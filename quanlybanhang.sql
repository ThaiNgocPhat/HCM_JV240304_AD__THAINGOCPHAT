create database Quanlybanhang;
use Quanlybanhang;
drop database Quanlybanhang;

-- tạo bảng Category
create table Category (
    id int primary key auto_increment,
    name varchar(255) not null unique,
    status tinyint default 1 check (status in (0, 1))
);

-- Tạo bảng Room
create table Room (
    id int primary key auto_increment,
    name varchar(150) not null,
    status tinyint default 1 check (status in (0, 1)),
    price float not null check (price >= 100000),
    salePrice float default 0,
    createdDate timestamp default CURRENT_TIMESTAMP,
    categoryId int not null,
    foreign key (categoryId) references Category(id),
    index idx_name (name),
    index idx_createdDate (createdDate),
    index idx_price (price)
);

-- Tạo bảng Customer
create table Customer (
    id int primary key auto_increment,
    name varchar(150) not null,
    email varchar(150) unique not null check (email regexp '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'),
    phone varchar(50) unique not null,
    address varchar(255),
    createdDate timestamp default current_timestamp,
    gender tinyint not null default 1 check (gender in (0, 1)),
    birthday date not null
);


-- tạo bảng Booking
create table Booking (
    id int primary key auto_increment,
    customerId int not null,
    status tinyint default 1 check (status in (0, 1, 2, 3)),
    bookingDate datetime default current_timestamp,
    foreign key (customerId) references Customer(id)
);

-- tạo bảng BookingDetail
create table BookingDetail (
    bookingId int not null,
    roomId int not null,
    price float not null,
    startDate datetime not null,
    endDate datetime not null,
    primary key (bookingid, roomid),
    foreign key (bookingid) references Booking(id),
    foreign key (roomid) references Room(id)
);

-- thêm dữ liệu vào bảng Category
insert into Category (name) values
('Phòng đơn'),
('Phòng đôi'),
('Phòng Suite'),
('Phòng gia đình'),
('Phòng Executive');

-- thêm dữ liệu vào bảng Room
insert into Room (name, status, price, saleprice, categoryid) values
('Phòng đơn 1', 1, 200000, 180000, 1),
('Phòng đơn 2', 1, 220000, 190000, 1),
('Phòng đôi 1', 1, 300000, 250000, 2),
('Phòng đôi 2', 1, 320000, 270000, 2),
('Phòng Suite 1', 1, 500000, 450000, 3),
('Phòng Suite 2', 1, 550000, 480000, 3),
('Phòng gia đình 1', 1, 600000, 550000, 4),
('Phòng gia đình 2', 1, 620000, 570000, 4),
('Phòng Executive 1', 1, 800000, 750000, 5),
('Phòng Executive 2', 1, 820000, 770000, 5),
('Phòng đơn 3', 1, 210000, 190000, 1),
('Phòng đôi 3', 1, 310000, 260000, 2),
('Phòng Suite 3', 1, 530000, 460000, 3),
('Phòng gia đình 3', 1, 610000, 560000, 4),
('Phòng Executive 3', 1, 810000, 760000, 5);

-- thêm dữ liệu vào bảng Customer
insert into Customer (name, email, phone, address, gender, birthday) values
('Lê Trường Thọ', 'letruongtho@example.com', '0987654321', 'thôn Phú Sen Phú Hoà, Phú Yên', 1, '1985-05-15'),
('Nguyễn Văn An', 'nguyenvanan@example.com', '0912345678', '456 Trần Hưng Đạo, Hà Nội', 1, '1990-03-22'),
('Lê Thị Hoa', 'lethihhoa@example.com', '0923456789', '789 Lê Lai, Thành phố Hồ Chí Minh', 0, '1988-12-10');

-- thêm dữ liệu vào bảng Booking
insert into Booking (customerid, status) values
(1, 1), 
(2, 1), 
(3, 1); 

-- thêm dữ liệu vào bảng BookingDetail
insert into BookingDetail (bookingid, roomid, price, startdate, enddate) values
-- Hóa đơn 1 cho Lê Trường Thọ
(1, 1, 180000, '2024-09-01 14:00:00', '2024-09-05 12:00:00'),  
(1, 2, 190000, '2024-09-01 14:00:00', '2024-09-05 12:00:00'),  

-- Hóa đơn 2 cho Nguyễn Văn An
(2, 3, 250000, '2024-09-02 15:00:00', '2024-09-07 11:00:00'), 
(2, 4, 270000, '2024-09-02 15:00:00', '2024-09-07 11:00:00'), 

-- Hóa đơn 3 cho Lê Thị Hoa
(3, 5, 450000, '2024-09-03 10:00:00', '2024-09-08 10:00:00'), 
(3, 6, 480000, '2024-09-03 10:00:00', '2024-09-08 10:00:00'); 

-- ---------------YÊU CẦU 1------------------
-- 1.Lấy ra phòng có sắp xếp giảm dần theo price gồm các cột:id, name, price
-- saleprice, status, categoryname, creteddate
select
    r.id,
    r.name,
    r.price,
    r.salePrice,
    r.status,
    c.name as 'Tên danh mục',
    r.createdDate
from
    Room r
join
    Category c on r.categoryId = c.id;
    
-- 2.Lấy ra danh sách Category gồm:id,name,totalroom,status(0 là ẩn, 1 là hiện)
select
    c.id,
    c.name,
    count(r.id) as 'Tổng số phòng',
    c.status,
    -- Tính tổng số phòng đang hoạt động
    (select count(id) from Room where status = 1 and categoryId = c.id) as 'Phòng đang hoạt độ',
    -- Tính tổng số phòng ẩn
    (select count(id) from Room where status = 0 and categoryId = c.id) as 'Phòng ẩn',
    -- Tính tổng số phòng hiện
    (select count(id) from Room where status = 1 and categoryId = c.id) as 'Phòng hiện'
from
    Category c
left join
    Room r on c.id = r.categoryId
group by
    c.id,
    c.name,
    c.status;
    
-- 3.Truy vấn danh sách Customer gồm : id, name, email,phone, address,createddate,gender
-- birthday,age(suy ra từ birthday,gender nếu 0 là nam, 1 là nữ, 2 là khác
select
    c.id,
    c.name,
    c.email,
    c.phone,
    c.address,
    c.createdDate,
    c.gender,
    timestampdiff(year, c.birthday, curdate()) as 'Age',
    case
    when c.gender = 0 then 'Nam'
    when c.gender = 1 then 'Nữ'
    else 'Khác'
    end as 'Gender'
from
    Customer c;
    
    
-- --------------------YÊU CẦU 2--------------------------
-- 1.View v_getRoomInfo lấy danh sách 10 phòng cao nhất
create view  v_getRoomInfo as
select
    r.id,
    r.name,
    r.price,
    r.salePrice,
    c.name as 'Tên danh mục'
from
    Room r
join
    Category c on r.categoryId = c.id
order by
    r.salePrice desc
limit 10;


-- 2.View v_getBookingList hiển thị danh sách đặt phòng:id bookingdate,status,customername
-- email,phone,totalamount(status 0 là chưa duyệt, 1 là đã duyệt, 2 là thanh toán, 3 là đã huỷ
create view v_getBookingList as
select
    b.id bookingDate,
    b.status,
    c.name as 'Customer Name',
    c.email,
    c.phone,
    sum(bd.price * (bd.endDate - bd.startDate)) as 'Total Amount'
from
    Booking b
join 
    Customer c on b.customerId = c.id
join 
    BookingDetail bd on b.id = bd.bookingId
group by
    b.id,
    b.status,
    c.name,
    c.email,
    c.phone;

    
-- ---------------------YÊU CẦU 3----------------------
-- 1.Thủ tục addRoomInfo thực hiện thêm mới Room,khi gọi thủ tục truyền đầy đủ các giá trị của bảng Room(trừ id tự tăng)
delimiter //
create procedure addRoomInfo
    (in p_name varchar(100), 
     in p_price float, 
     in p_salePrice float, 
     in p_categoryId int, 
     in p_status tinyint)
begin
    insert into Room (name, price, salePrice, categoryId, status)
    values (p_name, p_price, p_salePrice, p_categoryId, p_status);
    -- Lấy ID của bản ghi vừa được thêm
    select last_insert_id() as 'Mã số phòng mới';
end//
delimiter ;


-- 2. Thủ tục getBookingByCustomerId hiển thị danh sách phiếu đặt phòng của khách hàng
-- theo id khách hàng gồm : id,bookingdate, status,totalamount(status 0 là chưa duyệt, 1 là đã duyệt, 2 là thanh toán, 3 là đã huỷ)
-- khi gọi truyền id của khách hàng
delimiter //
create procedure getBookingByCustomerId
    (in p_customerId int)
begin
select
    b.id bookingDate,
    b.status,
    c.name as 'Customer Name',
    c.email,
    c.phone,
    sum(bd.price * (bd.endDate - bd.startDate)) as 'Total Amount'
from
    Booking b
join 
    Customer c on b.customerId = c.id
    join 
    BookingDetail bd on b.id = bd.bookingId
    where c.id = p_customerId
    group by
    b.id,
    b.status,
    c.name,
    c.email,
    c.phone;
end//
delimiter ;

-- 3.Thủ tục getRoomPaginate lấy danh sách phòng có phân trang gồm : id,name,price
-- saleprice , khi gọi thủ tục truyền vào limit và page



-- ------------------------YÊU CẦU 4---------------------------
-- 1.Tạo một trigger tr_Check_Value sao cho khi thêm hoặc sửa phòng Room nếu giá trị cột price > 5000000 thì tự chuyển về 5000000
-- và in ra thông báo 'Giá phòng lớn nhất 5 triệu'
delimiter //
create trigger  tr_Check_Value
after insert on Room
for each row
begin
    if new.price > 5000000 then
    update Room set price = 5000000 where id = new.id;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Giá phòng lớn hơn 5 triệu';
    END IF;
end//
delimiter ;


-- 2.Tạo trigger tr_check_Room_NotAllow khi thực hiện đặt phòng, nêú ngày đến (startdate)
-- và ngày đi (enddate) của đơn hiện tại mà phòng đã có người đặt rồi thì in ra thông báo 'Phòng đã có người đặt'
delimiter //
create trigger tr_check_Room_NotAllow
before insert on BookingDetail
for each row
begin
    if exists (
        select 1
        from BookingDetail
        where roomId = new.roomId
        and (
            (new.startDate < endDate and new.endDate > startDate)
        )
        and bookingId != new.bookingId
    ) then
        signal sqlstate '45000'
        set message_text = 'Phòng đã có người đặt trong khoảng thời gian này';
    end if;
end//
delimiter ;