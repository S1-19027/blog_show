## 使用git命令下载主题

>1. 在myblog 目录下使用git 命令来下载主题hugo-theme-bootstrap4-blog：
>     `git clone <https://github.com/alanorth/hugo-theme-bootstrap4-blog.git> themes/hugo-theme-bootstrap4-blog`
>     下载下来的主题会放在themes 目录中：

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
>     我们将exampleSite 目录中的内容，复制到博客根目录myblog 中，在myblog 目录中执行命令：
>     `cp themes/hugo-theme-bootstrap4-blog/exampleSite/* ./ -r`
>     删除旧的hugo.toml
>     (存疑将archetypes/default.md,"+"改成"-","="改成"+"，因为这个时toml格式的，我们要改成yaml格式)
>3. 启动博客服务
>     使用下面命令启动服务：
>     `>>> hugo server`



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

5. 推送的时候是master（主仓库，因为你没有权限）不是change（本地）

​	`git commit -m "Add brand-bilibili icon" git push origin my-changes`，写成`git push origin master`了

​	**解决方法：回退 fork 的 master**

如果你**必须**把 fork 的 master 恢复到推送前的状态（例如不想把修改放在 master 上）：

1. 找到推送前的 commit：

   ```
   cd themes/hugo-theme-stack
   git log --oneline --decorate
   ```

   记下误推前的 commit ID，例如 `abcdef0`。

2. 强制回退远程 master：

   ```
   git checkout master
   git reset --hard abcdef0      # 回到旧的 commit
   git push origin master --force
   ```
   
3. 把你的修改推到新分支：

git checkout -b my-changes

git push origin my-changes


4. 更新父仓库指针：

cd ../..

git add themes/hugo-theme-stack

git commit -m "Update submodule pointer to my-changes"

git push origin master

**如果你确实要修改主题源码（例如修改 theme 下的模板）**

此时子模块必须 fork，因为：

- 你想改的文件在 `themes/hugo-theme-stack/`
- 父仓库不会直接跟踪这些文件

每次修改流程：

1. 进入子模块：

   ```
   cd themes/hugo-theme-stack
   git checkout my-changes   # 建议始终在自己分支
   git pull origin my-changes  # 保持同步
   # 做修改
   git add .
   git commit -m "Update theme style"
   git push origin my-changes
   ```

2. 回到父仓库更新指针：

   ```
   cd ../..
   git add themes/hugo-theme-stack
   git commit -m "Update submodule pointer"
   git push origin master
   ```

利用submodule来更新， 自己新建的没有更新是因为submodule没有更新



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





### 如何建立自己的（博客）域名 

​	以`blog.xyz.site`为例

1. 首先选择域名注册商，如[阿里云](https://wanwang.aliyun.com/domain),购买自定义域名如`xyz.site`.可以自定义子域名，如`blog.xyz.site`。

2. 配置DNS记录

   为了让 `blog.xyz.com` 指向你的 Netlify 博客，需要在域名注册商那里设置 DNS：

   1. 登录域名注册商控制台。
   2. 进入[**DNS 管理** 或 **域名解析** ](https://dnsnext.console.aliyun.com/authoritative/domains)页面。
   3. 添加以下记录：

   - **CNAME 记录**
     - **主机名/名称/记录**：`blog`
     - **指向/值/记录值**：你的 Netlify 默认域名（`chenaasad.netlify.app`）
     - **TTL**：默认即可

   > ⚠️ 注意：不要同时为同一个子域名添加 A 记录，如果添加了 CNAME，就不要再加 A 记录。

   4. 保存并等待 DNS 生效（通常几分钟到 24 小时）。

3. 在 Netlify 添加自定义域

   1. 登录 Netlify 控制台，进入你的站点设置。

   2. 选择 **Domain management → Custom domains → Add custom domain**。

      即[Set up Netlify DNS ](https://app.netlify.com/projects/chenalna/dns/setup)

   3. 输入你的域名 `blog.xyz.com` 并保存。

   4. Netlify 会自动检测你的 CNAME 配置是否正确，如果一切正常，它会颁发 SSL 证书（HTTPS）。

   5. Netlify 会自动为自定义域名生成免费的 Let's Encrypt SSL 证书。

      你只需要确保在站点设置中开启 **Enforce HTTPS**（强制 HTTPS）。

      等证书生效后，你的博客就可以通过 `https://blog.xyz.com` 访问。

4. DNS 是否已传播

   即便你已经添加了正确的 CNAME 记录，DNS 修改需要一定时间才能在全球生效。

   - 一般 10 分钟到 24 小时不等。
   - 可以用以下工具查询是否已生效：
     - https://dnschecker.org/#CNAME/blog.chenalna.site
       看到解析结果是 **`chenaasad.netlify.app`** 才算成功。

5. 是否开启了 CDN/代理

   如果你使用 Cloudflare 或类似服务：

   - 确保 `blog` 这一条记录**小云朵为灰色（DNS only）**而不是橙色（代理状态），
     因为橙色会隐藏真实 CNAME，导致 Netlify 无法验证。
   - 验证完成并签发证书后，可以再开启代理。



### 为什么需要两个方向的绑定？

1. 阿里云的作用

   阿里云是**域名注册商**，它只负责：

   - 记录「访问 blog.chenalna.site 时去哪台服务器找内容」
   - 也就是**DNS 解析**（把域名解析成 IP 或转发到另一个域名）

   > 你在阿里云添加 **CNAME 记录**，只是告诉互联网：
   > “访问 `blog.chenalna.site` 时，请先去找 `chenalna.netlify.app`”。

   阿里云并不知道 `chenalna.netlify.app` 是不是你的站点，也不会给你的网站签 SSL 证书。
    它只是把访问者“指路”给 Netlify。

2.Netfliy作用

​	Netlify 是**托管服务商**，它必须：

- **确认这个域名是你的**（防止别人盗用你的域名指到他们的服务器）
- **为这个域名签发 SSL 证书**（HTTPS 加密）
- 配置站点路由，把 `blog.chenalna.site` 的请求交给你的博客程序

> 所以你在 **Netlify → Domain management** 添加域名，
> 就是告诉 Netlify：
> “这个域名是我的，DNS 我已经指到你们这里，请为它提供服务并签证书。”

3. 总结

   **阿里云**：相当于邮局的“地址登记处”，你告诉它：

   “有人找 `blog.chenalna.site`，就送到 Netlify。”

   **Netlify**：相当于你自己的“房子”，你得告诉它：

   “这个地址归我，请给这个地址挂上门牌和门锁（SSL证书）。”

4. 归纳

   1️⃣ 你输入 `https://blog.chenalna.site`

- 浏览器需要找到这个域名的 **IP**。

- 向 DNS 递归服务器（例如阿里云）查询 `blog.chenalna.site` 的记录。

- 阿里云返回：
  `CNAME chenalna.netlify.app`

  `blog.chenalna.site` 的解析结果 **等同于** `chenalna.netlify.app`，
   解析这个域名。

  2️⃣ 浏览器继续查询 `chenalna.netlify.app`

- 递归 DNS 服务器向 **Netlify 的权威 DNS** 查询 A/AAAA 记录。

- Netlify 返回一个或多个 **IP**（通常是 CDN/负载均衡节点）。

- 浏览器最终得到**托管服务器 IP**。

  3️⃣ 浏览器建立 TCP/TLS 连接

- 浏览器连接到**刚刚得到的 IP**。

- 如果是 HTTPS，会先发起 **TLS 握手**：

  - 在 `ClientHello` 里带上 **SNI**（Server Name Indication）：

    ```
    blog.chenalna.site
    ```

  - 这样服务器才能选择正确的 SSL 证书。

  4️⃣ 浏览器发送 HTTP 请求

- 握手完成后，浏览器发送标准 HTTP 请求：

  ```
  GET / HTTP/1.1
  Host: blog.chenalna.site
  User-Agent: ...
  Accept: ...
  ```

- 关键点：**Host = blog.chenalna.site**
  。 即使连接的是 **Netlify** 的 IP，
  Host 告诉 Netlify：“我访问的是 `blog.chenalna.site` 项目。”

  5️⃣ Netlify 服务器返回内容

- Netlify 根据 Host 找到对应的项目（你 GitHub 部署的静态文件）。

- 直接返回 **HTML/CSS/JS** 等静态资源。

- 因为是静态站点，返回的就是**最终网页文件**，不需要再发起其他“对象请求”才能获取主体内容（除非页面里引用了图片、JS、CSS，这些的附属资源，会触发额外的 HTTP 请求）。

| 域名类型                                  | 作用                                           | 是否必须   |
| ----------------------------------------- | ---------------------------------------------- | ---------- |
| **Netlify 子域名** `chenalna.netlify.app` | Netlify 自动分配，始终可用，方便测试或直接访问 | ✅ 自动拥有 |
| **自定义域名** `blog.chenalna.site`       | 你绑定的独立域名，用于品牌化访问               | 可选       |

它们共存，不冲突，**访问最终落在同一个 Netlify 服务器和同一份内容上**。

Netlify 部署时，你在项目设置中指定了**构建命令**和**输出目录**（Publish directory）。
 Netlify 会把这个目录里的内容部署到 CDN。
 所以虽然仓库里你看不到一个手写的 `index.html`，
 **Netlify 构建完成后生成的 `index.html`** 才是浏览器实际拿到的页面入口。



## Edge自带问题

1. 此网站的证书无效。由于此连接不安全，因此信息(如密码或信用卡)不会安全地发送到此网站，并且可能被其他人截获或看到。建议你不要在此网站输入个人信息或避免使用此网站。

**DNS 解析未生效**

- 你在阿里云添加了 `blog.chenalna.site` 的 CNAME，但 DNS 还没有在全球生效。
- Netlify 还没检测到域名指向它的服务器，因此 **无法签发 SSL 证书**。
- 生效时间通常 10 分钟到 24 小时不等。

2. 与此站点的连接不安全此站点有一个由受信任的颁发机构颁发的有效证书。但是，网站的某些部分不安全。这意味着信息 (如密码或信用卡) 可能不会安全地发送到此站点，并可能被其他人截获或查看。

   Let’s Encrypt 的证书 **有效期为 90 天（约 3 个月）**。

   Netlify 会在证书到期前 **自动续签**，无需手动干预。

   **清除 Edge 缓存和证书状态**

   - 打开 Edge → 设置 → 隐私、搜索和服务 → 清除浏览数据 → 勾选缓存文件、Cookie
   - 也可以在地址栏输入 `edge://net-internals/#dns` → Clear host cache
   - 再重新访问 `https://blog.chenalna.site`

## 脚本功能

1. **copy_assests.sh**

​	将themes/hugo-theme-stack/assests下的文件复制到blog/assests下

2. local_launch.bat

   本地运行

3. push.bat

​	**自动把本地 Hugo 生成网站推送到远程服务器部署**



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

​	




