---
title: python-极简装饰器工具类
aliases: []
date: 2024-05-14T01:53:48+08:00
lastmod: 2024-05-14T02:01:56+08:00
id: f415170e-1284-46f2-86cc-fc67776935df
slug: f415170e-1284-46f2-86cc-fc67776935df
obsidianLink: obsidian://advanced-uri?vault=note&uid=f415170e-1284-46f2-86cc-fc67776935df
hugoLink: https://blog.fishyer.com/post/f415170e-1284-46f2-86cc-fc67776935df/
tags:
  - python
  - 工具类
---

#python #工具类

先放源码，介绍之后再补。哈哈，感觉自己要把blog当做gist来用了。


## 源码-工具类

```python
import time
import inspect
import traceback
import inspect
from functools import wraps
import log_util as log_util

logger = log_util.FishLogger(path=__file__ + ".log", tag="decorator_util")
print = logger.debug


def trace_time(func):
    def wrapper(*args, **kwargs):
        # start the timer
        start_time = time.time()
        # call the decorated function
        result = func(*args, **kwargs)
        # remeasure the time
        end_time = time.time()
        # compute the elapsed time and print it
        execution_time = end_time - start_time
        print(f"Execution time: {execution_time} seconds")
        # return the result of the decorated function execution
        return result

    # return reference to the wrapper function
    return wrapper


def trace_args(func):
    def wrapper(*args, **kwargs):
        # print the fucntion name and arguments
        caller_frame = inspect.currentframe().f_back
        file_name = caller_frame.f_code.co_filename
        line_number = caller_frame.f_lineno
        print(
            f"Calling {func.__name__} at {file_name}:{line_number} with args: {args} kwargs: {kwargs}"
        )
        # call the function
        result = func(*args, **kwargs)
        # print the results
        print(f"{func.__name__} returned: {result}")
        return result

    return wrapper


def trace_exception(func):
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as e:
            # Handle the exception
            exception_msg = traceback.format_exc()
            logger.error(f"An exception occurred: \n{exception_msg}")
            # Optionally, perform additional error handling or logging
            # Reraise the exception if needed

    return wrapper


def trace_validate(*validators):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            arg_names = list(inspect.signature(func).parameters.keys())
            # 将args和kwargs合并为一个列表，以便与validators一一对应
            all_args = list(args) + [
                kwargs.get(key)
                for key in func.__code__.co_varnames[
                    len(args) : func.__code__.co_argcount
                ]
            ]
            # 校验每个参数
            for name, validator, arg in zip(arg_names, validators, all_args):
                if not validator(arg):
                    # 获取validator的源代码
                    lambda_source = inspect.getsource(validator)
                    raise ValueError(
                        f"Invalid argument: {name}={arg}, expected: \n{lambda_source}"
                    )
            return func(*args, **kwargs)

        return wrapper

    return decorator


def trace_retry(max_attempts, delay=1):
    def decorator(func):
        def wrapper(*args, **kwargs):
            attempts = 0
            while attempts < max_attempts:
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    attempts += 1
                    print(f"Attempt {attempts} failed: {e}")
                    time.sleep(delay)
            print(f"Function failed after {max_attempts} attempts")

        return wrapper

    return decorator

```

## 源码-测试类

```python
from decorator_util import *
import allure

@trace_time
def train_model():
    print("Starting the model training function...")
    # simulate a function execution by pausing the program for 5 seconds
    # time.sleep(1)
    print("Model training completed!")

@trace_args
def add_numbers(x, y):
    return x + y

@trace_exception
def divide(x, y):
    if y == 0:
        raise ValueError("Cannot divide by zero")
    result = x / y
    return result

@trace_exception
@trace_validate(
    lambda x: x > 0,
    lambda message: isinstance(message, str),
    lambda level: level >= 0,
)
def divide_and_print(x, message, level=2):
    print(f"x: {x}")
    print(f"message: {message}")
    print(f"level: {level}")

@trace_retry(max_attempts=3, delay=2)
def fetch_data(url):
    print("Fetching the data..")
    # raise timeout error to simulate a server not responding..
    raise TimeoutError("Server is not responding.")

@allure.feature(__file__)
def test():
    print(__file__)
    train_model()
    add_numbers(7, y=5)
    train_model()
    divide(10, 0)
    divide_and_print(-1, "test", level=-3)
    fetch_data("https://example.com/data")  # retry 3 delay 1


if __name__ == "__main__":
    test()

```