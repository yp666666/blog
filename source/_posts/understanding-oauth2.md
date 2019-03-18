---
title: understanding-oauth2
date: 2019-03-18 20:53:12
category:
tags: oauth2
---
> 头一次尝试翻译一篇文章，不准确处请指正，谢谢！

Source: [http://www.bubblecode.net/en/2016/01/22/understanding-oauth2/](http://www.bubblecode.net/en/2016/01/22/understanding-oauth2/)
如果OAuth2对你来说仍是一个模糊的概念或者你只想验证一下自己理解的是否准确，那么这篇文章就是为你准备的。

## 什么是 OAuth2?
[OAuth2](https://oauth.net/2/) 就是，你可以先猜一下，the OAuth Protocol (also called framework) 的第2版。
此协议允许第三方应用程序代表资源所有者授予对HTTP服务的有限访问权限，或允许第三方应用程序代表自己获取访问权限。访问权限由客户端（client）发起，它可以是一个网站或手机应用等。
第2版协议致力于简化上一版本并促进不同应用间的交互。
规范([Specifications](https://tools.ietf.org/html/rfc6749)) 仍处于起草期并且在不断被完善，但这并不能阻止它被实现并受到互联网大佬的青睐，像 Google、Facebook。
> 译者注：很好奇 spring-security-oauth2 是对 RFC 哪个版本的实现，大概是 6749和6750 版，最新的更新是 8252 版（for Native Apps），不知道区别在哪里。

## 基础知识
### Roles（角色）
OAuth2 定义了4种角色：
- 资源所属者（Resource Owner）：一般指你自己。
- 资源服务器（Resource Server）：托管（你的）私有数据的服务器（比如托管你个人资料和信息的Google）。
- 客户端（Client）：向资源服务器发起请求的应用（PHP 网站、Javascript 应用或手机应用）。
- 授权服务器（Authorization Server）：向客户端下发token的服务器。这个token可以让客户端访问资源服务器。This server can be the same as the authorization server (same physical server and same application), and it is often the case.（不知道这句怎么翻译）

### Tokens
Tokens 是授权服务器随机生成的字符串，当客户端来请求时下发的。
Token 分为两种：
- Access Token：这个非常重要，因为它可以让第三方应用访问资源服务器上的用户数据。它放在客户端请求的Header或参数中。它不是永久的，授权服务器会规定它的过期时间。通常要尽可能保证它不被泄露，但这又很难做到，尤其是客户端是web浏览器而且是用JavaScript去请求。
- Refresh Token：这个token会跟Access Token一起下发，但不同于后者，不是客户端每次发起请求到资源服务器都会携带。它只是用来当Access Token过期时客户端向授权服务器获取新的Access Token。出于安全考虑，可能并不会获取到Refresh Token，我们后面会讲到时在什么场景下拿不到它。

### Access Token scope（AT 作用范围）
作用范围是指Access token有哪些访问权限。授权服务器会定义一个作用范围列表。客户端必须指定它所请求的范围。所申请的范围越小，被授权的几率就越大。
> 更多：[http://tools.ietf.org/html/rfc6749#section-3.3](http://tools.ietf.org/html/rfc6749#section-3.3)

### HTTPS
OAuth2 要求客户端和授权服务器之间使用HTTPS协议，因为会有敏感信息（tokens或证书等）。事实上并没有强制你这样做，但你要知道不这样会有很大的安全漏洞。

## 注册成为客户端
既然你想通过OAuth2从资源服务器访问数据，你首先要向授权服务器注册成为一个客户端。
每个提供者都可以自由实现这一点。OAuth2只是定义了客户端必须的参数和授权服务器返回的参数。
下面是规定的参数：
**客户端注册**
- 应用名字：即客户端应用名。
- 跳转URLs：收到authorization code和access token后客户端的跳转地址。
- 授权类型（Grant Type(s)）：客户端申请的授权类型。
- Javascript Origin (可选)：通过XMLHttpRequest访问资源服务器时指定的hostname。

**授权服务器返回**
- 客户端ID（Client Id）：唯一的随机字符串。
- 客户端秘钥 (Client Secret)：必须保密的秘钥。
> 更多：[RFC 6749 — Client Registration](https://tools.ietf.org/html/rfc6749#section-2)

## 授权类型
根据客户端的位置和性质，OAuth2定义了4种类型。
### 授权码类型（Authorization Code Grant）
1. 何时应使用？
当客户端是web服务器时应该使用。它允许你获取一个长期有效的token，因为你可以用refresh token去刷新它（如果授权服务器允许的话）。
2. 例如：
- 资源拥有者：你。
- 资源服务器：a Google Server.
- 客户端：任何web服务器。
- 授权服务器：a Google Server.
3. 场景：
    1. 一个web应用想要获取你的Google信息。
    2. 你在此web应用上被跳转到Google的授权页面。
    3. 如果你点允许，Google会发一个authorization code给web的回调接口。
    4. 然后，web应用用这个code从认证服务器（Google）获取一个access token。
    5. web应用这时可以通过access token访问资源服务器（Google）上的你的资料。  

你并不能见到access token，它会被保存在web（例如session）中。Google还会发送其他信息，比如token过期时间甚至一个refresh token.  
这是个理想的场景，并且相对安全点，因为access token没有在client端（web浏览器）传递。

### Implicit Grant
### Resource Owner Password Credentials Grant
### Client Credentials Grant

## Access token usage


## Appendix
[OAuth 2.0 Security Best Current Practice](https://tools.ietf.org/id/draft-ietf-oauth-security-topics-06.html)
[springboot2-with-oauth2-integration](https://pattern-match.com/blog/2018/10/17/springboot2-with-oauth2-integration/)
[Spring Boot and OAuth2](https://spring.io/guides/tutorials/spring-boot-oauth2/)


