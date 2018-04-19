---
title: hibernate
date: 2018-04-19 22:30:51
category:
tags: hibernate
---
# hibernate 结果集映射
## Result -> Map
```java
List<Map> phoneCallTotalDurations = entityManager.createQuery(
    "select new map(" +
    "    p.number as phoneNumber , " +
    "    sum(c.duration) as totalDuration, " +
    "    avg(c.duration) as averageDuration " +
    ")  " +
    "from Call c " +
    "join c.phone p " +
    "group by p.number ", Map.class )
.getResultList();
```

需要注意的点：
1. 凡是数字类型都是`BigDecimal`，布尔类型成了`Integer`，如：*BigInteger id = (BigInteger) item.get("id")*；
2. like 的写法；
```java
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;

public List<xxxVo> listAllMembers(Long orderUsedTimeId, String keyword, Integer page, Integer count) {
    String haskey = "select u.id, u.nickname, u.background, u.portrait, c.name as companyName, case when m.id is null then '0' else '1' end as isInvited from t_user u join t_company c on u.companyId=c.id left join t_meetinginvitationrecord m on u.id=m.beInvitedUserId and m.orderUsedTimeId=:orderUsedTimeId where u.nickname like :keyword";
    List<Map> list = Member.entityManager()
                .createNativeQuery(haskey)
                .setParameter("keyword", "%" + keyword + "%")
                .setParameter("orderUsedTimeId", orderUsedTimeId)
                .setFirstResult((page - 1) * count)
                .setMaxResults(count)
                .unwrap(SQLQuery.class).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
    List<xxxVo> result = new LinkedList<>();
    list.forEach(item -> {
        BigInteger id = (BigInteger) item.get("id");
        String nickname = (String) item.get("nickname");
        String background = (String) item.get("background");
        String portrait = (String) item.get("portrait");
        String companyName = (String) item.get("companyName");
        Boolean isInvited = ((String) item.get("isInvited")).equals("0") ? false : true;
        result.add(new xxxVo(id.longValue(), nickname, background, portrait, companyName, isInvited));
    });
    return result;
}
```

## Result -> List<>
都不怎么好，非得选就推荐用它了。
```java
List<Object[]> persons = entityManager.createQuery(
    "select distinct pr, ph " +
    "from Person pr, Phone ph " +
    "where ph.person = pr and ph is not null", Object[].class)
.getResultList();
```

## Result -> Stream<>
[http://hibernate.org/](http://hibernate.org/)
```java
try ( Stream<Object[]> persons = session.createQuery(
    "select p.name, p.nickName " +
    "from Person p " +
    "where p.name like :name" )
.setParameter( "name", "J%" )
.stream() ) {

    persons
    .map( row -> new PersonNames(
            (String) row[0],
            (String) row[1] ) )
    .forEach( this::process );
}
```