#!/bin/bash

echo "=== 开始复制主题资源 ==="

# 确保所有目标目录都存在
mkdir -p assets/icons assets/img 

# 复制函数：如果源存在就复制，不存在就跳过
copy_if_exists() {
    local source_dir=$1
    local target_dir=$2
    local name=$3
    
    if [ -d "$source_dir" ] && [ -n "$(ls -A "$source_dir" 2>/dev/null)" ]; then
        echo "复制 $name..."
        cp -R "$source_dir"/* "$target_dir"/
        local file_count=$(find "$target_dir" -type f | wc -l)
        echo "✅ $name 复制完成 ($file_count 个文件)"
    else
        echo "⚠️  $name 源目录不存在或为空，已创建空目录"
    fi
}

# 复制各种资源
copy_if_exists "themes/hugo-theme-stack/assets/icons" "assets/icons" "图标"
copy_if_exists "themes/hugo-theme-stack/assets/img" "assets/img" "图片"


echo "=== 资源复制完成 ==="