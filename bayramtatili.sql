select * from Products

select * from Categories
select * from Suppliers

select ProductName, UnitPrice, CategoryName from Products
inner join Categories
on Products.CategoryID = Categories.ID

--Londrada kaç adet ürün tedarik ediyorum
select COUNT(*) [Toplam Ürün] from Products as p
inner join Suppliers as s
on p.SupplierID = s.SupplierID
where s.City = 'London'

--İspanyadan tedarik ettiğim ürünlerin adını, fiyatını ve tedarikçi firmanın adını yazdır
select p.ProductName, p.UnitPrice, s.CompanyName from Products as p inner join Suppliers as s
on p.SupplierID=s.SupplierID
Where LOWER(s.Country)='spain'

--Almanyadan şipariş veren kaç tane müşterim var(Customerdeki country )
select COUNT(*) from Orders as o inner join Customers as c
on o.CustomerID=c.CustomerID
where LOWER(c.Country)='germany'

select COUNT(*) from Orders as o
inner join Customers as c
on o.CustomerID = c.CustomerID
where LOWER( o.ShipCountry) = 'germany'

-- en çok sipariş veren müşterinin ID ?
select top 1 o.CustomerID, COUNT(o.CustomerID) toplam from Orders o
group by o.CustomerID
order by toplam desc

--10248 numaralı siparişin toplam tutarı nedir
select SUM(od.Quantity * od.UnitPrice) from [Order Details] as od
where OrderID = 10248

--10248 numaralı sipaşin ürünlerinin adını bana ver
select p.ProductName from [Order Details] as od
inner join Products as p
on od.ProductID = p.ProductID
where od.OrderID = 10248

--Bügüne kadar verilmiş en yüksek siparişin ID ve toplam tutar
select top 1 SUM(o.Quantity * o.UnitPrice),o.OrderID from [Order Details] as o 
group by o.OrderID order by o.OrderID desc

--1996 yılındaki siparişleri getir
select * from Orders where YEAR(OrderDate) = 1996

--------------------------------------------------------------------------------------------------------------------

--1) ürünleri ada göre sırala
select ProductName from Products order by ProductName

--2) ürünleri ada göre tersten sırala
select ProductName from Products order by ProductName desc

--3) ürün fiyatı 20 den büyük ve categoryid si 3 olan ürünleri fiyata göre sırala
select * from Products Where CategoryID=3 and UnitPrice>20 order by UnitPrice

--4) en pahalı 5 ürünü getir
select Top 5* from Products order by UnitPrice desc

--5) En pahalı ürünümün fiyatı
select Top 1* from Products order by UnitPrice desc

--6) En ucuz ürünümün fiyatı
select Top 1* from Products order by UnitPrice

--7) En ucuz ürünümün KDV li fiyatı nedir?
select Top 1 ( UnitPrice*1.18) from Products order by UnitPrice

--8) 1996 yılındaki siparişleri getir
select * from Orders where YEAR(OrderDate) = 1996

--9) 1997 yılının Mart ayının siparişlerini getir
select * from Orders where YEAR(OrderDate) = 1997 and MONTH(OrderDate)=03

--10) ShipCity - 1997 yılında Londra'ya kaç adet sipariş gitti?
select COUNT(*) from Orders where YEAR(OrderDate) = 1997 and LOWER(ShipCity)='London'

--11) ProductID si 5 olan ürünün kategori adı nedir
Select c.CategoryName
From Products p Inner Join Categories c
on p.CategoryID = c.ID
Where p.ProductID = 5

--12) Ürün adı ve ürünün kategorisinin adı
select p.ProductName, c.CategoryName from Products p  inner join Categories c
on p.CategoryID=c.ID

--13) Ürünün adı, kategorisinin adı ve tedarikçisinin adı
select p.ProductName, c.CategoryName, S.ContactName from Products p inner join Categories c
on p.CategoryID = c.ID
inner join Suppliers s 
on s.SupplierID =p.SupplierID

--14) Siparişi alan personelin adı,soyadı, sipariş tarihi. Sıralama sipariş tarihine göre
select e.FirstName , e.LastName,o.OrderDate from Orders o inner join Employees e 
on o.EmployeeID =e.EmployeeID
order by OrderDate 


--15) Son 5 siparişimin ortalama fiyatı nedir? (sepet toplamı ortalaması)
select Top 5  AVG(od.UnitPrice * od.Quantity) from Orders o inner join [Order Details] od
on o.OrderID = od.OrderID group by o.OrderID order by o.OrderID desc



--16) Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.ProductName, c.CategoryName, od.Quantity   from Products as p 
inner join Categories as c on c.ID=p.CategoryID
inner join [Order Details] as od on od.ProductID=p.ProductID 
inner join Orders as o  on od.OrderID =od.OrderID Where MONTH (OrderDate) =01


select SUM( od.Quantity) from Products as p 
inner join [Order Details] as od on od.ProductID = p.ProductID
inner join Orders as ord on ord.OrderID = od.OrderID  where MONTH(OrderDate) = 01


--17) Hangi personelim hangi personelime rapor veriyor?
select * from Employees -- devamını yapamadım

--18) Hangi ülkeden kaç müşterimiz var (distinc ve count kullanılacak)
select  DISTINCT Country, Count (*)  as Customers from Customers group by Country

--19) Ortalama satış miktarımın üzerindeki satışlarım nelerdir? (order details tablosu)
select * from [Order Details] Where Quantity> (select AVG(Quantity)  from [Order Details])

--20) En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı (4 tablo birleşimi)
select Top 1 p.ProductName,c.CategoryName, s.CompanyName,  od.Quantity from Products p 
inner join [Order Details] od on od.ProductID=p.ProductID
inner join Categories c on c.ID=p.CategoryID
inner join Suppliers s on s.SupplierID=p.SupplierID
order by od.Quantity desc

--21) 10248 numaralı siparişi alan çalışanın adı ve soyadı ve orderid
select e.FirstName,e.LastName,o.OrderID from Orders o inner join Employees e 
on e.EmployeeID=o.EmployeeID Where o.OrderID=10248

--22) 1996 yılında, 5 numaralı ID ye sahip çalışanım kaç adet sipariş aldı?
select COUNT(*) from Orders o inner join Employees e 
on e.EmployeeID=o.EmployeeID Where YEAR(OrderDate)=1996 and e.EmployeeID =5

--23) 1997 yılında kim ne kadar sipariş geçti (EmployeeID, Count)
select e.EmployeeID, COUNT(*) as count from Orders o inner join Employees e 
on e.EmployeeID =o.EmployeeID Where YEAR (OrderDate)=1997 group by e.EmployeeID

--24) 10248 numaralı siparişin ürünlerinin adları ve sipariş miktarı
select p.ProductName as Name, od.Quantity as Quantity from Products p inner join [Order Details] od 
on od.ProductID=p.ProductID 
inner join Orders o 
on o.OrderID=od.OrderID
Where o.OrderID=10248

--25) 10248 numaralı siparişin toplam fiyatı
select SUM(od.Quantity*p.UnitPrice) from Products p inner join [Order Details] od 
on od.ProductID=p.ProductID 
inner join Orders o 
on o.OrderID=od.OrderID
Where o.OrderID=10248

--26) 1996 yılında cirom
select SUM(UnitPrice * Quantity) from [Order Details] od inner join Orders o 
on o.OrderID = od.OrderID where YEAR(o.OrderDate) = 1996

--27) 1996 yılında en çok ciro (endorsement) yapan employeeID
select Top 1 e.EmployeeID , SUM(UnitPrice * Quantity) as endorsement from [Order Details] od inner join Orders o
on o.OrderID = od.OrderID
inner join Employees e on e.EmployeeID=o.EmployeeID 
where YEAR(o.OrderDate) = 1996 group by e.EmployeeID  order by endorsement desc

--28) 1997 Mart ayındaki siparişlerimin ortalama fiyatı nedir?
select AVG(od.UnitPrice) from Orders o inner join [Order Details] od on o.OrderID = od.OrderID 
where YEAR(o.OrderDate) = 1997  

--29) 1997 yılındaki aylık satışları sırala. Ocak - 500 gibi toplamda 12 satır olacak
select MONTH(o.OrderDate) as months , SUM(od.UnitPrice*od.Quantity) as sales from Orders o inner join [Order Details] od 
on o.OrderID=od.OrderID
Where YEAR(o.OrderDate) = 1997 group by MONTH (o.OrderDate) order by MONTH (o.OrderDate)

--30) En değerli MÜŞTERİMİN adı ve soyadı (orders,orderdetails,customers)
select c.ContactName, SUM(od.UnitPrice*od.Quantity) as sales from Orders o inner join [Order Details] od 
on o.OrderID=od.OrderID
inner join Customers c 
on c.CustomerID=o.CustomerID group by c.ContactName order by sales desc
