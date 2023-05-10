# Kafka学习笔记

## 2. kafka安装以及常用的命令

### zookeeper的安装

- brew方式安装
  - [参考博客](https://blog.csdn.net/jxq0816/article/details/78586555)
  - 启动zookeeper: zookeeper alongso_pro$ zkServer
  - 查看zookeeper的状态： zookeeper alongso_pro$ zkCli
  
- 解压缩方式安装：
  - [参考博客](https://blog.csdn.net/qi49125/article/details/60779877)
  - zookeeper安装目录：/usr/local/myapp/zookeeper-3.4.12
  - 进入zookeeper安装目录，启动zookeeper:sudo ./bin/zkServer.sh start
  - 停止zookeeper:sudo ./bin/zkServer.sh stop
  
  

### kafka的安装

- [brew方式安装](https://blog.csdn.net/u010046908/article/details/62229015)
  - 进入kafka安装目录，启动zookeeper：
    - bin/zookeeper-server-start /usr/local/etc/kafka/zookeeper.properties
  - 启动kafka：
    - bin/kafka-server-start /usr/local/etc/kafka/server.properties
- 解压缩方式安装：
  - 解压缩方式安装
    - 进入指定的文件（安装目录）创建logs文件夹，并且赋予用户能写 的权限（将/usr/local/myapp/kafka下的文件都赋予）
    - 启动zookeeper:
      - kafka alongso_pro$ ./bin/zookeeper-server-start.sh /usr/local/myapp/kafka/config/zookeeper.properties &
    - 启动kafka:
      - kafka alongso_pro$ ./bin/kafka-server-start.sh /usr/local/myapp/kafka/config/server.properties &
  - 遇到的问题
    - 启动消费者的时候报错：Connection to node -1 could not be established. Broker may not be available.
      - [参考博客](https://blog.csdn.net/getyouwant/article/details/79000524)、[参考](https://blog.51cto.com/ipcpu/2089105)
      - 傻逼了，根据端口访问加什么：
        - ./bin/kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --topic topic1 --from-beginning
    - zookeeper启动的时候报错  java.io.IOException: No snapshot found, but there are log entries. Something is broken!
      - [参考博客](https://www.panziye.com/java/bigdata/3078.html)

### kafka常用命令

```shell
-- 低于kafka2.2版本的所有的命令需要依赖zookeeper节点，不支持--bootstrap-server命令
-- 给kafka创建topic:
./bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
    - –create 创建主题命令
    - –zookeeper localhost:2181 指定zookeeper
    - –replication-factor 1 指定副本个数
    - –partitions 1 指定分区个数
    - –topic test 主题名称为“test”
-- 查看topic list
  - ./bin/kafka-topics.sh --list --zookeeper localhost:2181
-- 打开一个窗口输入命令创建一个生产者：
  - ./bin/kafka-console-producer.sh --broker-list 127.0.0.1:9092 --topic test


-- 高于2.2版本，支持--bootstrap-server命令
-- topic创建
./bin/kafka-topics.sh --create --bootstrap-server 127.0.0.1:9092 --replication-factor 1 --partitions 2 --topic test2

-- 查看topic
./bin/kafka-topics.sh --describe --bootstrap-server 127.0.0.1:9092 --topic test2

-- 查看消费者组消费的进度offset
./bin/kafka-consumer-groups.sh  --bootstrap-server 127.0.0.1:9092 --group consumer0 --describe

-- 消费消息
./bin/kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --topic test --from-beginning

-- 生产消息
./bin/kafka-console-producer.sh --bootstrap-server 127.0.0.1:9092 --topic test

-- 查看list
./bin/kafka-topics.sh --list --bootstrap-server 127.0.0.1:9092

-- 生产&发送键-值对消息
./bin/kafka-console-producer.sh --bootstrap-server 127.0.0.1:9092 --topic test --property parse.key=true

-- 消费&打印键-值对消息
./bin/kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --topic test --property print.key=true


```



### 参考资料

1. [topic创建参考](https://support.huaweicloud.com/usermanual-kafka/kafka-ug-180604018.html#kafka-ug-180604018__section1623746152018)
2. [操作参考](https://segmentfault.com/a/1190000021586525)
3. [官方文档](http://kafka.apache.org/documentation.html#introduction)





### topic+partition消费逻辑

#### partition

分区：桶

如果没有顺序上的约束的话：水平扩展

消息V

一旦消息（消息很多，但是消息种类一定很多），而且需要同一类消息的有序性

消息是KV，相同的key一定去打到一个分区里

Broker会保证producer同key（类型）消息的顺序

一个分区可能有不同的key，且不同的key是交叉的，相同的key在一个分区里没有排列在一起。



#### 拉取VS推送

推送：说的是server，主动去推送，网卡打满

拉取：consumer，自主，按需，去订阅拉取server的数据



#### 拉取粒度

如何拉取

1. Kafka consumer以什么粒度拉取消息

   >出于性能考虑，每次IO会批量拉取数据

如何维护

1. Kafka consumer以什么粒度更新&持久化offset?

   > 单线程：一条一条处理的时候，按顺序处理的时候，来更新offset，速度比较慢，硬件资源浪费
   >
   > 1-1多线程：offset维护？按条还是按批次？
   >
   > 什么情况下多线程的优势发挥到极致？具备隔离性
   >
   > 多线程的情况下，要加如记录级的判定顺序，决策更新谁的offset
   >
   > 2多线程：流式计算，充分利用线程



批次（如何保证顺序处理）

1. consumer拉取到消息用多线程还是单线程去处理？
2. Offset如何维护？



#### consume使用单线程与多线程的利弊

单线程：

按顺序，单条处理，offset就是递增的，无论对db，offset频率，成本有点高，CPU，网卡，资源浪费，粒度比较细

流式的多线程：

能多线程的多线程，但是，将整个批次的事务环节交给一个线程，做到这个批次，要么成功，要么失败，减少对DB的压力，和offset频率的压力，更多的去利用cpu和网卡硬件资源，粒度比较粗



