---
date: 2024-05-02
lastmod: 2024-05-09
draft: false
title: "git-更新忽略文件"
tags: ["配置", "git"]
author: "fishyer"
timezone: UTC+8
---
```shell
git rm -r --cached .
git add .
git commit -m 'update .gitignore'
```