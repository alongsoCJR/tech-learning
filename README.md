# courseop-tech-learning

教务技术学习笔记

## 技术学习笔记

访问地址：[tech-learning](https://alongsocjr.github.io/tech-learning/index.html)

Inspired By [lvt4j](https://lvt4j.51vip.biz/confluence/#all-updates)

## 本地运行

需要前置Rust开发环境

cargo install mdbook

如果已经安装好，每次运行执行以下命令：

mdbook clean

mdbook build

mdbook serve

本地运行 
```sql
./start.sh
```
本地访问地址：http://localhost:3000/

## 远程部署

笔记整理完之后，用mdbook+github page发布。
运行：
```sql
./up.push.git.sh 
```

