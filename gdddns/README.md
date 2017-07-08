# ttsoft-gdddns

## 简介 

> 这是一个适用于 Tomato 固件(koolshare) 的 Godaddy DDNS 插件，开发参考了 [aliddns](https://github.com/kyriosli/koolshare-aliddns) ，并完善了一些安装卸载脚本

## 插件使用

- 首先自己的域名需要托管在 Godaddy
- 在 [Godaddy Developer](https://developer.godaddy.com/keys/) 网站上生成用于调用 Godaddy API 的 Key 和 Secret
- 安装本插件，填入对应 Key 和 Secret，并设置解析域名等相关参数即可

## 开发规范


### 本插件目录结构规范

本插件目录结构如下

``` sh
├── LICENSE                         授权声明
├── README.md                       说明文档
├── backup.sh                       备份脚本
├── build.py                        打包脚本
├── config.json.js                  版本信息 json 文件
├── gdddns                          插件主目录(目录名最好和文件名等一致，这是一种默认的约定，暂不确定乱写会不会有问题)
│   ├── bin                         二进制执行文件目录
│   │   └── gdddns_curl             自编译的 curl(默认 koolshare 的 tomato curl 不支持 https)
│   ├── install.sh                  安装脚本(默认离线安装会执行此脚本，这里面主要是向 DBUS 注册当前插件状态以及复制文件等)
│   ├── res
│   │   ├── icon-gdddns-bg.png      软件中心背景图片
│   │   └── icon-gdddns.png         logo
│   ├── scripts                     插件执行脚本
│   │   ├── gdddns_config.sh        插件配置脚本
│   │   ├── gdddns_update.sh        本插件主要 DNS 更新脚本
│   │   └── uninstall_gdddns.sh     卸载脚本(点击卸载时删除一些插件释放的文件)
│   └── webs
│       └── Module_gdddns.asp       插件主要 UI 界面
├── gdddns.tar.gz
└── history                         插件历史版本
    ├── 1.0.0
    │   └── gdddns.tar.gz
    └── version
```

**约定优于配置: 默认的安装卸载脚本文件名(install.sh、uninstall_xxxx.sh) 请不要乱更改，否则可能不会执行；尤其是插件的文件名约定，
最好参考已有插件命名，不要乱造；否则这些脚本可能不会被执行，点击卸载时也只是做了 DBUS 反注册信息而已，实际文件并未被删除**



### 插件更新推送机制
- 插件git地址需要先被 [modules.json](https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/softcenter/modules.json) 收录
- 插件作者提交插件相关更新后，更改config.json.js内的版本号
- 插件作者运行 python build.py，会自动生成插件安装包，插件备份
- koolshare插件中心服务器会每隔5分钟检查一次该项目config.json.js内的版本号，如果有更新，则会拉取一份到中转服务
- 同时会将config.json.js的内容插入[app.json.js](https://koolshare.ngrok.wang/softcenter/app.json.js)
- 用户访问软件中心请求[app.json.js](https://koolshare.ngrok.wang/softcenter/app.json.js)，即可知道插件的状态


















