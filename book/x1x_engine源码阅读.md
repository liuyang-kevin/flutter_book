# 知识储备

1. C/C++

# 启动过程:

这里使用源码中`./example`的 glfw 的嵌入式方案.追溯到`./shell/platform/embedder`内部的 Cpp 代码.

本方案是为了 flutter 嵌入其他平台给出的 demo,使用 OpenGL 的 glfw.理论上支持 glfw 的设备都可以启动.

这里我们关注 flutter 的启动流程.

```cpp
// engine\src\flutter\examples\glfw\FlutterEmbedderGLFW.cc

// engine\src\flutter\shell\platform\embedder\embedder.cc
// 初始化engine
FlutterEngineResult FlutterEngineInitialize(/* 各种参数 */) {
    /* ... 配置与error处理 */
    PopulateSnapshotMappingCallbacks(args, settings); // 注册,对dart的dill镜像格式的内存填充回调
    /* ... icudlt.dat 文件路径 assets路径,vm内存,老年代配置 */
    // 预编译模式
    if (!flutter::DartVM::IsRunningPrecompiledCode()) {/*...*/}
    

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