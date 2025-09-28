---
title: 可变参数
description: 我们可以改变什么
date: 2020-09-09
slug: test-chinese
series: "tt"
weight: 3
categories:
    - Test
    - 测试
    - HLE
tags:
    - lf
---

## 一般参数

**identifier是什么？**

在 Hugo Stack 主题里，菜单项的 `identifier` 并不是 Hugo 官方必须的字段，而是 **Stack 主题自己定义用来唯一标识每个菜单项** 的属性。

作用

1. **唯一标识菜单项**
   - Stack 会根据 `identifier` 判断菜单项是哪一类（Home / Links / Archives 等），方便主题在侧边栏里显示不同图标或处理逻辑。
2. **和图标绑定**
   - 主题里可能会有类似 `params.icon` 的设置，根据 `identifier` 自动匹配图标或样式。

**weight是什么？**

在 Hugo（以及 Stack 主题）菜单配置里，`weight` 是用来 **控制菜单项在侧边栏或导航栏中的排序顺序** 的数字属性。

规则

1. **数值越小 → 越靠前显示**

**可以是正数或负数**

- Hugo 允许负数权重，负数越小（如 -10）越靠前。

## mailto的用法

### 1. `mailto:` 基本用法

`mailto:` 是一个 URL 协议，用来在网页上创建点击后自动打开默认邮件客户端的新邮件窗口，并自动填入收件人、主题等信息。

**基本语法：**

```
mailto:email@example.com
```

**示例：**

```
<a href="mailto:chenalna52@gmail.com">发送邮件</a>
```

点击链接后，系统会自动打开默认的邮件客户端，并将 `chenalna52@gmail.com` 填入收件人字段。

------

### 2. `mailto:` 高级用法（可带参数）

你还可以附加 `subject`（主题）、`body`（邮件内容）、`cc`、`bcc` 等参数：

```
mailto:chenalna52@gmail.com?subject=Hello&body=This%20is%20a%20test
```

- **注意**：空格和特殊字符需要用 URL 编码（比如空格用 `%20`）。
- **多个收件人**可以用逗号分隔：

```
mailto:abc@example.com,xyz@example.com
```

## Hugo单篇文章分页探究

### 1. Hugo 的分页概念

在 Hugo 中，分页 (`pagination`) 通常用于 **列表页面**，例如：

- 博客首页（显示多篇文章的列表）
- 分类页（显示某个分类下的文章列表）
- 标签页（显示某个标签下的文章列表）

分页的作用是：如果文章很多，每页只显示一定数量的文章（比如每页 5 篇），然后用户可以通过“上一页/下一页”或页码来浏览其他文章。

### 2. 单篇文章内分页

Hugo 不支持单篇文章分页是通过 **`<!--more-->`** 或 **`read more`** 来控制文章摘要显示，但这和模板中的 `paginator` 并不一样。
 文档中介绍的 `paginator` 是 `{{ .Paginate }}` 语法，用于列表分页，而不是单篇文章内容分页。

Hugo 本质是**静态站点生成器**，生成的是一组 **固定的 HTML 文件**，它不会像 PHP 或 Node 这种动态后端根据 `?page=1` 之类的参数实时拆分内容。所以即使 URL 上写了 `?page=1`、`?page=2`，如果没有在构建时为每一个参数生成独立的页面文件，浏览器也只会访问到同一个静态文件。

我之前给出的 `?page=` 方案，严格来说只是“伪分页”——

使用 **单篇 Markdown 文件 + `<!--pagebreak-->`** 的方法，带上一页/下一页按钮。

### 3. 在 Hugo 中的现实做法

如果你想**真正**实现一篇文章的分页阅读，通常有以下几种方式：

#### 1. **拆分为多篇内容文件**

例如：

```
content/posts/my-article/
    _index.md    # 目录页（可以写简介）
    part1.md
    part2.md
    part3.md
```

- 每个 `partX.md` 都是一篇独立文章。
- 使用列表模板（或自定义导航）实现“上一页/下一页”跳转。
- 构建后每个 part 都会生成一个独立的 HTML 文件，这才是真分页。

#### 2. **直接写成长文**

Hugo 的推荐做法通常是：

- 用 **目录（Table of Contents）** + **锚点跳转** (`#section-1`) 来组织长文章。
- 通过 Hugo 的 `{{ .TableOfContents }}` 自动生成侧边导航，让读者可以快速跳转。

事实上笔者依然没有找到这样的作法，即在一篇文章内进行分页处理。

## **Hugo 的模板查找顺序**

Hugo 按照以下优先级查找模板：

```
博客根目录/
├── hugo.yaml          ← 在这里配置（会被Hugo优先读取）
├── content/
├── themes/
│   └── hugo-theme-stack/
│       └── config.yaml ← 这个只是默认模板（优先级低）
```

不要像笔者一样去主题里面改了，改了也没用。

**每一页展示文章数目**

```yaml
hugo.yaml:
pagination:
 pagerSize: 10
```



## 附录

### 参考文献

### 版权信息

本文原载于[blog.chenalna.site](https://blog.chenalna.site/)，遵循 CC BY-NC-SA 4.0 协议，复制请保留原文出处。

