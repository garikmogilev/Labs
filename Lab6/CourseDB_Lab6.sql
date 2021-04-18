use Market

select ProductName, ProductShortDesc, ProductCategory, ProductPrice
from products P1
where ProductID =
    (
    select top 1 P2.ProductID
    from products P2
    where P1.ProductCategory = P2.ProductCategory
    order by ProductPrice
    ) order by ProductPrice desc

SELECT top 1
    (select sum(ProductPrice))[Summ all product]
from products
