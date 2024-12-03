---
title: PlantUML绘制时序图
date: 2024-12-03 18:20:21
tags:
---
# PlantUML 绘制时序图

时序图是什么？

> 时序图（Sequence Diagram），又名序列图、循序图，是一种UML交互图。它通过描述对象之间发送消息的时间顺序显示多个对象之间的动态协作。它可以表示用例的行为顺序，当执行一个用例行为时，其中的每条消息对应一个类操作或状态机中引起转换的触发事件。

## 基本用法

用 `->` 来绘制参与者之间传递的消息，`-->` 表示虚线。
各种箭头的写法：

```shell
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

```shell
@startuml
autonumber
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response

Alice -> Bob: Another authentication Request
Alice <-- Bob: Another authentication Response
@enduml
```
![2024-12-03-18-26-46.png](2024-12-03-18-26-46.png)

使用 `as` 关键字来重新命名参与者，你可以把它理解成定义变量一样, `as` 后面跟着的就是变量，声明后我们后面就可以使用这个变量了。
使用 `order` 关键字来定制参与者的显示顺序，数字越小，越往前排。
使用 `title` 关键字定义时序图的标题。
参与者后加上冒号(`:`)，后面跟上当前连线上的说明。如果连线上的文本过长，可以使用 `\n` 使长文本换行展示，不至于导致连线过长。

```shell
@startuml
title 测试PlantUML绘图
participant Last as L order 30
participant Middle as M order 20
participant First as F order 10

F -> M: 开始到中间
L <-- M: 中间到最后
@enduml
```
![2024-12-03-18-31-43.png](2024-12-03-18-31-43.png)

使用 `activate` 和 `deactivate` 表示参与者的生命线。比如上面例子，如果加上参与者的生命线，一旦参与者被激活，生命线就会被显示出来，会变成这个样子。
`destroy` 表示一个参与者的生命线的终结。

```
@startuml
title 测试PlantUML绘图
participant Last as L order 30
participant Middle as M order 20
participant First as F order 10

F -> M: 开始到中间
activate M

L <-- M: 中间到最后

activate L
L --> M: 中间到最后
destroy L

M--> F: 中间到开始结束
deactivate M
@enduml
```
![2024-12-03-18-36-06.png](2024-12-03-18-36-06.png)

还可以使用嵌套的生命线，并且运行给生命线添加颜色。

```
@startuml
title 测试PlantUML绘图
participant Last as L order 30
participant Middle as M order 20
participant First as F order 10

F -> M: 开始到中间
activate M #FFBBBB

L <-- M: 中间到最后
activate M #DarkSalmon

activate L
L --> M: 中间到最后
destroy L

M--> F: 中间到开始结束
deactivate M
@enduml
```
![2024-12-03-18-39-41.png](2024-12-03-18-39-41.png)

上面例子可以看出，每次需要手写关键字激活，不是很方便，也可以使用自动激活关键字（`autoactivate`），这需要与 `return` 关键字配合：

```
@startuml
autoactivate on
title 测试PlantUML绘图
participant Last as L order 30
participant Middle as M order 20
participant First as F order 10

F -> M: 开始到中间
M -> M: 中间到最后
M --> L: 中间到最后
return 开始到中间
return 开始到中间
return 开始到中间
@enduml
```

注意，`return` 返回的点是导致最近一次激活生命线的点。





## 声明参与者

使用关键字 `participant` 可以来声明参与者，默认使用长方形表示参与者，参与者如果没有明确指定类型，默认是 `participant` 类型。
PlantUML 还预制了一些默认参与者，其形状不同。
`actor`（角色）
`boundary`（边界）
`control`（控制）
`entity`（实体）
`database`（数据库）
`collections`（集合）
`queue`（队列）

```
@startuml
participant Participant as Foo
actor       Actor       as Foo1
boundary    Boundary    as Foo2
control     Control     as Foo3
entity      Entity      as Foo4
database    Database    as Foo5
collections Collections as Foo6
queue       Queue       as Foo7
Foo -> Foo1 : To actor
Foo -> Foo2 : To boundary
Foo -> Foo3 : To control
Foo -> Foo4 : To entity
Foo -> Foo5 : To database
Foo -> Foo6 : To collections
Foo -> Foo7: To queue
@enduml
```
![2024-12-03-18-45-50.png](2024-12-03-18-45-50.png)

## 分段以及分页

使用 `==` 关键字将时序图分割为不同的逻辑部分，方便阅读查看。

```
@startuml
== 初始化 ==
Alice -> Bob: 你好，我是Alice，请问有什么可以帮助您？
Bob -> Alice: 您好，我是Bob，很高兴为您服务。

== 商机分析 ==
Alice -> Bob: 请问您有什么想法或建议吗？
Bob -> Alice: 您好，我有一些想法，但我想先征求您的意见。             
@enduml
```
![2024-12-03-18-47-52.png](2024-12-03-18-47-52.png)

关键词 `newpage` 可以将一张时序图分割成多张图，后面跟上标题表示当前页的标题，适用于长图分页打印的场景。

```
@startuml
== 初始化 ==
Alice -> Bob: 你好，我是Alice，请问有什么可以帮助您？
Bob -> Alice: 您好，我是Bob，很高兴为您服务。

newpage 第二页
== 商机分析 ==
Alice -> Bob: 请问您有什么想法或建议吗？
Bob -> Alice: 您好，我有一些想法，但我想先征求您的意见。
@enduml
```
![2024-12-03-18-49-25.png](2024-12-03-18-49-25.png)
![2024-12-03-18-48-51.png](2024-12-03-18-48-51.png)

# 注释

可以使用 `note left` 或 `note right` 关键字在信息后面加上注释。
你可以使用 `end note` 关键字有一个多行注释。

```
@startuml
== 初始化 ==
Alice -> Bob: 你好，我是Alice，请问有什么可以帮助您？
note right of Alice: 请问您有什么想法或建议吗？
Bob -> Alice: 您好，我是Bob，很高兴为您服务。
note left of Bob: 您有什么想法或建议吗？


== 商机分析 ==
Alice -> Bob: 请问您有什么想法或建议吗？
note right: 您好，我有一些想法，但我想先征求您的意见。
Bob -> Alice: 您好，我有一些想法，但我想先征求您的意见。
note right
这是多行的版本
1
2
3
end note
@enduml
```
![2024-12-03-18-54-55.png](2024-12-03-18-54-55.png)

可以使用 `note left of`，`note right of` 或 `note over` 在节点(`participant`)的相对位置放置注释。
还可以通过修改背景色来高亮显示注释。

```
@startuml
== 初始化 ==
Alice -> Bob: 你好，我是Alice，请问有什么可以帮助您？
note right of Alice: 请问您有什么想法或建议吗？
Bob -> Alice: 您好，我是Bob，很高兴为您服务。
note left of Bob: 您有什么想法或建议吗？


== 商机分析 ==
Alice -> Bob: 请问您有什么想法或建议吗？
note over Alice, Bob #lightblue: 您好，我有一些想法，但我想先征求您的意见。
Bob -> Alice: 您好，我有一些想法，但我想先征求您的意见。
@enduml
```
![2024-12-03-18-57-08.png](2024-12-03-18-57-08.png)