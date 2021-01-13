# 激活web端
* 目前web平台支持处于bate分支。需要把sdk切到bate channel。
* 另外插件库支持很少。
    * 想借力js，基本要靠自己实现
    * 组织项目不够模块化，需要对web文件夹（web端）内的html加script等标签。

# flutter内部使用js
首先，需要了解的是dart对js输出是如何实现的。目前是dart需要编译（转换更为合适）成js输出整个vm环境，

所以，flutter的主项目其实是一个相对隔离的环境，哪怕它输出到了浏览器内部。

> 不要在主项目内使用 dart:html dart:js库
>
> 这里我走了一些弯路，主项目内直接使用了dart:html dart:js的库，这两个库也警告了，不要在非flutter插件环境下使用他们。但我这边觉得理论上可以直接调用web的。当我切换输出平台编译的时候就出现了问题，原生对这些库是不支持的。即便是使用了kIsWeb判断加接口方式实现。
> 因为dart编译的时候，需要将整体代码加载到vm，所以mobile平台下，是不认html，js这些库的。

# 关于模块化开发
从目前来看，web开发，哪怕flutter输出在浏览器内部，环境也是从隔离角度出发的。模块化开发的话依然需要MessageChannel这样的方式实现。

目前flutter支持的项目类型中以module方式组织项目，web平台是不支持的。只能以plugin方式组织

>（module方式是平台项目为主体，集成flutter；plugin是flutter为主体）

# Links
https://flutter.dev/docs/development/platform-integration/web