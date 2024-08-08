Серебрянский Олег Дмитриевич
<br /> Когорта: 16
<br /> Группа: 2
<br /> Эпик: Каталог
<br /> Ссылка: https://trello.com/b/2Si7cea7/дипломный-прокт-fake-nft

<hr>

# Catalog Flow Decomposition

(est: n min; fact: x min)

# Module 1:

## Основной экран каталога с таблицами и фильтром

#### Верстка
- Кнопка с фильтрами (est: 30 min; fact: x min)
- Всплывающее окно(Alert?) с фильтами (est: 120 min; fact: x min)
- Таблица с коллекциями (est: 120 min; fact: x min).
- Ячейки (est: 120 min; fact: x min).
- Индикатор загрузки (est: 120 min; fact: x min)



#### Логика
- Сохранить способ сортировки (est: 240 min; fact: x min).
- Переход на экран выбранной коллекции (est: 60 min; fact: x min)
- Индикатор загрузки (est: 120 min; fact: x min)
`Total:` est: 810 min; fact: x min.


# Module 2:

## Экран коллекции со списком NFT

#### Верстка
- Добавить UIcollectionView (est: 120 min; fact: x min)
- Ячейки для NFT в коллекции (est: 180 min; fact: x min)
- Скрыть tabBar (est: 30 min; fact: x min).
- Стрелка для перехода на предыдущий экран (est: 30 min; fact: x min)
- Индикатор загрузки (est: 120 min; fact: x min)

#### Логика
- Возврат на предыдущий экран (est: 30 min; fact: x min)
- Переход на подробный экран набора (est: 60 min; fact: x min).
- Индикатор загрузки (est: 120 min; fact: x min)


`Total:` est: 690 min; fact: x min.

# Module 3:

## Доделать оставшуюся логику и смерджит

- Сортировка (est: 240 min; fact: x min).
- Добавить NFT в избранное (est: 240 min; fact: x min)
- Добавить NFT в корзину (est: 240 min; fact: x min)
- Смёрджить проект с командой (est: 240 min; fact: x min)

`Total:` est: 820 min; fact: x min.
