# 知识储备

1. C/C++

# 启动过程:

这里使用源码中`./example`的 glfw 的嵌入式方案.追溯到`./shell/platform/embedder`内部的 Cpp 代码.

本方案是为了 flutter 嵌入其他平台给出的 demo,使用 OpenGL 的 glfw.理论上支持 glfw 的设备都可以启动.

这里我们关注 flutter 的启动流程.

1. 初始化glfw，提供平台窗口本身，激活OpenGL或者其他计算机图形库窗口
2. 初始化Flutter
    * Flutter Engine 外侧观察为“shell”，负责平台接口对接，
    * 内测观察为“engine”，完成自身内部逻辑
    1. 配置 FlutterRendererConfig
    2. alloc FlutterEngine内存保存Flutter
    3. FlutterEngineRun()启动整个Flutter
3. FlutterEngineRun 内部优先初始化engine，然后再执行engine
    1. engine内部有settings，各种callback、参数附加后，传递给engine init
    2. 生成平台、UI对应的各种callback，view，传递给engine init
    3. 检查shell是否正确生成，dart的isolate启动，完成engine启动。


```cpp
// engine\src\flutter\examples\glfw\FlutterEmbedderGLFW.cc
// main 函数再此 其内部完成glfw的初始化，主要是执行了RunFLutter激活了（shell、engine）
int main(int argc, const char* argv[]) {
    // ...
    bool runResult = RunFlutter(window, project_path, icudtl_path);
    // ...
}
// 入口
bool RunFlutter(GLFWwindow* window, const std::string& project_path, const std::string& icudtl_path){
    // 初始化F的config，配置OpenGL，指定assets路径等，allocated engine对象
    // ...
    FlutterEngine engine = nullptr;
    FlutterEngineResult result = FlutterEngineRun(FLUTTER_ENGINE_VERSION, &config,  // renderer
                                                &args, window, &engine);
    // 注册其他glfw事件给shell
    return true;
}
// engine\src\flutter\shell\platform\embedder\embedder.cc
// 启动Flutter Engine， engine_out作为传递引用，承接整个engine对象
FlutterEngineResult FlutterEngineRun（/* 各种参数 */, engine_out）{
    FlutterEngineInitialize(/* 各种参数 */, engine_out);//初始化负责实例engine，
    return FlutterEngineRunInitialized(*engine_out) //初始化后再运行engine
}

// engine\src\flutter\shell\platform\embedder\embedder.cc
// 初始化engine
FlutterEngineResult FlutterEngineInitialize(/* 各种参数 */) {
    /* ... 配置与error处理 */
    PopulateSnapshotMappingCallbacks(args, settings); // 注册,对dart的dill镜像格式的内存填充回调
    /* ... icudlt.dat 文件路径 assets路径,vm内存,老年代配置 */
    // 预编译模式下,配置"kernel_blob.bin"
    if (!flutter::DartVM::IsRunningPrecompiledCode()) {/*...*/}
    // 对settings配置观察者add、remove的调用方法
    settings.task_observer_add = [](key, callback){};
    settings.task_observer_remove = [](key){};
    // 判断args里是否添加了 root isolated的创建监听，附加到settings中
    if (SAFE_ACCESS(args, root_isolate_create_callback, nullptr) != nullptr){
        settings.root_isolate_create_callback = [callback, user_data]() {callback(user_data);};
    }
    /* ... */
    /* ... */
    /* ... */
    // new出多个callback，给platform_dispatch_table 消息分发表使用，
    flutter::PlatformViewEmbedder::PlatformDispatchTable platform_dispatch_table =
    {
        update_semantics_nodes_callback,            // 更新语义节点回调
        update_semantics_custom_actions_callback,   // 更新语义自定义操作回调
        platform_message_response_callback,         // 平台消息响应回调
        vsync_callback,                             // vsync回调
        compute_platform_resolved_locale_callback,  // 计算平台的回调，应该指的dart、flutter本身的cb，是必填参数
    };
    /* ... */
    /* ... */
    /* ... */
    // new出多个callback，给engine使用，生成engine本体，之前的各种settings在此附加给engine实体
    // 只new engine，不启动root isolate
    auto embedder_engine = std::make_unique<flutter::EmbedderEngine>(
        std::move(thread_host),        // 主线程
        std::move(task_runners),       // 
        std::move(settings),           //
        std::move(run_configuration),  //
        on_create_platform_view,       // 当对应平台view创建回调
        on_create_rasterizer,          // 当光栅时回调
        external_texture_callback      // 
    );

    // 对引用参数engine赋值
    // *engine_out = embedder_engine
    return 成功;
}
// 初始化后，启动engine过程
FlutterEngineResult FlutterEngineRunInitialized（engine）{
    // Shell 是来自 engine\src\flutter\shell\common\shell.h
    // 的通用接口层，用于engine对接不同平台代码使用。
    if (embedder_engine->IsValid()) {} // shell 是否合法
    if (embedder_engine->LaunchShell()) {}  // 启动shell层
    if (embedder_engine->NotifyCreated()) {} // 通知外部创建完毕
    if (embedder_engine->RunRootIsolate()) {} // 开启内部isolate
}
// 注册,对dart的dill镜像格式的内存填充回调
void PopulateSnapshotMappingCallbacks(const FlutterProjectArgs* args,
                                    flutter::Settings& settings) {
    // 生成回调函数的回调函数,
    // 1. 执行后返回 接受 snapshot内存指针,跟长度的回调方法
    // 2. 回调后,得到fml::NonOwnedMapping的指针.从而得到"dart程序内存对象"
    auto make_mapping_callback = [](const uint8_t* mapping, size_t size) {
        return [mapping, size]() {
            return std::make_unique<fml::NonOwnedMapping>(mapping, size);
        };
    };
    // ... 
    //配置与error处理
    // ...

    // settings中包含了获取"dart程序内存对象"的方法
    settings.dart_library_sources_kernel =
    make_mapping_callback(kPlatformStrongDill, kPlatformStrongDillSize);
}
```



```cpp
// settings
// ...
  // snapshot 文件地址或内存地址
  std::string vm_snapshot_data_path;  
  MappingCallback vm_snapshot_data;
  std::string vm_snapshot_instr_path;  
  MappingCallback vm_snapshot_instr;
 
  std::string isolate_snapshot_data_path;  
  MappingCallback isolate_snapshot_data;
  std::string isolate_snapshot_instr_path;  
  MappingCallback isolate_snapshot_instr;
 
  // library 模式下的lib文件路径
  std::string application_library_path;
  // icudlt.dat 文件路径
  std::string icu_data_path;
  // flutter_assets 资源文件夹路径
  std::string assets_path;
  // 
```