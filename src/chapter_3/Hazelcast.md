# Hazelcast简介

Hazelcast is a streaming and memory-first application platform for fast, stateful, data-intensive workloads on-premises, 
at the edge or as a fully managed cloud service.

产品有：Hazelcast Management Center，IMDG，Jet

## 学习进度


## 提供的新架构，解决方案


## 笔记

HZ核心设计文档：https://github.com/hazelcast/hazelcast/blob/master/docs/design/template.md

Bridging Between Java 8 Streams and Hazelcast Jet

In-Memory Storage/In-Memory Compute/Real-Time Processing

Distributed Data Design(Partitioning and Replication)： 
AP:Replication(lazy replication), primary-copy, best-effort, no strong consistency but monotonic reads guarantee,
anti-entropy,at-least-once,
CP: Consensus algorithms Raft

嵌入式是否支持”跨应用”发现彼此？

membership具体细节，如何加入和如何退出，以及数据迁移细节官方文档涉及比较少。

Build Distributed System

Core Object：Config,DistributedObject,Node,NodeState,Cluster,HazelcastInstance

FD:PhiAccrualFailureDetector,PhiAccrualClusterFailureDetector,DeadlineClusterFailureDetector,PingFailureDetector


## Starter

https://docs.hazelcast.com/hazelcast/5.1/pipelines/spring-boot


## Paper

[Phi Accrual Failure Detector](https://www.computer.org/csdl/proceedings-article/srds/2004/22390066/12OmNvT2phv)

[Group membership and view synchrony in partitionable asynchronous distributed systems: specifications](https://dl.acm.org/doi/pdf/10.1145/250007.250010)

