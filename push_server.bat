@echo off
hugo
scp -r -P 22 public/* root@111.92.241.204:/home/hugo_blog/
::scp -r -P 端口 public/* 你的名字@IP:存放博客文件的路径（展示）
pause