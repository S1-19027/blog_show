## 使用git命令下载主题

>1. 在myblog 目录下使用git 命令来下载主题hugo-theme-bootstrap4-blog：
>   `git clone <https://github.com/alanorth/hugo-theme-bootstrap4-blog.git> themes/hugo-theme-bootstrap4-blog`
>   下载下来的主题会放在themes 目录中：

```
└── hugo-theme-bootstrap4-blog
    ├── CHANGELOG.md
    ├── LICENSE.txt
    ├── README.md
    ├── archetypes
    ├── assets
    ├── exampleSite         # 本主题示例内容
    |      ├── content      # 示例博客文章
    │      |-- static
    │      |-- config.toml  # 本主题配置
    ├── i18n
    ├── images
    ├── layouts
    ├── package-lock.json
    ├── package.json
    ├── screenshot.png
    ├── source
    ├── theme.toml
    └── webpack.config.js
```

>2. 使用主题
>   我们将exampleSite 目录中的内容，复制到博客根目录myblog 中，在myblog 目录中执行命令：
>   `cp themes/hugo-theme-bootstrap4-blog/exampleSite/* ./ -r`
>   删除旧的hugo.toml
>   (存疑将archetypes/default.md,"+"改成"-","="改成"+"，因为这个时toml格式的，我们要改成yaml格式)
>3. 启动博客服务
>   使用下面命令启动服务：
>   `>>> hugo server`



## 遇到错误  

1.   子模块可能没有被正确初始化，或者 .gitmodules 文件中的配置与实际的子模块路径不匹配.

```
/usr/bin/git -c protocol.version=2 submodule update --init --force
Error: fatal: No url found for submodule path 'themes/hugo-theme-bootstrap4-blog' in .gitmodules
Error: The process '/usr/bin/git' failed with exit code 128  
```

​	解决方法：添加子模块
  git submodule add <https://github.com/theNewDynamic/gohugo-theme-ananke.git> themes/ananke.

2. 

```
ERROR deprecated: .Site.Social was deprecated in Hugo v0.124.0 and subsequently
removed. Implement taxonomy 'social' or use .Site.Params.Social instead.
ERROR deprecated: .Site.Authors was deprecated in Hugo v0.124.0 and subsequently
removed. Implement taxonomy 'authors' or use .Site.Params.Author instead.
```

​	解决方法
如报错信息，找到对应并替换即可

3. `range can't iterate over Your Name`

  Hugo 提示 range can't iterate over Your Name，这意味着你在模板中尝试使用 range 迭代一个字符串（Your Name），
  而 range 只能用于迭代数组、切片或映射（map），不能用于迭代单个字符串。

  你的` .Site.Params.Author `配置在` config.toml `里是：

  ```toml
[params]
author = "Your Name"
  ```

  `executing "partials/twitter_cards.html" at <.twitter>: can't evaluate field twitter in type interface {}`

  模板 `partials/twitter_cards.html` 里面，有类似这样的代码：

  ```go
{{ range .Site.Params.Author }}
    {{ .twitter }}
{{ end }}
  ```

  这段代码假设 `Author` 是一个数组或对象，每个元素都有 `twitter` 字段。

  但你提供的是字符串 `"Your Name"`，模板自然找不到 `.twitter` 字段 → 报错。

  方法 1：修改 config.toml 中的 author 配置
  将 author 配置为一个对象或数组，而不是字符串。例如：

  ```go
[params]

[params.author]

  author = "Your Name"

 twitter = "your_twitter"
  ```

  如果你需要迭代多个作者，可以将 author 配置为一个数组：

  ```go
[params]

 [[params.author]]

name = "Author 1"

 twitter = "author1_twitter"

 [[params.author]]

 name = "Author 2"

twitter = "author2_twitter
.
  ```

  方法2：如果 author 必须是一个字符串（例如 author = "Your Name"），你需要修改模板文件，避免使用 range 迭代 .Site.Params.Author。
  例如，将 twitter_cards.html 中的代码：

  ```go
{{ range .Site.Params.Author }}

  {{ .twitter }}

{{ end }}
  ```

  改为：
  `{{ .Site.Params.Author }}`

  方法 3：调试模板

  在 `twitter_cards.html` 中打印上下文，看看实际传入了什么：

  ```
{{ printf "%#v" . }}
  ```

  - 可以快速发现传入的上下文是否有 `twitter` 字段。
  - 用于排查问题，非常有用。

  方法 4：临时禁用 Twitter 卡片

  如果不需要 Twitter 卡片，可以在 `head-meta.html` 注释掉调用：

  ```
{{/* {{ partial "twitter_cards.html" . }} */}}
  ```

  - 避免报错，让网站能正常生成。
  - 适合快速排查或暂时不需要社交卡片功能。

4. 

```
 $ hugo
 bash: line 1: hugo: command not found
 "build.command" failed                                        
 ────────────────────────────────────────────────────────────────
   Error message
   Command failed with exit code 127: hugo (https://ntl.fyi/exit-code-127)
   Error location
   In Build command from Netlify app:
   hugo
 
   Resolved config
   build:
     command: hugo
     commandOrigin: ui
     publish: /opt/build/repo/public
     publishOrigin: ui
 Build failed due to a user error: Build script returned non-zero exit code: 2
 Failing build: Failed to build site
 Finished processing build request in 16.127s
```

 这个错误表明在你的构建环境中，hugo 命令未找到。hugo 是一个用于生成静态网站的工具，而你的构建系统（这里是 Netlify）无法找到它。
 解决方法：在 Netlify UI 中设置 Hugo 版本
如果你不想使用 netlify.toml 文件，可以通过 Netlify 的 UI 设置 Hugo 版本：

登录 Netlify 并进入你的项目。

导航到 Site settings > Build & deploy > Environment > Environment variables。

添加一个环境变量：

Key: HUGO_VERSION

Value: 0.120.4（替换为你需要的 Hugo 版本）。

保存并重新触发构建。

## Docsy主题

Docsy 是一个基于 Hugo 的主题，专门用于构建技术文档集。以下是一般 Docsy 项目的基本目录结构：

```
.
├── archetypes           # 自定义模板定义
├── assets                # 存放静态资源，如样式表、JavaScript 和图片
│  
├── css               # 主题和站点的自定义 CSS
│    └── ...
├── content              # 网站内容，包括页面和博客文章
│    ├── _index.md         # 主页内容
│    ├── docs              # 文档区域
│    │   └──_index.md     # 文档首页
│    ├── blog              # 博客文章
│    └── ...
├── data                  # YAML 数据文件，可用于自定义站点变量或数据
├── layouts               # 自定义布局文件
├── static                # 非 Hugo 处理的静态资源，将被直接复制到生成的站点中
├── themes                # 包含 Docsy 主题的子目录

```

### 项目的启动文件介绍

在 Docsy 项目中，主要的启动文件是 config.toml 或 config.yaml（取决于你的偏好）。这些配置文件位于项目根目录下，用来设置网站的基本参数、导航菜单、多语言支持等。

例如，一个简单的 config.toml 文件可能如下所示：

```
#Hugo 属性设置 
title = "我的文档站点"
#网站地址
baseURL = "https://example.com/"
#网站语言
languageCode = "en-us"
# 网站title
title = "我的博客"                   

# 主题的名字，这个要跟myblog/themes 目录中的子目录的目录名一致
theme = "hugo-theme-bootstrap4-blog"    

# home/category/tag 页面显示的文章数 (Default: 10)
paginate = 5

# home/category/tag 页面用于摘要的字数 (Default: 70)
summaryLength = 50
# optionally override the site's footer with custom copyright text
# copyright = "Except where otherwise noted, content on this site is licensed under a [Creative Commons Attribution 4.0 International license](https://creativecommons.org/licenses/by-sa/4.0/)."
#googleAnalytics = "UA-123-45"
#disqusShortname = "XYW"
# 博客链接的路径格式
[permalinks]
  posts = "/:year/:month/:title/"
  page = "/:slug/"
顶部栏
[[menu.main]]
name = "首页"
weight = 1
identifier = "home"
url = "/"
 侧边栏
[[menu.main]]
name = "文档"
weight = 2
identifier = "docs"
url = "/docs/"
#Theme 属性设置
#
[params]
  # Site author
  author = "Your Name"

  # Description/subtitle for homepage (can be Markdown)
  description = "A simple Hugo theme based on the Bootstrap v4 blog example."

  # Show header (default: true)
  #header_visible = true

  # Format dates with Go's time formatting
  date_format = "Mon Jan 02, 2006"

  # verification string for Google Webmaster Tools
  #google_verify_meta = "BAi57DROASu4b2mkVNA_EyUsobfA7Mq8BmSg7Rn-Zp9"

  # verification string for Bing Webmaster Tools
  #bing_verify_meta = "3DA353059F945D1AA256B1CD8A3DA847"

  # verification string for Yandex Webmaster Tools
  #yandex_verify_meta = "66b077430f35f04a"

  # Optionally display a message about the site's use of cookies, which may be
  # required for your site in the European Union. Set the parameter below to a
  # page where the user can get more information about cookies, either on your
  # site or externally, for example:
  #cookie_consent_info_url = "/cookie-information/"
  #cookie_consent_info_url = "http://cookiesandyou.com"

  # show sharing icons on pages/posts (default: true)
  #sharingicons = true

  # Display post summaries instead of content in list templates (default: true)
  #truncate = true

  # Disable the use of sub-resource integrity on CSS/JS assets (default: false)
  # Useful if you're using a CDN or other host where you can't control cache headers
  #disable_sri = false

  [params.sidebar]
    # Optional about block for sidebar (can be Markdown)
    about = "A simple Hugo theme based on the [Bootstrap v4 blog example](http://v4-alpha.getbootstrap.com/examples/blog/)."

    # How many posts to show on the sidebar (Default: 5)
    #num_recent_posts = 2

  [params.social]
    # Optional, used for attribution in Twitter cards (ideally not a person
    # for example: nytimes, flickr, NatGeo, etc).
    # See: https://dev.twitter.com/cards/types/summary-large-image
    twitter = "username"

# Default content language for Hugo 0.17's multilingual support (default is "en")
# See: https://github.com/spf13/hugo/blob/master/docs/content/content/multilingual.md
#DefaultContentLanguage = "en"

# Languages to render
#[languages.en]
#[languages.bg]
  # Bulgarian date format is dd.mm.yyyy
  #date_format = "02.01.2006"

# vim: ts=2 sw=2 et
```

在这个例子中，我们设置了网站的标题、基础 URL 和语言代码，以及两个主菜单项（首页和文档）。

### 项目的配置文件介绍

config.toml/config.yaml
这是整个站点的核心配置文件，你可以在这里设定站点的基本信息、导航菜单、元数据参数、多语言支持等。
_config.yaml in /themes/docsy
尽管这不是项目本身的配置文件，但 Docsy 主题也有自己的_config.yaml。这个文件包含了 Docsy 提供的默认配置，可以在项目中的 config.toml/config.yaml 中覆盖或扩展。
.hugorc （可选）
如果你选择使用 JSON 格式的配置，可以创建一个 .hugorc 文件来存储配置。它的工作方式与 config.toml 类似。
archetypes 目录
此目录下的文件定义了创建新页面时的默认内容结构。例如，你可以创建一个 doc.md 文件作为文档页面的模板。
static 和 assets 目录
这两个目录分别存放静态文件和处理过的静态资源。static 直接包含要复制到生成站点的内容，而 assets 内的文件会经过诸如 Sass 编译等预处理器处理。
以上就是 Docsy 主题的基本介绍和使用指南。更多详细信息和高级配置，请参考 Docsy 的官方文档。



## 自建主题骨架

创建新主题时，Hugo 会生成一个可用的主题骨架。例如，以下命令：
hugo new theme my-theme
会创建以下目录结构(省略了子目录):  

```
` my-theme/  
  ├── archetypes/  
  ├── assets/  
  ├── content/  
  ├── data/  
  ├── i18n/  
  ├── layouts/  
  ├── static/  
  ├── LICENSE  
  ├── `README.md`  
  ├── hugo.toml  
  └── theme.toml  
```


使用上述描述的联合文件系统，Hugo 将每个目录挂载到项目的相应位置。当两个文件路径相同时，项目目录中的文件优先。这样，例如，您可以通过在项目目录相同位置放置一个副本来覆盖主题的模板。

## 安装hexo

npm install -g hexo-cli