---
title: docker-部署SpringBoot服务
aliases: []
date: 2024-05-12T08:40:26+08:00
lastmod: 2024-05-12T10:48:36+08:00
id: b67149e5-5093-4a0b-9133-c9d66e663be6
slug: b67149e5-5093-4a0b-9133-c9d66e663be6
obsidianLink: obsidian://advanced-uri?vault=note&uid=b67149e5-5093-4a0b-9133-c9d66e663be6
hugoLink: https://blog.fishyer.com/post/b67149e5-5093-4a0b-9133-c9d66e663be6/
tags: []
zhihu-tags: []
---

## 1.在docker容器外使用mvn构建

其实就是先mvn clean package生成jar包

然后再将jar包拷贝到容器里面

问题在于：可能不同开发者的本地maven环境是不一样的

适用于开发阶段，方便快速调试

## 2.在docker容器内使用mvn构建

这个就是直接在docker里面分步构建，适用于部署阶段，保证环境一致

先第一步通过docker里面执行mvn clean packages
```Dockerfile
# Build stage
FROM maven:3.6.0-jdk-11-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

```

再第二步通过docker执行jar
```Dockerfile
# Package stage
FROM openjdk:11-jdk-slim
COPY --from=build /home/app/target/my-spring-boot-app-*.jar /usr/local/lib/my-spring-boot-app.jar
EXPOSE 8080
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/usr/local/lib/my-spring-boot-app.jar"]

```