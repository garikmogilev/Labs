use Market

--note full join
select  CategoryName,ProductName,ProductShortDesc, ProductCategory
from products
full join productcategories
    on products.ProductCategory = productcategories.CategoryID


--note left join
select CategoryName,ProductName, ProductShortDesc, ProductCategory
from products
left join productcategories
    on products.ProductCategory = productcategories.CategoryID

--note right join
select CategoryName,ProductName, ProductShortDesc, ProductCategory
from products
right join productcategories
    on products.ProductCategory = productcategories.CategoryID

--note left join
select CategoryName,ProductName, ProductShortDesc, ProductCategory
from products
inner join productcategories
    on products.ProductCategory = productcategories.CategoryID

--note right join is null
select CategoryName,ProductName, ProductShortDesc, ProductCategory
from products
right join productcategories on products.ProductCategory = productcategories.CategoryID
    where ProductName is null
