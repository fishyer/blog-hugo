---
title: python-函数式编程之纯数据类
aliases: []
date: 2024-05-14T16:25:30+08:00
lastmod: 2024-05-14T17:02:49+08:00
id: e5a92298-4d68-4912-ae8b-10640acc57f3
slug: e5a92298-4d68-4912-ae8b-10640acc57f3
obsidianLink: obsidian://advanced-uri?vault=note&uid=e5a92298-4d68-4912-ae8b-10640acc57f3
hugoLink: https://blog.fishyer.com/post/e5a92298-4d68-4912-ae8b-10640acc57f3/
tags: []
---

看到一个观点：用纯函数+纯数据类可以很大程度上代替掉面向对象，不用创建复杂的class类。

比如一个面向对象的写法：clazz.run(args)完全可以替换成run(clazz,args)的写法，让所有的函数都是一等公民，不必依赖于类而存在。

而run方法还可以做为变量去做另外一个函数的入参或者出参，比如：invoke_run(run,data)，这样可以极大的增加程序的灵活性，而不必定义可能只会被继承一次的接口类:RunInterface。

这是类方法被代替的案例，那么对象方法怎么被代替呢。对象方法里面经常会依赖了对象参数。这个时候，就可以用到纯数据类了。

比如一个User对象，有login方法，依赖了username和password两个参数。之前用python写面向对象的时候，感觉有点冗余:

```python
class User:
    def __init__(self, username, password):
        self.username = username
        self.password = password

    def login(self, username, password):
        if username == self.username and password == self.password:
            print("登录成功！")
            return True
        else:
            print("用户名或密码错误。")
            return False


# 示例
if __name__ == "__main__":
    user = User("example_user", "example_password")
    user.login("example_user", "example_password")  # 应该打印出 "登录成功！"
    user.login("wrong_user", "example_password")  # 应该打印出 "用户名或密码错误。"

```

而改成函数式编程写法，可以这样,将login函数和User数据类独立：
```python
from dataclasses import dataclass


@dataclass
class User:
    username: str
    password: str


def login(self: User, username, password):
    if username == self.username and password == self.password:
        print("登录成功！")
        return True
    else:
        print("用户名或密码错误。")
        return False
```

之前不是有句话嘛，程序=数据结构+算法。那么，在函数式编程里，程序=纯数据类+纯函数。尽量让函数只依赖于它的入参，不依赖于其它的全局变量。如果确实要依赖全局变量呢？那就再加一个函数入参GlobalVariable数据类:
```python
@dataclass
class GlobalVariable:
    key1: str
    key2: str
    key3: str


def login(gv: GlobalVariable, self: User, username, password):
    if username == self.username and password == self.password:
        print("登录成功！")
        return True
    else:
        print("用户名或密码错误。")
        return False

def main():
    print(__file__)
    gv = GlobalVariable("value1", "value2", "value3")
    user = User("example_user", "example_password")
    login(gv, user, "example_user", "example_password")  # 应该打印出 "登录成功！"
    login(gv, user, "wrong_user", "example_password")  # 应该打印出 "用户名或密码错误。"


if __name__ == "__main__":
    main()

```

纯函数的好处就是：极大的提高了可测试性。

上面的@dataclass的python 3.7以后引用的一个系统库，可以自动添加`__init__`、`__repr__`、`__eq__`等，减少了样板代码，使类更加简洁。

简洁的好处就是：代码量越少，出bug的可能性越小。

