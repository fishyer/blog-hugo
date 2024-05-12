---
title: Obsidian插件-自动添加元数据
date: 2024-05-11T12:16:47+08:00
updated_at: 2024-05-12T09:52:51+08:00
id: 7826b334-1950-4289-84a5-3fa6ac29b81c
slug: 7826b334-1950-4289-84a5-3fa6ac29b81c
aliases: []
tags:
  - Obsidian
  - Markdown
zhihu-tags:
  - Obsidian
  - Markdown
---

#Obsidian #Markdown 


## 开发目的

尝试了各种博客平台以后，感觉它们的限制还是蛮多的，不方便各种自定义设置，最终决定还是得搞一个自己的博客站点。以前用Notion搞过，但是现在Notion用的少了，反而是Obsidian用得多，本地的工具还是方便点。最后选择的博客站点生成工具是Hugo，主要是生成的快。

在用Hugo发布Obsidian的Markdown文件时，需要有一些frontmatter属性，例如这样的：
```
lastmod: 2024-05-11T12:17:17+08:00
date: 2024-05-11T12:16:47+08:00
id: f50ee79a-23fd-4db4-bfa1-4d7c0900fd85
title: Obsidian插件-自动添加元数据
tags: []
```
自己手动添加这些属性太麻烦了，就让插件来帮我自动生成吧，每次修改时，都会自动更新属性值（没有就新建，有就更新），其实更新操作主要是更新最后修改时间和标签。


## 配置项

- 更新时间：lastmod (最好别改，不然hugo可能识别有问题)
- 创建时间：date (最好别改，不然hugo可能识别有问题)
- uuid名称：id 这个是方便配合Advanced-URI插件使用,改成id是为了和Omnivore插件保持一致
- 时间格式：YYYY-MM-DDTHH:mm:ss+08:00（最好别改，不然hugo可能识别有问题）
- 其它的配置我没动过，都是[obsidian-frontmatter-modified-date](https://github.com/alangrainger/obsidian-frontmatter-modified-date )插件上原有的

![image.png](https://yupic.oss-cn-shanghai.aliyuncs.com/20240511122458.png)

## 仿TabCopy的小功能

我在这个插件里面还添加一个小功能（Tab-Copy for Advanced URL）：可以像TabCopy一样，通过命令一键生成类似：`[title](url)`这种格式的链接，不过它的链接是用的Adcanced-URI插件的，最后生成的效果如下：`[Obsidian插件-自动添加元数据](obsidian://advanced-uri?vault=note&uid=1c701082-2351-4aed-8081-ff3b55e3ac25 )`

强烈建议将这个命令通过Commander插件添加在页面首部，这样在其它地方引用就方便多了。比如我就经常把Obsidian的笔记链接粘贴到WorkFlowy中。


## 如何使用

下载源码，将dist文件夹的内容移动到.obsidian/plugins文件夹即可，可以将dist文件夹改一下名：auto-frontmatter

我是用的Hugo，所以才这样配置，如果你是用的其它静态站点生成器，比如：jekyll/hexo/gatsby等，可能需要调整一下配置项。如果这些配置无法满足你的需求，可以自己修改源码。或者通过邮件联系我，我来拓展一下这个插件的功能。未来的计划是让这插件可以通过模板来自定义配置项，这样就可以更灵活地使用。


## 源码

1. [fishyer/auto-frontmatter](https://github.com/fishyer/auto-frontmatter )
2. [fishyer/blog-hugo](https://github.com/fishyer/blog-hugo )

