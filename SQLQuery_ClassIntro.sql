select ar.Name, al.Title [Album Title]
from artist ar
	inner join Album al
		on ar.ArtistId = al.ArtistId

--left outer join!
select ar.Name, al.Title [Album Title]
from artist ar
	left join Album al
		on ar.ArtistId = al.ArtistId
--=give me all of the albums and where they have matching records, give me all of those too - so we would have more rows than before
where ar.Name = 'AC/DC'

--select Album.Title --specify the column you want to display
--from artist
	--join album
	--on Artist.ArtistId = Album.ArtistId
--where artist.Name = 'AC/DC'

select ar.Name, al.Title [Album Title]
from artist ar
	right join Album al
		on ar.ArtistId = al.ArtistId


--give me all the artists that don't have a matching album !
select ar.Name, al.Title [Album Title]
from artist ar
	left join Album al
		on ar.ArtistId = al.ArtistId
where al.AlbumId is null

--select *
--from artist
	--join album 
	--on Artist.ArtistId = Album.ArtistId
	--give me all the columns from the artist table and join the album table to that data based on the artist Id matching the album's artistId

--where artist.Name = 'AC/DC'

--where Name like 'b%'
--where Name like '%hans%'
--where Name like 'b%'
--to comment out sections, use --
--where ArtistId > 12

select *
from Album 
where ArtistId = 1



--SAT Sept 16

--below: it does not matter what you pass in to the count function
--use Top to get the top 1 5 etc items int he results
--select Top 1 BillingCountry, sum(Total) as InvoiceTotal, count(1) as CountOfInvoices
select BillingCountry, sum(Total) as InvoiceTotal, count(1) as CountOfInvoices, AVG(Total) Average, max(Total) BiggestTx, min(Total) SmallestTx
from Invoice
group by BillingCountry
order by InvoiceTotal desc
--to order descending, add desc: order by InvoiceTotal desc
--you can also say order by 2 - which means order by the second column!

--find out how much revenue we generated in the year 2009

--where InvoiceDate between '1/1/2009' and '1/1/2010'
--where Year(InvoiceDate) = 2009 --this is another way to specify the condition above

--what is our biggest 
--if you do 't have a group by statement > then it will add all the rows in the table into the aggregates you have listes in the select statement
select sum(total), count(1), STRING_AGG(BillingCountry, ',')
from Invoice


--SUBQUERIES:
--to get invoices for specific customers: you can use the in statement inside the where clause:
select *
from Invoice
where CustomerId in (1,2,3)

select *
from Customer
where City = 'Berlin'

--NEST a query inside the first one!!!
-- = give me all the rows from the Invoice table where the customer id has a city of Berlin
--the in statement works only if you return one column - the number / id itself:
select *
from Invoice
where CustomerId in (
						select CustomerId
						from Customer
						where City = 'Berlin'
						--where Company is not null
					)


--the 2 queries below accomplish the same goal:
select CustomerId, sum(Total)
from Invoice
where CustomerId in (
						select CustomerId
						from Customer
						
						where Company is not null
					)
group by CustomerId

--build a set of data on the fly - using an inner join:
select i.CustomerId, sum(Total)
from Invoice i
	join (
			select CustomerId
			from Customer
			where Company is not null
			) c
			on i.CustomerId = c.CustomerId
group by i.CustomerId

--correlated subquery

--to display data form multipel columns in one column:
select e.FirstName + ' ' + e.LastName as Name, e.City, c.FirstName + ' ' + c.LastName as CustomerName, c.City as CustomerCity 
from Employee e
	join Customer c
	on e.EmployeeId = c.SupportRepId


--instead of this, you can use a correlated subquery: the fact that it is using the e.employeeId - from the first table - inside the second query is what makes it a correlated query
select e.FirstName + ' ' + e.LastName as Name, 
	e.EmployeeId,
	e.City,
	(
	select string_agg(FirstName + ' ' + LastName, ',')
	from Customer 
	where SupportRepId = e.employeeId
	)
from Employee e


--using correlated subqueries inside a where clause
--exists here says - give me the data if there is at least one row that returns the results requested
--this is the part that makes this a correlated subquery: where c.SupportRepId = e.EmployeeId
select *
from Employee e
where exists(select 0 from Customer c where c.SupportRepId = e.EmployeeId)

--to get the same results as above with a join:
--need to add the distinct keyword to get only the unique rows
select distinct e.*
from Employee e
	join Customer c
	on c.SupportRepId = e.EmployeeId


--multiple datasets 
--union = says take the results fromt eh first set and the results from the second set and combien them all together in a single list
--give me all the data of people in my company and tell me if they are employees or customers
select firstname, lastname, 'Customer' Type
from Customer
union
select firstname, lastname, 'Employee' Type
from Employee
union -- excludes exact duplicates like the record below
--union all --inlcudes exact duplicates!
--except -- leaves out data that matches exactly
select 'Andrew', 'Adams', 'Employee'
order by type, LastName

--except
--select *
-- from Employee distinct e.*

