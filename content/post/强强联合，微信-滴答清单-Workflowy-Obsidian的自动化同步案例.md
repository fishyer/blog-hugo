---
title: 强强联合，微信-滴答清单-Workflowy-Obsidian的自动化同步案例
aliases: []
date: 2024-05-21T18:09:59+08:00
lastmod: 2024-05-21T21:18:09+08:00
id: f80d5840-d6c6-4444-af19-83d9d828a447
slug: f80d5840-d6c6-4444-af19-83d9d828a447
obsidianLink: obsidian://advanced-uri?vault=MyNote&uid=f80d5840-d6c6-4444-af19-83d9d828a447
hugoLink: https://blog.fishyer.com/post/f80d5840-d6c6-4444-af19-83d9d828a447/
tags: []
---

## 发给滴答清单的微信机器人消息

![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405211953247.png)

## 对应的滴答清单的任务清单

![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405211954243.png)

## 自动生成的WorkFlowy节点

![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405211949456.png)

## 自动生成的Obsidian目录

![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405211950225.png)

## 自动生成的Obsidian文件

![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405211951646.png)

## 启动本自动同步服务需要的配置项

### 1-滴答清单

1.登录[滴答清单网页版](https://dida365.com/webapp)
2.允许[OAtuth授权: dida-sync](https://dida365.com/oauth/authorize?scope=tasks:write%20tasks:read&client_id=13TIYIw0ik1FxqLREs&state=Ups0YwpHwWF1yoct&redirect_uri=https://fastapi.fishyer.com/dida/redirect_uri&response_type=code)

![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405211959727.png)

点击允许以后，可以获取一个类似的json数据，保存下来
```
{
  "state": "Ups0YwpHwWF1XXXX",
  "code": "XXXXXX"
}
```
### 2-WorkFlowy

登录WorkFlowy网页端，通过Application-Cookies-sessionid获取到一个32位的字符串，类似：bza32axq7bbzt9w5XXXXXXXXYYYYYYYY，保存下来
![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405212006101.png)

### 3-Obsidian

obsidian没有网页版，如果要实现在线自动同步的话，有2种方案：

1-借助与插件Local REST API和内网穿透工具SakuraLauncher
![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405212010574.png)
![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405212011415.png)

1.检查本地的[Local REST API服务](https://127.0.0.1:27124/)是否正常
2.注册一个[SakuraFrp](https://www.natfrp.com/tunnel/download )账号，下载客户端，然后创建一个内网穿透隧道，填好下面4项：
![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405212113812.png)
然后在日志里面可以看到自动创建的IP和端口，例如：202.189.5.24:42791
![](https://yupic.oss-cn-shanghai.aliyuncs.com/202405212114936.png)

## 4-在fastapi.fishyer.com网站填写以上配置项，启动同步即可【待完成】

自动同步服务网站正在建设中，敬请期待：https://fastapi.fishyer.com

如果你觉得对你有用的话，不妨点个赞👍🏻吧 ，你的支持也是我创建服务的最好动力。

## 参考资料

1. [Local Rest API for Obsidian: Interactive API Documentation](https://coddingtonbear.github.io/obsidian-local-rest-api )