---
date: 2024-05-02
lastmod: 2024-05-12T10:24:53+08:00
title: git-更新忽略文件
id: 150d2523-82e2-48b4-af49-db9c857cf9d8
aliases: []
slug: 150d2523-82e2-48b4-af49-db9c857cf9d8
obsidianLink: obsidian://advanced-uri?vault=note&uid=150d2523-82e2-48b4-af49-db9c857cf9d8
hugoLink: https://blog.fishyer.com/post/150d2523-82e2-48b4-af49-db9c857cf9d8/
tags:
  - git
  - 配置
  - 测试
zhihu-tags:
  - git
  - 配置
  - 测试
---

## 直接重建git暂存区
```shell
git rm -r --cached .
git add .
git commit -m 'update .gitignore'
```

## 移除指定文件
```shell
git rm --cached redis/dump.rdb
```

#git #配置 #测试


111