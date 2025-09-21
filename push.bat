@echo off
scp -r -P 22 public/* root@121.40.218.157:/home/hugo_blog/
::scp -r -P 端口 public/* 你的名字@IP:存放博客文件的路径（展示）