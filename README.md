# flutter_book
深入flutter内部原理，侧重于widget以外的使用与理解。涉及canvas，flutter-engine，dartVM等知识点
# 文件夹作用
* lib    # 主项目，main方法，实现各种demo
* plugin # 由于本地库调用问题，只能插件内调用几个特殊dart包，比如html
* 
## 目录与[导览](book/)
1. flutter 体系结构
    * framework与engine
    * [flutter Web避坑指南](book/flutter_web_避坑.md)
2. dart与dartVM
3. Canvas
## 补全代码
flutter create --platforms windows .

# 代码

```dart
void main(){
    print(1111);
}
```


# 待阅读
* https://github.com/DingProg/FlutterPIP
* https://github.com/aaronpenne/generative_art