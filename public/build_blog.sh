#!/bin/bash

cd /Users/yutianran/Documents/MyPKM/docker/blog-hugo
hugo -c /Users/yutianran/Documents/MyPKM/note/blog
# hugo server -D -c /Users/yutianran/Documents/MyPKM/note/blog
git add .
cur_time=$(date +'%Y-%m-%d %H:%M:%S')
git commit -m "update blog at $cur_time"
git push -u origin fishyer
hugo server -D