---

title: "Hugo_config"
slug: "Hugo_config"
description: 
date: "2025-09-28T12:10:49+08:00"
lastmod: "2025-09-28T12:10:49+08:00"
image: cover.png
math: 
license: 
hidden: false
draft: false 
categories: [""]
tags: [""]

---



## Hugo中的列表页、叶子页面和文章

1. 在 **Hugo Stack** 主题中，如果你只是想做一个**单独的文章**，**推荐的做法是：直接在 `content/page/` 下新建一个 `search.md` 文件** 

   ⚡ **原因**：

   content/page/xxx.md 表示一个“单页 (single page)”，它的 URL 自动是 /xxx/，非常适合搜索页、关于页、归档页这类独立页面。
   Stack 主题的「Search」就是单页，不需要列表功能，所以 .md 就够了。

2. content/search/_index.md
   适用于Section 列表页（文章合集），但搜索不是列表，不需要。

###  Hugo 如何生成页面 URL

Hugo 的规则：

| 文件位置                             | 前端 URL                    |
| ------------------------------------ | --------------------------- |
| `content/page/search.md`             | `/search/`                  |
| `content/page/travelling.md`         | `/travelling/`              |
| `content/travelling/_index.md`       | `/travelling/`              |
| `content/travelling/some-article.md` | `/travelling/some-article/` |

> 也就是说，**URL 的生成与菜单的 `url` 字段对应**，而不是 `identifier`。

------

###  Stack 菜单如何绑定页面

在 Stack 主题里，菜单配置通常在 `config.toml` 或 `config.yaml`，示例：

```
- identifier: travelling
  name: 旅行
  url: /travelling/
  weight: 40
  params:
    icon: map
```

### 工作原理

1. `url: /travelling/` → Hugo 会根据这个 URL 去匹配实际页面：
   - 先看 `content/page/travelling.md`
   - 如果没有，再看 `content/travelling/_index.md`
2. `identifier` 只用于 **Stack 内部逻辑和图标匹配**，不影响 URL。
3. Hugo 会把对应 URL 的页面渲染到 `/travelling/index.html`，然后侧边栏点击就跳到这个页面。

Hugo 的 **content 目录** = 站点内容源

- **Section**：一个“内容分组”目录，例如 `post/`、`travelling/`。
- **List Page（列表页）**：显示 Section 下文章列表的页面。
- **Single Page（单页）**：显示一篇文章的页面。

Hugo 通过文件名来判断一个内容是 **单页** 还是 **列表页**：

| 文件名             | 含义                                |
| ------------------ | ----------------------------------- |
| `_index.md`        | 列表页（List Page）                 |
| `index.md`         | 叶子页面（Leaf Bundle Single Page） |
| 其他名字（abc.md） | 普通单篇文章（Single Page）         |

 #### content 根目录的例子

 `content/_index.md`

- 作用：站点根目录的**首页列表页**。
- URL：`/`
- 内容：可以写首页描述或 Front Matter，例如标题、副标题。
- Stack 主题的首页就是通过这里配合 `params.mainSections` 来渲染文章列表。

 `content/index.md`

- 作用：站点根目录的**单页**。
- URL：`/` 或主题自定义（大多数主题不这么用）。
- 因为首页一般用 `_index.md`，所以很少使用 `index.md`。

 `content/abc.md`

- 作用：根目录下的一篇单独文章。
- URL：`/abc/`

第二种切换成index.md并没有什么效果，即并不是像abc.md为一篇文章,依然有列出所有文章的功能

#### content/page 目录

假设目录结构：

```
content/
└─ page/
   ├─ _index.md
   ├─ index.md
   └─ abc.md
```

| 文件             | 作用                                                         | URL                          |
| ---------------- | ------------------------------------------------------------ | ---------------------------- |
| `page/_index.md` | **page Section 的列表页**。如果要在 `/page/` 下显示所有子页面的列表，用它。 | `/page/`                     |
| `page/index.md`  | `page` 目录本身作为**叶子单页**（Leaf Bundle）。通常很少用。 | `/page/`（除非主题重写规则） |
| `page/abc.md`    | 一个普通单页（例如 About、Links 等）。会在左处出现。         | `/abc/`                      |



当从index.md切换到_index.md，会报错

⚡ Stack 主题的「Links / Archives / Search」这类单页通常直接用 `abc.md`，
 因为它们是单独的页面，不需要列表功能。

#### 新建一个文件夹 solution

```
content/
└─ solution/
   ├─ _index.md
   ├─ index.md
   └─ abc.md
```

| 文件                 | 作用                                              | URL              |
| -------------------- | ------------------------------------------------- | ---------------- |
| `solution/_index.md` | **Solution Section 的列表页**（显示子文章列表）。 | `/solution/`     |
| `solution/index.md`  | Solution 目录自身作为**叶子单页**。               | `/solution/`     |
| `solution/abc.md`    | Solution 下的一篇文章。                           | `/solution/abc/` |

> **常见用途**
>
> - 如果你想 `/solution/` 打开后看到**文章列表** → 用 `_index.md`。
> - 如果你想 `/solution/` 打开后只显示**一篇独立页面** → 不要 `_index.md`，而是用 `index.md`（Leaf Bundle 模式）。

#### post 目录的情况

```
content/
└─ post/
   ├─ _index.md
   ├─ index.md
   └─ abc.md
```

| 文件             | 作用                                              | URL          |
| ---------------- | ------------------------------------------------- | ------------ |
| `post/_index.md` | **文章列表页**（首页/归档会读取这里的 Section）。 | `/post/`     |
| `post/index.md`  | `post` 整个目录作为一个**单页**（不常用）。       | `/post/`     |
| `post/abc.md`    | 单篇博客文章。                                    | `/post/abc/` |

> ⚡ **Stack 的首页**
> `content/post/` 下的文章会自动汇总到 `/`（通过 `mainSections`），
> 但你也可以访问 `/post/`，它会用 `post/_index.md` 的配置作为标题/描述。

第一种情况和第三种情况没有用,依然展示所有文章.

不要将Solution放在content/page下而是content/下,否则,只是一篇文章.

## 一些小巧思

###  让文件出现在侧栏

```
  menu:   
     main:
        - identifier: solution
          name: "解答"
          url: "/solution/"
          weight: 3
          params:
            icon: bulb
```

### 不同语言设置不同的social和侧边栏

将main:menu:放到language下

如

```
  zh-cn:
    languageName: 中文
    title: chenalna
    weight: 2
    params:
      sidebar:
        subtitle: ....
    menu:
      main:
        - identifier: solution
          name: ...
          url: "/solution/"
          weight: 3
          params:
            icon: bulb
      social:....
```

问题是，为什么page下的archives/about/links/search，是默认生成的，你在page下添加新的文件夹却不会自动添加到到侧边栏。笔者并不知道为什么。

如果是自己新加的，需要在在对应语言下增加-identifier

**使用Hugo创建类别、标签**一节，新增的分类并不会在主页post列表出现，而是在归档下的Catgories出现。而分类更是，在归档下也没有出现。

**总而言之，问题有四：**

1. 关于单篇文章内的分页问题。（这是不是意味着倡导博客写短一点）
2. 关于社交信息的多语言问题，只能重新复制一遍到语言模块下。
3. 为什么在Page下的archives/about/links/search默认添加到默认语言，而自己新建的必须在对应语言下增加-identifier。
4. 关于多语言切换到部署到Github却没有生成对应的英文网址的问题。

## 附录

### 参考文献

### 版权信息

本文原载于[blog.chenalna.site](https://blog.chenalna.site/)，遵循 CC BY-NC-SA 4.0 协议，复制请保留原文出处。