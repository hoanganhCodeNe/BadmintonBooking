USE [master]
GO
/****** Object:  Database [BadmintonBooking]    Script Date: 3/17/2026 5:29:51 PM ******/
CREATE DATABASE [BadmintonBooking]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BadmintonBooking', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\BadmintonBooking.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BadmintonBooking_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\BadmintonBooking_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BadmintonBooking] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BadmintonBooking].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BadmintonBooking] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BadmintonBooking] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BadmintonBooking] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BadmintonBooking] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BadmintonBooking] SET ARITHABORT OFF 
GO
ALTER DATABASE [BadmintonBooking] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [BadmintonBooking] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BadmintonBooking] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BadmintonBooking] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BadmintonBooking] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BadmintonBooking] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BadmintonBooking] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BadmintonBooking] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BadmintonBooking] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BadmintonBooking] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BadmintonBooking] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BadmintonBooking] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BadmintonBooking] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BadmintonBooking] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BadmintonBooking] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BadmintonBooking] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [BadmintonBooking] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BadmintonBooking] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BadmintonBooking] SET  MULTI_USER 
GO
ALTER DATABASE [BadmintonBooking] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BadmintonBooking] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BadmintonBooking] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BadmintonBooking] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BadmintonBooking] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BadmintonBooking] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [BadmintonBooking] SET QUERY_STORE = ON
GO
ALTER DATABASE [BadmintonBooking] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BadmintonBooking]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 3/17/2026 5:29:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bookings]    Script Date: 3/17/2026 5:29:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bookings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[TimeSlotId] [int] NOT NULL,
	[Status] [nvarchar](max) NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Bookings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Courts]    Script Date: 3/17/2026 5:29:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
	[OwnerId] [int] NOT NULL,
	[AfternoonPrice] [decimal](18, 2) NOT NULL,
	[EveningPrice] [decimal](18, 2) NOT NULL,
	[ImageUrl] [nvarchar](1000) NULL,
	[MorningPrice] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_Courts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubCourts]    Script Date: 3/17/2026 5:29:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubCourts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[CourtId] [int] NOT NULL,
 CONSTRAINT [PK_SubCourts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimeSlots]    Script Date: 3/17/2026 5:29:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeSlots](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SubCourtId] [int] NOT NULL,
	[Date] [nvarchar](10) NOT NULL,
	[StartTime] [nvarchar](10) NOT NULL,
	[EndTime] [nvarchar](10) NOT NULL,
	[IsBooked] [bit] NOT NULL,
 CONSTRAINT [PK_TimeSlots] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 3/17/2026 5:29:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Phone] [nvarchar](20) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[Role] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20260310070522_InitialCreate', N'8.0.0')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20260316125558_AddCourtImageAndPrices', N'8.0.0')
GO
SET IDENTITY_INSERT [dbo].[Bookings] ON 

INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (1, 3, 1, N'cancelled', CAST(N'2026-03-12T12:11:25.4370816' AS DateTime2))
INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (2, 3, 1, N'cancelled', CAST(N'2026-03-12T12:25:07.7153176' AS DateTime2))
INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (3, 3, 1, N'approved', CAST(N'2026-03-12T12:38:05.9536529' AS DateTime2))
INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (4, 3, 9, N'approved', CAST(N'2026-03-12T13:00:45.6574499' AS DateTime2))
INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (1002, 4, 1013, N'approved', CAST(N'2026-03-15T16:53:50.4738433' AS DateTime2))
INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (1003, 3, 1014, N'approved', CAST(N'2026-03-15T16:55:57.0076580' AS DateTime2))
INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (1004, 4, 1015, N'rejected', CAST(N'2026-03-15T16:59:50.6961711' AS DateTime2))
INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (1005, 4, 1014, N'rejected', CAST(N'2026-03-15T17:07:24.6898978' AS DateTime2))
INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (1006, 5, 1134, N'rejected', CAST(N'2026-03-16T18:55:38.6792051' AS DateTime2))
INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (1007, 4, 1153, N'cancelled', CAST(N'2026-03-16T20:33:12.8420938' AS DateTime2))
INSERT [dbo].[Bookings] ([Id], [UserId], [TimeSlotId], [Status], [CreatedAt]) VALUES (1008, 2, 1153, N'rejected', CAST(N'2026-03-16T20:33:54.8634344' AS DateTime2))
SET IDENTITY_INSERT [dbo].[Bookings] OFF
GO
SET IDENTITY_INSERT [dbo].[Courts] ON 

INSERT [dbo].[Courts] ([Id], [Name], [Address], [OwnerId], [AfternoonPrice], [EveningPrice], [ImageUrl], [MorningPrice]) VALUES (1, N'Sân cầu lông 368', N'Số 854 thôn Thái Bình, Bình Yên, Thạch Thất, Hà Nội 13100, Vietnam', 2, CAST(50000.00 AS Decimal(18, 2)), CAST(80000.00 AS Decimal(18, 2)), N'["http://192.168.12.103:5000/uploads/courts/1/e9b31f41fc494eddbc5de343d5ddf07a.jpg","http://192.168.12.103:5000/uploads/courts/1/fe95a7efa94e4fe4bb9a567ececa441e.jpg","http://192.168.12.103:5000/uploads/courts/1/8f12efaf48394c7293eaab0721c9f6c6.jpg"]', CAST(20000.00 AS Decimal(18, 2)))
INSERT [dbo].[Courts] ([Id], [Name], [Address], [OwnerId], [AfternoonPrice], [EveningPrice], [ImageUrl], [MorningPrice]) VALUES (2, N'Sân cầu lông Quyết Khải', N'Sân cầu lông Quyết Khải', 2, CAST(50000.00 AS Decimal(18, 2)), CAST(80000.00 AS Decimal(18, 2)), NULL, CAST(22000.00 AS Decimal(18, 2)))
INSERT [dbo].[Courts] ([Id], [Name], [Address], [OwnerId], [AfternoonPrice], [EveningPrice], [ImageUrl], [MorningPrice]) VALUES (3, N'Sân cầu  lông Hiếu Lê', N'Sân Cầu Lông Kim Bông Thạch Thất, Hà Nội', 2, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), NULL, CAST(10000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[Courts] OFF
GO
SET IDENTITY_INSERT [dbo].[SubCourts] ON 

INSERT [dbo].[SubCourts] ([Id], [Name], [CourtId]) VALUES (1, N'Sân 1', 1)
INSERT [dbo].[SubCourts] ([Id], [Name], [CourtId]) VALUES (2, N'Sân 2', 1)
INSERT [dbo].[SubCourts] ([Id], [Name], [CourtId]) VALUES (3, N'Sân 3', 1)
INSERT [dbo].[SubCourts] ([Id], [Name], [CourtId]) VALUES (4, N'Sân 1', 2)
INSERT [dbo].[SubCourts] ([Id], [Name], [CourtId]) VALUES (5, N'Sân 2', 2)
INSERT [dbo].[SubCourts] ([Id], [Name], [CourtId]) VALUES (8, N'Sân 1', 3)
SET IDENTITY_INSERT [dbo].[SubCourts] OFF
GO
SET IDENTITY_INSERT [dbo].[TimeSlots] ON 

INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1, 1, N'2026-03-12', N'6:00', N'7:00', 1)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (2, 1, N'2026-03-12', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (3, 1, N'2026-03-12', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (4, 1, N'2026-03-12', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (5, 1, N'2026-03-12', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (6, 1, N'2026-03-12', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (7, 1, N'2026-03-12', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (8, 1, N'2026-03-12', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (9, 1, N'2026-03-12', N'14:00', N'15:00', 1)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (10, 1, N'2026-03-12', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (11, 1, N'2026-03-12', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (12, 1, N'2026-03-12', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (13, 1, N'2026-03-12', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (14, 1, N'2026-03-12', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (15, 1, N'2026-03-12', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (16, 1, N'2026-03-12', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (17, 1, N'2026-03-12', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (18, 2, N'2026-03-12', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (19, 2, N'2026-03-12', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (20, 2, N'2026-03-12', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (21, 2, N'2026-03-12', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (22, 2, N'2026-03-12', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (23, 2, N'2026-03-12', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (24, 2, N'2026-03-12', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (25, 2, N'2026-03-12', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (26, 2, N'2026-03-12', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (27, 2, N'2026-03-12', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (28, 2, N'2026-03-12', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (29, 2, N'2026-03-12', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (30, 2, N'2026-03-12', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (31, 2, N'2026-03-12', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (32, 2, N'2026-03-12', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (33, 2, N'2026-03-12', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (34, 2, N'2026-03-12', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (35, 3, N'2026-03-12', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (36, 3, N'2026-03-12', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (37, 3, N'2026-03-12', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (38, 3, N'2026-03-12', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (39, 3, N'2026-03-12', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (40, 3, N'2026-03-12', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (41, 3, N'2026-03-12', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (42, 3, N'2026-03-12', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (43, 3, N'2026-03-12', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (44, 3, N'2026-03-12', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (45, 3, N'2026-03-12', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (46, 3, N'2026-03-12', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (47, 3, N'2026-03-12', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (48, 3, N'2026-03-12', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (49, 3, N'2026-03-12', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (50, 3, N'2026-03-12', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (51, 3, N'2026-03-12', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (52, 4, N'2026-03-12', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (53, 4, N'2026-03-12', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (54, 4, N'2026-03-12', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (55, 4, N'2026-03-12', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (56, 4, N'2026-03-12', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (57, 4, N'2026-03-12', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (58, 4, N'2026-03-12', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (59, 4, N'2026-03-12', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (60, 4, N'2026-03-12', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (61, 4, N'2026-03-12', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (62, 4, N'2026-03-12', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (63, 4, N'2026-03-12', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (64, 4, N'2026-03-12', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (65, 4, N'2026-03-12', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (66, 4, N'2026-03-12', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (67, 4, N'2026-03-12', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (68, 4, N'2026-03-12', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (69, 5, N'2026-03-12', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (70, 5, N'2026-03-12', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (71, 5, N'2026-03-12', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (72, 5, N'2026-03-12', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (73, 5, N'2026-03-12', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (74, 5, N'2026-03-12', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (75, 5, N'2026-03-12', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (76, 5, N'2026-03-12', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (77, 5, N'2026-03-12', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (78, 5, N'2026-03-12', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (79, 5, N'2026-03-12', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (80, 5, N'2026-03-12', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (81, 5, N'2026-03-12', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (82, 5, N'2026-03-12', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (83, 5, N'2026-03-12', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (84, 5, N'2026-03-12', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (85, 5, N'2026-03-12', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (86, 1, N'2026-03-13', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (87, 1, N'2026-03-13', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (88, 1, N'2026-03-13', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (89, 1, N'2026-03-13', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (90, 1, N'2026-03-13', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (91, 1, N'2026-03-13', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (92, 1, N'2026-03-13', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (93, 1, N'2026-03-13', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (94, 1, N'2026-03-13', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (95, 1, N'2026-03-13', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (96, 1, N'2026-03-13', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (97, 1, N'2026-03-13', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (98, 1, N'2026-03-13', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (99, 1, N'2026-03-13', N'19:00', N'20:00', 0)
GO
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (100, 1, N'2026-03-13', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (101, 1, N'2026-03-13', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (102, 1, N'2026-03-13', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (103, 2, N'2026-03-13', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (104, 2, N'2026-03-13', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (105, 2, N'2026-03-13', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (106, 2, N'2026-03-13', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (107, 2, N'2026-03-13', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (108, 2, N'2026-03-13', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (109, 2, N'2026-03-13', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (110, 2, N'2026-03-13', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (111, 2, N'2026-03-13', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (112, 2, N'2026-03-13', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (113, 2, N'2026-03-13', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (114, 2, N'2026-03-13', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (115, 2, N'2026-03-13', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (116, 2, N'2026-03-13', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (117, 2, N'2026-03-13', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (118, 2, N'2026-03-13', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (119, 2, N'2026-03-13', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (120, 3, N'2026-03-13', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (121, 3, N'2026-03-13', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (122, 3, N'2026-03-13', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (123, 3, N'2026-03-13', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (124, 3, N'2026-03-13', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (125, 3, N'2026-03-13', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (126, 3, N'2026-03-13', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (127, 3, N'2026-03-13', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (128, 3, N'2026-03-13', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (129, 3, N'2026-03-13', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (130, 3, N'2026-03-13', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (131, 3, N'2026-03-13', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (132, 3, N'2026-03-13', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (133, 3, N'2026-03-13', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (134, 3, N'2026-03-13', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (135, 3, N'2026-03-13', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (136, 3, N'2026-03-13', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (137, 1, N'2026-03-31', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (138, 1, N'2026-03-31', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (139, 1, N'2026-03-31', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (140, 1, N'2026-03-31', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (141, 1, N'2026-03-31', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (142, 1, N'2026-03-31', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (143, 1, N'2026-03-31', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (144, 1, N'2026-03-31', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (145, 1, N'2026-03-31', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (146, 1, N'2026-03-31', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (147, 1, N'2026-03-31', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (148, 1, N'2026-03-31', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (149, 1, N'2026-03-31', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (150, 1, N'2026-03-31', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (151, 1, N'2026-03-31', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (152, 1, N'2026-03-31', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (153, 1, N'2026-03-31', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (154, 2, N'2026-03-31', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (155, 2, N'2026-03-31', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (156, 2, N'2026-03-31', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (157, 2, N'2026-03-31', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (158, 2, N'2026-03-31', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (159, 2, N'2026-03-31', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (160, 2, N'2026-03-31', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (161, 2, N'2026-03-31', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (162, 2, N'2026-03-31', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (163, 2, N'2026-03-31', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (164, 2, N'2026-03-31', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (165, 2, N'2026-03-31', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (166, 2, N'2026-03-31', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (167, 2, N'2026-03-31', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (168, 2, N'2026-03-31', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (169, 2, N'2026-03-31', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (170, 2, N'2026-03-31', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (171, 3, N'2026-03-31', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (172, 3, N'2026-03-31', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (173, 3, N'2026-03-31', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (174, 3, N'2026-03-31', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (175, 3, N'2026-03-31', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (176, 3, N'2026-03-31', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (177, 3, N'2026-03-31', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (178, 3, N'2026-03-31', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (179, 3, N'2026-03-31', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (180, 3, N'2026-03-31', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (181, 3, N'2026-03-31', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (182, 3, N'2026-03-31', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (183, 3, N'2026-03-31', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (184, 3, N'2026-03-31', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (185, 3, N'2026-03-31', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (186, 3, N'2026-03-31', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (187, 3, N'2026-03-31', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (188, 1, N'2026-03-18', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (189, 1, N'2026-03-18', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (190, 1, N'2026-03-18', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (191, 1, N'2026-03-18', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (192, 1, N'2026-03-18', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (193, 1, N'2026-03-18', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (194, 1, N'2026-03-18', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (195, 1, N'2026-03-18', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (196, 1, N'2026-03-18', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (197, 1, N'2026-03-18', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (198, 1, N'2026-03-18', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (199, 1, N'2026-03-18', N'17:00', N'18:00', 0)
GO
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (200, 1, N'2026-03-18', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (201, 1, N'2026-03-18', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (202, 1, N'2026-03-18', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (203, 1, N'2026-03-18', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (204, 1, N'2026-03-18', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (205, 2, N'2026-03-18', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (206, 2, N'2026-03-18', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (207, 2, N'2026-03-18', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (208, 2, N'2026-03-18', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (209, 2, N'2026-03-18', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (210, 2, N'2026-03-18', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (211, 2, N'2026-03-18', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (212, 2, N'2026-03-18', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (213, 2, N'2026-03-18', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (214, 2, N'2026-03-18', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (215, 2, N'2026-03-18', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (216, 2, N'2026-03-18', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (217, 2, N'2026-03-18', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (218, 2, N'2026-03-18', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (219, 2, N'2026-03-18', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (220, 2, N'2026-03-18', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (221, 2, N'2026-03-18', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (222, 3, N'2026-03-18', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (223, 3, N'2026-03-18', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (224, 3, N'2026-03-18', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (225, 3, N'2026-03-18', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (226, 3, N'2026-03-18', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (227, 3, N'2026-03-18', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (228, 3, N'2026-03-18', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (229, 3, N'2026-03-18', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (230, 3, N'2026-03-18', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (231, 3, N'2026-03-18', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (232, 3, N'2026-03-18', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (233, 3, N'2026-03-18', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (234, 3, N'2026-03-18', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (235, 3, N'2026-03-18', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (236, 3, N'2026-03-18', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (237, 3, N'2026-03-18', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (238, 3, N'2026-03-18', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (239, 4, N'2026-03-13', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (240, 4, N'2026-03-13', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (241, 4, N'2026-03-13', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (242, 4, N'2026-03-13', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (243, 4, N'2026-03-13', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (244, 4, N'2026-03-13', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (245, 4, N'2026-03-13', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (246, 4, N'2026-03-13', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (247, 4, N'2026-03-13', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (248, 4, N'2026-03-13', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (249, 4, N'2026-03-13', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (250, 4, N'2026-03-13', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (251, 4, N'2026-03-13', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (252, 4, N'2026-03-13', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (253, 4, N'2026-03-13', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (254, 4, N'2026-03-13', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (255, 4, N'2026-03-13', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (256, 5, N'2026-03-13', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (257, 5, N'2026-03-13', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (258, 5, N'2026-03-13', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (259, 5, N'2026-03-13', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (260, 5, N'2026-03-13', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (261, 5, N'2026-03-13', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (262, 5, N'2026-03-13', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (263, 5, N'2026-03-13', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (264, 5, N'2026-03-13', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (265, 5, N'2026-03-13', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (266, 5, N'2026-03-13', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (267, 5, N'2026-03-13', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (268, 5, N'2026-03-13', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (269, 5, N'2026-03-13', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (270, 5, N'2026-03-13', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (271, 5, N'2026-03-13', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (272, 5, N'2026-03-13', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (273, 4, N'2026-03-27', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (274, 4, N'2026-03-27', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (275, 4, N'2026-03-27', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (276, 4, N'2026-03-27', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (277, 4, N'2026-03-27', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (278, 4, N'2026-03-27', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (279, 4, N'2026-03-27', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (280, 4, N'2026-03-27', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (281, 4, N'2026-03-27', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (282, 4, N'2026-03-27', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (283, 4, N'2026-03-27', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (284, 4, N'2026-03-27', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (285, 4, N'2026-03-27', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (286, 4, N'2026-03-27', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (287, 4, N'2026-03-27', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (288, 4, N'2026-03-27', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (289, 4, N'2026-03-27', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (290, 5, N'2026-03-27', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (291, 5, N'2026-03-27', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (292, 5, N'2026-03-27', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (293, 5, N'2026-03-27', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (294, 5, N'2026-03-27', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (295, 5, N'2026-03-27', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (296, 5, N'2026-03-27', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (297, 5, N'2026-03-27', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (298, 5, N'2026-03-27', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (299, 5, N'2026-03-27', N'15:00', N'16:00', 0)
GO
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (300, 5, N'2026-03-27', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (301, 5, N'2026-03-27', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (302, 5, N'2026-03-27', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (303, 5, N'2026-03-27', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (304, 5, N'2026-03-27', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (305, 5, N'2026-03-27', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (306, 5, N'2026-03-27', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (307, 4, N'2026-03-31', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (308, 4, N'2026-03-31', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (309, 4, N'2026-03-31', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (310, 4, N'2026-03-31', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (311, 4, N'2026-03-31', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (312, 4, N'2026-03-31', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (313, 4, N'2026-03-31', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (314, 4, N'2026-03-31', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (315, 4, N'2026-03-31', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (316, 4, N'2026-03-31', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (317, 4, N'2026-03-31', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (318, 4, N'2026-03-31', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (319, 4, N'2026-03-31', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (320, 4, N'2026-03-31', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (321, 4, N'2026-03-31', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (322, 4, N'2026-03-31', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (323, 4, N'2026-03-31', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (324, 5, N'2026-03-31', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (325, 5, N'2026-03-31', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (326, 5, N'2026-03-31', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (327, 5, N'2026-03-31', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (328, 5, N'2026-03-31', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (329, 5, N'2026-03-31', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (330, 5, N'2026-03-31', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (331, 5, N'2026-03-31', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (332, 5, N'2026-03-31', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (333, 5, N'2026-03-31', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (334, 5, N'2026-03-31', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (335, 5, N'2026-03-31', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (336, 5, N'2026-03-31', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (337, 5, N'2026-03-31', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (338, 5, N'2026-03-31', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (339, 5, N'2026-03-31', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (340, 5, N'2026-03-31', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1002, 1, N'2026-03-15', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1003, 1, N'2026-03-15', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1004, 1, N'2026-03-15', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1005, 1, N'2026-03-15', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1006, 1, N'2026-03-15', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1007, 1, N'2026-03-15', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1008, 1, N'2026-03-15', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1009, 1, N'2026-03-15', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1010, 1, N'2026-03-15', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1011, 1, N'2026-03-15', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1012, 1, N'2026-03-15', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1013, 1, N'2026-03-15', N'17:00', N'18:00', 1)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1014, 1, N'2026-03-15', N'18:00', N'19:00', 1)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1015, 1, N'2026-03-15', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1016, 1, N'2026-03-15', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1017, 1, N'2026-03-15', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1018, 1, N'2026-03-15', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1019, 2, N'2026-03-15', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1020, 2, N'2026-03-15', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1021, 2, N'2026-03-15', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1022, 2, N'2026-03-15', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1023, 2, N'2026-03-15', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1024, 2, N'2026-03-15', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1025, 2, N'2026-03-15', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1026, 2, N'2026-03-15', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1027, 2, N'2026-03-15', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1028, 2, N'2026-03-15', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1029, 2, N'2026-03-15', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1030, 2, N'2026-03-15', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1031, 2, N'2026-03-15', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1032, 2, N'2026-03-15', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1033, 2, N'2026-03-15', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1034, 2, N'2026-03-15', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1035, 2, N'2026-03-15', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1036, 3, N'2026-03-15', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1037, 3, N'2026-03-15', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1038, 3, N'2026-03-15', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1039, 3, N'2026-03-15', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1040, 3, N'2026-03-15', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1041, 3, N'2026-03-15', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1042, 3, N'2026-03-15', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1043, 3, N'2026-03-15', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1044, 3, N'2026-03-15', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1045, 3, N'2026-03-15', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1046, 3, N'2026-03-15', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1047, 3, N'2026-03-15', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1048, 3, N'2026-03-15', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1049, 3, N'2026-03-15', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1050, 3, N'2026-03-15', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1051, 3, N'2026-03-15', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1052, 3, N'2026-03-15', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1053, 4, N'2026-03-15', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1054, 4, N'2026-03-15', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1055, 4, N'2026-03-15', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1056, 4, N'2026-03-15', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1057, 4, N'2026-03-15', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1058, 4, N'2026-03-15', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1059, 4, N'2026-03-15', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1060, 4, N'2026-03-15', N'13:00', N'14:00', 0)
GO
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1061, 4, N'2026-03-15', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1062, 4, N'2026-03-15', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1063, 4, N'2026-03-15', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1064, 4, N'2026-03-15', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1065, 4, N'2026-03-15', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1066, 4, N'2026-03-15', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1067, 4, N'2026-03-15', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1068, 4, N'2026-03-15', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1069, 4, N'2026-03-15', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1070, 5, N'2026-03-15', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1071, 5, N'2026-03-15', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1072, 5, N'2026-03-15', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1073, 5, N'2026-03-15', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1074, 5, N'2026-03-15', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1075, 5, N'2026-03-15', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1076, 5, N'2026-03-15', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1077, 5, N'2026-03-15', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1078, 5, N'2026-03-15', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1079, 5, N'2026-03-15', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1080, 5, N'2026-03-15', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1081, 5, N'2026-03-15', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1082, 5, N'2026-03-15', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1083, 5, N'2026-03-15', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1084, 5, N'2026-03-15', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1085, 5, N'2026-03-15', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1086, 5, N'2026-03-15', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1087, 4, N'2026-03-16', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1088, 4, N'2026-03-16', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1089, 4, N'2026-03-16', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1090, 4, N'2026-03-16', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1091, 4, N'2026-03-16', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1092, 4, N'2026-03-16', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1093, 4, N'2026-03-16', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1094, 4, N'2026-03-16', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1095, 4, N'2026-03-16', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1096, 4, N'2026-03-16', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1097, 4, N'2026-03-16', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1098, 4, N'2026-03-16', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1099, 4, N'2026-03-16', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1100, 4, N'2026-03-16', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1101, 4, N'2026-03-16', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1102, 4, N'2026-03-16', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1103, 4, N'2026-03-16', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1104, 5, N'2026-03-16', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1105, 5, N'2026-03-16', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1106, 5, N'2026-03-16', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1107, 5, N'2026-03-16', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1108, 5, N'2026-03-16', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1109, 5, N'2026-03-16', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1110, 5, N'2026-03-16', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1111, 5, N'2026-03-16', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1112, 5, N'2026-03-16', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1113, 5, N'2026-03-16', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1114, 5, N'2026-03-16', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1115, 5, N'2026-03-16', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1116, 5, N'2026-03-16', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1117, 5, N'2026-03-16', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1118, 5, N'2026-03-16', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1119, 5, N'2026-03-16', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1120, 5, N'2026-03-16', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1121, 8, N'2026-03-16', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1122, 8, N'2026-03-16', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1123, 8, N'2026-03-16', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1124, 8, N'2026-03-16', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1125, 8, N'2026-03-16', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1126, 8, N'2026-03-16', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1127, 8, N'2026-03-16', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1128, 8, N'2026-03-16', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1129, 8, N'2026-03-16', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1130, 8, N'2026-03-16', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1131, 8, N'2026-03-16', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1132, 8, N'2026-03-16', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1133, 8, N'2026-03-16', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1134, 8, N'2026-03-16', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1135, 8, N'2026-03-16', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1136, 8, N'2026-03-16', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1137, 8, N'2026-03-16', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1138, 1, N'2026-03-16', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1139, 1, N'2026-03-16', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1140, 1, N'2026-03-16', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1141, 1, N'2026-03-16', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1142, 1, N'2026-03-16', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1143, 1, N'2026-03-16', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1144, 1, N'2026-03-16', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1145, 1, N'2026-03-16', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1146, 1, N'2026-03-16', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1147, 1, N'2026-03-16', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1148, 1, N'2026-03-16', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1149, 1, N'2026-03-16', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1150, 1, N'2026-03-16', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1151, 1, N'2026-03-16', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1152, 1, N'2026-03-16', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1153, 1, N'2026-03-16', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1154, 1, N'2026-03-16', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1155, 2, N'2026-03-16', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1156, 2, N'2026-03-16', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1157, 2, N'2026-03-16', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1158, 2, N'2026-03-16', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1159, 2, N'2026-03-16', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1160, 2, N'2026-03-16', N'11:00', N'12:00', 0)
GO
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1161, 2, N'2026-03-16', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1162, 2, N'2026-03-16', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1163, 2, N'2026-03-16', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1164, 2, N'2026-03-16', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1165, 2, N'2026-03-16', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1166, 2, N'2026-03-16', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1167, 2, N'2026-03-16', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1168, 2, N'2026-03-16', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1169, 2, N'2026-03-16', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1170, 2, N'2026-03-16', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1171, 2, N'2026-03-16', N'22:00', N'23:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1172, 3, N'2026-03-16', N'6:00', N'7:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1173, 3, N'2026-03-16', N'7:00', N'8:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1174, 3, N'2026-03-16', N'8:00', N'9:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1175, 3, N'2026-03-16', N'9:00', N'10:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1176, 3, N'2026-03-16', N'10:00', N'11:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1177, 3, N'2026-03-16', N'11:00', N'12:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1178, 3, N'2026-03-16', N'12:00', N'13:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1179, 3, N'2026-03-16', N'13:00', N'14:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1180, 3, N'2026-03-16', N'14:00', N'15:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1181, 3, N'2026-03-16', N'15:00', N'16:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1182, 3, N'2026-03-16', N'16:00', N'17:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1183, 3, N'2026-03-16', N'17:00', N'18:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1184, 3, N'2026-03-16', N'18:00', N'19:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1185, 3, N'2026-03-16', N'19:00', N'20:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1186, 3, N'2026-03-16', N'20:00', N'21:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1187, 3, N'2026-03-16', N'21:00', N'22:00', 0)
INSERT [dbo].[TimeSlots] ([Id], [SubCourtId], [Date], [StartTime], [EndTime], [IsBooked]) VALUES (1188, 3, N'2026-03-16', N'22:00', N'23:00', 0)
SET IDENTITY_INSERT [dbo].[TimeSlots] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [Name], [Phone], [Password], [Role]) VALUES (1, N'Admin', N'0900000000', N'123456', N'admin')
INSERT [dbo].[Users] ([Id], [Name], [Phone], [Password], [Role]) VALUES (2, N'Nguyễn Văn A', N'0901234567', N'123456', N'owner')
INSERT [dbo].[Users] ([Id], [Name], [Phone], [Password], [Role]) VALUES (3, N'Trần Thị B', N'0907654321', N'123456', N'player')
INSERT [dbo].[Users] ([Id], [Name], [Phone], [Password], [Role]) VALUES (4, N'hoang anh', N'0942086830', N'Anh20041', N'player')
INSERT [dbo].[Users] ([Id], [Name], [Phone], [Password], [Role]) VALUES (5, N'trịnh hiếu', N'0328600889', N'Hieu123', N'player')
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
/****** Object:  Index [IX_Bookings_TimeSlotId]    Script Date: 3/17/2026 5:29:51 PM ******/
CREATE NONCLUSTERED INDEX [IX_Bookings_TimeSlotId] ON [dbo].[Bookings]
(
	[TimeSlotId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Bookings_UserId]    Script Date: 3/17/2026 5:29:51 PM ******/
CREATE NONCLUSTERED INDEX [IX_Bookings_UserId] ON [dbo].[Bookings]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Courts_OwnerId]    Script Date: 3/17/2026 5:29:51 PM ******/
CREATE NONCLUSTERED INDEX [IX_Courts_OwnerId] ON [dbo].[Courts]
(
	[OwnerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_SubCourts_CourtId]    Script Date: 3/17/2026 5:29:51 PM ******/
CREATE NONCLUSTERED INDEX [IX_SubCourts_CourtId] ON [dbo].[SubCourts]
(
	[CourtId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TimeSlots_SubCourtId]    Script Date: 3/17/2026 5:29:51 PM ******/
CREATE NONCLUSTERED INDEX [IX_TimeSlots_SubCourtId] ON [dbo].[TimeSlots]
(
	[SubCourtId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_Phone]    Script Date: 3/17/2026 5:29:51 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Phone] ON [dbo].[Users]
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Courts] ADD  DEFAULT ((0.0)) FOR [AfternoonPrice]
GO
ALTER TABLE [dbo].[Courts] ADD  DEFAULT ((0.0)) FOR [EveningPrice]
GO
ALTER TABLE [dbo].[Courts] ADD  DEFAULT ((0.0)) FOR [MorningPrice]
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD  CONSTRAINT [FK_Bookings_TimeSlots_TimeSlotId] FOREIGN KEY([TimeSlotId])
REFERENCES [dbo].[TimeSlots] ([Id])
GO
ALTER TABLE [dbo].[Bookings] CHECK CONSTRAINT [FK_Bookings_TimeSlots_TimeSlotId]
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD  CONSTRAINT [FK_Bookings_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Bookings] CHECK CONSTRAINT [FK_Bookings_Users_UserId]
GO
ALTER TABLE [dbo].[Courts]  WITH CHECK ADD  CONSTRAINT [FK_Courts_Users_OwnerId] FOREIGN KEY([OwnerId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Courts] CHECK CONSTRAINT [FK_Courts_Users_OwnerId]
GO
ALTER TABLE [dbo].[SubCourts]  WITH CHECK ADD  CONSTRAINT [FK_SubCourts_Courts_CourtId] FOREIGN KEY([CourtId])
REFERENCES [dbo].[Courts] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SubCourts] CHECK CONSTRAINT [FK_SubCourts_Courts_CourtId]
GO
ALTER TABLE [dbo].[TimeSlots]  WITH CHECK ADD  CONSTRAINT [FK_TimeSlots_SubCourts_SubCourtId] FOREIGN KEY([SubCourtId])
REFERENCES [dbo].[SubCourts] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TimeSlots] CHECK CONSTRAINT [FK_TimeSlots_SubCourts_SubCourtId]
GO
USE [master]
GO
ALTER DATABASE [BadmintonBooking] SET  READ_WRITE 
GO
