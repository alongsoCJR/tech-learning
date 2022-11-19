# Kafka学习笔记

## 1. kafka前瞻—架构维度

kafka是什么？消息中间件

服务——>服务 

网络到分布式

1. 单点问题 2. 性能问题

分布式：一致性，可靠性，可扩展性



### AKF

x-高可用 横向扩展，水平复制

y-业务划分 功能分解扩展，比如微服务

z-数据分区，比如分库分表



### 数据处理

大数据

无关的数据 必然分治——>无关的数据就分散到不同的分区里，以追求并发并行

有关的数据 聚合——> 有关的数据，一定要按原有顺序发送到同一分区里

分区内部有序，分区外部无序



### Kafka AKF分析

y轴：topic，不同的业务使用不同topic

z轴：partiton，对无关的数据打散到不同的分片，分而治之。将相关的数据按顺序聚合到同一个分片

x轴，对parttion进行副本备份，副本（理论上可以读写分离，但容易出现一致性问题，干脆只能在主P上进行读写）



### Zookeeper

单机管理->主从集群   分布式协调，zk不用于存储

broker与partition的关系？

broker与zookeeper的关系？

controller

Metadata：topic，partition，broker

旧版本：producer是通过zookeeper获取集群节点信息的

新老版本的区别：角色之间通信，在业务层次上不再依赖zookeeper（减少zk的负载）



### Producer

在并发情况下，注意一致性（顺序性保证）的问题
```sql
lock() { 
		sql
		producer.produce()
} unlock();

```


数据保存在哪里？

kafka的broker的partition里



### Consumer

consumer与patition的关系：n:1/ 1:1

思考，consumer与patition的关系1:n可不可以? 
破坏有序性



### group

不同业务组之间，需要消费同一topic的数据，可以使用不同的group

在单一的使用场景下，先要保证，即便追求性能，用多个consumer，应该注意，不能一个分区由多个consumer消费

数据的重复利用是站在group上



### offset

比如consumer重启，会不会导致数据重复消费和丢失，围绕的是消费的进度offset

起初consumer在runtime里维护自身的consumer

旧版本的offset是通过consumer与zookeeper通信维护的

新版kafka能自己维护offset

offset持久化节奏，频率，先后？

两大问题：

1. 丢失
2. 重复消费

异步的：每间隔5s，先处理业务逻辑，异步提交offset，重复消费

同步的：处理业务逻辑，同步提交offset

Consume流程没处理好，提交offset在业务逻辑处理之前，导致丢失

hbase,es,myisam顺序写

新版offset的维护

Consumer->broker(runtime)->mem metadata->磁盘，持久层

### 总结
1. 本节课从分布式AFK角度，分析了kafka作为一个分布式消息中间件（高可用，高扩展），从架构角度对xyz轴分析，分别对应由副本，partition，topic的出现。
2. 同时既然作为一个集群，就需要有一个协调者，引入了zookeeper，新旧版本的kafka对zookeeper这块进行了比较大的升级。
3. zookeeper管理的本质其实是tomcat进程，逻辑意义是broker，里面会有一个controller（主）的概念
4. 为了消息的顺序性消费，引入了producer和consumer，以及从架构角度如何保证消息顺序消费，不重复消费，以及消息丢失等问题。
5. 为了解决丢失和重复消费的问题，引入了offset消息消费进度的概念，以及放在哪里进行维护比较好（zookeeper?kafka?三方比如redis/mysql）