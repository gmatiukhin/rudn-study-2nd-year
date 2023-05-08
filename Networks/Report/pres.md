---
marp: true
theme: uncover
class: invert
color: #ccc
style: |
  .columns {
    display: flex;
    justify-content: center;
  }
---

# REST & JSON

<span style="color: grey">Выполнил:</span> Матюхин Григорий

---

## Источники

<!-- Yeah, I have to use HTML here and later because md formats with gaps -->
<ul>
  <li>REST:</li>
    <ul>
      <li>Fielding, Roy Thomas. "Architectural Styles and the Design of Network-based Software Architectures."
</li>
      <li>The Rest of REST - Dylan Beattie
</li>
    </ul>
  <li>JSON:</li>
    <ul>
      <li>The JavaScript Object Notation (JSON) Data Interchange Format. RFC 8259
</li>
    </ul>
</ul>

---

## Что такое REST?

---

"Получив <strong style="font-size: 50px; line-height: 0.6">имя</strong>, согласованный набор
<strong style="font-size: 60px; line-height: 0.6">архитектурных ограничений</strong>
становится архитектурным <strong style="font-size: 70px; line-height: 0.6">стилем</strong>."
\- Рой Филдинг

<!--
"When given a name, a coordinated set of architectural constraints becomes an architectural style."

REST is a style, published in Roy's PhD thesis.

Roy's thinking was **heavily** informed by architecture, as in buildings.
There're styles: Rococo, Barocco, Brutalism, so on.
Not tools, not framework, not plugin, a set of styles to solve recurring problems.

REST is not something you download from Cargo, NPM or PyPi.
REST is a way of thinking about how the systems will evolve over time.
-->

---

"<strong style="font-size: 40px; line-height: 0.6">REST</strong> &#8212; это разработка программного обеспечения
в масштабе <strong style="font-size: 90px; line-height: 0.8">десятилетий:</strong>
каждая деталь предназначена для обеспечения
<strong style="font-size: 60px; line-height: 0.6">долговечности</strong> программного обеспечения
и его <strong style="font-size: 60px; line-height: 0.6">независимого</strong> развития.

Многие ограничения прямо <strong style="font-size: 60px; line-height: 0.6">противоположны краткосрочной
эффективности.</strong>"

<!--
A key thing to bear in mind.

"REST is software design on the scale of decades:
every detail is intended to promote software longevity and independent evolution.
Many of the constraints are directly opposed to short-term efficiency."

If you're in a hurry -
trying to ship v1 before funding runs out,
trying to hit a deadline,
trying to comply with new regulations,
trying to urgently fix prod -
then REST is probably not for you.
Those are not the situations, where REST is the answer to your problems.

Scale of decades!
Roy Fielding published his PhD in 2000.
There've only been 2.3 decades.
That's not really enough time to prove, whether he was right or not.
__But__ there is a lot of thinking that suggests, that the patterns outlined by him
are actually a good way to build __flexible__ software that __can__ evolve over time.

Think about why are you building the system that you're building, it's requirements.
And if those requirements genuelnly inform building a system that you want to evolve over,
not necessarily decades, but years, then it is worth to take your time to look at the patterns,
to try to understand them and then make an informed decision, whether they are the right tool for the job.
-->

---

## Требования к архитектуре REST

- Модель клиент-сервер
- Отсутствие состояния
- Кэширование
- Слои
- Код по требованию
- Единообразие интерфейса

<!--
REST outlines a set of constraints around how the system should be built.
Important to note:
  REST doesn't say you must use HTTP or XML or JSON.
  It defines a set of patterns for communication between a client and a server
  and the ways of facilitating those interactions and those conversations.
-->

---

## Модель клиент-сервер

<ul>
  <li>Сервер:</li>
    <ul>
      <li>Данные</li>
      <li>Поведение</li>
      <li>Правила</li>
    </ul>
  <li>Клиент:</li>
    <ul>
      <li>Отправляет запросы на сервер</li>
    </ul>
</ul>

<!--
Shouldn't be surprising
Clients:
This way you don't have to mail everyone a CD to fix something like in the 80s.
You just push an update to the server, and boom - new feature.
-->

---

## Отсутствие состояния

- <strong style="font-size: 60px; line-height: 0.6">Ключевой</strong> принцип легкого масштабирования систем
- Каждый запрос должен быть <strong style="font-size: 60px; line-height: 0.6">атомарной</strong> транзакцией
- <strong style="font-size: 60px; line-height: 0.6">Никаких</strong> сессий

<!--
Key tenet of being able to scale systems easily.
Every conversation should be an **atomic** transaction.
Client should say: "here's me, here're my credentials, here's all data that I need to give to you".
And the server can deal with this.

Once you've introduced sessions, you're relying on the server to rembember who it talked to a minute ago.
You have all these half-finished conversations and half-backed transactions laying in your memory.
Problems:
  1. You can do better stuff with your memory;
  2. You are not sure, whether anyone will come back, so you have to fiddle around with your session timer;
  3. If one of your servers dies and you bounce the client to another in your swarm,
      that conversation is lost, because all of that state just disappeared with the server that died

So try to avoid that in a **RESTfull** system.
You may have sessions, they may be a perfect solution for your problem.
But it's not RESTfull.
-->

---

## Кэширование

<!--
Ideally, when a new version of some package is realeased in the US for instance,
it is downloaded only once in Russia and then stored locally.
So that anyone in Russia who needs this package, will download it from the russian server
and not use the very valuable contended bandwidth on the cables connecting us to the US.

Two ways of caching that matter:
- Infinite
- Never

Optimise for infinity.
When you put a resource on the Web, try, if you possibly can, to make sure
that anyone who've seen this resource previously will be able to use the version they got last week/month/year.
Or the versin that somebody else's got that their ISP is caching.

Don't think about caching for 1 hour, 3 hours, 2 days.
Think about caching for infinity.
It really influences your decisions how you structure the information you're presenting.
-->

---

## Слои

<!--
Goes hand-in-hand with cacheability.

You have a client and a server.
But the client doesn't care, whether it's talking to the server itself
or to a proxy that's talking to a load balancer,
or to a proxy that's talking to somebody else that's talking to a VPN so on and so forth.

At every level you have a thing that's talking to a thing above and a thing below.
But it doesn't care what's behind those.

And you can cache stuff on all these layers.
Example: using reverse proxies on a build pipeline.
When you're downloading packages from NPM, Cargo, NuGet, put a proxy in front of your build server.
So, if you've ever downloaded anything you now have a local copy.
NPM doesn't need to know that that's happening,
your build server doesn't need to know that that's happening,
upstream doesn't need to know that that's happening.
Each of these layers provide an abstraction between the provider and the consumer.
-->

---

## Код по требованию

<!--
"Servers can temporarily extend or customize the functionality of a client by transferring executable code."
  - Wikipedia

Basically, you can use your users' machines as a part of your behaviour.
Today it's mostly JavaScript or WebAssembly running in your browser.
-->

---

## Единообразие интерфейса

<!--

-->

---

## Гипермедиа как механизм состояния приложения

<!---->

---

# JSON

---

## Синтаксис

```json
{
  "name": "John Doe",
  "age": 25,
  "online": true,
  "friends": [
    {
      "name": "Mary Sue",
      "age": 26
    },
    {
      "name": "Joe Schmoe",
      "age": 21
    }
  ],
  "hobbies": ["knitting", "arm wrestling"]
}
```

---

# Спасибо за внимание
