# main函数启动dart/flutter
```text
WidgetsFlutterBinding这是一个单例模式，负责创建WidgetsFlutterBinding对象，
WidgetsFlutterBinding继承抽象类BindingBase，并且附带7个mixin，
对于mixin语法来说顺序是很重要，相同的方法会由后面的mixin覆盖前面的mixin方法，

BindingBase：抽象基类
  -> WidgetsBinding：绑定组件树
    -> RendererBinding：绑定渲染树
      -> SemanticsBinding：绑定语义树
        -> PaintingBinding：绑定绘制操作
          -> SchedulerBinding：绑定帧绘制回调函数，以及widget生命周期相关事件
            -> ServicesBinding：绑定平台服务消息，注册Dart层和C++层的消息传输服务；
              -> GestureBinding：绑定手势事件，用于检测应用的各种手势相关操作；
```
```dart
void main() async {
    // ensureInitialized 确保framework，ui框架加载完毕，这样初始化平台端的东西就不会crash
  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      // 首帧回调
  });
  runApp(App());
}
```
