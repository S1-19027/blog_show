---
date : "2025-09-23" 
title: 遇到的问题
description: 远比想象的多
weight: 2
series: "test"
categories:
    - Hugo
    - Web
tags:
    - Hugo
---

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

### 使用Git遇到的错误  

1.   子模块可能没有被正确初始化，或者 .gitmodules 文件中的配置与实际的子模块路径不匹配.

```bash
/usr/bin/git -c protocol.version=2 submodule update --init --force
Error: fatal: No url found for submodule path 'themes/hugo-theme-bootstrap4-blog' in .gitmodules
Error: The process '/usr/bin/git' failed with exit code 128  
```

​	解决方法：添加子模块
  git submodule add <https://github.com/theNewDynamic/gohugo-theme-ananke.git> themes/ananke.

2.  .Site.Social被废弃

```bash
ERROR deprecated: .Site.Social was deprecated in Hugo v0.124.0 and subsequently
removed. Implement taxonomy 'social' or use .Site.Params.Social instead.
ERROR deprecated: .Site.Authors was deprecated in Hugo v0.124.0 and subsequently
removed. Implement taxonomy 'authors' or use .Site.Params.Author instead.
```

​	解决方法
如报错信息，找到对应并替换即可

3. `range can't iterate over Your Name`，range尝试迭代Your Name，但是个字符串

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

  **方法 1**：修改 config.toml 中的 author 配置
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

  **方法2**：如果 author 必须是一个字符串（例如 author = "Your Name"），你需要修改模板文件，避免使用 range 迭代 .Site.Params.Author。
  例如，将 twitter_cards.html 中的代码：

  ```go
{{ range .Site.Params.Author }}

  {{ .twitter }}

{{ end }}
  ```

  改为：
  `{{ .Site.Params.Author }}`

  **方法 3**：调试模板

  在 `twitter_cards.html` 中打印上下文，看看实际传入了什么：

  ```
{{ printf "%#v" . }}
  ```

  - 可以快速发现传入的上下文是否有 `twitter` 字段。
  - 用于排查问题，非常有用。

  **方法 4**：临时禁用 Twitter 卡片

  如果不需要 Twitter 卡片，可以在 `head-meta.html` 注释掉调用：

  ```
{{/* {{ partial "twitter_cards.html" . }} */}}
  ```

  - 避免报错，让网站能正常生成。
  - 适合快速排查或暂时不需要社交卡片功能。

4. hugo版本设置

```bash
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

​	如果你**必须**把 fork 的 master 恢复到推送前的状态（例如不想把修改放在 master 上）：

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

   ```
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

## 问题二：

我fork了一个子模块，https://github.com/S1-19027/hugo-theme-stack，我想获得最新的来自master的主仓库https://github.com/CaiJimmy/hugo-theme-stack的版本，我该怎么做？

明白了，你的情况是典型的 **fork 后同步 upstream 仓库**。我给你详细步骤（假设你在本地已经 clone 了你的 fork）：

1.  添加 upstream 远程仓库

进入你本地的主题目录：

```
cd path/to/hugo-theme-stack
```

添加原仓库为 `upstream`：

```
git remote add upstream https://github.com/CaiJimmy/hugo-theme-stack.git
```

2.  获取 upstream 的最新内容

```
git fetch upstream
```

这会把 upstream 的分支（例如 `master`）抓到本地，但不会自动合并。

3.  合并 upstream 的 master 到你本地 master

```
git checkout master
git merge upstream/master
```

- 如果没有冲突，会直接合并成功。
- 如果有冲突，需要手动解决冲突，然后 [`git commit`](#step1)。

> ⚡️ 可选：如果你希望**直接用 upstream 覆盖你的 master**（丢弃本地修改）：
>
> ```
> git checkout master
> git reset --hard upstream/master
> ```

4. 推送更新到你的 fork（GitHub 上）

```
git push origin master
```

这样你 fork 的仓库就同步了主仓库的最新版本。

### 小结

1. 添加 upstream
2. `git fetch upstream`
3. 合并/重置到 upstream/master
4. `git push origin master`

## 问题二续

**那么如果我要更新一些子模块内容，当然对远程仓库没有权限push，只能在我的fork下更改咯？**

同步 upstream 最新内容（可选）

如果你想先基于主仓库最新版本更新 fork：

```
git fetch upstream
git checkout master
git merge upstream/master    # 或者 git reset --hard upstream/master
```

然后推送到你 fork：

```
git push origin master
```

 更新子模块内容

假设你在你的 fork 下更新了子模块（比如主题中的子模块或者 Hugo site 里的 `themes/hugo-theme-stack`），流程如下：

A. 初始化/更新子模块

```
git submodule init
git submodule update --remote --merge
```

或者指定分支：

```
git submodule update --remote --merge -- <path-to-submodule>
```

- `--remote` → 从子模块远程仓库拉取最新
- `--merge` → 自动合并到本地子模块

B. 提交子模块更新到你的 fork

子模块更新实际上是父仓库对 **子模块 commit 指针的更新**：

```
git add <path-to-submodule>
git commit -m "Update submodule to latest commit"
git push origin master
```

提交到 GitHub

- 你只能 push 到你 fork 的 `origin`
- 原仓库 `upstream` 没有权限 push，所以主仓库不会受影响
- 其他人如果想用你的更新，需要 clone 你的 fork

注意事项

1. **子模块本身的修改**
   - 如果子模块本身不是你 fork 的仓库，提交修改到子模块需要你 fork 子模块或者在本地修改，然后更新父仓库指针
2. **保持 fork 与 upstream 同步**
   - 定期 `git fetch upstream && merge upstream/master`，保证你的 fork 能跟上原仓库

------

⚡ 总结

1. 没权限 push → 所有改动只能在 fork 下操作
2. 更新子模块 → 更新子模块 commit，提交父仓库更新
3. push 到 fork → `git push origin master`
4. 保持 fork 与 upstream 同步 → 定期 `fetch` & `merge`

## 问题二续

<a id="step1"></a>

**在新分支上做 merge 测试**

为了安全起见，先新建一个临时分支：

```
git checkout -b merge-test
```

然后合并远程 master：

```
git merge origin/master
```

- 如果本地和远程没有冲突 → 自动合并
- 如果有冲突 → Git 会提示哪些文件有冲突，标记为 **unmerged**

查看差异（diff）

- 查看所有冲突文件的差异：

```
git status
```

- 查看单个文件差异：

```
git diff <file>
```

- 也可以使用更直观的工具：

```
git difftool <file>
```

> 你可以用 VS Code、Sourcetree、GitKraken 等可视化工具来比对本地与远程修改，选择保留哪一边。

手动解决冲突

Git 会在冲突文件里插入标记：

```
<<<<<<< HEAD
# 你的本地改动
=======
# 远程 origin/master 改动
>>>>>>> origin/master
```

- 修改文件，保留你想要的内容
- 保存后标记为已解决：

```
git add <file>
```

完成 merge 并提交

```
git commit
```

> 如果合并过程中没有冲突，这步 Git 会自动生成 merge commit；
>  如果手动解决冲突，需要你写 commit 信息。

 推送到 fork

```
git push origin merge-test
```

- 这样你就有一个**安全的测试分支**
- 如果满意，可以再合并到 master：

```
git checkout master
git merge merge-test
git push origin master
```

## 问题二续

**创建一个分支来做修改，而不是直接在 master 上改**，原因如下：

为什么要用分支

1. **保持 master 与 upstream 同步**
   - master 分支通常用来跟踪主仓库（upstream）最新版本
   - 如果直接在 master 上改，一旦你下次同步 upstream，就容易出现冲突或覆盖你的改动
2. **便于管理修改**
   - 新建分支（比如 `change` 或 `update-submodule`）可以专门存放你的自定义修改
   - 需要回退或测试时更安全，不影响 master
3. **方便 Pull Request**（如果将来想贡献回主仓库）
   - upstream 的 PR 一般要求基于 master 的 feature 分支
   - 用独立分支可以只包含你的改动，不带本地 merge 或同步历史

推荐操作流程

假设你要修改子模块或主题内容：

```
# 切到 master 并同步 upstream
git checkout master
git fetch upstream
git merge upstream/master

# 创建新分支
git checkout -b change

# 修改子模块或主题
git submodule update --remote --merge
# 或其他修改

# 提交改动
git add .
git commit -m "Update submodule / custom changes"

# 推送到 fork 的新分支
git push origin change
```

这样：

- `master` 始终和 upstream 保持一致
- 你的修改都在 `change` 分支，可以随时合并或删除
- 如果想合并到 master，只需 `git checkout master && git merge change` 或发 Pull Request

------

💡 小结

- **有必要创建分支**：安全、便于管理、避免冲突
- **命名建议**：`update-submodule`、`change-theme`、`feature-xxx`
- **master 保持干净**，只用于同步 upstream

## 安装hexo

npm install -g hexo-cli

## 如何建立自己的（博客）域名 

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

3. push_server.bat

​	**自动把本地 Hugo 生成网站推送到远程服务器部署**

4. creat_post_new_theme.bat

   **省去了用hugo_new建立 新文章的操作**

5. creat_post.bat

   在特定主题下新建一个文章的操作

## 批处理程序遇到的问题

1. `'tory' is not recognized as an internal or external command, operable program or batch file. 请输入Slug:`

解决方法一：

在两行命令中间加一个空行

```batch
echo 文件存在。
 
set /p input=请选择: 
```

解决方法二：

给 echo 输出的内容结尾去掉中文字符

```batch
echo 文件存在
 
set /p input=请选择:
```



## Nginx遇到的问题

```
│ A new version (/tmp/tmp.QB1PQknVLa) of configuration file /etc/ssh/sshd_config is available, but the version installed currently has been locally modified.  │                                           
│ What do you want to do about modified configuration file sshd_config?       
```

选择`Install the package maintainer's version`即可.



## 附录

### 参考文献

### 版权信息

本文原载于[blog.chenalna.site](https://blog.chenalna.site/)，遵循 CC BY-NC-SA 4.0 协议，复制请保留原文出处。

