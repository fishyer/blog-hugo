# 我的静态博客

由hugo自动生成的静态博客

源Markdown文件位于`/content`目录下，hugo会自动生成静态HTML文件到`/public`目录下，并部署到Github Pages。

博客主题为[hugo-theme-even](https://github.com/olOwOlo/hugo-theme-even)，感谢作者的开源工作！

## 从Obsidian指定目录来生成hugo

自动运行此脚本即可：

```bash
#!/bin/bash

cd /Users/yutianran/Documents/MyPKM/test/blog-hugo
hugo -c /Users/yutianran/Documents/MyPKM/note/blog
hugo server -D -c /Users/yutianran/Documents/MyPKM/note/blog
```