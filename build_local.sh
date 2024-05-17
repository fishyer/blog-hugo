#!/bin/bash

function log() {
  echo [$(date +"%Y-%m-%d %H:%M:%S")] "$@"  | tee -a "$0.log"
}

function end(){
    log "##################################################"
}


log "Running blog_hugo build_local.sh"
log "Current datetime: $(date +"%Y-%m-%d %H:%M:%S")"

cp -rf /Users/yutianran/Documents/MyNote/blog/* /Users/yutianran/Documents/MyCode/blog-hugo/content/
cd /Users/yutianran/Documents/MyCode/blog-hugo
hugo --buildFuture
pkill -f "hugo server"
nohup hugo server >> "$0.log" 2>&1 &
log "blog server is run at http://localhost:1313/"

end
