#!/bin/bash

source /Users/yutianran/Documents/MyCode/blog-hugo/build_local.sh
cd /Users/yutianran/Documents/MyCode/blog-hugo
git add .
cur_time=$(date +'%Y-%m-%d %H:%M:%S')
git commit -m "update blog at $cur_time"
git push -u origin fishyer
echo "blog updated at $cur_time"
echo "blog deployed successfully"