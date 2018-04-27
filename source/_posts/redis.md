---
title: redis
date: 2018-04-26 09:14:31
category:
tags: redis
---
[github-redis](https://github.com/xetorthio/jedis/wiki/AdvancedUsage)

## Redis实现锁的简单方法
[SET](http://redisdoc.com/string/set.html)
`SET key value [EX seconds] [PX milliseconds] [NX|XX]`
```
EX second ：设置键的过期时间为 second 秒。 SET key value EX second 效果等同于 SETEX key second value 。
PX millisecond ：设置键的过期时间为 millisecond 毫秒。 SET key value PX millisecond 效果等同于 PSETEX key millisecond value 。
NX ：只在键不存在时，才对键进行设置操作。 SET key value NX 效果等同于 SETNX key value 。
XX ：只在键已经存在时，才对键进行设置操作。
```

```java
package moc.oreh.common;

import redis.clients.jedis.Jedis;

import java.util.concurrent.TimeUnit;

/**
 * Stateless Redis Lock
 *
 * examples:
 * 1. tryLock
 * <code>
 * boolean got = JedisLock.tryLock(key, token, time, TimeUnit, jedis);
 * if (got) {
 *     try {
 *         // do something
 *     } finally {
 *         JedisLock.unlock(key, token, jedis);
 *     }
 * }
 * </code>
 * 2. lock
 * <code>
 * JedisLock.lock(key, token, jedis);
 * try {
 *
 * } finally {
 *     JedisLock.unlock(key, token, jedis);
 * }
 * </code>
 */
public class JedisLock {
    /**
     * @param key
     * @param token
     * @param jedis
     */
    public static void unlock(String key, String token, Jedis jedis) {
        if (token.equals(jedis.get(key))) {
            jedis.del(key);
        }
    }

    /**
     * @param key
     * @param token
     * @param jedis
     * @return
     */
    public static void lock(String key, String token, Jedis jedis) {
        for (; tryLock(key, token, jedis) == false; ) ;
    }

    /**
     * @param key
     * @param token
     * @param timeout
     * @param timeUnit
     * @param jedis
     * @return
     */
    public static boolean tryLock(String key, String token, long timeout, TimeUnit timeUnit, Jedis jedis) {
        timeout = timeUnit.convert(timeout, TimeUnit.MILLISECONDS);
        boolean got = tryLock(key, token, jedis);
        while (!got && 0 < timeout) {

            try {
                TimeUnit.MILLISECONDS.sleep(500);
            } catch (InterruptedException e) {
                //ignore
            }

            timeout -= 500;
            got = tryLock(key, token, jedis);
        }
        return got;
    }

    public static final int EXPIRED_TIME_IN_SECONDS = 60;

    private static boolean tryLock(String key, String token, Jedis jedis) {
        String got = jedis.set(key, token, "NX", "EX", EXPIRED_TIME_IN_SECONDS);
        return "OK".equals(got);
    }
}
```
此锁的特点：
1. 独占式、不可重入；
2. tryLock 不响应中断信号，也不修改中断标志；
3. EXPIRED_TIME_IN_SECONDS 为 60，可根据业务场景做相应修改；

为什么会这样设计？













