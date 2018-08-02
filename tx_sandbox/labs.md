## Bookstore TX Sandbox
##TOC
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->
* [Bookstore TX Sandbox](#bookstore-tx-sandbox)
* [Bookstore TX Sandbox](#bookstore-tx-sandbox)
* [TOC](#toc)
	* [Overview](#overview)
	* [Online Bookstore Data](#online-bookstore-data)
	* [System Info](#system-info)
* [Labs](#labs)
	* [General](#general)
	* [Queries](#queries)
		* [Books](#books)
		* [Customers](#customers)

<!-- /code_chunk_output -->
### Overview

### Online Bookstore Data

This sandbox is based on procedural generated data representing data for a typical online bookstore.
In the examples below we will try to answer the typical questions every business user has at some point when his business catch some speed.
Like “How am I doing?”, “What can be improved?” etc.

### System Info

The data is loaded in a MariaDB Server  one of the most popular open source databases in the world. It is the default database in leading Linux distributions – Arch Linux, CentOS, Debian, Fedora, Manjaro, openSUSE, Red Hat Enterprise Linux and SUSE Linux Enterprise, to name a few.

**The data size:**
Books: 5000 rows
Cards: 1,122,245 rows
Emails: 1,796,966 rows
Phones: 1,698,696 rows
Addresses: 1,867,567 rows
Transactions: 15,413,748 rows
LoyaltyPoints: 1,259,978 rows
Customers: 1,403,909 rows
Covers: 20 rows
TransactionTypes: 3 rows
MaritalStatuses: 5 rows

## Labs
### General 
 Your database is prepared and the sandbox data is loaded. Lets start by choosing the database we want to work on. In this case **bookstore** database.
```sql
USE DATABASE bookstore;
```

We can check what tables we have.
```sql
SHOW TABLES;
```

### Queries
#### Books

In this first part we will focus mainly on our main commodity - the books. We want to know what we offer to our customers and how can be improved.
Lets start by answering our first question.
**Q:**  How many books do we sell?
```sql
SELECT COUNT(*) FROM bookstore.books
```

```
Total Books 
5000
```

This was easy question 5000.
Lets try something harder.

**Q:** We are trying to position our online bookstore towards Fantasy and Sci-Fi theme, but we are also trying to provide good variety of books as well.
Did we achieve those goals?
TODO: Query Total number of books in Our Bookstore
It looks like we are spot on targeting our audience.

Now something more tangable.

Q:Are we making good profit from our focus categories ?
TODO: Query Profitability Potential by Genre
I looks like Fantasy and Sci-Fi books have good potential for profit, if they sell.

Now lets check if we provide enough variety in those categories. We are targeting Sci-Fi and Fantasy fans. Our catalog should be as complete as possible.
**Q:** Do we provide enough variety ?

TODO: Query Variety by Genre
The variety chart shows that we have covered Sci-Fi and Fantasy fans but also we have substential variety Romance and Children books.
We might want to explore the profitability potential those two categories.
Lets get back and click settings above and deselect items the chart now presents the profitability potential of those books.
It looks like Romance and Children are not very profitable, but Classics are.

As a result from this quick anlysis we already can make a decision for improvement in the future. Like how our customers like the new changes?; are they going to buy those books? etc.

Let try to identify who our customers are in the next section.

#### Customers

In this section we will try to identify who our customers are ? what are their preferences? how likely is for them to buy somethin out of their main focus.

Lets try to make a demographical profile of our customers.

**Q:** Who is our customer ?
   
TODO: Query Customer Profile
Those we demographics only. 
But we want to know more about their bying habbits.
How much they buy?
How much they spend?
What do they buy?

But lets start with the biggest question.
**Q:** Who spends more men or women ?

TODO: Query Orders Distribution by Sex
TODO: Query Top Buyers Distribution by Sex

It looks like women buy more.
But men lead the cart of most orders per person.

**Q:**  But do the younger people read more than seniores ?
Lets find out.

TODO: Query Order Distribution by Age

Lets focus on our top customers and try to profile them in order to answer the following question:

**Q:** What are the reading preferencess of our top customers?
TODO: Query top customers reading profile

Conclusion …
