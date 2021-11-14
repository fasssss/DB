
-- 3)
SELECT к.[Номер клиента], ФИО, т.Наименование, м.Адрес, ст.Забронировано, ст.Колличество FROM Клиенты AS к
LEFT JOIN Чек ч ON ч.[Номер клиента] = к.[Номер клиента]
LEFT JOIN Товары т ON т.[Номер товара] = ч.[Номер товара]
LEFT JOIN [Склады-Товары] ст ON ст.[Номер товара] = т.[Номер товара]
RIGHT JOIN [Магазины(Склады)] м ON м.[Номер склада] = ст.[Номер склада]
WHERE м.Адрес LIKE '%дом 53%' AND (ст.Забронировано < ст.Колличество)

--2)
SELECT с.[Номер сотрудника], с.ФИО FROM Сотрудники AS с
INNER JOIN Чек ч ON ч.[Номер сотрудника] = с.[Номер сотрудника]
INNER JOIN Товары т ON т.[Номер товара] = ч.[Номер товара]
INNER JOIN [Склады-Товары] ст ON ст.[Номер товара] = т.[Номер товара]
WHERE ст.Забронировано > 0
GROUP BY с.[Номер сотрудника], с.ФИО

--1)


--------- FINDING COUNT
DECLARE @length INT
SELECT @length = COUNT(*) FROM Товары AS т
INNER JOIN Жанры ж ON ж.[Номер жанра] = т.[Номер жанра]
LEFT JOIN [Акции-Товары] ат ON ат.[Номер товара] = т.[Номер товара]
LEFT JOIN Акции а ON а.[Номер акции] = ат.[Номер акции]
WHERE а.Условие LIKE '%++%'

---------
DECLARE @fetched table(rownumber bigint, Наименование nvarchar(50), [Акция(%)] float, Жанр nvarchar(50))
INSERT INTO @fetched(rownumber, Наименование, [Акция(%)], Жанр)
SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS rownumber, т.Наименование, а.[Акция(%)], ж.Наименование AS Жанр FROM Товары AS т
	INNER JOIN Жанры ж ON ж.[Номер жанра] = т.[Номер жанра]
	LEFT JOIN [Акции-Товары] ат ON ат.[Номер товара] = т.[Номер товара]
	LEFT JOIN Акции а ON а.[Номер акции] = ат.[Номер акции]
	WHERE а.Условие LIKE '%++%'
	ORDER BY ж.Популярность ASC

DECLARE @var1 NVARCHAR(50)
DECLARE @var2 NVARCHAR(50)
DECLARE @var3 NVARCHAR(50)
WHILE(@length > 0)
	BEGIN
	SELECT @var1 = временная.Наименование, @var2 = временная.[Акция(%)], @var3 = временная.Жанр
	FROM @fetched AS временная
	WHERE rownumber = @length
	PRINT(@var1 + ' - скидка ' + @var2 + '%. Жанр - ' + @var3)
	SET @length = @length - 1
	END