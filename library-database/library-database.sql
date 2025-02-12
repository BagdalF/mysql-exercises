drop database LibraryDatabase;

create database LibraryDatabase;
use LibraryDatabase;

--TABLES
create table Category (
    CategoryID int auto_increment primary key,
    CategoryName varchar(100) not null
);

create table Author (
    AuthorID int auto_increment primary key,
    AuthorName varchar(100) not null
);

create table Book (
    BookID int auto_increment primary key,
    Title varchar(255) not null,
    CategoryID int,
    AuthorID int,
    PublishingDate date,
    CopiesAvailable int,
    foreign key (CategoryID) references Category(CategoryID),
    foreign key (AuthorID) references Author(AuthorID)
);

create table Member (
    MemberID int auto_increment primary key,
    MemberName varchar(100) not null,
    MemberAddress varchar(200),
    PhoneNumber char(20)
);

create table Loan (
    LoanID int auto_increment primary key,
    MemberID int,
    BookID int,
    LoanDate date,
    ProvidedDevolutionDate date,
    RealDevolutionDate date,
    foreign key (MemberID) references Member(MemberID),
    foreign key (BookID) references Book(BookID)
);

-- SEEDING TABLES
insert into Category (CategoryName) values
('Tecnologia'),
('Ficção'),
('Ciência'),
('História'),
('Autoajuda');

insert into Author (AuthorName) values
('Carlos Silva'), 
('Maria Oliveira'), 
('João Souza'), 
('Ana Costa'), 
('Pedro Fernandes');

insert into Book (Title, CategoryID, AuthorID, PublishingDate, CopiesAvailable) 
values 
('Book de Sistemas', 1, 1, '2018-06-15', 13),
('História dos Sistemas', 1, 2, '2015-01-20', 4),
('Guia de Autoajuda', 5, 3, '2020-08-10', 82),
('Ciência Moderna', 3, 4, '2010-11-11', 21),
('Tecnologia Avançada', 1, 5, '2021-05-05', 5),
('Ficção Científica', 2, 1, '2012-02-14', 23),
('Mistério Antigo', 4, 2, '2005-11-23', 7),
('Autoajuda para Todos', 5, 3, '2023-03-10', 54),
('História Contemporânea', 4, 4, '2018-09-30', 5),
('Inovações Tecnológicas', 1, 5, '2019-07-21', 11);

insert into Member (MemberName, MemberAddress, PhoneNumber) 
values 
('Fernanda Lima', 'Av. Paulista, 1000, São Paulo, SP', '123456789'),
('Roberto Alves', 'Rua das Flores, 234, Rio de Janeiro, RJ', '987654321'),
('Juliana Pereira', 'Av. Brasil, 789, Belo Horizonte, MG', '111222333'),
('Lucas Martins', 'Rua do Carmo, 567, Salvador, BA', '444555666'),
('Gabriela Souza', 'Rua da Praia, 321, Porto Alegre, RS', '777888999'),
('Carlos Mendes', 'Rua Augusta, 987, São Paulo, SP', '112233445'),
('Beatriz Andrade', 'Rua dos Pinheiros, 543, Curitiba, PR', '667788990'),
('Felipe Santos', 'Rua das Palmeiras, 210, Fortaleza, CE', '556677889'),
('Mariana Ribeiro', 'Av. Atlântica, 765, Rio de Janeiro, RJ', '998877665'),
('Rafael Barbosa', 'Rua Afonso Pena, 432, Brasília, DF', '334455667');

insert into Loan (MemberID, BookID, LoanDate, ProvidedDevolutionDate, RealDevolutionDate) 
values 
(1, 1, '2024-01-01', '2024-01-15', '2024-01-14'),
(2, 2, '2024-02-01', '2024-02-15', '2024-02-10'),
(3, 3, '2024-10-26', '2024-10-30', null),
(4, 4, '2024-04-01', '2024-04-15', '2024-04-14'),
(5, 5, '2024-10-23', '2024-10-26', null),
(6, 6, '2024-06-01', '2024-06-15', '2024-06-14'),
(7, 7, '2024-07-01', '2024-07-15', null),
(8, 8, '2024-08-01', '2024-08-15', '2024-08-12'),
(9, 9, '2024-09-01', '2024-09-15', null),
(10, 6, '2024-10-15', '2024-10-25', '2024-10-14');

-- Query 1:
select AuthorName from Author where AuthorName like 'A%';

-- Query 2:
select Title from Book where Title like '%sistema%';

-- Query 3:
select BookID, Title from Book 
where PublishingDate < date_sub(curdate(), interval 5 year);

-- Query 4:
select Title from Book
where CopiesAvailable < 5 order by Title;

-- Query 5:
select Title from Book 
where BookID not in (select BookID from Loan);

-- Query 6:
update Loan
set RealDevolutionDate = curdate();

-- Query 7:
delete from Member 
where MemberID not in (select distinct MemberID from Loan);

-- Query 8:
select Book.Title, Author.AuthorName 
from Book
join Author on Book.AuthorID = Author.AuthorID;

-- Query 9:
select Loan.LoanDate, Member.MemberName, Book.Title 
from Loan
join Member on Loan.MemberID = Member.MemberID
join Book on Loan.BookID = Book.BookID
where year(Loan.LoanDate) = year(curdate());

-- Query 10:
select Category.CategoryName, Book.Title 
from Book
join Category on Book.CategoryID = Category.CategoryID;

-- Query 11:
select Book.Title, Loan.LoanDate, Loan.RealDevolutionDate 
from Book
join Loan on Book.BookID = Loan.BookID;

-- Query 12:
select Loan.LoanDate, Loan.RealDevolutionDate, Member.MemberName, Book.Title, Category.CategoryName Category, Author.AuthorName Author 
from Loan
join Member on Loan.MemberID = Member.MemberID
join Book on Loan.BookID = Book.BookID
join Category on Book.CategoryID = Category.CategoryID
join Author on Book.AuthorID = Author.AuthorID;

-- Query 13:
select count(*) TotalBooks from Book;

-- Query 14:
select count(*) TotalLoans 
from Loan
where year(LoanDate) = year(curdate()) - 1;

-- Query 15:
select Category.CategoryName, count(*) BookQuantity
from Category
join Book on Category.CategoryID = Book.CategoryID
group by Category.CategoryName;

-- Query 16:
select Book.Title, Member.MemberName, Loan.LoanDate
from Loan
inner join Book on Loan.BookID = Book.BookID
inner join Member on Loan.MemberID = Member.MemberID
where yearweek(Loan.LoanDate) = yearweek(curdate())
order by Loan.LoanDate;

-- Query 17:
select monthname(Loan.LoanDate) Month, count(*) TotalLoans
from Loan
where year(Loan.LoanDate) = year(curdate())
group by month(Loan.LoanDate), Month
order by month(Loan.LoanDate);