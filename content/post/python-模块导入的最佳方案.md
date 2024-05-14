---
title: python-模块导入的最佳方案
aliases: []
date: 2024-05-14T14:56:59+08:00
lastmod: 2024-05-14T15:02:18+08:00
id: 9e840039-9d01-4eee-b2de-e97c754b9ec7
slug: 9e840039-9d01-4eee-b2de-e97c754b9ec7
obsidianLink: obsidian://advanced-uri?vault=note&uid=9e840039-9d01-4eee-b2de-e97c754b9ec7
hugoLink: https://blog.fishyer.com/post/9e840039-9d01-4eee-b2de-e97c754b9ec7/
tags:
  - python
  - 依赖管理
---

#python #依赖管理

## 配置全局工具库

比如现在我有一个工具库：/Users/yutianran/MyGithub/fish_util：
-  /Users/yutianran/MyGithub/fish_util
    -  test
        -  test_log_util.py
        -  test_allure.py
        -  __init__.py
        -  test_decorator_util.py
    -  src
        -  internal_var.py
        -  log_util.py
        -  __init__.py
        -  decorator_util.py
        -  content_format.py
        -  tree_util.py
        -  common_op.py
    -  __init__.py
    -  README.md
    -  .gitignore
    -  main.py
    -  start_pytest.sh

那么，./test/test_log_util.py中如何调用./src/log_util.py呢？

一般来说，可能是这3种方案：
1. 在test_log_util中加sys.path.append加路径
2. 在test_log_util中通过相对导入..src.log_util的方式来导包
3. 将/Users/yutianran/MyGithub/fish_util添加到PYTHONPATH的环境变量

但是这3种方案都有缺点：
1. 第1种要在每一个测试文件都加，太麻烦了
2. 第2种的话，运行main.py可以正常执行，直接运行test_log_util.py会报错：ImportError: attempted relative import with no known parent package
3.第3种呢，以后每一个python项目中这种同一项目中不同模块互相导入都得加入环境变量么？那环境变量得加多少呀。

综合考虑，我觉得最佳解决方案是这样的：
1. 将/Users/yutianran/MyGithub这个项目的父路径加入到PYTHONPATH的环境变量中
2. 在每个项目根路径下都加上__init__.py，以后无论是项目内部还是项目外部，都是通过`from fish_util.src import log_util`来引用，保持一致性

那如果有的项目不在/Users/yutianran/MyGithub这个路径下面呢？那就用软链接呗。通过软链接将/Users/yutianran/Documents/MyApp映射到到/Users/yutianran/MyGithub目录下：
```shell
ln -s /Users/yutianran/Documents/MyApp /Users/yutianran/MyGithub/MyApp
```
或者映射到/Users/yutianran/anaconda3/lib/python3.11/site-packages目录下也行

