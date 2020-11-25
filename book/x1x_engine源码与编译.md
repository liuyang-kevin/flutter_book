# 系统与环境
1. 工具问题
2. 系统问题
## 工具
flutter使用了chromium的开发工具集组织项目,所以需要配置depot_tools工具

> depot_tools是个工具包，里面包含gclient、gn和ninja等工具。
> 是Google为解决Chromium源码管理问题为Chromium提供的源代码管理的一个工具。
> Flutter源码同步也需要依赖depot_tools工具。

```bash
# clone depot_tools源码
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
# 然后将depot_tools加入环境变量
export PATH="$PATH:/path/to/depot_tools"
```
## 系统
根据官方文档,
* Linux 可以输出Linux与Android产物
* Mac 可以输出ios,android,mac产物
* win 下,也就输出自己, Windows不支持Android或iOS的交叉编译工件。(也就看看源码)
## 源码
使用一个新建文件夹,最好使用"engine",说是内部使用了这个路径.

进入engine文件夹,内部新建文件".gclient"输入
```txt
solutions = [
  {
    "managed": False,
    "name": "src/flutter",
    "url": "git@github.com:liuyang-kevin/engine.git@2c956a31c0a3d350827aee6c56bb63337c5b4e6e",
    "custom_deps": {},
    "deps_file": "DEPS",
    "safesync_url": "",
  },
]
```
url的位置可以是官方仓库,如果需要自己修改提交,最好fork一个仓库,然后@后面的hash,可以指定git的提交版本.

> 这里有个坑,如果py提示非法key,可能是源码中的DEPS文件依赖有bug,所以我这改了个stable的hash拉取

然后使用 `gclient sync -v` 同步代码, -v是显示log

> win下代码拉不下来, 还需要额外配置一下工具链,否则一直提示登录Google仓库,输入用户名密码.然后失败
```bash
#  win下需要导入这些变量,因为交叉编译工具无效,所以需要指定工具
# 而win下又分cmd,powershell跟兼容bash,我这里用的bash所以是export,cmd是set
export GYP_MSVS_VERSION=2019
export DEPOT_TOOLS_WIN_TOOLCHAIN=0
export GYP_MSVS_OVERRIDE_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community"
```


# 代码提示与编译

# Link
https://fucknmb.com/2019/02/26/Flutter-Engine-%E7%BC%96%E8%AF%91%E6%8C%87%E5%8C%97/

https://chromium.googlesource.com/external/github.com/flutter/engine/+/refs/heads/master/CONTRIBUTING.md

https://github.com/flutter/flutter/wiki/Setting-up-the-Engine-development-environment