@echo off
chcp 65001 >nul
echo 开始复制主题静态资源...

REM 检查主题目录是否存在
if not exist "themes\hugo-theme-stack\assets" (
    echo ❌ 主题目录不存在: themes\hugo-theme-stack\assets
    exit /b 1
)

REM 复制所有图标
if exist "themes\hugo-theme-stack\assets\icons" (
    if not exist "assets\icons" mkdir "assets\icons"
    xcopy /E /Y "themes\hugo-theme-stack\assets\icons" "assets\icons"
    echo ✅ 已复制所有图标文件
) else (
    echo ⚠️  主题icons目录不存在
)

REM 复制所有图片
if exist "themes\hugo-theme-stack\assets\img" (
    if not exist "assets\img" mkdir "assets\img"
    xcopy /E /Y "themes\hugo-theme-stack\assets\img" "assets\img"
    echo ✅ 已复制所有图片文件
) else (
    echo ⚠️  主题img目录不存在
)
echo ✅ 所有主题静态资源已复制完成！
pause
