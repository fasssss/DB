
-- 3)
SELECT �.[����� �������], ���, �.������������, �.�����, ��.�������������, ��.����������� FROM ������� AS �
LEFT JOIN ��� � ON �.[����� �������] = �.[����� �������]
LEFT JOIN ������ � ON �.[����� ������] = �.[����� ������]
LEFT JOIN [������-������] �� ON ��.[����� ������] = �.[����� ������]
RIGHT JOIN [��������(������)] � ON �.[����� ������] = ��.[����� ������]
WHERE �.����� LIKE '%��� 53%' AND (��.������������� < ��.�����������)

--2)
SELECT �.[����� ����������], �.��� FROM ���������� AS �
INNER JOIN ��� � ON �.[����� ����������] = �.[����� ����������]
INNER JOIN ������ � ON �.[����� ������] = �.[����� ������]
INNER JOIN [������-������] �� ON ��.[����� ������] = �.[����� ������]
WHERE ��.������������� > 0
GROUP BY �.[����� ����������], �.���

--1)


--------- FINDING COUNT
DECLARE @length INT
SELECT @length = COUNT(*) FROM ������ AS �
INNER JOIN ����� � ON �.[����� �����] = �.[����� �����]
LEFT JOIN [�����-������] �� ON ��.[����� ������] = �.[����� ������]
LEFT JOIN ����� � ON �.[����� �����] = ��.[����� �����]
WHERE �.������� LIKE '%++%'

---------
DECLARE @fetched table(rownumber bigint, ������������ nvarchar(50), [�����(%)] float, ���� nvarchar(50))
INSERT INTO @fetched(rownumber, ������������, [�����(%)], ����)
SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS rownumber, �.������������, �.[�����(%)], �.������������ AS ���� FROM ������ AS �
	INNER JOIN ����� � ON �.[����� �����] = �.[����� �����]
	LEFT JOIN [�����-������] �� ON ��.[����� ������] = �.[����� ������]
	LEFT JOIN ����� � ON �.[����� �����] = ��.[����� �����]
	WHERE �.������� LIKE '%++%'
	ORDER BY �.������������ ASC

DECLARE @var1 NVARCHAR(50)
DECLARE @var2 NVARCHAR(50)
DECLARE @var3 NVARCHAR(50)
WHILE(@length > 0)
	BEGIN
	SELECT @var1 = ���������.������������, @var2 = ���������.[�����(%)], @var3 = ���������.����
	FROM @fetched AS ���������
	WHERE rownumber = @length
	PRINT(@var1 + ' - ������ ' + @var2 + '%. ���� - ' + @var3)
	SET @length = @length - 1
	END