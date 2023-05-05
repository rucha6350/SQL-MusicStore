--1. Who is the senior most employee based on job title?
SELECT TOP 1 * 
FROM Employee
ORDER BY levels DESC

--2. Which countries have the most invoices?
select billing_country,COUNT(billing_country) as invoice_number
from Invoice
group by billing_country
order by invoice_number desc

--3. What are top 3 values of total invoices?
select top 3 invoice_id,total 
from Invoice
order by total desc

--4. Which city has the best customers? We would like to throw a promotional Music
--Festival in the city we made the most money. Write a query that returns one city that
--has the highest sum of invoice totals. Return both the city name & sum of all invoice
--totals
select billing_city,SUM(total) AS Invoice_Total 
from Invoice
group by billing_city
order by Invoice_Total desc

--5. Who is the best customer? The customer who has spent the most money will be
--declared the best customer. Write a query that returns the person who has spent the
--most money
select top 1 Customer.customer_id,Customer.first_name,Customer.last_name,sum(total) as Total
from Invoice join Customer
on Invoice.customer_id=Customer.customer_id
group by Customer.customer_id,Customer.first_name,Customer.last_name
order by Total desc

--6. Write query to return the email, first name, last name, & Genre of all Rock Music
--listeners. Return your list ordered alphabetically by email starting with Aselect distinct c.customer_id,c.first_name,c.last_name,c.email from Customer c inner join Invoice ion c.customer_id=i.customer_id	inner join Invoice_Line ilon i.invoice_id=il.invoice_id	inner join Track ton il.track_id=t.track_id	inner join Genre gon t.genre_id=g.genre_idwhere g.name like '%Rock%'order by c.email--7. Let's invite the artists who have written the most rock music in our dataset. Write a
--query that returns the Artist name and total track count of the top 10 rock bands
select distinct top 10  ar.artist_id,ar.name, COUNT(ab.artist_id) AS MusicCount
from Artist ar inner join Album ab
	on ab.artist_id=ar.artist_id
inner join Track t
	on ab.[album_id]=t.album_id
inner join Genre g
	on t.genre_id=g.genre_id
where g.name like '%Rock%'
GROUP BY ar.artist_id,ar.name
order by MusicCount desc

--8. Return all the track names that have a song length longer than the average song length.
--Return the Name and Milliseconds for each track. Order by the song length with the
--longest songs listed firstSELECT NAME,milliseconds FROM TrackWHERE milliseconds>(select AVG(milliseconds) AS Average_Milliseconds from Track)ORDER BY milliseconds DESC--9. Find how much amount spent by each customer on artists? Write a query to return
--customer name, artist name and total spent
select 
Customer.first_name,Customer.last_name,Artist.name
,SUM(Invoice_Line.unit_price*Invoice_Line.quantity) as Total
from Track join Album on Track.album_id=Album.album_id
join Artist on Album.artist_id=Artist.artist_id
join Invoice_Line on Track.track_id=Invoice_Line.track_id
JOIN Invoice on Invoice.invoice_id=Invoice_Line.invoice_id
join Customer on Customer.customer_id=Invoice.customer_id
GROUP BY Customer.first_name,Customer.last_name,Artist.name
ORDER BY Total DESC


--10. We want to find out the most popular music Genre for each country. We determine the
--most popular genre as the genre with the highest amount of purchases. Write a query
--that returns each country along with the top Genre. For countries where the maximum
--number of purchases is shared return all Genres

with PurchasesByCountry as(
select 
	Invoice.billing_country
	,Genre.name
	,COUNT(Invoice.billing_country) as Purchases
	,ROW_NUMBER() OVER(PARTITION BY INVOICE.BILLING_COUNTRY order by COUNT(Invoice.billing_country) desc) AS RowNumber
from Invoice join Invoice_Line
	on Invoice.invoice_id=Invoice_Line.invoice_id
join Track
	on Invoice_Line.track_id=Track.track_id
join Genre
	on Track.genre_id=Genre.genre_id
group by Invoice.billing_country,Genre.name)
select billing_country,name,Purchases from PurchasesByCountry where RowNumber=1

--11. Write a query that determines the customer that has spent the most on music for each
--country. Write a query that returns the country along with the top customer and how
--much they spent. For countries where the top amount spent is shared, provide all
--customers who spent this amountselect temptable.first_name,temptable.last_name,temptable.billing_country,Totalfrom (
select 
	first_name,last_name,billing_country,SUM(total) as Total
	,ROW_NUMBER() over (partition by billing_country order by SUM(total) desc) as RowNumber
from Customer join Invoice
on Customer.customer_id=Invoice.customer_id
group by first_name,last_name,billing_country
)as temptable
where RowNumber=1