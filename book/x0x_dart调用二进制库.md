dart 调用本地库主要来自ffi的支持,ffi库可以load本地dll,so,dylib等不同平台的二进制动态库.从而直接加载到dart中

# ffi

FFI(Foreign Function Interface)是用来与其它语言交互的接口，在有些语言里面称为语言绑定(language bindings)，Java 里面一般称为 JNI(Java Native Interface) 或 JNA(Java Native Access)。由于现实中很多程序是由不同编程语言写的，必然会涉及到跨语言调用，比如 A 语言写的函数如果想在 B 语言里面调用，这时一般有两种解决方案：

* 一种是将函数做成一个服务，通过进程间通信(IPC)或网络协议通信(RPC, RESTful等)；
* 另一种就是直接通过 FFI 调用。

前者需要至少两个独立的进程才能实现，而后者直接将其它语言的接口内嵌到本语言中，所以调用效率比前者高。

# 1. 集成ffi
yaml中添加依赖
  ffi: any
