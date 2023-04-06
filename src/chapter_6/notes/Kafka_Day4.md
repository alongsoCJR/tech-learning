# Kafka学习笔记

## 4. ISR，OSR，AR，LW，HW，LEO，ACK原理理论

### kafkaIO

零拷贝—找周老师的IO课

sendfile(in, offset，out)

kafka对数据只是发送，没有加工的过程



### 分区的可靠性（CAP）

要解决一个问题，可能会引入其他问题，比如一致性问题



### 一致性

1. 强一致性
   1. 所有节点比必须ack
2. 最终一致性
   1. 过半机制
3. 弱一致性
   1. ISR（in-sync replicas），连通性&活跃性
   2. OSR（outof-sync replicas）,超过阈值时间（10s）,没有心跳
   3. AR(Assignes replicas)，面向分区的副本集合，创建topic的时候你给出了分区的副本数
   4. AR=ISR+OSR
4. ack=-1的时候，多个broker的消息进度是一致的
   1. 会与ISR相关的节点进行ack
5. tradeoff
   1. 不要强调磁盘的可靠性，转向异地多机的同步
   2. 如果拿磁盘做持久化，优先pagecache或者绝对磁盘
   3. 在多机集群分布式的时候，强一致性，最终一致性（过半，ISR）
   4. 总结：
      1. redis，宁可用HA，不用刻意追求AOF的准确性
      2. 像Kafka，我们追求ack=-1,要求磁盘的可靠性



### kafka弹性存储

1. LW：LowWatermark 数据裁剪
2. HW：High Watermark 高水位
3. LEO：LogEndOffset 



### TradeOff

Keeping track of what has been consumed is, surprisingly, one of the key performance points of a messaging system.
Most messaging systems keep metadata about what messages have been consumed on the broker. That is, as a message is handed out to a consumer, the broker either records that fact locally immediately or it may wait for acknowledgement from the consumer. This is a fairly intuitive choice, and indeed for a single machine server it is not clear where else this state could go. Since the data structures used for storage in many messaging systems scale poorly, this is also a pragmatic choice--since the broker knows what is consumed it can immediately delete it, keeping the data size small.

What is perhaps not obvious is that getting the broker and consumer to come into agreement about what has been consumed is not a trivial problem. If the broker records a message as consumed immediately every time it is handed out over the network, then if the consumer fails to process the message (say because it crashes or the request times out or whatever) that message will be lost. To solve this problem, many messaging systems add an acknowledgement feature which means that messages are only marked as sent not consumed when they are sent; the broker waits for a specific acknowledgement from the consumer to record the message as consumed. This strategy fixes the problem of losing messages, but creates new problems. **First of all, if the consumer processes the message but fails before it can send an acknowledgement then the message will be consumed twice. The second problem is around performance**, now the broker must keep multiple states about every single message (first to lock it so it is not given out a second time, and then to mark it as permanently consumed so that it can be removed). Tricky problems must be dealt with, like what to do with messages that are sent but never acknowledged.

Kafka handles this differently. Our topic is divided into a set of totally ordered partitions, each of which is consumed by exactly one consumer within each subscribing consumer group at any given time. This means that the position of a consumer in each partition is just a single integer, the offset of the next message to consume. This makes the state about what has been consumed very small, just one number for each partition. This state can be periodically checkpointed. This makes the equivalent of message acknowledgements very cheap.

There is a side benefit of this decision. A consumer can deliberately rewind back to an old offset and re-consume data. This violates the common contract of a queue, but turns out to be an essential feature for many consumers. For example, if the consumer code has a bug and is discovered after some messages are consumed, the consumer can re-consume those messages once the bug is fixed.
