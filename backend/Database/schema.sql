-- =============================================
-- Badminton Booking - SQL Server Database Script
-- =============================================

CREATE DATABASE BadmintonBooking;
GO

USE BadmintonBooking;
GO

-- Bảng Users
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL DEFAULT 'player'
);

-- Bảng Courts (địa điểm / cụm sân)
CREATE TABLE Courts (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(200) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    OwnerId INT NOT NULL,
    FOREIGN KEY (OwnerId) REFERENCES Users(Id)
);

-- Bảng SubCourts (sân con trong mỗi địa điểm)
CREATE TABLE SubCourts (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(200) NOT NULL,
    CourtId INT NOT NULL,
    FOREIGN KEY (CourtId) REFERENCES Courts(Id) ON DELETE CASCADE
);

-- Bảng TimeSlots
CREATE TABLE TimeSlots (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    SubCourtId INT NOT NULL,
    Date DATE NOT NULL,
    StartTime NVARCHAR(10) NOT NULL,
    EndTime NVARCHAR(10) NOT NULL,
    IsBooked BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (SubCourtId) REFERENCES SubCourts(Id) ON DELETE CASCADE
);

-- Bảng Bookings
CREATE TABLE Bookings (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    TimeSlotId INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (TimeSlotId) REFERENCES TimeSlots(Id)
);

-- =============================================
-- Dữ liệu mẫu
-- =============================================

-- Thêm user mẫu (password: 123456)
INSERT INTO Users (Name, Phone, Password, Role) VALUES
(N'Admin', '0900000000', '123456', 'owner'),
(N'Nguyễn Văn A', '0901234567', '123456', 'player'),
(N'Trần Thị B', '0907654321', '123456', 'player');

-- Thêm sân mẫu
INSERT INTO Courts (Name, Address, OwnerId) VALUES
(N'Sân cầu lông Phú Cát', N'Khu CNC Hòa Lạc, Thạch Thất, Hà Nội', 1),
(N'Sân cầu lông Hòa Lạc', N'Thôn 3, Thạch Hòa, Thạch Thất, Hà Nội', 1);

-- Thêm sân con mẫu
INSERT INTO SubCourts (Name, CourtId) VALUES
(N'Sân 1', 1),
(N'Sân 2', 1),
(N'Sân 3', 1),
(N'Sân 1', 2),
(N'Sân 2', 2);

GO
