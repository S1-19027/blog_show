@echo off & echo 【创建文章】  
set /p "theme= 请输入主题: "  
set /p "slug= 请输入Slug: "  
hugo new post/%theme%/%slug%.md  
echo 创建成功 
pause  