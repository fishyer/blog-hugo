---
title: python-极简日志工具类
aliases: []
date: 2024-05-14T00:06:11+08:00
lastmod: 2024-05-14T01:53:06+08:00
id: 8510cb4a-9c19-4ec6-ad1e-67f8c6616af5
slug: 8510cb4a-9c19-4ec6-ad1e-67f8c6616af5
obsidianLink: obsidian://advanced-uri?vault=note&uid=8510cb4a-9c19-4ec6-ad1e-67f8c6616af5
hugoLink: https://blog.fishyer.com/post/8510cb4a-9c19-4ec6-ad1e-67f8c6616af5/
tags:
  - python
  - 工具类
---

#python #工具类 

用过不少的日志工具类，要么太重了，要么就是不太灵活，不方便自己定制化，感觉不如直接自己动手写算了。

## 介绍

只用系统库封装的极简日志工具类，实现功能：
1. 支持输出到控制台、文件
2. 日志格式包含：时间-级别-模块-文件行号-函数名-消息，方便点击直接跳转
3. 支持着色：DEBUG-蓝色 INFO-绿色 WARN-黄色 ERROR-红色

后期计划：
1. 通过网络写入MongoDB数据库
2. 按日期拆分日志文件

## 源码

```python
import time
import sys
import os
import inspect

def get_caller_frame(parent_level=0):
    frame = inspect.currentframe()
    for _ in range(parent_level + 2):
        frame = frame.f_back
    return frame

# 日志控制器
class FishLogger:

    def __init__(self,tag="FishLogger",path=None):
        if path is None:
            path=__file__
        if tag is None:
            tag=os.path.basename(path)
        log_path=f"{os.path.dirname(path)}/log/{os.path.basename(path)}.log"
        if not os.path.exists(os.path.dirname(log_path)):
            os.makedirs(os.path.dirname(log_path),exist_ok=True)
        self.tag = tag
        self.terminal = sys.stdout
        self.log_fd = open(log_path, "a+", encoding='utf-8')
        # 输出执行的时间
        # run_time = time.strftime('run_time: %Y-%m-%d %H:%M:%S', time.localtime(time.time()))
        divider_msg="###################################################"
        self.warning(divider_msg)
        self.debug(f"path: {path}")
        self.debug(f"log_path: {log_path}")
        self.debug(f"tag: {tag}")

    def debug(self, msg):
        self.record("DEBUG", msg)

    def info(self, msg):
        self.record("INFO", msg)

    def warning(self, msg):
        self.record("WARN", msg)

    def error(self, msg):
        self.record("ERROR", msg)

    def msg_wrapper(self, level, msg,caller_level=2):
        timestamp = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
        level_padded = level.ljust(5)  # 使用 ljust 方法填充字符串，使得长度为 5
        caller_frame = get_caller_frame(caller_level)
        file_name = caller_frame.f_code.co_filename
        line_number = caller_frame.f_lineno
        func_name = caller_frame.f_code.co_name
        base_name = os.path.basename(file_name)
        new_msg=f"[{timestamp}] [{level_padded}] [{self.tag}] {base_name}:{line_number} {func_name}() - {msg}"
        return new_msg
    
    # 日志级别到颜色的映射字典
    level_colors = {
        'DEBUG': 'blue',
        'INFO': 'green',
        'WARN': 'yellow',
        'ERROR': 'red'
    }

    # 添加 ANSI 转义码来着色日志消息
    def colorize(self, msg, color):
        colors = {
            'red': '\033[91m',
            'green': '\033[92m',
            'yellow': '\033[93m',
            'blue': '\033[94m',
            'magenta': '\033[95m',
            'cyan': '\033[96m',
            'white': '\033[97m',
            'reset': '\033[0m'
        }
        return f"{colors[color]}{msg}{colors['reset']}"

    def print(self,msg):
        if self.terminal is not None:
            self.terminal.write(msg + "\n")
            self.terminal.flush()
    
    def write(self,msg):
        self.log_fd.write(msg + "\n")
        self.log_fd.flush()

    def record(self,level,msg,caller_level=2):
        msg=self.msg_wrapper(level,msg,caller_level)
        color = self.level_colors.get(level, 'white')
        self.print(self.colorize(msg, color))
        self.write(msg)



def test():
    print(__file__)
    logger=FishLogger()
    logger.debug("debug")
    logger.info("info")
    logger.warning("warning")
    logger.error("error")
    logger.print("print") # 只输出到控制台
    logger.write("write") # 只输出到文件
    logger.record("record","record",caller_level=1) #同时输出到控制台和文件


if __name__ == "__main__":
    test()
```

这里的主方法用test取名，是为了方便用pytest自动执行它，防止重构时不小心改了什么导致工具类无法正常运行。

最近研究了一下pytest+allure生成可视化的网页测试报告，感觉真的太方便了，明天梳理一下这个。

以前写了很多工具类，结果时间一久，项目一多，就都搞混了，忘记哪个工具类在哪个库里面了，最近得好好梳理一下，封装成一个个人工具库，以供各个项目都能依赖使用。

