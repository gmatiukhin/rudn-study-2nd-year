---
marp: true
theme: uncover
class: invert
color: #ddd
style: |
  .columns {
    display: flex;
    justify-content: center;
  }
---

# ReST & JSON

<span style="color: grey">Выполнил:</span> Матюхин Григорий

---

## Источники

- ReST

  - Fielding, Roy Thomas. "Architectural Styles and the Design of Network-based Software Architectures."
  - The Rest of ReST - Dylan Beattie

- JSON

  - The JavaScript Object Notation (JSON) Data Interchange Format. RFC 8259
  - www.json.org

---

## Что такое ReST?

---

## Требования к архитектуре ReST

- Модель клиент-сервер
- Отсутствие состояния
- Кэширование
- Единообразие интерфейса
- Слои
- Код по требованию <span style="color: #2b2d33">(опционально)</span>
- Гипермедиа как механизм состояния приложения

---

## Требования к архитектуре ReST

- Модель клиент-сервер
- Отсутствие состояния
- Кэширование
- Единообразие интерфейса
- Слои
- Код по требованию <span style="color: #bb0">(опционально)</span>
- Гипермедиа как механизм состояния приложения

---

# JSON

<!-- <iframe width="560" height="315" src="https://www.youtube.com/embed/uR-f4b0G9lo?controls=0&start=30&autoplay=1" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe> -->

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
