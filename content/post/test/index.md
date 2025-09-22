---
date : "2025-09-23" 
title: Hugo + Stack 简单搭建一个静态博客
description: 从零开始的博客生活
categories:
    - Hugo
    - Web
tags:
    - Hugo
---

## 前言

静态博客已成为现代技术博客、个人站点和文档系统的热门选择。

本文基于Hugo

## Hugo优势

1. 生产的性能好。Hugo是由 Go 语言实现的静态网站生成器。简单、易用、高效、易扩展、快速部署。

无论是Hugo还是Hexo，本质上都是将master文件通过预定好的模板渲染html文件

## 环境准备

1. 下载node.js
2. 下载golang

## 安装golang

安装hugo之前，先安装好[golang](<https://go.dev/dl/>)，推荐安装最新版本。

安装时选择安装目录为 C:\Users\sky\work\soft\golang 或者 D:\sky\work\soft\golang。

修改环境变量，将 GOPATH 的值修改为 C:\Users\sky\work\soft\gopath 或者 D:\sky\work\soft\gopath（默认为 %USERPROFILE%\go）。

## 安装nodejs/npm

为了使用Google Docsy主题，需要安装nodejs/npm。

在网站下载[nodejs](https://nodejs.org/en/download/package-manager)

安装时选择安装路径为 C:\Users\sky\work\soft\nodejs 或者 D:\sky\work\soft\nodejs。

## 安装Hugo

在Hugo Releases页面下载对应操作系统版本的安装包。[Hugo官方下载文档](https://gohugo.io/installation/)
,如`hugo_extended_0.150.0_windows-amd64.zip`.下载下来之后，解压缩，将 hugo.exe 文件复制到目录下。

然后修改环境变量，在 Path 中增加这个路径，
验证安装
`$ which hugo`
、`$ hugo version`。

切记由于 hugo和主题之间版本有依赖关系，因此不同主题选择不同版本

打开命令提示符，输入`hugo version`来验证安装是否成功。

## Hugo安装完成后的配置工作

设置别名
为了方便使用，增加 hugo server 命令的 alias 用来本地编辑时的实时预览：
vi ~/.zshrc
增加内容：

```
# hugo
alias h='hugo -D -F server --disableFastRender --bind "0.0.0.0"'
alias h2='hugo -D -F server --disableFastRender --bind "0.0.0.0" --port 2323'
alias h3='hugo -D -F server --disableFastRender --bind "0.0.0.0" --port 3333'
alias h4='hugo -D -F server --disableFastRender --bind "0.0.0.0" --port 4343'
```

hugo命令行参数说明：

-D: 等同--buildDrafts，标记为 Draft 的内容也会一起构建，方便在本地编写和预览新的暂时未发布的内容。

-F: 等同--buildFuture，发布时间为"未来"(即时间比当前时间还要晚)内容也会一起构建，方便在本地编写和预览新的暂时未发布的内容。
--disableFastRender：当内容修改时，进行完整的重新构建，避免预览的内容不够新
h2/h3/h4 指定了不同的端口，当需要在本地打开多个时，可以使用固定端口而不是随机端口。

## 设置代理

### npm代理
>主要是 npm 命令需要代理才能顺利下载文件，比如:安装 PostCSS
>要构建或更新站点的 CSS 资源，您还需要PostCSS创建最终资产。如果您需要安装它，您必须在您的机器上安装最新版本的NodeJS，以便您可以使用npmNode 包管理器。默认情况npm下，在您运行的目录下安>装工具npm install：
>npm install -D autoprefixer
>`npm install -D postcss-cli
>npm install -D --save autoprefixer
>如果发生报错，并且查看到如下的错误信息
>
>```
>path /home/sky/work/code/learning/docsy/>node_modules/hugo-extended
>command failed
>command sh -c node postinstall.js
> ✖ Hugo installation failed. :
> node:internal/process/promises:391
>    triggerUncaughtException(err, true />*fromPromise*/);
>   	^
>RequestError: getaddrinfo ENOTFOUND github.com
>```
>
>```
>npm config set registry <https://registry.npmmirror.com>
>npm config set proxy <http://192.168.2.1:7890>
>npm config set https-proxy <http://192.168.2.1:7890>
>```
>
>如果遇到报错信息：
>Failed to connect to github.com port 443 after 21045 m
>connect to github.com port 443 after 21045 ms: Could not >connect to server
>注意修改成自己的IP和端口号
>
>````
>git config --global http.proxy <http://127.0.0.1:7890>
>git config --global https.proxy <http://127.0.0.1:7890>
>````

## 站点骨架

每个 Hugo 项目都是一个目录，其中的子目录贡献于站点的内容、结构、行为和呈现。

在创建新站点时，Hugo 会生成一个项目骨架。例如，以下命令：  
利用hugo new site myblog(此时需要用到hugo.exe,假设存放在bin下),会在bin下生成myblog
```
myblog/
├── archetypes      #新建内容的模板（原型），方便统一管理文章格式，用于新建内容时自动填充默认 Front Matter
│   └── `default.md`
|--assests              #目录包含通常通过资源管道传递的全局资源。包括图片、CSS、Sass、JavaScript 和 TypeScript 等资源。
├── hugo.toml           # 博客站点的配置文件
├── content             # 博客文章所在目录.目录包含组成站点内容的标记文件（通常是 markdown）和页面资源
├── data                #目录包含用于增强内容、配置、本地化和导航的数据文件（JSON、TOML、YAML 或 XML），供模板调用
|----i18n               #目录包含多语言站点的翻译表。
├── layouts             # 自定义网站布局。目录包含将内容、数据和资源转换为完整网站的模板。决定网站的外观和布局。主题通常也会提供一套layouts，当你用自定义（不使用主题）时候可以在此覆盖主题默认模板。（hugo 初始化的layouts并不包含任何主题）
├── static              # 一些静态内容，目录包含在构建站点时将复制到 public 目录的文件，例如 .ico、.txt 和用于验证站点拥有权的文件。在引入 页面包 和 资源管道之前，static 目录也用于存放图片、CSS 和 JavaScript 等资源
└── themes              # 博客主题， 目录包含一个或多个主题，每个主题位于自己的子目录中。包含自己的layouts、static、配置文件等。启用主题后，Hugo首先会从主题中加载布局文件，再加载站点内自定义的覆盖文件
根据需要，可以将站点配置组织到子目录中：
|---config/                    #目录包含站点配置，可能分为多个子目录和文件。对于配置较少或不需要在不同环境中以不同方式运行的项目，项目根目录中的单个 hugo.toml 配置文件就足够了。
|___ _default/     
|_____config.toml #全局配置文件
```

- config.toml

  Hugo的全局配置文件，用于定义站点的基本信息、URL、语言、主题、菜单等。也可以使用config.yaml/config.json

- content/

​	存放所有博客文章和页面。每个markdown文件的Front matter中定义标题、日期、草稿状态、标签与分类等信息。

​	实例文件：

	title:"我的第一篇文章"
	date:2024-03-21
	draft:false
	tags:["入门"、“Hugo”]
	categories:[“技术博客”]
	这里是文章内容

- archtypes/

​	定义新建内容时所用的模板（原型），方便统一管理文章格式。你可以自定义默认模板以满足特定格式要求

- layouts/

  存放网站页面模板文件，决定网站的外观和布局。主题通常也会提供一套layouts，当你需要自定义时可以自此覆盖主题默认模板

- static/

  内容所有不会经过Hugo处理的静态文件，如图片、CSS文件、JS文件等。生成网站时，这些文件会直接复制到输出目录。

- themes/

  存放第三方主题，每个主题通常都包含自己的layouts、static、配置文件等。启用主题后，Hugo会先从主题中加载布局文件，再加载站点内自定义的覆盖文件。
  

1. 利用Hugo命令构建站点时，Hugo 会创建一个 public 目录，目录包含发布的网站，在运行 hugo 命令时生成。Hugo 根据需要重建此目录及其内容。
2. 通常还会创建一个 resources 目录：目录包含 Hugo 资源管道的缓存输出，在运行 hugo 或 hugo server 命令时生成。默认情况下，此缓存目录包括 CSS 和图片。Hugo 根据需要重建此目录及其内容
3. Hugo 创建了一个联合文件系统，允许将两个或多个目录挂载到同一位置。例如，假设您的主目录包含一个 Hugo 项目的目录，另一个目录包含共享内容.您可以使用挂载（mounts）在构建站点时包含共享内容。在站点配置中
4. 当两个或多个文件具有相同路径时，优先级顺序遵循挂载的顺序。例如，如果共享内容目录包含 books/book-1.md，则会被忽略，因为项目的 content 目录先被挂载。
5. 将archetypes/default.md,"+"改成"-","="改成"+"，因为这个时toml格式的，我们要改成yaml格式

## 配置主题

1. [下载主题](https://themes.gohugo.io/)

​	以Stack为例，下载[发布页面](https://github.com/CaiJimmy/hugo-theme-stack).把解压好的主题放在themes下，并把后面的版本号如`3.3.10`去掉

​	或者将存储库克隆到 `themes/hugo-theme-stack`

​	`git clone https://github.com/CaiJimmy/hugo-theme-stack/  themes/hugo-theme-stack`

​	或者如果您已经在您的网站中使用 Git，则可以通过在 Hugo 网站的根目录中运行以下命令将主题添加为子模块：

​	`git submodule add https://github.com/CaiJimmy/hugo-theme-stack/  themes/hugo-theme-stack`	

2. 把子模块的hugo-theme-stack里的layouts复制出来，复制到myblog下的layouts

3. 在hugo-theme-stack里examplesite里面的content和hugo.yaml,复制到myblog 下，然后把原来的hugo.toml删掉

   ```yaml
   示例
   baseurl: https://example.com/ 
   languageCode: en-us
   theme: hugo-theme-stack#指定主题
   title: Example Site
   copyright: Example Person
   DefaultContentLanguage: zh-cn# 默认语言
   ```

4. 然后在终端执行hugo，进行构建（如果有一些我们没有，删除content下post的内容，只留下chinese-test）

5. 同一个文件可以通过多个markdown，后缀名不同来实现。默认的index就是默认的名字 `zh-cn# 默认语言`，默认的主题下的名字。如果。即content/post/chinese-test下的
   index-zh-cn.md可以通过index-zh-cn来改变在中文界面i显示。index-en会在英文界面下显示。

​	这个里面有cataglories分类和用来打tags
archetypes/default.md

​	文章模板
draft改成false，否则不会显示

9. 如何快速创建一个文章？`hugo new potst/test/index.md`,就生成了`test/index.md`,将draft:true改成draft:false（此时是在content/post下）

   ```markdown
   title: Chinese Test
   description: 这是一个副标题
   date: 2020-09-09
   slug: test-chinese
   image: helena-hertz-wWZzXlDpMog-unsplash.jpg
   categories:
       - Test
       - 测试
       - HLE
   tags:
       - lf
   ```
   
### 常用命令

| 命令                 | 说明           |
| :------------------: | :------------: |
| hugo new post/test/index.md | 创建新文章。新建文章后，Hugo会在`content/post`目录下生成一份Markdown文件，并根据`archetypes`中的模板填充默认Front Matter |
| hugo server -D | 启动本地服务器预览，使用`-D`参数可包含草稿内容进行预览 |
| hugo | 构建站点（生成静态文件到public/目录） |
| hugo --cleanDestinationDir | 清理构建文件并重新生成 |
| hugo --minify | 构建并压缩HTML/CSS/JS文件（适合生产部署） |
| hugo new site [path] | 创建一个新站点 |
|hugo server| 启动本地服务器预览 |
|hugo config| 显示站点配置信息 |
|hugo list drafts| 列出所有处于草稿状态的文章 |

常用参数

- -D ,--buildDrafts:包括草稿文章
- -F，--buildFuture:包括未来发布的文章
- -E，--buildExpired：包括已过期的文章
- --minify:生成时压缩输出文件
- --gc:构建时运行垃圾回收

### 404 Page Not Found

__注意，一旦网站可以建立，那么除非你做一个新的文件，否则就一直404__

1.  hugo server --theme=your_theme_name(echo "theme = 'ananke'" >> hugo.toml)，这个相当于向hugo.toml添加theme
2.  删去 hugo.toml,保留config.toml

**推荐**：在 `config.toml` 中写 `theme = "your_theme_name"`

**临时**：命令行 `hugo server --theme=your_theme_name`

## Github推送自动化

在使用 GitHub Pages 构建并托管博客时，我们面临一个常见问题：如何在保持源码安全的同时，将构建好

的 **public** 文件用于页面展示。直接丢上去的往往是public文件。为了解决这一问题，我们可以通过创建两个 GitHub 仓库来实现不同用途的分离和自动化管理。

1. 源码仓库（source_blog）
   - 用于存储博客相关的源码， 包括markdown文件、配置信息等未构建的内容
   - 设置为Private仓库
2. 展示仓库（blog_show)
   - 用于存储构建后的文件（如public文件夹），供Github Pages或其他托管服务使用
   - 设为Public仓库，确保可以正常访问页面

### 自动化流程

利用**Github Actions**或脚本实现如下自动化：

1. 在源码仓库更新时触发构建操作，生成博客所需的静态文件
2.  将生成的文件自动推送到展示仓库，无需手动干预

Settings->Developer Settings->Personal access tokens -> Tokens(classic),勾选repo和workflow，过期时间选择永远不过期

generate token，然后复制生成的token

点开**source_blog**,Security-Secrets and variables-Actions-Repository secrets,创建一个新的。

自动化代码(deploy.yml)，

修改分支改成master

将.github_hugo移到blog下，并且去掉`_hugo`,作为部署文件

git init 创建.git 文件

EXTERNAL_REPOSITORY:`xx/blog_show`，展示的博客

blow_show里所展示的就是public里面的内容

blow_show>Settings>Pages>Build and delployment，改成 master 和root

你可以在根目录创建一个批处理脚本，用来快速启动本地服务器并使用 chrome 打开网页。

```
本地运行.bat
@echo off
echo [本地运行]
start chrome http://localhost:1313/ #默认开放1313端口
hugo server
pause
```

## 使用Netlify

Add newproject > import an existing project >选择blog_show

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

3. 
   在 Netlify 添加自定义域

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
   >  “访问 `blog.chenalna.site` 时，请先去找 `chenalna.netlify.app`”。

   阿里云并不知道 `chenalna.netlify.app` 是不是你的站点，也不会给你的网站签 SSL 证书。
    它只是把访问者“指路”给 Netlify。

2.Netfliy作用

​	Netlify 是**托管服务商**，它必须：

- **确认这个域名是你的**（防止别人盗用你的域名指到他们的服务器）
- **为这个域名签发 SSL 证书**（HTTPS 加密）
- 配置站点路由，把 `blog.chenalna.site` 的请求交给你的博客程序

> 所以你在 **Netlify → Domain management** 添加域名，
>  就是告诉 Netlify：
>  “这个域名是我的，DNS 我已经指到你们这里，请为它提供服务并签证书。”

3.  总结
	
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
   解析这个域名就行。

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
   。 即使连接的是 Netlify 的 IP，
   Host 告诉 Netlify：“我访问的是 `blog.chenalna.site` 项目。”

	5️⃣ Netlify 服务器返回内容

- Netlify 根据 Host 找到对应的项目（你 GitHub 部署的静态文件）。
- 直接返回 **HTML/CSS/JS** 等静态资源。
- 因为是静态站点，返回的就是**最终网页文件**，不需要再发起其他“对象请求”才能获取主体内容（除非页面里引用了图片、JS、CSS，这些会触发额外的 HTTP 请求）。

| 域名类型                                  | 作用                                           | 是否必须   |
| ----------------------------------------- | ---------------------------------------------- | ---------- |
| **Netlify 子域名** `chenalna.netlify.app` | Netlify 自动分配，始终可用，方便测试或直接访问 | ✅ 自动拥有 |
| **自定义域名** `blog.chenalna.site`       | 你绑定的独立域名，用于品牌化访问               | 可选       |

它们共存，不冲突，**访问最终落在同一个 Netlify 服务器和同一份内容上**。



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
