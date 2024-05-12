#!/bin/bash

cp -rf /Users/yutianran/Documents/MyPKM/note/blog/* /Users/yutianran/MyGithub/blog-hugo/content/
cd /Users/yutianran/MyGithub/blog-hugo
hugo --buildFuture
hugo server