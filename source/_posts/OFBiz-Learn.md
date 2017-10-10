---
title: OFBiz Learn
date: 2017-03-04 13:42:07
category: OFBiz
tags:
---

# 初识OFBiz
[官网](https://ofbiz.apache.org/apache-ofbiz-project-overview.html)

Open For Business(OFBiz) 是一个企业应用框架，类似于Spring，主要针对ERP、CRM系统。
OFBiz使用 [Apache License Version 2.0协议](https://www.apache.org/licenses/LICENSE-2.0)，你可以不公开你的代码。

# Major Application Components
## Common Data
包括实体类等系统启动时加载的、一般很少变动的数据。

## Content
用于对数据的追踪。

## Security
访问控制。

## Party
可以是一个人，或一个Parties组。Party Group可以是一个公司，公司内部的一个机构，供应商或顾客等。
与Party相关的类型有
1. Contact Mechanisms(地址，手机，邮箱，URL……)
2. Roles(作为顾客，供应商，员工，经理，商人……)
3. 另一种可归为Party类的数据是Parties之间communication和agreement的信息。它可被Work Effort实体用来计划和追踪Parties之间的问题和解决方案。

## Product
公司出售或内部使用的商品，可以是goods或services

## Order
商品的排序。如顾客对一类商品的url请求，就会被Order package内的实体处理。

## Facility
一座大楼或一个地理位置。

## Shipment
跟踪进出货和进出货清单。

## Accounting
记账。

## Marketing
市场信息。

## Work Effort
可以是一个task，project，project phase，to-do item,Workflow Activity等。

> 需要注意的是，OFBiz放弃了Workflow Engines，改用Event Driven Architecture(EDA)和ECAs(SECA,EECA,MECA)。ECA是Event Condition Action的缩写。SECAs用于Services，EECA用于Entity，MECAs用于Mail。

## Human Resources
人力资源信息。

![主要应用部件](ofbiz.png)

# Architecture and System Organization
## Entities and Services
| Entity  | 作用   |
|:---|:---|
|basic entity |&#124; 与数据库表对应 |
|view-entity  |&#124; 组合实体类字段构成虚拟实体|

使用Entity Engine可以省去写sql，可以不必维护大量的CRUD持久层类。取而代之的是相对少量的xml配置文件。
每个Service只负责简单的特定的任务，由ECA去调度，所以扩展时也不必改变原来的逻辑代码。

## Web Framework and XML Mini-Languages
OFBiz Core Framework 提供了许多client-server、peer-to-peer框架，为了便于使用，所以推出一个‘XML Mini-Language’工具。


