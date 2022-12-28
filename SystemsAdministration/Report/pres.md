---
marp: true
theme: uncover
backgroundColor: #fff
style: |
  .columns {
    display: flex;
    justify-content: center;
  }
---

# Логические тома ZFS

<span style="color: grey">Выполнил:</span> Матюхин Григорий

---

## Что такое ZFS?

---

# Другие файловые системы

<div class="columns">

  <img src=./Images/other_fs.png/>
  <img src=./Images/other_fs.png/>
  <img src=./Images/other_fs.png/>

</div>

---

## Пулы хранения

![w:40% h:40%](./Images/pool.png)

---

## Целостность данных

![w:40% h:40%](./Images/pointers.png)

---

# Самовосстановление

---

## Другие файловые системы

<div class="columns">

  <img src=./Images/bad_0.png>
  <img src=./Images/bad_1.png>
  <img src=./Images/bad_2.png>

</div>

---

## ZFS

<div class="columns">

  <img src=./Images/heal_0.png>
  <img src=./Images/heal_1.png>
  <img src=./Images/heal_2.png>

</div>

---

## Традиционный RAID (4/5/6)

* Полосы постоянной длинны
* Частичная запись полосы &mdash; плохо!
  * 1 изменение &rarr; 4 дополнительных обращения к дискам
  * "write hole error"

---

## RAID-Z

<table>
  <tr style="border: none;"><th style="border: none;"></th><th colspan="6" style="border: 1px solid black;">Диск</th></tr>
  <tr style="border: none;">
    <th>
      <!-- <div> -->
      <!--   Disk -->
      <!-- </div> -->
      <!-- <div> -->
      <!--   LBA -->
      <!-- </div> -->
    </th>
    <th></th>
    <th>A</th>
    <th>B</th>
    <th>C</th>
    <th>D</th>
    <th>E</th>
  </tr>

  <tr>
    <th rowspan=4 style="border: 1px solid black;">LBA</th>
    <th>0</th>
    <td style="background-color:orange">P<sub>0</sub></td>
    <td style="background-color:orange">D<sub>0</sub></td>
    <td style="background-color:orange">D<sub>2</sub></td>
    <td style="background-color:orange">D<sub>4</sub></td>
    <td style="background-color:orange">D<sub>6</sub></td>
  </tr>

  <tr>
    <th>1</th>
    <td style="background-color:orange">P<sub>1</sub></td>
    <td style="background-color:orange">D<sub>1</sub></td>
    <td style="background-color:orange">D<sub>3</sub></td>
    <td style="background-color:orange">D<sub>5</sub></td>
    <td style="background-color:orange">D<sub>7</sub></td>
  </tr>

  <tr>
    <th>2</th>
    <td style="background-color:yellow">P<sub>0</sub></td>
    <td style="background-color:yellow">D<sub>0</sub></td>
    <td style="background-color:yellow">D<sub>1</sub></td>
    <td style="background-color:yellow">D<sub>2</sub></td>
    <td style="background-color:green">P<sub>0</sub></td>
  </tr>

  <tr>
    <th>3</th>
    <td style="background-color:green">D<sub>0</sub></td>
    <td style="background-color:green">D<sub>1</sub></td>
    <td style="background-color:green">D<sub>2</sub></td>
    <td style="background-color:red">P<sub>0</sub></td>
    <td style="background-color:red">D<sub>0</sub></td>
  </tr>

</table>

---

## Копирование при записи

![w:750px h:500px](./Images/cow.png)

---

## Снимки и клоны

![w:40% h:40%](./Images/snapshot.png)

---

# Спасибо за внимание
