#!/bin/bash

cd /Users/yutianran/MyGithub/blog-hugo
hugo --buildFuture
git add .
cur_time=$(date +'%Y-%m-%d %H:%M:%S')
git commit -m "update blog at $cur_time"
git push -u origin fishyer
hugo server