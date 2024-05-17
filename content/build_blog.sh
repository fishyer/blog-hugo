#!/bin/bash

cp -rf /Users/yutianran/Documents/MyNote/blog/* /Users/yutianran/Documents/MyCode/blog-hugo/content/
cd /Users/yutianran/Documents/MyCode/blog-hugo
hugo --buildFuture
git add .
cur_time=$(date +'%Y-%m-%d %H:%M:%S')
git commit -m "update blog at $cur_time"
git push -u origin fishyer
hugo server