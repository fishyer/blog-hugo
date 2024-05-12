---
date: 2024-05-02
lastmod: 2024-05-12T08:35:24+08:00
title: git-更新忽略文件
tags:
  - 配置
  - git
id: 150d2523-82e2-48b4-af49-db9c857cf9d8
aliases: []
slug: 150d2523-82e2-48b4-af49-db9c857cf9d8
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