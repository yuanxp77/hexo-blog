---
title: PlantUML绘制时序图
date: 2024-12-03 18:20:21
tags:
---
# PlantUML 绘制时序图

时序图是什么？

> 时序图（Sequence Diagram），又名序列图、循序图，是一种UML交互图。它通过描述对象之间发送消息的时间顺序显示多个对象之间的动态协作。它可以表示用例的行为顺序，当执行一个用例行为时，其中的每条消息对应一个类操作或状态机中引起转换的触发事件。
> 基本用法

## 基本用法

用 `->` 来绘制参与者之间传递的消息，`-->` 表示虚线。
各种箭头的写法：

```
@startuml
Bob ->x Alice
Bob -> Alice
Bob ->> Alice
Bob -\ Alice
Bob \\- Alice
Bob //-- Alice

Bob ->o Alice
Bob o\\-- Alice

Bob <-> Alice
Bob <->o Alice
@enduml
```
![2024-12-03-18-25-51.png](2024-12-03-18-25-51.png)

关键字 `autonumber` 用于自动对消息编号

```rust
@startuml
autonumber
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response

Alice -> Bob: Another authentication Request
Alice <-- Bob: Another authentication Response
@enduml
```
![2024-12-03-18-26-46.png](2024-12-03-18-26-46.png)

