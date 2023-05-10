# Book




# Designing Event-Driven System









# Kafka:The Definitive Guide Second Edition





# Kafka简介

[Apache Kafka](https://www.confluent.io/what-is-apache-kafka/) is an event streaming platform used to collect, process, store, and integrate data at scale. It has numerous use cases including distributed streaming, stream processing, data integration, and pub/sub messaging.

财富榜top100中，80%的公司用了kafka

分布式流处理，数据聚合，消息发布和订阅

Due to Kafka's high throughput, fault tolerance, resilience, and scalability, there are numerous use cases across almost every industry 

高吞吐量，容错性，弹性和可扩展性

###### Data Integration

###### Metrics and Monitoring

###### Log Aggregation

###### Stream Processing

###### Publish-Subscribe Messaging



看到了这里：https://developer.confluent.io/what-is-apache-kafka/



## kafka coordinator

"协调者"有些陌生，所谓协调者，在Kafka 中对应的术语是Coordinator，它**专门为Consumer Group 服务，负责Group Rebalance 以及提供位移管理和组成员管理等**。

coordinator：https://zhuanlan.zhihu.com/p/148131411

kafka整体架构：https://cloud.tencent.com/developer/beta/article/1005708?areaSource=106001.1

官方文档：https://kafka.apache.org/documentation/#consumerconfigs

Offset：https://www.cnblogs.com/edisonchou/p/kafka_study_notes_part9.html