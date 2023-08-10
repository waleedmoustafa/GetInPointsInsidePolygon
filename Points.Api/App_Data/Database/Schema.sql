USE [master]
GO
/****** Object:  Database [DB_PointsDemo]    Script Date: 2023-08-10 8:25:25 AM ******/
CREATE DATABASE [DB_PointsDemo]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DB_PointsDemo', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DB_PointsDemo.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DB_PointsDemo_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DB_PointsDemo_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [DB_PointsDemo] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DB_PointsDemo].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DB_PointsDemo] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET ARITHABORT OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DB_PointsDemo] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DB_PointsDemo] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DB_PointsDemo] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DB_PointsDemo] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET RECOVERY FULL 
GO
ALTER DATABASE [DB_PointsDemo] SET  MULTI_USER 
GO
ALTER DATABASE [DB_PointsDemo] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DB_PointsDemo] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DB_PointsDemo] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DB_PointsDemo] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DB_PointsDemo] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DB_PointsDemo] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DB_PointsDemo', N'ON'
GO
ALTER DATABASE [DB_PointsDemo] SET QUERY_STORE = OFF
GO
USE [DB_PointsDemo]
GO
/****** Object:  UserDefinedTableType [dbo].[PolygonEdge]    Script Date: 2023-08-10 8:25:26 AM ******/
CREATE TYPE [dbo].[PolygonEdge] AS TABLE(
	[Lat] [decimal](18, 8) NOT NULL,
	[Long] [decimal](18, 8) NOT NULL,
	[EdgeOrder] [int] NOT NULL DEFAULT ((0))
)
GO
/****** Object:  UserDefinedFunction [dbo].[GetAreaOfTriangle]    Script Date: 2023-08-10 8:25:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  UserDefinedFunction [dbo].[F_FIND_SEARCH_LIMITS]    Script Date: 2023-08-09 2:23:07 PM ******/

CREATE FUNCTION [dbo].[GetAreaOfTriangle]
(
      @u decimal(18,8)
	, @a1 decimal(18,8)
	, @b1 decimal(18,8)
	, @b2 decimal(18,8)
)
RETURNS decimal(18,8)
AS
BEGIN

      Declare @area decimal(18,8)
	  SET @area = SQRT(@u*(@u - @a1)*(@u - @b1)*(@u - @b2))
	  RETURN	ISNULL(@area,0)

END


GO
/****** Object:  UserDefinedFunction [dbo].[GetEdgLength]    Script Date: 2023-08-10 8:25:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetEdgLength]
(
      @x1 decimal(18,8)
	, @y1 decimal(18,8)

    , @x2 decimal(18,8)
    , @y2 decimal(18,8)
)
RETURNS decimal(18,8)
AS
BEGIN

      Declare @length decimal(18,8)
	  SET @length = SQRT(POWER((@x1 - @x2),2) + POWER((@y1 - @y2),2))
	  RETURN	ISNULL(@length,0)

END


GO
/****** Object:  UserDefinedFunction [dbo].[IsPointInClockwiseTriangle]    Script Date: 2023-08-10 8:25:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsPointInClockwiseTriangle]
(
	 @Px decimal(18,8),
	 @Py decimal(18,8),

	 @Ax decimal(18,8),
	 @Ay decimal(18,8),

	 @Bx decimal(18,8),
	 @By decimal(18,8),

	 @Cx decimal(18,8),
	 @Cy decimal(18,8)
)
RETURNS bit
AS
BEGIN

      Declare @IsIn bit
	  DECLARE @s decimal(18,8);
	  DECLARE @t decimal(18,8);

	  SET @s = (@Ay * @Cx - @Ax * @Cy + (@Cy - @Ay) * @Px + (@Ax - @Cx) * @Py);
	  SET @t = (@Ax * @By - @Ay * @Bx + (@Ay - @By) * @Px + (@Bx - @Ax) * @Py);

	  IF (@s<= 0 OR @t <= 0)
	  BEGIN
         SET  @IsIn = 0;
		 Return @IsIn;
	  END

	  DECLARE @A decimal(18,8);
	  SET @A = (-@By * @Cx + @Ay * (-@Bx + @Cx) + @Ax * (@By - @Cy) + @Bx * @Cy);
	  SET @IsIn = CASE WHEN ((@s + @t) < @A) THEN 1
		               ELSE 0 END
	  RETURN @IsIn
END


GO
/****** Object:  UserDefinedFunction [dbo].[IsPointInPolygon]    Script Date: 2023-08-10 8:25:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[IsPointInPolygon]
(
	@Px decimal(18,8),
	@Py decimal(18,8),
	@PolygonEdges AS PolygonEdge READONLY
)
RETURNS bit
AS
BEGIN

	DECLARE @IsInside BIT;
	DECLARE @NumOfEdges INT;
	DECLARE @EdgeOrder INT;

	SELECT @NumOfEdges = COUNT(*) FROM @PolygonEdges
	DECLARE @Ax decimal(18,8);
	DECLARE  @Ay decimal(18,8);

	DECLARE @Bx decimal(18,8);
	DECLARE @By decimal(18,8);

	DECLARE @Cx decimal(18,8);
	DECLARE @Cy decimal(18,8);

	DECLARE @IsIn bit; SET @IsIn = 0;
	SELECT @Ax = Lat ,@Ay = Long FROM @PolygonEdges WHERE EdgeOrder = 1;
	
	DECLARE @Counter INT; SET @Counter = 2
	WHILE(@Counter < @NumOfEdges)
	BEGIN

		SELECT @Bx = Lat ,@By = Long FROM @PolygonEdges WHERE EdgeOrder = @Counter;
		SELECT @Cx = Lat ,@Cy = Long FROM @PolygonEdges WHERE EdgeOrder = @Counter+1;

	    SET @IsIn = dbo.IsPointInClockwiseTriangle (@Px ,@Py ,@Ax ,@Ay ,@Bx ,@By ,@Cx ,@Cy);
		IF(@IsIn = 1) 
		BEGIN
			BREAK;
		END
		SET @Counter  = @Counter  + 1
	END
	RETURN @IsIn;
END
GO
/****** Object:  Table [dbo].[Company]    Script Date: 2023-08-10 8:25:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[Lat] [decimal](18, 8) NULL,
	[Long] [decimal](18, 8) NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[SP_CheckPointIsInPolygon]    Script Date: 2023-08-10 8:25:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[SP_CheckPointIsInPolygon]
(
	@Px decimal(18,8),
	@Py decimal(18,8),
	@PolygonEdges AS PolygonEdge READONLY
)
AS
BEGIN

	DECLARE @IsInside BIT;
	DECLARE @NumOfEdges INT;
	DECLARE @EdgeOrder INT;

	SELECT @NumOfEdges = COUNT(*) FROM @PolygonEdges

	IF(@NumOfEdges < 3) 
	BEGIN
		SET @IsInside = 'false';
		PRINT ('Number of edges must exceed 3 edges');
		SELECT @NumOfEdges;
		RETURN 
	END

	DECLARE @Ax decimal(18,8);
	DECLARE  @Ay decimal(18,8);

	DECLARE @Bx decimal(18,8);
	DECLARE @By decimal(18,8);

	DECLARE @Cx decimal(18,8);
	DECLARE @Cy decimal(18,8);

	DECLARE @IsIn bit; SET @IsIn = 0;
	SELECT @Ax = Lat ,@Ay = Long FROM @PolygonEdges WHERE EdgeOrder = 1;
	
	DECLARE @Counter INT; SET @Counter = 2
	WHILE(@Counter < @NumOfEdges)
	BEGIN

		SELECT @Bx = Lat ,@By = Long FROM @PolygonEdges WHERE EdgeOrder = @Counter;
		SELECT @Cx = Lat ,@Cy = Long FROM @PolygonEdges WHERE EdgeOrder = @Counter+1;

	    SET @IsIn = dbo.IsPointInClockwiseTriangle (@Px ,@Py ,@Ax ,@Ay ,@Bx ,@By ,@Cx ,@Cy);
		IF(@IsIn = 1) 
		BEGIN
			 SELECT 'Is in triangle ' + CAST(@Counter-1 as nvarchar(20))
			BREAK;
		END
		SET @Counter  = @Counter  + 1
	END
	
	SELECT @IsIn AS 'IsIn'
	--SELECT * FROM @PolygonEdges
	--DELETE Top 1 @Ax = Lat ,@Ay = Long FROM @PolygonEdges ORDER BY EdgeOrder ASC;
	-- SELECT @NumOfEdges;

	--SET @IsInT1 = dbo.IsPointInClockwiseTriangle (@Px ,@Py ,@Ax ,@Ay ,@Bx ,@By ,@Cx ,@Cy);
	--SET @IsInT2 = dbo.IsPointInClockwiseTriangle (@Px ,@Py ,@Ax ,@Ay ,@Cx ,@Cy ,@Dx ,@Dy);
	--SELECT @IsInT1  'Is in triangel 1',  @IsInT2 'Is in triangel 2'

END
GO
/****** Object:  StoredProcedure [dbo].[SP_CompanyFactory]    Script Date: 2023-08-10 8:25:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[SP_CompanyFactory]
AS

BEGIN

SELECT * from Company
--Truncate table Company
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Ar Rahmaniyyah, Riyadh Saudi Arabia',24.711397 ,46.652770 );
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Al Raed, Riyadh 12352, Saudi Arabia',24.702000 ,46.645459 );
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Ali Bin Ali Industrial صناعية علي بن علي صناعية ام الحمام',24.7025209 ,46.6528011 );
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Delicious Manga لذه المنجو',24.7025209 ,46.6528011 );

INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Hayat Mall حياة مول',24.7318108 ,46.6395561 );
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Al Romansiah الرومانسية',24.7318108 ,46.6395561 );
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'stc store',24.7080335 ,46.674346 );
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'بنك باكستان الوطني',24.7081694 ,46.6729741 );
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Riyadh Front - Business Area',24.8386441 ,46.7217765 );


INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Place in',30.85623803549321 ,31.922008199264162 );
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Place in',30.856411688725142 ,31.923791989675532 );
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Place out',30.85370002645307 ,31.920296958727835 );
INSERT INTO [dbo].[Company] ([Name] ,[Lat] ,[Long]) VALUES (N'Place out',30.855321058436367 ,31.91816192037157);

--30.856364, 31.921374
--30.856964, 31.924243
--30.854501, 31.925190
--30.854194, 31.921245
--in  (30.85623803549321, 31.922008199264162)
--in  (30.856411688725142, 31.923791989675532)
--out (30.85370002645307, 31.920296958727835)
--out (30.855321058436367, 31.91816192037157

--[
--  {
--    "lat": 24.740618,
--    "long": 46.701150,
--    "orderId": 0
--  },
--    {
--    "lat": 24.713949,
--    "long": 46.625714,
--    "orderId": 0
--    },
--	    {
--    "lat": 24.711487,
--    "long": 46.738642,
--    "orderId": 0
--    },
--	    {
--    "lat": 24.653821,
--    "long": 46.620972,
--    "orderId": 0
--    },
--	{
--    "lat": 24.653821,
--    "long": 46.768455,
--    "orderId": 0
--    }
--]

     -- 24.713949, 46.625714
   -- 24.711487, 46.738642
   -- 24.653821, 46.620972
   -- 24.653821, 46.768455

   -- in 24.695072, 46.690987
   -- in 24.693431, 46.666143


   -- out  24.740618, 46.701150
   -- out  24.767897, 46.615551


END



GO
/****** Object:  StoredProcedure [dbo].[SP_GetPointsInPolygon]    Script Date: 2023-08-10 8:25:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[SP_GetPointsInPolygon]
(
	@PolygonEdges AS PolygonEdge READONLY
)
AS
BEGIN

	DECLARE	@Px decimal(18,8)
	DECLARE @Py decimal(18,8)

	DECLARE @C_Id INT
	DECLARE @C_Name nvarchar(200)

	DECLARE @IsInside BIT;
	DECLARE @NumOfEdges INT;
	DECLARE @EdgeOrder INT;


	SELECT @NumOfEdges = COUNT(*) FROM @PolygonEdges

	IF(@NumOfEdges < 3) 
	BEGIN
		SET @IsInside = 'false';
		PRINT ('Number of edges must exceed 3 edges');
		SELECT @NumOfEdges;
		RETURN 
	END

	DECLARE @Counter INT , @MaxId INT 
	SELECT @Counter = min(Id) , @MaxId = max(Id) FROM Company
	
	CREATE TABLE #InsideCompanies(Id INT, Name [nvarchar](200), Lat decimal(18,8), Long decimal(18,8))
	

	WHILE(@Counter IS NOT NULL AND @Counter <= @MaxId)
	BEGIN

		SELECT @C_Id= Id, @C_Name = Name, @Px = Lat ,@Py = Long  FROM Company WHERE Id = @Counter
		--SELECT dbo.IsPointInPolygon (@Px ,@Py ,@PolygonEdges)
		IF(dbo.IsPointInPolygon (@Px ,@Py ,@PolygonEdges) = 1)
		BEGIN
			INSERT into #InsideCompanies VALUES (@C_Id, @C_Name, @Px, @Py)
		END
		SET @Counter  = @Counter  + 1        
			
	END


	SELECT * FROM #InsideCompanies

	Drop Table #InsideCompanies
	

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Test_GetPointsInPolygon]    Script Date: 2023-08-10 8:25:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_Test_GetPointsInPolygon]

AS
BEGIN

DECLARE @Px decimal(18,8); 
DECLARE @Py decimal(18,8); 

DECLARE @PolygonEdges AS PolygonEdge;

-- Point
SET @Px = 24.755501
SET @Py = 46.668574

INSERT INTO @PolygonEdges (Lat, Long, EdgeOrder)
VALUES
 (24.863285, 46.593192, 1) -- Corner 1 24.863285, 46.593192 (l. 65)
,(24.846942, 46.850025, 2) -- Corner 2 24.846942, 46.850025 (l. 550)
,(24.753683, 46.820005, 3) -- Corner 3 24.753683, 46.820005 (l. 522)
,(24.701573, 46.625213, 4) -- Corner 4 24.701573, 46.625213 (l. 535)


--  EXECUTE  [dbo].[SP_CheckInOrOut_V2] @Px ,@Py ,@Ax ,@Ay ,@Bx ,@By ,@Cx ,@Cy,@Dx ,@Dy
--  EXECUTE SP_CheckInOrOut_V3 @Px ,@Py , @PolygonEdges = @PolygonEdges;
EXECUTE SP_GetPointsInPolygon @PolygonEdges = @PolygonEdges;

END
GO
USE [master]
GO
ALTER DATABASE [DB_PointsDemo] SET  READ_WRITE 
GO
