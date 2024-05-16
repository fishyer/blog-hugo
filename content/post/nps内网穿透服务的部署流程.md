---
title: nps内网穿透服务的部署流程
aliases: []
date: 2024-05-15T13:48:46+08:00
lastmod: 2024-05-15T18:34:06+08:00
id: ab6fa852-1d4c-41eb-94d1-e6ba6e31ed2a
slug: ab6fa852-1d4c-41eb-94d1-e6ba6e31ed2a
obsidianLink: obsidian://advanced-uri?vault=note&uid=ab6fa852-1d4c-41eb-94d1-e6ba6e31ed2a
hugoLink: https://blog.fishyer.com/post/ab6fa852-1d4c-41eb-94d1-e6ba6e31ed2a/
tags: []
---

之前做内网穿透，都是用frp，后来发现nps更方便一点，因为它有Web管理界面。之前用过几次，但是过一阵子再要用的时候，老是忘记怎么用的了，所以记录一下。

## 部署服务端

github仓库:[ehang-io/nps](https://github.com/ehang-io/nps )
docker镜像: [ffdfgdfg/nps](https://hub.docker.com/r/ffdfgdfg/nps )

1.下载docker镜像: `docker pull ffdfgdfg/nps`

2.下载配置文件夹：[conf](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/ehang-io/nps/tree/master/conf)文件夹

3.修改配置文件./conf/nps.conf,主要就是改代理端口，不然容易和其他服务冲突。其它的都不变
```
http_proxy_port=80
https_proxy_port=443
```
比如我是改成了
```
http_proxy_port=12080
https_proxy_port=12443
```

4.启动docker容器，主要就是挂载配置文件夹，指定端口映射
```shell
docker run -d --name=nps --restart=always --net=host -v /opt/nps/conf:/conf ffdfgdfg/nps
```

5.访问nps的Web管理页面,默认端口是8080，记得开放防火墙端口。
- http://server_ip:8080/nps
- 默认用户名密码是: admin/123


## 部署客户端

[Releases · ehang-io/nps](https://github.com/ehang-io/nps/releases )

1.在Release页面下载对应平台的客户端并解压执行安装命令: `./npc install`

2.在Web管理页面添加一个客户端，记住唯一验证密钥

3.进入解压后的客户端文件夹，本地启动客户端
```shell
nohup npc -server=server_ip:bridge_port -vkey=[客户端唯一验证秘钥] &
```
这里的bridge_port是服务端的桥接端口，记得打开防火墙，默认是8024。它并不是本地想要映射的端口。

4.在Web管理页面查看客户端的在线状态，如果是在线状态，说明客户端已经连接成功。
![image.png](https://yupic.oss-cn-shanghai.aliyuncs.com/20240515143214.png)

5.在Web管理页面去添加隧道，一般来说，用tcp隧道就足够了，可以支持http/https/socks5/ftp/ssh等协议。
![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405151417777.png)

## 结语

最近发现了一个很好用的开源的基于k8s的容器托管平台：Sealos，比起Vercel之类的托管服务，它是直接托管Docker镜像。堪称是云端操作系统，可以把docker镜像当做一个个手机App来安装。它完全为我们屏蔽掉了容器编排的问题，让我们可以专注于业务开发，而不用担心服务器的管理。以后做什么mysql集群、redis集群、mongodb集群，只需要把镜像上传到Sealos，然后就可以直接部署，不需要考虑服务器的扩容问题。至于容器的实例，完全可以自动伸缩，Sealos会自动管理。

本来呢，我是打算在Sealos上部署nps的，但是发现Sealos有一个问题：不支持`--net=host`模式，只能一个个的添加端口映射，这对于一个内网穿透服务来说实在是太不方便了，所以我还是用的自己的宝塔服务器来部署nps容器。

感谢docker，感谢k8s，感谢开源社区，让编程变得更简单。