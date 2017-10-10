---
title: gradle
date: 2017-03-06 21:13:10
category: OFBiz
tags: gradle
---

> [gradle](https://docs.gradle.org/current/userguide/tutorial_gradle_command_line.html)与maven功能相同，区别在于gradle是一个基于编程语言的build框架，maven是xml配置文件。孰好孰坏看你的喜好，编程的当然可以分模块，往上面抽象；xml呢最广泛有很多工具可以配合，而且maven文档写的很好好赞，xml的配置也不错。个人感觉在有IDEA的情况下选择maven；gradle我会在写个人的小程序时使用，牛人和实力雄厚的公司或许会选择gradle，自己去Google一下优劣即可。在学习之前先略一略Groovy哦。

# 首先，学习一下gradle的几个命令。
`gradle tasks --all`  列出本项目中的所有可执行task
(什么是task？就是写在build.gradle文件中的可以用`gradle taskName`执行的代码块)

原始的(不包括项目中自己写的)大概有这么几个task：
```
**Build Setup tasks**
init - Initializes a new Gradle build. [incubating]
wrapper - Generates Gradle wrapper files. [incubating]
**Help tasks**
buildEnvironment - Displays all buildscript dependencies declared in root project 'gradle'.
components - Displays the components produced by root project 'gradle'. [incubating]
dependencies - Displays all dependencies declared in root project 'gradle'.
dependencyInsight - Displays the insight into a specific dependency in root project 'gradle'.
dependentComponents - Displays the dependent components of components in root project 'gradle'. [incubating]
help - Displays a help message. 这个经常用用就行
model - Displays the configuration model of root project 'gradle'. [incubating]
projects - Displays the sub-projects of root project 'gradle'.
properties - Displays the properties of root project 'gradle'.
tasks - Displays the tasks runnable from root project 'gradle'.
```

`gradle help --task taskName`  对该task的一些具体信息

`gradle --help`下有：
```
USAGE: gradle [option...] [task...]

-?, -h, --help          Shows this help message.
-a, --no-rebuild        Do not rebuild project dependencies.
-b, --build-file        Specifies the build file. 指定要执行的build文件
-c, --settings-file     Specifies the settings file.
--configure-on-demand   Only relevant projects are configured in this build run. This means faster build for large multi-project builds. [incubating]
--console               Specifies which type of console output to generate. Values are 'plain', 'auto' (default) or 'rich'.
--continue              一个task failure后继续执行，但是其它依赖这个failure task的task都不会被执行了
-D, --system-prop       Set system property of the JVM (e.g. -Dmyprop=myvalue).
-d, --debug             Log in debug mode (includes normal stacktrace).
--daemon                Uses the Gradle Daemon to run the build. Starts the Daemon if not running.
--foreground            Starts the Gradle Daemon in the foreground. [incubating]
-g, --gradle-user-home  Specifies the gradle user home directory.
--gui                   Launches the Gradle GUI.
-I, --init-script       Specifies an initialization script.
-i, --info              Set log level to info.
--include-build         Includes the specified build in the composite. [incubating]
-m, --dry-run           Runs the builds with all task actions disabled. 展示task依赖，执行的先后循序，但不真正build
--max-workers           Configure the number of concurrent workers Gradle is allowed to use. [incubating]
--no-daemon             Do not use the Gradle Daemon to run the build.
--no-scan               Disables the creation of a build scan. [incubating]
--offline               The build should operate without accessing network resources.
-P, --project-prop      Set project property for the build script (e.g. -Pmyprop=myvalue).
-p, --project-dir       Specifies the start directory for Gradle. Defaults to current directory. 指定project的根目录，默认是当前目录
--parallel              Build projects in parallel. Gradle will attempt to determine the optimal number of executor threads to use. [incubating]
--profile               Profiles build execution time and generates a report in the <build_dir>/reports/profile directory. 在build命令执行时会产生一个report
--project-cache-dir     Specifies the project-specific cache directory. Defaults to .gradle in the root project directory.
-q, --quiet             Log errors only. 出错了才显示
--recompile-scripts     Force build script recompiling.
--refresh-dependencies  Refresh the state of dependencies.
--rerun-tasks           Ignore previously cached task results. 忽视cached上次task结果，强行执行
-S, --full-stacktrace   Print out the full (very verbose) stacktrace for all exceptions.
-s, --stacktrace        Print out the stacktrace for all exceptions.
--scan                  Creates a build scan. Gradle will fail the build if the build scan plugin has not been applied. [incubating]
--status                Shows status of running and recently stopped Gradle Daemon(s).
--stop                  Stops the Gradle Daemon if it is running.
-t, --continuous        Enables continuous build. Gradle does not exit and will re-execute tasks when task file inputs change. [incubating]
-u, --no-search-upward  Don't search in parent folders for a settings.gradle file.
-v, --version           Print version info.
-x, --exclude-task      把某个task排除在外,即使有task依赖它，它也不会被执行
```

# 举个栗子说一说gradle特性
## 重复task只执行一次

```java
task compile{
	doLast{
		println 'compile'
	}
}

task compileTest(dependsOn: compile){
	doLast{
		println 'test dependsOn compile'
	}
}

task test(dependsOn: [compile, compileTest]){
	doLast{
		println 'test dependsOn compile, compileTest'
	}
}

task dist(dependsOn:[compile, test]){
	doLast{
		println 'dist dependsOn compile, test'
	}
}
```
执行`gradle dist`：
```java
:compile
compile
:compileTest
test dependsOn compile
:test
test dependsOn compile, compileTest
:dist
dist dependsOn compile, test

BUILD SUCCESSFUL

```
执行`gradle dist test`,`gradle dist test compile`也是一样的结果，每个task不管你调了几次，它只会执行**一次**。

## 可以用缩写或驼峰
只要能唯一区分
如 `gradle di` equeals `gradle dist`、`gradle cT` equeals `gradle compileTest`

# 获取build的信息
[The Project Report Plugin](https://docs.gradle.org/current/userguide/project_reports_plugin.html)

## List projects 项目列表
`gradle -q projects`
```
Root project 'ofbiz'
+--- Project ':applications'
|    +--- Project ':applications:accounting'
|    +--- Project ':applications:commonext'
|    +--- Project ':applications:content'
|    +--- Project ':applications:datamodel'
|    +--- Project ':applications:humanres'
|    +--- Project ':applications:manufacturing'
|    +--- Project ':applications:marketing'
|    +--- Project ':applications:order'
|    +--- Project ':applications:party'
|    +--- Project ':applications:product'
|    +--- Project ':applications:securityext'
|    \--- Project ':applications:workeffort'
+--- Project ':framework'
|    +--- Project ':framework:base'
|    +--- Project ':framework:catalina'
|    +--- Project ':framework:common'
|    +--- Project ':framework:datafile'
|    +--- Project ':framework:entity'
|    +--- Project ':framework:entityext'
|    +--- Project ':framework:images'
|    +--- Project ':framework:minilang'
|    +--- Project ':framework:security'
|    +--- Project ':framework:service'
|    +--- Project ':framework:start'
|    +--- Project ':framework:testtools'
|    +--- Project ':framework:webapp'
|    +--- Project ':framework:webtools'
|    \--- Project ':framework:widget'
+--- Project ':specialpurpose'
|    +--- Project ':specialpurpose:assetmaint'
|    +--- Project ':specialpurpose:bi'
|    +--- Project ':specialpurpose:birt'
|    +--- Project ':specialpurpose:cmssite'
|    +--- Project ':specialpurpose:ebay'
|    +--- Project ':specialpurpose:ecommerce'
|    +--- Project ':specialpurpose:example'
|    +--- Project ':specialpurpose:exampleext'
|    +--- Project ':specialpurpose:hhfacility'
|    +--- Project ':specialpurpose:ldap'
|    +--- Project ':specialpurpose:lucene'
|    +--- Project ':specialpurpose:myportal'
|    +--- Project ':specialpurpose:passport'
|    +--- Project ':specialpurpose:projectmgr'
|    +--- Project ':specialpurpose:scrum'
|    +--- Project ':specialpurpose:solr'
|    \--- Project ':specialpurpose:webpos'
\--- Project ':themes'
     +--- Project ':themes:bluelight'
     +--- Project ':themes:flatgrey'
     +--- Project ':themes:multiflex'
     +--- Project ':themes:rainbowstone'
     \--- Project ':themes:tomahawk'

To see a list of the tasks of a project, run gradle <project-path>:tasks
For example, try running gradle :applications:tasks
```

## List tasks
`gradle -q tasks` 只能看到有task group分组的，即所谓的*visible tasks*。
`gradle -q tasks --all`可以显示所有task，即所谓的*hidden tasks*。

## Show task usage details
`gradle -q help --task someTask` 显示相关task的相信信息

## Listing project dependencies
`gradle -q dependencies aProject bProject` 给出所选项目的树型依赖

## Listing project buildscript dependencies
`gradle buildEnvironment`所选项目所依赖的build脚本文件。

## Listing project properties
`gradle properties`




















