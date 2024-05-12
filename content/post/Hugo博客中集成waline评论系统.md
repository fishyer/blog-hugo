---
title: Hugo博客中集成waline评论系统
aliases: []
date: 2024-05-12T20:11:04+08:00
lastmod: 2024-05-12T21:16:12+08:00
id: d9867c08-d7e0-4565-b742-ff9994c6d818
slug: d9867c08-d7e0-4565-b742-ff9994c6d818
obsidianLink: obsidian://advanced-uri?vault=note&uid=d9867c08-d7e0-4565-b742-ff9994c6d818
hugoLink: https://blog.fishyer.com/post/d9867c08-d7e0-4565-b742-ff9994c6d818/
tags: []
zhihu-tags: []
---

## 缘起

之前已经搞定了从Obsidian发布到快速自动发布到Hugo的流程，今天则是折腾了一下Hugo的评论系统。试验了一些基于GitHub issues的评论系统，但是感觉都太简陋了，而且不是每个读者都有Github账号的，它们都需要绑定Github账号才能评论，有点鸡肋。

综合考量后，选择的是[Valine](https://valine.js.org/ )这个无后端评论系统的，这个集成很简单，只需到[LeanCloud国内版](https://www.leancloud.cn/ )弄一个账号，创建一个应用就行，把参数AppID、AppKey、MasterKey在hugo.toml里面配置一下，就几乎完成了。

但是后来发现Valine在有人评论时是无法收到邮件提醒的，这就有点坑了。看它的文档，好像1.4.0以后就不支持了，而且Valine两年都没更新了。所以只好看看有没有其他方案。

幸好，找到了一个基于Valine升级的[Waline](https://waline.js.org/guide/get-started/ )，这个评论系统很新，最近的Github更新是4小时前的。

## 在Vercel里面配置Waline服务端的环境变量

一步一步按照它的文档来：
1. 注册[LeanCloud国际版账号](https://console.leancloud.app/apps )，
2. 创建一个应用，获得3个参数：AppID、AppKey、MasterKey
3. 通过Waline的模版一键发布到[Vercel](https://vercel.com),然后再填写几个环境变量，重新发布。

环境变量配置如下
```env
# LeanCloud国际版参数
LEAN_ID=XXXXXXXXX
LEAN_KEY=XXXXXXXXX
LEAN_MASTER_KEY=XXXXXXXXX

# 博客站点
SITE_URL=https://blog.fishyer.com
SITE_NAME=blog-hugo

# 邮件通知
SMTP_SERVICE=QQ
SMTP_SECURE=true
SMTP_HOST=smtp.qq.com
SMTP_PORT=465
SMTP_USER=630709658@qq.com
SMTP_PASS=XXXXXXXXX
AUTHOR_EMAIL=fishyer@foxmail.com
```

其实foxmail邮箱和qq邮箱是一个邮箱，我这里配置AUTHOR_EMAIL是为了方便测试，因为默认自己评论是不会给自己发邮件提醒的。

> 注意：不能在.env文件里面设置，得在Vercel管理页面设置，有点坑，我本来还想通过vercel-cli在本地配置环境变量的，结果不行了，浪费了一些时间

发布完成后，可以在Vercel绑定一下自己的评论系统的域名。我的Waline服务就是：https://waline.fishyer.com。然后注册一下管理员账号(第一个人用户就是管理员)，就可以在Waline的后台页面查看评论记录了: https://waline.fishyer.com/ui

![image.png](https://yupic.oss-cn-shanghai.aliyuncs.com/20240512203725.png)


> 注意：waline服务和你的博客站点是不同的域名，比如我的waline服务是waline.fishyer.com，博客站点是 blog.fishyer.com。环境变量里面的SITE_URL不要写错了，不然就不方便从后台评论列表那里直接点击链接跳转到自己的博客文章页面了。

收到的邮件示意图如下，这里我没有改通知模板，就是默认的，可以通过邮件通知直达文章页面，还是蛮方便的。
![image.png](https://yupic.oss-cn-shanghai.aliyuncs.com/20240512203838.png)

配合微信上的QQ邮箱提醒，嘿嘿，再也不怕漏过文章评论了。


## 在Hugo里面添加Waline客户端

在模版的themes/even/layouts/partials/comments.html文件里面，添加如下代码：
```html
<link
  rel="stylesheet"
  href="https://unpkg.com/@waline/client@v3/dist/waline.css"
  />
  <div id="waline"></div>
  <script type="module">
    import { init } from 'https://unpkg.com/@waline/client@v3/dist/waline.js';

    init({
      el: '#waline',
      reaction: true, // 开启快速反应 就是那几个表情按钮
      serverURL: 'https://waline.fishyer.com',
    });
  </script>

```

## 相关推荐

推荐大家去体验我开发的Obsidian插件：[fishyer/auto-frontmatter](https://github.com/fishyer/auto-frontmatter ),可以自动生成这些frontmatter属性，：
![image.png](https://yupic.oss-cn-shanghai.aliyuncs.com/20240512204210.png)
这里面的8个字段都是自动生成和更新的，每次修改了文档10s后就会按需自动更新，或者通过命令【Update FrontMatter】也可以快速更新。

- title、date、lastmod、slug这几个是hugo需要的字段
- aliases、tags是Obsidian库的字段，tags和zhihu-tags都是取的文档中的`#标签`，标签会自动更新，生成aliases则是方便自己加别名，因为自己老是把它和Logseq用的alias搞混
- id是决定slug、obsidianLink、hugoLink的，配合Advanced-URI插件的
- zhihu-tags是配合VSCode插件: [WPL/s - 知乎](https://marketplace.visualstudio.com/items?itemName=jks-liu.wpls )
- obsidianLink和hugoLink是我自定义的，可以在hugo文章显示的链接，方便快速从博客文章到Obsidian笔记
![image.png](https://yupic.oss-cn-shanghai.aliyuncs.com/20240512211546.png)

这个VSCode插件是基于[niudai/VSCode-Zhihu](https://github.com/niudai/VSCode-Zhihu ) 两次开发的，但是将原来必须在文章首行的`#! https://zhuanlan.zhihu.com/p/696649182`给改成了可以兼容Obsidian的frontmatter，它会使用zhihu-tags字段来发布为知乎的标签(前提是个人知乎上已经创建过这些标签)，知乎链接则是用zhihu-url字段来表示的。


## 结语

好了，Obsidian写作系统、Hugo博客系统和Waline评论系统的一整套工作流都搭建好了，后面就是享受记录、分享、交流的乐趣。

分享，不是为了显摆自己知道多少，而是为了寻找同道。谁是全知全能的？谁又没有知识漏洞？敢于暴露自己的无知，也是一种勇气。有的时候，读者的一句关键评论，可能就让困惑许久的自己茅塞顿开。

新的博客站点，新的写作旅程，期待未来能和大家多多交流，一起学习成长。