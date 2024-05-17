---
title: 自己在本机部署ChatGPT网站
aliases: []
date: 2024-05-17T18:54:31+08:00
lastmod: 2024-05-17T20:57:32+08:00
id: 2cb4f5ef-bb06-4e06-830b-adf0d65f147f
slug: 2cb4f5ef-bb06-4e06-830b-adf0d65f147f
obsidianLink: obsidian://advanced-uri?vault=MyNote&uid=2cb4f5ef-bb06-4e06-830b-adf0d65f147f
hugoLink: https://blog.fishyer.com/post/2cb4f5ef-bb06-4e06-830b-adf0d65f147f/
tags:
  - AI
  - DIY网站
  - Docker
---

#AI #DIY网站 #Docker

## 1-购买代理服务

这是我搜集到的2个ChatGPT-API的代理服务，都支持GPT4
- [OpenAI-SB](https://www.openai-sb.com/ )
- 🎉[EZ-API](https://api.ezchat.top/ )
- [API2D](https://api2d.com/ )

说下我的实际使用体验，SB第一家是我最先接触到的，用了半年，感觉还不错。不过价格比EZ要贵一点，EZ是我目前在用的，价格比较实惠，但是感觉有时候速度有点慢，可能是因为我一直用GPT4的原因吧。2D那家没用过。

EZ目前用了2个月，充值50人民币，剩余可用28人民币额度。1个月差不多10元左右，很便宜的使用GPT4的费用了。

虽然现在有很多别人部署好的AI聊天工具了，但是API这个东西，在自己想去体验一下一些开源项目时，还是刚需，比如[abi/screenshot-to-code](https://github.com/abi/screenshot-to-code )。

所以，买一个API，绝对不亏。本来我也想搞官方版本的API的，可惜的是没法绑定支付方式，用[NOBE](https://www.nobepay.com )的虚拟信用卡都不行，只好放弃。

## 2-如何使用API

这里有很多网站可以用API来部署聊天站点，比如:
- [ChatGPTNextWeb](https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web )
- 🎉[chatbot-ui](https://github.com/mckaywrigley/chatbot-ui )
- [chatbox](https://github.com/Bin-Huang/chatbox )

我目前用的是chatbot-ui，不过自己从它的其中一个commit节点切出来了，因为作者后期加入了很多我不需要的东西，UI也改动很大，还是喜欢最开始的简约风格：
- [chatbot-ui/Commits/138950c5](https://github.com/mckaywrigley/chatbot-ui/commits/138950c5520e80f69f059ecf0aea6a91a727cff9 )

直接从这个commit切出来弄一个仓库，发布到Vercel，配置一下环境变量：
- OPENAI_API_HOST="https://api.ezchat.top"
- OPENAI_API_KEY="sk-XXXXXXXXX"

不过如果只是自己用，我更推荐的是直接在Mac本机上安装OrbStack软件，然后通过它作为docker容器来部署chatbot-ui。毕竟Vercel是国外网站，访问网速还是不太给力。

## 3-本地docker部署chatbot-ui

一键初始化仓库的脚本：会自动在当前目录创建一个my-chatui-repo仓库，分支为my-main
```
#!/bin/bash

# 设置本地仓库名称
local_repo_path="my-chatui-repo"
echo "Local repository name: $local_repo_path"

# 如果文件夹不存在则创建
mkdir -p $local_repo_path

# 跳转到本地仓库目录
cd $local_repo_path

# 设置远程仓库URL
remote_repo_url="https://github.com/mckaywrigley/chatbot-ui.git"

# 设置要克隆的commit节点的哈希值
commit_hash="138950c5520e80f69f059ecf0aea6a91a727cff9"

# 初始化本地仓库
git init

# 克隆指定的commit节点到本地仓库
git fetch $remote_repo_url $commit_hash && git checkout FETCH_HEAD

# 切换到名为my-main的分支
git checkout -b my-main
```

然后进入仓库，修改docker-compose.yml，填上HOST和KEY
```yaml
version: '3.6'

services:
  chatgpt:
    build: .
    ports:
      - 3000:3000
    environment:
      - 'OPENAI_API_HOST=https://api.ezchat.top'
      - 'OPENAI_API_KEY=sk-XXXXX'
```

然后部署docker-compose
```shell
docker-compose up -d 
```

## 4-推荐做的几个配置修改

1.增加支持gpt-4-0125-preview模型，这个模型的价格更实惠：

修改types/openai.ts文件：
```ts
import { OPENAI_API_TYPE } from '../utils/app/const';

export interface OpenAIModel {
  id: string;
  name: string;
  maxLength: number; // maximum length of a message
  tokenLimit: number;
}

export enum OpenAIModelID {
  GPT_3_5 = 'gpt-3.5-turbo',
  GPT_3_5_AZ = 'gpt-35-turbo',
  GPT_4 = 'gpt-4',
  GPT_4_32K = 'gpt-4-32k',
  GPT_4_0125_PREVIEW = 'gpt-4-0125-preview',
}

// in case the `DEFAULT_MODEL` environment variable is not set or set to an unsupported model
export const fallbackModelID = OpenAIModelID.GPT_3_5;

export const OpenAIModels: Record<OpenAIModelID, OpenAIModel> = {
  [OpenAIModelID.GPT_3_5]: {
    id: OpenAIModelID.GPT_3_5,
    name: 'GPT-3.5',
    maxLength: 12000,
    tokenLimit: 4000,
  },
  [OpenAIModelID.GPT_3_5_AZ]: {
    id: OpenAIModelID.GPT_3_5_AZ,
    name: 'GPT-3.5',
    maxLength: 12000,
    tokenLimit: 4000,
  },
  [OpenAIModelID.GPT_4]: {
    id: OpenAIModelID.GPT_4,
    name: 'GPT-4',
    maxLength: 24000,
    tokenLimit: 8000,
  },
  [OpenAIModelID.GPT_4_32K]: {
    id: OpenAIModelID.GPT_4_32K,
    name: 'GPT-4-32K',
    maxLength: 96000,
    tokenLimit: 32000,
  },
  [OpenAIModelID.GPT_4_0125_PREVIEW]: {
    id: OpenAIModelID.GPT_4_0125_PREVIEW,
    name: 'GPT-4-0125-preview',
    maxLength: 128000,
    tokenLimit: 128000,
  },
};

```
修改了源码以后需要重新编译部署：
```shell
docker-compose up -d --build
```

2.gitignore文件中忽略掉docker-compose.yml
```
docker-compose.yml
```
防止不小心被KEY给提交到远程仓库了，修改了.gitignore后，执行下面命令让它生效
```
git rm --cache docker-compose.yml
```
3.建议修改默认的3000端口，这个端口号太常用了，太容易冲突了，我改成了23000
```
version: '3.6'

services:
  chatgpt:
    build: .
    ports:
      - 23000:3000
    environment:
      - 'OPENAI_API_HOST=https://api.ezchat.top'
      - 'OPENAI_API_KEY=sk-XXXXXXX'
# docker-compose up -d 
```

好了，下面就是愉快的调戏AI的时刻了。

![image.png](https://yupic.oss-cn-shanghai.aliyuncs.com/20240517203854.png)

其实chatbot-ui是从SB那里发现的这个开源项目。

左侧聊天历史，右侧自定义Prompt模板。可以导出和导入json格式的历史对话。感觉用起来很顺手。