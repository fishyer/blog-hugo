---
lastmod: 2024-05-11T12:30:42+08:00
date: 2024-05-11T12:16:47+08:00
id: f50ee79a-23fd-4db4-bfa1-4d7c0900fd85
title: Obsidian插件-自动添加元数据
tags: []
---

## 开发目的

被知乎和微信夹了几篇博文以后，感觉还是得搞一个自己的博客站点，以前用Notion搞的，但是现在Notion用的少了，反而是Obsidian用得多，本地的工具还是方便点。最后选择的博客站点生成工具是Hugo，主要是生成的快。

在用Hugo发布Obsidian的Markdown文件时，需要有一些frontmatter属性，例如这样的：
```
lastmod: 2024-05-11T12:17:17+08:00
date: 2024-05-11T12:16:47+08:00
id: f50ee79a-23fd-4db4-bfa1-4d7c0900fd85
title: Obsidian插件-自动添加元数据
tags: []
```
自己手动添加这些属性太麻烦了，就让插件来帮我自动生成吧，每次修改时，都会自动更新属性值（没有就新建，有就更新），其实更新操作主要是更新最后修改时间。

## 

## 配置项

- 更新时间：lastmod (最好别改，不然hugo可能识别有问题)
- 创建时间：date (最好别改，不然hugo可能识别有问题)
- uuid名称：id 这个是方便配合Advanced-URI插件使用,改成id是为了和Omnivore插件保持一致
- 时间格式：YYYY-MM-DDTHH:mm:ss+08:00（最好别改，不然hugo可能识别有问题）
- 其它的配置我没动过，都是[obsidian-frontmatter-modified-date](https://github.com/alangrainger/obsidian-frontmatter-modified-date )插件上原有的

![image.png](https://yupic.oss-cn-shanghai.aliyuncs.com/20240511122458.png)
## 如何使用

下载源码，将dist文件夹的内容移动到.obsidian/plugins文件夹即可，可以将dist文件夹改一下名：auto-frontmatter

## 源码

- [fishyer/auto-frontmatter](https://github.com/fishyer/auto-frontmatter )
- [fishyer/blog-hugo](https://github.com/fishyer/blog-hugo )

