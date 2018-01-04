---
title: shiro
date: 2017-09-03 14:23:57
category:
tags:
---
> 好的老师，能让你事半功倍、信心倍增。

[shiro.apache.org](https://shiro.apache.org/)
[跟我学shiro](http://jinnianshilongnian.iteye.com/blog/2018398)

shiro是一个安全框架，主要模块有认证(Authentication)、授权(Authorization)、加密(Cryptography)、会话管理(Session Management).

/WEB-INF/shiro.ini
```xml
[main]
securityManager = auth.MySecurityManager
myRealm = auth.MyRealm
securityManager.realm = $myRealm
sessionManager = org.apache.shiro.web.session.mgt.DefaultWebSessionManager
securityManager.sessionManager = $sessionManager
cacheManager = org.apache.shiro.cache.MemoryConstrainedCacheManager
securityManager.cacheManager = $cacheManager
authc.loginUrl = /login

[urls]
/login = authc
/houses/cowshed.jsp = perms[visit:cowshed]
/houses/palace.jsp = authc,roles[admin]
/users/** = authc,roles[admin]
/pages/** = authc,roles[admin]
/logout = logout

# -----------------------------------------------------------------------------
# Users and their (optional) assigned roles
# username = password, role1, role2, ..., roleN
# -----------------------------------------------------------------------------
[users]
root = passwd, admin
guest = guest, guest
presidentskroob = 12345, president
darkhelmet = ludicrousspeed, darklord, schwartz
lonestarr = vespa, goodguy, schwartz

# -----------------------------------------------------------------------------
# Roles with assigned permissions
# roleName = perm1, perm2, ..., permN
# -----------------------------------------------------------------------------
[roles]
admin = *
guest = visit:cowshed
schwartz = lightsaber:*
goodguy = winnebago:drive:eagle5
```

#### [main]
`securityManager.realm = $myRealm`  通过反射调用manager的setRealm方法

#### [urls]
`/login = authc`  有authc就每次都触发一次认证
`/houses/cowshed.jsp = perms[visit:cowshed]` 多个用逗号隔开
`/houses/palace.jsp = authc,roles[admin]`  多个用逗号隔开
这里的urls是有顺序的，从上到下依次匹配，所以写时要注意。
