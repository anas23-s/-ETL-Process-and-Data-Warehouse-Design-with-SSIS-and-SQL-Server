USE [master]
GO
/****** Object:  Database [STG]    Script Date: 02/08/2024 08:01:49 ******/
CREATE DATABASE [STG]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'STG', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\STG.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'STG_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\STG_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [STG] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [STG].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [STG] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [STG] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [STG] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [STG] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [STG] SET ARITHABORT OFF 
GO
ALTER DATABASE [STG] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [STG] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [STG] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [STG] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [STG] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [STG] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [STG] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [STG] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [STG] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [STG] SET  DISABLE_BROKER 
GO
ALTER DATABASE [STG] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [STG] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [STG] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [STG] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [STG] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [STG] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [STG] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [STG] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [STG] SET  MULTI_USER 
GO
ALTER DATABASE [STG] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [STG] SET DB_CHAINING OFF 
GO
ALTER DATABASE [STG] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [STG] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [STG] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [STG] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [STG] SET QUERY_STORE = ON
GO
ALTER DATABASE [STG] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [STG]
GO
/****** Object:  Schema [COLLAB]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [COLLAB]
GO
/****** Object:  Schema [CSP]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [CSP]
GO
/****** Object:  Schema [DS]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [DS]
GO
/****** Object:  Schema [ERM]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [ERM]
GO
/****** Object:  Schema [HSE]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [HSE]
GO
/****** Object:  Schema [JPASS]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [JPASS]
GO
/****** Object:  Schema [LogBoomi]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [LogBoomi]
GO
/****** Object:  Schema [MASTER]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [MASTER]
GO
/****** Object:  Schema [P6]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [P6]
GO
/****** Object:  Schema [PARAM]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [PARAM]
GO
/****** Object:  Schema [PROCORE]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [PROCORE]
GO
/****** Object:  Schema [QA]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [QA]
GO
/****** Object:  Schema [SAP]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [SAP]
GO
/****** Object:  Schema [SPS]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [SPS]
GO
/****** Object:  Schema [VER]    Script Date: 02/08/2024 08:01:49 ******/
CREATE SCHEMA [VER]
GO
/****** Object:  UserDefinedFunction [dbo].[getFirstLastDayFiscalMonth]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[getFirstLastDayFiscalMonth](
    @DateValue_datetime DATETIME
)
RETURNS @T table(DateValue datetime,FirstDayOfTheMonth datetime,LastDayOfTheMonth datetime,YearPeriod int, MonthPeriod int)
AS
BEGIN
DECLARE @DateValue DATE = cast(@DateValue_datetime as date)
DECLARE @DateValueNext DATETIME= (SELECT DATEADD(mm, DATEDIFF(m,0,@DateValue)+1,0))
DECLARE @DateValueLast DATETIME= (SELECT DATEADD(mm, DATEDIFF(m,0,@DateValue)-1,0))

insert into @T
select @DateValue,x.FirstDayOfTheMonth,x.LastDayOfTheMonth,Year(x.LastDayOfTheMonth) YearPeriod,Month(x.LastDayOfTheMonth) MonthPeriod
from (
select case when datediff(month,dbo.[ufn_GetLastFridayV2](@DateValue) , @DateValue)=0 and dbo.[ufn_GetLastFridayV2](@DateValue) < @DateValue
then  dateadd(d,1,dbo.[ufn_GetLastFridayV2](@DateValue))
else dateadd(d,1,dbo.[ufn_GetLastFridayV2](@DateValueLast))
end FirstDayOfTheMonth,
 CASE WHEN 
dbo.[ufn_GetLastFridayV2](@DateValue) < @DateValue
then dbo.[ufn_GetLastFridayV2](@DateValueNext)
else dbo.[ufn_GetLastFridayV2](@DateValue) end AS LastDayOfTheMonth)x
RETURN
END


GO
/****** Object:  UserDefinedFunction [dbo].[getFiscalYear]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[getFiscalYear]
(   
    @Date datetime
)

RETURNS  int
AS
BEGIN
DECLARE @FiscalYear INT
SELECT @FiscalYear = (case when month(@Date)>6 then year(@Date)+1 else year(@Date) end)
RETURN @FiscalYear

END

GO
/****** Object:  UserDefinedFunction [dbo].[getMonthOfCutOff]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMonthOfCutOff]
(   
    @Date datetime
)

RETURNS  int
AS
BEGIN
DECLARE @CutOffMonth INT
SELECT @CutOffMonth = (case when day(@Date) between 1 and 20 then
	case when month(@Date) = 1 then 12 else month(@Date)-1 end
else month(@Date) end )
RETURN @CutOffMonth

END
GO
/****** Object:  UserDefinedFunction [dbo].[getYearOfCutOff]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getYearOfCutOff]
(   
    @Date datetime
)

RETURNS  int
AS
BEGIN
DECLARE @CutOffYear INT
SELECT @CutOffYear = (case when day(@Date) between 1 and 20 then
	case when month(@Date) = 1 then year(@Date)-1 else year(@Date) end
else year(@Date)
end)
RETURN @CutOffYear

END

GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetLastFriday]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Author:		Zouhair Ouichdani
-- Create date: 2022-12-15
-- Description:	This function calculate the date of the last Friday of a given date
-- ==========================================================================================
CREATE FUNCTION [dbo].[ufn_GetLastFriday]
(
	@DateValue as DATETIME
)
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	DECLARE @DateReturn DATE

	-- Add the T-SQL statements to compute the return value here
	SELECT  @DateReturn= case when @DateValue>LastWeekDay then LastWeekNextMonthDay else LastWeekDay end
	FROM (
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-1 AS LastWeekDay,DATEADD(mm,2,@DateValue - DAY(@DateValue)+1)-1 AS LastWeekNextMonthDay
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-2 AS LastWeekDay,DATEADD(mm,2,@DateValue - DAY(@DateValue)+1)-2
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-3 AS LastWeekDay,DATEADD(mm,2,@DateValue - DAY(@DateValue)+1)-3
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-4 AS LastWeekDay,DATEADD(mm,2,@DateValue - DAY(@DateValue)+1)-4 
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-5 AS LastWeekDay,DATEADD(mm,2,@DateValue - DAY(@DateValue)+1)-5
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-6 AS LastWeekDay,DATEADD(mm,2,@DateValue - DAY(@DateValue)+1)-6
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-7 AS LastWeekDay,DATEADD(mm,2,@DateValue - DAY(@DateValue)+1)-7
		) AS YourFridayTable
	WHERE DATENAME(WeekDay,LastWeekDay) = 'Friday'


	-- Return the result of the function
	RETURN @DateReturn

END

GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetLastFridayV2]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ==========================================================================================
-- Author:		Zouhair Ouichdani
-- Create date: 2022-12-15
-- Description:	This function calculate the date of the last Friday of a given date
-- ==========================================================================================
CREATE FUNCTION [dbo].[ufn_GetLastFridayV2]
(
	@DateValue as DATETIME
)
RETURNS DATETIME
AS
BEGIN
	-- Declare the return variable here
	DECLARE @DateReturn DATE

	-- Add the T-SQL statements to compute the return value here
	SELECT  @DateReturn= LastWeekDay
	FROM (
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-1 AS LastWeekDay
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-2 AS LastWeekDay
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-3 AS LastWeekDay
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-4 AS LastWeekDay
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-5 AS LastWeekDay
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-6 AS LastWeekDay
			UNION ALL
			SELECT DATEADD(mm,1,@DateValue - DAY(@DateValue)+1)-7 AS LastWeekDay
		) AS YourFridayTable
	WHERE DATENAME(WeekDay,LastWeekDay) = 'Friday'


	-- Return the result of the function
	RETURN @DateReturn

END



GO
/****** Object:  Table [LogBoomi].[hse2_hse_top_three]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[hse2_hse_top_three](
	[id] [int] NOT NULL,
	[rank] [int] NULL,
	[category] [int] NOT NULL,
	[value] [numeric](12, 2) NULL,
	[comment] [nvarchar](max) NULL,
	[id_hse] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vHSE2Collab1]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vHSE2Collab1](
	[YearValue] [int] NULL,
	[MonthValue] [int] NULL,
	[JPassProjectID] [int] NULL,
	[ProjectNumber] [nvarchar](250) NULL,
	[WorkingHours] [int] NULL,
	[trirRecordableCases] [int] NULL,
	[lostTimeIncidentRecordableCases] [int] NULL,
	[recordableIncidenteRecordableCases] [int] NULL,
	[firstAidCaseRecordableCases] [int] NULL,
	[nearMissRecordableCases] [int] NULL,
	[trirPtd] [int] NULL,
	[trirYtd] [int] NULL,
	[lostTimeIncidentPtd] [int] NULL,
	[lostTimeIncidentYtd] [int] NULL,
	[recordableIncidentPtd] [int] NULL,
	[recordableIncidentYtd] [int] NULL,
	[firstAidCasePtd] [int] NULL,
	[firstAidCaseYtd] [int] NULL,
	[nearMissPtd] [int] NULL,
	[nearMissYtd] [int] NULL,
	[comment] [int] NULL,
	[creationDate] [int] NULL,
	[updateDate] [int] NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vHSE2Collab2]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vHSE2Collab2](
	[YearValue] [int] NULL,
	[MonthValue] [int] NULL,
	[JPassProjectID] [int] NULL,
	[ProjectNumber] [nvarchar](250) NULL,
	[TotalSor] [int] NULL,
	[ClosedSor] [int] NULL,
	[OpenSor] [int] NULL,
	[rankNum] [bigint] NULL,
	[CategoryID] [nvarchar](250) NULL,
	[CategoryLabel] [nvarchar](200) NULL,
	[CategoryCode] [nvarchar](250) NULL,
	[CategoryType] [nvarchar](250) NULL,
	[SOR] [int] NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[hse2_hse]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[hse2_hse](
	[id] [int] NOT NULL,
	[top_three_sor] [nvarchar](max) NULL,
	[id_project] [int] NULL,
	[month_period] [int] NOT NULL,
	[year] [int] NOT NULL,
	[total_sor] [numeric](12, 2) NOT NULL,
	[closed_sor] [numeric](12, 2) NOT NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[hse2_hse_kpi]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[hse2_hse_kpi](
	[id] [int] NOT NULL,
	[period_month] [int] NOT NULL,
	[working_hours] [numeric](10, 2) NOT NULL,
	[trir_recordable_cases] [numeric](15, 2) NOT NULL,
	[lost_time_incident_recordable_cases] [int] NOT NULL,
	[recordable_incidente_recordable_cases] [int] NOT NULL,
	[first_aid_case_recordable_cases] [int] NOT NULL,
	[near_miss_recordable_cases] [int] NOT NULL,
	[comment] [nvarchar](max) NULL,
	[id_project] [int] NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[year] [int] NOT NULL,
	[training_hours] [numeric](18, 0) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [LogBoomi].[v_HSE_Monitoring]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- LogBoomi.v_HSE_Monitoring source

CREATE VIEW [LogBoomi].[v_HSE_Monitoring] AS


select CAST([DWH_Table] AS NVARCHAR(50)) + '||' +
        CAST([month] AS NVARCHAR(50)) + '||' +
        CAST([year] AS NVARCHAR(50)) + '||' +
        CAST([ProjectID] AS NVARCHAR(50)) + '||' +
        CAST([rankNum] AS NVARCHAR(50)) + '||' ID,*
from (

--hse_kpi
SELECT 
    N'hse_kpi' AS Collab_Table,
    N'vHSE2Collab1' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    N'-' as rankNum,
    N'-' as value_DWH,
    N'-' as value_Collab,
    N'Insert' IntegrationType,
    N'No-KPI' AS KPI,
    N'Insert: hse_kpi in DWH but not in Collab' reason
FROM 
	STG.LogBoomi.vHSE2Collab1 DWH 
left join 
	stg.LogBoomi.hse2_hse_kpi C
on 
	DWH.JPassProjectID = C.id_project and DWH.MonthValue = C.period_month and DWH.YearValue = C.year 
where
	C.id_project is Null
	
UNION

SELECT 
    N'hse_kpi' AS Collab_Table,
    N'vHSE2Collab1' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    N'-' as rankNum,
    cast(dwh.WorkingHours as nvarchar(max)) as value_DWH,
    cast(C.working_hours  as nvarchar(max)) as value_Collab,
    N'Update' IntegrationType,
    N'workinghours' AS KPI,
    N'Update: workinghours in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vHSE2Collab1 DWH 
inner join 
	stg.LogBoomi.hse2_hse_kpi C
on 
	DWH.JPassProjectID = C.id_project and DWH.MonthValue = C.period_month and DWH.YearValue = C.[year] 
where
	dwh.WorkingHours != C.working_hours 
	
Union

SELECT 
    N'hse_kpi' AS Collab_Table,
    N'vHSE2Collab1' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    N'-' as rankNum,
    cast(dwh.lostTimeIncidentRecordableCases as nvarchar(max)) as value_DWH,
    cast(C.lost_time_incident_recordable_cases as nvarchar(max)) as value_Collab,
    N'Update' IntegrationType,
    N'lostTimeIncidentRecordableCases' AS KPI,
    N'Update: lostTimeIncidentRecordableCases in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vHSE2Collab1 DWH 
inner join 
	stg.LogBoomi.hse2_hse_kpi C
on 
	DWH.JPassProjectID = C.id_project and DWH.MonthValue = C.period_month and DWH.YearValue = C.[year] 
where
	dwh.lostTimeIncidentRecordableCases  != C.lost_time_incident_recordable_cases  
	
UNION

SELECT 
    N'hse_kpi' AS Collab_Table,
    N'vHSE2Collab1' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    N'-' as rankNum,
    cast(dwh.recordableIncidenteRecordableCases as nvarchar(max)) as value_DWH,
    cast(C.recordable_incidente_recordable_cases as nvarchar(max)) as value_Collab,
    N'Update' IntegrationType,
    N'recordableIncidenteRecordableCases' AS KPI,
    N'Update: recordableIncidenteRecordableCases in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vHSE2Collab1 DWH 
inner join 
	stg.LogBoomi.hse2_hse_kpi C
on 
	DWH.JPassProjectID = C.id_project and DWH.MonthValue = C.period_month and DWH.YearValue = C.[year] 
where
	dwh.recordableIncidenteRecordableCases  != C.recordable_incidente_recordable_cases  
	
UNION

SELECT 
    N'hse_kpi' AS Collab_Table,
    N'vHSE2Collab1' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    N'-' as rankNum,
    cast(dwh.firstAidCaseRecordableCases as nvarchar(max)) as value_DWH,
    cast(C.first_aid_case_recordable_cases as nvarchar(max)) as value_Collab,
    N'Update' IntegrationType,
    N'firstAidCaseRecordableCases' AS KPI,
    N'Update: firstAidCaseRecordableCases in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vHSE2Collab1 DWH 
inner join 
	stg.LogBoomi.hse2_hse_kpi C
on 
	DWH.JPassProjectID = C.id_project and DWH.MonthValue = C.period_month and DWH.YearValue = C.[year] 
where
	dwh.firstAidCaseRecordableCases  != C.first_aid_case_recordable_cases  
	
UNION

SELECT 
    N'hse_kpi' AS Collab_Table,
    N'vHSE2Collab1' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    N'-' as rankNum,
    cast(dwh.nearMissRecordableCases as nvarchar(max)) as value_DWH,
    cast(C.near_miss_recordable_cases as nvarchar(max)) as value_Collab,
    N'Update' IntegrationType,
    N'nearMissRecordableCases' AS KPI,
    N'Update: nearMissRecordableCases in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vHSE2Collab1 DWH 
inner join 
	stg.LogBoomi.hse2_hse_kpi C
on 
	DWH.JPassProjectID = C.id_project and DWH.MonthValue = C.period_month and DWH.YearValue = C.[year] 
where
	dwh.nearMissRecordableCases  != C.near_miss_recordable_cases
	

--- hse / hse top 3
	
	
	
UNION	
SELECT 
    N'hse/top3' AS Collab_Table,
    N'vHSE2Collab2' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    cast(dwh.rankNum as nvarchar(max)) as rankNum,
    N'-' as value_DWH,
    N'-' as value_Collab,
    N'Insert' as IntegrationType,
    N'No-KPI' AS KPI,
    N'Insert: hse_kpi in DWH but not in Collab' reason
FROM 
	stg.LogBoomi.vHSE2Collab2 DWH
left join 
	stg.LogBoomi.hse2_hse h left join stg.LogBoomi.hse2_hse_top_three ht3 on h.id = ht3.id_hse
on 
	DWH.JPassProjectID = h.id_project and DWH.MonthValue = h.month_period  and DWH.YearValue  = h.year and DWH.rankNum = ht3.rank 
where
	h.id_project is Null

UNION

SELECT
    N'hse/top3' AS Collab_Table,
    N'vHSE2Collab2' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    cast(dwh.rankNum as nvarchar(max)) as rankNum,
    cast(dwh.TotalSor as nvarchar(max)) as value_DWH,
	cast(h.total_sor as nvarchar(max)) as value_Collab,
    N'Update' as IntegrationType,
    N'TotalSor' AS KPI,
    N'Update: TotalSor in DWH different than Collab' reason
FROM 
	stg.LogBoomi.vHSE2Collab2 DWH
inner join 
	(stg.LogBoomi.hse2_hse h left join stg.LogBoomi.hse2_hse_top_three ht3 on h.id = ht3.id_hse)
on 
	DWH.JPassProjectID = h.id_project and DWH.MonthValue = h.month_period  and DWH.YearValue  = h.year and DWH.rankNum = ht3.rank  
where
	dwh.TotalSor != h.total_sor

UNION

SELECT
    N'hse/top3' AS Collab_Table,
    N'vHSE2Collab2' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    cast(dwh.rankNum as nvarchar(max)) as rankNum,
    cast(dwh.ClosedSor  as nvarchar(max)) as value_DWH,
	cast(h.closed_sor  as nvarchar(max)) as value_Collab,
    N'Update' as IntegrationType,
    N'ClosedSor' AS KPI,
    N'Update: ClosedSor in DWH different than Collab' reason
FROM 
	stg.LogBoomi.vHSE2Collab2 DWH 
inner join 
	(stg.LogBoomi.hse2_hse h left join stg.LogBoomi.hse2_hse_top_three ht3 on h.id = ht3.id_hse)
on 
	DWH.JPassProjectID = h.id_project and DWH.MonthValue = h.month_period  and DWH.YearValue = h.year and DWH.rankNum = ht3.rank  
where
	dwh.ClosedSor != h.closed_sor
	
	
UNION

SELECT
    N'hse/top3' AS Collab_Table,
    N'vHSE2Collab2' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    cast(dwh.rankNum as nvarchar(max)) as rankNum,
    cast(dwh.SOR as nvarchar(max)) as value_DWH,
	cast(ht3.value as nvarchar(max)) as value_Collab,
    N'Update' as IntegrationType,
    N'SOR' AS KPI,
    N'Update: SOR in DWH different than Collab' reason
FROM 
	stg.LogBoomi.vHSE2Collab2 DWH 
inner join 
	(stg.LogBoomi.hse2_hse h left join stg.LogBoomi.hse2_hse_top_three ht3 on h.id = ht3.id_hse)
on 
	DWH.JPassProjectID = h.id_project and DWH.MonthValue = h.month_period  and DWH.YearValue  = h.year and DWH.rankNum = ht3.rank  
where
	dwh.SOR != ht3.value
	
UNION
	
SELECT 
    N'-' AS Collab_Table,
    N'vHSE2Collab1' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    N'-' as rankNum,
    CAST(NULL as nvarchar(max)) as value_DWH,
    CAST(NULL as nvarchar(max)) as value_Collab,
    N'Original Data' IntegrationType,
    N'HSE-KPI' AS KPI,
    N'Sent Document' reason
FROM 
	STG.LogBoomi.vHSE2Collab1 DWH 
	
UNION ALL

SELECT 
    N'-' AS Collab_Table,
    N'vHSE2Collab2' AS DWH_Table,
    DWH.MonthValue as [month],
    DWH.YearValue as [year],
    DWH.JPassProjectID AS ProjectID,
    cast(dwh.rankNum as nvarchar(max)) as rankNum,
    CAST(NULL as nvarchar(max)) as value_DWH,
    CAST(NULL as nvarchar(max)) as value_Collab,
    N'Original Data' IntegrationType,
    N'HSE-SOR' AS KPI,
    N'Sent Document' reason
FROM 
	STG.LogBoomi.vHSE2Collab2 DWH )x
	
	

;

;

GO
/****** Object:  Table [DS].[jpass_construction_equipment_certificate]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_construction_equipment_certificate](
	[id] [nvarchar](2000) NULL,
	[certificate_date] [nvarchar](2000) NULL,
	[certificate_expiring_date] [nvarchar](2000) NULL,
	[accredited_organization] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[certificate_id] [nvarchar](2000) NULL,
	[construction_equipment_id] [nvarchar](2000) NULL,
	[validation_comment] [nvarchar](2000) NULL,
	[validation_status_id] [nvarchar](2000) NULL,
	[file] [nvarchar](2000) NULL,
	[mobile_id] [nvarchar](2000) NULL,
	[upload_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_equipment_certificate]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [DS].[v_jpass_equipment_certificate] as 
SELECT cast(id as int) id
      ,cast([certificate_date] as datetime) [certificate_date]
      ,cast([certificate_expiring_date] as datetime) [certificate_expiring_date]
      ,[accredited_organization]
      ,cast(left([creation_date],23) as datetime) [creation_date]
      ,cast(left([update_date],23)  as datetime) [update_date]
      ,[certificate_id]
      ,[construction_equipment_id]
      ,[validation_comment]
      ,[validation_status_id]
      ,[file]
      ,[mobile_id]
      ,[upload_id]
  FROM ds.JPASS_construction_equipment_certificate

GO
/****** Object:  Table [DS].[jpass_construction_equipment_employee]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_construction_equipment_employee](
	[id] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[construction_equipment_id] [nvarchar](2000) NULL,
	[employee_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_equipment_employee]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [DS].[v_jpass_equipment_employee] as 
SELECT  cast([id] as int) id
      ,cast(left([creation_date],23) as datetime) [creation_date]
      ,[construction_equipment_id]
      ,[employee_id]
  FROM [STG].ds.[jpass_construction_equipment_employee]

GO
/****** Object:  Table [SAP].[PRHI]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PRHI](
	[MANDT] [nvarchar](3) NULL,
	[POSNR] [nvarchar](8) NULL,
	[PSPHI] [nvarchar](8) NULL,
	[UP] [nvarchar](8) NULL,
	[DOWN] [nvarchar](8) NULL,
	[LEFT] [nvarchar](8) NULL,
	[RIGHT] [nvarchar](8) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PROJ]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PROJ](
	[MANDT] [nvarchar](3) NULL,
	[PSPNR] [nvarchar](8) NULL,
	[PSPID] [nvarchar](24) NULL,
	[POST1] [nvarchar](40) NULL,
	[OBJNR] [nvarchar](22) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[ERDAT] [nvarchar](8) NULL,
	[AENAM] [nvarchar](12) NULL,
	[AEDAT] [nvarchar](8) NULL,
	[KIMSK] [nvarchar](24) NULL,
	[AUTOD] [nvarchar](1) NULL,
	[STSPD] [nvarchar](8) NULL,
	[STSPR] [nvarchar](8) NULL,
	[VERNR] [nvarchar](8) NULL,
	[VERNA] [nvarchar](25) NULL,
	[ASTNR] [nvarchar](8) NULL,
	[ASTNA] [nvarchar](25) NULL,
	[VBUKR] [nvarchar](4) NULL,
	[VGSBR] [nvarchar](4) NULL,
	[VKOKR] [nvarchar](4) NULL,
	[PRCTR] [nvarchar](10) NULL,
	[PWHIE] [nvarchar](5) NULL,
	[ZUORD] [nvarchar](1) NULL,
	[TRMEQ] [nvarchar](1) NULL,
	[PLFAZ] [nvarchar](8) NULL,
	[PLSEZ] [nvarchar](8) NULL,
	[WERKS] [nvarchar](4) NULL,
	[KALID] [nvarchar](2) NULL,
	[VGPLF] [nvarchar](1) NULL,
	[EWPLF] [nvarchar](1) NULL,
	[ZTEHT] [nvarchar](3) NULL,
	[NZANZ] [nvarchar](1) NULL,
	[PLNAW] [nvarchar](1) NULL,
	[VPROF] [nvarchar](7) NULL,
	[PROFL] [nvarchar](7) NULL,
	[BPROF] [nvarchar](6) NULL,
	[TXTSP] [nvarchar](1) NULL,
	[KOSTL] [nvarchar](10) NULL,
	[KTRG] [nvarchar](12) NULL,
	[AEDTE] [nvarchar](8) NULL,
	[AEDTP] [nvarchar](8) NULL,
	[BERST] [nvarchar](16) NULL,
	[BERTR] [nvarchar](16) NULL,
	[BERKO] [nvarchar](16) NULL,
	[BERBU] [nvarchar](16) NULL,
	[SPSNR] [nvarchar](8) NULL,
	[BESTA] [nvarchar](1) NULL,
	[SCOPE] [nvarchar](2) NULL,
	[XSTAT] [nvarchar](1) NULL,
	[TXJCD] [nvarchar](15) NULL,
	[ZSCHM] [nvarchar](7) NULL,
	[SCPRF] [nvarchar](12) NULL,
	[IMPRF] [nvarchar](6) NULL,
	[FMPRF] [nvarchar](6) NULL,
	[ABGSL] [nvarchar](6) NULL,
	[POSTU] [nvarchar](40) NULL,
	[PPROF] [nvarchar](6) NULL,
	[PLINT] [nvarchar](1) NULL,
	[LOEVM] [nvarchar](1) NULL,
	[INACT] [nvarchar](1) NULL,
	[KZBWS] [nvarchar](1) NULL,
	[SMPRF] [nvarchar](7) NULL,
	[FLGVRG] [nvarchar](1) NULL,
	[GRTOP] [nvarchar](1) NULL,
	[PGPRF] [nvarchar](6) NULL,
	[STORT] [nvarchar](10) NULL,
	[LOGSYSTEM] [nvarchar](10) NULL,
	[KZERB] [nvarchar](1) NULL,
	[PARGR] [nvarchar](4) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[VKORG] [nvarchar](4) NULL,
	[VTWEG] [nvarchar](2) NULL,
	[SPART] [nvarchar](2) NULL,
	[DPPPROF] [nvarchar](8) NULL,
	[VPKSTU] [nvarchar](2) NULL,
	[PSPID_EDIT] [nvarchar](24) NULL,
	[VNAME] [nvarchar](6) NULL,
	[RECID] [nvarchar](2) NULL,
	[ETYPE] [nvarchar](3) NULL,
	[OTYPE] [nvarchar](4) NULL,
	[JIBCL] [nvarchar](3) NULL,
	[JIBSA] [nvarchar](5) NULL,
	[EEW_PROJ_PS_DUMMY] [nvarchar](1) NULL,
	[SCHTYP] [nvarchar](1) NULL,
	[SPROG] [nvarchar](8) NULL,
	[EPROG] [nvarchar](8) NULL,
	[SLWID] [nvarchar](7) NULL,
	[USR00] [nvarchar](20) NULL,
	[USR01] [nvarchar](20) NULL,
	[USR02] [nvarchar](10) NULL,
	[USR03] [nvarchar](10) NULL,
	[USR04] [numeric](13, 3) NULL,
	[USE04] [nvarchar](3) NULL,
	[USR05] [numeric](13, 3) NULL,
	[USE05] [nvarchar](3) NULL,
	[USR06] [numeric](13, 3) NULL,
	[USE06] [nvarchar](5) NULL,
	[USR07] [numeric](13, 3) NULL,
	[USE07] [nvarchar](5) NULL,
	[USR08] [nvarchar](8) NULL,
	[USR09] [nvarchar](8) NULL,
	[USR10] [nvarchar](1) NULL,
	[USR11] [nvarchar](1) NULL,
	[CPD_UPDAT] [numeric](15, 0) NULL,
	[FERC_IND] [nvarchar](4) NULL,
	[AVC_PROFILE] [nvarchar](6) NULL,
	[AVC_ACTIVE] [nvarchar](1) NULL,
	[CPCURR] [nvarchar](5) NULL,
	[ZZCLIENT_CURR] [nvarchar](5) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PRPS]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PRPS](
	[MANDT] [nvarchar](3) NULL,
	[PSPNR] [nvarchar](8) NULL,
	[POST1] [nvarchar](40) NULL,
	[OBJNR] [nvarchar](22) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[ERDAT] [nvarchar](8) NULL,
	[AENAM] [nvarchar](12) NULL,
	[AEDAT] [nvarchar](8) NULL,
	[VERNR] [nvarchar](8) NULL,
	[VERNA] [nvarchar](25) NULL,
	[ASTNR] [nvarchar](8) NULL,
	[ASTNA] [nvarchar](25) NULL,
	[PRCTR] [nvarchar](10) NULL,
	[ZUORD] [nvarchar](1) NULL,
	[TRMEQ] [nvarchar](1) NULL,
	[WERKS] [nvarchar](4) NULL,
	[TXTSP] [nvarchar](1) NULL,
	[KOSTL] [nvarchar](10) NULL,
	[KTRG] [nvarchar](12) NULL,
	[BERST] [nvarchar](16) NULL,
	[BERTR] [nvarchar](16) NULL,
	[BERKO] [nvarchar](16) NULL,
	[BERBU] [nvarchar](16) NULL,
	[SPSNR] [nvarchar](8) NULL,
	[SCOPE] [nvarchar](2) NULL,
	[XSTAT] [nvarchar](1) NULL,
	[TXJCD] [nvarchar](15) NULL,
	[ZSCHM] [nvarchar](7) NULL,
	[IMPRF] [nvarchar](6) NULL,
	[ABGSL] [nvarchar](6) NULL,
	[POSTU] [nvarchar](40) NULL,
	[PLINT] [nvarchar](1) NULL,
	[LOEVM] [nvarchar](1) NULL,
	[KZBWS] [nvarchar](1) NULL,
	[PGPRF] [nvarchar](6) NULL,
	[STORT] [nvarchar](10) NULL,
	[LOGSYSTEM] [nvarchar](10) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[VNAME] [nvarchar](6) NULL,
	[RECID] [nvarchar](2) NULL,
	[ETYPE] [nvarchar](3) NULL,
	[OTYPE] [nvarchar](4) NULL,
	[JIBCL] [nvarchar](3) NULL,
	[JIBSA] [nvarchar](5) NULL,
	[SLWID] [nvarchar](7) NULL,
	[USR00] [nvarchar](20) NULL,
	[USR01] [nvarchar](20) NULL,
	[USR02] [nvarchar](10) NULL,
	[USR03] [nvarchar](10) NULL,
	[USR04] [numeric](13, 3) NULL,
	[USE04] [nvarchar](3) NULL,
	[USR05] [numeric](13, 3) NULL,
	[USE05] [nvarchar](3) NULL,
	[USR06] [numeric](13, 3) NULL,
	[USE06] [nvarchar](5) NULL,
	[USR07] [numeric](13, 3) NULL,
	[USE07] [nvarchar](5) NULL,
	[USR08] [nvarchar](8) NULL,
	[USR09] [nvarchar](8) NULL,
	[USR10] [nvarchar](1) NULL,
	[USR11] [nvarchar](1) NULL,
	[CPD_UPDAT] [numeric](15, 0) NULL,
	[FERC_IND] [nvarchar](4) NULL,
	[ZZCLIENT_CURR] [nvarchar](5) NULL,
	[POSID] [nvarchar](24) NULL,
	[PSPHI] [nvarchar](8) NULL,
	[POSKI] [nvarchar](16) NULL,
	[PBUKR] [nvarchar](4) NULL,
	[PGSBR] [nvarchar](4) NULL,
	[PKOKR] [nvarchar](4) NULL,
	[PRART] [nvarchar](2) NULL,
	[STUFE] [smallint] NULL,
	[PLAKZ] [nvarchar](1) NULL,
	[BELKZ] [nvarchar](1) NULL,
	[FAKKZ] [nvarchar](1) NULL,
	[NPFAZ] [nvarchar](1) NULL,
	[KVEWE] [nvarchar](1) NULL,
	[KAPPL] [nvarchar](2) NULL,
	[KALSM] [nvarchar](6) NULL,
	[ZSCHL] [nvarchar](6) NULL,
	[AKOKR] [nvarchar](4) NULL,
	[AKSTL] [nvarchar](10) NULL,
	[FKOKR] [nvarchar](4) NULL,
	[FKSTL] [nvarchar](10) NULL,
	[FABKL] [nvarchar](2) NULL,
	[PSPRI] [nvarchar](1) NULL,
	[EQUNR] [nvarchar](18) NULL,
	[TPLNR] [nvarchar](30) NULL,
	[PWPOS] [nvarchar](5) NULL,
	[CLASF] [nvarchar](1) NULL,
	[EVGEW] [numeric](8, 0) NULL,
	[AENNR] [nvarchar](12) NULL,
	[SUBPR] [nvarchar](12) NULL,
	[FPLNR] [nvarchar](10) NULL,
	[TADAT] [nvarchar](8) NULL,
	[IZWEK] [nvarchar](2) NULL,
	[ISIZE] [nvarchar](2) NULL,
	[IUMKZ] [nvarchar](5) NULL,
	[ABUKR] [nvarchar](4) NULL,
	[GRPKZ] [nvarchar](1) NULL,
	[PSPNR_LOGS] [nvarchar](8) NULL,
	[KLVAR] [nvarchar](4) NULL,
	[KALNR] [nvarchar](12) NULL,
	[POSID_EDIT] [nvarchar](24) NULL,
	[PSPKZ] [nvarchar](1) NULL,
	[MATNR] [nvarchar](40) NULL,
	[VLPSP] [nvarchar](8) NULL,
	[VLPKZ] [nvarchar](1) NULL,
	[SORT1] [nvarchar](10) NULL,
	[SORT2] [nvarchar](10) NULL,
	[SORT3] [nvarchar](10) NULL,
	[CGPL_GUID16] [binary](16) NULL,
	[CGPL_LOGSYS] [nvarchar](10) NULL,
	[CGPL_OBJTYPE] [nvarchar](3) NULL,
	[ADPSP] [nvarchar](40) NULL,
	[RFIPPNT] [nvarchar](20) NULL,
	[EEW_PRPS_PS_DUMMY] [nvarchar](1) NULL,
	[ZAD_REG] [nvarchar](2) NULL,
	[ZAD_SECLOB] [nvarchar](4) NULL,
	[ZAD_LAND] [nvarchar](3) NULL,
	[ZAD_BUSARE] [nvarchar](3) NULL,
	[ZAD_GEO] [nvarchar](3) NULL,
	[ZAD_PRLO] [nvarchar](3) NULL,
	[ZAD_SERTYP] [nvarchar](4) NULL,
	[ZPROJECT_CTRL] [nvarchar](8) NULL,
	[ZPROJECT_DIRECTOR] [nvarchar](8) NULL,
	[ZPROJECT_ACC] [nvarchar](8) NULL,
	[ZAD_CT] [nvarchar](2) NULL,
	[ZZKUNNR] [nvarchar](10) NULL,
	[ZZCT_VAL] [nvarchar](20) NULL,
	[ZZBU_LEAD] [nvarchar](20) NULL,
	[ZZOCP_PROJ] [nvarchar](1) NULL,
	[ZZCLNT_PROJMGR] [nvarchar](20) NULL,
	[ZZCLNT_FMRMGR] [nvarchar](20) NULL,
	[ZZCLNT_PROJDIR] [nvarchar](20) NULL,
	[ZZCOST_CTRL] [nvarchar](8) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_ProjHierarchy]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[v_ProjHierarchy] as 
WITH ProjHierarchy as (
select distinct PSPHI ParentProject,POSNR ChildProject,1 isParent
from [STG].[SAP].[PRHI] 
where up='00000000'
union 
select distinct POSNR,DOWN,0
from [STG].[SAP].[PRHI]
where POSNR<>'00000000' and DOWN<>'00000000'
union 
select distinct UP,POSNR ,0
from [STG].[SAP].[PRHI]
where POSNR<>'00000000' and UP<>'00000000'
),proj as (
SELECT
  Lvl1.ParentProject   AS lvl1,
  Lvl2.ChildProject   AS lvl2,
  Lvl3.ChildProject   AS lvl3,
   Lvl4.ChildProject   AS lvl4,
    Lvl5.ChildProject   AS lvl5
FROM
  ProjHierarchy   AS Lvl1
  CROSS APPLY
(
   SELECT ChildProject FROM ProjHierarchy p WHERE p.isParent=1 and p.ParentProject=Lvl1.ParentProject and p.ChildProject=lvl1.ChildProject
   UNION ALL
   SELECT NULL AS ID
)AS Lvl2
CROSS APPLY
(
   SELECT ChildProject FROM ProjHierarchy p WHERE ParentProject = Lvl2.ChildProject and ChildProject <>'00000000'
   and ChildProject <> Lvl2.ChildProject and p.isParent=0
   UNION ALL
   SELECT NULL AS ID
)
  AS Lvl3
  CROSS APPLY
(
   SELECT ChildProject FROM ProjHierarchy p WHERE ParentProject = Lvl3.ChildProject and ChildProject <>'00000000'
   and ChildProject <> Lvl3.ChildProject and p.isParent=0
   UNION ALL
   SELECT NULL AS ID
)
  AS Lvl4
CROSS APPLY
(
   SELECT ChildProject FROM ProjHierarchy p WHERE ParentProject = Lvl4.ChildProject and ChildProject <>'00000000'
   and ChildProject <> Lvl4.ChildProject and p.isParent=0
   UNION ALL
   SELECT NULL AS ID
)
  AS Lvl5
WHERE
  Lvl1.isParent=1)
  select pr.PSPID ProjDef,pr.POSTU ProjDefName,case when pr.PRCTR in ('JESE','JEST','JEUS','INST','JETM','JESA','JEIN','JEWA') then pr.PRCTR
  else left(pr.PRCTR,3) end BU
,isnull(ps2.POSID,'') WBSElement1,ps2.POSTU WBSElementName1
,isnull(ps3.POSID,'') WBSElement2,ps3.POSTU WBSElementName2
,isnull(ps4.POSID,'') WBSElement3,ps4.POSTU WBSElementName3
,isnull(ps5.POSID,'') WBSElement4,ps5.POSTU WBSElementName4

from proj t
left outer join stg.sap.PROJ pr on pr.PSPNR = t.lvl1
left outer join stg.sap.PRPS ps2 on ps2.PSPNR=t.lvl2  
left outer join stg.sap.PRPS ps3 on ps3.PSPNR=t.lvl3  
left outer join stg.sap.PRPS ps4 on ps4.PSPNR=t.lvl4  
left outer join stg.sap.PRPS ps5 on ps5.PSPNR=t.lvl5



GO
/****** Object:  Table [DS].[jpass_construction_equipment_inspection]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_construction_equipment_inspection](
	[id] [nvarchar](2000) NULL,
	[inspection_date] [nvarchar](2000) NULL,
	[expiring_date] [nvarchar](2000) NULL,
	[required_action] [nvarchar](2000) NULL,
	[description] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[construction_equipment_id] [nvarchar](2000) NULL,
	[inspection] [nvarchar](2000) NULL,
	[validation_comment] [nvarchar](2000) NULL,
	[validation_status_id] [nvarchar](2000) NULL,
	[file] [nvarchar](2000) NULL,
	[mobile_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_equipment_inspection]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [DS].[v_jpass_equipment_inspection] as 
SELECT CAST([id] as int) id
      ,cast([inspection_date] as datetime) [inspection_date]
      ,cast([expiring_date]  as datetime) [expiring_date]
      ,[required_action]
      ,[description]
      ,cast(left([creation_date],23) as datetime) creation_date
      ,cast(left([update_date],23) as datetime) update_date
      ,[construction_equipment_id]
      ,[inspection]
      ,[validation_comment]
      ,[validation_status_id]
      ,[file]
      ,[mobile_id]
  FROM [STG].ds.[jpass_construction_equipment_inspection]


GO
/****** Object:  Table [DS].[jpass_construction_equipment_project]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_construction_equipment_project](
	[id] [nvarchar](2000) NULL,
	[construction_equipment_id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[start_date] [nvarchar](2000) NULL,
	[end_date] [nvarchar](2000) NULL,
	[status] [nvarchar](2000) NULL,
	[assignment_rate] [nvarchar](2000) NULL,
	[is_deleted] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_equipment_project]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [DS].[v_jpass_equipment_project] as 
SELECT cast([id] as int) id
      ,[construction_equipment_id]
      ,[project_id]
      ,cast(left([start_date],23) as datetime) [start_date]
      ,cast(left([end_date],23) as datetime) [end_date]
      ,[status]
      ,[assignment_rate]
      ,[is_deleted]
  FROM [STG].ds.[jpass_construction_equipment_project]

GO
/****** Object:  Table [DS].[jpass_construction_equipment_warning]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_construction_equipment_warning](
	[id] [nvarchar](2000) NULL,
	[warning_date] [nvarchar](2000) NULL,
	[required_action] [nvarchar](2000) NULL,
	[description] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[construction_equipment_id] [nvarchar](2000) NULL,
	[warning] [nvarchar](2000) NULL,
	[validation_comment] [nvarchar](2000) NULL,
	[validation_status_id] [nvarchar](2000) NULL,
	[file] [nvarchar](2000) NULL,
	[mobile_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_equipment_warning]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [DS].[v_jpass_equipment_warning] as 
SELECT  cast([id] as int) id
      ,cast(left([warning_date],23) as datetime) [warning_date]
      ,[required_action]
      ,[description]
      ,cast(left([creation_date],23) as datetime) [creation_date]
      ,[construction_equipment_id]
      ,[warning]
      ,[validation_comment]
      ,[validation_status_id]
      ,[file]
      ,[mobile_id]
  FROM [STG].ds.[jpass_construction_equipment_warning]

GO
/****** Object:  Table [DS].[jpass_inspections]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_inspections](
	[id] [nvarchar](250) NULL,
	[name] [nvarchar](250) NULL,
	[type] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_enumeration]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_enumeration](
	[id] [nvarchar](2000) NULL,
	[type] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[label] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_inspection]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [DS].[v_jpass_inspection] as 
SELECT i.[id] inspections_id
      ,i.[name]
      ,e.label
	  ,e.type
      ,i.[creation_date]
      ,i.[update_date]
  FROM [STG].ds.[jpass_inspections] i
  left outer join ds.jpass_enumeration e on e.id = i.type

GO
/****** Object:  Table [LogBoomi].[v_HR_TIMESHEET]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[v_HR_TIMESHEET](
	[firstdaymonth] [date] NULL,
	[lastdaymonth] [date] NULL,
	[projectid] [int] NULL,
	[mailcacheaduser] [nvarchar](2000) NULL,
	[firstdayweek] [date] NULL,
	[lastdayweek] [date] NULL,
	[activitydate] [date] NULL,
	[taskname] [nvarchar](100) NULL,
	[Duration] [numeric](38, 2) NULL,
	[isbillable] [varchar](5) NULL,
	[user_deleted] [nvarchar](2000) NULL,
	[azure_directory_id] [nvarchar](2000) NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[timesheet2_activity]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[timesheet2_activity](
	[id] [int] NOT NULL,
	[id_task] [int] NULL,
	[id_timesheet] [int] NULL,
	[activity_date] [date] NOT NULL,
	[duration] [numeric](5, 2) NOT NULL,
	[is_billable] [nvarchar](max) NULL,
	[is_labour_corrected] [nvarchar](max) NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[timesheet2_timesheet]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[timesheet2_timesheet](
	[id] [int] NOT NULL,
	[id_user] [nvarchar](max) NULL,
	[id_project] [int] NULL,
	[first_day_week] [date] NOT NULL,
	[last_day_week] [date] NOT NULL,
	[latest_update] [date] NOT NULL,
	[is_labour_correction_needed] [nvarchar](max) NULL,
	[labour_correction_comment] [nvarchar](max) NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[timesheet2_task]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[timesheet2_task](
	[id] [int] NOT NULL,
	[name] [nvarchar](max) NOT NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[collab_user_cache]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[collab_user_cache](
	[user_mgt_id] [nvarchar](500) NULL,
	[azure_directory_id] [nvarchar](500) NULL,
	[first_name] [nvarchar](500) NULL,
	[last_name] [nvarchar](500) NULL,
	[display_name] [nvarchar](500) NULL,
	[mail] [nvarchar](500) NULL,
	[mobile_phone] [nvarchar](500) NULL,
	[job_title] [nvarchar](500) NULL,
	[deleted] [nvarchar](500) NULL,
	[admin] [nvarchar](500) NULL,
	[external] [nvarchar](500) NULL,
	[creation_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[frozen] [nvarchar](500) NULL,
	[dpe] [nvarchar](500) NULL,
	[external_role] [nvarchar](500) NULL,
	[specific_role] [nvarchar](500) NULL,
	[bu] [nvarchar](500) NULL,
	[program] [nvarchar](500) NULL,
	[sector] [nvarchar](500) NULL,
	[discipline] [nvarchar](500) NULL,
	[linked_to_all_companies] [nvarchar](500) NULL,
	[contractors] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[collab_app_user]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[collab_app_user](
	[id] [varchar](50) NULL,
	[azure_directory_id] [varchar](50) NULL,
	[deleted] [varchar](50) NULL,
	[deleted_platform] [varchar](50) NULL,
	[firebase_token] [varchar](50) NULL,
	[old_cache_ad_user_id] [varchar](50) NULL,
	[user_id] [varchar](50) NULL,
	[creation_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [LogBoomi].[v_Timesheet_Monitoring]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- LogBoomi.v_Timesheet_Monitoring source

-- LogBoomi.v_Timesheet_Monitoring source

-- LogBoomi.v_Timesheet_Monitoring source


CREATE view [LogBoomi].[v_Timesheet_Monitoring] as 

SELECT 
	CAST([DWH_Table] AS NVARCHAR(MAX))+'||'+
	CAST([ProjectID] AS NVARCHAR(MAX))+'||'+
	CAST([MailCacheAdUser] AS NVARCHAR(MAX))+'||'+
	CAST([TaskName] AS NVARCHAR(MAX))+'||'+
	CAST([ActivityDate] AS NVARCHAR(MAX))+'||'+
	CAST([isbillable] AS NVARCHAR(MAX))+'||'+
	CAST([Duration] AS NVARCHAR(MAX))+'||'
	ID, *

FROM (
SELECT 
    N'activity/task/timesheet' AS Collab_Table,
    N'v_HR_TIMESHEET' AS DWH_Table,
	DWH.projectid AS ProjectID,
    DWH.mailcacheaduser as MailCacheAdUser,
    DWH.taskname as TaskName,
    DWH.activitydate as ActivityDate,
    DWH.isbillable as isbillable,
    DWH.Duration as Duration,
    N'-' as value_DWH,
    N'-' as value_Collab,
    N'Insert' IntegrationType,
    N'No-KPI' AS KPI,
    N'Insert: HR_TIMESHEET in DWH but not in Collab' reason
FROM 
	STG.LogBoomi.v_HR_TIMESHEET DWH 
left join
	(STG.LogBoomi.timesheet2_activity a
	left join STG.LogBoomi.timesheet2_task t2 on a.id_task = t2.id
	left join STG.LogBoomi.timesheet2_timesheet t on a.id_timesheet = t.id
	left join stg.logboomi.collab_app_user u on u.id=t.id_user
	left join stg.logboomi.collab_user_cache uc ON uc.user_mgt_id = u.user_id) on
	DWH.projectid = t.id_project and DWH.mailcacheaduser = uc.mail and DWH.taskname =t2.name and DWH.activitydate = a.activity_date
	and SUBSTRING(DWH.isbillable , 1, 1) = a.is_billable and DWH.Duration = a.duration 
where
	t.id_project is NULL 

UNION

SELECT 
    N'activity/task/timesheet' AS Collab_Table,
    N'v_HR_TIMESHEET' AS DWH_Table,
	DWH.projectid AS ProjectID,
    DWH.mailcacheaduser as MailCacheAdUser,
    DWH.taskname as TaskName,
    DWH.activitydate as ActivityDate,
    DWH.isbillable as isbillable,
    DWH.Duration as Duration,
    cast(DWH.Duration as nvarchar(max)) as value_DWH,
    cast(a.duration as nvarchar(max)) as value_Collab,
    N'Update' IntegrationType,
    N'duration' AS KPI,
    N'Update: Duration in DWH different than Collab' reason
FROM 
	STG.LogBoomi.v_HR_TIMESHEET DWH 
inner join
	(STG.LogBoomi.timesheet2_activity a
	left join STG.LogBoomi.timesheet2_task t2 on a.id_task = t2.id
	left join STG.LogBoomi.timesheet2_timesheet t on a.id_timesheet = t.id
	left join stg.logboomi.collab_app_user u on u.id=t.id_user
	left join stg.logboomi.collab_user_cache uc ON uc.user_mgt_id = u.user_id) on
	DWH.projectid = t.id_project and DWH.mailcacheaduser = uc.mail and DWH.taskname =t2.name and DWH.activitydate = a.activity_date
	and SUBSTRING(DWH.isbillable , 1, 1) = a.is_billable and DWH.Duration = a.duration 
where
	DWH.Duration != a.duration

UNION

SELECT
    N'-' AS Collab_Table,
    N'v_HR_TIMESHEET' AS DWH_Table,
	DWH.projectid  AS ProjectID,
    DWH.mailcacheaduser as MailCacheAdUser,
    DWH.taskname as TaskName,
    DWH.activitydate as ActivityDate,
    DWH.isbillable as isbillable,
    DWH.Duration as Duration,
    CAST(NULL AS NVARCHAR(MAX)) as value_DWH,
    CAST(NULL AS NVARCHAR(MAX)) as value_Collab,
    N'Original Data' IntegrationType,
    N'Timesheet' AS KPI,
    N'Sent Document' reason
FROM 
	STG.LogBoomi.v_HR_TIMESHEET DWH )x 


;
GO
/****** Object:  Table [DS].[jpass_employee_project]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_employee_project](
	[id] [nvarchar](2000) NULL,
	[employee_id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[date] [nvarchar](2000) NULL,
	[end_date] [nvarchar](2000) NULL,
	[attendance_rate] [nvarchar](2000) NULL,
	[job] [nvarchar](2000) NULL,
	[company_id] [nvarchar](2000) NULL,
	[status] [nvarchar](2000) NULL,
	[is_deleted] [nvarchar](2000) NULL,
	[unlimited_access] [nvarchar](2000) NULL,
	[access] [nvarchar](2000) NULL,
	[access_frequency] [nvarchar](2000) NULL,
	[access_start_date] [nvarchar](2000) NULL,
	[access_end_date] [nvarchar](2000) NULL,
	[jpass_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_scan_history]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_scan_history](
	[id] [nvarchar](2000) NULL,
	[scanned_employee] [nvarchar](2000) NULL,
	[scanned_by_id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[operation_type] [nvarchar](2000) NULL,
	[date] [nvarchar](2000) NULL,
	[employee_external_id] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_employee]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_employee](
	[id] [nvarchar](2000) NULL,
	[first_name] [nvarchar](2000) NULL,
	[last_name] [nvarchar](2000) NULL,
	[phone] [nvarchar](2000) NULL,
	[email] [nvarchar](2000) NULL,
	[client_badge_id] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[nationality] [nvarchar](2000) NULL,
	[avatar] [nvarchar](2000) NULL,
	[qr_code] [nvarchar](2000) NULL,
	[unique_reference] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[job] [nvarchar](2000) NULL,
	[company] [nvarchar](2000) NULL,
	[subcontractor] [nvarchar](2000) NULL,
	[department] [nvarchar](2000) NULL,
	[address] [nvarchar](2000) NULL,
	[city] [nvarchar](2000) NULL,
	[employe_type] [nvarchar](2000) NULL,
	[all_project_areas] [nvarchar](2000) NULL,
	[areas] [nvarchar](2000) NULL,
	[linked_to_all_validated_contracts] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL,
	[business_line] [nvarchar](2000) NULL,
	[corporate] [nvarchar](2000) NULL,
	[discipline] [nvarchar](2000) NULL,
	[sub_discipline] [nvarchar](2000) NULL,
	[employee_number] [nvarchar](2000) NULL,
	[supervisor_user] [nvarchar](2000) NULL,
	[cats_app_user] [nvarchar](2000) NULL,
	[gender] [nvarchar](2000) NULL,
	[contract_type] [nvarchar](2000) NULL,
	[country_origin] [nvarchar](2000) NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_scan_history]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [DS].[v_jpass_scan_history]
AS SELECT DISTINCT e.id AS employee_id,
    e.unique_reference AS employee_unique_reference,
    ep.project_id,
    ep.status AS employee_project_status,
    left(ep.date,23) AS employee_project_start_date,
    left(ep.end_date,23) AS employee_project_end_date,
    ep.is_deleted AS employee_is_deleted,
    opt.code AS scanned_operation_type_code,
    opt.label AS scanned_operation_type,
    sh.date AS scanned_date
   FROM ds.jpass_employee_project ep
     LEFT JOIN ds.jpass_employee e ON ep.employee_id = e.id
     LEFT JOIN ds.jpass_scan_history sh ON sh.scanned_employee = e.id AND sh.project_id = ep.project_id
     LEFT JOIN ds.jpass_enumeration opt ON opt.id = sh.operation_type


GO
/****** Object:  Table [PROCORE].[correspondance]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[correspondance](
	[id_project] [varchar](250) NULL,
	[id] [varchar](250) NULL,
	[closed_at] [varchar](250) NULL,
	[cost_code] [varchar](250) NULL,
	[cost_impact] [varchar](250) NULL,
	[status_cost] [varchar](250) NULL,
	[value_cost] [varchar](250) NULL,
	[created_at] [varchar](250) NULL,
	[id_creator] [varchar](250) NULL,
	[company_creator] [varchar](250) NULL,
	[locale_creator] [varchar](250) NULL,
	[login_creator] [varchar](250) NULL,
	[name_creator] [varchar](250) NULL,
	[description] [varchar](max) NULL,
	[due_date] [varchar](250) NULL,
	[generic_tool] [varchar](250) NULL,
	[id_generic_tool] [varchar](250) NULL,
	[abbreviation_generic_tool] [varchar](250) NULL,
	[domain_id_generic_tool] [varchar](250) NULL,
	[title_generic_tool] [varchar](250) NULL,
	[issued_at] [varchar](250) NULL,
	[location] [varchar](250) NULL,
	[position_correspondance] [varchar](250) NULL,
	[private] [varchar](250) NULL,
	[quantity] [varchar](250) NULL,
	[id_received_from] [varchar](250) NULL,
	[id_company] [varchar](250) NULL,
	[name_company] [varchar](250) NULL,
	[locale_receiver] [varchar](250) NULL,
	[login_receiver] [varchar](250) NULL,
	[name_receiver] [varchar](250) NULL,
	[status_schedule_impact] [varchar](250) NULL,
	[value_schedule_impact] [varchar](250) NULL,
	[specification_section] [varchar](250) NULL,
	[status] [varchar](250) NULL,
	[status_type] [varchar](250) NULL,
	[sub_job] [varchar](250) NULL,
	[title] [varchar](250) NULL,
	[trade] [varchar](250) NULL,
	[unformatted_position] [varchar](250) NULL,
	[uom] [varchar](250) NULL,
	[updated_at] [varchar](250) NULL,
	[task] [varchar](250) NULL,
	[custom_field_68369] [nvarchar](max) NULL,
	[custom_field_78100] [nvarchar](500) NULL,
	[custom_field_82018] [nvarchar](500) NULL,
	[custom_field_82019] [nvarchar](500) NULL,
	[custom_field_101242] [nvarchar](max) NULL,
	[custom_field_101243] [nvarchar](500) NULL,
	[custom_field_101244] [nvarchar](500) NULL,
	[custom_field_101250] [nvarchar](max) NULL,
	[custom_field_101251] [nvarchar](500) NULL,
	[custom_field_101252] [nvarchar](500) NULL,
	[custom_field_102557] [nvarchar](max) NULL,
	[custom_field_119143] [nvarchar](500) NULL,
	[custom_field_101238] [nvarchar](500) NULL,
	[custom_field_101239] [nvarchar](500) NULL,
	[custom_field_136073] [nvarchar](max) NULL,
	[custom_field_136075] [nvarchar](max) NULL,
	[custom_field_136076] [nvarchar](500) NULL,
	[custom_field_136077] [nvarchar](500) NULL,
	[custom_field_136078] [nvarchar](500) NULL,
	[custom_field_136079] [nvarchar](500) NULL,
	[custom_field_562949953933688] [nvarchar](max) NULL,
	[custom_field_101235] [nvarchar](500) NULL,
	[custom_field_101237] [nvarchar](500) NULL,
	[custom_field_134716] [nvarchar](max) NULL,
	[custom_field_134717] [nvarchar](max) NULL,
	[custom_field_134718] [nvarchar](500) NULL,
	[custom_field_562949953931063] [nvarchar](max) NULL,
	[custom_field_78686] [nvarchar](500) NULL,
	[custom_field_121043] [nvarchar](500) NULL,
	[custom_field_121044] [nvarchar](max) NULL,
	[name_assignees] [nvarchar](500) NULL,
	[login_assignees] [nvarchar](500) NULL,
	[company_name_assignees] [nvarchar](500) NULL,
	[active_trades] [nvarchar](500) NULL,
	[name_trades] [nvarchar](500) NULL,
	[login_distribution] [nvarchar](500) NULL,
	[name_distribution] [nvarchar](500) NULL,
	[company_name_distribution] [nvarchar](500) NULL,
	[id_assignee] [nvarchar](500) NULL,
	[id_distribution] [nvarchar](500) NULL,
	[id_custom_field_82018] [nvarchar](250) NULL,
	[custom_field_562949953937218] [nvarchar](500) NULL,
	[custom_field_562949953937219] [nvarchar](500) NULL,
	[custom_field_562949953937220] [nvarchar](500) NULL,
	[custom_field_562949953937222] [nvarchar](500) NULL,
	[custom_field_562949953937223] [nvarchar](500) NULL,
	[custom_field_562949953937224] [nvarchar](500) NULL,
	[custom_field_562949953937225] [nvarchar](500) NULL,
	[custom_field_562949953937226] [nvarchar](500) NULL,
	[custom_field_562949953937227] [nvarchar](500) NULL,
	[custom_field_562949953937232] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [PROCORE].[v_correspondance]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [PROCORE].[v_correspondance] as
SELECT  [id_project]
      ,[id]
      ,[closed_at]
      ,[cost_code]
      ,[cost_impact]
      ,[status_cost]
      ,[value_cost]
      ,[created_at]
      ,[id_creator]
      ,[company_creator]
      ,[locale_creator]
      ,[login_creator]
      ,[name_creator]
      ,[description]
      ,[due_date]
      ,[generic_tool]
      ,[id_generic_tool]
      ,[abbreviation_generic_tool]
      ,[domain_id_generic_tool]
      ,[title_generic_tool]
      ,[issued_at]
      ,[location]
      ,[position_correspondance]
      ,[private]
      ,[quantity]
      ,[id_received_from]
      ,[id_company]
      ,[name_company]
      ,[locale_receiver]
      ,[login_receiver]
      ,[name_receiver]
      ,[status_schedule_impact]
      ,[value_schedule_impact]
      ,[specification_section]
      ,[status]
      ,[status_type]
      ,[sub_job]
      ,[title]
      ,[trade]
      ,[unformatted_position]
      ,[uom]
      ,[updated_at]
      ,[task]
      , custom_field_68369 as question_box
	, custom_field_78100 as area
	, custom_field_82018 as [contractor]
	, id_custom_field_82018 as [contractor_id]
	, custom_field_82019 as [discipline]
	, custom_field_101242 as [answer]
	, custom_field_101243 as [issue_Date]
	, custom_field_101244 as [target_date]
	, custom_field_101250 as [comment]
	, custom_field_101251 as [closure_date]
	, custom_field_101252 as [replier_name]
	, custom_field_102557 as [importance]
	, custom_field_119143 as [commitment_number]
	, custom_field_101238 as [effective_date]
	, custom_field_101239 as [expiration_Date]
	, custom_field_136073 as [currency]
	, custom_field_136075 as [bank_guarantee_type]
	, custom_field_136076 as [reference]
	, custom_field_136077 as [bank_guarantee_amount]
	, custom_field_136078 as [milestone]
	, custom_field_136079 as [bank_guarantee_provider]
	, custom_field_562949953933688 as [nb_1]
	, custom_field_101235 as [policy_number]
	, custom_field_101237 as [limit_amount]
	, custom_field_134716 as [company_project_insurance]
	, custom_field_134717 as [insurance_type]
	, custom_field_134718 as [insurance_provider]
	, custom_field_562949953931063 as payment_receipt
	, [custom_field_121043] as hse_impact
    ,[custom_field_121044] as change_justification
    ,[name_assignees]
    ,[login_assignees]
    ,[company_name_assignees]
    ,[active_trades]
    ,[name_trades]
    ,[login_distribution]
    ,[name_distribution]
    ,[company_name_distribution]
	,id_assignee
	,id_distribution
,custom_field_562949953937218	subcontractor_name
,custom_field_562949953937219	subcontractor_address
,custom_field_562949953937220	subcontractor_email_address
,custom_field_562949953937222	subcontractor_city
,custom_field_562949953937223	subcontractor_country
,custom_field_562949953937224	subcontractor_phone_number
,custom_field_562949953937225	subcontractor_contact_name
,custom_field_562949953937226	subcontractor_job_title
,custom_field_562949953937227	subcontractor_scope_of_work
,custom_field_562949953937232	subcontractor_nb
  FROM [STG].[PROCORE].[correspondance]



GO
/****** Object:  Table [DS].[jpass_contractor_sub_contractor]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_contractor_sub_contractor](
	[id] [nvarchar](2000) NULL,
	[name_sub] [nvarchar](2000) NULL,
	[type_sub] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[management_notification_address] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_sub_contractor]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [DS].[v_jpass_sub_contractor]
AS SELECT csc.id AS company_id,
    csc.name_sub AS company_name,
    csc.type_sub  AS company_type,
    csc.creation_date AS company_creation_date
   FROM ds.jpass_contractor_sub_contractor csc

GO
/****** Object:  Table [DS].[jpass_employee_training]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_employee_training](
	[id] [nvarchar](2000) NULL,
	[training_id] [nvarchar](2000) NULL,
	[employee_id] [nvarchar](2000) NULL,
	[training_expiring_date] [nvarchar](2000) NULL,
	[start_date] [nvarchar](2000) NULL,
	[trainer] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[file] [nvarchar](2000) NULL,
	[validation_comment] [nvarchar](2000) NULL,
	[validation_status_id] [nvarchar](2000) NULL,
	[duration] [nvarchar](2000) NULL,
	[is_present] [nvarchar](2000) NULL,
	[final_score] [nvarchar](2000) NULL,
	[passe_gate] [nvarchar](2000) NULL,
	[is_linked_to_all_areas] [nvarchar](2000) NULL,
	[is_passed] [nvarchar](2000) NULL,
	[category] [nvarchar](2000) NULL,
	[upload_id] [nvarchar](2000) NULL,
	[comment] [nvarchar](2000) NULL,
	[initial_score] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_training]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_training](
	[id] [nvarchar](2000) NULL,
	[title] [nvarchar](2000) NULL,
	[description] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_association_validation_status]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_association_validation_status](
	[id] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[label_validation] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_training]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [DS].[v_jpass_training]
AS SELECT DISTINCT et.id AS emp_training_id,
    t.id AS training_id,
    t.title AS training_title,
    et.employee_id,
    e.unique_reference AS employee_unique_reference,
    cat.code AS employee_category_id,
    cat.label AS employee_category,
    avs.code AS training_validation_status_code,
    avs.label_validation  AS training_validation_status,
    et.start_date AS training_start_date,
    et.trainer AS training_trainer,
    et.training_expiring_date,
    et.duration AS training_duration,
    et.is_present AS employee_is_present,
    et.initial_score AS employee_initial_score,
    et.final_score AS employee_final_score,
    et.passe_gate AS employee_passe_gate,
    et.is_passed AS employee_is_passed,
    et.validation_comment AS training_validation_comment,
    et.comment AS training_comment
   FROM ds.jpass_employee_training et
     LEFT JOIN ds.jpass_training t ON et.training_id = t.id
     LEFT JOIN ds.jpass_employee e ON e.id = et.employee_id
     LEFT JOIN ds.jpass_enumeration cat ON cat.id = et.category
     LEFT JOIN ds.jpass_association_validation_status avs ON avs.id = et.validation_status_id

GO
/****** Object:  View [DS].[v_jpass_training_title]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [DS].[v_jpass_training_title]
AS SELECT t.id AS training_id,
    t.title AS training_title,
    t.description AS training_description
   FROM ds.jpass_training t

GO
/****** Object:  Table [DS].[jpass_warning]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_warning](
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[type] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_warning_type]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_warning_type](
	[id] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[label_war] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_warning]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [DS].[v_jpass_warning] as 
SELECT  w.[id] warning_id
      ,[name] warning_name
      ,wt.label_war warning_type
  FROM ds.jpass_warning w
  left outer join ds.jpass_warning_type wt on wt.id = w.type



GO
/****** Object:  Table [DS].[qa_activity_finding_report]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_activity_finding_report](
	[id] [nvarchar](2000) NULL,
	[very_high] [nvarchar](2000) NULL,
	[high] [nvarchar](2000) NULL,
	[medium] [nvarchar](2000) NULL,
	[low] [nvarchar](2000) NULL,
	[opportunity] [nvarchar](2000) NULL,
	[report_status] [nvarchar](2000) NULL,
	[report] [nvarchar](2000) NULL,
	[report_id] [nvarchar](2000) NULL,
	[terms_of_reference] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[ordinal_number] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_activity_result]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_activity_result](
	[id] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[label] [nvarchar](2000) NULL,
	[description] [nvarchar](2000) NULL,
	[activity_type_id] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_activity_type]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_activity_type](
	[id] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[label] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_app_user]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_app_user](
	[id] [nvarchar](2000) NULL,
	[user_mg_id] [nvarchar](2000) NULL,
	[user_type] [nvarchar](2000) NULL,
	[status] [nvarchar](2000) NULL,
	[is_admin] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[is_visible] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_css_info]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_css_info](
	[id] [nvarchar](2000) NULL,
	[safety] [nvarchar](2000) NULL,
	[scope] [nvarchar](2000) NULL,
	[communication] [nvarchar](2000) NULL,
	[tech_services] [nvarchar](2000) NULL,
	[staffing] [nvarchar](2000) NULL,
	[schedule] [nvarchar](2000) NULL,
	[cost_estimate] [nvarchar](2000) NULL,
	[field_services] [nvarchar](2000) NULL,
	[supply_mgmt] [nvarchar](2000) NULL,
	[mgmt_support] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_activity]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_activity](
	[id] [nvarchar](2000) NULL,
	[status] [nvarchar](2000) NULL,
	[month] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[comment] [nvarchar](2000) NULL,
	[planned_date] [nvarchar](2000) NULL,
	[category] [nvarchar](2000) NULL,
	[sub_category] [nvarchar](2000) NULL,
	[pre_draft] [nvarchar](2000) NULL,
	[to_delete] [nvarchar](2000) NULL,
	[progress] [nvarchar](2000) NULL,
	[discipline] [nvarchar](2000) NULL,
	[conducted_date] [nvarchar](2000) NULL,
	[completed_date] [nvarchar](2000) NULL,
	[score] [nvarchar](2000) NULL,
	[responsible] [nvarchar](2000) NULL,
	[extra_source] [nvarchar](2000) NULL,
	[css_info] [nvarchar](2000) NULL,
	[activity_finding_report] [nvarchar](2000) NULL,
	[result] [nvarchar](2000) NULL,
	[creator] [nvarchar](2000) NULL,
	[any_raised_capa] [nvarchar](2000) NULL,
	[raised_capa_number] [nvarchar](2000) NULL,
	[canceled_date] [nvarchar](2000) NULL,
	[rescheduled_date] [nvarchar](2000) NULL,
	[changes_number] [nvarchar](2000) NULL,
	[source_id] [nvarchar](20) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_activity_planning]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_activity_planning](
	[id] [nvarchar](2000) NULL,
	[activity_id] [nvarchar](2000) NULL,
	[planning_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_enumeration]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_enumeration](
	[id] [nvarchar](2000) NULL,
	[type] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[label] [nvarchar](2000) NULL,
	[parent_enum_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_planning]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_planning](
	[id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[activity_type_id] [nvarchar](2000) NULL,
	[status] [nvarchar](2000) NULL,
	[fiscal_year] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[to_delete] [nvarchar](2000) NULL,
	[created_by] [nvarchar](2000) NULL,
	[updated_by] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_qa_activity]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  VIEW [DS].[v_qa_activity]
AS SELECT [activity_id]
      ,[activity_creation_date]
      ,[activity_update_date]
      ,[activity_planned_date]
      ,[activity_conducted_date]
      ,[activity_completed_date]
      ,[activity_rescheduled_date]
      ,[activity_canceled_date]
      ,[activity_comment]
      ,[activity_result]
      ,[activity_result_code]
      ,[activity_result_desc]
      ,[activity_status]
      ,[activity_status_code]
      ,[activity_type]
      ,[activity_type_code]
      ,[activity_category]
      ,[activity_category_code]
      ,[activity_category_type]
      ,[activity_subcategory]
      ,[activity_subcategory_code]
      ,[activity_subcategory_type]
      ,[activity_discipline]
      ,[activity_discipline_code]
      ,[activity_progress]
      ,[activity_progress_code]
      ,[report_finding_status]
      ,[report_finding_code]
      ,[activity_month]
      ,[activity_score]
      ,[activity_pre_draft]
      ,[activity_to_delete]
      ,[finding_very_high]
      ,[finding_high]
      ,[finding_medium]
      ,[finding_low]
      ,[finding_opportunity]
      ,[css_infos_id]
      ,[css_safety]
      ,[css_scope]
      ,[css_communication]
      ,[css_tech_services]
      ,[css_staffing]
      ,[css_schedule]
      ,[css_cost_estimate]
      ,[css_field_services]
      ,[css_supply_mgmt]
      ,[css_mgmt_support]
      ,[activity_creator_id]
      ,[activity_responsible_id]
      ,[activity_extra_source_id]
      ,[activity_any_raised_capa]
      ,[activity_raised_capa_number]
      ,[activity_source_id]
FROM (
SELECT a.id AS activity_id,
    a.creation_date AS activity_creation_date,
    a.update_date AS activity_update_date,
	a.planned_date  AS activity_planned_date,
    a.conducted_date AS activity_conducted_date,
    a.completed_date AS activity_completed_date,
    a.rescheduled_date AS activity_rescheduled_date,
    a.canceled_date AS activity_canceled_date,
	a.comment as activity_comment,
    ar.label AS activity_result,
    ar.code AS activity_result_code,
    ar.description AS activity_result_desc,
    s.label AS activity_status,
    s.code AS activity_status_code,
    at2.label AS activity_type,
    at2.code AS activity_type_code,
    cat.label AS activity_category,
    cat.code AS activity_category_code,
    cat.type AS activity_category_type,
	case when scat.label is null and cat.label in ('Start-up','Close-out') then cat.label 
	else scat.label end AS activity_subcategory,
    --scat.label AS activity_subcategory,
    scat.code AS activity_subcategory_code,
    scat.type AS activity_subcategory_type,
    dp.label AS activity_discipline,
    dp.code AS activity_discipline_code,
    pg.label AS activity_progress,
    pg.code AS activity_progress_code,
    afrs.label AS report_finding_status,
    afrs.code AS report_finding_code,
    a.month AS activity_month,
    a.score AS activity_score,
    a.pre_draft AS activity_pre_draft,
    a.to_delete AS activity_to_delete,
    afr.very_high AS finding_very_high,
    afr.high AS finding_high,
    afr.medium AS finding_medium,
    afr.low AS finding_low,
    afr.opportunity AS finding_opportunity,
    ci.id AS css_infos_id,
    ci.safety AS css_safety,
    ci.scope AS css_scope,
    ci.communication AS css_communication,
    ci.tech_services AS css_tech_services,
    ci.staffing AS css_staffing,
    ci.schedule AS css_schedule,
    ci.cost_estimate AS css_cost_estimate,
    ci.field_services AS css_field_services,
    ci.supply_mgmt AS css_supply_mgmt,
    ci.mgmt_support AS css_mgmt_support,
    au.user_mg_id AS activity_creator_id,
    aur.user_mg_id AS activity_responsible_id,
    aue.user_mg_id AS activity_extra_source_id,
	a.any_raised_capa activity_any_raised_capa,
	a.raised_capa_number activity_raised_capa_number,
	a.source_id activity_source_id,
	row_number() over(partition by a.source_id order by cast(a.id as int) desc ) ord
   FROM stg.ds.qa_activity a
   cross apply (select  distinct act.id, act.source_id,actPlanning.planning_id actplid,act.creation_date acreation,act.update_date cupdate,planning.activity_type_id,planning.fiscal_year,planning.update_date,planning.creation_date 
   from ds.qa_activity act 
inner join ds.qa_activity_planning actPlanning on actPlanning.activity_id = act.id
inner join ds.qa_planning planning on planning.id = actPlanning.planning_id
and coalesce(planning.update_date, planning.creation_date) = 
(select MAX(coalesce(pl2.update_date, pl2.creation_date)) from ds.qa_planning pl2
inner join ds.qa_enumeration plStatus on plStatus.id = pl2.status
where pl2.project_id = planning.project_id and pl2.activity_type_id = planning.activity_type_id
and plStatus.code = 'REVIEWED' and pl2.fiscal_year = planning.fiscal_year)
where act.id=a.id
) v
     LEFT JOIN ds.qa_activity_result ar ON ar.id = a.result
     LEFT JOIN ds.qa_activity_type at2 ON at2.id = ar.activity_type_id
     LEFT JOIN ds.qa_activity_finding_report afr ON afr.id = a.activity_finding_report
     LEFT JOIN ds.qa_enumeration s ON a.status = s.id
     LEFT JOIN ds.qa_enumeration cat ON a.category = cat.id
     LEFT JOIN ds.qa_enumeration scat ON a.sub_category = scat.id
     LEFT JOIN ds.qa_enumeration dp ON a.discipline = dp.id
     LEFT JOIN ds.qa_enumeration pg ON a.progress = pg.id
     LEFT JOIN ds.qa_enumeration afrs ON afrs.id = afr.report_status
     LEFT JOIN ds.qa_css_info ci ON ci.id = a.css_info
     LEFT JOIN ds.qa_app_user au ON au.id = a.creator
     LEFT JOIN ds.qa_app_user aur ON aur.id = a.responsible
     LEFT JOIN ds.qa_app_user aue ON aue.id = a.extra_source
	 )x
	 where x.ord=1

GO
/****** Object:  View [DS].[v_qa_activity_planning]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [DS].[v_qa_activity_planning]
AS SELECT activity_id,
    planning_id
   FROM ds.qa_activity_planning

GO
/****** Object:  Table [DS].[qa_capa]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_capa](
	[id] [nvarchar](2000) NULL,
	[issue_date] [nvarchar](2000) NULL,
	[source_description] [nvarchar](2000) NULL,
	[finding_description] [nvarchar](2000) NULL,
	[root_cause_description] [nvarchar](2000) NULL,
	[action_description] [nvarchar](2000) NULL,
	[capa_number] [nvarchar](2000) NULL,
	[planned_implementation] [nvarchar](2000) NULL,
	[risk_level] [nvarchar](2000) NULL,
	[root_cause] [nvarchar](2000) NULL,
	[action_type] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[activity_id] [nvarchar](2000) NULL,
	[status] [nvarchar](2000) NULL,
	[nature_of_finding_level1] [nvarchar](2000) NULL,
	[nature_of_finding_level2] [nvarchar](2000) NULL,
	[attachment] [nvarchar](2000) NULL,
	[action_owner] [nvarchar](2000) NULL,
	[responsible] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[closed_on_date] [nvarchar](2000) NULL,
	[revised_date] [nvarchar](2000) NULL,
	[insufficient_evidence] [nvarchar](2000) NULL,
	[rca_report] [nvarchar](2000) NULL,
	[creator] [nvarchar](2000) NULL,
	[comment] [nvarchar](2000) NULL,
	[ordinal_number] [nvarchar](2000) NULL,
	[overdue_action_delays] [nvarchar](2000) NULL,
	[closure_time] [nvarchar](2000) NULL,
	[overdue_rating] [nvarchar](2000) NULL,
	[completion_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_project_detail]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_project_detail](
	[id] [int] NULL,
	[number] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NULL,
	[update_date] [nvarchar](255) NULL,
	[qa_lead] [nvarchar](255) NULL,
	[assessor] [nvarchar](255) NULL,
	[progress] [nvarchar](255) NULL,
	[issue_date] [nvarchar](255) NULL,
	[qa_scope] [nvarchar](255) NULL,
	[comment] [nvarchar](255) NULL,
	[project_manager] [nvarchar](255) NULL,
	[last_update_of_assurance_plan] [nvarchar](255) NULL,
	[assurance_plan] [nvarchar](255) NULL,
	[project_id] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_qa_capa]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE  VIEW [DS].[v_qa_capa]
AS SELECT c.id AS capa_id,
    c.capa_number,
    c.activity_id,
    c.issue_date AS capa_issue_date,
    c.creation_date AS capa_creation_date,
    case when c.overdue_action_delays='' or c.overdue_action_delays='0' then null else c.overdue_action_delays end AS capa_overdue_action_delays,
	cast(TRY_CONVERT(datetime,c.closed_on_date) as date) capa_closed_date,
    --c.closed_on_date AS capa_closed_date,
	c.comment as capa_comment,
    case when isdate(c.planned_implementation)=1 then cast(c.planned_implementation as date) else null end AS capa_planned_implementation,
    f1.label AS nature_of_finding_level1,
    f2.label AS nature_of_finding_level2,
    rc.label AS capa_root_cause,
    rc.code AS capa_root_cause_code,
    c.root_cause_description AS capa_root_cause_description,
    cs.label AS capa_status,
    cs.code AS capa_status_code,
    cor.label AS capa_overdue_rating,
    cor.code AS capa_overdue_rating_code,
    pr.label AS capa_risk_level,
    pr.code AS capa_risk_level_code,
    d.project_id,
	c.source_description capa_source_description,
    c.finding_description as capa_finding_description,
    c.action_description as capa_action_description
   FROM ds.qa_capa c
   inner join ds.qa_project_detail d on d.id=c.project_id
     LEFT JOIN ds.qa_enumeration cs ON cs.id = c.status
     LEFT JOIN ds.qa_enumeration pr ON pr.id = c.risk_level
     LEFT JOIN ds.qa_enumeration cor ON c.overdue_rating = cor.id
     LEFT JOIN ds.qa_enumeration rc ON c.root_cause = rc.id
     LEFT JOIN ds.qa_enumeration f1 ON c.nature_of_finding_level1 = f1.id
     LEFT JOIN ds.qa_enumeration f2 ON c.nature_of_finding_level2 = f2.id




GO
/****** Object:  View [DS].[v_qa_planning]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [DS].[v_qa_planning]
AS SELECT p.id AS planning_id,
    pls.code AS planning_status_code,
    pls.label AS planning_status,
    at2.label AS planning_activity_type,
    at2.code AS planning_activity_type_code,
    p.creation_date AS planning_creation_date,
    p.update_date AS planning_update_date,
    p.fiscal_year,
    p.project_id
   FROM ds.qa_planning p
     LEFT JOIN ds.qa_enumeration pls ON pls.id = p.status
     LEFT JOIN ds.qa_activity_type at2 ON at2.id = p.activity_type_id

GO
/****** Object:  Table [DS].[project_management_client]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_client](
	[creation_date] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[logo] [nvarchar](2000) NULL,
	[migrated] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_project_phase]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_project_phase](
	[id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[phase_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_cache_ad_user]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_cache_ad_user](
	[id] [nvarchar](2000) NULL,
	[azure_directory_id] [nvarchar](2000) NULL,
	[first_name] [nvarchar](2000) NULL,
	[last_name] [nvarchar](2000) NULL,
	[mail] [nvarchar](2000) NULL,
	[mobile_phone] [nvarchar](2000) NULL,
	[job_title] [nvarchar](2000) NULL,
	[is_deleted] [nvarchar](2000) NULL,
	[is_admin] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_project]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_project](
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[number] [nvarchar](2000) NULL,
	[sector] [nvarchar](2000) NULL,
	[bu] [nvarchar](2000) NULL,
	[status] [nvarchar](2000) NULL,
	[start_date] [nvarchar](2000) NULL,
	[expected_finished_date] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[customer] [nvarchar](2000) NULL,
	[qa_lead] [nvarchar](2000) NULL,
	[assessor] [nvarchar](2000) NULL,
	[progress] [nvarchar](2000) NULL,
	[issue_date] [nvarchar](2000) NULL,
	[qa_scope] [nvarchar](2000) NULL,
	[on_hold_date] [nvarchar](2000) NULL,
	[on_close_date] [nvarchar](2000) NULL,
	[comment] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_business_unit]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_business_unit](
	[id] [nvarchar](2000) NULL,
	[abbreviation] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_enumeration]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_enumeration](
	[creation_date] [nvarchar](2000) NULL,
	[type] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[label] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_project]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_project](
	[jv_partner] [nvarchar](2000) NULL,
	[sponsor] [nvarchar](2000) NULL,
	[home_office_location] [nvarchar](2000) NULL,
	[picture] [nvarchar](2000) NULL,
	[site_location] [nvarchar](2000) NULL,
	[signed_authorization_url] [nvarchar](2000) NULL,
	[migrated] [nvarchar](2000) NULL,
	[on_hold_date] [nvarchar](2000) NULL,
	[close_date] [nvarchar](2000) NULL,
	[max_date] [nvarchar](2000) NULL,
	[maximum_amount] [nvarchar](2000) NULL,
	[client_id] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[program_id] [nvarchar](2000) NULL,
	[sector_id] [nvarchar](2000) NULL,
	[bu_id] [nvarchar](2000) NULL,
	[project_size_id] [nvarchar](2000) NULL,
	[risk_classification_id] [nvarchar](2000) NULL,
	[status_id] [nvarchar](2000) NULL,
	[type_contract_id] [nvarchar](2000) NULL,
	[commercial_contract_id] [nvarchar](2000) NULL,
	[scope_id] [nvarchar](2000) NULL,
	[project_creation_status_id] [nvarchar](2000) NULL,
	[jesa_contract] [nvarchar](2000) NULL,
	[target] [nvarchar](2000) NULL,
	[workshare_split] [nvarchar](2000) NULL,
	[daily_working_hours] [nvarchar](2000) NULL,
	[start_date] [nvarchar](2000) NULL,
	[contractual_end_date] [nvarchar](2000) NULL,
	[forecast_date] [nvarchar](2000) NULL,
	[longitude] [nvarchar](2000) NULL,
	[latitude] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[with_work_location] [nvarchar](2000) NULL,
	[number] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[risks_determining_risk_classification] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_sector]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_sector](
	[code] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_qa_project]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE  VIEW [DS].[v_qa_project]
AS select *
from (
SELECT pj.id AS project_id,
    pj.number AS project_number,
    pj.name AS project_name,
    pc.name AS project_customer,
    pbu.name AS project_bu,
    pbu.code AS project_bu_code,
    pbus.name AS project_sector,
    pbus.code AS project_sector_code,
    ps.code AS project_status_code,
    ps.label AS project_status,
    psz.label AS project_size,
    psp.label AS project_phase,
    psr.label AS project_risk,
	ad.mail as project_lead,
	qpd.qa_scope project_scope,
	ROW_NUMBER() over(partition by  pj.number order by pj.id desc) ord
   FROM ds.project_management_project pj
   inner join ds.qa_project pr on pr.id=pj.id
   inner  join ds.qa_project_detail qpd on qpd.project_id=pj.id 
	left outer join ds.project_management_client pc on pc.id=pj.client_id
     LEFT JOIN ds.project_management_enumeration ps ON pj.status_id = ps.id
     LEFT JOIN ds.project_management_business_unit pbu ON pbu.id = pj.bu_id
     LEFT JOIN ds.project_management_sector pbus ON pbus.id = pj.sector_id
	 --left outer join ds.qa_project qp on qp.id=pj.id
	 
	 LEFT JOIN ds.qa_app_user ap on ap.id = qpd.qa_lead
	 LEFT JOIN ds.qa_cache_ad_user ad on ad.id = ap.user_mg_id
     outer apply ( SELECT top 1 ee.*
           FROM ds.project_management_project_phase phh
		   inner join ds.project_management_enumeration ee on ee.id=phh.phase_id
		   where phh.project_id=pj.id
		   order by phh.id desc) psp
      LEFT JOIN ds.project_management_enumeration psz ON psz.id = pj.project_size_id
     
     LEFT JOIN ds.project_management_enumeration psr ON psr.id = pj.risk_classification_id
	 )x
	 where x.ord=1







GO
/****** Object:  View [DS].[v_qa_user]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  VIEW [DS].[v_qa_user]
AS SELECT cast(cache_ad_user.id as char(50)) AS cache_ad_user_id,
    cache_ad_user.last_name AS user_last_name,
    cache_ad_user.first_name AS user_first_name,
    cache_ad_user.mail AS user_email,
	is_deleted as user_deleted,
	mobile_phone user_phone,
	N'QA' SourceSystem
   FROM ds.qa_cache_ad_user cache_ad_user

GO
/****** Object:  Table [LogBoomi].[vVer2Collab2]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vVer2Collab2](
	[WorkOrderID] [int] NULL,
	[month] [int] NULL,
	[year] [int] NULL,
	[planned] [numeric](12, 2) NULL,
	[actual] [numeric](12, 2) NULL,
	[forecast] [numeric](12, 2) NULL,
	[projectId] [int] NULL,
	[ReportingYear] [int] NULL,
	[ReportingMonth] [int] NULL,
	[isPostCutoff] [int] NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vVer2Collab1]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vVer2Collab1](
	[revisionText] [nvarchar](255) NULL,
	[hours] [int] NULL,
	[amount] [numeric](19, 2) NULL,
	[approved] [nvarchar](5) NULL,
	[startDate] [date] NULL,
	[finishDate] [date] NULL,
	[project] [int] NULL,
	[month] [int] NULL,
	[year] [int] NULL,
	[workorderid] [int] NULL,
	[ReportingYear] [int] NULL,
	[ReportingMonth] [int] NULL,
	[isPostCutoff] [int] NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vVer2Collab4]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vVer2Collab4](
	[month] [int] NULL,
	[year] [int] NULL,
	[project] [int] NULL,
	[workorder] [int] NULL,
	[cpi] [numeric](17, 2) NULL,
	[isPostCutoff] [int] NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vVer2Collab3]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vVer2Collab3](
	[month] [int] NULL,
	[WorkOrder] [nvarchar](250) NULL,
	[year] [int] NULL,
	[project] [int] NULL,
	[work_order_id] [int] NULL,
	[professionalServicesComment] [nvarchar](max) NULL,
	[ReportGroupingNameCollab] [nvarchar](250) NULL,
	[id_cost_discipline] [int] NULL,
	[label_cost_discipline] [nvarchar](250) NULL,
	[code_cost_discipline] [nvarchar](250) NULL,
	[type_cost_discipline] [nvarchar](250) NULL,
	[id_cost_indicator] [int] NULL,
	[label_ps_indicator] [nvarchar](250) NULL,
	[code_label_ps_indicator] [nvarchar](250) NULL,
	[type_ps_indicator] [nvarchar](250) NULL,
	[value_hours] [numeric](17, 2) NULL,
	[value_cost] [numeric](17, 2) NULL,
	[isPostCutoff] [int] NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[ver2_cash_gross_margin]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[ver2_cash_gross_margin](
	[id] [int] NOT NULL,
	[month] [int] NOT NULL,
	[year] [int] NOT NULL,
	[planned] [numeric](12, 2) NULL,
	[actual] [numeric](12, 2) NULL,
	[forecast] [numeric](12, 2) NULL,
	[creation_date] [datetime] NOT NULL,
	[update_date] [datetime] NULL,
	[id_cash] [int] NULL,
	[work_order_period] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[ver2_work_order_period]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[ver2_work_order_period](
	[id] [int] NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[update_date] [datetime] NULL,
	[month] [int] NULL,
	[year] [int] NULL,
	[id_work_order] [int] NULL,
	[work_order_id] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[ver3_parent_kpi_cost]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[ver3_parent_kpi_cost](
	[id] [int] NOT NULL,
	[id_cost] [int] NULL,
	[id_work_order] [int] NULL,
	[comment] [text] NULL,
	[creation_date] [datetime] NOT NULL,
	[update_date] [datetime] NULL,
	[work_order_id] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[ver3_professional_service]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[ver3_professional_service](
	[id] [int] NOT NULL,
	[type] [int] NOT NULL,
	[cost_service_indicator] [int] NOT NULL,
	[total] [numeric](20, 2) NULL,
	[creation_date] [datetime] NOT NULL,
	[update_date] [datetime] NULL,
	[id_parent_kpi_cost] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[ver3_professional_service_discipline]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[ver3_professional_service_discipline](
	[id] [int] NOT NULL,
	[cost_discipline] [int] NULL,
	[id_professional_service] [int] NULL,
	[value] [numeric](17, 2) NULL,
	[creation_date] [datetime] NOT NULL,
	[update_date] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[ver4_cost_cpi]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[ver4_cost_cpi](
	[id] [int] NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[update_date] [datetime] NULL,
	[cpi] [numeric](12, 2) NULL,
	[month] [int] NULL,
	[year] [int] NULL,
	[start_of_the_week] [date] NULL,
	[id_work_order] [int] NULL,
	[work_order_id] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[ver1_cash_work_order]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[ver1_cash_work_order](
	[id] [int] NOT NULL,
	[revision_text] [nvarchar](max) NOT NULL,
	[hours] [numeric](14, 2) NULL,
	[amount] [numeric](19, 2) NOT NULL,
	[start_date] [date] NULL,
	[finish_date] [date] NULL,
	[approved] [nvarchar](max) NOT NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[id_project] [int] NULL,
	[month] [int] NULL,
	[year] [int] NULL,
	[id_work_order] [int] NULL,
	[work_order_id] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[ver2_work_order]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[ver2_work_order](
	[id] [int] NOT NULL,
	[number] [nvarchar](255) NOT NULL,
	[id_project] [int] NULL,
	[creation_date] [datetime] NOT NULL,
	[update_date] [datetime] NULL,
	[is_overall_work_order] [nvarchar](max) NULL,
	[work_order_type] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[ver3_cost]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[ver3_cost](
	[id] [int] NOT NULL,
	[month] [int] NOT NULL,
	[year] [int] NOT NULL,
	[tic_cost_analysis] [nvarchar](max) NULL,
	[user_comment] [nvarchar](max) NULL,
	[forecast_value] [numeric](10, 2) NULL,
	[forecast_variance] [numeric](10, 2) NULL,
	[cpi] [numeric](10, 2) NULL,
	[id_project] [int] NULL,
	[creation_date] [datetime] NOT NULL,
	[update_date] [datetime] NULL,
	[start_of_the_week] [date] NULL,
	[actual_hrs_to_date] [numeric](14, 2) NULL,
	[as_sold_plan_hrs_to_date] [numeric](14, 2) NULL,
	[maintenance_cost_comment] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [LogBoomi].[v_Verano_Monitoring]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- LogBoomi.v_Verano_Monitoring source

-- LogBoomi.v_Verano_Monitoring source

-- LogBoomi.v_Verano_Monitoring source



CREATE view [LogBoomi].[v_Verano_Monitoring] as 
-- LogBoomi.v_Monitoring source

with
	Collab_gross_margin
	as (
	select distinct
		cgm.id,
		cgm.update_date,
	    cgm.month,
	    cgm.year,
		cgm.work_order_period,
		wop.work_order_id,
		wo.id_project,
		wop.month as ReportingMonth_C,
		wop.year as ReportingYear_C,
		cgm.planned as planned_collab,
		cgm.actual as actual_collab,
		cgm.forecast as forecast_collab
	from
		STG.LogBoomi.ver2_cash_gross_margin cgm
		left join STG.LogBoomi.ver2_work_order_period wop on cgm.work_order_period = wop.id
		left outer join STG.LogBoomi.ver2_work_order wo on wo.id=wop.work_order_id
	),
	PS_Collab  
    as(
    select 
        psd.update_date,
        psd.creation_date,
        psd.value AS Collab_Value,
        psd.value,
        ps.[type],
        wo.id as work_order_id,
        wo.id_project,
        vc.[month],
        vc.[year],
        ps.cost_service_indicator,
        psd.cost_discipline
    from 
        stg.LogBoomi.ver3_professional_service_discipline psd 
        left join stg.LogBoomi.ver3_professional_service ps on psd.id_professional_service = ps.id 
        left join stg.LogBoomi.ver3_parent_kpi_cost pkc on ps.id_parent_kpi_cost = pkc.id
        left join stg.LogBoomi.ver2_work_order wo on pkc.work_order_id = wo.id 
        left join stg.LogBoomi.ver3_cost vc on pkc.id_cost = vc.id 
    ),
    CPI_Collab
	AS (
	SELECT 
		vcc.id as id_cpi_collab,
		vcc.[month],
		vcc.[year], 
		vcc.update_date, 
		vcc.work_order_id,
		wo.id_project, 
		vcc.cpi as cpi_collab 
	FROM
		STG.logboomi.ver4_cost_cpi vcc 
		left join STG.LogBoomi.ver2_work_order wo on vcc.work_order_id = wo.id
	)
	
select CAST([DWHViewName] AS NVARCHAR(50)) + '||' +
            CAST([ReportingYear] AS NVARCHAR(50)) + '||' +
            CAST([ReportingMonth] AS NVARCHAR(50)) + '||' +
            CAST([isPostCutoff] AS NVARCHAR(50)) + '||' +
            CAST([TimePeriodYear] AS NVARCHAR(50)) + '||' +
            CAST([TimePeriodMonth] AS NVARCHAR(50)) + '||' +
            CAST([project] AS NVARCHAR(50)) + '||' +
            CAST([workorderid] AS NVARCHAR(50)) + '||' +
            CAST([id_cost_indicator] AS NVARCHAR(50)) + '||' +
            CAST([id_cost_discipline] AS NVARCHAR(50)) + '||' ID,*
from (
Select
N'vVer2Collab1' DWHViewName,
N'cash_work_order' CollabTables,
dwh.ReportingYear,
dwh.ReportingMonth,
dwh.isPostCutoff,
dwh.year TimePeriodYear,
dwh.month TimePeriodMonth,
dwh.project,
dwh.workorderid,
N'-' id_cost_indicator,
N'-' id_cost_discipline,
N'Insert' IntegrationType,
N'Insert_CWO' KPI,
N'-' DWHValue,
N'-' CollabValue,
N'Insert: CWO in DWH but not in COLLAB' reason
from
    STG.LogBoomi.vVer2Collab1 DWH
	 left join stg.LogBoomi.ver1_cash_work_order C on C.id_project = DWH.project and C.work_order_id = DWH.workorderid and DWH.month = C.month and DWH.year = C.year
where
    C.id_project is NULL
 
    
UNION
 
Select
N'vVer2Collab1' DWHViewName,
N'cash_work_order' CollabTables,
dwh.ReportingYear,
dwh.ReportingMonth,
dwh.isPostCutoff,
dwh.year TimePeriodYear,
dwh.month TimePeriodMonth,
dwh.project,
dwh.workorderid,
N'-' id_cost_indicator,
N'-' id_cost_discipline,
N'Update' IntegrationType,
N'Hours' KPI,
cast(DWH.hours as nvarchar(50)) DWHValue,
cast(C.hours as nvarchar(50)) CollabValue,
N'Update: Mismatch in Hours' reason
from
STG.LogBoomi.vVer2Collab1 DWH
	 inner join stg.LogBoomi.ver1_cash_work_order C on C.id_project = DWH.project and C.work_order_id = DWH.workorderid and DWH.month = C.month and DWH.year = C.year
where DWH.hours <> C.hours

UNION

Select
N'vVer2Collab1' DWHViewName,
N'cash_work_order' CollabTables,
dwh.ReportingYear,
dwh.ReportingMonth,
dwh.isPostCutoff,
dwh.year TimePeriodYear,
dwh.month TimePeriodMonth,
dwh.project,
dwh.workorderid,
N'-' id_cost_indicator,
N'-' id_cost_discipline,
N'Update' IntegrationType,
N'Amount' KPI,
cast(DWH.amount as nvarchar(50)) DWHValue,
cast(C.amount  as nvarchar(50)) CollabValue,
N'Update:Mismatch in Amount' reason
from
STG.LogBoomi.vVer2Collab1 DWH
	 inner join stg.LogBoomi.ver1_cash_work_order C on C.id_project = DWH.project and C.work_order_id = DWH.workorderid and DWH.month = C.month and DWH.year = C.year
where DWH.amount <> C.amount

UNION

Select
N'vVer2Collab1' DWHViewName,
N'cash_work_order' CollabTables,
dwh.ReportingYear,
dwh.ReportingMonth,
dwh.isPostCutoff,
dwh.year TimePeriodYear,
dwh.month TimePeriodMonth,
dwh.project,
dwh.workorderid,
N'-' id_cost_indicator,
N'-' id_cost_discipline,
N'Update' IntegrationType,
N'Approved' KPI,
Cast (DWH.approved as nvarchar(max)) DWHValue,
Cast (C.approved as nvarchar(max)) CollabValue,
N'Update: Mismatch in Approved' reason
from
	STG.LogBoomi.vVer2Collab1 DWH inner join stg.LogBoomi.ver1_cash_work_order C 
	on C.id_project = DWH.project and C.work_order_id = DWH.workorderid and DWH.month = C.month and DWH.year = C.year
where 
	left(dwh.approved,1) <> c.approved
	
UNION 


-----MAIN CASH GROSS MARGIN


Select
N'vVer2Collab2' DWHViewName,
N'Cash_Gross_Margin' CollabTables,
DWH.ReportingYear as ReportingYear,
DWH.ReportingMonth as ReportingMonth,
dwh.isPostCutoff,
dwh.year TimePeriodYear,
dwh.month TimePeriodMonth,
dwh.projectId,
dwh.workorderid,
N'-' id_cost_indicator,
N'-' id_cost_discipline,
N'Insert' IntegrationType,
N'Insert_CGM' KPI,
N'-' DWHValue,
N'-' CollabValue,
N'Insert: CGM in DWH but not in Collab' reason
from
	STG.LogBoomi.vVer2Collab2 as DWH
LEFT join Collab_gross_margin C
	on C.id_project=DWH.projectId and C.work_order_id=DWH.WorkOrderID
	and DWH.ReportingMonth=C.ReportingMonth_C and DWH.ReportingYear=C.ReportingYear_C
	and DWH.month = C.month and DWH.year = C.year
where C.id_project is NULL 

UNION

Select
N'vVer2Collab2' DWHViewName,
N'cash_Gross_Margin' CollabTables,
DWH.ReportingYear as ReportingYear,
DWH.ReportingMonth as ReportingMonth,
dwh.isPostCutoff,
dwh.year TimePeriodYear,
dwh.month TimePeriodMonth,
dwh.projectId,
dwh.workorderid,
N'-' id_cost_indicator,
N'-' id_cost_discipline,
N'Update' IntegrationType,
N'Planned' KPI,
cast(DWH.planned as nvarchar(50)) as DWHValue,
cast (C.planned_collab as nvarchar(50))  as CollabValue,
N'Update: Mismatch in Planned' reason
from
	STG.LogBoomi.vVer2Collab2  as DWH
inner join Collab_gross_margin C
	on C.id_project=DWH.projectId and C.work_order_id=DWH.WorkOrderID
	and DWH.ReportingMonth=C.ReportingMonth_C and DWH.ReportingYear=C.ReportingYear_C
	and DWH.month = C.month and DWH.year = C.year
where C.planned_collab != DWH.planned

UNION


Select
N'vVer2Collab2' DWHViewName,
N'cash_Gross_Margin' CollabTables,
DWH.ReportingYear as ReportingYear,
DWH.ReportingMonth as ReportingMonth,
dwh.isPostCutoff,
dwh.year TimePeriodYear,
dwh.month TimePeriodMonth,
dwh.projectId,
dwh.workorderid,
N'-' id_cost_indicator,
N'-' id_cost_discipline,
N'Update' IntegrationType,
N'Actual' KPI,
cast(DWH.actual as nvarchar(50)) as DWHValue,
cast(C.actual_collab as nvarchar(50)) as CollabValue,
N'Update: Mismatch in Actual' reason
from
	STG.LogBoomi.vVer2Collab2 as DWH
inner join Collab_gross_margin C
	on C.id_project=DWH.projectId and C.work_order_id=DWH.WorkOrderID
	and DWH.ReportingMonth=C.ReportingMonth_C and DWH.ReportingYear=C.ReportingYear_C
	and DWH.month = C.month and DWH.year = C.year
where C.actual_collab != DWH.actual

union 

Select
N'vVer2Collab2' DWHViewName,
N'Cash_Gross_Margin' CollabTables,
DWH.ReportingYear as ReportingYear,
DWH.ReportingMonth as ReportingMonth,
dwh.isPostCutoff,
dwh.year TimePeriodYear,
dwh.month TimePeriodMonth,
dwh.projectId,
dwh.workorderid,
N'-' id_cost_indicator,
N'-' id_cost_discipline,
N'Update' IntegrationType,
N'Forecast' KPI,
cast(DWH.forecast as nvarchar(50)) as DWHValue,
cast(C.forecast_collab as nvarchar(50)) as CollabValue,
N'Update: Mismatch in Forecast' reason
from
	STG.LogBoomi.vVer2Collab2  DWH
inner join Collab_gross_margin C
	on C.id_project=DWH.projectId and C.work_order_id=DWH.WorkOrderID
	and DWH.ReportingMonth=C.ReportingMonth_C and DWH.ReportingYear=C.ReportingYear_C
	and DWH.month = C.month and DWH.year = C.year
where C.forecast_collab != DWH.forecast



----- END OF CASH GROSS MARGIN

UNION

----- MAIN PROFESSIONAL SERVICES

SELECT 
	N'vVer2Collab3' DWHViewName,
	N'Professional Services' CollabTables,
	dwh.year ReportingYear,
	dwh.month ReportingMonth,
	dwh.isPostCutoff,
	dwh.year TimePeriodYear,
	dwh.month TimePeriodMonth,
	dwh.project,
	dwh.work_order_id,
	cast (DWH.id_cost_indicator as nvarchar(MAX)) as id_cost_indicator,
   	cast (DWH.id_cost_discipline as nvarchar(MAX)) as id_cost_discipline,
	N'Insert' IntegrationType,
	N'PS' KPI,
	N'-' DWHValue,
	N'-' CollabValue,
	N'Insert: PS in DWH but not in Collab' reason
from 
    stg.LogBoomi.vVer2Collab3 as DWH left join PS_Collab C on DWH.work_order_id= C.work_order_id and DWH.project= C.id_project and DWH.month = C.month and DWH.year= C.year 
    and c.cost_service_indicator=dwh.id_cost_indicator
    and c.cost_discipline=DWH.id_cost_discipline 
WHERE 
	C.id_project is null

UNION
  
SELECT 
	N'vVer2Collab3' DWHViewName,
	N'Professional Services' CollabTables,
	dwh.year ReportingYear,
	dwh.month ReportingMonth,
	dwh.isPostCutoff,
	dwh.year TimePeriodYear,
	dwh.month TimePeriodMonth,
	dwh.project,
	dwh.work_order_id,
	cast (DWH.id_cost_indicator as nvarchar(MAX)) as id_cost_indicator,
   	cast (DWH.id_cost_discipline as nvarchar(MAX)) as id_cost_discipline,
	N'Update' IntegrationType,
	N'Value_Cost' KPI,
	cast(DWH.value_cost as nvarchar(50)) as DWHValue,
	cast(C.Collab_Value as nvarchar(50)) as CollabValue,
	N'Update: Mismatch in Value_Cost' reason
from 
    stg.LogBoomi.vVer2Collab3 as DWH inner join PS_Collab C on DWH.work_order_id= C.work_order_id and DWH.project= C.id_project and DWH.month = C.month and DWH.year= C.year 
    and c.cost_service_indicator=dwh.id_cost_indicator
    and c.cost_discipline=DWH.id_cost_discipline and C.type = 54
WHERE 
	C.Collab_Value <> DWH.value_cost
	
UNION

SELECT 
	N'vVer2Collab3' DWHViewName,
	N'Professional Services' CollabTables,
	dwh.year ReportingYear,
	dwh.month ReportingMonth,
	dwh.isPostCutoff,
	dwh.year TimePeriodYear,
	dwh.month TimePeriodMonth,
	dwh.project,
	dwh.work_order_id,
	cast (DWH.id_cost_indicator as nvarchar(MAX)) as id_cost_indicator,
   	cast (DWH.id_cost_discipline as nvarchar(MAX)) as id_cost_discipline,
	N'Update' IntegrationType,
	N'Value_Hours' KPI,
	cast(DWH.value_hours as nvarchar(50)) as DWHValue,
	cast(C.Collab_Value as nvarchar(50)) as CollabValue,
	N'Update: Mismatch in Value_Hours' reason
from 
    stg.LogBoomi.vVer2Collab3 as DWH inner join PS_Collab C on DWH.work_order_id= C.work_order_id and DWH.project= C.id_project and DWH.month = C.month and DWH.year= C.year 
    and c.cost_service_indicator=dwh.id_cost_indicator
    and c.cost_discipline=DWH.id_cost_discipline and C.type = 53
WHERE 
	C.Collab_Value <> DWH.value_hours
    

---- END OF PRO SERVICES 
UNION	
---- MAIN COST CPI


SELECT 
	N'vVer2Collab4' DWHViewName,
	N'Cost_CPI' CollabTables,
	dwh.year ReportingYear,
	dwh.month ReportingMonth,
	dwh.isPostCutoff,
	dwh.year TimePeriodYear,
	dwh.month TimePeriodMonth,
	dwh.project,
	dwh.workorder,
	N'-' id_cost_indicator,
   	N'-' id_cost_discipline,
	N'Insert' IntegrationType,
	N'Insert_CPI' KPI,
	N'-' DWHValue,
	N'-' CollabValue,
	N'Insert: CPI in DWH but not in Collab' reason
FROM
    STG.LogBoomi.vVer2Collab4 DWH  left join CPI_Collab C
    on DWH.project = C.id_project and DWH.workorder = C.work_order_id
    and DWH.month = C.month and DWH.year = C.year
WHERE
    C.id_project is null 
    
UNION

SELECT 
	N'vVer2Collab4' DWHViewName,
	N'Cost_CPI' CollabTables,
	dwh.year ReportingYear,
	dwh.month ReportingMonth,
	dwh.isPostCutoff,
	dwh.year TimePeriodYear,
	dwh.month TimePeriodMonth,
	dwh.project,
	dwh.workorder,
	N'-' id_cost_indicator,
   	N'-' id_cost_discipline,
	N'Update' IntegrationType,
	N'Cost_CPI' KPI,
	cast(DWH.cpi as nvarchar(50)) as DWHValue,
	cast(C.cpi_collab as nvarchar(50)) as CollabValue,
	N'Update: Mismatch in CPI' reason
FROM
    STG.LogBoomi.vVer2Collab4 DWH  inner join CPI_Collab C
    on DWH.project = C.id_project and DWH.workorder = C.work_order_id
    and DWH.month = C.month and DWH.year = C.year
WHERE
    C.cpi_collab != DWH.cpi

------ END OF COST CPI

UNION

------ MAIN ALL SENT DATA 

SELECT 
    N'vVer2Collab1' AS DWHViewName,
    N'-' AS CollabTables,
    DWH.ReportingYear AS ReportingYear,
    DWH.ReportingMonth  AS ReportingMonth,
	DWH.isPostCutoff  AS isPostCutoff,
    DWH.[year]  AS TimePeriodYear,
    DWH.[month]  AS TimePeriodMonth,
    DWH.project  AS project,
    DWH.workorderid  AS workorder,
    N'-' AS id_cost_indicator,
    N'-' AS id_cost_discipline,
    N'Original Data' AS IntegrationType,
    N'CWO' AS KPI,
   	CAST(NULL AS nvarchar(50)) AS DWHValue,
    CAST(NULL AS nvarchar(50)) AS CollabValue,
    N'Sent Document' AS reason
FROM
    STG.LogBoomi.vVer2Collab1 DWH
    
UNION

SELECT 
	N'vVer2Collab2' AS DWHViewName,
    N'-' AS CollabTables,
    DWH.ReportingYear AS ReportingYear,
    DWH.ReportingMonth  AS ReportingMonth,
	DWH.isPostCutoff  AS isPostCutoff,
    DWH.[year]  AS TimePeriodYear,
    DWH.[month]  AS TimePeriodMonth,
    DWH.projectId  AS project,
    DWH.WorkOrderID  AS workorder,
    N'-' AS id_cost_indicator,
    N'-' AS id_cost_discipline,
    N'Original Data' AS IntegrationType,
    N'CGM' AS KPI,
   	CAST(NULL AS nvarchar(50)) AS DWHValue,
    CAST(NULL AS nvarchar(50)) AS CollabValue,
    N'Sent Document' AS reason
FROM
    STG.LogBoomi.vVer2Collab2 DWH

UNION

SELECT 
	N'vVer2Collab3' AS DWHViewName,
    N'-' AS CollabTables,
    DWH.[year] AS ReportingYear,
    DWH.[month]  AS ReportingMonth,
	DWH.isPostCutoff  AS isPostCutoff,
    DWH.[year]  AS TimePeriodYear,
    DWH.[month]  AS TimePeriodMonth,
   	DWH.project  AS project,
    DWH.work_order_id  AS workorder,
    CAST(DWH.id_cost_indicator AS nvarchar(50)) as id_cost_indicator,
	CAST(DWH.id_cost_discipline AS nvarchar(50)) as id_cost_discipline,
    N'Original Data' AS IntegrationType,
    N'PS' AS KPI,
   	CAST(NULL AS nvarchar(50)) AS DWHValue,
    CAST(NULL AS nvarchar(50)) AS CollabValue,
    N'Sent Document' AS reason
FROM
    STG.LogBoomi.vVer2Collab3 DWH
   
UNION 

SELECT 
	N'vVer2Collab4' AS DWHViewName,
    N'-' AS CollabTables,
    DWH.[year] AS ReportingYear,
    DWH.[month]  AS ReportingMonth,
	DWH.isPostCutoff  AS isPostCutoff,
    DWH.[year]  AS TimePeriodYear,
    DWH.[month]  AS TimePeriodMonth,
    DWH.project  AS project,
    DWH.workorder  AS workorder,
    N'-' AS id_cost_indicator,
    N'-' AS id_cost_discipline,
    N'Original Data' AS IntegrationType,
    N'CPI' AS KPI,
   	CAST(NULL AS nvarchar(50)) AS DWHValue,
    CAST(NULL AS nvarchar(50)) AS CollabValue,
    N'Sent Document' AS reason
FROM
    STG.LogBoomi.vVer2Collab4 DWH)x

    
----- END;
GO
/****** Object:  Table [PROCORE].[ContractPayment]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[ContractPayment](
	[id] [nvarchar](1000) NULL,
	[amount] [nvarchar](1000) NULL,
	[check_number] [nvarchar](1000) NULL,
	[created_at] [nvarchar](1000) NULL,
	[date] [nvarchar](1000) NULL,
	[date_payment_settled] [nvarchar](1000) NULL,
	[date_payment_initiated] [nvarchar](1000) NULL,
	[draw_request_number] [nvarchar](1000) NULL,
	[invoice_number] [nvarchar](1000) NULL,
	[notes] [nvarchar](1000) NULL,
	[payment_number] [nvarchar](1000) NULL,
	[payment_method] [nvarchar](1000) NULL,
	[attachments_id] [nvarchar](1000) NULL,
	[attachments_url] [nvarchar](1000) NULL,
	[attachments_filename] [nvarchar](1000) NULL,
	[project_id] [nvarchar](1000) NULL,
	[contract_id] [nvarchar](1000) NULL,
	[requisition_id] [nvarchar](1000) NULL,
	[origin_id] [nvarchar](1000) NULL,
	[origin_code] [nvarchar](1000) NULL,
	[origin_data] [nvarchar](1000) NULL,
	[status] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [PROCORE].[v_req_pay_issued]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [PROCORE].[v_req_pay_issued] as
select distinct
r.[RequisitionID] ,
[InvoiceNumber] ,
[ReqStatusSK] ,
r.[ProjectSK] ,
r.[ContractSK] ,
[VendorSK] ,
[BillingDate] ,
[ReqCreationDate] ,
[ReqUpdateDate] ,
[BillingPeriodDueDate] ,
[BillingPeriodStartDate] ,
[BillingPeriodEndDate] ,
[CurrentPaymentDue] ,
[CurrentPaymentDue]*r.[ConversionRate] [CurrentPaymentDueMAD],
r.[ConversionRate] [ConversionRateRequisition],
[date] PayIssuedDate,
cast([amount] as numeric(17,2)) PaymentAmount,
cast([amount] as numeric(17,2))*case when cr.ContractCurrency='MAD' then 1 else ex.[Taux de conversion] end PaymentAmountMAD,
case when cr.ContractCurrency='MAD' then 1 else ex.[Taux de conversion] end [ConversionRatePayIssued],
c.payment_number PaymentNumber ,
c.notes
  FROM dwh.fact.f_requisitions r
  left outer join [STG].[PROCORE].[ContractPayment] c on r.[RequisitionID]=c.requisition_id
     left outer join dwh.dim.D_PROCCONTRACT cr on cr.ContractID=c.[contract_id]
		   left outer join dwh.dim.D_ExchangeRate ex on ex.Période='T' + CAST(DATEPART(QUARTER, c.[created_at]) AS VARCHAR(1)) + ' ' + CAST(DATEPART(YEAR, c.[created_at]) AS VARCHAR(4))
   and ex.Devise=cr.ContractCurrency

 

GO
/****** Object:  View [DS].[v_qa_activity_kpi]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE  VIEW [DS].[v_qa_activity_kpi]
AS SELECT  activity.id activity_id,
activityStatus.code activity_status,
activity.month activity_month,
activity.planned_date activity_planned_date,
activity.rescheduled_date activity_rescheduled_date,
planning.fiscal_year as planning_fiscal_year,
case 
			when activity.planned_date is null then activity.rescheduled_date
			when activity.rescheduled_date is null then activity.planned_date
			when activity.rescheduled_date is not null and activity.planned_date is not null and activity.planned_date>activity.rescheduled_date then activity.planned_date
			when activity.rescheduled_date is not null and activity.planned_date is not null and activity.planned_date<=activity.rescheduled_date then activity.rescheduled_date
			end max_planned_scheduled_date
from
	ds.qa_activity activity
inner join ds.qa_activity_planning activityPlanning on activityPlanning.activity_id = activity.id
inner join ds.qa_planning planning on	planning.id = activityPlanning.planning_id 	--and (planning.fiscal_year in (2024))
	and coalesce(planning.update_date, planning.creation_date)=(
	select max(coalesce(planning2.update_date, planning2.creation_date))
	from ds.qa_planning planning2
	inner join ds.qa_enumeration planningStatus on	(planningStatus.id = planning2.status)
	where
			planning2.project_id = planning.project_id
		and planning2.activity_type_id = planning.activity_type_id
		and planningStatus.code = 'REVIEWED'
		and planning2.fiscal_year = planning.fiscal_year)
inner join ds.qa_project_detail project on project.id=planning.project_id
--inner join ds.project_management_project project on (project.id = planning.project_id)
inner join ds.qa_project pr on pr.id = project.project_id

--inner join ds.qa_project_detail prr on prr.project_id = planning.project_id
inner join ds.qa_enumeration activityStatus on	(activityStatus.id = activity.status)
--inner join ds.project_management_enumeration projectStatus on	(projectStatus.id = project.status_id)

where pr.status like '%ACTIVE%'
		or activityStatus.code = 'CONDUCTED'
		or activityStatus.code = 'COMPLETED'
		or (pr.status like '%CLOSED%'
			and activity.planned_date <= pr.on_close_date)
		or (pr.status like '%ON_HOLD%'
			and activity.planned_date <= pr.on_hold_date)

			
			


GO
/****** Object:  Table [PROCORE].[requisitions]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[requisitions](
	[id] [varchar](250) NULL,
	[billing_date] [varchar](250) NULL,
	[created_at] [varchar](250) NULL,
	[updated_at] [varchar](250) NULL,
	[commitment_id] [varchar](250) NULL,
	[commitment_type] [varchar](250) NULL,
	[invoice_number] [varchar](250) NULL,
	[origin_data] [varchar](250) NULL,
	[origin_id] [varchar](250) NULL,
	[payment_date] [varchar](250) NULL,
	[percent_complete] [varchar](250) NULL,
	[period_id] [varchar](250) NULL,
	[status] [varchar](250) NULL,
	[submitted_at] [varchar](250) NULL,
	[comment] [varchar](8000) NULL,
	[final_requisitions] [varchar](250) NULL,
	[project_id] [varchar](250) NULL,
	[created_by] [varchar](250) NULL,
	[id_creator] [varchar](250) NULL,
	[login_creator] [varchar](250) NULL,
	[name_creator] [varchar](250) NULL,
	[company_name_creator] [varchar](250) NULL,
	[vendor_name] [varchar](250) NULL,
	[custom_fields] [varchar](250) NULL,
	[requisition_start] [varchar](250) NULL,
	[requisition_end] [varchar](250) NULL,
	[number] [varchar](250) NULL,
	[balance_to_finish_including_retainage] [varchar](250) NULL,
	[completed_work_retainage_amount] [varchar](250) NULL,
	[completed_work_retainage_percent] [varchar](250) NULL,
	[contract_sum_to_date] [varchar](250) NULL,
	[current_payment_due] [varchar](250) NULL,
	[formatted_period] [varchar](250) NULL,
	[less_previous_certificates_for_payment] [varchar](250) NULL,
	[negative_change_order_item_total] [varchar](250) NULL,
	[negative_new_change_order_item_total] [varchar](250) NULL,
	[negative_previous_change_order_item_total] [varchar](250) NULL,
	[net_change_by_change_orders] [varchar](250) NULL,
	[original_contract_sum] [varchar](250) NULL,
	[positive_change_order_item_total] [varchar](250) NULL,
	[positive_new_change_order_item_total] [varchar](250) NULL,
	[positive_previous_change_order_item_total] [varchar](250) NULL,
	[stored_materials_retainage_amount] [varchar](250) NULL,
	[stored_materials_retainage_percent] [varchar](250) NULL,
	[tax_applicable_to_this_payment] [varchar](250) NULL,
	[total_completed_and_stored_to_date] [varchar](250) NULL,
	[total_earned_less_retainage] [varchar](250) NULL,
	[total_retainage] [varchar](250) NULL,
	[currency] [nvarchar](100) NULL,
	[vendor_id] [nvarchar](50) NULL,
	[item_id] [nvarchar](500) NULL,
	[item_type] [nvarchar](500) NULL,
	[item_accounting_method] [nvarchar](500) NULL,
	[item_cost_code_id] [nvarchar](500) NULL,
	[item_line_item_id] [nvarchar](500) NULL,
	[item_description_of_work] [nvarchar](max) NULL,
	[item_net_amount] [nvarchar](500) NULL,
	[item_gross_amount] [nvarchar](500) NULL,
	[item_wbs_code_id] [nvarchar](500) NULL,
	[item_wbs_code_flat_code] [nvarchar](500) NULL,
	[item_wbs_code_description] [nvarchar](max) NULL,
	[item_wbs_code_segment_items_id] [nvarchar](500) NULL,
	[item_wbs_code_segment_items_code] [nvarchar](500) NULL,
	[item_wbs_code_segment_items_name] [nvarchar](500) NULL,
	[item_wbs_code_segment_items_path_ids] [nvarchar](500) NULL,
	[item_wbs_code_segment_items_path_codes] [nvarchar](500) NULL,
	[item_wbs_code_segment_items_segment_type] [nvarchar](500) NULL,
	[item_wbs_code_segment_items_segment_id] [nvarchar](500) NULL,
	[item_scheduled_value] [nvarchar](500) NULL,
	[item_work_completed_from_previous_application] [nvarchar](500) NULL,
	[item_work_completed_this_period] [nvarchar](500) NULL,
	[item_materials_presently_stored] [nvarchar](500) NULL,
	[item_materials_presently_stored_from_previous_progress] [nvarchar](500) NULL,
	[item_total_completed_and_stored_to_date] [nvarchar](500) NULL,
	[item_total_completed_and_stored_to_date_percent] [nvarchar](500) NULL,
	[item_total_completed_and_stored_to_date_from_previous] [nvarchar](500) NULL,
	[item_work_completed_retainage_from_previous_application] [nvarchar](500) NULL,
	[item_work_completed_retainage_retained_this_period] [nvarchar](500) NULL,
	[item_work_completed_retainage_percent_this_period] [nvarchar](500) NULL,
	[item_materials_stored_retainage_currently_retained] [nvarchar](500) NULL,
	[item_materials_stored_retainage_percent_this_period] [nvarchar](500) NULL,
	[item_materials_stored_retainage_new_materials] [nvarchar](500) NULL,
	[item_work_completed_retainage_released_this_period] [nvarchar](500) NULL,
	[item_materials_stored_retainage_released_this_period] [nvarchar](500) NULL,
	[item_scheduled_quantity] [nvarchar](500) NULL,
	[item_scheduled_unit_price] [nvarchar](500) NULL,
	[item_work_completed_this_period_quantity] [nvarchar](500) NULL,
	[item_work_completed_from_previous_application_quantity] [nvarchar](500) NULL,
	[item_comment] [nvarchar](500) NULL,
	[item_status] [nvarchar](500) NULL,
	[item_position] [nvarchar](500) NULL,
	[item_line_number] [nvarchar](500) NULL,
	[item_ssr_manual_override] [nvarchar](500) NULL,
	[item_subcontractor_claimed_amount] [nvarchar](500) NULL,
	[summary_text_project_name] [nvarchar](500) NULL,
	[summary_text_project_number] [nvarchar](500) NULL,
	[summary_text_to_general_contractor] [nvarchar](500) NULL,
	[summary_text_requisition_period_start] [nvarchar](500) NULL,
	[summary_text_requisition_period_end] [nvarchar](500) NULL,
	[summary_text_subcontractor_name] [nvarchar](500) NULL,
	[summary_text_subcontractor_street] [nvarchar](500) NULL,
	[summary_text_subcontractor_city] [nvarchar](500) NULL,
	[summary_text_subcontractor_state_code] [nvarchar](500) NULL,
	[summary_text_subcontractor_zip] [nvarchar](500) NULL,
	[summary_text_subcontractor_country_code] [nvarchar](500) NULL,
	[summary_text_application_number] [nvarchar](500) NULL,
	[summary_text_contract_for] [nvarchar](500) NULL,
	[summary_text_contract_date] [nvarchar](500) NULL,
	[custom_field_562949953947351] [nvarchar](500) NULL,
	[total_claimed_amount] [nvarchar](500) NULL,
	[item_flag] [nvarchar](50) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [PROCORE].[v_requisition]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [PROCORE].[v_requisition] as 
select  [id]
      ,[billing_date]
      ,[created_at]
      ,[updated_at]
      ,[commitment_id]
      ,[commitment_type]
      ,[invoice_number]
      ,[origin_data]
      ,[origin_id]
      ,[payment_date]
      ,[percent_complete]
      ,[period_id]
      ,[status]
      ,[submitted_at]
	   , REPLACE(REPLACE([comment], CHAR(13), ' '), CHAR(10), ' ') [comment]
      ,[final_requisitions]
      ,[project_id]
      ,[created_by]
      ,[id_creator]
      ,[login_creator]
      ,[name_creator]
      ,[company_name_creator]
      ,[vendor_name]
      ,[custom_fields]
      ,[requisition_start]
      ,[requisition_end]
      ,[number]
      ,[balance_to_finish_including_retainage]
      ,[completed_work_retainage_amount]
      ,[completed_work_retainage_percent]
      ,[contract_sum_to_date]
      ,[current_payment_due]
      ,[formatted_period]
      ,[less_previous_certificates_for_payment]
      ,[negative_change_order_item_total]
      ,[negative_new_change_order_item_total]
      ,[negative_previous_change_order_item_total]
      ,[net_change_by_change_orders]
      ,[original_contract_sum]
      ,[positive_change_order_item_total]
      ,[positive_new_change_order_item_total]
      ,[positive_previous_change_order_item_total]
      ,[stored_materials_retainage_amount]
      ,[stored_materials_retainage_percent]
      ,[tax_applicable_to_this_payment]
      ,[total_completed_and_stored_to_date]
      ,[total_earned_less_retainage]
      ,[total_retainage]
      ,[currency]
      ,[vendor_id]
      ,[item_id]
      ,[item_type]
      ,[item_accounting_method]
      ,[item_cost_code_id]
      ,[item_line_item_id]
      , REPLACE(REPLACE([item_description_of_work], CHAR(13), ' '), CHAR(10), ' ')  [item_description_of_work]
      ,[item_net_amount]
      ,[item_gross_amount]
      ,[item_wbs_code_id]
      ,[item_wbs_code_flat_code]
      , REPLACE(REPLACE([item_wbs_code_description], CHAR(13), ' '), CHAR(10), ' ')  [item_wbs_code_description]
      ,[item_wbs_code_segment_items_id]
      ,[item_wbs_code_segment_items_code]
      ,[item_wbs_code_segment_items_name]
      ,[item_wbs_code_segment_items_path_ids]
      ,[item_wbs_code_segment_items_path_codes]
      ,[item_wbs_code_segment_items_segment_type]
      ,[item_wbs_code_segment_items_segment_id]
      ,[item_scheduled_value]
      ,[item_work_completed_from_previous_application]
      ,[item_work_completed_this_period]
      ,[item_materials_presently_stored]
      ,[item_materials_presently_stored_from_previous_progress]
      ,[item_total_completed_and_stored_to_date]
      ,[item_total_completed_and_stored_to_date_percent]
      ,[item_total_completed_and_stored_to_date_from_previous]
      ,[item_work_completed_retainage_from_previous_application]
      ,[item_work_completed_retainage_retained_this_period]
      ,[item_work_completed_retainage_percent_this_period]
      ,[item_materials_stored_retainage_currently_retained]
      ,[item_materials_stored_retainage_percent_this_period]
      ,[item_materials_stored_retainage_new_materials]
      ,[item_work_completed_retainage_released_this_period]
      ,[item_materials_stored_retainage_released_this_period]
      ,[item_scheduled_quantity]
      ,[item_scheduled_unit_price]
      ,[item_work_completed_this_period_quantity]
      ,[item_work_completed_from_previous_application_quantity]
	  , REPLACE(REPLACE([item_comment], CHAR(13), ' '), CHAR(10), ' ') [item_comment]
      ,[item_status]
      ,[item_position]
      ,[item_line_number]
      ,[item_ssr_manual_override]
      ,[item_subcontractor_claimed_amount]
      ,[summary_text_project_name]
      ,[summary_text_project_number]
      ,[summary_text_to_general_contractor]
      ,[summary_text_requisition_period_start]
      ,[summary_text_requisition_period_end]
      ,[summary_text_subcontractor_name]
      ,[summary_text_subcontractor_street]
      ,[summary_text_subcontractor_city]
      ,[summary_text_subcontractor_state_code]
      ,[summary_text_subcontractor_zip]
      ,[summary_text_subcontractor_country_code]
      ,[summary_text_application_number]
      ,[summary_text_contract_for]
      ,[summary_text_contract_date]
      ,[custom_field_562949953947351]
      ,[total_claimed_amount]
      ,[item_flag]
  FROM [STG].[PROCORE].[requisitions]
 

GO
/****** Object:  Table [DS].[collab_cache_ad_users]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_cache_ad_users](
	[id] [nvarchar](2000) NULL,
	[first_name] [nvarchar](2000) NULL,
	[last_name] [nvarchar](2000) NULL,
	[mail] [nvarchar](2000) NULL,
	[display_name] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[mobile_phone] [nvarchar](2000) NULL,
	[azure_directory_id] [nvarchar](2000) NULL,
	[job_title] [nvarchar](2000) NULL,
	[department] [nvarchar](2000) NULL,
	[is_frozen] [nvarchar](2000) NULL,
	[is_deleted] [nvarchar](2000) NULL,
	[is_admin] [nvarchar](2000) NULL,
	[is_external] [nvarchar](2000) NULL,
	[is_dpe] [nvarchar](2000) NULL,
	[specific_role] [nvarchar](2000) NULL,
	[id_program_sector] [nvarchar](2000) NULL,
	[user_bu] [nvarchar](2000) NULL,
	[is_linked_to_all_companies] [nvarchar](2000) NULL,
	[external_user_role] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_collab_cach_users]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [DS].[v_collab_cach_users]
AS SELECT DISTINCT cau.id AS cache_ad_user_id,
    cau.first_name AS user_first_name,
    cau.last_name AS user_last_name,
    cau.mail AS user_mail,
    cau.display_name AS user_display_name,
    cau.is_frozen AS user_frozen,
    cau.is_deleted AS user_deleted,
    cau.mobile_phone AS user_phone,
    cau.azure_directory_id,
    cau.creation_date user_creation_date,
	N'Collab' SourceSystem
   FROM ds.collab_cache_ad_users cau;


GO
/****** Object:  Table [LogBoomi].[ErrorTrack]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[ErrorTrack](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[KPI] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[unique_key] [nvarchar](2000) NULL,
	[error_code] [nvarchar](2000) NULL,
	[error_message] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[Record_ID] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[HSE_Monitoring_History]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[HSE_Monitoring_History](
	[BatchID] [int] NULL,
	[BatchDate] [date] NULL,
	[DWH_Table] [nvarchar](max) NULL,
	[month] [int] NULL,
	[year] [int] NULL,
	[ProjectID] [int] NULL,
	[rankNum] [nvarchar](max) NULL,
	[OriginalData] [int] NULL,
	[InsertData] [int] NULL,
	[UpdateData] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[QA_Monitoring_History]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[QA_Monitoring_History](
	[BatchID] [int] NULL,
	[BatchDate] [date] NULL,
	[DWH_Table] [nvarchar](13) NOT NULL,
	[month] [nvarchar](max) NULL,
	[year] [nvarchar](max) NULL,
	[qa_source_id] [nvarchar](max) NULL,
	[ProjectID] [nvarchar](max) NULL,
	[Id_passgate] [nvarchar](max) NULL,
	[Id_Enum] [nvarchar](max) NULL,
	[OriginalData] [int] NULL,
	[InsertData] [int] NULL,
	[UpdateData] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[Timesheet_Monitoring_History]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[Timesheet_Monitoring_History](
	[BatchID] [int] NULL,
	[BatchDate] [date] NULL,
	[DWH_Table] [nvarchar](14) NOT NULL,
	[ProjectID] [int] NULL,
	[MailCacheAdUser] [nvarchar](2000) NULL,
	[TaskName] [nvarchar](100) NULL,
	[ActivityDate] [date] NULL,
	[isbillable] [varchar](5) NULL,
	[Duration] [numeric](38, 2) NULL,
	[OriginalData] [int] NULL,
	[InsertData] [int] NULL,
	[UpdateData] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[Verano_Monitoring_History]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[Verano_Monitoring_History](
	[BatchID] [int] NULL,
	[BatchDate] [date] NULL,
	[DWHViewName] [nvarchar](12) NULL,
	[ReportingYear] [int] NULL,
	[ReportingMonth] [int] NULL,
	[isPostCutoff] [int] NULL,
	[TimePeriodYear] [int] NULL,
	[TimePeriodMonth] [int] NULL,
	[project] [int] NULL,
	[workorderid] [int] NULL,
	[id_cost_indicator] [nvarchar](4) NULL,
	[id_cost_discipline] [nvarchar](4) NULL,
	[OriginalData] [int] NULL,
	[InsertData] [int] NULL,
	[UpdateData] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [LogBoomi].[v_Error_Monitoring]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [LogBoomi].[v_Error_Monitoring] As
 
--VARANO
 
select 'Verano' [system] ,DWH_Table, BatchDate , error_code, count (*) as [Count]
from (
	select VER_HIS.*, ET.KPI ,ET.error_code  
		from (
		select	 vhis.DWHViewName as DWH_Table,
				cast(vhis.DWHViewName as nvarchar(max)) + '||' +
				cast( vhis.ReportingYear as nvarchar(max)) + '||' +
				cast( vhis.ReportingMonth as nvarchar(max)) + '||' +
				cast( vhis.isPostCutoff as nvarchar(max)) + '||' +
				cast( vhis.TimePeriodYear as nvarchar(max)) + '||' +
				cast( vhis.TimePeriodMonth as nvarchar(max)) + '||' +
				cast( vhis.project as nvarchar(max)) + '||' +
				cast( vhis.workorderid as nvarchar(max))  + '||' +
				CAST( vhis.id_cost_indicator AS NVARCHAR(50)) + '||' +
		        CAST( vhis.id_cost_discipline AS NVARCHAR(50)) + '||' REC_ID , OriginalData, InsertData , UpdateData, BatchDate
		from stg.LogBoomi.Verano_Monitoring_History vhis ) VER_HIS
	left join stg.LogBoomi.ErrorTrack ET on VER_HIS.REC_ID = ET.Record_ID  ) FC
group by DWH_Table, BatchDate, error_code
 
 
UNION
 
--QA
 
select 'QA' [system], DWH_Table, BatchDate , error_code, count (*) as [Count]
from (
	select QA_HIS.*, ET.KPI ,ET.error_code  
	from (
		select DWH_Table,
			CAST([DWH_Table] as nvarchar(max))+'||'+
			CAST([month] as nvarchar(max)) +'||'+
			CAST([year] as nvarchar(max)) +'||'+
			CAST([qa_source_id] as nvarchar(max)) +'||'+
			CAST([ProjectID] as nvarchar(max)) +'||'+
			CAST([Id_passgate] as nvarchar(max)) +'||'+
			CAST([Id_Enum] as nvarchar(max)) +'||' REC_ID , OriginalData, InsertData , UpdateData ,  BatchDate
		from stg.LogBoomi.QA_Monitoring_History Qhis ) QA_HIS
	left join stg.LogBoomi.ErrorTrack ET on QA_HIS.REC_ID = ET.Record_ID
	) FC
group by DWH_Table, BatchDate, error_code
 
 
UNION
 
--- HSE
 
select 'HSE' [system], DWH_Table, BatchDate , error_code, count (*) as [Count]
from (
	select HSE_HIS.*, ET.KPI ,ET.error_code  
	from (
		select
				[DWH_Table],
				CAST([DWH_Table] AS NVARCHAR(50)) + '||' +
		        CAST([month] AS NVARCHAR(50)) + '||' +
		        CAST([year] AS NVARCHAR(50)) + '||' +
		        CAST([ProjectID] AS NVARCHAR(50)) + '||' +
		        CAST([rankNum] AS NVARCHAR(50)) + '||' REC_ID , OriginalData, InsertData , UpdateData ,  BatchDate
		from
				stg.LogBoomi.HSE_Monitoring_History ) HSE_HIS
	left join stg.LogBoomi.ErrorTrack ET on HSE_HIS.REC_ID = ET.Record_ID
	) FC
group by DWH_Table, BatchDate, error_code
	
UNION
 
--TIMESHEET
 
select 'Timesheet' [system], DWH_Table, BatchDate , error_code, count (*) as [Count]
from (
	select TS_HIS.*, ET.KPI ,ET.error_code  
	from (
		select
			DWH_Table,
			CAST([DWH_Table] AS NVARCHAR(MAX))+'||'+
			CAST([ProjectID] AS NVARCHAR(MAX))+'||'+
			CAST([MailCacheAdUser] AS NVARCHAR(MAX))+'||'+
			CAST([TaskName] AS NVARCHAR(MAX))+'||'+
			CAST([ActivityDate] AS NVARCHAR(MAX))+'||'+
			CAST([isbillable] AS NVARCHAR(MAX))+'||'+
			CAST([Duration] AS NVARCHAR(MAX))+'||' REC_ID , OriginalData, InsertData , UpdateData ,  BatchDate
		from stg.LogBoomi.Timesheet_Monitoring_History ) TS_HIS
	left join stg.LogBoomi.ErrorTrack ET on TS_HIS.REC_ID = ET.Record_ID
	) FC
group by DWH_Table, BatchDate, error_code
 
 
	;
 
GO
/****** Object:  Table [P6].[PROJECT]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[PROJECT](
	[objectid] [int] NULL,
	[id] [varchar](40) NULL,
	[fiscalyearstartmonth] [int] NULL,
	[resourcescaneditasgnmtpctcmp] [varchar](1) NULL,
	[resourcescanselfassigntoacts] [varchar](1) NULL,
	[primaryrescanmarkactsascmp] [varchar](1) NULL,
	[resourcecanassigntosameact] [varchar](1) NULL,
	[checkoutstatus] [varchar](1) NULL,
	[activitypctcmpbasedonsteps] [varchar](1) NULL,
	[costquantityrecalculateflag] [varchar](1) NULL,
	[containssummarydataonly] [varchar](1) NULL,
	[enablesummarization] [varchar](1) NULL,
	[wbscodeseparator] [varchar](2) NULL,
	[activitydefaultpctcmptype] [varchar](10) NULL,
	[activitydefcostacctobjectid] [int] NULL,
	[activitydefcalendarobjectid] [int] NULL,
	[currentbaselineprojectobjectid] [int] NULL,
	[activityidsuffix] [int] NULL,
	[activityidincrement] [int] NULL,
	[levelingpriority] [int] NULL,
	[summarizetowbslevel] [int] NULL,
	[strategicpriority] [int] NULL,
	[criticalactivityfloatlimit] [numeric](10, 2) NULL,
	[activitydefaultpriceperunit] [numeric](21, 8) NULL,
	[plannedstartdate] [datetime] NULL,
	[mustfinishbydate] [datetime] NULL,
	[scheduledfinishdate] [datetime] NULL,
	[dateadded] [datetime] NULL,
	[summarizeddatadate] [datetime] NULL,
	[lastsummarizeddate] [datetime] NULL,
	[projectforecaststartdate] [datetime] NULL,
	[activitydefaultdurationtype] [varchar](27) NULL,
	[activityidprefix] [varchar](20) NULL,
	[defaultpricetimeunits] [varchar](32) NULL,
	[addedby] [varchar](255) NULL,
	[websiterootdirectory] [varchar](120) NULL,
	[websiteurl] [varchar](200) NULL,
	[assignmentdefaultratetype] [varchar](14) NULL,
	[linkactualtoactualthisperiod] [varchar](1) NULL,
	[activitydefaultactivitytype] [varchar](18) NULL,
	[linkpercentcompletewithactual] [varchar](1) NULL,
	[addactualtoremaining] [varchar](1) NULL,
	[criticalactivitypathtype] [varchar](14) NULL,
	[activityidbasedonselactivity] [varchar](1) NULL,
	[assignmentdefaultdrivingflag] [varchar](1) NULL,
	[linkplannedandatcompletionflag] [varchar](1) NULL,
	[resetplannedtoremainingflag] [varchar](1) NULL,
	[allownegativeactualunitsflag] [varchar](1) NULL,
	[ownerresourceobjectid] [int] NULL,
	[checkoutdate] [datetime] NULL,
	[checkoutuserobjectid] [int] NULL,
	[lastfinancialperiodobjectid] [int] NULL,
	[useprojectblforearnedvalue] [varchar](1) NULL,
	[annualdiscountrate] [numeric](28, 10) NULL,
	[anticipatedfinishdate] [datetime] NULL,
	[anticipatedstartdate] [datetime] NULL,
	[containssummarydata] [varchar](1) NULL,
	[currentbudget] [numeric](28, 10) NULL,
	[currentvariance] [numeric](28, 10) NULL,
	[datadate] [datetime] NULL,
	[discountapplicationperiod] [varchar](24) NULL,
	[distributedcurrentbudget] [numeric](28, 10) NULL,
	[earnedvaluecomputetype] [varchar](255) NULL,
	[earnedvalueetccomputetype] [varchar](255) NULL,
	[earnedvalueetcuservalue] [numeric](28, 10) NULL,
	[earnedvalueuserpercent] [numeric](28, 10) NULL,
	[finishdate] [datetime] NULL,
	[forecastfinishdate] [datetime] NULL,
	[forecaststartdate] [datetime] NULL,
	[independentetclaborunits] [numeric](28, 10) NULL,
	[independentetctotalcost] [numeric](28, 10) NULL,
	[name] [varchar](255) NULL,
	[obsname] [varchar](255) NULL,
	[obsobjectid] [int] NULL,
	[originalbudget] [numeric](28, 10) NULL,
	[overallprojectscore] [numeric](28, 10) NULL,
	[parentepsobjectid] [int] NULL,
	[proposedbudget] [numeric](28, 10) NULL,
	[risklevel] [varchar](24) NULL,
	[riskscore] [int] NULL,
	[riskexposure] [numeric](28, 10) NULL,
	[startdate] [datetime] NULL,
	[status] [varchar](24) NULL,
	[originalprojectobjectid] [int] NULL,
	[riskscorematrixobjectid] [int] NULL,
	[sumplannedstartdate] [datetime] NULL,
	[sumplannedfinishdate] [datetime] NULL,
	[sumplannedduration] [numeric](28, 10) NULL,
	[sumplannedlaborunits] [numeric](28, 10) NULL,
	[sumplannednonlaborunits] [numeric](28, 10) NULL,
	[sumplannedexpensecost] [numeric](28, 10) NULL,
	[sumplannedlaborcost] [numeric](28, 10) NULL,
	[sumplannedmaterialcost] [numeric](28, 10) NULL,
	[sumplannednonlaborcost] [numeric](28, 10) NULL,
	[sumplannedtotalcost] [numeric](28, 10) NULL,
	[sumaccountingvarbylaborunits] [numeric](28, 10) NULL,
	[sumaccountingvariancebycost] [numeric](28, 10) NULL,
	[sumactthisperiodmaterialcost] [numeric](28, 10) NULL,
	[sumactthisperiodnonlaborcost] [numeric](28, 10) NULL,
	[sumactthisperiodnonlaborunits] [numeric](28, 10) NULL,
	[sumactualthisperiodlaborcost] [numeric](28, 10) NULL,
	[sumactualthisperiodlaborunits] [numeric](28, 10) NULL,
	[sumatcompletionmaterialcost] [numeric](28, 10) NULL,
	[sumatcompletionnonlaborcost] [numeric](28, 10) NULL,
	[sumatcompletionnonlaborunits] [numeric](28, 10) NULL,
	[sumatcompletiontotalcostvar] [numeric](28, 10) NULL,
	[sumbaselinecompactivitycount] [numeric](28, 10) NULL,
	[sumbaselinenotstartedactcnt] [numeric](28, 10) NULL,
	[sumblinprogressactivitycount] [numeric](28, 10) NULL,
	[sumbudgetatcmpbylaborunits] [numeric](28, 10) NULL,
	[sumbudgetatcompletionbycost] [numeric](28, 10) NULL,
	[sumcostperfindexbycost] [numeric](28, 10) NULL,
	[sumcostperfindexbylaborunits] [numeric](28, 10) NULL,
	[sumcostvariancebylaborunits] [numeric](28, 10) NULL,
	[sumcostvarindexbylaborunits] [numeric](28, 10) NULL,
	[sumdurationpercentofplanned] [numeric](28, 10) NULL,
	[sumeacbycost] [numeric](28, 10) NULL,
	[sumeacbylaborunits] [numeric](28, 10) NULL,
	[sumeachighpctbylaborunits] [numeric](28, 10) NULL,
	[sumeaclowpctbylaborunits] [numeric](28, 10) NULL,
	[sumetcbycost] [numeric](28, 10) NULL,
	[sumetcbylaborunits] [numeric](28, 10) NULL,
	[sumexpensecostpctcomplete] [numeric](28, 10) NULL,
	[sumlaborcostpercentcomplete] [numeric](28, 10) NULL,
	[sumlaborunitspercentcomplete] [numeric](28, 10) NULL,
	[sumactivitycount] [numeric](28, 10) NULL,
	[sumactualduration] [numeric](28, 10) NULL,
	[sumactualexpensecost] [numeric](28, 10) NULL,
	[sumactualfinishdate] [datetime] NULL,
	[summaxactualfinishdate] [datetime] NULL,
	[summaxrestartdate] [datetime] NULL,
	[sumactuallaborcost] [numeric](28, 10) NULL,
	[sumactuallaborunits] [numeric](28, 10) NULL,
	[sumactualmaterialcost] [numeric](28, 10) NULL,
	[sumactualnonlaborcost] [numeric](28, 10) NULL,
	[sumactualnonlaborunits] [numeric](28, 10) NULL,
	[sumactualstartdate] [datetime] NULL,
	[sumactualthisperiodcost] [numeric](28, 10) NULL,
	[sumactualtotalcost] [numeric](28, 10) NULL,
	[sumactualvaluebycost] [numeric](28, 10) NULL,
	[sumactualvaluebylaborunits] [numeric](28, 10) NULL,
	[sumatcompletionduration] [numeric](28, 10) NULL,
	[sumatcompletionexpensecost] [numeric](28, 10) NULL,
	[sumatcompletionlaborcost] [numeric](28, 10) NULL,
	[sumatcompletionlaborunits] [numeric](28, 10) NULL,
	[sumatcompletiontotalcost] [numeric](28, 10) NULL,
	[sumbaselineduration] [numeric](28, 10) NULL,
	[sumbaselineexpensecost] [numeric](28, 10) NULL,
	[sumbaselinefinishdate] [datetime] NULL,
	[sumbaselinelaborcost] [numeric](28, 10) NULL,
	[sumbaselinelaborunits] [numeric](28, 10) NULL,
	[sumbaselinematerialcost] [numeric](28, 10) NULL,
	[sumbaselinenonlaborcost] [numeric](28, 10) NULL,
	[sumbaselinenonlaborunits] [numeric](28, 10) NULL,
	[sumbaselinestartdate] [datetime] NULL,
	[sumbaselinetotalcost] [numeric](28, 10) NULL,
	[sumcompletedactivitycount] [numeric](28, 10) NULL,
	[sumcostpercentcomplete] [numeric](28, 10) NULL,
	[sumcostpercentofplanned] [numeric](28, 10) NULL,
	[sumcostvariancebycost] [numeric](28, 10) NULL,
	[sumcostvarianceindex] [numeric](28, 10) NULL,
	[sumcostvarianceindexbycost] [numeric](28, 10) NULL,
	[sumdurationpercentcomplete] [numeric](28, 10) NULL,
	[sumdurationvariance] [numeric](28, 10) NULL,
	[sumearnedvaluebycost] [numeric](28, 10) NULL,
	[sumearnedvaluebylaborunits] [numeric](28, 10) NULL,
	[sumexpensecostvariance] [numeric](28, 10) NULL,
	[sumfinishdatevariance] [numeric](28, 10) NULL,
	[suminprogressactivitycount] [numeric](28, 10) NULL,
	[sumlaborcostvariance] [numeric](28, 10) NULL,
	[sumlaborunitsvariance] [numeric](28, 10) NULL,
	[summaterialcostvariance] [numeric](28, 10) NULL,
	[sumnonlaborcostvariance] [numeric](28, 10) NULL,
	[sumnonlaborunitsvariance] [numeric](28, 10) NULL,
	[sumnotstartedactivitycount] [numeric](28, 10) NULL,
	[sumplannedvaluebycost] [numeric](28, 10) NULL,
	[sumprogressfinishdate] [datetime] NULL,
	[sumremainingduration] [numeric](28, 10) NULL,
	[sumremainingexpensecost] [numeric](28, 10) NULL,
	[sumremainingfinishdate] [datetime] NULL,
	[sumremaininglaborcost] [numeric](28, 10) NULL,
	[sumremaininglaborunits] [numeric](28, 10) NULL,
	[sumremainingmaterialcost] [numeric](28, 10) NULL,
	[sumremainingnonlaborcost] [numeric](28, 10) NULL,
	[sumremainingnonlaborunits] [numeric](28, 10) NULL,
	[sumremainingstartdate] [datetime] NULL,
	[sumremainingtotalcost] [numeric](28, 10) NULL,
	[sumschedulepercentcomplete] [numeric](28, 10) NULL,
	[sumperformancepercentcomplete] [numeric](28, 10) NULL,
	[sumschedulevariancebycost] [numeric](28, 10) NULL,
	[sumschedulevarianceindex] [numeric](28, 10) NULL,
	[sumstartdatevariance] [numeric](28, 10) NULL,
	[sumtotalcostvariance] [numeric](28, 10) NULL,
	[sumtotalfloat] [numeric](28, 10) NULL,
	[sumunitspercentcomplete] [numeric](28, 10) NULL,
	[summaterialcostpctcomplete] [numeric](28, 10) NULL,
	[sumnonlaborcostpctcomplete] [numeric](28, 10) NULL,
	[sumnonlaborunitspctcomplete] [numeric](28, 10) NULL,
	[sumperfpctcmpbylaborunits] [numeric](28, 10) NULL,
	[sumplannedvaluebylaborunits] [numeric](28, 10) NULL,
	[sumschdpctcmpbylaborunits] [numeric](28, 10) NULL,
	[sumschdperfindexbylaborunits] [numeric](28, 10) NULL,
	[sumschdvariancebylaborunits] [numeric](28, 10) NULL,
	[sumschdvarianceindexbycost] [numeric](28, 10) NULL,
	[sumschdvarindexbylaborunits] [numeric](28, 10) NULL,
	[sumscheduleperfindexbycost] [numeric](28, 10) NULL,
	[sumtocompleteperfindexbycost] [numeric](28, 10) NULL,
	[sumvaratcmpbylaborunits] [numeric](28, 10) NULL,
	[sumearlystartdate] [datetime] NULL,
	[sumearlyenddate] [datetime] NULL,
	[sumlatestartdate] [datetime] NULL,
	[sumlateenddate] [datetime] NULL,
	[summaxcalendarid] [numeric](28, 10) NULL,
	[summincalendarid] [numeric](28, 10) NULL,
	[totalbenefitplan] [numeric](28, 10) NULL,
	[totalbenefitplantally] [numeric](28, 10) NULL,
	[totalfunding] [numeric](28, 10) NULL,
	[totalspendingplan] [numeric](28, 10) NULL,
	[totalspendingplantally] [numeric](28, 10) NULL,
	[unallocatedbudget] [numeric](28, 10) NULL,
	[NetPresentValue] [numeric](23, 6) NULL,
	[ReturnOnInvestment] [numeric](23, 6) NULL,
	[PaybackPeriod] [int] NULL,
	[undistributedcurrentvariance] [numeric](28, 10) NULL,
	[projectdescription] [varchar](500) NULL,
	[baselinetypeobjectid] [int] NULL,
	[enablepublication] [varchar](1) NULL,
	[nextpublicationdate] [datetime] NULL,
	[lastpublishedon] [datetime] NULL,
	[publicationpriority] [numeric](3, 0) NULL,
	[locationobjectid] [int] NULL,
	[historyinterval] [varchar](25) NULL,
	[historylevel] [varchar](10) NULL,
	[locationname] [varchar](255) NULL,
	[allowstatusreview] [varchar](1) NULL,
	[lastupdateuser] [varchar](255) NULL,
	[lastupdatedate] [datetime] NULL,
	[createuser] [varchar](255) NULL,
	[etlinterval] [int] NULL,
	[etlhour] [int] NULL,
	[createdate] [datetime] NULL,
	[lastupdatedatex] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_project]    Script Date: 02/08/2024 08:01:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_project](
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[number] [nvarchar](2000) NULL,
	[daily_working_hours] [nvarchar](2000) NULL,
	[picture] [nvarchar](2000) NULL,
	[start_date] [nvarchar](2000) NULL,
	[contractual_end_date] [nvarchar](2000) NULL,
	[budget] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[forecast_date] [nvarchar](2000) NULL,
	[engineering_start_date] [nvarchar](2000) NULL,
	[engineering_end_date] [nvarchar](2000) NULL,
	[procurement_start_date] [nvarchar](2000) NULL,
	[procurement_end_date] [nvarchar](2000) NULL,
	[construction_start_date] [nvarchar](2000) NULL,
	[construction_end_date] [nvarchar](2000) NULL,
	[commissioning_start_date] [nvarchar](2000) NULL,
	[commissioning_end_date] [nvarchar](2000) NULL,
	[longitude] [nvarchar](2000) NULL,
	[latitude] [nvarchar](2000) NULL,
	[kpi_frequency] [nvarchar](2000) NULL,
	[target] [nvarchar](2000) NULL,
	[home_office_location] [nvarchar](2000) NULL,
	[jv_partner] [nvarchar](2000) NULL,
	[risks_determining_risk_classification] [nvarchar](2000) NULL,
	[workshare_split] [nvarchar](2000) NULL,
	[sponsor_name] [nvarchar](2000) NULL,
	[site_location] [nvarchar](2000) NULL,
	[jpass_notification_address] [nvarchar](2000) NULL,
	[progress_value] [nvarchar](2000) NULL,
	[ops_start_date] [nvarchar](2000) NULL,
	[ops_end_date] [nvarchar](2000) NULL,
	[mes_start_date] [nvarchar](2000) NULL,
	[mes_end_date] [nvarchar](2000) NULL,
	[mee_start_date] [nvarchar](2000) NULL,
	[mee_end_date] [nvarchar](2000) NULL,
	[tar_start_date] [nvarchar](2000) NULL,
	[tar_end_date] [nvarchar](2000) NULL,
	[at_risk] [nvarchar](2000) NULL,
	[maximum_date] [nvarchar](2000) NULL,
	[maximum_amount] [nvarchar](2000) NULL,
	[signed_authorization] [nvarchar](2000) NULL,
	[program] [nvarchar](2000) NULL,
	[sector] [nvarchar](2000) NULL,
	[state] [nvarchar](2000) NULL,
	[risk_classification] [nvarchar](2000) NULL,
	[scope] [nvarchar](2000) NULL,
	[type] [nvarchar](2000) NULL,
	[project_creation_status] [nvarchar](2000) NULL,
	[commercial_contract] [nvarchar](2000) NULL,
	[type_contract] [nvarchar](2000) NULL,
	[bu] [nvarchar](2000) NULL,
	[client] [nvarchar](2000) NULL,
	[phase] [nvarchar](2000) NULL,
	[work_orders] [nvarchar](2000) NULL,
	[with_work_location] [nvarchar](2000) NULL,
	[close_date] [nvarchar](2000) NULL,
	[on_hold_date] [nvarchar](2000) NULL,
	[platforms] [nvarchar](2000) NULL,
	[project_pm] [nvarchar](2000) NULL,
	[project_dpe] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [PROCORE].[v_P6ProjFinishDate]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [PROCORE].[v_P6ProjFinishDate] as
with proj_map as (
select 'Q1255021' as CollabMap,'Q1255341-AC' P6Map union 
select 'Q2002011' as CollabMap,'Q2002011-AC' P6Map union 
select 'Q2120041' as CollabMap,'Q2120041-AC' P6Map union 
select 'Q2127221' as CollabMap,'Q2127221-AC' P6Map union 
select 'Q2210211' as CollabMap,'Q2210211-AC' P6Map union 
select 'Q2270041' as CollabMap,'Q2270041-AC' P6Map union 
select 'Q3125031' as CollabMap,'Q3125031-AC-11' P6Map union 
select 'Q3200241' as CollabMap,'Q3200241-AC' P6Map union 
select 'Q3204021' as CollabMap,'Q3204021-AC' P6Map union 
select 'Q3213031' as CollabMap,'Q3213031-AC' P6Map union 
select 'Q3213231' as CollabMap,'Q3213231-AC' P6Map union 
select 'Q3225011' as CollabMap,'Q3225051-AC' P6Map union 
select 'Q3303021' as CollabMap,'Q3303021-AC' P6Map union 
select 'Q3394011' as CollabMap,'Q3394011-AC' P6Map union 
select 'Q3621311' as CollabMap,'Q3621311-AC' P6Map union 
select 'Q3621521' as CollabMap,'Q3621521 -AC' P6Map union 
select 'Q3622021' as CollabMap,'Q3622021-AC' P6Map union 
select 'Q3702745' as CollabMap,'Q3702745-AC' P6Map union 
select 'Q3702743' as CollabMap,'Q3702743-AC' P6Map union 
select 'Q3709131' as CollabMap,'Q3709131-AC' P6Map union 
select 'Q3709331' as CollabMap,'Q3709331-AC' P6Map union 
select 'Q5463011' as CollabMap,'Q5463011-AC' P6Map union 
select 'Q6015011' as CollabMap,'Q6015011-AC' P6Map union 
select 'Q6605031' as CollabMap,'Q6605031-AC' P6Map union 
select 'Q6638021' as CollabMap,'Q6638021-AC2' P6Map union 
select 'Q8008141' as CollabMap,'Q8008141-AC' P6Map union 
select 'Q7002021' as CollabMap,'Q7002021-AC' P6Map union 
select 'Q8204011' as CollabMap,'Q8204011-AC' P6Map union 
select 'Q8205011' as CollabMap,'Q8205011-AC' P6Map union 
select 'Q8206011' as CollabMap,'Q8206011-AC' P6Map union 
select 'Q8215011' as CollabMap,'Q8215011-AC' P6Map union 
select 'Q8217011' as CollabMap,'Q8217011-AC' P6Map union 
select 'Q8218011' as CollabMap,'Q8218011-AC' P6Map union 
select 'Q8219011' as CollabMap,'Q8219011-AC' P6Map union 
select 'Q8225011' as CollabMap,'Q8225011-AC' P6Map union 
select 'Q8228011' as CollabMap,'Q8228011-AC' P6Map union 
select 'QB192001' as CollabMap,'QB192001-AC' P6Map union 
select 'QB210201' as CollabMap,'QB198001-AC' P6Map union 
select 'QB210301' as CollabMap,'QB210301- AC' P6Map union 
select 'QB223201' as CollabMap,'QB223201-AC' P6Map union 
select 'QB230101' as CollabMap,'QB230101-AC' P6Map union 
select 'QB230201' as CollabMap,'QB230201- AC' P6Map union 
select 'QB230301' as CollabMap,'QB230301- AC' P6Map union 
select 'QB230401' as CollabMap,'QB230401- AC' P6Map union 
select 'QB230601' as CollabMap,'QB230601-AC' P6Map union 
select 'QB231301' as CollabMap,'QB231301-AC' P6Map union 
select 'QB232001' as CollabMap,'QB232001-AC' P6Map union 
select 'QB232101' as CollabMap,'QB232101-AC' P6Map union 
select 'QB232301' as CollabMap,'QB232301-AC' P6Map union 
select 'QB232601' as CollabMap,'QB232601-AC' P6Map union 
select 'QB240101' as CollabMap,'QB240101- AC' P6Map union 
select 'QBB17011' as CollabMap,'QBB17011-AC' P6Map union 
select 'QE225501' as CollabMap,'QE225501-AC' P6Map union 
select 'QE225901' as CollabMap,'QE225901-AC' P6Map union 
select 'QE226001' as CollabMap,'QE226001-AC' P6Map union 
select 'QE226101' as CollabMap,'QE226101-AC' P6Map union 
select 'QE231301' as CollabMap,'QE231301- AC1' P6Map union 
select 'QT230201' as CollabMap,'QT230201-AC' P6Map union 
select 'QW212401' as CollabMap,'QW212401-AC' P6Map union 
select 'QW223801' as CollabMap,'QW223801.2-AC' P6Map union 
select 'QW240101' as CollabMap,'QW240101' P6Map union 
select 'Q2118121' as CollabMap,'Q2118121-AC' P6Map union 
select 'Q3111051' as CollabMap,'Q3111051-AC' P6Map union 
select 'Q3126131' as CollabMap,'Q3126131-AC' P6Map union 
select 'Q3223011' as CollabMap,'QE226201_AC1' P6Map union 
select 'Q3304011' as CollabMap,'Q3304011-AC' P6Map union 
select 'Q3610051' as CollabMap,'Q361005PV' P6Map union 
select 'Q3613011' as CollabMap,'Q36130-AC' P6Map union 
select 'Q3622011' as CollabMap,'Q3622011-AC' P6Map union 
select 'Q3622211' as CollabMap,'Q3622211-BL' P6Map union 
select 'Q3622311' as CollabMap,'Q3622311-AC' P6Map union 
select 'Q3702744' as CollabMap,'Q3702744-AC' P6Map union 
select 'Q3709231' as CollabMap,'Q3709231-AC' P6Map union 
select 'Q8013011.C' as CollabMap,'Q8213011-AC' P6Map union 
select 'Q8013033.C' as CollabMap,'QE225601-AC' P6Map union 
select 'QE230601' as CollabMap,'QE230601-BL' P6Map union 
select 'QE230501' as CollabMap,'QE230501-BL' P6Map union 
select 'QE243001' as CollabMap,'QE243001-BL' P6Map union 
select 'QW225201' as CollabMap,'QW225201-AC' P6Map 
)
select  [objectid]
      ,p.[id] P6ProjectNumber
	  ,[forecastfinishdate]
	  ,[finishdate]
      ,cp.id CollabID
  FROM [STG].[P6].[PROJECT] p
  inner join proj_map pm on pm.P6Map = p.id
  inner JOIN stg.DS.COLLAB_project cp on cp.number = pm.CollabMap
GO
/****** Object:  Table [P6].[WBSHIERARCHY]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[WBSHIERARCHY](
	[parentobjectid] [varchar](255) NULL,
	[parentprojectid] [varchar](255) NULL,
	[parentname] [varchar](255) NULL,
	[parentid] [varchar](255) NULL,
	[childobjectid] [varchar](255) NULL,
	[childprojectid] [varchar](255) NULL,
	[childname] [varchar](255) NULL,
	[childid] [varchar](255) NULL,
	[fullpathname] [varchar](5000) NULL,
	[parentlevelsbelowroot] [varchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [P6].[v_WBSHIERARCHY_Split]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- P6.v_WBSHIERARCHY_Split source

-- P6.v_WBSHIERARCHY_Split source

-- P6.v_WBSHIERARCHY_Split source

CREATE view [P6].[v_WBSHIERARCHY_Split] as

With ParentLevel as (
SELECT [parentobjectid]
      ,[parentname]
      ,[parentid]
      ,[childobjectid]
      ,[childname]
      ,[childid]
      ,[fullpathname]
  FROM [STG].[P6].[WBSHIERARCHY]
where parentlevelsbelowroot=1
and parentid=childid
),Level1 as (
SELECT [parentobjectid] ParentLevelObjectId
      ,[parentid] ParentLevelId
      ,[childobjectid] ChildObjectLevel1
      ,[childname]
      ,[fullpathname]
  FROM [STG].[P6].[WBSHIERARCHY]
where parentlevelsbelowroot=1
and len(FullPathName) - len(replace(FullPathName, '.', '')) = 1
),Level2 as (
SELECT [parentobjectid] ChildObjectLevel1
      ,[childobjectid] ChildObjectLevel2
      ,[childname]
      ,[childid]
      ,[fullpathname]
  FROM [STG].[P6].[WBSHIERARCHY]
where parentlevelsbelowroot=2
and len(FullPathName) - len(replace(FullPathName, '.', '')) = 2
),
overall as ( select --ParentLevel.[parentobjectid],
ParentLevel.[fullpathname] fullpathnameL0,
ParentLevel.[childname] wbsNameL0,
--level1.ChildObjectLevel1,
level1.[fullpathname] fullpathnameL1,
level1.[childname] wbsNameL1,
--level2.ChildObjectLevel2,
level2.[fullpathname] fullpathnameL2,
level2.[childname] wbsNameL2--,
--level1.ChildObjectLevel1 ParentJoinColumn,
--level2.ChildObjectLevel2 JoinColumn
 from ParentLevel
 left join level1 on ParentLevel.[parentobjectid]=level1.ParentLevelObjectId
 left join Level2 on level1.ChildObjectLevel1=level2.ChildObjectLevel1
 union
 select distinct --ParentLevel.[parentobjectid],
ParentLevel.[fullpathname] fullpathnameL0,
ParentLevel.[childname] wbsNameL0,
--level1.ChildObjectLevel1,
level1.[fullpathname] fullpathnameL1,
level1.[childname] wbsNameL1,
--null ChildObjectLevel2,
null fullpathnameL2,
null wbsNameL2--,
--ParentLevel.[parentobjectid],
--level1.ChildObjectLevel1 JoinColumn
 from ParentLevel
 left join level1 on ParentLevel.[parentobjectid]=level1.ParentLevelObjectId
  union
 select distinct --ParentLevel.[parentobjectid],
ParentLevel.[fullpathname] fullpathnameL0,
ParentLevel.childname wbsNameL0,
--null ChildObjectLevel1,
null fullpathnameL1,
null wbsNameL1,
--null ChildObjectLevel2,
null fullpathnameL2,
null wbsNameL2--,
--null ParentJoinColumn,
--ParentLevel.[parentobjectid] JoinColumn
 from ParentLevel)
 select wbs, wbsname, immediate_wbs_parent, immediate_wbsname_parent from (
SELECT DISTINCT CASE
                  WHEN fullpathnameL2 IS NULL THEN fullpathnameL0
                  ELSE fullpathnameL1
                END
                immediate_wbs_parent,
                CASE
                  WHEN wbsnameL2 IS NULL THEN wbsnameL0
                  ELSE wbsnameL1
                END
                immediate_wbsname_parent,
                Isnull(fullpathnameL2, Isnull(fullpathnameL1, fullpathnameL0)) wbs,
                Isnull(wbsnameL2, Isnull(wbsnameL1, wbsnameL0)) wbsname
FROM   overall
union
select distinct fullpathnameL2 as immediate_wbs_parent, wbsNameL2 immediate_wbsname_parent, fullpathnameL2 as wbs, wbsNameL2 wbsname 
from overall
union
select distinct fullpathnameL1 as immediate_wbs_parent, wbsNameL1 immediate_wbsname_parent, fullpathnameL1 as wbs, wbsNameL1 wbsname 
from overall
union
select distinct fullpathnameL0 as immediate_wbs_parent, wbsNameL0 immediate_wbsname_parent, fullpathnameL0 as wbs, wbsNameL1 wbsname 
from overall
) z where z.wbs is not null;
GO
/****** Object:  Table [DS].[collab_enumeration]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_enumeration](
	[id] [nvarchar](2000) NULL,
	[type] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[label] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_kpi_frequency]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_kpi_frequency](
	[id] [nvarchar](2000) NULL,
	[human_capital_frequency] [nvarchar](2000) NULL,
	[change_management_frequency] [nvarchar](2000) NULL,
	[commissioning_progress_frequency] [nvarchar](2000) NULL,
	[scheduling_frequency] [nvarchar](2000) NULL,
	[engineering_frequency] [nvarchar](2000) NULL,
	[cost_frequency] [nvarchar](2000) NULL,
	[overall_frequency] [nvarchar](2000) NULL,
	[construction_frequency] [nvarchar](2000) NULL,
	[progress_mes_frequency] [nvarchar](2000) NULL,
	[progress_ops_frequency] [nvarchar](2000) NULL,
	[progress_mee_frequency] [nvarchar](2000) NULL,
	[progress_tar_frequency] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_collab_project]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  VIEW [DS].[v_collab_project]
AS SELECT p.id AS project_id,
    p.number AS project_number,
    p.name AS project_name,
    ps.label AS project_state,
    psi.name AS project_bu,
    p.sponsor AS project_program,
	cast(left(p.forecast_date,8) as date) project_fcst_date,
	cast(left(p.start_date,8) as date) as project_start_date,
	psss.label enum_type,
	pss.name project_sector,
	--pr.name project_sector,
	ee.label scheduling_frequency
   FROM ds.project_management_project p
     LEFT JOIN ds.project_management_enumeration ps ON ps.id = p.status_id
     LEFT JOIN ds.project_management_enumeration psss ON psss.id = p.project_size_id
     LEFT JOIN ds.project_management_sector pss ON pss.id = p.sector_id
     LEFT JOIN ds.project_management_business_unit psi ON psi.id = p.bu_id
	 left join stg.ds.COLLAB_kpi_frequency kp on kp.id = p.id
	 left join stg.ds.collab_enumeration ee on ee.id=kp.scheduling_frequency



GO
/****** Object:  Table [DS].[collab_project_contractor_work_dimension]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_project_contractor_work_dimension](
	[id] [nvarchar](250) NULL,
	[id_project] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[contractor] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_project_sub_contractor_work_dimension]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_project_sub_contractor_work_dimension](
	[id] [nvarchar](200) NULL,
	[id_project] [nvarchar](200) NULL,
	[creation_date] [nvarchar](200) NULL,
	[update_date] [nvarchar](200) NULL,
	[sub_contractor] [nvarchar](200) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_collab_project_work_dimension]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [DS].[v_collab_project_work_dimension]
AS select distinct [id_project]
      ,[contractor]
	  ,'Contractor' company_type
from ds.COLLAB_project_contractor_work_dimension
union
select distinct [id_project]
      ,[sub_contractor]
	  ,'Sub Contractor' company_type
from ds.collab_project_sub_contractor_work_dimension

GO
/****** Object:  Table [LogBoomi].[collab_enumeration]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[collab_enumeration](
	[id] [int] NOT NULL,
	[type] [nvarchar](max) NULL,
	[code] [nvarchar](max) NULL,
	[label] [nvarchar](max) NULL,
	[creation_date] [datetime2](7) NULL,
	[update_date] [datetime2](7) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[p6_schedule]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[p6_schedule](
	[id] [int] NOT NULL,
	[month] [int] NOT NULL,
	[year] [int] NOT NULL,
	[title] [nvarchar](max) NULL,
	[creation_date] [datetime] NOT NULL,
	[update_date] [datetime] NULL,
	[id_project] [int] NULL,
	[start_of_the_week] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[p6_schedule_level_activity]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[p6_schedule_level_activity](
	[id] [int] NOT NULL,
	[activity_id] [nvarchar](max) NULL,
	[collab_code] [nvarchar](max) NULL,
	[wbs_name] [nvarchar](max) NULL,
	[task_description] [nvarchar](max) NULL,
	[predecessor] [nvarchar](max) NULL,
	[bl_start_date] [datetime] NULL,
	[bl_finish_date] [datetime] NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[duration] [int] NULL,
	[status] [int] NULL,
	[progress] [numeric](12, 2) NULL,
	[creation_date] [datetime] NOT NULL,
	[update_date] [datetime] NULL,
	[id_schedule] [int] NULL,
	[total_float] [int] NULL,
	[remaining_duration] [int] NULL,
	[schedule_percentage_complete] [int] NULL,
	[resources] [nvarchar](max) NULL,
	[budget_labor_units] [int] NULL,
	[actual_labor_units] [int] NULL,
	[float_path] [int] NULL,
	[float_path_order] [nvarchar](max) NULL,
	[g_zero_two_steps] [nvarchar](max) NULL,
	[g_twelve_supplier_subs] [nvarchar](max) NULL,
	[g_sixteen_discipline] [nvarchar](max) NULL,
	[area] [nvarchar](max) NULL,
	[g_eighteen_warn_act_identifier] [nvarchar](max) NULL,
	[type] [int] NULL,
	[root_level] [nvarchar](max) NULL,
	[level] [nvarchar](max) NULL,
	[level_code] [nvarchar](max) NULL,
	[parent_level] [nvarchar](max) NULL,
	[at_complete_duration] [int] NULL,
	[level1task_description] [nvarchar](max) NULL,
	[wbs] [nvarchar](max) NULL,
	[activity_name] [nvarchar](max) NULL,
	[schedule_wbs] [int] NULL,
	[data_type] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[p6_schedule_wbs]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[p6_schedule_wbs](
	[id] [int] NOT NULL,
	[wbs_code] [nvarchar](max) NULL,
	[wbs_name] [nvarchar](max) NULL,
	[level] [nvarchar](max) NULL,
	[level_code] [nvarchar](max) NULL,
	[parent_level] [nvarchar](max) NULL,
	[id_schedule] [int] NULL,
	[creation_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vP62Collab1]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vP62Collab1](
	[schedule_key] [nvarchar](92) NULL,
	[month] [int] NULL,
	[year] [int] NULL,
	[firstDayOfWeek] [date] NULL,
	[jpassprojectId] [nvarchar](2000) NULL,
	[activityId] [nvarchar](250) NULL,
	[wbs] [nvarchar](250) NULL,
	[wbsName] [nvarchar](250) NULL,
	[activityName] [nvarchar](500) NULL,
	[blStartDate] [date] NULL,
	[blFinishDate] [date] NULL,
	[startDate] [date] NULL,
	[endDate] [date] NULL,
	[originalDuration] [numeric](17, 4) NULL,
	[remainingDuration] [numeric](17, 4) NULL,
	[atCompleteDuration] [numeric](17, 4) NULL,
	[schedulePercentageComplete] [numeric](17, 4) NULL,
	[resources] [varchar](255) NULL,
	[budgetLaborUnits] [numeric](17, 4) NULL,
	[actualLaborUnits] [numeric](17, 4) NULL,
	[floatPath] [numeric](17, 4) NULL,
	[floatPathOrder] [numeric](17, 4) NULL,
	[status_label] [nvarchar](250) NULL,
	[type_label] [nvarchar](250) NULL,
	[totalFloat] [numeric](17, 4) NULL,
	[gzeroTwoSteps] [nvarchar](250) NULL,
	[gtwelveSupplierSubs] [nvarchar](250) NULL,
	[gsixteenDiscipline] [nvarchar](250) NULL,
	[geighteenWarnActIdentifier] [nvarchar](250) NULL,
	[wbs_level] [int] NULL,
	[frequency] [nvarchar](100) NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vP62Collab2]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vP62Collab2](
	[JPassProjectID] [int] NULL,
	[ProjectNumber] [nvarchar](250) NULL,
	[ProjectName] [nvarchar](250) NULL,
	[P6StartDate] [date] NULL,
	[JpassStartDate] [date] NULL,
	[ContractualEndDate] [datetime] NULL,
	[P6ForecastDate] [date] NULL,
	[JpassForecastDate] [date] NULL,
	[EngineeringStartDate] [date] NULL,
	[EngineeringEndDate] [date] NULL,
	[ProcurementStartDate] [date] NULL,
	[ProcurementEndDate] [date] NULL,
	[ConstructionStartDate] [date] NULL,
	[ConstructionEndDate] [date] NULL,
	[CommissioningStartDate] [date] NULL,
	[CommissioningEndDate] [date] NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[project_details]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[project_details](
	[id] [int] NOT NULL,
	[engineering_start_date] [date] NULL,
	[engineering_end_date] [date] NULL,
	[procurement_start_date] [date] NULL,
	[procurement_end_date] [date] NULL,
	[construction_start_date] [date] NULL,
	[construction_end_date] [date] NULL,
	[commissioning_start_date] [date] NULL,
	[commissioning_end_date] [date] NULL,
	[ops_start_date] [date] NULL,
	[ops_end_date] [date] NULL,
	[mes_start_date] [date] NULL,
	[mes_end_date] [date] NULL,
	[mee_start_date] [date] NULL,
	[mee_end_date] [date] NULL,
	[tar_start_date] [date] NULL,
	[tar_end_date] [date] NULL,
	[project_id] [int] NULL,
	[description] [nvarchar](max) NULL,
	[summary] [nvarchar](max) NULL,
	[plot_plan] [nvarchar](max) NULL,
	[commercial_breakdown] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [LogBoomi].[v_P6_Monitoring]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- LogBoomi.v_P6_Monitoring source

-- LogBoomi.v_P6_Monitoring source

CREATE view [LogBoomi].[v_P6_Monitoring] as 




SELECT 
	CAST([DWH_Table] AS NVARCHAR(MAX))+'||'+
	CAST([month] AS NVARCHAR(MAX))+'||'+
	CAST([year] AS NVARCHAR(MAX))+'||'+
	CAST([jpassprojectId] AS NVARCHAR(MAX))+'||'+
	CAST([activityId] AS NVARCHAR(MAX))+'||'
	ID, *

from (

select 
    N'schedule/wbs/sla' AS Collab_Table,
    N'vP62Collab1' AS DWH_Table,
	dwh.[month], 
	dwh. [year],
	dwh.jpassprojectId,
	dwh.activityId,
	N'Insert' IntegrationType,
    N'No-KPI' AS KPI,
	N'-' value_DWH,
	N'-' value_Collab,
	'' reason
from
	STG.LogBoomi.vP62Collab1 dwh 
	left join (stg.logboomi.p6_schedule_level_activity sla 
	left join stg.LogBoomi.p6_schedule_wbs sw on sla.schedule_wbs = sw.id 
	left join stg.LogBoomi.p6_schedule s on sw.id_schedule = s.id)
 		on s.month = dwh.month and s.year = dwh.year 
 		and s.id_project = dwh.JPassprojectID and sla.activity_id = dwh.activityId
where s.id_project is null

union

select 
    N'schedule/wbs/sla' AS Collab_Table,
    N'vP62Collab1' AS DWH_Table,
	dwh.[month], 
	dwh. [year],
	dwh.jpassprojectId,
	dwh.activityId ,
	N'Update' IntegrationType,
    N'startDate' AS KPI,
	cast (dwh.startDate as nvarchar (max) ) value_DWH,
	cast (sla.start_date as nvarchar (max) ) value_Collab,
	'' reason
from
	STG.LogBoomi.vP62Collab1 dwh 
	inner join (stg.logboomi.p6_schedule_level_activity sla 
	left join stg.LogBoomi.p6_schedule_wbs sw on sla.schedule_wbs = sw.id 
	left join stg.LogBoomi.p6_schedule s on sw.id_schedule = s.id)
 		on s.month = dwh.month and s.year = dwh.year 
 		and s.id_project = dwh.JPassprojectID and sla.activity_id = dwh.activityId
where sla.start_date != dwh.startDate

union

select 
    N'schedule/wbs/sla' AS Collab_Table,
    N'vP62Collab1' AS DWH_Table,
	dwh.[month], 
	dwh. [year],
	dwh.jpassprojectId,
	dwh.activityId ,
	N'Update' IntegrationType,
    N'endDate' AS KPI,
	cast (dwh.endDate as nvarchar (max) ) DWHvalue,
	cast (sla.end_date as nvarchar (max) ) CollabValue,
	'' reason 
from
	STG.LogBoomi.vP62Collab1 dwh
	inner join (stg.logboomi.p6_schedule_level_activity sla 
	left join stg.LogBoomi.p6_schedule_wbs sw on sla.schedule_wbs = sw.id 
	left join stg.LogBoomi.p6_schedule s on sw.id_schedule = s.id )
	 		on s.month = dwh.month and s.year = dwh.year 
	 		and s.id_project = dwh.JPassprojectID and sla.activity_id = dwh.activityId
where 
 	sla.end_date != dwh.endDate 

union 

select
    N'schedule/wbs/sla' AS Collab_Table,
    N'vP62Collab1' AS DWH_Table,
	dwh.[month], 
	dwh. [year],
	dwh.jpassprojectId,
	dwh.activityId ,
	N'Update' IntegrationType,
    N'totalFloat' AS KPI,
	cast (dwh.totalFloat  as nvarchar (max) ) DWHvalue,
	cast (sla.total_float  as nvarchar (max) ) CollabValue,
	'' reason
from
	stg.LogBoomi.vP62Collab1 dwh 
	inner join stg.logboomi.p6_schedule_level_activity sla 
	left join stg.LogBoomi.p6_schedule_wbs sw on sla.schedule_wbs = sw.id 
	left join stg.LogBoomi.p6_schedule s on sw.id_schedule = s.id 
	 		on s.month = dwh.month and s.year = dwh.year 
	 		and s.id_project = dwh.JPassprojectID and sla.activity_id = dwh.activityId
where 
 	sla.total_float  != round(dwh.totalFloat,0)
 	
union 

select
    N'schedule/wbs/sla' AS Collab_Table,
    N'vP62Collab1' AS DWH_Table,
	dwh.[month], 
	dwh. [year],
	dwh.jpassprojectId,
	dwh.activityId ,
	N'Update' IntegrationType,
    N'originalDuration' AS KPI,
	cast (dwh.originalDuration  as nvarchar (max) ) DWHvalue,
	cast (sla.duration  as nvarchar (max) ) CollabValue,
	'' reason
from
	stg.LogBoomi.vP62Collab1 dwh 
	inner join stg.logboomi.p6_schedule_level_activity sla 
	left join stg.LogBoomi.p6_schedule_wbs sw on sla.schedule_wbs = sw.id 
	left join stg.LogBoomi.p6_schedule s on sw.id_schedule = s.id 
	 		on s.month = dwh.month and s.year = dwh.year 
	 		and s.id_project = dwh.JPassprojectID and sla.activity_id = dwh.activityId
where 
 	sla.duration  != round(dwh.originalDuration, 0)
 
 UNION
 
 select
    N'schedule/wbs/sla' AS Collab_Table,
    N'vP62Collab1' AS DWH_Table,
	dwh.[month], 
	dwh. [year],
	dwh.jpassprojectId,
	dwh.activityId ,
	N'Update' IntegrationType,
    N'remainingDuration' AS KPI,
	cast (dwh.remainingDuration as nvarchar (max) ) DWHvalue,
	cast (sla.remaining_duration as nvarchar (max) ) CollabValue,
	'' reason
from
	stg.LogBoomi.vP62Collab1 dwh 
	inner join stg.logboomi.p6_schedule_level_activity sla 
	left join stg.LogBoomi.p6_schedule_wbs sw on sla.schedule_wbs = sw.id 
	left join stg.LogBoomi.p6_schedule s on sw.id_schedule = s.id 
	 		on s.month = dwh.month and s.year = dwh.year 
	 		and s.id_project = dwh.JPassprojectID and sla.activity_id = dwh.activityId
where 
 	sla.remaining_duration != round(dwh.remainingDuration,0)
 
UNION

select
    N'schedule/wbs/sla' AS Collab_Table,
    N'vP62Collab1' AS DWH_Table,
	dwh.[month], 
	dwh. [year],
	dwh.jpassprojectId,
	dwh.activityId ,
	N'Update' IntegrationType,
    N'atCompleteDuration' AS KPI,
	cast (dwh.atCompleteDuration as nvarchar (max) ) DWHvalue,
	cast (sla.at_complete_duration as nvarchar (max) ) CollabValue,
	'' reason
from
	STG.LogBoomi.vP62Collab1 dwh 
	inner join stg.logboomi.p6_schedule_level_activity sla 
	left join stg.LogBoomi.p6_schedule_wbs sw on sla.schedule_wbs = sw.id 
	left join stg.LogBoomi.p6_schedule s on sw.id_schedule = s.id 
	 		on s.month = dwh.month and s.year = dwh.year 
	 		and s.id_project = dwh.JPassprojectID and sla.activity_id = dwh.activityId
where 
 	sla.at_complete_duration != round(dwh.atCompleteDuration,0)

Union

select 					
	N'schedule/wbs/sla' AS Collab_Table,
	N'vP62Collab1' AS DWH_Table,
	dwh.[month], 
	dwh. [year],
	dwh.jpassprojectId,
	dwh.activityId ,
	N'Update' IntegrationType,
	N'status_label' AS KPI,
	cast (dwh.status_label as nvarchar (max)) DWHvalue,
	cast (enum.label as nvarchar (max)) CollabValue,
	'' reason
from
	STG.LogBoomi.vP62Collab1 dwh 
	inner join (stg.logboomi.p6_schedule_level_activity sla 
	left join  stg.LogBoomi.p6_schedule_wbs sw on sla.schedule_wbs = sw.id 
	left join stg.LogBoomi.p6_schedule s on sw.id_schedule = s.id 
	left join stg.logboomi.collab_enumeration enum on sla.status = enum.id)
	 		on s.month = dwh.month and s.year = dwh.year 
	 		and s.id_project = dwh.JPassprojectID and sla.activity_id = dwh.activityId
where 
 	dwh.status_label  != enum.label 
 	
Union

select 					
	N'schedule/wbs/sla' AS Collab_Table,
	N'vP62Collab1' AS DWH_Table,
	dwh.[month], 
	dwh. [year],
	dwh.jpassprojectId,
	dwh.activityId ,
	N'Update' IntegrationType,
	N'type_label' AS KPI,
	cast (dwh.type_label as nvarchar (max)) DWHvalue,
	cast (enum.label as nvarchar (max)) CollabValue,
	'' reason
from
	stg.LogBoomi.vP62Collab1 dwh 
	inner join (stg.logboomi.p6_schedule_level_activity sla 
	left join  stg.LogBoomi.p6_schedule_wbs sw on sla.schedule_wbs = sw.id 
	left join stg.LogBoomi.p6_schedule s on sw.id_schedule = s.id 
	left join stg.logboomi.collab_enumeration enum on sla.type = enum.id)
	 		on s.month = dwh.month and s.year = dwh.year 
	 		and s.id_project = dwh.JPassprojectID and sla.activity_id = dwh.activityId
where 
 	dwh.type_label  != enum.label

Union
--------------------------- PROJECT DETAILS -------------------------------------


select 
    N'project_details' AS Collab_Table,
    N'vP62Collab2' AS DWH_Table,
    N'-'[month], 
	N'-' [year],
	dwh.jpassprojectId,
	N'-' activityId,
	N'Insert' IntegrationType,
    N'No-KPI' AS KPI,
	N'-' value_DWH,
	N'-' value_Collab,
	'' reason
FROM stg.LogBoomi.vP62Collab2 dwh 
	left join stg.logboomi.project_details C on dwh.JPassProjectID = C.project_id 
WHERE C.project_id IS NULL
	
	
Union
 	
select
    N'project_details' AS Collab_Table,
    N'vP62Collab2' AS DWH_Table,
    N'-'[month], 
	N'-' [year],
	dwh.jpassprojectId,
	N'-' activityId,
	N'Update' IntegrationType,
    N'EngineeringStartDate' AS KPI,
	cast (dwh.EngineeringStartDate as nvarchar (max) ) DWHvalue,
	cast (C.engineering_start_date as nvarchar (max) ) CollabValue,
	'' reason
FROM stg.LogBoomi.vP62Collab2 dwh 
	inner join stg.logboomi.project_details C on dwh.JPassProjectID = C.project_id 
WHERE dwh.EngineeringStartDate != C.engineering_start_date 

UNION

select
    N'project_details' AS Collab_Table,
    N'vP62Collab2' AS DWH_Table,
    N'-'[month], 
	N'-' [year],
	dwh.jpassprojectId,
	N'-' activityId,
	N'Update' IntegrationType,
    N'EngineeringEndDate' AS KPI,
	cast (dwh.EngineeringEndDate as nvarchar (max)) DWHvalue,
	cast (C.engineering_end_date as nvarchar (max)) CollabValue,
	'' reason
FROM stg.LogBoomi.vP62Collab2 dwh 
	inner join stg.logboomi.project_details C on dwh.JPassProjectID = C.project_id 
WHERE C.engineering_end_date != dwh.EngineeringEndDate

UNION

select
    N'project_details' AS Collab_Table,
    N'vP62Collab2' AS DWH_Table,
    N'-'[month], 
	N'-' [year],
	dwh.jpassprojectId,
	N'-' activityId,
	N'Update' IntegrationType,
    N'ProcurementStartDate' AS KPI,
	cast (dwh.ProcurementStartDate  as nvarchar (max)) DWHvalue,
	cast (C.procurement_start_date  as nvarchar (max)) CollabValue,
	'' reason
FROM stg.LogBoomi.vP62Collab2 dwh 
	inner join stg.logboomi.project_details C on dwh.JPassProjectID = C.project_id 
WHERE C.procurement_start_date  != dwh.ProcurementStartDate

union

select
    N'project_details' AS Collab_Table,
    N'vP62Collab2' AS DWH_Table,
    N'-'[month], 
	N'-' [year],
	dwh.jpassprojectId,
	N'-' activityId,
	N'Update' IntegrationType,
    N'ProcurementEndDate' AS KPI,
	cast (dwh.ProcurementEndDate  as nvarchar (max)) DWHvalue,
	cast (C.procurement_end_date  as nvarchar (max)) CollabValue,
	'' reason
FROM stg.LogBoomi.vP62Collab2 dwh 
	inner join stg.logboomi.project_details C on dwh.JPassProjectID = C.project_id 
WHERE C.procurement_end_date != dwh.ProcurementEndDate

union

select
    N'project_details' AS Collab_Table,
    N'vP62Collab2' AS DWH_Table,
    N'-'[month], 
	N'-' [year],
	dwh.jpassprojectId,
	N'-' activityId,
	N'Update' IntegrationType,
    N'ConstructionStartDate' AS KPI,
	cast (dwh.ConstructionStartDate as nvarchar (max)) DWHvalue,
	cast (C.construction_start_date as nvarchar (max)) CollabValue,
	'' reason
FROM stg.LogBoomi.vP62Collab2 dwh 
	inner join stg.logboomi.project_details C on dwh.JPassProjectID = C.project_id 
WHERE C.construction_start_date  != dwh.ConstructionStartDate

union 

select
    N'project_details' AS Collab_Table,
    N'vP62Collab2' AS DWH_Table,
    N'-'[month], 
	N'-' [year],
	dwh.jpassprojectId,
	N'-' activityId,
	N'Update' IntegrationType,
    N'ConstructionEndDate' AS KPI,
	cast (dwh.ConstructionEndDate as nvarchar (max)) DWHvalue,
	cast (C.construction_end_date as nvarchar (max)) CollabValue,
'' reason
FROM stg.LogBoomi.vP62Collab2 dwh 
	inner join stg.logboomi.project_details C on dwh.JPassProjectID = C.project_id 
WHERE C.construction_end_date != dwh.ConstructionEndDate 

Union

select
    N'project_details' AS Collab_Table,
    N'vP62Collab2' AS DWH_Table,
    N'-'[month], 
	N'-' [year],
	dwh.jpassprojectId,
	N'-' activityId,
	N'Update' IntegrationType,
    N'CommissioningStartDate' AS KPI,
	cast (dwh.CommissioningStartDate as nvarchar (max)) DWHvalue,
	cast (C.commissioning_start_date as nvarchar (max)) CollabValue,
	'' reason
FROM stg.LogBoomi.vP62Collab2 dwh 
	inner join stg.logboomi.project_details C on dwh.JPassProjectID = C.project_id 
WHERE C.commissioning_start_date  != dwh.CommissioningStartDate 

union 

select
    N'project_details' AS Collab_Table,
    N'vP62Collab2' AS DWH_Table,
    N'-'[month], 
	N'-' [year],
	dwh.jpassprojectId,
	N'-' activityId,
	N'Update' IntegrationType,
    N'CommissioningEndDate' AS KPI,
	cast (dwh.CommissioningEndDate as nvarchar (max)) DWHvalue,
	cast (C.commissioning_end_date as nvarchar (max)) CollabValue,
	'' reason
FROM stg.LogBoomi.vP62Collab2 dwh 
	inner join stg.logboomi.project_details C on dwh.JPassProjectID = C.project_id 
WHERE C.commissioning_end_date  != dwh.CommissioningEndDate 

---------------------------OOOORRRRRIIIIGGGIIIINNNAAALLLLL DAATTTAA -----------------------------
UNION

select 
    N'-' AS Collab_Table,
    N'vP62Collab1' AS DWH_Table,
	dwh.[month], 
	dwh. [year],
	dwh.jpassprojectId,
	dwh.activityId,
	N'Original Data' IntegrationType,
    N'Schedule' AS KPI,
	cast (NULL  as nvarchar (max)) DWHvalue,
	cast (NULL as nvarchar (max)) CollabValue,
	'' reason
from
	STG.LogBoomi.vP62Collab1 dwh 

UNION

select
    N'-' AS Collab_Table,
    N'vP62Collab2' AS DWH_Table,
    N'-' [month], 
	N'-' [year],
	dwh.jpassprojectId,
	N'-' activityId,
	N'Original Data' IntegrationType,
    N'project_details' AS KPI,
	cast (NULL  as nvarchar (max)) DWHvalue,
	cast (NULL as nvarchar (max)) CollabValue,
	'' reason
FROM stg.LogBoomi.vP62Collab2 dwh )x

;
GO
/****** Object:  Table [MASTER].[lookup_project]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MASTER].[lookup_project](
	[Collab_Project_Number] [nvarchar](255) NULL,
	[Project_Name] [nvarchar](255) NULL,
	[Verano_Project_Number] [nvarchar](255) NULL,
	[PC_Project_Number] [nvarchar](255) NULL,
	[HSE_Project_Number] [nvarchar](255) NULL,
	[P6_Project_Number] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [HSE].[SOR]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HSE].[SOR](
	[ContentTypeID] [nvarchar](max) NULL,
	[Title] [nvarchar](max) NULL,
	[ComplianceAssetId] [nvarchar](max) NULL,
	[Project] [nvarchar](max) NULL,
	[Company] [nvarchar](max) NULL,
	[Date] [datetime] NULL,
	[Submiter] [nvarchar](max) NULL,
	[CriticalRisk] [nvarchar](max) NULL,
	[SubjectValue] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[TypeValue] [nvarchar](max) NULL,
	[GroupValue] [nvarchar](max) NULL,
	[WPS] [nvarchar](max) NULL,
	[Likelihood] [nvarchar](max) NULL,
	[Statut] [nvarchar](max) NULL,
	[ImageBefore] [nvarchar](max) NULL,
	[DateOfClosure] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ImmediatCorrectiveActions] [nvarchar](max) NULL,
	[ImageAfter] [nvarchar](max) NULL,
	[ActionPlan] [nvarchar](max) NULL,
	[Validated] [nvarchar](max) NULL,
	[MailValue] [nvarchar](max) NULL,
	[LocationOfSORValue] [nvarchar](max) NULL,
	[Created] [datetime] NULL,
	[Id] [int] NULL,
	[ContentType] [nvarchar](max) NULL,
	[Modified] [datetime] NULL,
	[CreatedById] [int] NULL,
	[ModifiedById] [int] NULL,
	[Owshiddenversion] [int] NULL,
	[Version] [nvarchar](max) NULL,
	[Path] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HSE].[StatisticInputMonth]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HSE].[StatisticInputMonth](
	[ContentTypeID] [nvarchar](max) NULL,
	[Title] [nvarchar](max) NULL,
	[ComplianceAssetId] [nvarchar](max) NULL,
	[Datevalue] [datetime] NULL,
	[MPValue] [float] NULL,
	[MHValue] [float] NULL,
	[SPAValue] [float] NULL,
	[SORValue] [float] NULL,
	[TBTValue] [float] NULL,
	[InductionValue] [float] NULL,
	[Projectvalue] [nvarchar](max) NULL,
	[Validated] [float] NULL,
	[Id] [int] NULL,
	[ContentType] [nvarchar](max) NULL,
	[Modified] [datetime] NULL,
	[Created] [datetime] NULL,
	[CreatedById] [int] NULL,
	[ModifiedById] [int] NULL,
	[Owshiddenversion] [int] NULL,
	[Version] [nvarchar](max) NULL,
	[Path] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HSE].[SubEvent]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HSE].[SubEvent](
	[ContentTypeID] [nvarchar](max) NULL,
	[Title] [nvarchar](max) NULL,
	[ComplianceAssetId] [nvarchar](max) NULL,
	[IDPIN] [float] NULL,
	[TypeValue] [nvarchar](max) NULL,
	[SubEventValue] [nvarchar](max) NULL,
	[WorkRelatedValue] [nvarchar](max) NULL,
	[ClassificationValue] [nvarchar](max) NULL,
	[ActualSeverityValue] [float] NULL,
	[EquipementInvolvedValue] [nvarchar](max) NULL,
	[SourceOfInjuryValue] [nvarchar](max) NULL,
	[NatureOfInjuryValue] [nvarchar](max) NULL,
	[BodyPartValue] [nvarchar](max) NULL,
	[AppropriatePPENotUsedValue] [nvarchar](max) NULL,
	[TreatementDateValue] [datetime] NULL,
	[TreatementDescriptionValue] [nvarchar](max) NULL,
	[TreatmentFacilityValue] [nvarchar](max) NULL,
	[PermanentDisabilityValue] [nvarchar](max) NULL,
	[ExpectedRestrictedDaysValue] [float] NULL,
	[ActualRestrictedDaysValue] [float] NULL,
	[ExpectedDaysAwayValue] [float] NULL,
	[ActualDaysAwayValue] [float] NULL,
	[ActualReturnToWorkDateValue] [datetime] NULL,
	[Validated] [float] NULL,
	[MailValue] [nvarchar](max) NULL,
	[SubmiterValue] [nvarchar](max) NULL,
	[PoliceReportRequiredValue] [nvarchar](max) NULL,
	[PoliceReportFieldValue] [nvarchar](max) NULL,
	[SubstanceReleasedValue] [nvarchar](max) NULL,
	[VolumeReleasedValue] [nvarchar](max) NULL,
	[PotentialCostValue] [nvarchar](max) NULL,
	[VehicleOwnerValue] [nvarchar](max) NULL,
	[IsVehicleAssignedToTheDriverInvolvedValue] [nvarchar](max) NULL,
	[WhoIsItassignedToValue] [nvarchar](max) NULL,
	[VehicleIDValue] [nvarchar](max) NULL,
	[TipeofVehicleValue] [nvarchar](max) NULL,
	[MarkeValue] [nvarchar](max) NULL,
	[ModelValue] [nvarchar](max) NULL,
	[VehiculeYearValue] [nvarchar](max) NULL,
	[WasVehicleOccupiedValue] [nvarchar](max) NULL,
	[NumberOfPassangersValue] [float] NULL,
	[StatusOfVehicleValue] [nvarchar](max) NULL,
	[MVISubEventValue] [nvarchar](max) NULL,
	[RollOverValue] [nvarchar](max) NULL,
	[VehicleSpeedValue] [nvarchar](max) NULL,
	[VehicleDisabledValue] [nvarchar](max) NULL,
	[AirbagDeployedValue] [nvarchar](max) NULL,
	[CollisionValue] [nvarchar](max) NULL,
	[CollisionDetailValue] [nvarchar](max) NULL,
	[TypeOfCollisionValue] [nvarchar](max) NULL,
	[PointOfImpactValue] [nvarchar](max) NULL,
	[VehicleDamagedValue] [nvarchar](max) NULL,
	[InsuranceCompanyValue] [nvarchar](max) NULL,
	[InsurancePolicyNumberValue] [nvarchar](max) NULL,
	[InsuranceExpiringDateValue] [datetime] NULL,
	[InternationalValue] [nvarchar](max) NULL,
	[DrugTestAllowedinyourcountryValue] [nvarchar](max) NULL,
	[DrugTestPerformedValue] [nvarchar](max) NULL,
	[AlcoholTestAllowedValue] [nvarchar](max) NULL,
	[AlcoholTestPerformedValue] [nvarchar](max) NULL,
	[SubEventRemarksValue] [nvarchar](max) NULL,
	[IsthereanyinvolvedPersonValue] [nvarchar](max) NULL,
	[UnsafeactsValue] [nvarchar](max) NULL,
	[UnsafeconditionsValue] [nvarchar](max) NULL,
	[PeopleFactorsValue] [nvarchar](max) NULL,
	[ExecutionFactorsValue] [nvarchar](max) NULL,
	[ManagementAspectsValue] [nvarchar](max) NULL,
	[ProgramSystemAspectsValue] [nvarchar](max) NULL,
	[Datevalue] [datetime] NULL,
	[Projectvalue] [nvarchar](max) NULL,
	[Descriptionvalue] [nvarchar](max) NULL,
	[Id] [int] NULL,
	[ContentType] [nvarchar](max) NULL,
	[Modified] [datetime] NULL,
	[Created] [datetime] NULL,
	[CreatedById] [int] NULL,
	[ModifiedById] [int] NULL,
	[Owshiddenversion] [int] NULL,
	[Version] [nvarchar](max) NULL,
	[Path] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [HSE].[v_SOR]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [HSE].[v_SOR] as 
with proj as (
SELECT distinct [Project]
  FROM [STG].[HSE].[SOR]
union
SELECT distinct [Projectvalue]
     
  FROM [STG].[HSE].[StatisticInputMonth]
  
  union
 select distinct Projectvalue from hse.SubEvent),hse_proj as (
select distinct  Project
,CASE 
    WHEN CHARINDEX('- ', Project) > 0 
    THEN SUBSTRING(Project, 1, CHARINDEX('- ', Project) - 1) 
    ELSE Project 
  END AS project_name,
  CASE 
    WHEN CHARINDEX('- ', Project) > 0 
    THEN SUBSTRING(Project, CHARINDEX('- ', Project) + 1, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) - CHARINDEX('- ', Project) - 1) 
    ELSE NULL 
  END AS city,
  CASE 
    WHEN CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) > 0 
    THEN SUBSTRING(Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1, CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) - CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) - 1) 
    ELSE NULL 
  END AS project_number,
  CASE 
    WHEN CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) >0  
	AND CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) + 1) 
- CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) - 1>0
    THEN SUBSTRING(Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) + 1, CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) + 1) - CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) - 1) 
    ELSE NULL 
  END AS sector,
  CASE 
    WHEN CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) + 1) > 0 
    THEN SUBSTRING(Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) + 1) + 1, LEN(Project)) 
    ELSE NULL 
  END AS bu

 from proj s)

 select s.*,
 pe.label project_status,
 psp.label project_phase,
 pes.label project_size,
 ltrim(rtrim(p.project_number)) project_number,
 pmp.number Collab_project,
 isnull(lp.Collab_Project_Number,ltrim(rtrim(p.project_number))) mappedProject,
 cast(left(pmp.close_date,8) as date) close_date,
 cast(left(pmp.forecast_date,8) as date) forecast_date,
 cast(left(pmp.contractual_end_date,8) as date) contractual_end_date,
 cast(left(pmp.start_date,8) as date) start_date

 from stg.hse.sor s
 left outer join  hse_proj p on p.Project = s.Project
 left outer join stg.master.lookup_project lp on lp.HSE_Project_Number =  ltrim(rtrim(p.project_number))
 left outer join stg.ds.project_management_project pmp on pmp.number = isnull(lp.Collab_Project_Number,ltrim(rtrim(p.project_number)))
 --left outer join stg.ds.project_management_project pmp on pmp.number = ltrim(rtrim(p.project_number))
 left outer join stg.ds.project_management_enumeration pe on pe.id = pmp.status_id
 left outer join stg.ds.project_management_enumeration pes on pes.id = pmp.project_size_id
 outer apply ( SELECT top 1 ee.*
           FROM ds.project_management_project_phase phh
		   inner join ds.project_management_enumeration ee on ee.id=phh.phase_id
		   where phh.project_id=pmp.id
		   order by phh.id desc) psp







GO
/****** Object:  View [P6].[v_WBSHIERARCHY_Split_uni]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- P6.v_WBSHIERARCHY_Split source

-- P6.v_WBSHIERARCHY_Split source

CREATE view [P6].[v_WBSHIERARCHY_Split_uni] as
With ParentLevel as (
SELECT [parentobjectid]
      ,[parentname]
      ,[parentid]
      ,[childobjectid]
      ,[childname]
      ,[childid]
      ,[fullpathname]
  FROM [STG].[P6].[WBSHIERARCHY]
where parentlevelsbelowroot=1
and parentid=childid
),Level1 as (
SELECT [parentobjectid] ParentLevelObjectId
      ,[parentid] ParentLevelId
      ,[childobjectid] ChildObjectLevel1
      ,[childname]
      ,[fullpathname]
  FROM [STG].[P6].[WBSHIERARCHY]
where parentlevelsbelowroot=1
and len(FullPathName) - len(replace(FullPathName, '.', '')) = 1
),Level2 as (
SELECT [parentobjectid] ChildObjectLevel1
      ,[childobjectid] ChildObjectLevel2
      ,[childname]
      ,[childid]
      ,[fullpathname]
  FROM [STG].[P6].[WBSHIERARCHY]
where parentlevelsbelowroot=2
and len(FullPathName) - len(replace(FullPathName, '.', '')) = 2

)

select ParentLevel.[parentobjectid],
ParentLevel.[fullpathname],
level1.ChildObjectLevel1,
level1.[fullpathname] fullpathname1,
level2.ChildObjectLevel2,
level2.[fullpathname] fullpathname2,
level1.ChildObjectLevel1 ParentJoinColumn,
level2.ChildObjectLevel2 JoinColumn
 from ParentLevel
 left join level1 on ParentLevel.[parentobjectid]=level1.ParentLevelObjectId
 left join Level2 on level1.ChildObjectLevel1=level2.ChildObjectLevel1
 --where  level2.ChildObjectLevel2='1819087'
-- where  ParentLevel.[parentobjectid]='1819087'

 union
 select distinct ParentLevel.[parentobjectid],
ParentLevel.[fullpathname],
level1.ChildObjectLevel1,
level1.[fullpathname],
null ChildObjectLevel2,
null [fullpathname],
ParentLevel.[parentobjectid],
level1.ChildObjectLevel1 JoinColumn
 from ParentLevel
 left join level1 on ParentLevel.[parentobjectid]=level1.ParentLevelObjectId
-- where  ParentLevel.[parentobjectid]='1819087'

  union
 select distinct ParentLevel.[parentobjectid],
ParentLevel.[fullpathname],
null ChildObjectLevel1,
null [fullpathname],
null ChildObjectLevel2,
null [fullpathname],
null,
ParentLevel.[parentobjectid] JoinColumn
 from ParentLevel
-- where  ParentLevel.[parentobjectid]='1819087'
 --order by len(Level2.fullpathname) asc;
GO
/****** Object:  Table [DS].[csp_audit_and_evaluation]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_audit_and_evaluation](
	[id] [nvarchar](250) NULL,
	[safety_performance_id] [nvarchar](250) NULL,
	[planned] [nvarchar](250) NULL,
	[conducted] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_contract_management]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_contract_management](
	[id] [nvarchar](250) NULL,
	[safety_performance_id] [nvarchar](250) NULL,
	[number_of_hse_enforcement] [nvarchar](250) NULL,
	[notice_of_hse_non_compliance] [nvarchar](250) NULL,
	[ncr_close_out] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_contractor_hse_supervisor_ratio]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_contractor_hse_supervisor_ratio](
	[id] [nvarchar](255) NOT NULL,
	[safety_performance_id] [nvarchar](255) NULL,
	[number_of_contractors_hse_supervisor] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NOT NULL,
	[update_date] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_health_management]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_health_management](
	[id] [nvarchar](255) NOT NULL,
	[safety_performance_id] [nvarchar](255) NULL,
	[fit_to_work_health_assessment] [nvarchar](255) NULL,
	[working_at_height_medical_assessments_and_training] [nvarchar](255) NULL,
	[people_working_at_height] [nvarchar](255) NULL,
	[actual_first_aiders_on_site] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NOT NULL,
	[update_date] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_lagging_indicators]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_lagging_indicators](
	[id] [nvarchar](255) NOT NULL,
	[ltifr] [nvarchar](255) NULL,
	[trifr] [nvarchar](255) NULL,
	[safety_performance_id] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NULL,
	[update_date] [nvarchar](255) NULL,
	[fatality] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_management_and_leadership]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_management_and_leadership](
	[id] [nvarchar](250) NULL,
	[safety_performance_id] [nvarchar](250) NULL,
	[planned_site_leadership_walks] [nvarchar](250) NULL,
	[site_leadership_walks_conducted] [nvarchar](250) NULL,
	[raised_in_meeting] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_reward_recognition]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_reward_recognition](
	[id] [nvarchar](255) NOT NULL,
	[safety_performance_id] [nvarchar](255) NULL,
	[actual] [nvarchar](255) NULL,
	[planned] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NOT NULL,
	[update_date] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_safety_performance]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_safety_performance](
	[id] [nvarchar](250) NULL,
	[project_id] [nvarchar](250) NULL,
	[contract_id] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[month] [nvarchar](250) NULL,
	[year] [nvarchar](250) NULL,
	[status] [nvarchar](250) NULL,
	[contractor_id] [nvarchar](250) NULL,
	[creator_id] [nvarchar](250) NULL,
	[currently_with] [nvarchar](250) NULL,
	[qualitative_evaluation_of_raised_actions] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_site_presence]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_site_presence](
	[id] [nvarchar](250) NULL,
	[safety_performance_id] [nvarchar](250) NULL,
	[total_on_site] [nvarchar](250) NULL,
	[contractors_key_persons] [nvarchar](250) NULL,
	[working_hours_during_the_month] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_task_planning]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_task_planning](
	[id] [nvarchar](255) NOT NULL,
	[safety_performance_id] [nvarchar](255) NULL,
	[number_of_sampled_by_contractors] [nvarchar](255) NULL,
	[number_of_completed_by_cs] [nvarchar](255) NULL,
	[average] [nvarchar](255) NULL,
	[number_of_tasks_carried] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NOT NULL,
	[update_date] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_training_management]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_training_management](
	[id] [nvarchar](250) NULL,
	[safety_performance_id] [nvarchar](250) NULL,
	[all_hse_training_hours] [nvarchar](250) NULL,
	[number_of_starts_on_project] [nvarchar](250) NULL,
	[attended] [nvarchar](250) NULL,
	[number_of_tbt_planned] [nvarchar](250) NULL,
	[number_of_tbt_conducted] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_csp_safety_performance]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [DS].[v_csp_safety_performance] as
SELECT sp.id as sp_id
      ,sp.project_id
      ,sp.contract_id
      ,sp.creation_date sp_creation_date
      ,sp.update_date as sp_update_date
      ,month as sp_month
      ,year as sp_year
      ,status as sp_status
      ,contractor_id as sp_contractor_id
      ,creator_id as sp_creator_id
      ,currently_with as sp_currently_with
	  ,sp.qualitative_evaluation_of_raised_actions sp_qual_eval_raised_actions
	  ,aae.planned audit_evaluation_planned
	  ,aae.conducted audit_evaluation_conducted
	  ,cm.number_of_hse_enforcement cm_hse_enforcement
	  ,cm.notice_of_hse_non_compliance cm_hse_non_compliance
	  ,cm.ncr_close_out cm_ncr_close_out 
	  ,chsr.number_of_contractors_hse_supervisor chsr_nb_contractors_hse_supervisor
	  ,hm.fit_to_work_health_assessment hm_fit_to_work_health_assessment
	  ,hm.working_at_height_medical_assessments_and_training hm_working_at_height_medical_assessments_and_training
	  ,hm.people_working_at_height hm_people_working_at_height
	  ,hm.actual_first_aiders_on_site hm_actual_first_aiders_on_site
	  ,li.ltifr li_ltifr
	  ,li.trifr li_trifr
	  ,li.fatality li_fatality
	  ,mal.planned_site_leadership_walks mal_planned_site_leadership_walks
	  ,mal.site_leadership_walks_conducted mal_site_leadership_walks_conducted
	  ,mal.raised_in_meeting mal_raised_in_meeting
	  ,rr.actual rr_actual
	  ,rr.planned rr_planned
	  ,sp2.total_on_site sp2_total_on_site
	  ,sp2.contractors_key_persons sp2_contractors_key_persons
	  ,sp2.working_hours_during_the_month sp2_working_hours_during_the_month
	  ,tp.number_of_completed_by_cs tp_number_of_completed_by_cs
	  ,tp.number_of_sampled_by_contractors tp_number_of_sampled_by_contractors
	  ,tp.number_of_tasks_carried tp_number_of_tasks_carried
	  ,tp.average tp_average
	  ,tm.all_hse_training_hours tm_all_hse_training_hours
	  ,tm.number_of_starts_on_project tm_number_of_starts_on_project
	  ,tm.attended tm_attended
	  ,tm.number_of_tbt_conducted tm_number_of_tbt_conducted
	  ,tm.number_of_tbt_planned tm_number_of_tbt_planned
	  
  FROM ds.CSP_safety_performance sp
 left join ds.csp_audit_and_evaluation aae on aae.safety_performance_id = sp.id
 left join ds.csp_contract_management cm on cm.safety_performance_id = sp.id
 left join ds.csp_contractor_hse_supervisor_ratio chsr on chsr.safety_performance_id = sp.id
 left join ds.csp_health_management hm on hm.safety_performance_id = sp.id
 left join ds.csp_lagging_indicators li on li.safety_performance_id = sp.id
 left join ds.csp_management_and_leadership mal on mal.safety_performance_id = sp.id
 left join ds.csp_reward_recognition rr on rr.safety_performance_id = sp.id
 left join ds.csp_site_presence sp2 on sp2.safety_performance_id = sp.id
 left join ds.csp_task_planning tp on tp.safety_performance_id = sp.id
 left join ds.csp_training_management tm on tm.safety_performance_id =sp.id


GO
/****** Object:  Table [DS].[jpass_employee_behavior]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_employee_behavior](
	[id] [nvarchar](2000) NULL,
	[warning_date] [nvarchar](2000) NULL,
	[expiring_date] [nvarchar](2000) NULL,
	[required_action] [nvarchar](2000) NULL,
	[description] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[employee_id] [nvarchar](2000) NULL,
	[company] [nvarchar](2000) NULL,
	[type_emp] [nvarchar](2000) NULL,
	[file_emp] [nvarchar](2000) NULL,
	[validation_comment] [nvarchar](2000) NULL,
	[validation_status_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_behavior]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [DS].[v_jpass_behavior]
as SELECT e.id AS employee_id,
    e.unique_reference AS employee_unique_reference,
    eb.id AS behavior_id,
    eb.required_action AS behavior_req_action,
    eb.description AS behavior_description,
    eb.warning_date AS behavior_date,
    eb.expiring_date AS behavior_expiring_date,
    ctr.id AS company_id,
    ctr.name_sub AS company_name,
    vwr.code AS behavior_validation_status_code,
    vwr.label_validation  AS behavior_validation_status,
    wr.id AS behavior_label_id,
    wr.name AS behavior_label,
    wrt.id AS behavior_type_id,
    wrt.label_war AS behavior_type
   FROM ds.jpass_employee_behavior eb
     LEFT JOIN ds.jpass_employee e ON eb.employee_id = e.id
     LEFT JOIN ds.jpass_warning wr ON wr.id = eb.type_emp
     LEFT JOIN ds.jpass_warning_type wrt ON wrt.id = wr.type
     LEFT JOIN ds.jpass_association_validation_status vwr ON vwr.id = eb.validation_status_id
     LEFT JOIN ds.jpass_contractor_sub_contractor ctr ON ctr.id = e.company

GO
/****** Object:  View [DS].[v_jpass_behavior_type]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [DS].[v_jpass_behavior_type]
AS SELECT w.id AS behavior_label_id,
    tw.id AS behavior_type_id,
    w.name AS behavior_label,
    tw.label_war AS behavior_type
   FROM DS.jpass_warning w
     LEFT JOIN ds.jpass_warning_type tw ON tw.id = w.type

GO
/****** Object:  Table [LogBoomi].[vQaaudits]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vQaaudits](
	[id] [varchar](1) NULL,
	[id_audit_type] [nvarchar](250) NULL,
	[type_audit_type] [nvarchar](250) NULL,
	[code_audit_type] [nvarchar](250) NULL,
	[label_audit_type] [nvarchar](250) NULL,
	[id_type] [nvarchar](250) NULL,
	[type_type] [nvarchar](250) NULL,
	[code_type] [nvarchar](250) NULL,
	[label_type] [nvarchar](250) NULL,
	[activityDisciplineCode] [nvarchar](250) NULL,
	[activityDiscipline] [nvarchar](250) NULL,
	[id_status] [nvarchar](250) NULL,
	[type_status] [nvarchar](250) NULL,
	[code_status] [nvarchar](250) NULL,
	[label_status] [nvarchar](250) NULL,
	[Score] [numeric](12, 2) NULL,
	[findingsNumber] [int] NULL,
	[comment] [varchar](1) NULL,
	[realizationDate] [datetime] NULL,
	[plannedDate] [datetime] NULL,
	[creationDate] [varchar](1) NULL,
	[updateDate] [varchar](1) NULL,
	[JPassProjectID] [int] NULL,
	[trafficLight] [nvarchar](4000) NULL,
	[qa_source_id] [nvarchar](20) NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vQaaudits_tpr]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vQaaudits_tpr](
	[id] [varchar](1) NULL,
	[id_audit_type] [nvarchar](2000) NULL,
	[type_audit_type] [nvarchar](2000) NULL,
	[code_audit_type] [nvarchar](2000) NULL,
	[label_audit_type] [nvarchar](2000) NULL,
	[id_type] [nvarchar](250) NULL,
	[type_type] [nvarchar](250) NULL,
	[code_type] [nvarchar](250) NULL,
	[label_type] [nvarchar](250) NULL,
	[activityDisciplineCode] [nvarchar](200) NULL,
	[activityDiscipline] [nvarchar](200) NULL,
	[id_status] [nvarchar](250) NULL,
	[type_status] [nvarchar](250) NULL,
	[code_status] [nvarchar](250) NULL,
	[label_status] [nvarchar](250) NULL,
	[Score] [numeric](12, 2) NULL,
	[findingsNumber] [int] NULL,
	[comment] [varchar](1) NULL,
	[realizationDate] [datetime] NULL,
	[plannedDate] [datetime] NULL,
	[creationDate] [varchar](1) NULL,
	[updateDate] [varchar](1) NULL,
	[JPassProjectID] [int] NULL,
	[trafficLight] [nvarchar](4000) NULL,
	[qa_source_id] [nvarchar](20) NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vQaglobalpin]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vQaglobalpin](
	[comment] [varchar](1) NULL,
	[id_global_pins] [varchar](1) NULL,
	[month] [int] NULL,
	[year] [varchar](4) NULL,
	[openGlobalPins] [int] NULL,
	[closedGlobalPins] [int] NULL,
	[averageOpenDays] [int] NULL,
	[overduePinsNumber] [int] NULL,
	[creation_date_global] [varchar](1) NULL,
	[update_date_global] [varchar](1) NULL,
	[projectId] [int] NULL,
	[name] [nvarchar](250) NULL,
	[EndDate] [datetime] NULL,
	[id_pins] [varchar](1) NULL,
	[openPins] [int] NULL,
	[closedPins] [int] NULL,
	[id_enum] [nvarchar](250) NULL,
	[type] [nvarchar](250) NULL,
	[code] [nvarchar](250) NULL,
	[label] [nvarchar](250) NULL,
	[creationDate_pin] [varchar](1) NULL,
	[updateDate_pin] [varchar](1) NULL,
	[low] [int] NULL,
	[Medium] [int] NULL,
	[High] [int] NULL,
	[veryHigh] [int] NULL,
	[creation_date_risk] [varchar](1) NULL,
	[modified_date_risk] [varchar](1) NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vQapassgate]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vQapassgate](
	[id] [varchar](1) NULL,
	[id_status] [nvarchar](250) NULL,
	[type_status] [nvarchar](250) NULL,
	[code_status] [nvarchar](250) NULL,
	[label_status] [nvarchar](250) NULL,
	[comment] [varchar](1) NULL,
	[plannedDate] [datetime] NULL,
	[JPassProjectID] [int] NULL,
	[id_passgate] [nvarchar](250) NULL,
	[type_passgate] [nvarchar](250) NULL,
	[code_passgate] [nvarchar](250) NULL,
	[label_passgate] [nvarchar](250) NULL,
	[creationDate_passgate] [varchar](1) NULL,
	[updateDate_passgate] [varchar](1) NULL,
	[creation_date_status] [varchar](1) NULL,
	[updateDate_status] [varchar](1) NULL,
	[id_result] [nvarchar](250) NULL,
	[type_result] [nvarchar](250) NULL,
	[code_result] [nvarchar](250) NULL,
	[label_result] [nvarchar](250) NULL,
	[creation_date_result] [varchar](1) NULL,
	[updateDate_result] [varchar](1) NULL,
	[actualDate] [datetime] NULL,
	[ActivityScore] [numeric](12, 2) NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[vQasurvey]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[vQasurvey](
	[ActivitySK] [int] NULL,
	[ActivityScore] [numeric](12, 2) NULL,
	[pinsNumber] [int] NULL,
	[comment] [varchar](1) NULL,
	[realizationDate] [datetime] NULL,
	[plannedDate] [datetime] NULL,
	[attachement] [varchar](1) NULL,
	[projectId] [int] NULL,
	[ActivityCompletedDate] [datetime] NULL,
	[qa_source_id] [nvarchar](20) NULL,
	[Batch_Date] [date] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[qa2_qa_audits]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[qa2_qa_audits](
	[id] [int] NOT NULL,
	[type] [int] NULL,
	[realization_date] [date] NULL,
	[score] [numeric](12, 2) NULL,
	[id_project] [int] NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[comment] [nvarchar](max) NULL,
	[findings_number] [numeric](12, 2) NULL,
	[planned_date] [date] NULL,
	[status] [int] NULL,
	[audit_type] [int] NULL,
	[traffic_light] [nvarchar](max) NULL,
	[discipline] [int] NULL,
	[qa_source_id] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[qa2_qa_surveys]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[qa2_qa_surveys](
	[id] [int] NOT NULL,
	[realization_date] [date] NULL,
	[score] [numeric](5, 2) NULL,
	[attachment] [nvarchar](max) NULL,
	[id_project] [int] NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[comment] [nvarchar](max) NULL,
	[pins_number] [numeric](12, 2) NULL,
	[planned_date] [date] NOT NULL,
	[last_ces_date] [date] NULL,
	[attachment_name] [nvarchar](max) NULL,
	[qa_source_id] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[qa2_qa_pass_gate]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[qa2_qa_pass_gate](
	[id] [int] NOT NULL,
	[id_project] [int] NULL,
	[comment] [nvarchar](max) NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[pass_gate] [int] NULL,
	[result] [int] NULL,
	[planned_date] [date] NULL,
	[actual_date] [date] NULL,
	[project_deliverables] [numeric](12, 2) NULL,
	[status] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[qa2_qa_global_pin]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[qa2_qa_global_pin](
	[id] [int] NOT NULL,
	[month] [int] NOT NULL,
	[year] [int] NOT NULL,
	[average_open_days] [numeric](10, 2) NULL,
	[comment] [nvarchar](max) NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[id_project] [int] NULL,
	[overdue_pins_number] [numeric](12, 2) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[qa2_qa_global_pin_detail]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[qa2_qa_global_pin_detail](
	[id] [int] NOT NULL,
	[open_pins] [numeric](10, 2) NULL,
	[closed_pins] [numeric](10, 2) NULL,
	[pins_source] [int] NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[id_global_pin] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [LogBoomi].[v_QA_Monitoring]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [LogBoomi].[v_QA_Monitoring] as 



-- QA AUDIT
SELECT 
	CAST([DWH_Table] as nvarchar(max))+'||'+
	CAST([month] as nvarchar(max)) +'||'+
	CAST([year] as nvarchar(max)) +'||'+
	CAST([qa_source_id] as nvarchar(max)) +'||'+
	CAST([ProjectID] as nvarchar(max)) +'||'+
	CAST([Id_passgate] as nvarchar(max)) +'||'+
	CAST([Id_Enum] as nvarchar(max)) +'||'
	ID,*
FROM(
SELECT 
    N'qa_audits' AS Collab_Table,
    N'vQaaudits' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    N'-' as value_DWH,
    N'-' as value_Collab,
    N'Insert' IntegrationType,
    N'No-KPI' AS KPI,
    N'Insert: QA audits in DWH but not in Collab' reason
FROM 
	STG.LogBoomi.vQaaudits DWH 
left join 
	stg.LogBoomi.qa2_qa_audits C 
on 
	DWH.JPassProjectID = C.id_project and DWH.qa_source_id = C.qa_source_id  and DWH.id_status = C.status and  C.audit_type in (310, 311)
where
	C.id_project is Null

UNION

SELECT 
    N'qa_audits' AS Collab_Table,
    N'vQaaudits' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.Score as NVARCHAR(MAX)) AS value_DWH,
    cast(C.score as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'score' AS KPI,
    N'Update: score in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQaaudits DWH 
inner join 
	stg.LogBoomi.qa2_qa_audits C 
on 
	DWH.JPassProjectID = C.id_project and DWH.qa_source_id = C.	qa_source_id  and DWH.id_status = C.status and  C.audit_type in (310, 311)
where 
	DWH.Score != C.score

UNION

SELECT 
    N'qa_audits' AS Collab_Table,
    N'vQaaudits' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.findingsNumber  as NVARCHAR(MAX)) AS value_DWH,
    cast(C.findings_number  as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'findingsNumber' AS KPI,
    N'Update: findingsNumber in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQaaudits DWH 
inner join 
	stg.LogBoomi.qa2_qa_audits C 
on 
	DWH.JPassProjectID = C.id_project and DWH.qa_source_id = C.	qa_source_id  and DWH.id_status = C.status and  C.audit_type in (310, 311)
where 
	DWH.findingsNumber  != C.findings_number

UNION

SELECT 
    N'qa_audits' AS Collab_Table,
    N'vQaaudits' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.realizationDate as NVARCHAR(MAX)) AS value_DWH,
    cast(C.realization_date as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'realizationDate' AS KPI,
    N'Update: realizationDate in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQaaudits DWH 
inner join 
	stg.LogBoomi.qa2_qa_audits C 
on 
	DWH.JPassProjectID = C.id_project and DWH.qa_source_id = C.	qa_source_id  and DWH.id_status = C.status and  C.audit_type in (310, 311)
where 
	DWH.realizationDate  != C.realization_date

UNION

SELECT 
    N'qa_audits' AS Collab_Table,
    N'vQaaudits' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.plannedDate as NVARCHAR(MAX)) AS value_DWH,
    cast(C.planned_date as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'plannedDate' AS KPI,
    N'Update: plannedDate in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQaaudits DWH 
inner join 
	stg.LogBoomi.qa2_qa_audits C 
on 
	DWH.JPassProjectID = C.id_project and DWH.qa_source_id = C.	qa_source_id  and DWH.id_status = C.status and  C.audit_type in (310, 311)
where 
	DWH.plannedDate  != C.planned_date
	
UNION

--AUDIT TPR	

SELECT 
    N'qa_audits' AS Collab_Table,
    N'vQaaudits_tpr' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    N'-' as value_DWH,
    N'-' as value_Collab,
    N'Insert' IntegrationType,
    N'No-KPI' AS KPI,
    N'Insert: QA audits_tpr in DWH but not in Collab' reason
FROM 
	STG.LogBoomi.vQaaudits_tpr DWH 
left join 
	stg.LogBoomi.qa2_qa_audits C 
on 
	DWH.JPassProjectID = C.id_project and DWH.qa_source_id = C.qa_source_id  and DWH.id_status = C.status and  C.audit_type=312
where
	C.id_project is Null

UNION

SELECT 
    N'qa_audits' AS Collab_Table,
    N'vQaaudits_tpr' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.Score as NVARCHAR(MAX)) AS value_DWH,
    cast(C.score as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'score' AS KPI,
    N'Update: score in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQaaudits_tpr DWH 
inner join 
	stg.LogBoomi.qa2_qa_audits C 
on 
	DWH.JPassProjectID = C.id_project and DWH.qa_source_id = C.qa_source_id  and DWH.id_status = C.status and  C.audit_type=312
where 
	DWH.Score != C.score

UNION

SELECT 
    N'qa_audits' AS Collab_Table,
    N'vQaaudits_tpr' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.findingsNumber  as NVARCHAR(MAX)) AS value_DWH,
    cast(C.findings_number  as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'findingsNumber' AS KPI,
    N'Update: findingsNumber in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQaaudits_tpr DWH 
inner join 
	stg.LogBoomi.qa2_qa_audits C 
on 
	DWH.JPassProjectID = C.id_project and DWH.qa_source_id = C.qa_source_id  and DWH.id_status = C.status and  C.audit_type=312
where 
	DWH.findingsNumber  != C.findings_number

UNION

SELECT 
    N'qa_audits' AS Collab_Table,
    N'vQaaudits_tpr' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.realizationDate as NVARCHAR(MAX)) AS value_DWH,
    cast(C.realization_date as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'realizationDate' AS KPI,
    N'Update: realizationDate in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQaaudits_tpr DWH 
inner join 
	stg.LogBoomi.qa2_qa_audits C 
on 
	DWH.JPassProjectID = C.id_project and DWH.qa_source_id = C.qa_source_id  and DWH.id_status = C.status and  C.audit_type=312
where 
	DWH.realizationDate  != C.realization_date

UNION

SELECT 
    N'qa_audits' AS Collab_Table,
    N'vQaaudits_tpr' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.plannedDate as NVARCHAR(MAX)) AS value_DWH,
    cast(C.planned_date as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'plannedDate' AS KPI,
    N'Update: plannedDate in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQaaudits_tpr DWH 
inner join 
	stg.LogBoomi.qa2_qa_audits C 
on 
	DWH.JPassProjectID = C.id_project and DWH.qa_source_id = C.qa_source_id  and DWH.id_status = C.status and  C.audit_type=312
where 
	DWH.plannedDate  != C.planned_date
	
---- START OF PASS GATE
UNION	
	
SELECT
    N'qa_pass_gate' AS Collab_Table,
    N'vQapassgate' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    N'-' as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    cast(DWH.id_passgate  as NVARCHAR(MAX)) AS Id_passgate,
 	N'-' as Id_Enum,
    N'-' as value_DWH,
    N'-' as value_Collab,
    N'Insert' IntegrationType,
    N'No-KPI' AS KPI,
    N'Insert: vQapassgate in DWH but not in Collab' reason
FROM 
	STG.LogBoomi.vQapassgate DWH 
left join 
	stg.LogBoomi.qa2_qa_pass_gate C 
on 
	DWH.JPassProjectID = C.id_project and DWH.id_passgate  = C.pass_gate 
where 
	C.id_project is null

UNION
	
SELECT
    N'qa_pass_gate' AS Collab_Table,
    N'vQapassgate' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    N'-' as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    cast(DWH.id_passgate as NVARCHAR(MAX)) AS Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.plannedDate  as NVARCHAR(MAX)) AS value_DWH,
    cast(C.planned_date  as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'plannedDate' AS KPI,
    N'update: PlannedDate in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQapassgate DWH 
inner join 
	stg.LogBoomi.qa2_qa_pass_gate C 
on 
	DWH.JPassProjectID = C.id_project and DWH.id_passgate  = C.pass_gate 
where 
	DWH.plannedDate  != C.planned_date
	
UNION

SELECT
    N'qa_pass_gate' AS Collab_Table,
    N'vQapassgate' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    N'-' as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    cast(DWH.id_passgate as NVARCHAR(MAX)) AS Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.actualDate  as NVARCHAR(MAX)) AS value_DWH,
    cast(C.actual_date  as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'actualDate' AS KPI,
    N'update: actualDate in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQapassgate DWH 
inner join 
	stg.LogBoomi.qa2_qa_pass_gate C 
on 
	DWH.JPassProjectID = C.id_project and DWH.id_passgate  = C.pass_gate 
where 
	DWH.actualDate  != C.actual_date 

UNION
	
SELECT
    N'qa_pass_gate' AS Collab_Table,
    N'vQapassgate' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    N'-' as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    cast(DWH.id_passgate as NVARCHAR(MAX)) AS Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.id_status as NVARCHAR(MAX)) AS value_DWH,
    cast(C.status  as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'id_status' AS KPI,
    N'update: id_status in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQapassgate DWH 
inner join 
	stg.LogBoomi.qa2_qa_pass_gate C 
on 
	DWH.JPassProjectID = C.id_project and DWH.id_passgate  = C.pass_gate 
where 
	DWH.id_status  != C.status  

UNION

SELECT
    N'qa_pass_gate' AS Collab_Table,
    N'vQapassgate' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    N'-' as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    cast(DWH.id_passgate as NVARCHAR(MAX)) AS Id_passgate,
    N'-' as Id_Enum,
    cast(dwh.id_result as NVARCHAR(MAX)) AS value_DWH,
    cast(C.[result] as NVARCHAR(MAX)) AS value_Collab,
    N'Update' IntegrationType,
    N'id_result' AS KPI,
    N'update: id_result in DWH different than Collab' reason
FROM 
	STG.LogBoomi.vQapassgate DWH 
inner join 
	stg.LogBoomi.qa2_qa_pass_gate C 
on 
	DWH.JPassProjectID = C.id_project and DWH.id_passgate  = C.pass_gate 
where 
	DWH.id_result  != C.[result] 

UNION
	
--- start of QA survey
	
SELECT
    N'qa2_qa_surveys' AS Collab_Table,
    N'vQasurvey' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
	N'-' as  DWHValue,
	N'-' as  CollabValue,
	N'Insert' IntegrationType,
    N'plannedDate' AS KPI,
    N'Insert: Qasurvey in DWH but not in Collab' reason
FROM 
	STG.LogBoomi.vQasurvey DWH 
LEFT join 
	stg.LogBoomi.qa2_qa_surveys C 
on 
	DWH.projectId = C.id_project  and DWH.qa_source_id  = C.qa_source_id 
where
	C.id_project is NULL
	
UNION

SELECT
    N'qa2_qa_surveys' AS Collab_Table,
    N'vQasurvey' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    CAST (dwh.plannedDate AS NVARCHAR(MAX)) AS value_DWH,
   	CAST (C.planned_date  AS NVARCHAR(MAX)) AS value_Collab,
	N'Update' IntegrationType,
    N'plannedDate' AS KPI,
    N'Update: plannedDate in DWH different than collab' reason
FROM 
	STG.LogBoomi.vQasurvey DWH 
inner join 
	stg.LogBoomi.qa2_qa_surveys C 
on 
	DWH.projectId = C.id_project  and DWH.qa_source_id  = C.qa_source_id 
where
	DWH.plannedDate  != C.planned_date 
	
UNION

SELECT
    N'qa2_qa_surveys' AS Collab_Table,
    N'vQasurvey' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    CAST (dwh.realizationDate  AS NVARCHAR(MAX)) AS value_DWH,
   	CAST (C.realization_date  AS NVARCHAR(MAX)) AS value_Collab,
	N'Update' IntegrationType,
    N'realizationDate' AS KPI,
    N'Update: realizationDate in DWH different than collab' reason
FROM 
	STG.LogBoomi.vQasurvey DWH 
inner join 
	stg.LogBoomi.qa2_qa_surveys C 
on 
	DWH.projectId = C.id_project  and DWH.qa_source_id  = C.qa_source_id 
where
	DWH.realizationDate  != C.realization_date 
	
UNION

SELECT
    N'qa2_qa_surveys' AS Collab_Table,
    N'vQasurvey' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    CAST (dwh.ActivityScore AS NVARCHAR(MAX)) AS value_DWH,
   	CAST (C.score  AS NVARCHAR(MAX)) AS value_Collab,
	N'Update' IntegrationType,
    N'ActivityScore' AS KPI,
    N'Update: ActivityScore in DWH different than collab' reason
FROM 
	STG.LogBoomi.vQasurvey DWH 
inner join 
	stg.LogBoomi.qa2_qa_surveys C 
on 
	DWH.projectId = C.id_project  and DWH.qa_source_id  = C.qa_source_id 
where
	DWH.ActivityScore  != C.score  

UNION

SELECT
    N'qa2_qa_surveys' AS Collab_Table,
    N'vQasurvey' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
    CAST (dwh.pinsNumber AS NVARCHAR(MAX)) AS value_DWH,
   	CAST (C.pins_number  AS NVARCHAR(MAX)) AS value_Collab,
   	N'Update' IntegrationType,
    N'pinsNumber' AS KPI,
    N'Update: pinsNumber in DWH different than collab' reason
FROM 
	STG.LogBoomi.vQasurvey DWH 
inner join 
	stg.LogBoomi.qa2_qa_surveys C 
on 
	DWH.projectId = C.id_project  and DWH.qa_source_id  = C.qa_source_id 
where
	DWH.pinsNumber  != C.pins_number 
	
--QA GLOBAL PIN 

UNION

SELECT
    N'qa_global_pins/details_joined' AS Collab_Table,
    N'vQaglobalpin' AS DWH_Table,
	Cast(DWH.[month] as NVARCHAR(MAX))as [month],
    Cast(DWH.[year] as NVARCHAR(MAX)) as [year],
    N'-' as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    Cast(DWH.id_enum as nvarchar(max)) as Id_Enum,
	N'-' as DWHValue,
	N'-' as CollabValue,
	N'Insert' IntegrationType,
    N'No-KPI' AS KPI,
    N'Insert: QA Global Pin in DWH but not in collab' reason
FROM 
	STG.LogBoomi.vQaglobalpin DWH 
left join 
	(stg.LogBoomi.qa2_qa_global_pin qgp  left join stg.LogBoomi.qa2_qa_global_pin_detail qgpd on  qgp.id = qgpd.id_global_pin) 
on 
	DWH.projectId = qgp.id_project  and DWH.id_enum = qgpd.pins_source  and dwh.month= qgp.month and dwh.year = qgp.year 
where
	qgp.id_project is NULL
	
UNION 
 
SELECT
    N'qa_global_pins/details_joined' AS Collab_Table,
    N'vQaglobalpin' AS DWH_Table,
	Cast(DWH.[month] as NVARCHAR(MAX))as [month],
    Cast(DWH.[year] as NVARCHAR(MAX)) as [year],
    N'-' as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    Cast(DWH.id_enum as nvarchar(max)) as Id_Enum,
	cast(DWH.averageOpendays as nvarchar(max)) DWHValue,
	cast(qgp.average_open_days as nvarchar(max)) CollabValue,
   	N'Update' IntegrationType,
    N'averageOpendays' AS KPI,
    N'Update: averageOpendays in DWH different that collab' reason
FROM 
	STG.LogBoomi.vQaglobalpin DWH 
inner join 
	(stg.LogBoomi.qa2_qa_global_pin qgp  left join stg.LogBoomi.qa2_qa_global_pin_detail qgpd on  qgp.id = qgpd.id_global_pin) 
on 
	DWH.projectId = qgp.id_project  and DWH.id_enum = qgpd.pins_source  and dwh.month= qgp.month and dwh.year = qgp.year 
where
	DWH.averageOpendays  != qgp.average_open_days
	
union 
	
SELECT
    N'qa_global_pins/details_joined' AS Collab_Table,
    N'vQaglobalpin' AS DWH_Table,
	Cast(DWH.[month] as NVARCHAR(MAX))as [month],
    Cast(DWH.[year] as NVARCHAR(MAX)) as [year],
    N'-' as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    Cast(DWH.id_enum as nvarchar(max)) as Id_Enum,
	cast(dwh.overduePinsNumber as nvarchar(50)) DWHValue,
	cast(qgp.overdue_pins_number as nvarchar(50)) CollabValue,
   	N'Update' IntegrationType,
    N'overduePinsNumber' AS KPI,
    N'Update: overduePinsNumber in DWH different that collab' reason
FROM 
	STG.LogBoomi.vQaglobalpin DWH 
inner join 
	(stg.LogBoomi.qa2_qa_global_pin qgp  left join stg.LogBoomi.qa2_qa_global_pin_detail qgpd on  qgp.id = qgpd.id_global_pin)
on 
	DWH.projectId = qgp.id_project and DWH.id_enum = qgpd.pins_source  and dwh.month= qgp.month and dwh.year = qgp.year 
where
	DWH.overduePinsNumber  != qgp.overdue_pins_number
	
union 

SELECT
    N'qa_global_pins/details_joined' AS Collab_Table,
    N'vQaglobalpin' AS DWH_Table,
	Cast(DWH.[month] as NVARCHAR(MAX))as [month],
    Cast(DWH.[year] as NVARCHAR(MAX)) as [year],
    N'-' as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    Cast(DWH.id_enum as nvarchar(max)) as Id_Enum,
	cast(DWH.openGlobalPins as nvarchar(max)) DWHValue,
	cast(qgpd.open_pins as nvarchar(max)) CollabValue,
   	N'Update' IntegrationType,
    N'OpenGlobalPins' AS KPI,
    N'Update: OpenGlobalPins in DWH different that collab' reason
FROM 
	STG.LogBoomi.vQaglobalpin DWH 
inner join 
	(stg.LogBoomi.qa2_qa_global_pin qgp  left join stg.LogBoomi.qa2_qa_global_pin_detail qgpd on  qgp.id = qgpd.id_global_pin)
on 
	DWH.projectId = qgp.id_project and DWH.id_enum = qgpd.pins_source  and dwh.month= qgp.month and dwh.year = qgp.year 
where
	DWH.openGlobalPins  != qgpd.open_pins

union

SELECT
    N'qa_global_pins/details_joined' AS Collab_Table,
    N'vQaglobalpin' AS DWH_Table,
	Cast(DWH.[month] as NVARCHAR(MAX))as [month],
    Cast(DWH.[year] as NVARCHAR(MAX)) as [year],
    N'-' as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    Cast(DWH.id_enum as nvarchar(max)) as Id_Enum,
	cast(DWH.closedGlobalPins as nvarchar(max)) DWHValue,
	cast(qgpd.closed_pins as nvarchar(max)) CollabValue,
   	N'Update' IntegrationType,
    N'closedGlobalPins' AS KPI,
    N'Update: closedGlobalPins in DWH different that collab' reason
FROM 
	STG.LogBoomi.vQaglobalpin DWH 
inner join 
	(stg.LogBoomi.qa2_qa_global_pin qgp  left join stg.LogBoomi.qa2_qa_global_pin_detail qgpd on  qgp.id = qgpd.id_global_pin)
on 
	DWH.projectId = qgp.id_project and DWH.id_enum = qgpd.pins_source  and dwh.month= qgp.month and dwh.year = qgp.year 
where
	DWH.closedGlobalPins  != qgpd.closed_pins
	
UNION

--- ALL SENT DATA 

SELECT 
    N'-' AS Collab_Table,
    N'vQaaudits' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
   	CAST(NULL AS nvarchar(50)) AS DWHValue,
    CAST(NULL AS nvarchar(50)) AS CollabValue,
    N'Original Data' IntegrationType,
    N'QA Audits' AS KPI,
    N'Sent Document' reason
FROM 
	STG.LogBoomi.vQaaudits DWH     

UNION ALL 

SELECT 
    N'-' AS Collab_Table,
    N'vQaaudits_tpr' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
   	CAST(NULL AS nvarchar(50)) AS DWHValue,
    CAST(NULL AS nvarchar(50)) AS CollabValue,
    N'Original Data' IntegrationType,
    N'QA Audits TPR' AS KPI,
    N'Sent Document' reason
FROM 
	STG.LogBoomi.vQaaudits_tpr DWH
	
UNION ALL
    
SELECT
    N'-' AS Collab_Table,
    N'vQapassgate' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    N'-' as qa_source_id,
    cast(DWH.JPassProjectID as NVARCHAR(MAX)) AS ProjectID,
    cast(DWH.id_passgate as NVARCHAR(MAX)) AS Id_passgate,
    N'-' as Id_Enum,
   	CAST(NULL AS nvarchar(50)) AS DWHValue,
    CAST(NULL AS nvarchar(50)) AS CollabValue,
    N'Original Data' IntegrationType,
    N'Pass Gate' AS KPI,
    N'Sent Document' reason
FROM 
	STG.LogBoomi.vQapassgate DWH 

UNION ALL

SELECT
    N'-' AS Collab_Table,
    N'vQasurvey' AS DWH_Table,
    N'-' as [month],
    N'-' as [year],
    Cast(DWH.qa_source_id as nvarchar(max)) as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    N'-' as Id_Enum,
   	CAST(NULL AS nvarchar(50)) AS DWHValue,
    CAST(NULL AS nvarchar(50)) AS CollabValue,
   	N'Original Data' IntegrationType,
    N'Survey' AS KPI,
    N'Sent Document' reason
FROM 
	STG.LogBoomi.vQasurvey DWH 
	
UNION ALL
    
SELECT
    N'-' AS Collab_Table,
    N'vQaglobalpin' AS DWH_Table,
	Cast(DWH.[month] as NVARCHAR(MAX)) as [month],
    Cast(DWH.[year] as NVARCHAR(MAX)) as [year],
    N'-' as qa_source_id,
    Cast(DWH.projectId as nvarchar(max)) as ProjectID,
    N'-' as Id_passgate,
    Cast(DWH.id_enum as nvarchar(max)) as Id_Enum,
   	CAST(NULL AS nvarchar(50)) AS DWHValue,
    CAST(NULL AS nvarchar(50)) AS CollabValue,
   	N'Original Data' IntegrationType,
    N'Global Pin' AS KPI,
    N'Sent Document' reason
FROM 
	STG.LogBoomi.vQaglobalpin DWH )x

;

GO
/****** Object:  Table [DS].[jpass_certificate]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_certificate](
	[id] [nvarchar](2000) NULL,
	[title] [nvarchar](2000) NULL,
	[description] [nvarchar](2000) NULL,
	[confidential] [nvarchar](2000) NULL,
	[medical] [nvarchar](2000) NULL,
	[type_certificate] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_certification]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [DS].[v_jpass_certification]
AS SELECT cr.id AS certificate_id,
    cr.title AS certificate_title,
    cr.description AS certificate_description,
    cr.confidential AS certificate_confidential,
    cr.medical AS certificate_medical,
    e.label AS certificate_type_label
   FROM DS.jpass_certificate cr
     LEFT JOIN ds.jpass_enumeration e ON e.id = cr.type_certificate 

GO
/****** Object:  Table [DS].[jpass_construction_equipment]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_construction_equipment](
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[brand] [nvarchar](2000) NULL,
	[serial_number] [nvarchar](2000) NULL,
	[type] [nvarchar](2000) NULL,
	[matriculation] [nvarchar](2000) NULL,
	[lifting_equip] [nvarchar](2000) NULL,
	[more_information] [nvarchar](2000) NULL,
	[photo] [nvarchar](2000) NULL,
	[qr_code] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[longitude] [nvarchar](2000) NULL,
	[latitude] [nvarchar](2000) NULL,
	[upload_id] [nvarchar](2000) NULL,
	[company] [nvarchar](2000) NULL,
	[subcontractor] [nvarchar](2000) NULL,
	[linked_all_contracts] [nvarchar](2000) NULL,
	[construction_equipment_name] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_company_equipement]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [DS].[v_jpass_company_equipement] as 
SELECT distinct  cast(e.id as int) equipment_id
     
	  ,en.id enum_type
      ,e.company company_id
	  ,e.subcontractor subcontractor_id
  FROM ds.JPASS_construction_equipment e
  left outer join ds.jpass_enumeration en on en.id = e.type

GO
/****** Object:  View [DS].[v_jpass_construction_equipement]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [DS].[v_jpass_construction_equipement] as 
SELECT  cast(e.id as int) id
      ,name
      ,brand
      ,serial_number
	  ,en.label
	  ,en.type
      ,matriculation
      ,lifting_equip
      ,more_information
      ,photo
      ,qr_code
      ,cast(left(e.creation_date,23) as datetime) creation_date
      ,cast(left(e.update_date,23) as datetime) update_date
      ,longitude
      ,latitude
      ,upload_id
      ,cc.name_sub company
	  ,cs.name_sub subcontractor
      ,linked_all_contracts
      ,construction_equipment_name
  FROM ds.JPASS_construction_equipment e
  left outer join ds.jpass_enumeration en on en.id = e.type
  left outer join ds.jpass_contractor_sub_contractor cc on e.company = cc.id  
  left outer join ds.jpass_contractor_sub_contractor cs on e.subcontractor = cs.id



GO
/****** Object:  Table [DS].[jpass_employee_certificate]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_employee_certificate](
	[id] [nvarchar](2000) NULL,
	[certificate_id] [nvarchar](2000) NULL,
	[employee_id] [nvarchar](2000) NULL,
	[certificate_expiring_date] [nvarchar](2000) NULL,
	[certificate_date] [nvarchar](2000) NULL,
	[accredited_organization] [nvarchar](2000) NULL,
	[apt] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[company] [nvarchar](2000) NULL,
	[file] [nvarchar](2000) NULL,
	[validation_comment] [nvarchar](2000) NULL,
	[validation_status_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_emp_certificates]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [DS].[v_jpass_emp_certificates]
AS SELECT ec.id AS employee_certificate_id,
    e.id AS employee_id,
    e.unique_reference AS employee_unique_reference,
    ctr.id AS company_id,
    ctr.name_sub AS company_name,
    cr.id AS certificate_id,
    ec.certificate_date,
    ec.accredited_organization AS certificate_accredited_organization,
    ec.apt AS certificate_apt,
    vcr.code AS certificate_validation_status_code,
    vcr.label_validation  AS certificate_validation_status,
    ec.certificate_expiring_date
   FROM ds.jpass_employee_certificate ec
     LEFT JOIN ds.jpass_employee e ON ec.employee_id = e.id
     LEFT JOIN ds.jpass_certificate cr ON cr.id = ec.certificate_id
     LEFT JOIN ds.jpass_association_validation_status vcr ON vcr.id = ec.validation_status_id
     LEFT JOIN ds.jpass_contractor_sub_contractor ctr ON ctr.id = ec.company

GO
/****** Object:  Table [DS].[jpass_contractor_sub_contractor_jobs]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_contractor_sub_contractor_jobs](
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[related_to_construction_machinery] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_country]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_country](
	[id] [nvarchar](2000) NULL,
	[label] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_department]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_department](
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[type] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_employee]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [DS].[v_jpass_employee]
AS SELECT e.id AS employee_id,
    e.unique_reference AS employee_unique_reference,
    emt.label AS employee_type,
    ctr.name_sub AS employee_company_name,
    sctr.name_sub AS employee_subcontractor,
    cscj.name AS employee_job,
    dp.name AS employee_department,
    cnt.label AS employee_country,
    e.city AS employee_city
   FROM ds.jpass_employee e
     LEFT JOIN ds.jpass_enumeration emt ON emt.id = e.employe_type
     LEFT JOIN ds.jpass_contractor_sub_contractor ctr ON ctr.id = e.company
     LEFT JOIN ds.jpass_contractor_sub_contractor sctr ON sctr.id = e.subcontractor
     LEFT JOIN ds.jpass_contractor_sub_contractor_jobs cscj ON cscj.id = e.job
     LEFT JOIN ds.jpass_department dp ON dp.id = e.department
     LEFT JOIN ds.jpass_country cnt ON cnt.id = e.country_origin


GO
/****** Object:  Table [DS].[jpass_employee_area]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_employee_area](
	[id] [nvarchar](2000) NULL,
	[employee_id] [nvarchar](2000) NULL,
	[area_id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_area]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_area](
	[id] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[label] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  View [DS].[v_jpass_employee_area]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  VIEW [DS].[v_jpass_employee_area]
AS SELECT e.id,
    e.unique_reference,
    p.id AS project_id,
    p.name,
    ar.label AS area,
    ar.code AS area_code
   FROM ds.jpass_employee_area ea
     LEFT JOIN ds.jpass_employee e ON e.id = ea.employee_id
     LEFT JOIN ds.collab_project p ON p.id = ea.project_id
     LEFT JOIN ds.collab_area ar ON ar.id = ea.area_id


GO
/****** Object:  UserDefinedFunction [dbo].[getPriorFiscalMonth]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[getPriorFiscalMonth](
    @FiscalMonthInt INT
)
RETURNS TABLE
AS
RETURN

SELECT FiscalMonth
FROM
(
select xx.ID from 
(select 1 as ID, 7 as FiscalMonth union
select 2 as ID, 8 as FiscalMonth union
select 3 as ID, 9 as FiscalMonth union
select 4 as ID, 10 as FiscalMonth union
select 5 as ID, 11 as FiscalMonth union
select 6 as ID, 12 as FiscalMonth union
select 7 as ID, 1 as FiscalMonth union
select 8 as ID, 2 as FiscalMonth union
select 9 as ID, 3 as FiscalMonth union
select 10 as ID, 4 as FiscalMonth union
select 11 as ID, 5 as FiscalMonth union
select 12 as ID, 6 as FiscalMonth)xx
where xx.FiscalMonth=@FiscalMonthInt )x
outer apply (
select distinct FiscalMonth
from (
select 1 as ID, 7 as FiscalMonth union
select 2 as ID, 8 as FiscalMonth union
select 3 as ID, 9 as FiscalMonth union
select 4 as ID, 10 as FiscalMonth union
select 5 as ID, 11 as FiscalMonth union
select 6 as ID, 12 as FiscalMonth union
select 7 as ID, 1 as FiscalMonth union
select 8 as ID, 2 as FiscalMonth union
select 9 as ID, 3 as FiscalMonth union
select 10 as ID, 4 as FiscalMonth union
select 11 as ID, 5 as FiscalMonth union
select 12 as ID, 6 as FiscalMonth)yy
where yy.ID<=x.ID )y 


GO
/****** Object:  Table [DS].[collab_delegation]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_delegation](
	[id] [nvarchar](2000) NULL,
	[project] [nvarchar](2000) NULL,
	[delegant] [nvarchar](2000) NULL,
	[delegate] [nvarchar](2000) NULL,
	[profile] [nvarchar](2000) NULL,
	[start_date] [nvarchar](2000) NULL,
	[end_date] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_discipline]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_discipline](
	[code] [nvarchar](200) NULL,
	[creation_date] [nvarchar](200) NULL,
	[id] [nvarchar](200) NULL,
	[label] [nvarchar](200) NULL,
	[update_date] [nvarchar](200) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_privilege]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_privilege](
	[id] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[label] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_profile_privilege]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_profile_privilege](
	[id] [nvarchar](2000) NULL,
	[profile_id] [nvarchar](2000) NULL,
	[feature_id] [nvarchar](2000) NULL,
	[privilege_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_program_sector]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_program_sector](
	[id] [nvarchar](250) NULL,
	[name] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[type] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_project_details]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_project_details](
	[id] [nvarchar](2000) NULL,
	[engineering_start_date] [nvarchar](2000) NULL,
	[engineering_end_date] [nvarchar](2000) NULL,
	[procurement_start_date] [nvarchar](2000) NULL,
	[procurement_end_date] [nvarchar](2000) NULL,
	[construction_start_date] [nvarchar](2000) NULL,
	[construction_end_date] [nvarchar](2000) NULL,
	[commissioning_start_date] [nvarchar](2000) NULL,
	[commissioning_end_date] [nvarchar](2000) NULL,
	[ops_start_date] [nvarchar](2000) NULL,
	[ops_end_date] [nvarchar](2000) NULL,
	[mes_start_date] [nvarchar](2000) NULL,
	[mes_end_date] [nvarchar](2000) NULL,
	[mee_start_date] [nvarchar](2000) NULL,
	[mee_end_date] [nvarchar](2000) NULL,
	[tar_start_date] [nvarchar](2000) NULL,
	[tar_end_date] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[description] [nvarchar](2000) NULL,
	[summary] [nvarchar](2000) NULL,
	[plot_plan] [nvarchar](2000) NULL,
	[commercial_breakdown] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_project_phase]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_project_phase](
	[id] [nvarchar](50) NULL,
	[phase] [nvarchar](50) NULL,
	[id_project] [nvarchar](50) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_user_cache]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_user_cache](
	[user_mgt_id] [nvarchar](2000) NULL,
	[azure_directory_id] [nvarchar](2000) NULL,
	[first_name] [nvarchar](2000) NULL,
	[last_name] [nvarchar](2000) NULL,
	[display_name] [nvarchar](2000) NULL,
	[mail] [nvarchar](2000) NULL,
	[mobile_phone] [nvarchar](2000) NULL,
	[job_title] [nvarchar](2000) NULL,
	[deleted] [nvarchar](2000) NULL,
	[admin] [nvarchar](2000) NULL,
	[external] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[frozen] [nvarchar](2000) NULL,
	[dpe] [nvarchar](50) NOT NULL,
	[external_role] [nvarchar](2000) NULL,
	[specific_role] [nvarchar](2000) NULL,
	[bu] [nvarchar](2000) NULL,
	[program] [nvarchar](2000) NULL,
	[sector] [nvarchar](2000) NULL,
	[discipline] [nvarchar](2000) NULL,
	[linked_to_all_companies] [nvarchar](2000) NULL,
	[contractors] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_user_project]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_user_project](
	[id] [nvarchar](2000) NULL,
	[id_project] [nvarchar](2000) NULL,
	[id_role] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[id_user] [nvarchar](2000) NULL,
	[id_profile] [nvarchar](2000) NULL,
	[is_deleted] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[collab_work_order]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[collab_work_order](
	[id] [nvarchar](250) NULL,
	[number] [nvarchar](250) NULL,
	[id_project] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[is_overall_work_order] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[contractor_management_contract]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[contractor_management_contract](
	[id] [nvarchar](2000) NULL,
	[contract_number] [nvarchar](2000) NULL,
	[description] [nvarchar](2000) NULL,
	[contract_date] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[validated] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[contractor_management_contractor]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[contractor_management_contractor](
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[management_notification_address] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[contractor_management_contractor_contract]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[contractor_management_contractor_contract](
	[id] [nvarchar](2000) NULL,
	[level] [nvarchar](2000) NULL,
	[lead] [nvarchar](2000) NULL,
	[contract_id] [nvarchar](2000) NULL,
	[contractor_id] [nvarchar](2000) NULL,
	[sub_contractor_id] [nvarchar](2000) NULL,
	[parent_contractor_id] [nvarchar](2000) NULL,
	[parent_sub_contractor_id] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[contractor_management_project_contractor_work_dimension]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[contractor_management_project_contractor_work_dimension](
	[id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[entity] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[contractor_management_project_sub_contractor_work_dimension]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[contractor_management_project_sub_contractor_work_dimension](
	[id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[entity] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[contractor_management_sub_contractor]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[contractor_management_sub_contractor](
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[contractor_management_vendor]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[contractor_management_vendor](
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_attachment]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_attachment](
	[id] [nvarchar](255) NULL,
	[entity_id] [nvarchar](255) NULL,
	[type] [nvarchar](255) NULL,
	[attachment_name] [nvarchar](255) NULL,
	[uploaded_file_name] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NULL,
	[update_date] [nvarchar](255) NULL,
	[attachment_type] [nvarchar](255) NULL,
	[safety_performance_id] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_comment]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_comment](
	[id] [nvarchar](255) NULL,
	[safety_performance_id] [nvarchar](255) NULL,
	[azure_id_owner] [nvarchar](255) NULL,
	[profile_name] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NULL,
	[update_date] [nvarchar](255) NULL,
	[comment] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_enumeration]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_enumeration](
	[id] [nvarchar](255) NOT NULL,
	[type] [nvarchar](255) NULL,
	[code] [nvarchar](255) NULL,
	[label] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NULL,
	[update_date] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_flyway_schema_history]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_flyway_schema_history](
	[installed_rank] [nvarchar](255) NOT NULL,
	[version] [nvarchar](255) NULL,
	[description] [nvarchar](255) NOT NULL,
	[type] [nvarchar](255) NOT NULL,
	[script] [nvarchar](255) NOT NULL,
	[checksum] [nvarchar](255) NULL,
	[installed_by] [nvarchar](255) NOT NULL,
	[installed_on] [nvarchar](255) NOT NULL,
	[execution_time] [nvarchar](255) NOT NULL,
	[success] [nvarchar](10) NOT NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[csp_monitoring_and_inspection]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[csp_monitoring_and_inspection](
	[id] [nvarchar](250) NULL,
	[safety_performance_id] [nvarchar](250) NULL,
	[type] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[planned] [nvarchar](250) NULL,
	[conducted] [nvarchar](250) NULL,
	[raised_action] [nvarchar](250) NULL,
	[closed_action] [nvarchar](250) NULL,
	[cosed_within] [nvarchar](250) NULL,
	[recorded_by_key_persons] [nvarchar](250) NULL,
	[total_sors] [nvarchar](250) NULL,
	[number_of_area] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_contract]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_contract](
	[contract_number] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[id] [nvarchar](250) NULL,
	[description] [nvarchar](250) NULL,
	[contract_date] [nvarchar](250) NULL,
	[project_id] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL,
	[end_date] [varchar](100) NULL,
	[Forecast_date] [varchar](100) NULL,
	[inactive_periods] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_contractor_contract]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_contractor_contract](
	[id] [nvarchar](250) NULL,
	[level] [nvarchar](250) NULL,
	[is_lead] [nvarchar](250) NULL,
	[contract_id] [nvarchar](250) NULL,
	[contractor_id] [nvarchar](250) NULL,
	[parent_id] [nvarchar](250) NULL,
	[creation_date] [nvarchar](250) NULL,
	[update_date] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_delivery]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_delivery](
	[id] [nvarchar](255) NULL,
	[delivery_expected_date] [nvarchar](255) NULL,
	[status] [nvarchar](255) NULL,
	[compliance] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NULL,
	[update_date] [nvarchar](255) NULL,
	[project_id] [nvarchar](255) NULL,
	[ros_date] [nvarchar](255) NULL,
	[actual_ex_works_date] [nvarchar](255) NULL,
	[eta] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_procured_equipment]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_procured_equipment](
	[id] [nvarchar](255) NULL,
	[drawing] [nvarchar](255) NULL,
	[po_number] [nvarchar](255) NULL,
	[type] [nvarchar](255) NULL,
	[brand] [nvarchar](255) NULL,
	[serial_number] [nvarchar](255) NULL,
	[certificate] [nvarchar](255) NULL,
	[area] [nvarchar](255) NULL,
	[latitude] [nvarchar](255) NULL,
	[longitude] [nvarchar](255) NULL,
	[system] [nvarchar](255) NULL,
	[system_number] [nvarchar](255) NULL,
	[description] [nvarchar](255) NULL,
	[quantity] [nvarchar](255) NULL,
	[eta] [nvarchar](255) NULL,
	[delivery_expected_date] [nvarchar](255) NULL,
	[delivery_status] [nvarchar](255) NULL,
	[reception_type] [nvarchar](255) NULL,
	[link] [nvarchar](255) NULL,
	[photo] [nvarchar](255) NULL,
	[main_section] [nvarchar](255) NULL,
	[length] [nvarchar](255) NULL,
	[weight] [nvarchar](255) NULL,
	[size1] [nvarchar](255) NULL,
	[size2] [nvarchar](255) NULL,
	[raw_material] [nvarchar](255) NULL,
	[pipe_class] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NULL,
	[update_date] [nvarchar](255) NULL,
	[qr_code] [nvarchar](255) NULL,
	[ros_date] [nvarchar](255) NULL,
	[actual_ex_works_date] [nvarchar](255) NULL,
	[upload_id] [nvarchar](255) NULL,
	[company] [nvarchar](255) NULL,
	[project_system_id] [nvarchar](255) NULL,
	[frame_number] [nvarchar](255) NULL,
	[po_number_frame_number] [nvarchar](255) NULL,
	[vendor] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_sub_equipment]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_sub_equipment](
	[id] [nvarchar](255) NULL,
	[tag_number] [nvarchar](255) NULL,
	[quantity] [nvarchar](255) NULL,
	[status] [nvarchar](255) NULL,
	[area] [nvarchar](255) NULL,
	[sub_area] [nvarchar](255) NULL,
	[latitude] [nvarchar](255) NULL,
	[longitude] [nvarchar](255) NULL,
	[link] [nvarchar](1000) NULL,
	[procured_equipment_id] [nvarchar](255) NULL,
	[visual_inspection] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NULL,
	[update_date] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_sub_equipment_handover]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_sub_equipment_handover](
	[id] [nvarchar](255) NULL,
	[handover_date] [nvarchar](255) NULL,
	[return_date] [nvarchar](255) NULL,
	[quantity] [nvarchar](255) NULL,
	[returned] [nvarchar](255) NULL,
	[destination_project] [nvarchar](255) NULL,
	[received_by] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NULL,
	[update_date] [nvarchar](255) NULL,
	[sub_equipment_id] [nvarchar](255) NULL,
	[type] [nvarchar](255) NULL,
	[destination_company] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[jpass_task_history]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[jpass_task_history](
	[id] [nvarchar](2000) NULL,
	[task] [nvarchar](2000) NULL,
	[work_area] [nvarchar](2000) NULL,
	[detail] [nvarchar](2000) NULL,
	[start_date] [nvarchar](2000) NULL,
	[end_date] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[construction_equipment_id] [nvarchar](2000) NULL,
	[mobile_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_app_users]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_app_users](
	[id] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[project_admin_data_id] [nvarchar](2000) NULL,
	[user_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_discipline]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_discipline](
	[code] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_program]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_program](
	[update_date] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_project_area]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_project_area](
	[id] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_project_discipline_work_dimension]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_project_discipline_work_dimension](
	[id] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[discipline] [nvarchar](2000) NULL,
	[id_project] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_project_platform]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_project_platform](
	[id] [nvarchar](2000) NULL,
	[platform_id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_project_system]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_project_system](
	[name] [nvarchar](2000) NULL,
	[number] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_user_project]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_user_project](
	[creation_date] [nvarchar](2000) NULL,
	[is_deleted] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[user_id] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[role_id] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_work_location]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_work_location](
	[update_date] [nvarchar](2000) NULL,
	[location] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[work_order_id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[status_id] [nvarchar](2000) NULL,
	[image] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_work_location_work_order]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_work_location_work_order](
	[work_location_id] [nvarchar](2000) NULL,
	[work_order_id] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[project_management_work_order]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[project_management_work_order](
	[id] [nvarchar](2000) NULL,
	[is_overall_work_order] [nvarchar](2000) NULL,
	[number] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_activity_trans]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_activity_trans](
	[activity_id] [int] NULL,
	[project_id] [int] NULL,
	[project_number] [nvarchar](250) NULL,
	[activity_creation_date] [datetime] NULL,
	[activity_update_date] [datetime] NULL,
	[activity_planned_date] [datetime] NULL,
	[activity_conducted_date] [datetime] NULL,
	[activity_completed_date] [datetime] NULL,
	[activity_result] [nvarchar](250) NULL,
	[activity_comment] [nvarchar](2000) NULL,
	[activity_result_code] [nvarchar](250) NULL,
	[activity_result_desc] [nvarchar](250) NULL,
	[activity_status] [nvarchar](250) NULL,
	[activity_status_code] [nvarchar](250) NULL,
	[activity_type] [nvarchar](255) NULL,
	[activity_category] [nvarchar](255) NULL,
	[activity_subcategory] [nvarchar](255) NULL,
	[activity_progress] [nvarchar](255) NULL,
	[activity_discipline] [nvarchar](250) NULL,
	[activity_discipline_code] [nvarchar](250) NULL,
	[activity_creator_id] [nvarchar](250) NULL,
	[activity_responsible_id] [nvarchar](250) NULL,
	[activity_extra_source_id] [nvarchar](250) NULL,
	[report_finding_status] [nvarchar](250) NULL,
	[report_finding_code] [nvarchar](250) NULL,
	[activity_month] [int] NULL,
	[activity_score] [numeric](12, 2) NULL,
	[activity_pre_draft] [nvarchar](250) NULL,
	[activity_to_delete] [nvarchar](250) NULL,
	[finding_very_high] [int] NULL,
	[finding_high] [int] NULL,
	[finding_medium] [int] NULL,
	[finding_low] [int] NULL,
	[finding_opportunity] [int] NULL,
	[css_infos_id] [int] NULL,
	[css_safety] [numeric](17, 2) NULL,
	[css_scope] [numeric](17, 2) NULL,
	[css_communication] [numeric](17, 2) NULL,
	[css_tech_services] [numeric](17, 2) NULL,
	[css_staffing] [numeric](17, 2) NULL,
	[css_schedule] [numeric](17, 2) NULL,
	[css_cost_estimate] [numeric](17, 2) NULL,
	[css_field_services] [numeric](17, 2) NULL,
	[css_supply_mgmt] [numeric](17, 2) NULL,
	[css_mgmt_support] [numeric](17, 2) NULL,
	[activity_rescheduled_date] [datetime] NULL,
	[activity_canceled_date] [datetime] NULL,
	[activity_any_raised_capa] [nvarchar](10) NULL,
	[activity_raised_capa_number] [int] NULL,
	[activity_source_id] [nvarchar](20) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_project_history]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_project_history](
	[id] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[risk] [nvarchar](2000) NULL,
	[size] [nvarchar](2000) NULL,
	[phase] [nvarchar](2000) NULL,
	[type_contract] [nvarchar](2000) NULL,
	[version] [nvarchar](2000) NULL,
	[creation_date] [nvarchar](2000) NULL,
	[update_date] [nvarchar](2000) NULL,
	[commercial_contract] [nvarchar](2000) NULL,
	[project_manager] [nvarchar](2000) NULL,
	[assurance_plan] [nvarchar](2000) NULL,
	[last_update_of_assurance_plan] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[qa_user_cache]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[qa_user_cache](
	[id] [int] NOT NULL,
	[full_name] [nvarchar](255) NULL,
	[job_title] [nvarchar](255) NULL,
	[mail] [nvarchar](255) NULL,
	[mobile_phone] [nvarchar](255) NULL,
	[azure_id] [nvarchar](255) NULL,
	[deleted] [nvarchar](255) NOT NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DS].[user_management_ad_user]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DS].[user_management_ad_user](
	[id] [nvarchar](255) NULL,
	[azure_directory_id] [nvarchar](255) NULL,
	[first_name] [nvarchar](255) NULL,
	[last_name] [nvarchar](255) NULL,
	[mail] [nvarchar](255) NULL,
	[mobile_phone] [nvarchar](255) NULL,
	[job_title] [nvarchar](255) NULL,
	[is_deleted] [nvarchar](255) NULL,
	[is_admin] [nvarchar](255) NULL,
	[creation_date] [nvarchar](255) NULL,
	[update_date] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [ERM].[po_mar]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ERM].[po_mar](
	[Job_run_date] [nvarchar](256) NULL,
	[Size_2] [nvarchar](256) NULL,
	[Size_1] [nvarchar](256) NULL,
	[Uom] [nvarchar](256) NULL,
	[Bom_qty] [nvarchar](256) NULL,
	[Issued_qty] [nvarchar](256) NULL,
	[Shortage_qty] [nvarchar](256) NULL,
	[Discipline_node] [nvarchar](256) NULL,
	[Iso_spool] [nvarchar](256) NULL,
	[Po_no] [nvarchar](256) NULL,
	[Ident_code] [nvarchar](256) NULL,
	[Tag_number] [nvarchar](256) NULL,
	[Ident_description] [nvarchar](256) NULL,
	[Pred_on_site] [nvarchar](256) NULL,
	[Req_no] [nvarchar](256) NULL,
	[Allocated_On_Hand_Qty] [nvarchar](256) NULL,
	[Allocated_Qty] [nvarchar](256) NULL,
	[Allocated_Undelivered_Qty] [nvarchar](256) NULL,
	[Allocation_Number] [nvarchar](256) NULL,
	[Bin_Description] [nvarchar](256) NULL,
	[Bin_id] [nvarchar](256) NULL,
	[BOM_Path] [nvarchar](256) NULL,
	[Commodity_Code] [nvarchar](256) NULL,
	[Location_description] [nvarchar](256) NULL,
	[Location_id] [nvarchar](256) NULL,
	[Project_Description] [nvarchar](256) NULL,
	[Project_ERM_Internal_number] [nvarchar](256) NULL,
	[Reserved_Qty] [nvarchar](256) NULL,
	[Run_Description] [nvarchar](256) NULL,
	[Run_Number] [nvarchar](256) NULL,
	[Site] [nvarchar](256) NULL,
	[Status_HDR] [nvarchar](256) NULL,
	[Status_ITEM] [nvarchar](256) NULL,
	[Project_id] [nvarchar](256) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [ERM].[po_mar_history]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ERM].[po_mar_history](
	[Job_run_date] [nvarchar](256) NULL,
	[Size_2] [nvarchar](256) NULL,
	[Size_1] [nvarchar](256) NULL,
	[Uom] [nvarchar](256) NULL,
	[Bom_qty] [nvarchar](256) NULL,
	[Issued_qty] [nvarchar](256) NULL,
	[Shortage_qty] [nvarchar](256) NULL,
	[Discipline_node] [nvarchar](256) NULL,
	[Iso_spool] [nvarchar](256) NULL,
	[Po_no] [nvarchar](256) NULL,
	[Ident_code] [nvarchar](256) NULL,
	[Tag_number] [nvarchar](256) NULL,
	[Ident_description] [nvarchar](256) NULL,
	[Pred_on_site] [nvarchar](256) NULL,
	[Req_no] [nvarchar](256) NULL,
	[Allocated_On_Hand_Qty] [nvarchar](256) NULL,
	[Allocated_Qty] [nvarchar](256) NULL,
	[Allocated_Undelivered_Qty] [nvarchar](256) NULL,
	[Allocation_Number] [nvarchar](256) NULL,
	[Bin_Description] [nvarchar](256) NULL,
	[Bin_id] [nvarchar](256) NULL,
	[BOM_Path] [nvarchar](256) NULL,
	[Commodity_Code] [nvarchar](256) NULL,
	[Location_description] [nvarchar](256) NULL,
	[Location_id] [nvarchar](256) NULL,
	[Project_Description] [nvarchar](256) NULL,
	[Project_ERM_Internal_number] [nvarchar](256) NULL,
	[Reserved_Qty] [nvarchar](256) NULL,
	[Run_Description] [nvarchar](256) NULL,
	[Run_Number] [nvarchar](256) NULL,
	[Site] [nvarchar](256) NULL,
	[Status_HDR] [nvarchar](256) NULL,
	[Status_ITEM] [nvarchar](256) NULL,
	[Project_id] [nvarchar](256) NULL,
	[Upload_date] [nvarchar](256) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [ERM].[po_tracks]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ERM].[po_tracks](
	[Po] [nvarchar](256) NULL,
	[Po_description] [nvarchar](256) NULL,
	[Po_issue_date] [nvarchar](256) NULL,
	[Po_status] [nvarchar](256) NULL,
	[Po_revision] [nvarchar](256) NULL,
	[Load_list_id] [nvarchar](256) NULL,
	[Vendor_name] [nvarchar](256) NULL,
	[Vendor] [nvarchar](256) NULL,
	[Mrr_no] [nvarchar](256) NULL,
	[Buyer] [nvarchar](256) NULL,
	[Expeditor] [nvarchar](256) NULL,
	[Shipping_point] [nvarchar](256) NULL,
	[Ship_to] [nvarchar](256) NULL,
	[Transit_time_days] [nvarchar](256) NULL,
	[Etd] [nvarchar](256) NULL,
	[Eta] [nvarchar](256) NULL,
	[Ata] [nvarchar](256) NULL,
	[Ros_date] [nvarchar](256) NULL,
	[Requisition] [nvarchar](256) NULL,
	[Requisition_description] [nvarchar](256) NULL,
	[Incoterm] [nvarchar](256) NULL,
	[PO_Pos] [nvarchar](256) NULL,
	[Commodity_code] [nvarchar](256) NULL,
	[Ident_Code] [nvarchar](256) NULL,
	[Unit_price] [nvarchar](256) NULL,
	[Unit_price_currency] [nvarchar](256) NULL,
	[City] [nvarchar](256) NULL,
	[Contact_info1] [nvarchar](256) NULL,
	[Contact_info2] [nvarchar](256) NULL,
	[Contact_info3] [nvarchar](256) NULL,
	[Contact_info4] [nvarchar](256) NULL,
	[Country_code] [nvarchar](256) NULL,
	[Load_List_Qty] [nvarchar](256) NULL,
	[PO_ERM_Internal_number] [nvarchar](256) NULL,
	[PO_Pos_Internal_number] [nvarchar](256) NULL,
	[PO_Qty] [nvarchar](256) NULL,
	[Postal_code] [nvarchar](256) NULL,
	[Project_Description] [nvarchar](256) NULL,
	[Project_ERM_Internal_number] [nvarchar](256) NULL,
	[Project_Id] [nvarchar](256) NULL,
	[Tag_Number] [nvarchar](256) NULL,
	[UOM] [nvarchar](256) NULL,
	[eo] [nvarchar](256) NULL,
	[so] [nvarchar](256) NULL,
	[ident_description] [nvarchar](256) NULL,
	[creation_date] [nvarchar](256) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [ERM].[po_tracks_history]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ERM].[po_tracks_history](
	[Po] [nvarchar](256) NULL,
	[Po_description] [nvarchar](256) NULL,
	[Po_issue_date] [nvarchar](256) NULL,
	[Po_status] [nvarchar](256) NULL,
	[Po_revision] [nvarchar](256) NULL,
	[Load_list_id] [nvarchar](256) NULL,
	[Vendor_name] [nvarchar](256) NULL,
	[Vendor] [nvarchar](256) NULL,
	[Mrr_no] [nvarchar](256) NULL,
	[Buyer] [nvarchar](256) NULL,
	[Expeditor] [nvarchar](256) NULL,
	[Shipping_point] [nvarchar](256) NULL,
	[Ship_to] [nvarchar](256) NULL,
	[Transit_time_days] [nvarchar](256) NULL,
	[Etd] [nvarchar](256) NULL,
	[Eta] [nvarchar](256) NULL,
	[Ata] [nvarchar](256) NULL,
	[Ros_date] [nvarchar](256) NULL,
	[Requisition] [nvarchar](256) NULL,
	[Requisition_description] [nvarchar](256) NULL,
	[Incoterm] [nvarchar](256) NULL,
	[PO_Pos] [nvarchar](256) NULL,
	[Commodity_code] [nvarchar](256) NULL,
	[Ident_Code] [nvarchar](256) NULL,
	[Unit_price] [nvarchar](256) NULL,
	[Unit_price_currency] [nvarchar](256) NULL,
	[City] [nvarchar](256) NULL,
	[Contact_info1] [nvarchar](256) NULL,
	[Contact_info2] [nvarchar](256) NULL,
	[Contact_info3] [nvarchar](256) NULL,
	[Contact_info4] [nvarchar](256) NULL,
	[Country_code] [nvarchar](256) NULL,
	[Load_List_Qty] [nvarchar](256) NULL,
	[PO_ERM_Internal_number] [nvarchar](256) NULL,
	[PO_Pos_Internal_number] [nvarchar](256) NULL,
	[PO_Qty] [nvarchar](256) NULL,
	[Postal_code] [nvarchar](256) NULL,
	[Project_Description] [nvarchar](256) NULL,
	[Project_ERM_Internal_number] [nvarchar](256) NULL,
	[Project_Id] [nvarchar](256) NULL,
	[Tag_Number] [nvarchar](256) NULL,
	[UOM] [nvarchar](256) NULL,
	[eo] [nvarchar](256) NULL,
	[so] [nvarchar](256) NULL,
	[Upload_date] [nvarchar](256) NULL,
	[ident_description] [nvarchar](256) NULL,
	[creation_date] [nvarchar](256) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [HSE].[LOOKUP_COLLAB_HSE]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HSE].[LOOKUP_COLLAB_HSE](
	[collab_project_number] [nvarchar](255) NULL,
	[CollabProjectName] [nvarchar](255) NULL,
	[hse_project_number] [nvarchar](255) NULL,
	[HSE Mapping] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [HSE].[NEFS_Reporting]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HSE].[NEFS_Reporting](
	[Isr] [nvarchar](500) NULL,
	[sector] [nvarchar](500) NULL,
	[raisedActions] [nvarchar](500) NULL,
	[closedActions] [nvarchar](500) NULL,
	[openActions] [nvarchar](500) NULL,
	[OverdueActions] [nvarchar](500) NULL,
	[highWPSopenActions] [nvarchar](500) NULL,
	[overdueHighWPSActions] [nvarchar](500) NULL,
	[behaviourRelated] [nvarchar](500) NULL,
	[conditionsRelated] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [HSE].[NEFS_Reporting_backup]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HSE].[NEFS_Reporting_backup](
	[Isr] [nvarchar](500) NULL,
	[sector] [nvarchar](500) NULL,
	[raisedActions] [nvarchar](500) NULL,
	[closedActions] [nvarchar](500) NULL,
	[openActions] [nvarchar](500) NULL,
	[OverdueActions] [nvarchar](500) NULL,
	[highWPSopenActions] [nvarchar](500) NULL,
	[overdueHighWPSActions] [nvarchar](500) NULL,
	[behaviourRelated] [nvarchar](500) NULL,
	[conditionsRelated] [nvarchar](2000) NULL,
	[week_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [HSE].[Training]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HSE].[Training](
	[ID] [nvarchar](250) NULL,
	[Projectvalue] [nvarchar](250) NULL,
	[CompanyValue] [nvarchar](250) NULL,
	[Submitter] [nvarchar](250) NULL,
	[Trainer] [nvarchar](250) NULL,
	[Training_Date] [nvarchar](250) NULL,
	[Topic] [nvarchar](250) NULL,
	[Hours_of_training] [nvarchar](250) NULL,
	[People_Trained] [nvarchar](250) NULL,
	[Training_Type] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [HSE].[v_SOR_Extended20240719]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HSE].[v_SOR_Extended20240719](
	[ContentTypeID] [nvarchar](max) NULL,
	[Title] [nvarchar](max) NULL,
	[ComplianceAssetId] [nvarchar](max) NULL,
	[Project] [nvarchar](max) NULL,
	[Company] [nvarchar](max) NULL,
	[Date] [datetime] NULL,
	[Submiter] [nvarchar](max) NULL,
	[CriticalRisk] [nvarchar](max) NULL,
	[SubjectValue] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[TypeValue] [nvarchar](max) NULL,
	[GroupValue] [nvarchar](max) NULL,
	[WPS] [nvarchar](max) NULL,
	[Likelihood] [nvarchar](max) NULL,
	[Statut] [nvarchar](max) NULL,
	[ImageBefore] [nvarchar](max) NULL,
	[DateOfClosure] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ImmediatCorrectiveActions] [nvarchar](max) NULL,
	[ImageAfter] [nvarchar](max) NULL,
	[ActionPlan] [nvarchar](max) NULL,
	[Validated] [nvarchar](max) NULL,
	[MailValue] [nvarchar](max) NULL,
	[LocationOfSORValue] [nvarchar](max) NULL,
	[Created] [datetime] NULL,
	[Id] [int] NULL,
	[ContentType] [nvarchar](max) NULL,
	[Modified] [datetime] NULL,
	[CreatedById] [int] NULL,
	[ModifiedById] [int] NULL,
	[Owshiddenversion] [int] NULL,
	[Version] [nvarchar](max) NULL,
	[Path] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[collab_cache_ad_users]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[collab_cache_ad_users](
	[id] [nvarchar](max) NOT NULL,
	[mail] [nvarchar](max) NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[update_date] [datetime2](7) NULL,
	[azure_directory_id] [nvarchar](max) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[collab_client]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[collab_client](
	[id] [int] NOT NULL,
	[name] [nvarchar](max) NOT NULL,
	[creation_date] [datetime2](7) NULL,
	[update_date] [datetime2](7) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[collab_project]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[collab_project](
	[bu_code] [nvarchar](max) NULL,
	[bu_label] [nvarchar](max) NULL,
	[creation_date] [datetime2](7) NOT NULL,
	[forecast_date] [date] NULL,
	[id] [int] NOT NULL,
	[id_client] [int] NULL,
	[client_name] [nvarchar](max) NULL,
	[program_code] [nvarchar](max) NULL,
	[program_label] [nvarchar](max) NULL,
	[sector_code] [nvarchar](max) NULL,
	[sector_label] [nvarchar](max) NULL,
	[kpi_frequency] [int] NULL,
	[name] [nvarchar](max) NOT NULL,
	[number] [nvarchar](max) NOT NULL,
	[start_date] [date] NULL,
	[contractual_end_date] [date] NULL,
	[state_code] [nvarchar](max) NULL,
	[state_label] [nvarchar](max) NULL,
	[type_code] [nvarchar](max) NULL,
	[type_label] [nvarchar](max) NULL,
	[update_date] [datetime2](7) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[Integration_Performance_History]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[Integration_Performance_History](
	[insert_date] [datetime] NULL,
	[system] [nvarchar](max) NULL,
	[DWHViewName] [nvarchar](max) NULL,
	[non_integrated] [int] NULL,
	[sent_data] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[STG_Monitoring]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[STG_Monitoring](
	[BatchDate] [datetime] NULL,
	[table_name] [nvarchar](max) NULL,
	[system] [nvarchar](max) NULL,
	[records] [int] NULL,
	[STG_Date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[v_HR_TIMESHEET_ERROR]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[v_HR_TIMESHEET_ERROR](
	[firstdaymonth] [date] NULL,
	[lastdaymonth] [date] NULL,
	[projectid] [int] NULL,
	[mailcacheaduser] [nvarchar](2000) NULL,
	[firstdayweek] [date] NULL,
	[lastdayweek] [date] NULL,
	[activitydate] [date] NULL,
	[taskname] [nvarchar](100) NULL,
	[Duration] [numeric](38, 2) NULL,
	[isbillable] [varchar](5) NULL,
	[user_deleted] [nvarchar](2000) NULL,
	[azure_directory_id] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[Verano_Monitoring_History_back]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[Verano_Monitoring_History_back](
	[BatchID] [int] NULL,
	[BatchDate] [date] NULL,
	[DWHViewName] [nvarchar](12) NULL,
	[ReportingYear] [int] NULL,
	[ReportingMonth] [int] NULL,
	[isPostCutoff] [int] NULL,
	[TimePeriodYear] [int] NULL,
	[TimePeriodMonth] [int] NULL,
	[project] [int] NULL,
	[workorderid] [int] NULL,
	[id_cost_indicator] [int] NULL,
	[id_cost_discipline] [int] NULL,
	[OriginalData] [int] NULL,
	[InsertData] [int] NULL,
	[UpdateData] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [LogBoomi].[Verano_Monitoring_History_prod]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LogBoomi].[Verano_Monitoring_History_prod](
	[BatchID] [int] NULL,
	[BatchDate] [date] NULL,
	[DWHViewName] [nvarchar](12) NULL,
	[ReportingYear] [int] NULL,
	[ReportingMonth] [int] NULL,
	[isPostCutoff] [int] NULL,
	[TimePeriodYear] [int] NULL,
	[TimePeriodMonth] [int] NULL,
	[project] [int] NULL,
	[workorderid] [int] NULL,
	[id_cost_indicator] [int] NULL,
	[id_cost_discipline] [int] NULL,
	[OriginalData] [int] NULL,
	[InsertData] [int] NULL,
	[UpdateData] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [MASTER].[lookup_project_backup]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MASTER].[lookup_project_backup](
	[Collab_Project_Number] [nvarchar](255) NULL,
	[Project_Name] [nvarchar](255) NULL,
	[Verano_Project_Number] [nvarchar](255) NULL,
	[PC_Project_Number] [nvarchar](100) NULL,
	[HSE_Project_Number] [nvarchar](100) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [MASTER].[lookup_project_collab_pc]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MASTER].[lookup_project_collab_pc](
	[Collab_project_number] [nvarchar](200) NULL,
	[PC_project_number] [nvarchar](200) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [MASTER].[lookup_project_kenza20240109]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MASTER].[lookup_project_kenza20240109](
	[Project number Collab] [nvarchar](255) NULL,
	[PC List (P Number)] [nvarchar](255) NULL,
	[PC List (WBS)_not exhaustive] [nvarchar](255) NULL,
	[PMO List(P Number)] [nvarchar](255) NULL,
	[Project Number QA] [nvarchar](255) NULL,
	[Project Status] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [MASTER].[PROJECT]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MASTER].[PROJECT](
	[project_number] [nvarchar](250) NULL,
	[j_project_id] [int] NULL,
	[q_project_id] [int] NULL,
	[p6_project_id] [int] NULL,
	[hse_project_id] [nvarchar](250) NULL,
	[j_project_bu] [nvarchar](250) NULL,
	[q_project_bu] [nvarchar](250) NULL,
	[q_project_bu_code] [nvarchar](250) NULL,
	[j_project_name] [nvarchar](250) NULL,
	[q_project_name] [nvarchar](250) NULL,
	[j_project_program] [nvarchar](250) NULL,
	[q_project_customer] [nvarchar](250) NULL,
	[q_project_status_code] [nvarchar](250) NULL,
	[q_project_status] [nvarchar](250) NULL,
	[j_project_state] [nvarchar](250) NULL,
	[j_start_date] [datetime] NULL,
	[j_fcst_date] [datetime] NULL,
	[q_project_phase] [nvarchar](250) NULL,
	[q_project_risk] [nvarchar](250) NULL,
	[q_project_sector] [nvarchar](250) NULL,
	[q_project_sector_code] [nvarchar](250) NULL,
	[q_project_size] [nvarchar](250) NULL,
	[p6_project_name] [nvarchar](200) NULL,
	[p6_obsname] [nvarchar](200) NULL,
	[p6_project_status] [nvarchar](200) NULL,
	[p6_fcst_start_date] [datetime] NULL,
	[p6_plan_end_date] [datetime] NULL,
	[p6_scd_end_date] [datetime] NULL,
	[p6_engineeringStartDate] [datetime] NULL,
	[p6_engineeringEndDate] [datetime] NULL,
	[p6_procurementStartDate] [datetime] NULL,
	[p6_procurementEndDate] [datetime] NULL,
	[p6_constructionStartDate] [datetime] NULL,
	[p6_constructionEndDate] [datetime] NULL,
	[p6_commissioningStartDate] [datetime] NULL,
	[p6_commissioningEndDate] [datetime] NULL,
	[q_project_scope] [nvarchar](200) NULL,
	[q_project_lead] [nvarchar](200) NULL,
	[enum_type] [int] NULL,
	[isDeleted] [int] NULL,
	[j_project_sector] [nvarchar](250) NULL,
	[p6_start_date] [datetime] NULL,
	[procore_project_id] [nvarchar](255) NULL,
	[procore_project_name] [nvarchar](255) NULL,
	[procore_program_name] [nvarchar](255) NULL,
	[j_scheduling_frequency] [nvarchar](100) NULL,
	[project_size] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [P6].[ACTIVITY]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[ACTIVITY](
	[objectid] [int] NULL,
	[projectobjectid] [int] NULL,
	[wbsobjectid] [int] NULL,
	[calendarobjectid] [int] NULL,
	[isnewfeedback] [varchar](1) NULL,
	[autocomputeactuals] [varchar](1) NULL,
	[percentcompletetype] [varchar](10) NULL,
	[type] [varchar](18) NULL,
	[durationtype] [varchar](27) NULL,
	[reviewstatus] [varchar](12) NULL,
	[status] [varchar](12) NULL,
	[id] [varchar](40) NULL,
	[name] [varchar](120) NULL,
	[primaryresourceobjectid] [int] NULL,
	[totalfloat] [numeric](17, 6) NULL,
	[freefloat] [numeric](17, 6) NULL,
	[remainingduration] [numeric](17, 6) NULL,
	[actuallaborunits] [numeric](17, 6) NULL,
	[remaininglaborunits] [numeric](17, 6) NULL,
	[plannedlaborunits] [numeric](17, 6) NULL,
	[plannedduration] [numeric](17, 6) NULL,
	[plannednonlaborunits] [numeric](17, 6) NULL,
	[actualnonlaborunits] [numeric](17, 6) NULL,
	[remainingnonlaborunits] [numeric](17, 6) NULL,
	[primaryconstraintdate] [datetime] NULL,
	[actualstartdate] [datetime] NULL,
	[actualfinishdate] [datetime] NULL,
	[latestartdate] [datetime] NULL,
	[latefinishdate] [datetime] NULL,
	[expectedfinishdate] [datetime] NULL,
	[earlystartdate] [datetime] NULL,
	[earlyfinishdate] [datetime] NULL,
	[remainingearlystartdate] [datetime] NULL,
	[remainingearlyfinishdate] [datetime] NULL,
	[plannedstartdate] [datetime] NULL,
	[plannedfinishdate] [datetime] NULL,
	[reviewfinishdate] [datetime] NULL,
	[remaininglatestartdate] [datetime] NULL,
	[remaininglatefinishdate] [datetime] NULL,
	[primaryconstrainttype] [varchar](19) NULL,
	[levelingpriority] [varchar](12) NULL,
	[secondaryconstraintdate] [datetime] NULL,
	[secondaryconstrainttype] [varchar](19) NULL,
	[floatpath] [int] NULL,
	[floatpathorder] [int] NULL,
	[actualthisperiodlaborunits] [numeric](17, 6) NULL,
	[actualthisperiodnonlaborunits] [numeric](17, 6) NULL,
	[islongestpath] [varchar](1) NULL,
	[suspenddate] [datetime] NULL,
	[resumedate] [datetime] NULL,
	[externalearlystartdate] [datetime] NULL,
	[externallatefinishdate] [datetime] NULL,
	[accountingvariance] [numeric](28, 10) NULL,
	[accountingvariancelaborunits] [numeric](28, 10) NULL,
	[actualduration] [numeric](28, 10) NULL,
	[actualexpensecost] [numeric](28, 10) NULL,
	[actuallaborcost] [numeric](28, 10) NULL,
	[actualmaterialcost] [numeric](28, 10) NULL,
	[actualnonlaborcost] [numeric](28, 10) NULL,
	[actualthisperiodlaborcost] [numeric](28, 10) NULL,
	[actualthisperiodmaterialcost] [numeric](28, 10) NULL,
	[actualthisperiodnonlaborcost] [numeric](28, 10) NULL,
	[actualtotalcost] [numeric](28, 10) NULL,
	[actualtotalunits] [numeric](28, 10) NULL,
	[atcompletionduration] [numeric](28, 10) NULL,
	[atcompletionexpensecost] [numeric](28, 10) NULL,
	[atcompletionlaborcost] [numeric](28, 10) NULL,
	[atcompletionlaborunits] [numeric](28, 10) NULL,
	[atcompletionlaborunitsvariance] [numeric](28, 10) NULL,
	[atcompletionmaterialcost] [numeric](28, 10) NULL,
	[atcompletionnonlaborcost] [numeric](28, 10) NULL,
	[atcompletionnonlaborunits] [numeric](28, 10) NULL,
	[atcompletiontotalcost] [numeric](28, 10) NULL,
	[atcompletiontotalunits] [numeric](28, 10) NULL,
	[atcompletionvariance] [numeric](28, 10) NULL,
	[baselineduration] [numeric](28, 10) NULL,
	[baselinefinishdate] [datetime] NULL,
	[baselineplannedduration] [numeric](28, 10) NULL,
	[baselineplannedexpensecost] [numeric](28, 10) NULL,
	[baselineplannedlaborcost] [numeric](28, 10) NULL,
	[baselineplannedlaborunits] [numeric](28, 10) NULL,
	[baselineplannedmaterialcost] [numeric](28, 10) NULL,
	[baselineplannednonlaborcost] [numeric](28, 10) NULL,
	[baselineplannednonlaborunits] [numeric](28, 10) NULL,
	[baselineplannedtotalcost] [numeric](28, 10) NULL,
	[baselinestartdate] [datetime] NULL,
	[baselinelatestartdate] [datetime] NULL,
	[baseline1latestartdate] [datetime] NULL,
	[baselinelatefinishdate] [datetime] NULL,
	[baseline1latefinishdate] [datetime] NULL,
	[budgetatcompletion] [numeric](28, 10) NULL,
	[calendarname] [varchar](255) NULL,
	[costpercentcomplete] [numeric](28, 10) NULL,
	[costpercentofplanned] [numeric](28, 10) NULL,
	[costperformanceindex] [numeric](28, 10) NULL,
	[costperformanceindexlaborunits] [numeric](28, 10) NULL,
	[costvariance] [numeric](28, 10) NULL,
	[costvarianceindex] [numeric](28, 10) NULL,
	[costvarianceindexlaborunits] [numeric](28, 10) NULL,
	[costvariancelaborunits] [numeric](28, 10) NULL,
	[datadate] [datetime] NULL,
	[duration1variance] [numeric](28, 10) NULL,
	[durationpercentcomplete] [numeric](28, 10) NULL,
	[durationpercentofplanned] [numeric](28, 10) NULL,
	[durationvariance] [numeric](28, 10) NULL,
	[earnedvaluecost] [numeric](28, 10) NULL,
	[earnedvaluelaborunits] [numeric](28, 10) NULL,
	[estimateatcompletioncost] [numeric](28, 10) NULL,
	[estimateatcompletionlaborunits] [numeric](28, 10) NULL,
	[estimatetocomplete] [numeric](28, 10) NULL,
	[estimatetocompletelaborunits] [numeric](28, 10) NULL,
	[expensecost1variance] [numeric](28, 10) NULL,
	[expensecostpercentcomplete] [numeric](28, 10) NULL,
	[expensecostvariance] [numeric](28, 10) NULL,
	[finishdate] [datetime] NULL,
	[finishdate1variance] [numeric](28, 10) NULL,
	[finishdatevariance] [numeric](28, 10) NULL,
	[iscritical] [varchar](1) NULL,
	[laborcost1variance] [numeric](28, 10) NULL,
	[laborcostpercentcomplete] [numeric](28, 10) NULL,
	[laborcostvariance] [numeric](28, 10) NULL,
	[laborunits1variance] [numeric](28, 10) NULL,
	[laborunitspercentcomplete] [numeric](28, 10) NULL,
	[laborunitsvariance] [numeric](28, 10) NULL,
	[materialcost1variance] [numeric](28, 10) NULL,
	[materialcostpercentcomplete] [numeric](28, 10) NULL,
	[materialcostvariance] [numeric](28, 10) NULL,
	[nonlaborcost1variance] [numeric](28, 10) NULL,
	[nonlaborcostpercentcomplete] [numeric](28, 10) NULL,
	[nonlaborcostvariance] [numeric](28, 10) NULL,
	[nonlaborunits1variance] [numeric](28, 10) NULL,
	[nonlaborunitspercentcomplete] [numeric](28, 10) NULL,
	[nonlaborunitsvariance] [numeric](28, 10) NULL,
	[percentcomplete] [numeric](28, 10) NULL,
	[performancepercentcomplete] [numeric](28, 10) NULL,
	[physicalpercentcomplete] [numeric](28, 10) NULL,
	[plannedexpensecost] [numeric](28, 10) NULL,
	[plannedlaborcost] [numeric](28, 10) NULL,
	[plannedmaterialcost] [numeric](28, 10) NULL,
	[plannednonlaborcost] [numeric](28, 10) NULL,
	[plannedtotalcost] [numeric](28, 10) NULL,
	[plannedtotalunits] [numeric](28, 10) NULL,
	[plannedvaluecost] [numeric](28, 10) NULL,
	[plannedvaluelaborunits] [numeric](28, 10) NULL,
	[primaryresourceid] [varchar](255) NULL,
	[primaryresourcename] [varchar](255) NULL,
	[remainingexpensecost] [numeric](28, 10) NULL,
	[remainingfloat] [numeric](28, 10) NULL,
	[remaininglaborcost] [numeric](28, 10) NULL,
	[remainingmaterialcost] [numeric](28, 10) NULL,
	[remainingnonlaborcost] [numeric](28, 10) NULL,
	[remainingtotalcost] [numeric](28, 10) NULL,
	[remainingtotalunits] [numeric](28, 10) NULL,
	[schedulepercentcomplete] [numeric](28, 10) NULL,
	[scheduleperfindexlaborunits] [numeric](28, 10) NULL,
	[scheduleperformanceindex] [numeric](28, 10) NULL,
	[schedulevariance] [numeric](28, 10) NULL,
	[schedulevarianceindex] [numeric](28, 10) NULL,
	[schedulevariancelaborunits] [numeric](28, 10) NULL,
	[schedulevarindexlaborunits] [numeric](28, 10) NULL,
	[startdate] [datetime] NULL,
	[startdate1variance] [numeric](28, 10) NULL,
	[startdatevariance] [numeric](28, 10) NULL,
	[tocompleteperformanceindex] [numeric](28, 10) NULL,
	[totalcost1variance] [numeric](28, 10) NULL,
	[totalcostvariance] [numeric](28, 10) NULL,
	[unitspercentcomplete] [numeric](28, 10) NULL,
	[wbscode] [varchar](255) NULL,
	[wbsname] [varchar](255) NULL,
	[locationobjectid] [int] NULL,
	[locationname] [varchar](255) NULL,
	[reviewrequired] [varchar](1) NULL,
	[isstarred] [varchar](1) NULL,
	[cbscode] [varchar](1024) NULL,
	[lastupdateuser] [varchar](255) NULL,
	[lastupdatedate] [datetime] NULL,
	[createuser] [varchar](255) NULL,
	[createdate] [datetime] NULL,
	[lastupdatedatex] [datetime] NULL,
	[ActivityOwnerObjectId] [int] NULL,
	[ActivityOwner] [varchar](255) NULL,
	[RPT_CURRENT_FLAG] [varchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [P6].[ACTIVITYCODE]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[ACTIVITYCODE](
	[objectid] [int] NULL,
	[description] [varchar](120) NULL,
	[codetypename] [varchar](255) NULL,
	[projectobjectid] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [P6].[ACTIVITYCODEASSIGNMENT]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[ACTIVITYCODEASSIGNMENT](
	[activityobjectid] [varchar](255) NULL,
	[activitycodetypeobjectid] [varchar](255) NULL,
	[activitycodeobjectid] [varchar](255) NULL,
	[projectobjectid] [varchar](255) NULL,
	[activitycodedescription] [varchar](255) NULL,
	[activitycodetypename] [varchar](255) NULL,
	[activitycodetypescope] [varchar](255) NULL,
	[activitycodevalue] [varchar](255) NULL,
	[activityid] [varchar](255) NULL,
	[activityname] [varchar](255) NULL,
	[issecurecode] [varchar](255) NULL,
	[lastupdateuser] [varchar](255) NULL,
	[lastupdatedate] [varchar](255) NULL,
	[createuser] [varchar](255) NULL,
	[createdate] [varchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [P6].[ACTIVITYSPREAD]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[ACTIVITYSPREAD](
	[ActivityObjectId] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ActivityCode] [varchar](40) NULL,
	[ActivityName] [varchar](120) NULL,
	[WBSObjectId] [int] NULL,
	[projectobjectid] [int] NULL,
	[ActualLaborUnits] [numeric](28, 10) NULL,
	[ActualNonLaborUnits] [numeric](28, 10) NULL,
	[AtCompletionLaborUnits] [numeric](28, 10) NULL,
	[AtCompletionNonLaborUnits] [numeric](28, 10) NULL,
	[BaselineActualLaborUnits] [numeric](28, 10) NULL,
	[BaselineActualNonLaborUnits] [numeric](28, 10) NULL,
	[BaselinePlannedLaborUnits] [numeric](28, 10) NULL,
	[BaselinePlannedNonLaborUnits] [numeric](28, 10) NULL,
	[Baseline1ActualLaborUnits] [numeric](28, 10) NULL,
	[Baseline1ActualNonLaborUnits] [numeric](28, 10) NULL,
	[Baseline1PlannedLaborUnits] [numeric](28, 10) NULL,
	[Baseline1PlannedNonLaborUnits] [numeric](28, 10) NULL,
	[EarnedValueLaborUnits] [numeric](28, 10) NULL,
	[EstimateAtCompletionLaborUnits] [numeric](28, 10) NULL,
	[EstimateToCompleteLaborUnits] [numeric](28, 10) NULL,
	[PlannedLaborUnits] [numeric](28, 10) NULL,
	[PlannedNonLaborUnits] [numeric](28, 10) NULL,
	[PlannedValueLaborUnits] [numeric](28, 10) NULL,
	[RemainingLaborUnits] [numeric](28, 10) NULL,
	[RemainingLateLaborUnits] [numeric](28, 10) NULL,
	[RemainingLateNonLaborUnits] [numeric](28, 10) NULL,
	[RemainingNonLaborUnits] [numeric](28, 10) NULL,
	[ActualCost] [numeric](28, 10) NULL,
	[ActualExpenseCost] [numeric](28, 10) NULL,
	[ActualLaborCost] [numeric](28, 10) NULL,
	[ActualMaterialCost] [numeric](28, 10) NULL,
	[ActualNonLaborCost] [numeric](28, 10) NULL,
	[ActualTotalCost] [numeric](28, 10) NULL,
	[AtCompletionExpenseCost] [numeric](28, 10) NULL,
	[AtCompletionLaborCost] [numeric](28, 10) NULL,
	[AtCompletionMaterialCost] [numeric](28, 10) NULL,
	[AtCompletionNonLaborCost] [numeric](28, 10) NULL,
	[AtCompletionTotalCost] [numeric](28, 10) NULL,
	[BaselinePlannedExpenseCost] [numeric](28, 10) NULL,
	[BaselinePlannedLaborCost] [numeric](28, 10) NULL,
	[BaselinePlannedMaterialCost] [numeric](28, 10) NULL,
	[BaselinePlannedNonLaborCost] [numeric](28, 10) NULL,
	[BaselinePlannedTotalCost] [numeric](28, 10) NULL,
	[BaselineActualExpenseCost] [numeric](28, 10) NULL,
	[BaselineActualLaborCost] [numeric](28, 10) NULL,
	[BaselineActualMaterialCost] [numeric](28, 10) NULL,
	[BaselineActualNonLaborCost] [numeric](28, 10) NULL,
	[BaselineActualTotalCost] [numeric](28, 10) NULL,
	[Baseline1ActualExpenseCost] [numeric](28, 10) NULL,
	[Baseline1ActualLaborCost] [numeric](28, 10) NULL,
	[Baseline1ActualMaterialCost] [numeric](28, 10) NULL,
	[Baseline1ActualNonLaborCost] [numeric](28, 10) NULL,
	[Baseline1ActualTotalCost] [numeric](28, 10) NULL,
	[Baseline1PlannedExpenseCost] [numeric](28, 10) NULL,
	[Baseline1PlannedLaborCost] [numeric](28, 10) NULL,
	[Baseline1PlannedMaterialCost] [numeric](28, 10) NULL,
	[Baseline1PlannedNonLaborCost] [numeric](28, 10) NULL,
	[Baseline1PlannedTotalCost] [numeric](28, 10) NULL,
	[EarnedValueCost] [numeric](28, 10) NULL,
	[EstimateAtCompletionCost] [numeric](28, 10) NULL,
	[EstimateToCompleteCost] [numeric](28, 10) NULL,
	[PlannedExpenseCost] [numeric](28, 10) NULL,
	[PlannedLaborCost] [numeric](28, 10) NULL,
	[PlannedMaterialCost] [numeric](28, 10) NULL,
	[PlannedNonLaborCost] [numeric](28, 10) NULL,
	[PlannedTotalCost] [numeric](28, 10) NULL,
	[PlannedValueCost] [numeric](28, 10) NULL,
	[RemainingExpenseCost] [numeric](28, 10) NULL,
	[RemainingLaborCost] [numeric](28, 10) NULL,
	[RemainingLateExpenseCost] [numeric](28, 10) NULL,
	[RemainingLateLaborCost] [numeric](28, 10) NULL,
	[RemainingLateMaterialCost] [numeric](28, 10) NULL,
	[RemainingLateNonLaborCost] [numeric](28, 10) NULL,
	[RemainingLateTotalCost] [numeric](28, 10) NULL,
	[RemainingMaterialCost] [numeric](28, 10) NULL,
	[RemainingNonLaborCost] [numeric](28, 10) NULL,
	[RemainingTotalCost] [numeric](28, 10) NULL,
	[lastupdatedate] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [P6].[BASELINE]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[BASELINE](
	[objectid] [int] NULL,
	[id] [varchar](40) NULL,
	[fiscalyearstartmonth] [int] NULL,
	[resourcescaneditasgnmtpctcmp] [varchar](1) NULL,
	[resourcescanselfassigntoacts] [varchar](1) NULL,
	[primaryrescanmarkactsascmp] [varchar](1) NULL,
	[resourcecanassigntosameact] [varchar](1) NULL,
	[checkoutstatus] [varchar](1) NULL,
	[activitypctcmpbasedonsteps] [varchar](1) NULL,
	[costquantityrecalculateflag] [varchar](1) NULL,
	[containssummarydataonly] [varchar](1) NULL,
	[enablesummarization] [varchar](1) NULL,
	[wbscodeseparator] [varchar](2) NULL,
	[activitydefaultpctcmptype] [varchar](10) NULL,
	[activitydefcostacctobjectid] [int] NULL,
	[activitydefcalendarobjectid] [int] NULL,
	[currentbaselineprojectobjectid] [int] NULL,
	[activityidsuffix] [int] NULL,
	[activityidincrement] [int] NULL,
	[levelingpriority] [int] NULL,
	[summarizetowbslevel] [int] NULL,
	[strategicpriority] [int] NULL,
	[criticalactivityfloatlimit] [numeric](10, 2) NULL,
	[activitydefaultpriceperunit] [numeric](21, 8) NULL,
	[plannedstartdate] [datetime] NULL,
	[mustfinishbydate] [datetime] NULL,
	[scheduledfinishdate] [datetime] NULL,
	[dateadded] [datetime] NULL,
	[summarizeddatadate] [datetime] NULL,
	[lastsummarizeddate] [datetime] NULL,
	[projectforecaststartdate] [datetime] NULL,
	[activitydefaultdurationtype] [varchar](27) NULL,
	[activityidprefix] [varchar](20) NULL,
	[defaultpricetimeunits] [varchar](32) NULL,
	[addedby] [varchar](255) NULL,
	[websiterootdirectory] [varchar](120) NULL,
	[websiteurl] [varchar](200) NULL,
	[assignmentdefaultratetype] [varchar](14) NULL,
	[linkactualtoactualthisperiod] [varchar](1) NULL,
	[activitydefaultactivitytype] [varchar](18) NULL,
	[linkpercentcompletewithactual] [varchar](1) NULL,
	[addactualtoremaining] [varchar](1) NULL,
	[criticalactivitypathtype] [varchar](14) NULL,
	[activityidbasedonselactivity] [varchar](1) NULL,
	[assignmentdefaultdrivingflag] [varchar](1) NULL,
	[linkplannedandatcompletionflag] [varchar](1) NULL,
	[resetplannedtoremainingflag] [varchar](1) NULL,
	[allownegativeactualunitsflag] [varchar](1) NULL,
	[ownerresourceobjectid] [int] NULL,
	[checkoutdate] [datetime] NULL,
	[checkoutuserobjectid] [int] NULL,
	[lastfinancialperiodobjectid] [int] NULL,
	[useprojectblforearnedvalue] [varchar](1) NULL,
	[originalprojectobjectid] [int] NULL,
	[riskscorematrixobjectid] [int] NULL,
	[projectdescription] [varchar](500) NULL,
	[baselinetypeobjectid] [int] NULL,
	[enablepublication] [varchar](1) NULL,
	[nextpublicationdate] [datetime] NULL,
	[lastpublishedon] [datetime] NULL,
	[publicationpriority] [numeric](3, 0) NULL,
	[locationobjectid] [int] NULL,
	[historyinterval] [varchar](25) NULL,
	[historylevel] [varchar](10) NULL,
	[allowstatusreview] [varchar](1) NULL,
	[lastupdateuser] [varchar](255) NULL,
	[lastupdatedate] [datetime] NULL,
	[createuser] [varchar](255) NULL,
	[etlinterval] [int] NULL,
	[etlhour] [int] NULL,
	[createdate] [datetime] NULL,
	[parentprojectid] [varchar](40) NULL,
	[name] [varchar](100) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [P6].[CALENDAR]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[CALENDAR](
	[objectid] [varchar](255) NULL,
	[isdefault] [varchar](255) NULL,
	[calendarname] [varchar](255) NULL,
	[calendartype] [varchar](255) NULL,
	[projectobjectid] [varchar](255) NULL,
	[basecalendarobjectid] [varchar](255) NULL,
	[lastchangedate] [varchar](255) NULL,
	[weekdaynumber] [varchar](255) NULL,
	[totalworkhours] [varchar](255) NULL,
	[workdayflag] [varchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [P6].[PROJECTCODEASSIGNMENT]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[PROJECTCODEASSIGNMENT](
	[projectobjectid] [int] NULL,
	[projectcodetypeobjectid] [int] NULL,
	[projectcodeobjectid] [int] NULL,
	[projectcodedescription] [varchar](255) NULL,
	[projectcodetypename] [varchar](255) NULL,
	[projectcodevalue] [varchar](255) NULL,
	[projectname] [varchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [P6].[RELATIONSHIP]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[RELATIONSHIP](
	[objectid] [int] NULL,
	[successoractivityobjectid] [int] NULL,
	[predecessoractivityobjectid] [int] NULL,
	[successorprojectobjectid] [int] NULL,
	[predecessorprojectobjectid] [int] NULL,
	[type] [varchar](16) NULL,
	[lag] [numeric](17, 6) NULL,
	[predecessoractivityid] [varchar](255) NULL,
	[predecessoractivityname] [varchar](255) NULL,
	[predecessorprojectid] [varchar](255) NULL,
	[successoractivityid] [varchar](255) NULL,
	[successoractivityname] [varchar](255) NULL,
	[successorprojectid] [varchar](255) NULL,
	[lastupdateuser] [varchar](255) NULL,
	[lastupdatedate] [datetime] NULL,
	[createuser] [varchar](255) NULL,
	[createdate] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [P6].[RESOURCES]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[RESOURCES](
	[objectid] [int] NULL,
	[isactive] [varchar](1) NULL,
	[resourcetype] [varchar](10) NULL,
	[id] [varchar](255) NULL,
	[name] [varchar](255) NULL,
	[defaultunitspertime] [numeric](16, 8) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [P6].[WBS]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [P6].[WBS](
	[objectid] [int] NULL,
	[projectobjectid] [int] NULL,
	[obsobjectid] [int] NULL,
	[status] [varchar](20) NULL,
	[code] [varchar](40) NULL,
	[name] [varchar](100) NULL,
	[parentobjectid] [int] NULL,
	[originalbudget] [numeric](23, 6) NULL,
	[anticipatedstartdate] [datetime] NULL,
	[anticipatedfinishdate] [datetime] NULL,
	[sumactivitycount] [numeric](28, 10) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PARAM].[PARAM_UTLITY]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PARAM].[PARAM_UTLITY](
	[param_label] [nvarchar](200) NULL,
	[param_value] [nvarchar](50) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[billing_periods]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[billing_periods](
	[id_project] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[created_at] [nvarchar](2000) NULL,
	[due_date] [nvarchar](2000) NULL,
	[end_date] [nvarchar](2000) NULL,
	[position] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[start_date] [nvarchar](2000) NULL,
	[status] [nvarchar](2000) NULL,
	[updated_at] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[change_events]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[change_events](
	[project_id] [nvarchar](250) NULL,
	[id] [nvarchar](250) NULL,
	[created_at] [nvarchar](250) NULL,
	[event_scope] [nvarchar](250) NULL,
	[event_type] [nvarchar](250) NULL,
	[number] [nvarchar](250) NULL,
	[alphanumeric_number] [nvarchar](250) NULL,
	[origin_data] [nvarchar](250) NULL,
	[origin_id] [nvarchar](250) NULL,
	[status] [nvarchar](250) NULL,
	[title] [nvarchar](250) NULL,
	[updated_at] [nvarchar](250) NULL,
	[change_event_line_items_object] [nvarchar](250) NULL,
	[id_event_line_items] [nvarchar](250) NULL,
	[biller_object] [nvarchar](250) NULL,
	[id_biller] [nvarchar](250) NULL,
	[name_biller] [nvarchar](250) NULL,
	[model_name] [nvarchar](250) NULL,
	[guid] [nvarchar](250) NULL,
	[biller_guid] [nvarchar](250) NULL,
	[contract_event_line_item_object] [nvarchar](250) NULL,
	[id_contract] [nvarchar](250) NULL,
	[number_contract] [nvarchar](250) NULL,
	[title_contract] [nvarchar](250) NULL,
	[name_contract] [nvarchar](250) NULL,
	[cost_code_object] [nvarchar](250) NULL,
	[id_cost_code] [nvarchar](250) NULL,
	[name_cost_code] [nvarchar](250) NULL,
	[full_code_cost_code] [nvarchar](250) NULL,
	[origin_id_cost_code] [nvarchar](250) NULL,
	[origin_data_cost_code] [nvarchar](250) NULL,
	[standard_cost_code_id_cost_code] [nvarchar](250) NULL,
	[biller_cost_code] [nvarchar](250) NULL,
	[biller_id_cost_code] [nvarchar](250) NULL,
	[biller_type_cost_code] [nvarchar](250) NULL,
	[biller_origin_id_cost_code] [nvarchar](250) NULL,
	[budgeted_cost_code] [nvarchar](250) NULL,
	[code_cost_code] [nvarchar](250) NULL,
	[parent_object] [nvarchar](250) NULL,
	[id_parent] [nvarchar](250) NULL,
	[cost_type_object] [nvarchar](250) NULL,
	[id_cost_type] [nvarchar](250) NULL,
	[provider_id_cost_type] [nvarchar](250) NULL,
	[provider_type_cost_type] [nvarchar](250) NULL,
	[name_cost_type] [nvarchar](250) NULL,
	[csv_import_code_cost_type] [nvarchar](250) NULL,
	[base_type_cost_type] [nvarchar](250) NULL,
	[position_cost_type] [nvarchar](250) NULL,
	[deleted_at_cost_type] [nvarchar](250) NULL,
	[created_at_cost_type] [nvarchar](250) NULL,
	[updated_at_cost_type] [nvarchar](250) NULL,
	[timesheet_type_cost_type] [nvarchar](250) NULL,
	[company_id_cost_type] [nvarchar](250) NULL,
	[cost_code_biller_name] [nvarchar](250) NULL,
	[cost_code_id] [nvarchar](250) NULL,
	[cost_code_is_budgeted] [nvarchar](250) NULL,
	[deletable] [nvarchar](250) NULL,
	[description] [nvarchar](250) NULL,
	[editable] [nvarchar](250) NULL,
	[estimated_cost_amount] [nvarchar](250) NULL,
	[event_id] [nvarchar](250) NULL,
	[line_item_types_object] [nvarchar](250) NULL,
	[id_line_item_type] [nvarchar](250) NULL,
	[name_line_item_type] [nvarchar](250) NULL,
	[code_line_item_type] [nvarchar](250) NULL,
	[base_type_line_item_type] [nvarchar](250) NULL,
	[origin_id_line_item_type] [nvarchar](250) NULL,
	[line_item_type_id] [nvarchar](250) NULL,
	[links_object] [nvarchar](250) NULL,
	[edit] [nvarchar](250) NULL,
	[views] [nvarchar](250) NULL,
	[parent] [nvarchar](250) NULL,
	[contracts] [nvarchar](250) NULL,
	[links_rom] [nvarchar](250) NULL,
	[number_event_line_item] [nvarchar](250) NULL,
	[permission_to_edit] [nvarchar](250) NULL,
	[proposed_contract_id] [nvarchar](250) NULL,
	[proposed_vendor_id] [nvarchar](250) NULL,
	[request_for_quote_id] [nvarchar](250) NULL,
	[rfq_amount] [nvarchar](250) NULL,
	[rom] [nvarchar](250) NULL,
	[sortable_code] [nvarchar](250) NULL,
	[status_event_line_item] [nvarchar](250) NULL,
	[statuses_object] [nvarchar](250) NULL,
	[contract_statuses] [nvarchar](250) NULL,
	[title_event_line_item] [nvarchar](250) NULL,
	[vendor_object] [nvarchar](250) NULL,
	[id_vendor] [nvarchar](250) NULL,
	[name_vendor] [nvarchar](250) NULL,
	[event_title_and_number] [nvarchar](250) NULL,
	[is_markup_summary] [nvarchar](250) NULL,
	[estimated_cost_calculation_strategy] [nvarchar](250) NULL,
	[estimated_cost_quantity] [nvarchar](250) NULL,
	[estimated_cost_unit_cost] [nvarchar](250) NULL,
	[uom] [nvarchar](250) NULL,
	[wbs_code_object] [nvarchar](250) NULL,
	[description_wbs_code] [nvarchar](250) NULL,
	[flat_code] [nvarchar](250) NULL,
	[id_wbs_code] [nvarchar](250) NULL,
	[latest_revenue_amount] [nvarchar](250) NULL,
	[over_under_amount] [nvarchar](250) NULL,
	[revenue_rom_amount] [nvarchar](250) NULL,
	[revenue_rom_display] [nvarchar](250) NULL,
	[revenue_rom_calculation_strategy] [nvarchar](250) NULL,
	[revenue_rom_quantity] [nvarchar](250) NULL,
	[revenue_rom_uom] [nvarchar](250) NULL,
	[revenue_rom_unit_cost] [nvarchar](250) NULL,
	[latest_cost_calculation_strategy] [nvarchar](250) NULL,
	[latest_cost_quantity] [nvarchar](250) NULL,
	[latest_cost_uom] [nvarchar](250) NULL,
	[latest_cost_unit_cost] [nvarchar](250) NULL,
	[non_committed_cost] [nvarchar](250) NULL,
	[manual_latest_cost_amount] [nvarchar](250) NULL,
	[latest_cost_amount] [nvarchar](250) NULL,
	[change_order_change_reason_object] [nvarchar](250) NULL,
	[id_change_order_change_reason] [nvarchar](250) NULL,
	[company_id_change_order_change_reason] [nvarchar](250) NULL,
	[change_reason_change_order_change_reason] [nvarchar](250) NULL,
	[change_event_status_object] [nvarchar](250) NULL,
	[id_event] [nvarchar](250) NULL,
	[name_event] [nvarchar](250) NULL,
	[mapped_to_status] [nvarchar](250) NULL,
	[show_in_select] [nvarchar](250) NULL,
	[id_creator] [nvarchar](250) NULL,
	[login] [nvarchar](250) NULL,
	[name_creator] [nvarchar](250) NULL,
	[id_attachment] [nvarchar](250) NULL,
	[filename] [nvarchar](250) NULL,
	[name_attachment] [nvarchar](250) NULL,
	[url] [nvarchar](250) NULL,
	[rqfs_object] [nvarchar](250) NULL,
	[id_rqfs] [nvarchar](250) NULL,
	[commitment_contract_id_rqfs] [nvarchar](250) NULL,
	[created_at_rqfs] [nvarchar](250) NULL,
	[description_rqfs] [nvarchar](250) NULL,
	[due_date_rqfs] [nvarchar](250) NULL,
	[estimated_status_rqfs] [nvarchar](250) NULL,
	[intent_to_quote_rqfs] [nvarchar](250) NULL,
	[number_rqfs] [nvarchar](250) NULL,
	[original_quote_rqfs] [nvarchar](250) NULL,
	[position_rqfs] [nvarchar](250) NULL,
	[private_rqfs] [nvarchar](250) NULL,
	[status_rqfs] [nvarchar](250) NULL,
	[title_rqfs] [nvarchar](250) NULL,
	[updated_at_rqfs] [nvarchar](250) NULL,
	[quotes_object] [nvarchar](250) NULL,
	[id_quote] [nvarchar](250) NULL,
	[cost_quote] [nvarchar](250) NULL,
	[created_at_quote] [nvarchar](250) NULL,
	[description_quote] [nvarchar](250) NULL,
	[schedule_impact_quote] [nvarchar](250) NULL,
	[updated_at_quote] [nvarchar](250) NULL,
	[request_for_quote_id_quote] [nvarchar](250) NULL,
	[created_by_id_quote] [nvarchar](250) NULL,
	[created_by_object_quote] [nvarchar](250) NULL,
	[id_1] [nvarchar](250) NULL,
	[login_1] [nvarchar](250) NULL,
	[name_1] [nvarchar](250) NULL,
	[responses_object] [nvarchar](250) NULL,
	[id_response] [nvarchar](250) NULL,
	[comment_response] [nvarchar](250) NULL,
	[created_at_response] [nvarchar](250) NULL,
	[updated_at_response] [nvarchar](250) NULL,
	[created_by_object] [nvarchar](250) NULL,
	[id_2] [nvarchar](250) NULL,
	[login_2] [nvarchar](250) NULL,
	[name_2] [nvarchar](250) NULL,
	[change_event_line_item_id] [nvarchar](250) NULL,
	[commitment_potential_change_orders_object] [nvarchar](250) NULL,
	[id_commitment_potential] [nvarchar](250) NULL,
	[contract_id_commitment_potential] [nvarchar](250) NULL,
	[created_at_commitment_potential] [nvarchar](250) NULL,
	[created_by_id_commitment_potential] [nvarchar](250) NULL,
	[number_commitment_potential] [nvarchar](250) NULL,
	[status_commitment_potential] [nvarchar](250) NULL,
	[title_commitment_potential] [nvarchar](250) NULL,
	[updated_at_commitment_potential] [nvarchar](250) NULL,
	[change_order_request_id_commitment_potential] [nvarchar](250) NULL,
	[executed_commitment_potential] [nvarchar](250) NULL,
	[grand_total_commitment_potential] [nvarchar](250) NULL,
	[revision_commitment_potential] [nvarchar](250) NULL,
	[change_reason_commitment_potential] [nvarchar](250) NULL,
	[change_order_request_title_commitment_potential] [nvarchar](250) NULL,
	[change_order_package_title_commitment_potential] [nvarchar](250) NULL,
	[potential_change_order_acronym_number_commitment_potential] [nvarchar](250) NULL,
	[change_order_request_acronym_number_commitment_potential] [nvarchar](250) NULL,
	[change_order_package_acronym_number_commitment_potential] [nvarchar](250) NULL,
	[change_order_tiers_commitment_potential] [nvarchar](250) NULL,
	[commitment_change_order_packages_object] [nvarchar](250) NULL,
	[id_commitment_change] [nvarchar](250) NULL,
	[contract_id_commitment_change] [nvarchar](250) NULL,
	[created_at_commitment_change] [nvarchar](250) NULL,
	[created_by_id_commitment_change] [nvarchar](250) NULL,
	[executed_commitment_change] [nvarchar](250) NULL,
	[grand_total_commitment_change] [nvarchar](250) NULL,
	[number_commitment_change] [nvarchar](250) NULL,
	[reviewed_at_commitment_change] [nvarchar](250) NULL,
	[status_commitment_change] [nvarchar](250) NULL,
	[title_commitment_change] [nvarchar](250) NULL,
	[updated_at_commitment_change] [nvarchar](250) NULL,
	[revision_commitment_change] [nvarchar](250) NULL,
	[singleton_potential_change_order_id_commitment_change] [nvarchar](250) NULL,
	[created_by] [nvarchar](250) NULL,
	[id_3] [nvarchar](250) NULL,
	[login_3] [nvarchar](250) NULL,
	[name_3] [nvarchar](250) NULL,
	[sortable_code_parent] [varchar](250) NULL,
	[created_at_parent] [varchar](250) NULL,
	[deleted_at_parent] [varchar](250) NULL,
	[committed_cost_links] [varchar](250) NULL,
	[commitment_pco_cost_links] [varchar](250) NULL,
	[committed_cost_statuses] [varchar](250) NULL,
	[commitment_pco_cost_statuses] [varchar](250) NULL,
	[commitment_pco_tooltip_statuses] [varchar](250) NULL,
	[commited_cost_wbs_code] [varchar](250) NULL,
	[commitment_pco_cost_wbs_code] [varchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[commitments_subcontracts_work_order]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[commitments_subcontracts_work_order](
	[id_project] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[accounting_method] [nvarchar](2000) NULL,
	[actual_completion_date] [nvarchar](2000) NULL,
	[approval_letter_date] [nvarchar](2000) NULL,
	[approved_change_orders] [nvarchar](2000) NULL,
	[billing_schedule_of_values_status] [nvarchar](2000) NULL,
	[contract_date] [nvarchar](2000) NULL,
	[contract_estimated_completion_date] [nvarchar](2000) NULL,
	[contract_start_date] [nvarchar](2000) NULL,
	[created_at] [nvarchar](2000) NULL,
	[created_by_id] [nvarchar](2000) NULL,
	[currency_configuration_currency_iso_code] [nvarchar](2000) NULL,
	[custom_fields_custom_field_78686_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_78686_value] [nvarchar](2000) NULL,
	[custom_fields_custom_field_78687_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_78687_value] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82611_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82611_value] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82612_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82612_value] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82613_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82613_value] [nvarchar](2000) NULL,
	[deleted_at] [nvarchar](2000) NULL,
	[description] [nvarchar](2000) NULL,
	[draft_change_orders_amount] [nvarchar](2000) NULL,
	[exclusions] [nvarchar](2000) NULL,
	[executed] [nvarchar](2000) NULL,
	[execution_date] [nvarchar](2000) NULL,
	[grand_total] [nvarchar](2000) NULL,
	[has_change_order_packages] [nvarchar](2000) NULL,
	[has_potential_change_orders] [nvarchar](2000) NULL,
	[inclusions] [nvarchar](2000) NULL,
	[issued_on_date] [nvarchar](2000) NULL,
	[letter_of_intent_date] [nvarchar](2000) NULL,
	[number] [nvarchar](2000) NULL,
	[origin_code] [nvarchar](2000) NULL,
	[origin_data] [nvarchar](2000) NULL,
	[origin_id] [nvarchar](2000) NULL,
	[pending_change_orders] [nvarchar](2000) NULL,
	[pending_revised_contract] [nvarchar](2000) NULL,
	[percentage_paid] [nvarchar](2000) NULL,
	[private] [nvarchar](2000) NULL,
	[project_id] [nvarchar](2000) NULL,
	[project_name] [nvarchar](2000) NULL,
	[project_origin_data] [nvarchar](2000) NULL,
	[project_origin_id] [nvarchar](2000) NULL,
	[remaining_balance_outstanding] [nvarchar](2000) NULL,
	[requisitions_are_enabled] [nvarchar](2000) NULL,
	[retainage_percent] [nvarchar](2000) NULL,
	[returned_date] [nvarchar](2000) NULL,
	[revised_contract] [nvarchar](2000) NULL,
	[show_line_items_to_non_admins] [nvarchar](2000) NULL,
	[signed_contract_received_date] [nvarchar](2000) NULL,
	[status] [nvarchar](2000) NULL,
	[title] [nvarchar](2000) NULL,
	[total_draw_requests_amount] [nvarchar](2000) NULL,
	[total_payments] [nvarchar](2000) NULL,
	[total_requisitions_amount] [nvarchar](2000) NULL,
	[updated_at] [nvarchar](2000) NULL,
	[vendor_id] [nvarchar](2000) NULL,
	[vendor_company] [nvarchar](2000) NULL,
	[vendor_origin_data] [nvarchar](2000) NULL,
	[vendor_origin_id] [nvarchar](2000) NULL,
	[custom_fields_custom_field_78686_value_id] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[company_vendor]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[company_vendor](
	[id] [varchar](250) NULL,
	[abbreviated_name] [varchar](250) NULL,
	[company] [varchar](max) NULL,
	[country_code] [varchar](250) NULL,
	[city] [varchar](250) NULL,
	[address] [varchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[delay_log_types]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[delay_log_types](
	[project_id] [varchar](250) NULL,
	[id] [varchar](250) NULL,
	[created_at] [varchar](250) NULL,
	[display_name] [varchar](250) NULL,
	[english_or_display_name] [varchar](250) NULL,
	[translation_key] [varchar](250) NULL,
	[updated_at] [varchar](250) NULL,
	[visible] [varchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[meetings]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[meetings](
	[id_project] [nvarchar](2000) NULL,
	[group_title] [nvarchar](2000) NULL,
	[meetings_id] [nvarchar](2000) NULL,
	[meetings_description] [nvarchar](2000) NULL,
	[meetings_ends_at] [nvarchar](2000) NULL,
	[meetings_is_private] [nvarchar](2000) NULL,
	[meetings_location] [nvarchar](2000) NULL,
	[meetings_meeting_topics_count] [nvarchar](2000) NULL,
	[meetings_mode] [nvarchar](2000) NULL,
	[meetings_occurred] [nvarchar](2000) NULL,
	[meetings_parent_id] [nvarchar](2000) NULL,
	[meetings_position] [nvarchar](2000) NULL,
	[meetings_starts_at] [nvarchar](2000) NULL,
	[meetings_title] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[project_insurrance]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[project_insurrance](
	[id_project] [varchar](250) NULL,
	[additional_insured] [varchar](250) NULL,
	[division_template] [varchar](250) NULL,
	[effective_date] [varchar](250) NULL,
	[enable_expired_insurance_notifications] [varchar](250) NULL,
	[exempt] [varchar](250) NULL,
	[expiration_date] [varchar](250) NULL,
	[id] [varchar](250) NULL,
	[info_received] [varchar](250) NULL,
	[insurance_provider] [varchar](250) NULL,
	[insurance_sets] [varchar](250) NULL,
	[insurance_type] [varchar](250) NULL,
	[limit] [varchar](250) NULL,
	[notes] [varchar](250) NULL,
	[origin_data] [varchar](250) NULL,
	[origin_id] [varchar](250) NULL,
	[policy_number] [varchar](250) NULL,
	[status] [varchar](250) NULL,
	[vendor_id] [varchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[ProjectRoles]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[ProjectRoles](
	[id] [nvarchar](1000) NULL,
	[ProjectID] [nvarchar](1000) NULL,
	[name] [nvarchar](1000) NULL,
	[role] [nvarchar](1000) NULL,
	[contact_id] [nvarchar](1000) NULL,
	[user_id] [nvarchar](1000) NULL,
	[is_active] [nvarchar](1000) NULL,
	[created_at] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[projects]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[projects](
	[id_project] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[accounting_project_number] [nvarchar](2000) NULL,
	[active] [nvarchar](2000) NULL,
	[address] [nvarchar](2000) NULL,
	[city] [nvarchar](2000) NULL,
	[code] [nvarchar](2000) NULL,
	[company_id] [nvarchar](2000) NULL,
	[company_name] [nvarchar](2000) NULL,
	[completion_date] [nvarchar](2000) NULL,
	[country_code] [nvarchar](2000) NULL,
	[county] [nvarchar](2000) NULL,
	[created_at] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82842_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82842_value_id] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82842_value_label] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82843_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82843_value_id] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82843_value_label] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82847_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82847_value_id] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82847_value_label] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82848_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82848_value_id] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82848_value_label] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82849_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82849_value_id] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82849_value_label] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82908_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82908_value] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82909_data_type] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82909_value_id] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82909_value_label] [nvarchar](2000) NULL,
	[designated_market_area] [nvarchar](2000) NULL,
	[display_name] [nvarchar](2000) NULL,
	[erp_integrated] [nvarchar](2000) NULL,
	[estimated_value] [nvarchar](2000) NULL,
	[is_demo] [nvarchar](2000) NULL,
	[latitude] [nvarchar](2000) NULL,
	[longitude] [nvarchar](2000) NULL,
	[name] [nvarchar](2000) NULL,
	[origin_code] [nvarchar](2000) NULL,
	[origin_data] [nvarchar](2000) NULL,
	[origin_id] [nvarchar](2000) NULL,
	[owners_project_id] [nvarchar](2000) NULL,
	[parent_job_id] [nvarchar](2000) NULL,
	[phone] [nvarchar](2000) NULL,
	[photo_id] [nvarchar](2000) NULL,
	[project_bid_type_id] [nvarchar](2000) NULL,
	[project_number] [nvarchar](2000) NULL,
	[project_owner_type_id] [nvarchar](2000) NULL,
	[project_region_id] [nvarchar](2000) NULL,
	[project_stage_id] [nvarchar](2000) NULL,
	[project_stage_name] [nvarchar](2000) NULL,
	[start_date] [nvarchar](2000) NULL,
	[state_code] [nvarchar](2000) NULL,
	[store_number] [nvarchar](2000) NULL,
	[time_zone] [nvarchar](2000) NULL,
	[total_value] [nvarchar](2000) NULL,
	[updated_at] [nvarchar](2000) NULL,
	[zip] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82908_value_id] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82908_value_label] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82848_value] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82842_value] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82843_value] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82847_value] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82849_value] [nvarchar](2000) NULL,
	[custom_fields_custom_field_82909_value] [nvarchar](2000) NULL,
	[project_stage] [nvarchar](2000) NULL,
	[project_program_id] [nvarchar](500) NULL,
	[project_program_name] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[variation]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[variation](
	[id_project] [nvarchar](2000) NULL,
	[id] [nvarchar](2000) NULL,
	[contract_id] [nvarchar](2000) NULL,
	[created_at] [nvarchar](2000) NULL,
	[created_by_id] [nvarchar](2000) NULL,
	[invoiced_date] [nvarchar](2000) NULL,
	[number] [nvarchar](2000) NULL,
	[status] [nvarchar](2000) NULL,
	[title] [nvarchar](2000) NULL,
	[updated_at] [nvarchar](2000) NULL,
	[change_order_request_id] [nvarchar](2000) NULL,
	[executed] [nvarchar](2000) NULL,
	[grand_total] [nvarchar](2000) NULL,
	[revision] [nvarchar](2000) NULL,
	[change_order_request_title] [nvarchar](2000) NULL,
	[change_order_package_title] [nvarchar](2000) NULL,
	[potential_change_order_acronym_number] [nvarchar](2000) NULL,
	[change_order_request_acronym_number] [nvarchar](2000) NULL,
	[change_order_package_acronym_number] [nvarchar](2000) NULL,
	[change_order_tiers] [nvarchar](2000) NULL,
	[currency_configuration_currency_iso_code] [nvarchar](2000) NULL,
	[due_date] [nvarchar](2000) NULL,
	[paid_date] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [PROCORE].[weather_conditions]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PROCORE].[weather_conditions](
	[id_project] [nvarchar](2000) NULL,
	[sky_key] [nvarchar](2000) NULL,
	[sky_value] [nvarchar](2000) NULL,
	[ground_key] [nvarchar](2000) NULL,
	[ground_value] [nvarchar](2000) NULL,
	[calamity_key] [nvarchar](2000) NULL,
	[calamity_value] [nvarchar](2000) NULL,
	[wind_key] [nvarchar](2000) NULL,
	[wind_value] [nvarchar](2000) NULL,
	[temperature_key] [nvarchar](2000) NULL,
	[temperature_value] [nvarchar](2000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ACDOCA]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ACDOCA](
	[RCLNT] [nvarchar](30) NULL,
	[RLDNR] [nvarchar](30) NULL,
	[RBUKRS] [nvarchar](30) NULL,
	[GJAHR] [nvarchar](30) NULL,
	[BELNR] [nvarchar](30) NULL,
	[DOCLN] [nvarchar](30) NULL,
	[RYEAR] [nvarchar](30) NULL,
	[VORGN] [nvarchar](30) NULL,
	[VRGNG] [nvarchar](30) NULL,
	[BTTYPE] [nvarchar](30) NULL,
	[AWTYP] [nvarchar](30) NULL,
	[AWSYS] [nvarchar](30) NULL,
	[AWORG] [nvarchar](30) NULL,
	[AWREF] [nvarchar](30) NULL,
	[AWITEM] [nvarchar](30) NULL,
	[AWITGRP] [nvarchar](30) NULL,
	[SUBTA] [nvarchar](30) NULL,
	[XREVERSING] [nvarchar](30) NULL,
	[XREVERSED] [nvarchar](30) NULL,
	[XTRUEREV] [nvarchar](30) NULL,
	[AWTYP_REV] [nvarchar](30) NULL,
	[AWORG_REV] [nvarchar](30) NULL,
	[AWREF_REV] [nvarchar](30) NULL,
	[SUBTA_REV] [nvarchar](30) NULL,
	[XSETTLING] [nvarchar](30) NULL,
	[XSETTLED] [nvarchar](30) NULL,
	[RTCUR] [nvarchar](30) NULL,
	[RWCUR] [nvarchar](30) NULL,
	[RHCUR] [nvarchar](30) NULL,
	[RKCUR] [nvarchar](30) NULL,
	[ROCUR] [nvarchar](30) NULL,
	[RVCUR] [nvarchar](30) NULL,
	[RUNIT] [nvarchar](30) NULL,
	[RVUNIT] [nvarchar](30) NULL,
	[CO_MEINH] [nvarchar](30) NULL,
	[RACCT] [nvarchar](30) NULL,
	[RCNTR] [nvarchar](30) NULL,
	[PRCTR] [nvarchar](30) NULL,
	[RBUSA] [nvarchar](30) NULL,
	[KOKRS] [nvarchar](30) NULL,
	[SEGMENT] [nvarchar](30) NULL,
	[SCNTR] [nvarchar](30) NULL,
	[PPRCTR] [nvarchar](30) NULL,
	[SBUSA] [nvarchar](30) NULL,
	[TSL] [nvarchar](30) NULL,
	[WSL] [nvarchar](30) NULL,
	[WSL2] [nvarchar](30) NULL,
	[WSL3] [nvarchar](30) NULL,
	[HSL] [nvarchar](30) NULL,
	[KSL] [nvarchar](30) NULL,
	[OSL] [nvarchar](30) NULL,
	[VSL] [nvarchar](30) NULL,
	[PSL] [nvarchar](30) NULL,
	[MSL] [nvarchar](30) NULL,
	[MFSL] [nvarchar](30) NULL,
	[VMSL] [nvarchar](30) NULL,
	[VMFSL] [nvarchar](30) NULL,
	[CO_MEGBTR] [nvarchar](30) NULL,
	[DRCRK] [nvarchar](30) NULL,
	[POPER] [nvarchar](30) NULL,
	[PERIV] [nvarchar](30) NULL,
	[FISCYEARPER] [nvarchar](30) NULL,
	[BUDAT] [nvarchar](30) NULL,
	[BLDAT] [nvarchar](30) NULL,
	[BLART] [nvarchar](30) NULL,
	[BUZEI] [nvarchar](30) NULL,
	[ZUONR] [nvarchar](30) NULL,
	[BSCHL] [nvarchar](30) NULL,
	[BSTAT] [nvarchar](30) NULL,
	[LINETYPE] [nvarchar](30) NULL,
	[KTOSL] [nvarchar](30) NULL,
	[XSPLITMOD] [nvarchar](30) NULL,
	[USNAM] [nvarchar](30) NULL,
	[TIMESTAMP] [nvarchar](30) NULL,
	[EPRCTR] [nvarchar](30) NULL,
	[RHOART] [nvarchar](30) NULL,
	[GLACCOUNT_TYPE] [nvarchar](30) NULL,
	[KTOPL] [nvarchar](30) NULL,
	[LOKKT] [nvarchar](30) NULL,
	[KTOP2] [nvarchar](30) NULL,
	[REBZG] [nvarchar](30) NULL,
	[REBZJ] [nvarchar](30) NULL,
	[REBZZ] [nvarchar](30) NULL,
	[REBZT] [nvarchar](30) NULL,
	[RBEST] [nvarchar](30) NULL,
	[EBELN] [nvarchar](30) NULL,
	[EBELP] [nvarchar](30) NULL,
	[ZEKKN] [nvarchar](30) NULL,
	[SGTXT] [nvarchar](200) NULL,
	[KDAUF] [nvarchar](30) NULL,
	[KDPOS] [nvarchar](30) NULL,
	[MATNR] [nvarchar](30) NULL,
	[WERKS] [nvarchar](30) NULL,
	[LIFNR] [nvarchar](30) NULL,
	[KUNNR] [nvarchar](30) NULL,
	[FBUDA] [nvarchar](30) NULL,
	[KOART] [nvarchar](30) NULL,
	[OBJNR] [nvarchar](30) NULL,
	[PAROB1] [nvarchar](30) NULL,
	[PAROBSRC] [nvarchar](30) NULL,
	[USPOB] [nvarchar](30) NULL,
	[CO_BELKZ] [nvarchar](30) NULL,
	[CO_BEKNZ] [nvarchar](30) NULL,
	[BELTP] [nvarchar](30) NULL,
	[MUVFLG] [nvarchar](30) NULL,
	[GKONT] [nvarchar](30) NULL,
	[GKOAR] [nvarchar](30) NULL,
	[PERNR] [nvarchar](30) NULL,
	[SCOPE] [nvarchar](30) NULL,
	[PBUKRS] [nvarchar](30) NULL,
	[PSCOPE] [nvarchar](30) NULL,
	[BWSTRAT] [nvarchar](30) NULL,
	[UKOSTL] [nvarchar](30) NULL,
	[ULSTAR] [nvarchar](30) NULL,
	[ACCAS] [nvarchar](30) NULL,
	[ACCASTY] [nvarchar](30) NULL,
	[LSTAR] [nvarchar](30) NULL,
	[PS_PSP_PNR] [nvarchar](30) NULL,
	[PS_POSID] [nvarchar](30) NULL,
	[PS_PRJ_PNR] [nvarchar](30) NULL,
	[PS_PSPID] [nvarchar](30) NULL,
	[NPLNR] [nvarchar](30) NULL,
	[NPLNR_VORGN] [nvarchar](30) NULL,
	[PACCAS] [nvarchar](30) NULL,
	[PACCASTY] [nvarchar](30) NULL,
	[PLSTAR] [nvarchar](30) NULL,
	[PNPLNR] [nvarchar](30) NULL,
	[PNPLNR_VORGN] [nvarchar](30) NULL,
	[CO_ZLENR] [nvarchar](30) NULL,
	[CO_BELNR] [nvarchar](30) NULL,
	[CO_BUZEI] [nvarchar](30) NULL,
	[ARBID] [nvarchar](30) NULL,
	[VORNR] [nvarchar](30) NULL,
	[FKART] [nvarchar](30) NULL,
	[VKORG] [nvarchar](30) NULL,
	[VTWEG] [nvarchar](30) NULL,
	[SPART] [nvarchar](30) NULL,
	[ZBILLABLE] [nvarchar](30) NULL,
	[ZEXP_TYP] [nvarchar](30) NULL,
	[ZEXPENDITURE] [nvarchar](30) NULL,
	[ZBWR] [nvarchar](30) NULL,
	[ZAR_INVOICE] [nvarchar](30) NULL,
	[ZVENDOR] [nvarchar](200) NULL,
	[ZTYPE] [nvarchar](30) NULL,
	[ZRAWCOST] [nvarchar](30) NULL,
	[ZBILLAMOUNT] [nvarchar](30) NULL,
	[NETDT] [nvarchar](30) NULL,
	[AUGDT] [nvarchar](30) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ACDOCA_2023]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ACDOCA_2023](
	[RCLNT] [nvarchar](30) NULL,
	[RLDNR] [nvarchar](30) NULL,
	[RBUKRS] [nvarchar](30) NULL,
	[GJAHR] [nvarchar](30) NULL,
	[BELNR] [nvarchar](30) NULL,
	[DOCLN] [nvarchar](30) NULL,
	[RYEAR] [nvarchar](30) NULL,
	[VORGN] [nvarchar](30) NULL,
	[VRGNG] [nvarchar](30) NULL,
	[BTTYPE] [nvarchar](30) NULL,
	[AWTYP] [nvarchar](30) NULL,
	[AWSYS] [nvarchar](30) NULL,
	[AWORG] [nvarchar](30) NULL,
	[AWREF] [nvarchar](30) NULL,
	[AWITEM] [nvarchar](30) NULL,
	[AWITGRP] [nvarchar](30) NULL,
	[SUBTA] [nvarchar](30) NULL,
	[XREVERSING] [nvarchar](30) NULL,
	[XREVERSED] [nvarchar](30) NULL,
	[XTRUEREV] [nvarchar](30) NULL,
	[AWTYP_REV] [nvarchar](30) NULL,
	[AWORG_REV] [nvarchar](30) NULL,
	[AWREF_REV] [nvarchar](30) NULL,
	[SUBTA_REV] [nvarchar](30) NULL,
	[XSETTLING] [nvarchar](30) NULL,
	[XSETTLED] [nvarchar](30) NULL,
	[RTCUR] [nvarchar](30) NULL,
	[RWCUR] [nvarchar](30) NULL,
	[RHCUR] [nvarchar](30) NULL,
	[RKCUR] [nvarchar](30) NULL,
	[ROCUR] [nvarchar](30) NULL,
	[RVCUR] [nvarchar](30) NULL,
	[RUNIT] [nvarchar](30) NULL,
	[RVUNIT] [nvarchar](30) NULL,
	[CO_MEINH] [nvarchar](30) NULL,
	[RACCT] [nvarchar](30) NULL,
	[RCNTR] [nvarchar](30) NULL,
	[PRCTR] [nvarchar](30) NULL,
	[RBUSA] [nvarchar](30) NULL,
	[KOKRS] [nvarchar](30) NULL,
	[SEGMENT] [nvarchar](30) NULL,
	[SCNTR] [nvarchar](30) NULL,
	[PPRCTR] [nvarchar](30) NULL,
	[SBUSA] [nvarchar](30) NULL,
	[TSL] [nvarchar](30) NULL,
	[WSL] [nvarchar](30) NULL,
	[WSL2] [nvarchar](30) NULL,
	[WSL3] [nvarchar](30) NULL,
	[HSL] [nvarchar](30) NULL,
	[KSL] [nvarchar](30) NULL,
	[OSL] [nvarchar](30) NULL,
	[VSL] [nvarchar](30) NULL,
	[PSL] [nvarchar](30) NULL,
	[MSL] [nvarchar](30) NULL,
	[MFSL] [nvarchar](30) NULL,
	[VMSL] [nvarchar](30) NULL,
	[VMFSL] [nvarchar](30) NULL,
	[CO_MEGBTR] [nvarchar](30) NULL,
	[DRCRK] [nvarchar](30) NULL,
	[POPER] [nvarchar](30) NULL,
	[PERIV] [nvarchar](30) NULL,
	[FISCYEARPER] [nvarchar](30) NULL,
	[BUDAT] [nvarchar](30) NULL,
	[BLDAT] [nvarchar](30) NULL,
	[BLART] [nvarchar](30) NULL,
	[BUZEI] [nvarchar](30) NULL,
	[ZUONR] [nvarchar](30) NULL,
	[BSCHL] [nvarchar](30) NULL,
	[BSTAT] [nvarchar](30) NULL,
	[LINETYPE] [nvarchar](30) NULL,
	[KTOSL] [nvarchar](30) NULL,
	[XSPLITMOD] [nvarchar](30) NULL,
	[USNAM] [nvarchar](30) NULL,
	[TIMESTAMP] [nvarchar](30) NULL,
	[EPRCTR] [nvarchar](30) NULL,
	[RHOART] [nvarchar](30) NULL,
	[GLACCOUNT_TYPE] [nvarchar](30) NULL,
	[KTOPL] [nvarchar](30) NULL,
	[LOKKT] [nvarchar](30) NULL,
	[KTOP2] [nvarchar](30) NULL,
	[REBZG] [nvarchar](30) NULL,
	[REBZJ] [nvarchar](30) NULL,
	[REBZZ] [nvarchar](30) NULL,
	[REBZT] [nvarchar](30) NULL,
	[RBEST] [nvarchar](30) NULL,
	[EBELN] [nvarchar](30) NULL,
	[EBELP] [nvarchar](30) NULL,
	[ZEKKN] [nvarchar](30) NULL,
	[SGTXT] [nvarchar](200) NULL,
	[KDAUF] [nvarchar](30) NULL,
	[KDPOS] [nvarchar](30) NULL,
	[MATNR] [nvarchar](30) NULL,
	[WERKS] [nvarchar](30) NULL,
	[LIFNR] [nvarchar](30) NULL,
	[KUNNR] [nvarchar](30) NULL,
	[FBUDA] [nvarchar](30) NULL,
	[KOART] [nvarchar](30) NULL,
	[OBJNR] [nvarchar](30) NULL,
	[PAROB1] [nvarchar](30) NULL,
	[PAROBSRC] [nvarchar](30) NULL,
	[USPOB] [nvarchar](30) NULL,
	[CO_BELKZ] [nvarchar](30) NULL,
	[CO_BEKNZ] [nvarchar](30) NULL,
	[BELTP] [nvarchar](30) NULL,
	[MUVFLG] [nvarchar](30) NULL,
	[GKONT] [nvarchar](30) NULL,
	[GKOAR] [nvarchar](30) NULL,
	[PERNR] [nvarchar](30) NULL,
	[SCOPE] [nvarchar](30) NULL,
	[PBUKRS] [nvarchar](30) NULL,
	[PSCOPE] [nvarchar](30) NULL,
	[BWSTRAT] [nvarchar](30) NULL,
	[UKOSTL] [nvarchar](30) NULL,
	[ULSTAR] [nvarchar](30) NULL,
	[ACCAS] [nvarchar](30) NULL,
	[ACCASTY] [nvarchar](30) NULL,
	[LSTAR] [nvarchar](30) NULL,
	[PS_PSP_PNR] [nvarchar](30) NULL,
	[PS_POSID] [nvarchar](30) NULL,
	[PS_PRJ_PNR] [nvarchar](30) NULL,
	[PS_PSPID] [nvarchar](30) NULL,
	[NPLNR] [nvarchar](30) NULL,
	[NPLNR_VORGN] [nvarchar](30) NULL,
	[PACCAS] [nvarchar](30) NULL,
	[PACCASTY] [nvarchar](30) NULL,
	[PLSTAR] [nvarchar](30) NULL,
	[PNPLNR] [nvarchar](30) NULL,
	[PNPLNR_VORGN] [nvarchar](30) NULL,
	[CO_ZLENR] [nvarchar](30) NULL,
	[CO_BELNR] [nvarchar](30) NULL,
	[CO_BUZEI] [nvarchar](30) NULL,
	[ARBID] [nvarchar](30) NULL,
	[VORNR] [nvarchar](30) NULL,
	[FKART] [nvarchar](30) NULL,
	[VKORG] [nvarchar](30) NULL,
	[VTWEG] [nvarchar](30) NULL,
	[SPART] [nvarchar](30) NULL,
	[ZBILLABLE] [nvarchar](30) NULL,
	[ZEXP_TYP] [nvarchar](30) NULL,
	[ZEXPENDITURE] [nvarchar](30) NULL,
	[ZBWR] [nvarchar](30) NULL,
	[ZAR_INVOICE] [nvarchar](30) NULL,
	[ZVENDOR] [nvarchar](200) NULL,
	[ZTYPE] [nvarchar](30) NULL,
	[ZRAWCOST] [nvarchar](30) NULL,
	[ZBILLAMOUNT] [nvarchar](30) NULL,
	[NETDT] [nvarchar](30) NULL,
	[AUGDT] [nvarchar](30) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ACDOCA_2024]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ACDOCA_2024](
	[RCLNT] [nvarchar](30) NULL,
	[RLDNR] [nvarchar](30) NULL,
	[RBUKRS] [nvarchar](30) NULL,
	[GJAHR] [nvarchar](30) NULL,
	[BELNR] [nvarchar](30) NULL,
	[DOCLN] [nvarchar](30) NULL,
	[RYEAR] [nvarchar](30) NULL,
	[VORGN] [nvarchar](30) NULL,
	[VRGNG] [nvarchar](30) NULL,
	[BTTYPE] [nvarchar](30) NULL,
	[AWTYP] [nvarchar](30) NULL,
	[AWSYS] [nvarchar](30) NULL,
	[AWORG] [nvarchar](30) NULL,
	[AWREF] [nvarchar](30) NULL,
	[AWITEM] [nvarchar](30) NULL,
	[AWITGRP] [nvarchar](30) NULL,
	[SUBTA] [nvarchar](30) NULL,
	[XREVERSING] [nvarchar](30) NULL,
	[XREVERSED] [nvarchar](30) NULL,
	[XTRUEREV] [nvarchar](30) NULL,
	[AWTYP_REV] [nvarchar](30) NULL,
	[AWORG_REV] [nvarchar](30) NULL,
	[AWREF_REV] [nvarchar](30) NULL,
	[SUBTA_REV] [nvarchar](30) NULL,
	[XSETTLING] [nvarchar](30) NULL,
	[XSETTLED] [nvarchar](30) NULL,
	[RTCUR] [nvarchar](30) NULL,
	[RWCUR] [nvarchar](30) NULL,
	[RHCUR] [nvarchar](30) NULL,
	[RKCUR] [nvarchar](30) NULL,
	[ROCUR] [nvarchar](30) NULL,
	[RVCUR] [nvarchar](30) NULL,
	[RUNIT] [nvarchar](30) NULL,
	[RVUNIT] [nvarchar](30) NULL,
	[CO_MEINH] [nvarchar](30) NULL,
	[RACCT] [nvarchar](30) NULL,
	[RCNTR] [nvarchar](30) NULL,
	[PRCTR] [nvarchar](30) NULL,
	[RBUSA] [nvarchar](30) NULL,
	[KOKRS] [nvarchar](30) NULL,
	[SEGMENT] [nvarchar](30) NULL,
	[SCNTR] [nvarchar](30) NULL,
	[PPRCTR] [nvarchar](30) NULL,
	[SBUSA] [nvarchar](30) NULL,
	[TSL] [nvarchar](30) NULL,
	[WSL] [nvarchar](30) NULL,
	[WSL2] [nvarchar](30) NULL,
	[WSL3] [nvarchar](30) NULL,
	[HSL] [nvarchar](30) NULL,
	[KSL] [nvarchar](30) NULL,
	[OSL] [nvarchar](30) NULL,
	[VSL] [nvarchar](30) NULL,
	[PSL] [nvarchar](30) NULL,
	[MSL] [nvarchar](30) NULL,
	[MFSL] [nvarchar](30) NULL,
	[VMSL] [nvarchar](30) NULL,
	[VMFSL] [nvarchar](30) NULL,
	[CO_MEGBTR] [nvarchar](30) NULL,
	[DRCRK] [nvarchar](30) NULL,
	[POPER] [nvarchar](30) NULL,
	[PERIV] [nvarchar](30) NULL,
	[FISCYEARPER] [nvarchar](30) NULL,
	[BUDAT] [nvarchar](30) NULL,
	[BLDAT] [nvarchar](30) NULL,
	[BLART] [nvarchar](30) NULL,
	[BUZEI] [nvarchar](30) NULL,
	[ZUONR] [nvarchar](30) NULL,
	[BSCHL] [nvarchar](30) NULL,
	[BSTAT] [nvarchar](30) NULL,
	[LINETYPE] [nvarchar](30) NULL,
	[KTOSL] [nvarchar](30) NULL,
	[XSPLITMOD] [nvarchar](30) NULL,
	[USNAM] [nvarchar](30) NULL,
	[TIMESTAMP] [nvarchar](30) NULL,
	[EPRCTR] [nvarchar](30) NULL,
	[RHOART] [nvarchar](30) NULL,
	[GLACCOUNT_TYPE] [nvarchar](30) NULL,
	[KTOPL] [nvarchar](30) NULL,
	[LOKKT] [nvarchar](30) NULL,
	[KTOP2] [nvarchar](30) NULL,
	[REBZG] [nvarchar](30) NULL,
	[REBZJ] [nvarchar](30) NULL,
	[REBZZ] [nvarchar](30) NULL,
	[REBZT] [nvarchar](30) NULL,
	[RBEST] [nvarchar](30) NULL,
	[EBELN] [nvarchar](30) NULL,
	[EBELP] [nvarchar](30) NULL,
	[ZEKKN] [nvarchar](30) NULL,
	[SGTXT] [nvarchar](200) NULL,
	[KDAUF] [nvarchar](30) NULL,
	[KDPOS] [nvarchar](30) NULL,
	[MATNR] [nvarchar](30) NULL,
	[WERKS] [nvarchar](30) NULL,
	[LIFNR] [nvarchar](30) NULL,
	[KUNNR] [nvarchar](30) NULL,
	[FBUDA] [nvarchar](30) NULL,
	[KOART] [nvarchar](30) NULL,
	[OBJNR] [nvarchar](30) NULL,
	[PAROB1] [nvarchar](30) NULL,
	[PAROBSRC] [nvarchar](30) NULL,
	[USPOB] [nvarchar](30) NULL,
	[CO_BELKZ] [nvarchar](30) NULL,
	[CO_BEKNZ] [nvarchar](30) NULL,
	[BELTP] [nvarchar](30) NULL,
	[MUVFLG] [nvarchar](30) NULL,
	[GKONT] [nvarchar](30) NULL,
	[GKOAR] [nvarchar](30) NULL,
	[PERNR] [nvarchar](30) NULL,
	[SCOPE] [nvarchar](30) NULL,
	[PBUKRS] [nvarchar](30) NULL,
	[PSCOPE] [nvarchar](30) NULL,
	[BWSTRAT] [nvarchar](30) NULL,
	[UKOSTL] [nvarchar](30) NULL,
	[ULSTAR] [nvarchar](30) NULL,
	[ACCAS] [nvarchar](30) NULL,
	[ACCASTY] [nvarchar](30) NULL,
	[LSTAR] [nvarchar](30) NULL,
	[PS_PSP_PNR] [nvarchar](30) NULL,
	[PS_POSID] [nvarchar](30) NULL,
	[PS_PRJ_PNR] [nvarchar](30) NULL,
	[PS_PSPID] [nvarchar](30) NULL,
	[NPLNR] [nvarchar](30) NULL,
	[NPLNR_VORGN] [nvarchar](30) NULL,
	[PACCAS] [nvarchar](30) NULL,
	[PACCASTY] [nvarchar](30) NULL,
	[PLSTAR] [nvarchar](30) NULL,
	[PNPLNR] [nvarchar](30) NULL,
	[PNPLNR_VORGN] [nvarchar](30) NULL,
	[CO_ZLENR] [nvarchar](30) NULL,
	[CO_BELNR] [nvarchar](30) NULL,
	[CO_BUZEI] [nvarchar](30) NULL,
	[ARBID] [nvarchar](30) NULL,
	[VORNR] [nvarchar](30) NULL,
	[FKART] [nvarchar](30) NULL,
	[VKORG] [nvarchar](30) NULL,
	[VTWEG] [nvarchar](30) NULL,
	[SPART] [nvarchar](30) NULL,
	[ZBILLABLE] [nvarchar](30) NULL,
	[ZEXP_TYP] [nvarchar](30) NULL,
	[ZEXPENDITURE] [nvarchar](30) NULL,
	[ZBWR] [nvarchar](30) NULL,
	[ZAR_INVOICE] [nvarchar](30) NULL,
	[ZVENDOR] [nvarchar](200) NULL,
	[ZTYPE] [nvarchar](30) NULL,
	[ZRAWCOST] [nvarchar](30) NULL,
	[ZBILLAMOUNT] [nvarchar](30) NULL,
	[NETDT] [nvarchar](30) NULL,
	[AUGDT] [nvarchar](30) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ACDOCA_TEST]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ACDOCA_TEST](
	[RCLNT] [nvarchar](30) NULL,
	[RLDNR] [nvarchar](30) NULL,
	[RBUKRS] [nvarchar](30) NULL,
	[GJAHR] [nvarchar](30) NULL,
	[BELNR] [nvarchar](30) NULL,
	[DOCLN] [nvarchar](30) NULL,
	[RYEAR] [nvarchar](30) NULL,
	[VORGN] [nvarchar](30) NULL,
	[VRGNG] [nvarchar](30) NULL,
	[BTTYPE] [nvarchar](30) NULL,
	[AWTYP] [nvarchar](30) NULL,
	[AWSYS] [nvarchar](30) NULL,
	[AWORG] [nvarchar](30) NULL,
	[AWREF] [nvarchar](30) NULL,
	[AWITEM] [nvarchar](30) NULL,
	[AWITGRP] [nvarchar](30) NULL,
	[SUBTA] [nvarchar](30) NULL,
	[XREVERSING] [nvarchar](30) NULL,
	[XREVERSED] [nvarchar](30) NULL,
	[XTRUEREV] [nvarchar](30) NULL,
	[AWTYP_REV] [nvarchar](30) NULL,
	[AWORG_REV] [nvarchar](30) NULL,
	[AWREF_REV] [nvarchar](30) NULL,
	[SUBTA_REV] [nvarchar](30) NULL,
	[XSETTLING] [nvarchar](30) NULL,
	[XSETTLED] [nvarchar](30) NULL,
	[RTCUR] [nvarchar](30) NULL,
	[RWCUR] [nvarchar](30) NULL,
	[RHCUR] [nvarchar](30) NULL,
	[RKCUR] [nvarchar](30) NULL,
	[ROCUR] [nvarchar](30) NULL,
	[RVCUR] [nvarchar](30) NULL,
	[RUNIT] [nvarchar](30) NULL,
	[RVUNIT] [nvarchar](30) NULL,
	[CO_MEINH] [nvarchar](30) NULL,
	[RACCT] [nvarchar](30) NULL,
	[RCNTR] [nvarchar](30) NULL,
	[PRCTR] [nvarchar](30) NULL,
	[RBUSA] [nvarchar](30) NULL,
	[KOKRS] [nvarchar](30) NULL,
	[SEGMENT] [nvarchar](30) NULL,
	[SCNTR] [nvarchar](30) NULL,
	[PPRCTR] [nvarchar](30) NULL,
	[SBUSA] [nvarchar](30) NULL,
	[TSL] [nvarchar](30) NULL,
	[WSL] [nvarchar](30) NULL,
	[WSL2] [nvarchar](30) NULL,
	[WSL3] [nvarchar](30) NULL,
	[HSL] [nvarchar](30) NULL,
	[KSL] [nvarchar](30) NULL,
	[OSL] [nvarchar](30) NULL,
	[VSL] [nvarchar](30) NULL,
	[PSL] [nvarchar](30) NULL,
	[MSL] [nvarchar](30) NULL,
	[MFSL] [nvarchar](30) NULL,
	[VMSL] [nvarchar](30) NULL,
	[VMFSL] [nvarchar](30) NULL,
	[CO_MEGBTR] [nvarchar](30) NULL,
	[DRCRK] [nvarchar](30) NULL,
	[POPER] [nvarchar](30) NULL,
	[PERIV] [nvarchar](30) NULL,
	[FISCYEARPER] [nvarchar](30) NULL,
	[BUDAT] [nvarchar](30) NULL,
	[BLDAT] [nvarchar](30) NULL,
	[BLART] [nvarchar](30) NULL,
	[BUZEI] [nvarchar](30) NULL,
	[ZUONR] [nvarchar](30) NULL,
	[BSCHL] [nvarchar](30) NULL,
	[BSTAT] [nvarchar](30) NULL,
	[LINETYPE] [nvarchar](30) NULL,
	[KTOSL] [nvarchar](30) NULL,
	[XSPLITMOD] [nvarchar](30) NULL,
	[USNAM] [nvarchar](30) NULL,
	[TIMESTAMP] [nvarchar](30) NULL,
	[EPRCTR] [nvarchar](30) NULL,
	[RHOART] [nvarchar](30) NULL,
	[GLACCOUNT_TYPE] [nvarchar](30) NULL,
	[KTOPL] [nvarchar](30) NULL,
	[LOKKT] [nvarchar](30) NULL,
	[KTOP2] [nvarchar](30) NULL,
	[REBZG] [nvarchar](30) NULL,
	[REBZJ] [nvarchar](30) NULL,
	[REBZZ] [nvarchar](30) NULL,
	[REBZT] [nvarchar](30) NULL,
	[RBEST] [nvarchar](30) NULL,
	[EBELN] [nvarchar](30) NULL,
	[EBELP] [nvarchar](30) NULL,
	[ZEKKN] [nvarchar](30) NULL,
	[SGTXT] [nvarchar](200) NULL,
	[KDAUF] [nvarchar](30) NULL,
	[KDPOS] [nvarchar](30) NULL,
	[MATNR] [nvarchar](30) NULL,
	[WERKS] [nvarchar](30) NULL,
	[LIFNR] [nvarchar](30) NULL,
	[KUNNR] [nvarchar](30) NULL,
	[FBUDA] [nvarchar](30) NULL,
	[KOART] [nvarchar](30) NULL,
	[OBJNR] [nvarchar](30) NULL,
	[PAROB1] [nvarchar](30) NULL,
	[PAROBSRC] [nvarchar](30) NULL,
	[USPOB] [nvarchar](30) NULL,
	[CO_BELKZ] [nvarchar](30) NULL,
	[CO_BEKNZ] [nvarchar](30) NULL,
	[BELTP] [nvarchar](30) NULL,
	[MUVFLG] [nvarchar](30) NULL,
	[GKONT] [nvarchar](30) NULL,
	[GKOAR] [nvarchar](30) NULL,
	[PERNR] [nvarchar](30) NULL,
	[SCOPE] [nvarchar](30) NULL,
	[PBUKRS] [nvarchar](30) NULL,
	[PSCOPE] [nvarchar](30) NULL,
	[BWSTRAT] [nvarchar](30) NULL,
	[UKOSTL] [nvarchar](30) NULL,
	[ULSTAR] [nvarchar](30) NULL,
	[ACCAS] [nvarchar](30) NULL,
	[ACCASTY] [nvarchar](30) NULL,
	[LSTAR] [nvarchar](30) NULL,
	[PS_PSP_PNR] [nvarchar](30) NULL,
	[PS_POSID] [nvarchar](30) NULL,
	[PS_PRJ_PNR] [nvarchar](30) NULL,
	[PS_PSPID] [nvarchar](30) NULL,
	[NPLNR] [nvarchar](30) NULL,
	[NPLNR_VORGN] [nvarchar](30) NULL,
	[PACCAS] [nvarchar](30) NULL,
	[PACCASTY] [nvarchar](30) NULL,
	[PLSTAR] [nvarchar](30) NULL,
	[PNPLNR] [nvarchar](30) NULL,
	[PNPLNR_VORGN] [nvarchar](30) NULL,
	[CO_ZLENR] [nvarchar](30) NULL,
	[CO_BELNR] [nvarchar](30) NULL,
	[CO_BUZEI] [nvarchar](30) NULL,
	[ARBID] [nvarchar](30) NULL,
	[VORNR] [nvarchar](30) NULL,
	[FKART] [nvarchar](30) NULL,
	[VKORG] [nvarchar](30) NULL,
	[VTWEG] [nvarchar](30) NULL,
	[SPART] [nvarchar](30) NULL,
	[ZBILLABLE] [nvarchar](30) NULL,
	[ZEXP_TYP] [nvarchar](30) NULL,
	[ZEXPENDITURE] [nvarchar](30) NULL,
	[ZBWR] [nvarchar](30) NULL,
	[ZAR_INVOICE] [nvarchar](30) NULL,
	[ZVENDOR] [nvarchar](200) NULL,
	[ZTYPE] [nvarchar](30) NULL,
	[ZRAWCOST] [nvarchar](30) NULL,
	[ZBILLAMOUNT] [nvarchar](30) NULL,
	[NETDT] [nvarchar](30) NULL,
	[AUGDT] [nvarchar](30) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[AFVC]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[AFVC](
	[MANDT] [nvarchar](3) NULL,
	[AUFPL] [nvarchar](10) NULL,
	[APLZL] [nvarchar](8) NULL,
	[PLNFL] [nvarchar](6) NULL,
	[PLNKN] [nvarchar](8) NULL,
	[PLNAL] [nvarchar](2) NULL,
	[PLNTY] [nvarchar](1) NULL,
	[VINTV] [numeric](3, 0) NULL,
	[PLNNR] [nvarchar](8) NULL,
	[ZAEHL] [nvarchar](8) NULL,
	[VORNR] [nvarchar](4) NULL,
	[STEUS] [nvarchar](4) NULL,
	[ARBID] [nvarchar](8) NULL,
	[PDEST] [nvarchar](4) NULL,
	[WERKS] [nvarchar](4) NULL,
	[KTSCH] [nvarchar](7) NULL,
	[LTXA1] [nvarchar](40) NULL,
	[LTXA2] [nvarchar](40) NULL,
	[TXTSP] [nvarchar](1) NULL,
	[VPLTY] [nvarchar](1) NULL,
	[VPLNR] [nvarchar](8) NULL,
	[VPLAL] [nvarchar](2) NULL,
	[VPLFL] [nvarchar](6) NULL,
	[VGWTS] [nvarchar](4) NULL,
	[LAR01] [nvarchar](6) NULL,
	[LAR02] [nvarchar](6) NULL,
	[LAR03] [nvarchar](6) NULL,
	[LAR04] [nvarchar](6) NULL,
	[LAR05] [nvarchar](6) NULL,
	[LAR06] [nvarchar](6) NULL,
	[ZERMA] [nvarchar](5) NULL,
	[ZGDAT] [nvarchar](4) NULL,
	[ZCODE] [nvarchar](6) NULL,
	[ZULNR] [nvarchar](5) NULL,
	[LOANZ] [numeric](3, 0) NULL,
	[LOART] [nvarchar](4) NULL,
	[RSANZ] [nvarchar](3) NULL,
	[QUALF] [nvarchar](2) NULL,
	[ANZMA] [numeric](5, 2) NULL,
	[RFGRP] [nvarchar](10) NULL,
	[RFSCH] [nvarchar](10) NULL,
	[RASCH] [nvarchar](2) NULL,
	[AUFAK] [numeric](5, 3) NULL,
	[LOGRP] [nvarchar](3) NULL,
	[UEMUS] [nvarchar](1) NULL,
	[UEKAN] [nvarchar](1) NULL,
	[FLIES] [nvarchar](1) NULL,
	[SPMUS] [nvarchar](1) NULL,
	[SPLIM] [numeric](3, 0) NULL,
	[ABLIPKZ] [nvarchar](1) NULL,
	[RSTRA] [nvarchar](2) NULL,
	[SUMNR] [nvarchar](8) NULL,
	[SORTL] [nvarchar](10) NULL,
	[LIFNR] [nvarchar](10) NULL,
	[PREIS] [numeric](11, 2) NULL,
	[PEINH] [numeric](5, 0) NULL,
	[SAKTO] [nvarchar](10) NULL,
	[WAERS] [nvarchar](5) NULL,
	[INFNR] [nvarchar](10) NULL,
	[ESOKZ] [nvarchar](1) NULL,
	[EKORG] [nvarchar](4) NULL,
	[EKGRP] [nvarchar](3) NULL,
	[KZLGF] [nvarchar](1) NULL,
	[KZWRTF] [nvarchar](1) NULL,
	[MATKL] [nvarchar](9) NULL,
	[DDEHN] [nvarchar](1) NULL,
	[ANZZL] [smallint] NULL,
	[PRZNT] [smallint] NULL,
	[MLSTN] [nvarchar](5) NULL,
	[PPRIO] [nvarchar](2) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[ANFKO] [nvarchar](10) NULL,
	[ANFKOKRS] [nvarchar](4) NULL,
	[INDET] [nvarchar](1) NULL,
	[LARNT] [nvarchar](6) NULL,
	[PRKST] [numeric](11, 2) NULL,
	[APLFL] [nvarchar](6) NULL,
	[RUECK] [nvarchar](10) NULL,
	[RMZHL] [nvarchar](8) NULL,
	[PROJN] [nvarchar](8) NULL,
	[OBJNR] [nvarchar](22) NULL,
	[SPANZ] [numeric](3, 0) NULL,
	[BEDID] [nvarchar](12) NULL,
	[BEDZL] [nvarchar](8) NULL,
	[BANFN] [nvarchar](10) NULL,
	[BNFPO] [nvarchar](5) NULL,
	[LEK01] [nvarchar](1) NULL,
	[LEK02] [nvarchar](1) NULL,
	[LEK03] [nvarchar](1) NULL,
	[LEK04] [nvarchar](1) NULL,
	[LEK05] [nvarchar](1) NULL,
	[LEK06] [nvarchar](1) NULL,
	[SELKZ] [nvarchar](1) NULL,
	[KALID] [nvarchar](2) NULL,
	[FRSP] [nvarchar](1) NULL,
	[STDKN] [nvarchar](8) NULL,
	[ANLZU] [nvarchar](1) NULL,
	[ISTRU] [nvarchar](40) NULL,
	[ISTTY] [nvarchar](1) NULL,
	[ISTNR] [nvarchar](8) NULL,
	[ISTKN] [nvarchar](8) NULL,
	[ISTPO] [nvarchar](8) NULL,
	[IUPOZ] [nvarchar](4) NULL,
	[EBORT] [nvarchar](20) NULL,
	[VERTL] [nvarchar](8) NULL,
	[LEKNW] [nvarchar](1) NULL,
	[NPRIO] [nvarchar](1) NULL,
	[PVZKN] [nvarchar](8) NULL,
	[PHFLG] [nvarchar](1) NULL,
	[PHSEQ] [nvarchar](2) NULL,
	[KNOBJ] [nvarchar](18) NULL,
	[ERFSICHT] [nvarchar](2) NULL,
	[QPPKTABS] [nvarchar](1) NULL,
	[OTYPE] [nvarchar](2) NULL,
	[OBJEKTID] [nvarchar](8) NULL,
	[QLKAPAR] [nvarchar](3) NULL,
	[RSTUF] [nvarchar](1) NULL,
	[NPTXTKY] [nvarchar](12) NULL,
	[SUBSYS] [nvarchar](6) NULL,
	[PSPNR] [nvarchar](8) NULL,
	[PACKNO] [nvarchar](10) NULL,
	[TXJCD] [nvarchar](15) NULL,
	[SCOPE] [nvarchar](2) NULL,
	[GSBER] [nvarchar](4) NULL,
	[PRCTR] [nvarchar](10) NULL,
	[NO_DISP] [nvarchar](1) NULL,
	[QKZPRZEIT] [nvarchar](1) NULL,
	[QKZZTMG1] [nvarchar](1) NULL,
	[QKZPRMENG] [nvarchar](1) NULL,
	[QKZPRFREI] [nvarchar](1) NULL,
	[KZFEAT] [nvarchar](1) NULL,
	[QKZTLSBEST] [nvarchar](1) NULL,
	[AENNR] [nvarchar](12) NULL,
	[CUOBJ_ARB] [nvarchar](18) NULL,
	[EVGEW] [numeric](8, 0) NULL,
	[ARBII] [nvarchar](8) NULL,
	[WERKI] [nvarchar](4) NULL,
	[CY_SEQNRV] [nvarchar](14) NULL,
	[KAPT_PUFFR] [int] NULL,
	[EBELN] [nvarchar](10) NULL,
	[EBELP] [nvarchar](5) NULL,
	[WEMPF] [nvarchar](12) NULL,
	[ABLAD] [nvarchar](25) NULL,
	[CLASF] [nvarchar](1) NULL,
	[FRUNV] [nvarchar](1) NULL,
	[ZSCHL] [nvarchar](6) NULL,
	[KALSM] [nvarchar](6) NULL,
	[SCHED_END] [nvarchar](1) NULL,
	[NETZKONT] [nvarchar](1) NULL,
	[OWAER] [nvarchar](5) NULL,
	[AFNAM] [nvarchar](12) NULL,
	[BEDNR] [nvarchar](10) NULL,
	[KZFIX] [nvarchar](1) NULL,
	[PERNR] [nvarchar](8) NULL,
	[FRDLB] [nvarchar](1) NULL,
	[QPART] [nvarchar](8) NULL,
	[LOEKZ] [nvarchar](1) NULL,
	[WKURS] [numeric](9, 5) NULL,
	[PROD_ACT] [nvarchar](1) NULL,
	[FPLNR] [nvarchar](10) NULL,
	[OBJTYPE] [nvarchar](1) NULL,
	[CH_PROC] [nvarchar](1) NULL,
	[KLVAR] [nvarchar](4) NULL,
	[KALNR] [nvarchar](12) NULL,
	[FORDN] [nvarchar](10) NULL,
	[FORDP] [nvarchar](5) NULL,
	[MAT_PRKST] [numeric](11, 2) NULL,
	[PRZ01] [nvarchar](12) NULL,
	[RFPNT] [nvarchar](20) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[TECHS] [nvarchar](12) NULL,
	[ADPSP] [nvarchar](40) NULL,
	[RFIPPNT] [nvarchar](20) NULL,
	[MES_OPERID] [nvarchar](48) NULL,
	[MES_STEPID] [nvarchar](6) NULL,
	[OAN_INST_ID_SETUP] [int] NULL,
	[OAN_INST_ID_PRODUCE] [int] NULL,
	[OAN_INST_ID_TEARDOWN] [int] NULL,
	[TL_VERSN] [nvarchar](4) NULL,
	[DUMMY_AFVC_INCL_EEW_PS] [nvarchar](1) NULL,
	[/CUM/CUGUID] [binary](16) NULL,
	[/ISDFPS/OBJNR] [nvarchar](22) NULL,
	[MILL_OC_AUFNR_MO] [nvarchar](12) NULL,
	[WTY_IND] [nvarchar](1) NULL,
	[TPLNR] [nvarchar](30) NULL,
	[EQUNR] [nvarchar](18) NULL,
	[CPD_UPDAT] [numeric](15, 0) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[AUFK]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[AUFK](
	[MANDT] [nvarchar](3) NULL,
	[AUFNR] [nvarchar](12) NULL,
	[AUART] [nvarchar](4) NULL,
	[AUTYP] [nvarchar](2) NULL,
	[REFNR] [nvarchar](12) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[ERDAT] [nvarchar](8) NULL,
	[AENAM] [nvarchar](12) NULL,
	[AEDAT] [nvarchar](8) NULL,
	[KTEXT] [nvarchar](40) NULL,
	[LTEXT] [nvarchar](1) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[WERKS] [nvarchar](4) NULL,
	[GSBER] [nvarchar](4) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[CCKEY] [nvarchar](23) NULL,
	[KOSTV] [nvarchar](10) NULL,
	[STORT] [nvarchar](10) NULL,
	[SOWRK] [nvarchar](4) NULL,
	[ASTKZ] [nvarchar](1) NULL,
	[WAERS] [nvarchar](5) NULL,
	[ASTNR] [nvarchar](2) NULL,
	[STDAT] [nvarchar](8) NULL,
	[ESTNR] [nvarchar](2) NULL,
	[PHAS0] [nvarchar](1) NULL,
	[PHAS1] [nvarchar](1) NULL,
	[PHAS2] [nvarchar](1) NULL,
	[PHAS3] [nvarchar](1) NULL,
	[PDAT1] [nvarchar](8) NULL,
	[PDAT2] [nvarchar](8) NULL,
	[PDAT3] [nvarchar](8) NULL,
	[IDAT1] [nvarchar](8) NULL,
	[IDAT2] [nvarchar](8) NULL,
	[IDAT3] [nvarchar](8) NULL,
	[OBJID] [nvarchar](1) NULL,
	[VOGRP] [nvarchar](4) NULL,
	[LOEKZ] [nvarchar](1) NULL,
	[PLGKZ] [nvarchar](1) NULL,
	[KVEWE] [nvarchar](1) NULL,
	[KAPPL] [nvarchar](2) NULL,
	[KALSM] [nvarchar](6) NULL,
	[ZSCHL] [nvarchar](6) NULL,
	[ABKRS] [nvarchar](2) NULL,
	[KSTAR] [nvarchar](10) NULL,
	[KOSTL] [nvarchar](10) NULL,
	[SAKNR] [nvarchar](10) NULL,
	[SETNM] [nvarchar](12) NULL,
	[CYCLE] [nvarchar](10) NULL,
	[SDATE] [nvarchar](8) NULL,
	[SEQNR] [nvarchar](4) NULL,
	[USER0] [nvarchar](20) NULL,
	[USER1] [nvarchar](20) NULL,
	[USER2] [nvarchar](20) NULL,
	[USER3] [nvarchar](20) NULL,
	[USER4] [numeric](11, 2) NULL,
	[USER5] [nvarchar](8) NULL,
	[USER6] [nvarchar](15) NULL,
	[USER7] [nvarchar](8) NULL,
	[USER8] [nvarchar](8) NULL,
	[USER9] [nvarchar](1) NULL,
	[OBJNR] [nvarchar](22) NULL,
	[PRCTR] [nvarchar](10) NULL,
	[PSPEL] [nvarchar](8) NULL,
	[AWSLS] [nvarchar](6) NULL,
	[ABGSL] [nvarchar](6) NULL,
	[TXJCD] [nvarchar](15) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[SCOPE] [nvarchar](2) NULL,
	[PLINT] [nvarchar](1) NULL,
	[KDAUF] [nvarchar](10) NULL,
	[KDPOS] [nvarchar](6) NULL,
	[AUFEX] [nvarchar](20) NULL,
	[IVPRO] [nvarchar](6) NULL,
	[LOGSYSTEM] [nvarchar](10) NULL,
	[FLG_MLTPS] [nvarchar](1) NULL,
	[ABUKR] [nvarchar](4) NULL,
	[AKSTL] [nvarchar](10) NULL,
	[SIZECL] [nvarchar](2) NULL,
	[IZWEK] [nvarchar](2) NULL,
	[UMWKZ] [nvarchar](5) NULL,
	[KSTEMPF] [nvarchar](1) NULL,
	[ZSCHM] [nvarchar](7) NULL,
	[PKOSA] [nvarchar](12) NULL,
	[ANFAUFNR] [nvarchar](12) NULL,
	[PROCNR] [nvarchar](12) NULL,
	[PROTY] [nvarchar](4) NULL,
	[RSORD] [nvarchar](1) NULL,
	[BEMOT] [nvarchar](2) NULL,
	[ADRNRA] [nvarchar](10) NULL,
	[ERFZEIT] [nvarchar](6) NULL,
	[AEZEIT] [nvarchar](6) NULL,
	[CSTG_VRNT] [nvarchar](4) NULL,
	[COSTESTNR] [nvarchar](12) NULL,
	[VERAA_USER] [nvarchar](12) NULL,
	[EEW_AUFK_PS_DUMMY] [nvarchar](1) NULL,
	[VNAME] [nvarchar](6) NULL,
	[RECID] [nvarchar](2) NULL,
	[ETYPE] [nvarchar](3) NULL,
	[OTYPE] [nvarchar](4) NULL,
	[JV_JIBCL] [nvarchar](3) NULL,
	[JV_JIBSA] [nvarchar](5) NULL,
	[JV_OCO] [nvarchar](1) NULL,
	[CPD_UPDAT] [numeric](15, 0) NULL,
	[/CUM/INDCU] [nvarchar](1) NULL,
	[/CUM/CMNUM] [nvarchar](12) NULL,
	[/CUM/AUEST] [nvarchar](1) NULL,
	[/CUM/DESNUM] [nvarchar](12) NULL,
	[AD01PROFNR] [nvarchar](8) NULL,
	[VAPLZ] [nvarchar](8) NULL,
	[WAWRK] [nvarchar](4) NULL,
	[FERC_IND] [nvarchar](4) NULL,
	[CLAIM_CONTROL] [nvarchar](1) NULL,
	[UPDATE_NEEDED] [nvarchar](1) NULL,
	[UPDATE_CONTROL] [nvarchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CATSCO]    Script Date: 02/08/2024 08:01:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CATSCO](
	[MANDT] [nvarchar](3) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[BEMOT] [nvarchar](2) NULL,
	[COUNTER] [nvarchar](12) NULL,
	[STOKZ] [nvarchar](1) NULL,
	[PERNR] [nvarchar](8) NULL,
	[WORKDATE] [nvarchar](8) NULL,
	[CATSHOURS] [numeric](4, 2) NULL,
	[SKOSTL] [nvarchar](10) NULL,
	[LSTAR] [nvarchar](6) NULL,
	[SPRZNR] [nvarchar](12) NULL,
	[RKOSTL] [nvarchar](10) NULL,
	[RPROJ] [nvarchar](8) NULL,
	[RAUFNR] [nvarchar](12) NULL,
	[RAUFPL] [nvarchar](10) NULL,
	[RAPLZL] [nvarchar](8) NULL,
	[RKDAUF] [nvarchar](10) NULL,
	[RKDPOS] [nvarchar](6) NULL,
	[RKSTR] [nvarchar](12) NULL,
	[RNPLNR] [nvarchar](12) NULL,
	[RPRZNR] [nvarchar](12) NULL,
	[PAOBJNR] [nvarchar](10) NULL,
	[LTXA1] [nvarchar](40) NULL,
	[LOGSYS] [nvarchar](10) NULL,
	[BELNR] [nvarchar](10) NULL,
	[REFCOUNTER] [nvarchar](12) NULL,
	[TRANSFER] [nvarchar](1) NULL,
	[MEINH] [nvarchar](3) NULL,
	[PRICE] [numeric](11, 2) NULL,
	[TCURR] [nvarchar](5) NULL,
	[HRKOSTL] [nvarchar](10) NULL,
	[HRLSTAR] [nvarchar](6) NULL,
	[HRCOSTASG] [nvarchar](1) NULL,
	[STATKEYFIG] [nvarchar](6) NULL,
	[CATSQUANTITY] [numeric](15, 3) NULL,
	[UNIT] [nvarchar](3) NULL,
	[FUND] [nvarchar](10) NULL,
	[GRANT_NBR] [nvarchar](20) NULL,
	[S_FUND] [nvarchar](10) NULL,
	[S_FUNC_AREA] [nvarchar](16) NULL,
	[S_GRANT_NBR] [nvarchar](20) NULL,
	[HRFUND] [nvarchar](10) NULL,
	[HRFUNC_AREA] [nvarchar](16) NULL,
	[HRGRANT_NBR] [nvarchar](20) NULL,
	[BUDGET_PD] [nvarchar](10) NULL,
	[SBUDGET_PD] [nvarchar](10) NULL,
	[HRBUDGET_PD] [nvarchar](10) NULL,
	[WORK_ITEM_ID] [nvarchar](10) NULL,
	[DUMMY_INCL_EEW_PRS_CPILS] [nvarchar](1) NULL,
	[FM_SPLIT_FLG] [nvarchar](1) NULL,
	[ZINTRABU] [nvarchar](1) NULL,
	[BUDAT] [nvarchar](8) NULL,
	[BUDAT_C] [nvarchar](8) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CATSDB]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CATSDB](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[COUNTER] [nvarchar](12) NULL,
	[WORKDATE] [nvarchar](8) NULL,
	[SKOSTL] [nvarchar](10) NULL,
	[LSTAR] [nvarchar](6) NULL,
	[SEBELN] [nvarchar](10) NULL,
	[SEBELP] [nvarchar](5) NULL,
	[SPRZNR] [nvarchar](12) NULL,
	[LSTNR] [nvarchar](18) NULL,
	[RKOSTL] [nvarchar](10) NULL,
	[RPROJ] [nvarchar](8) NULL,
	[RAUFNR] [nvarchar](12) NULL,
	[RNPLNR] [nvarchar](12) NULL,
	[RAUFPL] [nvarchar](10) NULL,
	[RAPLZL] [nvarchar](8) NULL,
	[RKDAUF] [nvarchar](10) NULL,
	[RKDPOS] [nvarchar](6) NULL,
	[RKSTR] [nvarchar](12) NULL,
	[RPRZNR] [nvarchar](12) NULL,
	[PAOBJNR] [nvarchar](10) NULL,
	[FUND] [nvarchar](10) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[GRANT_NBR] [nvarchar](20) NULL,
	[S_FUND] [nvarchar](10) NULL,
	[S_FUNC_AREA] [nvarchar](16) NULL,
	[S_GRANT_NBR] [nvarchar](20) NULL,
	[BUDGET_PD] [nvarchar](10) NULL,
	[SBUDGET_PD] [nvarchar](10) NULL,
	[WORK_ITEM_ID] [nvarchar](10) NULL,
	[AWART] [nvarchar](4) NULL,
	[LGART] [nvarchar](4) NULL,
	[KAPID] [nvarchar](8) NULL,
	[SPLIT] [smallint] NULL,
	[REINR] [nvarchar](10) NULL,
	[WABLNR] [nvarchar](10) NULL,
	[VERSL] [nvarchar](1) NULL,
	[WTART] [nvarchar](4) NULL,
	[BWGRL] [numeric](13, 2) NULL,
	[WAERS] [nvarchar](5) NULL,
	[AUFKZ] [nvarchar](1) NULL,
	[TRFGR] [nvarchar](8) NULL,
	[TRFST] [nvarchar](2) NULL,
	[PRAKN] [nvarchar](2) NULL,
	[PRAKZ] [nvarchar](4) NULL,
	[OTYPE] [nvarchar](2) NULL,
	[PLANS] [nvarchar](8) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[MEINH] [nvarchar](3) NULL,
	[TCURR] [nvarchar](5) NULL,
	[PRICE] [numeric](11, 2) NULL,
	[ARBID] [nvarchar](8) NULL,
	[WERKS] [nvarchar](4) NULL,
	[AUTYP] [nvarchar](2) NULL,
	[HRCOSTASG] [nvarchar](1) NULL,
	[HRKOSTL] [nvarchar](10) NULL,
	[HRLSTAR] [nvarchar](6) NULL,
	[HRFUND] [nvarchar](10) NULL,
	[HRFUNC_AREA] [nvarchar](16) NULL,
	[HRGRANT_NBR] [nvarchar](20) NULL,
	[BEMOT] [nvarchar](2) NULL,
	[UNIT] [nvarchar](3) NULL,
	[STATKEYFIG] [nvarchar](6) NULL,
	[TASKTYPE] [nvarchar](4) NULL,
	[TASKLEVEL] [nvarchar](8) NULL,
	[TASKCOMPONENT] [nvarchar](8) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[CPR_GUID] [nvarchar](32) NULL,
	[CPR_EXTID] [nvarchar](24) NULL,
	[CPR_OBJGUID] [nvarchar](32) NULL,
	[CPR_OBJGEXTID] [nvarchar](24) NULL,
	[CPR_OBJTYPE] [nvarchar](3) NULL,
	[HRBUDGET_PD] [nvarchar](10) NULL,
	[ERSDA] [nvarchar](8) NULL,
	[ERSTM] [nvarchar](6) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[LAEDA] [nvarchar](8) NULL,
	[LAETM] [nvarchar](6) NULL,
	[AENAM] [nvarchar](12) NULL,
	[APNAM] [nvarchar](12) NULL,
	[APDAT] [nvarchar](8) NULL,
	[WORKITEMID] [nvarchar](12) NULL,
	[LOGSYS] [nvarchar](10) NULL,
	[STATUS] [nvarchar](2) NULL,
	[REFCOUNTER] [nvarchar](12) NULL,
	[REASON] [nvarchar](4) NULL,
	[BELNR] [nvarchar](10) NULL,
	[EXTSYSTEM] [nvarchar](10) NULL,
	[EXTAPPLICATION] [nvarchar](5) NULL,
	[EXTDOCUMENTNO] [nvarchar](20) NULL,
	[TASKCOUNTER] [nvarchar](10) NULL,
	[CATSHOURS] [numeric](4, 2) NULL,
	[BEGUZ] [nvarchar](6) NULL,
	[ENDUZ] [nvarchar](6) NULL,
	[VTKEN] [nvarchar](1) NULL,
	[ALLDF] [nvarchar](1) NULL,
	[OFMNW] [numeric](7, 1) NULL,
	[PEDD] [nvarchar](8) NULL,
	[AUERU] [nvarchar](1) NULL,
	[LTXA1] [nvarchar](40) NULL,
	[LONGTEXT] [nvarchar](1) NULL,
	[ERUZU] [nvarchar](1) NULL,
	[CATSAMOUNT] [numeric](13, 2) NULL,
	[CATSQUANTITY] [numeric](15, 3) NULL,
	[ZBILLABLE] [nvarchar](4) NULL,
	[ZCOST] [nvarchar](13) NULL,
	[ZCOST_BILLED] [nvarchar](13) NULL,
	[ZREVENUE] [nvarchar](13) NULL,
	[PRICE_COST_BWRWM] [numeric](11, 2) NULL,
	[PRICE_COST_BWR] [numeric](11, 2) NULL,
	[CC_COST_BWR] [nvarchar](10) NULL,
	[PRICE_COST_ODC] [numeric](11, 2) NULL,
	[CC_COST_ODC] [nvarchar](10) NULL,
	[PRICE_COST_LDC] [numeric](11, 2) NULL,
	[CC_COST_LDC] [nvarchar](10) NULL,
	[PRICE_COST_ADC] [numeric](11, 2) NULL,
	[CC_COST_ADC] [nvarchar](10) NULL,
	[PRICE_REV_BWR] [numeric](11, 2) NULL,
	[PRICE_REV_ODC] [numeric](11, 2) NULL,
	[PRICE_REV_EDC] [numeric](11, 2) NULL,
	[PRICE_REV_LDC] [numeric](11, 2) NULL,
	[COST_INTRA_BU] [numeric](11, 2) NULL,
	[SENDER_CPROFIT] [nvarchar](10) NULL,
	[RECEIVER_CPROFIT] [nvarchar](10) NULL,
	[RKOSTL_TXT] [nvarchar](100) NULL,
	[RPROJ_TXT] [nvarchar](100) NULL,
	[RNETWORK_TXT] [nvarchar](100) NULL,
	[RAWART_TXT] [nvarchar](100) NULL,
	[DUMMY_INCL_EEW_PRS_CPILS] [nvarchar](1) NULL,
	[PRICE_COST_MDC] [numeric](11, 2) NULL,
	[CC_COST_MDC] [nvarchar](10) NULL,
	[PRICE_REV_MDC] [numeric](11, 2) NULL,
	[PRICE_REV_ASR] [numeric](11, 2) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CATSDB_2020]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CATSDB_2020](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[COUNTER] [nvarchar](12) NULL,
	[WORKDATE] [nvarchar](8) NULL,
	[SKOSTL] [nvarchar](10) NULL,
	[LSTAR] [nvarchar](6) NULL,
	[SEBELN] [nvarchar](10) NULL,
	[SEBELP] [nvarchar](5) NULL,
	[SPRZNR] [nvarchar](12) NULL,
	[LSTNR] [nvarchar](18) NULL,
	[RKOSTL] [nvarchar](10) NULL,
	[RPROJ] [nvarchar](8) NULL,
	[RAUFNR] [nvarchar](12) NULL,
	[RNPLNR] [nvarchar](12) NULL,
	[RAUFPL] [nvarchar](10) NULL,
	[RAPLZL] [nvarchar](8) NULL,
	[RKDAUF] [nvarchar](10) NULL,
	[RKDPOS] [nvarchar](6) NULL,
	[RKSTR] [nvarchar](12) NULL,
	[RPRZNR] [nvarchar](12) NULL,
	[PAOBJNR] [nvarchar](10) NULL,
	[FUND] [nvarchar](10) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[GRANT_NBR] [nvarchar](20) NULL,
	[S_FUND] [nvarchar](10) NULL,
	[S_FUNC_AREA] [nvarchar](16) NULL,
	[S_GRANT_NBR] [nvarchar](20) NULL,
	[BUDGET_PD] [nvarchar](10) NULL,
	[SBUDGET_PD] [nvarchar](10) NULL,
	[WORK_ITEM_ID] [nvarchar](10) NULL,
	[AWART] [nvarchar](4) NULL,
	[LGART] [nvarchar](4) NULL,
	[KAPID] [nvarchar](8) NULL,
	[SPLIT] [smallint] NULL,
	[REINR] [nvarchar](10) NULL,
	[WABLNR] [nvarchar](10) NULL,
	[VERSL] [nvarchar](1) NULL,
	[WTART] [nvarchar](4) NULL,
	[BWGRL] [numeric](13, 2) NULL,
	[WAERS] [nvarchar](5) NULL,
	[AUFKZ] [nvarchar](1) NULL,
	[TRFGR] [nvarchar](8) NULL,
	[TRFST] [nvarchar](2) NULL,
	[PRAKN] [nvarchar](2) NULL,
	[PRAKZ] [nvarchar](4) NULL,
	[OTYPE] [nvarchar](2) NULL,
	[PLANS] [nvarchar](8) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[MEINH] [nvarchar](3) NULL,
	[TCURR] [nvarchar](5) NULL,
	[PRICE] [numeric](11, 2) NULL,
	[ARBID] [nvarchar](8) NULL,
	[WERKS] [nvarchar](4) NULL,
	[AUTYP] [nvarchar](2) NULL,
	[HRCOSTASG] [nvarchar](1) NULL,
	[HRKOSTL] [nvarchar](10) NULL,
	[HRLSTAR] [nvarchar](6) NULL,
	[HRFUND] [nvarchar](10) NULL,
	[HRFUNC_AREA] [nvarchar](16) NULL,
	[HRGRANT_NBR] [nvarchar](20) NULL,
	[BEMOT] [nvarchar](2) NULL,
	[UNIT] [nvarchar](3) NULL,
	[STATKEYFIG] [nvarchar](6) NULL,
	[TASKTYPE] [nvarchar](4) NULL,
	[TASKLEVEL] [nvarchar](8) NULL,
	[TASKCOMPONENT] [nvarchar](8) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[CPR_GUID] [nvarchar](32) NULL,
	[CPR_EXTID] [nvarchar](24) NULL,
	[CPR_OBJGUID] [nvarchar](32) NULL,
	[CPR_OBJGEXTID] [nvarchar](24) NULL,
	[CPR_OBJTYPE] [nvarchar](3) NULL,
	[HRBUDGET_PD] [nvarchar](10) NULL,
	[ERSDA] [nvarchar](8) NULL,
	[ERSTM] [nvarchar](6) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[LAEDA] [nvarchar](8) NULL,
	[LAETM] [nvarchar](6) NULL,
	[AENAM] [nvarchar](12) NULL,
	[APNAM] [nvarchar](12) NULL,
	[APDAT] [nvarchar](8) NULL,
	[WORKITEMID] [nvarchar](12) NULL,
	[LOGSYS] [nvarchar](10) NULL,
	[STATUS] [nvarchar](2) NULL,
	[REFCOUNTER] [nvarchar](12) NULL,
	[REASON] [nvarchar](4) NULL,
	[BELNR] [nvarchar](10) NULL,
	[EXTSYSTEM] [nvarchar](10) NULL,
	[EXTAPPLICATION] [nvarchar](5) NULL,
	[EXTDOCUMENTNO] [nvarchar](20) NULL,
	[TASKCOUNTER] [nvarchar](10) NULL,
	[CATSHOURS] [numeric](4, 2) NULL,
	[BEGUZ] [nvarchar](6) NULL,
	[ENDUZ] [nvarchar](6) NULL,
	[VTKEN] [nvarchar](1) NULL,
	[ALLDF] [nvarchar](1) NULL,
	[OFMNW] [numeric](7, 1) NULL,
	[PEDD] [nvarchar](8) NULL,
	[AUERU] [nvarchar](1) NULL,
	[LTXA1] [nvarchar](40) NULL,
	[LONGTEXT] [nvarchar](1) NULL,
	[ERUZU] [nvarchar](1) NULL,
	[CATSAMOUNT] [numeric](13, 2) NULL,
	[CATSQUANTITY] [numeric](15, 3) NULL,
	[ZBILLABLE] [nvarchar](4) NULL,
	[ZCOST] [nvarchar](13) NULL,
	[ZCOST_BILLED] [nvarchar](13) NULL,
	[ZREVENUE] [nvarchar](13) NULL,
	[PRICE_COST_BWRWM] [numeric](11, 2) NULL,
	[PRICE_COST_BWR] [numeric](11, 2) NULL,
	[CC_COST_BWR] [nvarchar](10) NULL,
	[PRICE_COST_ODC] [numeric](11, 2) NULL,
	[CC_COST_ODC] [nvarchar](10) NULL,
	[PRICE_COST_LDC] [numeric](11, 2) NULL,
	[CC_COST_LDC] [nvarchar](10) NULL,
	[PRICE_COST_ADC] [numeric](11, 2) NULL,
	[CC_COST_ADC] [nvarchar](10) NULL,
	[PRICE_REV_BWR] [numeric](11, 2) NULL,
	[PRICE_REV_ODC] [numeric](11, 2) NULL,
	[PRICE_REV_EDC] [numeric](11, 2) NULL,
	[PRICE_REV_LDC] [numeric](11, 2) NULL,
	[COST_INTRA_BU] [numeric](11, 2) NULL,
	[SENDER_CPROFIT] [nvarchar](10) NULL,
	[RECEIVER_CPROFIT] [nvarchar](10) NULL,
	[RKOSTL_TXT] [nvarchar](100) NULL,
	[RPROJ_TXT] [nvarchar](100) NULL,
	[RNETWORK_TXT] [nvarchar](100) NULL,
	[RAWART_TXT] [nvarchar](100) NULL,
	[DUMMY_INCL_EEW_PRS_CPILS] [nvarchar](1) NULL,
	[PRICE_COST_MDC] [numeric](11, 2) NULL,
	[CC_COST_MDC] [nvarchar](10) NULL,
	[PRICE_REV_MDC] [numeric](11, 2) NULL,
	[PRICE_REV_ASR] [numeric](11, 2) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CATSDB_2021]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CATSDB_2021](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[COUNTER] [nvarchar](12) NULL,
	[WORKDATE] [nvarchar](8) NULL,
	[SKOSTL] [nvarchar](10) NULL,
	[LSTAR] [nvarchar](6) NULL,
	[SEBELN] [nvarchar](10) NULL,
	[SEBELP] [nvarchar](5) NULL,
	[SPRZNR] [nvarchar](12) NULL,
	[LSTNR] [nvarchar](18) NULL,
	[RKOSTL] [nvarchar](10) NULL,
	[RPROJ] [nvarchar](8) NULL,
	[RAUFNR] [nvarchar](12) NULL,
	[RNPLNR] [nvarchar](12) NULL,
	[RAUFPL] [nvarchar](10) NULL,
	[RAPLZL] [nvarchar](8) NULL,
	[RKDAUF] [nvarchar](10) NULL,
	[RKDPOS] [nvarchar](6) NULL,
	[RKSTR] [nvarchar](12) NULL,
	[RPRZNR] [nvarchar](12) NULL,
	[PAOBJNR] [nvarchar](10) NULL,
	[FUND] [nvarchar](10) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[GRANT_NBR] [nvarchar](20) NULL,
	[S_FUND] [nvarchar](10) NULL,
	[S_FUNC_AREA] [nvarchar](16) NULL,
	[S_GRANT_NBR] [nvarchar](20) NULL,
	[BUDGET_PD] [nvarchar](10) NULL,
	[SBUDGET_PD] [nvarchar](10) NULL,
	[WORK_ITEM_ID] [nvarchar](10) NULL,
	[AWART] [nvarchar](4) NULL,
	[LGART] [nvarchar](4) NULL,
	[KAPID] [nvarchar](8) NULL,
	[SPLIT] [smallint] NULL,
	[REINR] [nvarchar](10) NULL,
	[WABLNR] [nvarchar](10) NULL,
	[VERSL] [nvarchar](1) NULL,
	[WTART] [nvarchar](4) NULL,
	[BWGRL] [numeric](13, 2) NULL,
	[WAERS] [nvarchar](5) NULL,
	[AUFKZ] [nvarchar](1) NULL,
	[TRFGR] [nvarchar](8) NULL,
	[TRFST] [nvarchar](2) NULL,
	[PRAKN] [nvarchar](2) NULL,
	[PRAKZ] [nvarchar](4) NULL,
	[OTYPE] [nvarchar](2) NULL,
	[PLANS] [nvarchar](8) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[MEINH] [nvarchar](3) NULL,
	[TCURR] [nvarchar](5) NULL,
	[PRICE] [numeric](11, 2) NULL,
	[ARBID] [nvarchar](8) NULL,
	[WERKS] [nvarchar](4) NULL,
	[AUTYP] [nvarchar](2) NULL,
	[HRCOSTASG] [nvarchar](1) NULL,
	[HRKOSTL] [nvarchar](10) NULL,
	[HRLSTAR] [nvarchar](6) NULL,
	[HRFUND] [nvarchar](10) NULL,
	[HRFUNC_AREA] [nvarchar](16) NULL,
	[HRGRANT_NBR] [nvarchar](20) NULL,
	[BEMOT] [nvarchar](2) NULL,
	[UNIT] [nvarchar](3) NULL,
	[STATKEYFIG] [nvarchar](6) NULL,
	[TASKTYPE] [nvarchar](4) NULL,
	[TASKLEVEL] [nvarchar](8) NULL,
	[TASKCOMPONENT] [nvarchar](8) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[CPR_GUID] [nvarchar](32) NULL,
	[CPR_EXTID] [nvarchar](24) NULL,
	[CPR_OBJGUID] [nvarchar](32) NULL,
	[CPR_OBJGEXTID] [nvarchar](24) NULL,
	[CPR_OBJTYPE] [nvarchar](3) NULL,
	[HRBUDGET_PD] [nvarchar](10) NULL,
	[ERSDA] [nvarchar](8) NULL,
	[ERSTM] [nvarchar](6) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[LAEDA] [nvarchar](8) NULL,
	[LAETM] [nvarchar](6) NULL,
	[AENAM] [nvarchar](12) NULL,
	[APNAM] [nvarchar](12) NULL,
	[APDAT] [nvarchar](8) NULL,
	[WORKITEMID] [nvarchar](12) NULL,
	[LOGSYS] [nvarchar](10) NULL,
	[STATUS] [nvarchar](2) NULL,
	[REFCOUNTER] [nvarchar](12) NULL,
	[REASON] [nvarchar](4) NULL,
	[BELNR] [nvarchar](10) NULL,
	[EXTSYSTEM] [nvarchar](10) NULL,
	[EXTAPPLICATION] [nvarchar](5) NULL,
	[EXTDOCUMENTNO] [nvarchar](20) NULL,
	[TASKCOUNTER] [nvarchar](10) NULL,
	[CATSHOURS] [numeric](4, 2) NULL,
	[BEGUZ] [nvarchar](6) NULL,
	[ENDUZ] [nvarchar](6) NULL,
	[VTKEN] [nvarchar](1) NULL,
	[ALLDF] [nvarchar](1) NULL,
	[OFMNW] [numeric](7, 1) NULL,
	[PEDD] [nvarchar](8) NULL,
	[AUERU] [nvarchar](1) NULL,
	[LTXA1] [nvarchar](40) NULL,
	[LONGTEXT] [nvarchar](1) NULL,
	[ERUZU] [nvarchar](1) NULL,
	[CATSAMOUNT] [numeric](13, 2) NULL,
	[CATSQUANTITY] [numeric](15, 3) NULL,
	[ZBILLABLE] [nvarchar](4) NULL,
	[ZCOST] [nvarchar](13) NULL,
	[ZCOST_BILLED] [nvarchar](13) NULL,
	[ZREVENUE] [nvarchar](13) NULL,
	[PRICE_COST_BWRWM] [numeric](11, 2) NULL,
	[PRICE_COST_BWR] [numeric](11, 2) NULL,
	[CC_COST_BWR] [nvarchar](10) NULL,
	[PRICE_COST_ODC] [numeric](11, 2) NULL,
	[CC_COST_ODC] [nvarchar](10) NULL,
	[PRICE_COST_LDC] [numeric](11, 2) NULL,
	[CC_COST_LDC] [nvarchar](10) NULL,
	[PRICE_COST_ADC] [numeric](11, 2) NULL,
	[CC_COST_ADC] [nvarchar](10) NULL,
	[PRICE_REV_BWR] [numeric](11, 2) NULL,
	[PRICE_REV_ODC] [numeric](11, 2) NULL,
	[PRICE_REV_EDC] [numeric](11, 2) NULL,
	[PRICE_REV_LDC] [numeric](11, 2) NULL,
	[COST_INTRA_BU] [numeric](11, 2) NULL,
	[SENDER_CPROFIT] [nvarchar](10) NULL,
	[RECEIVER_CPROFIT] [nvarchar](10) NULL,
	[RKOSTL_TXT] [nvarchar](100) NULL,
	[RPROJ_TXT] [nvarchar](100) NULL,
	[RNETWORK_TXT] [nvarchar](100) NULL,
	[RAWART_TXT] [nvarchar](100) NULL,
	[DUMMY_INCL_EEW_PRS_CPILS] [nvarchar](1) NULL,
	[PRICE_COST_MDC] [numeric](11, 2) NULL,
	[CC_COST_MDC] [nvarchar](10) NULL,
	[PRICE_REV_MDC] [numeric](11, 2) NULL,
	[PRICE_REV_ASR] [numeric](11, 2) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CATSDB_2022]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CATSDB_2022](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[COUNTER] [nvarchar](12) NULL,
	[WORKDATE] [nvarchar](8) NULL,
	[SKOSTL] [nvarchar](10) NULL,
	[LSTAR] [nvarchar](6) NULL,
	[SEBELN] [nvarchar](10) NULL,
	[SEBELP] [nvarchar](5) NULL,
	[SPRZNR] [nvarchar](12) NULL,
	[LSTNR] [nvarchar](18) NULL,
	[RKOSTL] [nvarchar](10) NULL,
	[RPROJ] [nvarchar](8) NULL,
	[RAUFNR] [nvarchar](12) NULL,
	[RNPLNR] [nvarchar](12) NULL,
	[RAUFPL] [nvarchar](10) NULL,
	[RAPLZL] [nvarchar](8) NULL,
	[RKDAUF] [nvarchar](10) NULL,
	[RKDPOS] [nvarchar](6) NULL,
	[RKSTR] [nvarchar](12) NULL,
	[RPRZNR] [nvarchar](12) NULL,
	[PAOBJNR] [nvarchar](10) NULL,
	[FUND] [nvarchar](10) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[GRANT_NBR] [nvarchar](20) NULL,
	[S_FUND] [nvarchar](10) NULL,
	[S_FUNC_AREA] [nvarchar](16) NULL,
	[S_GRANT_NBR] [nvarchar](20) NULL,
	[BUDGET_PD] [nvarchar](10) NULL,
	[SBUDGET_PD] [nvarchar](10) NULL,
	[WORK_ITEM_ID] [nvarchar](10) NULL,
	[AWART] [nvarchar](4) NULL,
	[LGART] [nvarchar](4) NULL,
	[KAPID] [nvarchar](8) NULL,
	[SPLIT] [smallint] NULL,
	[REINR] [nvarchar](10) NULL,
	[WABLNR] [nvarchar](10) NULL,
	[VERSL] [nvarchar](1) NULL,
	[WTART] [nvarchar](4) NULL,
	[BWGRL] [numeric](13, 2) NULL,
	[WAERS] [nvarchar](5) NULL,
	[AUFKZ] [nvarchar](1) NULL,
	[TRFGR] [nvarchar](8) NULL,
	[TRFST] [nvarchar](2) NULL,
	[PRAKN] [nvarchar](2) NULL,
	[PRAKZ] [nvarchar](4) NULL,
	[OTYPE] [nvarchar](2) NULL,
	[PLANS] [nvarchar](8) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[MEINH] [nvarchar](3) NULL,
	[TCURR] [nvarchar](5) NULL,
	[PRICE] [numeric](11, 2) NULL,
	[ARBID] [nvarchar](8) NULL,
	[WERKS] [nvarchar](4) NULL,
	[AUTYP] [nvarchar](2) NULL,
	[HRCOSTASG] [nvarchar](1) NULL,
	[HRKOSTL] [nvarchar](10) NULL,
	[HRLSTAR] [nvarchar](6) NULL,
	[HRFUND] [nvarchar](10) NULL,
	[HRFUNC_AREA] [nvarchar](16) NULL,
	[HRGRANT_NBR] [nvarchar](20) NULL,
	[BEMOT] [nvarchar](2) NULL,
	[UNIT] [nvarchar](3) NULL,
	[STATKEYFIG] [nvarchar](6) NULL,
	[TASKTYPE] [nvarchar](4) NULL,
	[TASKLEVEL] [nvarchar](8) NULL,
	[TASKCOMPONENT] [nvarchar](8) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[CPR_GUID] [nvarchar](32) NULL,
	[CPR_EXTID] [nvarchar](24) NULL,
	[CPR_OBJGUID] [nvarchar](32) NULL,
	[CPR_OBJGEXTID] [nvarchar](24) NULL,
	[CPR_OBJTYPE] [nvarchar](3) NULL,
	[HRBUDGET_PD] [nvarchar](10) NULL,
	[ERSDA] [nvarchar](8) NULL,
	[ERSTM] [nvarchar](6) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[LAEDA] [nvarchar](8) NULL,
	[LAETM] [nvarchar](6) NULL,
	[AENAM] [nvarchar](12) NULL,
	[APNAM] [nvarchar](12) NULL,
	[APDAT] [nvarchar](8) NULL,
	[WORKITEMID] [nvarchar](12) NULL,
	[LOGSYS] [nvarchar](10) NULL,
	[STATUS] [nvarchar](2) NULL,
	[REFCOUNTER] [nvarchar](12) NULL,
	[REASON] [nvarchar](4) NULL,
	[BELNR] [nvarchar](10) NULL,
	[EXTSYSTEM] [nvarchar](10) NULL,
	[EXTAPPLICATION] [nvarchar](5) NULL,
	[EXTDOCUMENTNO] [nvarchar](20) NULL,
	[TASKCOUNTER] [nvarchar](10) NULL,
	[CATSHOURS] [numeric](4, 2) NULL,
	[BEGUZ] [nvarchar](6) NULL,
	[ENDUZ] [nvarchar](6) NULL,
	[VTKEN] [nvarchar](1) NULL,
	[ALLDF] [nvarchar](1) NULL,
	[OFMNW] [numeric](7, 1) NULL,
	[PEDD] [nvarchar](8) NULL,
	[AUERU] [nvarchar](1) NULL,
	[LTXA1] [nvarchar](40) NULL,
	[LONGTEXT] [nvarchar](1) NULL,
	[ERUZU] [nvarchar](1) NULL,
	[CATSAMOUNT] [numeric](13, 2) NULL,
	[CATSQUANTITY] [numeric](15, 3) NULL,
	[ZBILLABLE] [nvarchar](4) NULL,
	[ZCOST] [nvarchar](13) NULL,
	[ZCOST_BILLED] [nvarchar](13) NULL,
	[ZREVENUE] [nvarchar](13) NULL,
	[PRICE_COST_BWRWM] [numeric](11, 2) NULL,
	[PRICE_COST_BWR] [numeric](11, 2) NULL,
	[CC_COST_BWR] [nvarchar](10) NULL,
	[PRICE_COST_ODC] [numeric](11, 2) NULL,
	[CC_COST_ODC] [nvarchar](10) NULL,
	[PRICE_COST_LDC] [numeric](11, 2) NULL,
	[CC_COST_LDC] [nvarchar](10) NULL,
	[PRICE_COST_ADC] [numeric](11, 2) NULL,
	[CC_COST_ADC] [nvarchar](10) NULL,
	[PRICE_REV_BWR] [numeric](11, 2) NULL,
	[PRICE_REV_ODC] [numeric](11, 2) NULL,
	[PRICE_REV_EDC] [numeric](11, 2) NULL,
	[PRICE_REV_LDC] [numeric](11, 2) NULL,
	[COST_INTRA_BU] [numeric](11, 2) NULL,
	[SENDER_CPROFIT] [nvarchar](10) NULL,
	[RECEIVER_CPROFIT] [nvarchar](10) NULL,
	[RKOSTL_TXT] [nvarchar](100) NULL,
	[RPROJ_TXT] [nvarchar](100) NULL,
	[RNETWORK_TXT] [nvarchar](100) NULL,
	[RAWART_TXT] [nvarchar](100) NULL,
	[DUMMY_INCL_EEW_PRS_CPILS] [nvarchar](1) NULL,
	[PRICE_COST_MDC] [numeric](11, 2) NULL,
	[CC_COST_MDC] [nvarchar](10) NULL,
	[PRICE_REV_MDC] [numeric](11, 2) NULL,
	[PRICE_REV_ASR] [numeric](11, 2) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CATSDB_2023]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CATSDB_2023](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[COUNTER] [nvarchar](12) NULL,
	[WORKDATE] [nvarchar](8) NULL,
	[SKOSTL] [nvarchar](10) NULL,
	[LSTAR] [nvarchar](6) NULL,
	[SEBELN] [nvarchar](10) NULL,
	[SEBELP] [nvarchar](5) NULL,
	[SPRZNR] [nvarchar](12) NULL,
	[LSTNR] [nvarchar](18) NULL,
	[RKOSTL] [nvarchar](10) NULL,
	[RPROJ] [nvarchar](8) NULL,
	[RAUFNR] [nvarchar](12) NULL,
	[RNPLNR] [nvarchar](12) NULL,
	[RAUFPL] [nvarchar](10) NULL,
	[RAPLZL] [nvarchar](8) NULL,
	[RKDAUF] [nvarchar](10) NULL,
	[RKDPOS] [nvarchar](6) NULL,
	[RKSTR] [nvarchar](12) NULL,
	[RPRZNR] [nvarchar](12) NULL,
	[PAOBJNR] [nvarchar](10) NULL,
	[FUND] [nvarchar](10) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[GRANT_NBR] [nvarchar](20) NULL,
	[S_FUND] [nvarchar](10) NULL,
	[S_FUNC_AREA] [nvarchar](16) NULL,
	[S_GRANT_NBR] [nvarchar](20) NULL,
	[BUDGET_PD] [nvarchar](10) NULL,
	[SBUDGET_PD] [nvarchar](10) NULL,
	[WORK_ITEM_ID] [nvarchar](10) NULL,
	[AWART] [nvarchar](4) NULL,
	[LGART] [nvarchar](4) NULL,
	[KAPID] [nvarchar](8) NULL,
	[SPLIT] [smallint] NULL,
	[REINR] [nvarchar](10) NULL,
	[WABLNR] [nvarchar](10) NULL,
	[VERSL] [nvarchar](1) NULL,
	[WTART] [nvarchar](4) NULL,
	[BWGRL] [numeric](13, 2) NULL,
	[WAERS] [nvarchar](5) NULL,
	[AUFKZ] [nvarchar](1) NULL,
	[TRFGR] [nvarchar](8) NULL,
	[TRFST] [nvarchar](2) NULL,
	[PRAKN] [nvarchar](2) NULL,
	[PRAKZ] [nvarchar](4) NULL,
	[OTYPE] [nvarchar](2) NULL,
	[PLANS] [nvarchar](8) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[MEINH] [nvarchar](3) NULL,
	[TCURR] [nvarchar](5) NULL,
	[PRICE] [numeric](11, 2) NULL,
	[ARBID] [nvarchar](8) NULL,
	[WERKS] [nvarchar](4) NULL,
	[AUTYP] [nvarchar](2) NULL,
	[HRCOSTASG] [nvarchar](1) NULL,
	[HRKOSTL] [nvarchar](10) NULL,
	[HRLSTAR] [nvarchar](6) NULL,
	[HRFUND] [nvarchar](10) NULL,
	[HRFUNC_AREA] [nvarchar](16) NULL,
	[HRGRANT_NBR] [nvarchar](20) NULL,
	[BEMOT] [nvarchar](2) NULL,
	[UNIT] [nvarchar](3) NULL,
	[STATKEYFIG] [nvarchar](6) NULL,
	[TASKTYPE] [nvarchar](4) NULL,
	[TASKLEVEL] [nvarchar](8) NULL,
	[TASKCOMPONENT] [nvarchar](8) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[CPR_GUID] [nvarchar](32) NULL,
	[CPR_EXTID] [nvarchar](24) NULL,
	[CPR_OBJGUID] [nvarchar](32) NULL,
	[CPR_OBJGEXTID] [nvarchar](24) NULL,
	[CPR_OBJTYPE] [nvarchar](3) NULL,
	[HRBUDGET_PD] [nvarchar](10) NULL,
	[ERSDA] [nvarchar](8) NULL,
	[ERSTM] [nvarchar](6) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[LAEDA] [nvarchar](8) NULL,
	[LAETM] [nvarchar](6) NULL,
	[AENAM] [nvarchar](12) NULL,
	[APNAM] [nvarchar](12) NULL,
	[APDAT] [nvarchar](8) NULL,
	[WORKITEMID] [nvarchar](12) NULL,
	[LOGSYS] [nvarchar](10) NULL,
	[STATUS] [nvarchar](2) NULL,
	[REFCOUNTER] [nvarchar](12) NULL,
	[REASON] [nvarchar](4) NULL,
	[BELNR] [nvarchar](10) NULL,
	[EXTSYSTEM] [nvarchar](10) NULL,
	[EXTAPPLICATION] [nvarchar](5) NULL,
	[EXTDOCUMENTNO] [nvarchar](20) NULL,
	[TASKCOUNTER] [nvarchar](10) NULL,
	[CATSHOURS] [numeric](4, 2) NULL,
	[BEGUZ] [nvarchar](6) NULL,
	[ENDUZ] [nvarchar](6) NULL,
	[VTKEN] [nvarchar](1) NULL,
	[ALLDF] [nvarchar](1) NULL,
	[OFMNW] [numeric](7, 1) NULL,
	[PEDD] [nvarchar](8) NULL,
	[AUERU] [nvarchar](1) NULL,
	[LTXA1] [nvarchar](40) NULL,
	[LONGTEXT] [nvarchar](1) NULL,
	[ERUZU] [nvarchar](1) NULL,
	[CATSAMOUNT] [numeric](13, 2) NULL,
	[CATSQUANTITY] [numeric](15, 3) NULL,
	[ZBILLABLE] [nvarchar](4) NULL,
	[ZCOST] [nvarchar](13) NULL,
	[ZCOST_BILLED] [nvarchar](13) NULL,
	[ZREVENUE] [nvarchar](13) NULL,
	[PRICE_COST_BWRWM] [numeric](11, 2) NULL,
	[PRICE_COST_BWR] [numeric](11, 2) NULL,
	[CC_COST_BWR] [nvarchar](10) NULL,
	[PRICE_COST_ODC] [numeric](11, 2) NULL,
	[CC_COST_ODC] [nvarchar](10) NULL,
	[PRICE_COST_LDC] [numeric](11, 2) NULL,
	[CC_COST_LDC] [nvarchar](10) NULL,
	[PRICE_COST_ADC] [numeric](11, 2) NULL,
	[CC_COST_ADC] [nvarchar](10) NULL,
	[PRICE_REV_BWR] [numeric](11, 2) NULL,
	[PRICE_REV_ODC] [numeric](11, 2) NULL,
	[PRICE_REV_EDC] [numeric](11, 2) NULL,
	[PRICE_REV_LDC] [numeric](11, 2) NULL,
	[COST_INTRA_BU] [numeric](11, 2) NULL,
	[SENDER_CPROFIT] [nvarchar](10) NULL,
	[RECEIVER_CPROFIT] [nvarchar](10) NULL,
	[RKOSTL_TXT] [nvarchar](100) NULL,
	[RPROJ_TXT] [nvarchar](100) NULL,
	[RNETWORK_TXT] [nvarchar](100) NULL,
	[RAWART_TXT] [nvarchar](100) NULL,
	[DUMMY_INCL_EEW_PRS_CPILS] [nvarchar](1) NULL,
	[PRICE_COST_MDC] [numeric](11, 2) NULL,
	[CC_COST_MDC] [nvarchar](10) NULL,
	[PRICE_REV_MDC] [numeric](11, 2) NULL,
	[PRICE_REV_ASR] [numeric](11, 2) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CATSDB_2024]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CATSDB_2024](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[COUNTER] [nvarchar](12) NULL,
	[WORKDATE] [nvarchar](50) NULL,
	[SKOSTL] [nvarchar](10) NULL,
	[LSTAR] [nvarchar](6) NULL,
	[SEBELN] [nvarchar](10) NULL,
	[SEBELP] [nvarchar](5) NULL,
	[SPRZNR] [nvarchar](12) NULL,
	[LSTNR] [nvarchar](18) NULL,
	[RKOSTL] [nvarchar](10) NULL,
	[RPROJ] [nvarchar](8) NULL,
	[RAUFNR] [nvarchar](12) NULL,
	[RNPLNR] [nvarchar](12) NULL,
	[RAUFPL] [nvarchar](10) NULL,
	[RAPLZL] [nvarchar](8) NULL,
	[RKDAUF] [nvarchar](10) NULL,
	[RKDPOS] [nvarchar](6) NULL,
	[RKSTR] [nvarchar](12) NULL,
	[RPRZNR] [nvarchar](12) NULL,
	[PAOBJNR] [nvarchar](10) NULL,
	[FUND] [nvarchar](10) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[GRANT_NBR] [nvarchar](20) NULL,
	[S_FUND] [nvarchar](10) NULL,
	[S_FUNC_AREA] [nvarchar](16) NULL,
	[S_GRANT_NBR] [nvarchar](20) NULL,
	[BUDGET_PD] [nvarchar](10) NULL,
	[SBUDGET_PD] [nvarchar](10) NULL,
	[WORK_ITEM_ID] [nvarchar](10) NULL,
	[AWART] [nvarchar](4) NULL,
	[LGART] [nvarchar](4) NULL,
	[KAPID] [nvarchar](8) NULL,
	[SPLIT] [smallint] NULL,
	[REINR] [nvarchar](10) NULL,
	[WABLNR] [nvarchar](10) NULL,
	[VERSL] [nvarchar](1) NULL,
	[WTART] [nvarchar](4) NULL,
	[BWGRL] [numeric](13, 2) NULL,
	[WAERS] [nvarchar](5) NULL,
	[AUFKZ] [nvarchar](1) NULL,
	[TRFGR] [nvarchar](8) NULL,
	[TRFST] [nvarchar](2) NULL,
	[PRAKN] [nvarchar](2) NULL,
	[PRAKZ] [nvarchar](4) NULL,
	[OTYPE] [nvarchar](2) NULL,
	[PLANS] [nvarchar](8) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[MEINH] [nvarchar](3) NULL,
	[TCURR] [nvarchar](5) NULL,
	[PRICE] [numeric](11, 2) NULL,
	[ARBID] [nvarchar](8) NULL,
	[WERKS] [nvarchar](4) NULL,
	[AUTYP] [nvarchar](2) NULL,
	[HRCOSTASG] [nvarchar](1) NULL,
	[HRKOSTL] [nvarchar](10) NULL,
	[HRLSTAR] [nvarchar](6) NULL,
	[HRFUND] [nvarchar](10) NULL,
	[HRFUNC_AREA] [nvarchar](16) NULL,
	[HRGRANT_NBR] [nvarchar](20) NULL,
	[BEMOT] [nvarchar](2) NULL,
	[UNIT] [nvarchar](3) NULL,
	[STATKEYFIG] [nvarchar](6) NULL,
	[TASKTYPE] [nvarchar](4) NULL,
	[TASKLEVEL] [nvarchar](8) NULL,
	[TASKCOMPONENT] [nvarchar](8) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[CPR_GUID] [nvarchar](32) NULL,
	[CPR_EXTID] [nvarchar](24) NULL,
	[CPR_OBJGUID] [nvarchar](32) NULL,
	[CPR_OBJGEXTID] [nvarchar](24) NULL,
	[CPR_OBJTYPE] [nvarchar](3) NULL,
	[HRBUDGET_PD] [nvarchar](10) NULL,
	[ERSDA] [nvarchar](50) NULL,
	[ERSTM] [nvarchar](50) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[LAEDA] [nvarchar](50) NULL,
	[LAETM] [nvarchar](50) NULL,
	[AENAM] [nvarchar](12) NULL,
	[APNAM] [nvarchar](12) NULL,
	[APDAT] [nvarchar](50) NULL,
	[WORKITEMID] [nvarchar](12) NULL,
	[LOGSYS] [nvarchar](10) NULL,
	[STATUS] [nvarchar](2) NULL,
	[REFCOUNTER] [nvarchar](12) NULL,
	[REASON] [nvarchar](4) NULL,
	[BELNR] [nvarchar](10) NULL,
	[EXTSYSTEM] [nvarchar](10) NULL,
	[EXTAPPLICATION] [nvarchar](5) NULL,
	[EXTDOCUMENTNO] [nvarchar](20) NULL,
	[TASKCOUNTER] [nvarchar](10) NULL,
	[CATSHOURS] [numeric](4, 2) NULL,
	[BEGUZ] [nvarchar](50) NULL,
	[ENDUZ] [nvarchar](50) NULL,
	[VTKEN] [nvarchar](1) NULL,
	[ALLDF] [nvarchar](1) NULL,
	[OFMNW] [numeric](7, 1) NULL,
	[PEDD] [nvarchar](50) NULL,
	[AUERU] [nvarchar](1) NULL,
	[LTXA1] [nvarchar](40) NULL,
	[LONGTEXT] [nvarchar](1) NULL,
	[ERUZU] [nvarchar](1) NULL,
	[CATSAMOUNT] [numeric](13, 2) NULL,
	[CATSQUANTITY] [numeric](15, 3) NULL,
	[ZBILLABLE] [nvarchar](4) NULL,
	[ZCOST] [nvarchar](13) NULL,
	[ZCOST_BILLED] [nvarchar](13) NULL,
	[ZREVENUE] [nvarchar](13) NULL,
	[PRICE_COST_BWRWM] [numeric](11, 2) NULL,
	[PRICE_COST_BWR] [numeric](11, 2) NULL,
	[CC_COST_BWR] [nvarchar](10) NULL,
	[PRICE_COST_ODC] [numeric](11, 2) NULL,
	[CC_COST_ODC] [nvarchar](10) NULL,
	[PRICE_COST_LDC] [numeric](11, 2) NULL,
	[CC_COST_LDC] [nvarchar](10) NULL,
	[PRICE_COST_ADC] [numeric](11, 2) NULL,
	[CC_COST_ADC] [nvarchar](10) NULL,
	[PRICE_REV_BWR] [numeric](11, 2) NULL,
	[PRICE_REV_ODC] [numeric](11, 2) NULL,
	[PRICE_REV_EDC] [numeric](11, 2) NULL,
	[PRICE_REV_LDC] [numeric](11, 2) NULL,
	[COST_INTRA_BU] [numeric](11, 2) NULL,
	[SENDER_CPROFIT] [nvarchar](10) NULL,
	[RECEIVER_CPROFIT] [nvarchar](10) NULL,
	[RKOSTL_TXT] [nvarchar](100) NULL,
	[RPROJ_TXT] [nvarchar](100) NULL,
	[RNETWORK_TXT] [nvarchar](100) NULL,
	[RAWART_TXT] [nvarchar](100) NULL,
	[DUMMY_INCL_EEW_PRS_CPILS] [nvarchar](1) NULL,
	[PRICE_COST_MDC] [numeric](11, 2) NULL,
	[CC_COST_MDC] [nvarchar](10) NULL,
	[PRICE_REV_MDC] [numeric](11, 2) NULL,
	[PRICE_REV_ASR] [numeric](11, 2) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CATSDB_TMP]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CATSDB_TMP](
	[MANDT] [nvarchar](255) NULL,
	[PERNR] [nvarchar](255) NULL,
	[COUNTER] [nvarchar](255) NULL,
	[WORKDATE] [datetime] NULL,
	[SKOSTL] [nvarchar](255) NULL,
	[LSTAR] [nvarchar](255) NULL,
	[SEBELN] [nvarchar](255) NULL,
	[SEBELP] [nvarchar](255) NULL,
	[SPRZNR] [nvarchar](255) NULL,
	[LSTNR] [nvarchar](255) NULL,
	[RKOSTL] [nvarchar](255) NULL,
	[RPROJ] [nvarchar](255) NULL,
	[RAUFNR] [nvarchar](255) NULL,
	[RNPLNR] [nvarchar](255) NULL,
	[RAUFPL] [nvarchar](255) NULL,
	[RAPLZL] [nvarchar](255) NULL,
	[RKDAUF] [nvarchar](255) NULL,
	[RKDPOS] [nvarchar](255) NULL,
	[RKSTR] [nvarchar](255) NULL,
	[RPRZNR] [nvarchar](255) NULL,
	[PAOBJNR] [nvarchar](255) NULL,
	[FUND] [nvarchar](255) NULL,
	[FUNC_AREA] [nvarchar](255) NULL,
	[GRANT_NBR] [nvarchar](255) NULL,
	[S_FUND] [nvarchar](255) NULL,
	[S_FUNC_AREA] [nvarchar](255) NULL,
	[S_GRANT_NBR] [nvarchar](255) NULL,
	[BUDGET_PD] [nvarchar](255) NULL,
	[SBUDGET_PD] [nvarchar](255) NULL,
	[WORK_ITEM_ID] [nvarchar](255) NULL,
	[AWART] [nvarchar](255) NULL,
	[LGART] [nvarchar](255) NULL,
	[KAPID] [nvarchar](255) NULL,
	[SPLIT] [float] NULL,
	[REINR] [nvarchar](255) NULL,
	[WABLNR] [nvarchar](255) NULL,
	[VERSL] [nvarchar](255) NULL,
	[WTART] [nvarchar](255) NULL,
	[BWGRL] [float] NULL,
	[WAERS] [nvarchar](255) NULL,
	[AUFKZ] [nvarchar](255) NULL,
	[TRFGR] [nvarchar](255) NULL,
	[TRFST] [nvarchar](255) NULL,
	[PRAKN] [nvarchar](255) NULL,
	[PRAKZ] [nvarchar](255) NULL,
	[OTYPE] [nvarchar](255) NULL,
	[PLANS] [nvarchar](255) NULL,
	[KOKRS] [nvarchar](255) NULL,
	[MEINH] [nvarchar](255) NULL,
	[TCURR] [nvarchar](255) NULL,
	[PRICE] [float] NULL,
	[ARBID] [nvarchar](255) NULL,
	[WERKS] [nvarchar](255) NULL,
	[AUTYP] [nvarchar](255) NULL,
	[HRCOSTASG] [nvarchar](255) NULL,
	[HRKOSTL] [nvarchar](255) NULL,
	[HRLSTAR] [nvarchar](255) NULL,
	[HRFUND] [nvarchar](255) NULL,
	[HRFUNC_AREA] [nvarchar](255) NULL,
	[HRGRANT_NBR] [nvarchar](255) NULL,
	[BEMOT] [nvarchar](255) NULL,
	[UNIT] [nvarchar](255) NULL,
	[STATKEYFIG] [nvarchar](255) NULL,
	[TASKTYPE] [nvarchar](255) NULL,
	[TASKLEVEL] [nvarchar](255) NULL,
	[TASKCOMPONENT] [nvarchar](255) NULL,
	[BUKRS] [nvarchar](255) NULL,
	[CPR_GUID] [nvarchar](255) NULL,
	[CPR_EXTID] [nvarchar](255) NULL,
	[CPR_OBJGUID] [nvarchar](255) NULL,
	[CPR_OBJGEXTID] [nvarchar](255) NULL,
	[CPR_OBJTYPE] [nvarchar](255) NULL,
	[HRBUDGET_PD] [nvarchar](255) NULL,
	[ERSDA] [datetime] NULL,
	[ERSTM] [datetime] NULL,
	[ERNAM] [nvarchar](255) NULL,
	[LAEDA] [datetime] NULL,
	[LAETM] [datetime] NULL,
	[AENAM] [nvarchar](255) NULL,
	[APNAM] [nvarchar](255) NULL,
	[APDAT] [datetime] NULL,
	[WORKITEMID] [nvarchar](255) NULL,
	[LOGSYS] [nvarchar](255) NULL,
	[STATUS] [nvarchar](255) NULL,
	[REFCOUNTER] [nvarchar](255) NULL,
	[REASON] [nvarchar](255) NULL,
	[BELNR] [nvarchar](255) NULL,
	[EXTSYSTEM] [nvarchar](255) NULL,
	[EXTAPPLICATION] [nvarchar](255) NULL,
	[EXTDOCUMENTNO] [nvarchar](255) NULL,
	[TASKCOUNTER] [nvarchar](255) NULL,
	[CATSHOURS] [float] NULL,
	[BEGUZ] [datetime] NULL,
	[ENDUZ] [datetime] NULL,
	[VTKEN] [nvarchar](255) NULL,
	[ALLDF] [nvarchar](255) NULL,
	[OFMNW] [float] NULL,
	[PEDD] [datetime] NULL,
	[AUERU] [nvarchar](255) NULL,
	[LTXA1] [nvarchar](255) NULL,
	[LONGTEXT] [nvarchar](255) NULL,
	[ERUZU] [nvarchar](255) NULL,
	[CATSAMOUNT] [float] NULL,
	[CATSQUANTITY] [float] NULL,
	[ZBILLABLE] [nvarchar](255) NULL,
	[ZCOST] [nvarchar](255) NULL,
	[ZCOST_BILLED] [nvarchar](255) NULL,
	[ZREVENUE] [nvarchar](255) NULL,
	[PRICE_COST_BWRWM] [float] NULL,
	[PRICE_COST_BWR] [float] NULL,
	[CC_COST_BWR] [nvarchar](255) NULL,
	[PRICE_COST_ODC] [float] NULL,
	[CC_COST_ODC] [nvarchar](255) NULL,
	[PRICE_COST_LDC] [float] NULL,
	[CC_COST_LDC] [nvarchar](255) NULL,
	[PRICE_COST_ADC] [float] NULL,
	[CC_COST_ADC] [nvarchar](255) NULL,
	[PRICE_REV_BWR] [float] NULL,
	[PRICE_REV_ODC] [float] NULL,
	[PRICE_REV_EDC] [float] NULL,
	[PRICE_REV_LDC] [float] NULL,
	[COST_INTRA_BU] [float] NULL,
	[SENDER_CPROFIT] [nvarchar](255) NULL,
	[RECEIVER_CPROFIT] [nvarchar](255) NULL,
	[RKOSTL_TXT] [nvarchar](255) NULL,
	[RPROJ_TXT] [nvarchar](255) NULL,
	[RNETWORK_TXT] [nvarchar](255) NULL,
	[RAWART_TXT] [nvarchar](255) NULL,
	[DUMMY_INCL_EEW_PRS_CPILS] [nvarchar](255) NULL,
	[PRICE_COST_MDC] [float] NULL,
	[CC_COST_MDC] [nvarchar](255) NULL,
	[PRICE_REV_MDC] [float] NULL,
	[PRICE_REV_ASR] [float] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CATSPS]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CATSPS](
	[MANDT] [nvarchar](30) NULL,
	[COUNTER] [nvarchar](30) NULL,
	[STOKZ] [nvarchar](30) NULL,
	[PERNR] [nvarchar](30) NULL,
	[WORKDATE] [nvarchar](30) NULL,
	[RNPLNR] [nvarchar](30) NULL,
	[RAUFPL] [nvarchar](30) NULL,
	[RAPLZL] [nvarchar](30) NULL,
	[KAPID] [nvarchar](30) NULL,
	[SPLIT] [nvarchar](30) NULL,
	[ARBID] [nvarchar](30) NULL,
	[WERKS] [nvarchar](30) NULL,
	[CATSHOURS] [nvarchar](30) NULL,
	[MEINH] [nvarchar](30) NULL,
	[OFMNW] [nvarchar](30) NULL,
	[PEDD] [nvarchar](30) NULL,
	[LSTAR] [nvarchar](30) NULL,
	[BEGUZ] [nvarchar](30) NULL,
	[ENDUZ] [nvarchar](30) NULL,
	[LTXA1] [nvarchar](200) NULL,
	[AUERU] [nvarchar](30) NULL,
	[BELNR] [nvarchar](30) NULL,
	[TRANSFER] [nvarchar](30) NULL,
	[LGART] [nvarchar](30) NULL,
	[PRICE] [nvarchar](30) NULL,
	[TCURR] [nvarchar](30) NULL,
	[ERUZU] [nvarchar](30) NULL,
	[ERSDA] [nvarchar](30) NULL,
	[ERSTM] [nvarchar](30) NULL,
	[BEMOT] [nvarchar](30) NULL,
	[KOKRS] [nvarchar](30) NULL,
	[SKOSTL] [nvarchar](30) NULL,
	[FM_SPLIT_FLG] [nvarchar](30) NULL,
	[ZINTRABU] [nvarchar](30) NULL,
	[BUDAT] [nvarchar](30) NULL,
	[BUDAT_C] [nvarchar](30) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CEPC]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CEPC](
	[MANDT] [nvarchar](3) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[ERSDA] [nvarchar](8) NULL,
	[PRCTR] [nvarchar](10) NULL,
	[DATBI] [nvarchar](8) NULL,
	[DATAB] [nvarchar](8) NULL,
	[USNAM] [nvarchar](12) NULL,
	[MERKMAL] [nvarchar](30) NULL,
	[ABTEI] [nvarchar](12) NULL,
	[VERAK] [nvarchar](20) NULL,
	[VERAK_USER] [nvarchar](12) NULL,
	[WAERS] [nvarchar](5) NULL,
	[NPRCTR] [nvarchar](10) NULL,
	[LAND1] [nvarchar](3) NULL,
	[ANRED] [nvarchar](15) NULL,
	[NAME1] [nvarchar](35) NULL,
	[NAME2] [nvarchar](35) NULL,
	[NAME3] [nvarchar](35) NULL,
	[NAME4] [nvarchar](35) NULL,
	[ORT01] [nvarchar](35) NULL,
	[ORT02] [nvarchar](35) NULL,
	[STRAS] [nvarchar](35) NULL,
	[PFACH] [nvarchar](10) NULL,
	[PSTLZ] [nvarchar](10) NULL,
	[PSTL2] [nvarchar](10) NULL,
	[SPRAS] [nvarchar](1) NULL,
	[TELBX] [nvarchar](15) NULL,
	[TELF1] [nvarchar](16) NULL,
	[TELF2] [nvarchar](16) NULL,
	[TELFX] [nvarchar](31) NULL,
	[TELTX] [nvarchar](30) NULL,
	[TELX1] [nvarchar](30) NULL,
	[DATLT] [nvarchar](14) NULL,
	[DRNAM] [nvarchar](4) NULL,
	[KHINR] [nvarchar](12) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[VNAME] [nvarchar](6) NULL,
	[RECID] [nvarchar](2) NULL,
	[ETYPE] [nvarchar](3) NULL,
	[TXJCD] [nvarchar](15) NULL,
	[REGIO] [nvarchar](3) NULL,
	[KVEWE] [nvarchar](1) NULL,
	[KAPPL] [nvarchar](2) NULL,
	[KALSM] [nvarchar](6) NULL,
	[LOGSYSTEM] [nvarchar](10) NULL,
	[LOCK_IND] [nvarchar](1) NULL,
	[PCA_TEMPLATE] [nvarchar](10) NULL,
	[SEGMENT] [nvarchar](10) NULL,
	[EEW_CEPC_PS_DUMMY] [nvarchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CEPCT]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CEPCT](
	[MANDT] [nvarchar](500) NULL,
	[SPRAS] [nvarchar](500) NULL,
	[PRCTR] [nvarchar](500) NULL,
	[DATBI] [nvarchar](500) NULL,
	[KOKRS] [nvarchar](500) NULL,
	[KTEXT] [nvarchar](500) NULL,
	[LTEXT] [nvarchar](500) NULL,
	[MCTXT] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CJI3]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CJI3](
	[Projdef] [nvarchar](255) NULL,
	[Per] [nvarchar](50) NULL,
	[Year] [nvarchar](50) NULL,
	[ValCOArCur] [nvarchar](255) NULL,
	[CoCd] [nvarchar](255) NULL,
	[WBSElement] [nvarchar](255) NULL,
	[CostElem] [nvarchar](500) NULL,
	[FileName] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CJI3_TMP]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CJI3_TMP](
	[Projdef] [nvarchar](255) NULL,
	[Per] [nvarchar](50) NULL,
	[Year] [nvarchar](50) NULL,
	[ValCOArCur] [nvarchar](255) NULL,
	[CoCd] [nvarchar](255) NULL,
	[WBSElement] [nvarchar](255) NULL,
	[CostElem] [nvarchar](500) NULL,
	[FileName] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CSKS]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CSKS](
	[MANDT] [nvarchar](3) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[PRCTR] [nvarchar](10) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[OBJNR] [nvarchar](22) NULL,
	[WERKS] [nvarchar](4) NULL,
	[GSBER] [nvarchar](4) NULL,
	[KOSTL] [nvarchar](10) NULL,
	[DATBI] [nvarchar](8) NULL,
	[DATAB] [nvarchar](8) NULL,
	[BKZKP] [nvarchar](1) NULL,
	[PKZKP] [nvarchar](1) NULL,
	[KOSAR] [nvarchar](1) NULL,
	[VERAK] [nvarchar](20) NULL,
	[VERAK_USER] [nvarchar](12) NULL,
	[WAERS] [nvarchar](5) NULL,
	[KALSM] [nvarchar](6) NULL,
	[TXJCD] [nvarchar](15) NULL,
	[LOGSYSTEM] [nvarchar](10) NULL,
	[ERSDA] [nvarchar](8) NULL,
	[USNAM] [nvarchar](12) NULL,
	[BKZKS] [nvarchar](1) NULL,
	[BKZER] [nvarchar](1) NULL,
	[BKZOB] [nvarchar](1) NULL,
	[PKZKS] [nvarchar](1) NULL,
	[PKZER] [nvarchar](1) NULL,
	[VMETH] [nvarchar](2) NULL,
	[MGEFL] [nvarchar](1) NULL,
	[ABTEI] [nvarchar](12) NULL,
	[NKOST] [nvarchar](10) NULL,
	[KVEWE] [nvarchar](1) NULL,
	[KAPPL] [nvarchar](2) NULL,
	[KOSZSCHL] [nvarchar](6) NULL,
	[LAND1] [nvarchar](3) NULL,
	[ANRED] [nvarchar](15) NULL,
	[NAME1] [nvarchar](35) NULL,
	[NAME2] [nvarchar](35) NULL,
	[NAME3] [nvarchar](35) NULL,
	[NAME4] [nvarchar](35) NULL,
	[ORT01] [nvarchar](35) NULL,
	[ORT02] [nvarchar](35) NULL,
	[STRAS] [nvarchar](35) NULL,
	[PFACH] [nvarchar](10) NULL,
	[PSTLZ] [nvarchar](10) NULL,
	[PSTL2] [nvarchar](10) NULL,
	[REGIO] [nvarchar](3) NULL,
	[SPRAS] [nvarchar](1) NULL,
	[TELBX] [nvarchar](15) NULL,
	[TELF1] [nvarchar](16) NULL,
	[TELF2] [nvarchar](16) NULL,
	[TELFX] [nvarchar](31) NULL,
	[TELTX] [nvarchar](30) NULL,
	[TELX1] [nvarchar](30) NULL,
	[DATLT] [nvarchar](14) NULL,
	[DRNAM] [nvarchar](4) NULL,
	[KHINR] [nvarchar](12) NULL,
	[CCKEY] [nvarchar](23) NULL,
	[KOMPL] [nvarchar](1) NULL,
	[STAKZ] [nvarchar](1) NULL,
	[FUNKT] [nvarchar](3) NULL,
	[AFUNK] [nvarchar](3) NULL,
	[CPI_TEMPL] [nvarchar](10) NULL,
	[CPD_TEMPL] [nvarchar](10) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[SCI_TEMPL] [nvarchar](10) NULL,
	[SCD_TEMPL] [nvarchar](10) NULL,
	[SKI_TEMPL] [nvarchar](10) NULL,
	[SKD_TEMPL] [nvarchar](10) NULL,
	[EEW_CSKS_PS_DUMMY] [nvarchar](1) NULL,
	[VNAME] [nvarchar](6) NULL,
	[RECID] [nvarchar](2) NULL,
	[ETYPE] [nvarchar](3) NULL,
	[JV_OTYPE] [nvarchar](4) NULL,
	[JV_JIBCL] [nvarchar](3) NULL,
	[JV_JIBSA] [nvarchar](5) NULL,
	[FERC_IND] [nvarchar](4) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[CSKT]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[CSKT](
	[MAN] [nvarchar](1000) NULL,
	[SP] [nvarchar](1000) NULL,
	[KOKR] [nvarchar](1000) NULL,
	[KOSTL] [nvarchar](1000) NULL,
	[DATBI] [nvarchar](1000) NULL,
	[KTEXT] [nvarchar](1000) NULL,
	[LTEXT] [nvarchar](1000) NULL,
	[MCTXT] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[DD03L]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[DD03L](
	[TABNAME] [nvarchar](1000) NULL,
	[FIELDNAME] [nvarchar](1000) NULL,
	[AS4LOCAL] [nvarchar](1000) NULL,
	[AS4V] [nvarchar](1000) NULL,
	[POSI] [nvarchar](1000) NULL,
	[KEYFLAG] [nvarchar](1000) NULL,
	[MANDATORY] [nvarchar](1000) NULL,
	[ROLLNAME] [nvarchar](1000) NULL,
	[CHECKTABLE] [nvarchar](1000) NULL,
	[ADMINFIELD] [nvarchar](1000) NULL,
	[INTTYPE] [nvarchar](1000) NULL,
	[INTLEN] [nvarchar](1000) NULL,
	[REFTABLE] [nvarchar](1000) NULL,
	[PRECFIELD] [nvarchar](1000) NULL,
	[REFFIELD] [nvarchar](1000) NULL,
	[CONROUT] [nvarchar](1000) NULL,
	[N] [nvarchar](1000) NULL,
	[DATATYPE] [nvarchar](1000) NULL,
	[LENG] [nvarchar](1000) NULL,
	[DECIMA] [nvarchar](1000) NULL,
	[DOMNAME] [nvarchar](1000) NULL,
	[S] [nvarchar](1000) NULL,
	[T] [nvarchar](1000) NULL,
	[DE] [nvarchar](1000) NULL,
	[C] [nvarchar](1000) NULL,
	[R] [nvarchar](1000) NULL,
	[L] [nvarchar](1000) NULL,
	[DBPO] [nvarchar](1000) NULL,
	[ANONYMOUS] [nvarchar](1000) NULL,
	[OU] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[DD04T]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[DD04T](
	[ROLLNAME] [nvarchar](1000) NULL,
	[DD] [nvarchar](1000) NULL,
	[A] [nvarchar](1000) NULL,
	[AS4V] [nvarchar](1000) NULL,
	[DDTEXT] [nvarchar](1000) NULL,
	[REPTEXT] [nvarchar](1000) NULL,
	[SCRTEXT_S] [nvarchar](1000) NULL,
	[SCRTEXT_M] [nvarchar](1000) NULL,
	[SCRTEXT_L] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[EKKN]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[EKKN](
	[MANDT] [nvarchar](3) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[PRCTR] [nvarchar](10) NULL,
	[GSBER] [nvarchar](4) NULL,
	[KOSTL] [nvarchar](10) NULL,
	[TXJCD] [nvarchar](15) NULL,
	[VNAME] [nvarchar](6) NULL,
	[RECID] [nvarchar](2) NULL,
	[EBELN] [nvarchar](10) NULL,
	[EBELP] [nvarchar](5) NULL,
	[ZEKKN] [nvarchar](2) NULL,
	[LOEKZ] [nvarchar](1) NULL,
	[AEDAT] [nvarchar](8) NULL,
	[KFLAG] [nvarchar](1) NULL,
	[MENGE] [numeric](13, 3) NULL,
	[VPROZ] [numeric](3, 1) NULL,
	[NETWR] [numeric](13, 2) NULL,
	[SAKTO] [nvarchar](10) NULL,
	[PROJN] [nvarchar](16) NULL,
	[VBELN] [nvarchar](10) NULL,
	[VBELP] [nvarchar](6) NULL,
	[VETEN] [nvarchar](4) NULL,
	[KZBRB] [nvarchar](1) NULL,
	[ANLN1] [nvarchar](12) NULL,
	[ANLN2] [nvarchar](4) NULL,
	[AUFNR] [nvarchar](12) NULL,
	[WEMPF] [nvarchar](12) NULL,
	[ABLAD] [nvarchar](25) NULL,
	[XBKST] [nvarchar](1) NULL,
	[XBAUF] [nvarchar](1) NULL,
	[XBPRO] [nvarchar](1) NULL,
	[EREKZ] [nvarchar](1) NULL,
	[KSTRG] [nvarchar](12) NULL,
	[PAOBJNR] [nvarchar](10) NULL,
	[PS_PSP_PNR] [nvarchar](8) NULL,
	[NPLNR] [nvarchar](12) NULL,
	[AUFPL] [nvarchar](10) NULL,
	[IMKEY] [nvarchar](8) NULL,
	[APLZL] [nvarchar](8) NULL,
	[VPTNR] [nvarchar](10) NULL,
	[FIPOS] [nvarchar](14) NULL,
	[ZBILLABLE] [nvarchar](4) NULL,
	[ZEXP_TYP] [nvarchar](25) NULL,
	[ZEXPENDITURE] [nvarchar](55) NULL,
	[ZBWR] [nvarchar](6) NULL,
	[ZAR_INVOICE] [nvarchar](20) NULL,
	[ZVENDOR] [nvarchar](35) NULL,
	[ZTYPE] [nvarchar](20) NULL,
	[ZRAWCOST] [nvarchar](12) NULL,
	[ZBILLAMOUNT] [nvarchar](12) NULL,
	[DUMMY_INCL_EEW_COBL] [nvarchar](1) NULL,
	[FISTL] [nvarchar](16) NULL,
	[GEBER] [nvarchar](10) NULL,
	[FKBER] [nvarchar](16) NULL,
	[DABRZ] [nvarchar](8) NULL,
	[AUFPL_ORD] [nvarchar](10) NULL,
	[APLZL_ORD] [nvarchar](8) NULL,
	[MWSKZ] [nvarchar](2) NULL,
	[NAVNW] [numeric](13, 2) NULL,
	[KBLNR] [nvarchar](10) NULL,
	[KBLPOS] [nvarchar](3) NULL,
	[LSTAR] [nvarchar](6) NULL,
	[PRZNR] [nvarchar](12) NULL,
	[GRANT_NBR] [nvarchar](20) NULL,
	[BUDGET_PD] [nvarchar](10) NULL,
	[FM_SPLIT_BATCH] [nvarchar](3) NULL,
	[FM_SPLIT_BEGRU] [nvarchar](4) NULL,
	[AA_FINAL_IND] [nvarchar](1) NULL,
	[AA_FINAL_REASON] [nvarchar](2) NULL,
	[AA_FINAL_QTY] [numeric](13, 3) NULL,
	[AA_FINAL_QTY_F] [float] NULL,
	[MENGE_F] [float] NULL,
	[FMFGUS_KEY] [nvarchar](22) NULL,
	[_DATAAGING] [nvarchar](8) NULL,
	[EGRUP] [nvarchar](3) NULL,
	[KBLNR_CAB] [nvarchar](10) NULL,
	[KBLPOS_CAB] [nvarchar](3) NULL,
	[TCOBJNR] [nvarchar](22) NULL,
	[DATEOFSERVICE] [nvarchar](8) NULL,
	[NOTAXCORR] [nvarchar](1) NULL,
	[DIFFOPTRATE] [numeric](9, 6) NULL,
	[HASDIFFOPTRATE] [nvarchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[EKPO]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[EKPO](
	[MANDT] [nvarchar](3) NULL,
	[TXJCD] [nvarchar](15) NULL,
	[EBELN] [nvarchar](10) NULL,
	[EBELP] [nvarchar](5) NULL,
	[LOEKZ] [nvarchar](1) NULL,
	[AEDAT] [nvarchar](8) NULL,
	[MENGE] [numeric](13, 3) NULL,
	[NETWR] [numeric](13, 2) NULL,
	[EREKZ] [nvarchar](1) NULL,
	[FIPOS] [nvarchar](14) NULL,
	[FISTL] [nvarchar](16) NULL,
	[GEBER] [nvarchar](10) NULL,
	[FKBER] [nvarchar](16) NULL,
	[MWSKZ] [nvarchar](2) NULL,
	[NAVNW] [numeric](13, 2) NULL,
	[KBLNR] [nvarchar](10) NULL,
	[KBLPOS] [nvarchar](3) NULL,
	[GRANT_NBR] [nvarchar](20) NULL,
	[BUDGET_PD] [nvarchar](10) NULL,
	[FMFGUS_KEY] [nvarchar](22) NULL,
	[_DATAAGING] [nvarchar](8) NULL,
	[KBLPOS_CAB] [nvarchar](3) NULL,
	[UNIQUEID] [nvarchar](15) NULL,
	[STATU] [nvarchar](1) NULL,
	[TXZ01] [nvarchar](40) NULL,
	[MATNR] [nvarchar](40) NULL,
	[EMATN] [nvarchar](40) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[WERKS] [nvarchar](4) NULL,
	[LGORT] [nvarchar](4) NULL,
	[BEDNR] [nvarchar](10) NULL,
	[MATKL] [nvarchar](9) NULL,
	[INFNR] [nvarchar](10) NULL,
	[IDNLF] [nvarchar](35) NULL,
	[KTMNG] [numeric](13, 3) NULL,
	[MEINS] [nvarchar](3) NULL,
	[BPRME] [nvarchar](3) NULL,
	[BPUMZ] [numeric](5, 0) NULL,
	[BPUMN] [numeric](5, 0) NULL,
	[UMREZ] [numeric](5, 0) NULL,
	[UMREN] [numeric](5, 0) NULL,
	[NETPR] [numeric](11, 2) NULL,
	[PEINH] [numeric](5, 0) NULL,
	[BRTWR] [numeric](13, 2) NULL,
	[AGDAT] [nvarchar](8) NULL,
	[WEBAZ] [numeric](3, 0) NULL,
	[BONUS] [nvarchar](2) NULL,
	[INSMK] [nvarchar](1) NULL,
	[SPINF] [nvarchar](1) NULL,
	[PRSDR] [nvarchar](1) NULL,
	[SCHPR] [nvarchar](1) NULL,
	[MAHNZ] [numeric](3, 0) NULL,
	[MAHN1] [numeric](3, 0) NULL,
	[MAHN2] [numeric](3, 0) NULL,
	[MAHN3] [numeric](3, 0) NULL,
	[UEBTO] [numeric](3, 1) NULL,
	[UEBTK] [nvarchar](1) NULL,
	[UNTTO] [numeric](3, 1) NULL,
	[BWTAR] [nvarchar](10) NULL,
	[BWTTY] [nvarchar](1) NULL,
	[ABSKZ] [nvarchar](1) NULL,
	[AGMEM] [nvarchar](3) NULL,
	[ELIKZ] [nvarchar](1) NULL,
	[PSTYP] [nvarchar](1) NULL,
	[KNTTP] [nvarchar](1) NULL,
	[KZVBR] [nvarchar](1) NULL,
	[VRTKZ] [nvarchar](1) NULL,
	[TWRKZ] [nvarchar](1) NULL,
	[WEPOS] [nvarchar](1) NULL,
	[WEUNB] [nvarchar](1) NULL,
	[REPOS] [nvarchar](1) NULL,
	[WEBRE] [nvarchar](1) NULL,
	[KZABS] [nvarchar](1) NULL,
	[LABNR] [nvarchar](20) NULL,
	[KONNR] [nvarchar](10) NULL,
	[KTPNR] [nvarchar](5) NULL,
	[ABDAT] [nvarchar](8) NULL,
	[ABFTZ] [numeric](13, 3) NULL,
	[ETFZ1] [numeric](3, 0) NULL,
	[ETFZ2] [numeric](3, 0) NULL,
	[KZSTU] [nvarchar](1) NULL,
	[NOTKZ] [nvarchar](1) NULL,
	[LMEIN] [nvarchar](3) NULL,
	[EVERS] [nvarchar](2) NULL,
	[ZWERT] [numeric](13, 2) NULL,
	[ABMNG] [numeric](13, 3) NULL,
	[PRDAT] [nvarchar](8) NULL,
	[BSTYP] [nvarchar](1) NULL,
	[EFFWR] [numeric](13, 2) NULL,
	[XOBLR] [nvarchar](1) NULL,
	[KUNNR] [nvarchar](10) NULL,
	[ADRNR] [nvarchar](10) NULL,
	[EKKOL] [nvarchar](4) NULL,
	[SKTOF] [nvarchar](1) NULL,
	[STAFO] [nvarchar](6) NULL,
	[PLIFZ] [numeric](3, 0) NULL,
	[NTGEW] [numeric](13, 3) NULL,
	[GEWEI] [nvarchar](3) NULL,
	[ETDRK] [nvarchar](1) NULL,
	[SOBKZ] [nvarchar](1) NULL,
	[ARSNR] [nvarchar](10) NULL,
	[ARSPS] [nvarchar](4) NULL,
	[INSNC] [nvarchar](1) NULL,
	[SSQSS] [nvarchar](8) NULL,
	[ZGTYP] [nvarchar](4) NULL,
	[EAN11] [nvarchar](18) NULL,
	[BSTAE] [nvarchar](4) NULL,
	[REVLV] [nvarchar](2) NULL,
	[KO_GSBER] [nvarchar](4) NULL,
	[KO_PARGB] [nvarchar](4) NULL,
	[KO_PRCTR] [nvarchar](10) NULL,
	[KO_PPRCTR] [nvarchar](10) NULL,
	[MEPRF] [nvarchar](1) NULL,
	[BRGEW] [numeric](13, 3) NULL,
	[VOLUM] [numeric](13, 3) NULL,
	[VOLEH] [nvarchar](3) NULL,
	[INCO1] [nvarchar](3) NULL,
	[INCO2] [nvarchar](28) NULL,
	[VORAB] [nvarchar](1) NULL,
	[KOLIF] [nvarchar](10) NULL,
	[LTSNR] [nvarchar](6) NULL,
	[PACKNO] [nvarchar](10) NULL,
	[FPLNR] [nvarchar](10) NULL,
	[GNETWR] [numeric](13, 2) NULL,
	[STAPO] [nvarchar](1) NULL,
	[UEBPO] [nvarchar](5) NULL,
	[LEWED] [nvarchar](8) NULL,
	[EMLIF] [nvarchar](10) NULL,
	[LBLKZ] [nvarchar](1) NULL,
	[SATNR] [nvarchar](40) NULL,
	[ATTYP] [nvarchar](2) NULL,
	[VSART] [nvarchar](2) NULL,
	[HANDOVERLOC] [nvarchar](10) NULL,
	[KANBA] [nvarchar](1) NULL,
	[ADRN2] [nvarchar](10) NULL,
	[CUOBJ] [nvarchar](18) NULL,
	[XERSY] [nvarchar](1) NULL,
	[EILDT] [nvarchar](8) NULL,
	[DRDAT] [nvarchar](8) NULL,
	[DRUHR] [nvarchar](6) NULL,
	[DRUNR] [nvarchar](4) NULL,
	[AKTNR] [nvarchar](10) NULL,
	[ABELN] [nvarchar](10) NULL,
	[ABELP] [nvarchar](5) NULL,
	[ANZPU] [numeric](13, 3) NULL,
	[PUNEI] [nvarchar](3) NULL,
	[SAISO] [nvarchar](4) NULL,
	[SAISJ] [nvarchar](4) NULL,
	[EBON2] [nvarchar](2) NULL,
	[EBON3] [nvarchar](2) NULL,
	[EBONF] [nvarchar](1) NULL,
	[MLMAA] [nvarchar](1) NULL,
	[MHDRZ] [numeric](4, 0) NULL,
	[ANFNR] [nvarchar](10) NULL,
	[ANFPS] [nvarchar](5) NULL,
	[KZKFG] [nvarchar](1) NULL,
	[USEQU] [nvarchar](1) NULL,
	[UMSOK] [nvarchar](1) NULL,
	[BANFN] [nvarchar](10) NULL,
	[BNFPO] [nvarchar](5) NULL,
	[MTART] [nvarchar](4) NULL,
	[UPTYP] [nvarchar](1) NULL,
	[UPVOR] [nvarchar](1) NULL,
	[KZWI1] [numeric](13, 2) NULL,
	[KZWI2] [numeric](13, 2) NULL,
	[KZWI3] [numeric](13, 2) NULL,
	[KZWI4] [numeric](13, 2) NULL,
	[KZWI5] [numeric](13, 2) NULL,
	[KZWI6] [numeric](13, 2) NULL,
	[SIKGR] [nvarchar](3) NULL,
	[MFZHI] [numeric](15, 3) NULL,
	[FFZHI] [numeric](15, 3) NULL,
	[RETPO] [nvarchar](1) NULL,
	[AUREL] [nvarchar](1) NULL,
	[BSGRU] [nvarchar](3) NULL,
	[LFRET] [nvarchar](4) NULL,
	[MFRGR] [nvarchar](8) NULL,
	[NRFHG] [nvarchar](1) NULL,
	[J_1BNBM] [nvarchar](16) NULL,
	[J_1BMATUSE] [nvarchar](1) NULL,
	[J_1BMATORG] [nvarchar](1) NULL,
	[J_1BOWNPRO] [nvarchar](1) NULL,
	[J_1BINDUST] [nvarchar](2) NULL,
	[ABUEB] [nvarchar](4) NULL,
	[NLABD] [nvarchar](8) NULL,
	[NFABD] [nvarchar](8) NULL,
	[KZBWS] [nvarchar](1) NULL,
	[BONBA] [numeric](13, 2) NULL,
	[FABKZ] [nvarchar](1) NULL,
	[J_1AINDXP] [nvarchar](5) NULL,
	[J_1AIDATEP] [nvarchar](8) NULL,
	[MPROF] [nvarchar](4) NULL,
	[EGLKZ] [nvarchar](1) NULL,
	[KZTLF] [nvarchar](1) NULL,
	[KZFME] [nvarchar](1) NULL,
	[RDPRF] [nvarchar](4) NULL,
	[TECHS] [nvarchar](12) NULL,
	[CHG_SRV] [nvarchar](1) NULL,
	[CHG_FPLNR] [nvarchar](1) NULL,
	[MFRPN] [nvarchar](40) NULL,
	[MFRNR] [nvarchar](10) NULL,
	[EMNFR] [nvarchar](10) NULL,
	[NOVET] [nvarchar](1) NULL,
	[AFNAM] [nvarchar](12) NULL,
	[TZONRC] [nvarchar](6) NULL,
	[IPRKZ] [nvarchar](1) NULL,
	[LEBRE] [nvarchar](1) NULL,
	[BERID] [nvarchar](10) NULL,
	[XCONDITIONS] [nvarchar](1) NULL,
	[APOMS] [nvarchar](1) NULL,
	[CCOMP] [nvarchar](1) NULL,
	[STATUS] [nvarchar](1) NULL,
	[RESLO] [nvarchar](4) NULL,
	[WEORA] [nvarchar](1) NULL,
	[SRV_BAS_COM] [nvarchar](1) NULL,
	[PRIO_URG] [nvarchar](2) NULL,
	[PRIO_REQ] [nvarchar](3) NULL,
	[EMPST] [nvarchar](25) NULL,
	[DIFF_INVOICE] [nvarchar](2) NULL,
	[TRMRISK_RELEVANT] [nvarchar](2) NULL,
	[CREATIONDATE] [nvarchar](8) NULL,
	[CREATIONTIME] [nvarchar](6) NULL,
	[SPE_ABGRU] [nvarchar](2) NULL,
	[SPE_CRM_SO] [nvarchar](10) NULL,
	[SPE_CRM_SO_ITEM] [nvarchar](6) NULL,
	[SPE_CRM_REF_SO] [nvarchar](35) NULL,
	[SPE_CRM_REF_ITEM] [nvarchar](6) NULL,
	[SPE_CRM_FKREL] [nvarchar](1) NULL,
	[SPE_CHNG_SYS] [nvarchar](1) NULL,
	[SPE_INSMK_SRC] [nvarchar](1) NULL,
	[SPE_CQ_CTRLTYPE] [nvarchar](1) NULL,
	[SPE_CQ_NOCQ] [nvarchar](1) NULL,
	[REASON_CODE] [nvarchar](4) NULL,
	[CQU_SAR] [numeric](15, 3) NULL,
	[ANZSN] [int] NULL,
	[SPE_EWM_DTC] [nvarchar](1) NULL,
	[EXLIN] [nvarchar](40) NULL,
	[EXSNR] [nvarchar](5) NULL,
	[EHTYP] [nvarchar](4) NULL,
	[RETPC] [numeric](5, 2) NULL,
	[DPTYP] [nvarchar](4) NULL,
	[DPPCT] [numeric](5, 2) NULL,
	[DPAMT] [numeric](11, 2) NULL,
	[DPDAT] [nvarchar](8) NULL,
	[FLS_RSTO] [nvarchar](1) NULL,
	[EXT_RFX_NUMBER] [nvarchar](35) NULL,
	[EXT_RFX_ITEM] [nvarchar](10) NULL,
	[EXT_RFX_SYSTEM] [nvarchar](10) NULL,
	[SRM_CONTRACT_ID] [nvarchar](10) NULL,
	[SRM_CONTRACT_ITM] [nvarchar](10) NULL,
	[BLK_REASON_ID] [nvarchar](4) NULL,
	[BLK_REASON_TXT] [nvarchar](40) NULL,
	[ITCONS] [nvarchar](1) NULL,
	[FIXMG] [nvarchar](1) NULL,
	[WABWE] [nvarchar](1) NULL,
	[CMPL_DLV_ITM] [nvarchar](1) NULL,
	[INCO2_L] [nvarchar](70) NULL,
	[INCO3_L] [nvarchar](70) NULL,
	[STAWN] [nvarchar](30) NULL,
	[ISVCO] [nvarchar](30) NULL,
	[GRWRT] [numeric](13, 2) NULL,
	[SERVICEPERFORMER] [nvarchar](10) NULL,
	[PRODUCTTYPE] [nvarchar](2) NULL,
	[REQUESTFORQUOTATION] [nvarchar](10) NULL,
	[REQUESTFORQUOTATIONITEM] [nvarchar](5) NULL,
	[EXTMATERIALFORPURG] [nvarchar](40) NULL,
	[TARGET_VALUE] [numeric](15, 2) NULL,
	[EXTERNALREFERENCEID] [nvarchar](70) NULL,
	[TC_AUT_DET] [nvarchar](2) NULL,
	[MANUAL_TC_REASON] [nvarchar](2) NULL,
	[FISCAL_INCENTIVE] [nvarchar](4) NULL,
	[TAX_SUBJECT_ST] [nvarchar](1) NULL,
	[FISCAL_INCENTIVE_ID] [nvarchar](4) NULL,
	[SF_TXJCD] [nvarchar](15) NULL,
	[DUMMY_EKPO_INCL_EEW_PS] [nvarchar](1) NULL,
	[EXPECTED_VALUE] [numeric](13, 2) NULL,
	[LIMIT_AMOUNT] [numeric](13, 2) NULL,
	[ENH_DATE1] [nvarchar](8) NULL,
	[ENH_DATE2] [nvarchar](8) NULL,
	[ENH_PERCENT] [numeric](5, 2) NULL,
	[ENH_NUMC1] [nvarchar](10) NULL,
	[/BEV1/NEGEN_ITEM] [nvarchar](1) NULL,
	[/BEV1/NEDEPFREE] [nvarchar](1) NULL,
	[/BEV1/NESTRUCCAT] [nvarchar](1) NULL,
	[ADVCODE] [nvarchar](2) NULL,
	[EXCPE] [nvarchar](2) NULL,
	[IUID_RELEVANT] [nvarchar](1) NULL,
	[MRPIND] [nvarchar](1) NULL,
	[SGT_SCAT] [nvarchar](40) NULL,
	[SGT_RCAT] [nvarchar](40) NULL,
	[TMS_REF_UUID] [nvarchar](22) NULL,
	[WRF_CHARSTC1] [nvarchar](18) NULL,
	[WRF_CHARSTC2] [nvarchar](18) NULL,
	[WRF_CHARSTC3] [nvarchar](18) NULL,
	[ZZBILLI] [nvarchar](1) NULL,
	[ZZEXP_TYP] [nvarchar](25) NULL,
	[ZZWHT] [nvarchar](1) NULL,
	[ZZPSPNR] [nvarchar](8) NULL,
	[REFSITE] [nvarchar](4) NULL,
	[ZAPCGK] [nvarchar](4) NULL,
	[APCGK_EXTEND] [nvarchar](10) NULL,
	[ZBAS_DATE] [nvarchar](8) NULL,
	[ZADATTYP] [nvarchar](1) NULL,
	[ZSTART_DAT] [nvarchar](8) NULL,
	[Z_DEV] [numeric](6, 3) NULL,
	[ZINDANX] [nvarchar](1) NULL,
	[ZLIMIT_DAT] [nvarchar](8) NULL,
	[NUMERATOR] [nvarchar](20) NULL,
	[HASHCAL_BDAT] [nvarchar](8) NULL,
	[HASHCAL] [nvarchar](1) NULL,
	[NEGATIVE] [nvarchar](1) NULL,
	[HASHCAL_EXISTS] [nvarchar](4) NULL,
	[KNOWN_INDEX] [nvarchar](1) NULL,
	[/SAPMP/GPOSE] [nvarchar](5) NULL,
	[ANGPN] [nvarchar](6) NULL,
	[ADMOI] [nvarchar](4) NULL,
	[ADPRI] [nvarchar](3) NULL,
	[LPRIO] [nvarchar](2) NULL,
	[ADACN] [nvarchar](10) NULL,
	[AFPNR] [nvarchar](6) NULL,
	[BSARK] [nvarchar](4) NULL,
	[AUDAT] [nvarchar](8) NULL,
	[ANGNR] [nvarchar](20) NULL,
	[PNSTAT] [nvarchar](1) NULL,
	[ADDNS] [nvarchar](1) NULL,
	[SERRU] [nvarchar](1) NULL,
	[SERNP] [nvarchar](4) NULL,
	[DISUB_SOBKZ] [nvarchar](1) NULL,
	[DISUB_PSPNR] [nvarchar](8) NULL,
	[DISUB_KUNNR] [nvarchar](10) NULL,
	[DISUB_VBELN] [nvarchar](10) NULL,
	[DISUB_POSNR] [nvarchar](6) NULL,
	[DISUB_OWNER] [nvarchar](10) NULL,
	[FSH_SEASON_YEAR] [nvarchar](4) NULL,
	[FSH_SEASON] [nvarchar](10) NULL,
	[FSH_COLLECTION] [nvarchar](10) NULL,
	[FSH_THEME] [nvarchar](10) NULL,
	[FSH_ATP_DATE] [nvarchar](8) NULL,
	[FSH_VAS_REL] [nvarchar](1) NULL,
	[FSH_VAS_PRNT_ID] [nvarchar](5) NULL,
	[FSH_TRANSACTION] [nvarchar](10) NULL,
	[FSH_ITEM_GROUP] [nvarchar](5) NULL,
	[FSH_ITEM] [nvarchar](5) NULL,
	[FSH_SS] [nvarchar](3) NULL,
	[FSH_GRID_COND_REC] [nvarchar](32) NULL,
	[FSH_PSM_PFM_SPLIT] [nvarchar](15) NULL,
	[CNFM_QTY] [numeric](13, 3) NULL,
	[FSH_PQR_UEPOS] [nvarchar](6) NULL,
	[RFM_DIVERSION] [nvarchar](1) NULL,
	[STPAC] [nvarchar](1) NULL,
	[LGBZO] [nvarchar](10) NULL,
	[LGBZO_B] [nvarchar](10) NULL,
	[ADDRNUM] [nvarchar](10) NULL,
	[CONSNUM] [nvarchar](3) NULL,
	[BORGR_MISS] [nvarchar](1) NULL,
	[DEP_ID] [nvarchar](12) NULL,
	[BELNR] [nvarchar](10) NULL,
	[KBLNR_COMP] [nvarchar](10) NULL,
	[KBLPOS_COMP] [nvarchar](3) NULL,
	[WBS_ELEMENT] [nvarchar](8) NULL,
	[RFM_PSST_RULE] [nvarchar](4) NULL,
	[RFM_PSST_GROUP] [nvarchar](10) NULL,
	[RFM_REF_DOC] [nvarchar](10) NULL,
	[RFM_REF_ITEM] [nvarchar](6) NULL,
	[RFM_REF_ACTION] [nvarchar](1) NULL,
	[RFM_REF_SLITEM] [nvarchar](4) NULL,
	[REF_ITEM] [nvarchar](5) NULL,
	[SOURCE_ID] [nvarchar](3) NULL,
	[SOURCE_KEY] [nvarchar](32) NULL,
	[PUT_BACK] [nvarchar](1) NULL,
	[POL_ID] [nvarchar](10) NULL,
	[CONS_ORDER] [nvarchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[GET_ZHR_T_COSTR_JEIN]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[GET_ZHR_T_COSTR_JEIN](
	[ID] [nvarchar](500) NULL,
	[NUMBER] [nvarchar](500) NULL,
	[MESSAGE] [nvarchar](500) NULL,
	[LOG_NO] [nvarchar](500) NULL,
	[LOG_MSG_NO] [nvarchar](500) NULL,
	[MESSAGE_V1] [nvarchar](500) NULL,
	[MESSAGE_V2] [nvarchar](500) NULL,
	[MESSAGE_V3] [nvarchar](500) NULL,
	[MESSAGE_V4] [nvarchar](500) NULL,
	[PARAMETER] [nvarchar](500) NULL,
	[ROW] [nvarchar](500) NULL,
	[FIELD] [nvarchar](500) NULL,
	[SYSTEM] [nvarchar](500) NULL,
	[MANDT] [nvarchar](500) NULL,
	[PERSG] [nvarchar](500) NULL,
	[BEGDA] [nvarchar](500) NULL,
	[ENDDA] [nvarchar](500) NULL,
	[OFFICE_VALUE] [nvarchar](500) NULL,
	[COST_MULT] [nvarchar](500) NULL,
	[COST_ODC_ST] [nvarchar](500) NULL,
	[COST_ODC_OV] [nvarchar](500) NULL,
	[COST_LDC] [nvarchar](500) NULL,
	[COST_ADC] [nvarchar](500) NULL,
	[REVENUE_MULT] [nvarchar](500) NULL,
	[REVENUE_ODC_ST] [nvarchar](500) NULL,
	[REVENUE_ODC_OT] [nvarchar](500) NULL,
	[REVENUE_LDC] [nvarchar](500) NULL,
	[WAERS] [nvarchar](500) NULL,
	[COST_MDC_ST] [nvarchar](500) NULL,
	[COST_MDC_OV] [nvarchar](500) NULL,
	[REVENUE_MDC_ST] [nvarchar](500) NULL,
	[REVENUE_MDC_OT] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL,
	[REVENUE_EDC_OT] [nvarchar](1000) NULL,
	[REVENUE_EDC_ST] [nvarchar](1000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[HRDB]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[HRDB](
	[Personnel_number] [nvarchar](255) NULL,
	[First_name] [nvarchar](255) NULL,
	[Last_name] [nvarchar](255) NULL,
	[Full_Name] [nvarchar](255) NULL,
	[Contract_Start_Date] [datetime] NULL,
	[Employment_Status] [nvarchar](255) NULL,
	[Employment_Group] [nvarchar](255) NULL,
	[Legal_Entity] [nvarchar](255) NULL,
	[Employee_Status] [nvarchar](255) NULL,
	[Vendor_Company] [nvarchar](255) NULL,
	[Expatriate_Home_Office] [nvarchar](255) NULL,
	[Organizational_Unit_ID] [nvarchar](255) NULL,
	[Organizational_Unit] [nvarchar](255) NULL,
	[Department] [nvarchar](255) NULL,
	[Division] [nvarchar](255) NULL,
	[Group] [nvarchar](255) NULL,
	[Rec_Cost_Center_ID] [nvarchar](255) NULL,
	[Rec_Cost_Center] [nvarchar](255) NULL,
	[Sen_Cost_Center_ID] [nvarchar](255) NULL,
	[Sen# Cost Center] [nvarchar](255) NULL,
	[Position ID] [nvarchar](255) NULL,
	[Position] [nvarchar](255) NULL,
	[Job Code] [nvarchar](255) NULL,
	[Job] [nvarchar](255) NULL,
	[Home Office Location] [nvarchar](255) NULL,
	[Office Location] [nvarchar](255) NULL,
	[Functional Manager Name] [nvarchar](255) NULL,
	[Primary Approver Name] [nvarchar](255) NULL,
	[Secondary Approver Name] [nvarchar](255) NULL,
	[Email_Address] [nvarchar](255) NULL,
	[Contract Type] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[HRP1000]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[HRP1000](
	[MANDT] [nvarchar](3) NULL,
	[PLVAR] [nvarchar](2) NULL,
	[OTYPE] [nvarchar](2) NULL,
	[OBJID] [nvarchar](8) NULL,
	[ISTAT] [nvarchar](1) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[LANGU] [nvarchar](1) NULL,
	[SEQNR] [nvarchar](3) NULL,
	[OTJID] [nvarchar](10) NULL,
	[INFTY] [nvarchar](4) NULL,
	[AEDTM] [nvarchar](8) NULL,
	[UNAME] [nvarchar](12) NULL,
	[REASN] [nvarchar](2) NULL,
	[HISTO] [nvarchar](1) NULL,
	[ITXNR] [nvarchar](8) NULL,
	[SHORT] [nvarchar](12) NULL,
	[STEXT] [nvarchar](40) NULL,
	[GDATE] [nvarchar](8) NULL,
	[MC_SHORT] [nvarchar](12) NULL,
	[MC_STEXT] [nvarchar](40) NULL,
	[MC_SEARK] [nvarchar](52) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[HRP1001]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[HRP1001](
	[MANDT] [nvarchar](3) NULL,
	[PLVAR] [nvarchar](2) NULL,
	[OTYPE] [nvarchar](2) NULL,
	[OBJID] [nvarchar](8) NULL,
	[ISTAT] [nvarchar](1) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[SEQNR] [nvarchar](3) NULL,
	[OTJID] [nvarchar](10) NULL,
	[INFTY] [nvarchar](4) NULL,
	[AEDTM] [nvarchar](8) NULL,
	[UNAME] [nvarchar](12) NULL,
	[REASN] [nvarchar](2) NULL,
	[HISTO] [nvarchar](1) NULL,
	[ITXNR] [nvarchar](8) NULL,
	[RSIGN] [nvarchar](1) NULL,
	[RELAT] [nvarchar](3) NULL,
	[PRIOX] [nvarchar](2) NULL,
	[VARYF] [nvarchar](10) NULL,
	[SUBTY] [nvarchar](4) NULL,
	[SCLAS] [nvarchar](2) NULL,
	[SOBID] [nvarchar](45) NULL,
	[PROZT] [numeric](5, 2) NULL,
	[ADATANR] [nvarchar](32) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[KNA1]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[KNA1](
	[MANDT] [nvarchar](500) NULL,
	[KUNNR] [nvarchar](500) NULL,
	[LAND1] [nvarchar](500) NULL,
	[NAME1] [nvarchar](500) NULL,
	[NAME2] [nvarchar](500) NULL,
	[ORT01] [nvarchar](500) NULL,
	[PSTLZ] [nvarchar](500) NULL,
	[REGIO] [nvarchar](500) NULL,
	[SORTL] [nvarchar](500) NULL,
	[STRAS] [nvarchar](500) NULL,
	[TELF1] [nvarchar](500) NULL,
	[TELFX] [nvarchar](500) NULL,
	[XCPDK] [nvarchar](500) NULL,
	[ADRNR] [nvarchar](500) NULL,
	[MCOD1] [nvarchar](500) NULL,
	[MCOD2] [nvarchar](500) NULL,
	[MCOD3] [nvarchar](500) NULL,
	[ANRED] [nvarchar](500) NULL,
	[AUFSD] [nvarchar](500) NULL,
	[BAHNE] [nvarchar](500) NULL,
	[BAHNS] [nvarchar](500) NULL,
	[BBBNR] [nvarchar](500) NULL,
	[BBSNR] [nvarchar](500) NULL,
	[BEGRU] [nvarchar](500) NULL,
	[BRSCH] [nvarchar](500) NULL,
	[BUBKZ] [nvarchar](500) NULL,
	[DATLT] [nvarchar](500) NULL,
	[ERDAT] [nvarchar](500) NULL,
	[ERNAM] [nvarchar](500) NULL,
	[EXABL] [nvarchar](500) NULL,
	[FAKSD] [nvarchar](500) NULL,
	[FISKN] [nvarchar](500) NULL,
	[KNAZK] [nvarchar](500) NULL,
	[KNRZA] [nvarchar](500) NULL,
	[KONZS] [nvarchar](500) NULL,
	[KTOKD] [nvarchar](500) NULL,
	[KUKLA] [nvarchar](500) NULL,
	[LIFRN] [nvarchar](500) NULL,
	[LIFSD] [nvarchar](500) NULL,
	[LOCCO] [nvarchar](500) NULL,
	[LOEVM] [nvarchar](500) NULL,
	[NAME3] [nvarchar](500) NULL,
	[NAME4] [nvarchar](500) NULL,
	[NIELS] [nvarchar](500) NULL,
	[ORT02] [nvarchar](500) NULL,
	[PFACH] [nvarchar](500) NULL,
	[PSTL2] [nvarchar](500) NULL,
	[COUNC] [nvarchar](500) NULL,
	[CITYC] [nvarchar](500) NULL,
	[RPMKR] [nvarchar](500) NULL,
	[SPERR] [nvarchar](500) NULL,
	[SPRAS] [nvarchar](500) NULL,
	[STCD1] [nvarchar](500) NULL,
	[STCD2] [nvarchar](500) NULL,
	[STKZA] [nvarchar](500) NULL,
	[STKZU] [nvarchar](500) NULL,
	[TELBX] [nvarchar](500) NULL,
	[TELF2] [nvarchar](500) NULL,
	[TELTX] [nvarchar](500) NULL,
	[TELX1] [nvarchar](500) NULL,
	[LZONE] [nvarchar](500) NULL,
	[XZEMP] [nvarchar](500) NULL,
	[VBUND] [nvarchar](500) NULL,
	[STCEG] [nvarchar](500) NULL,
	[DEAR1] [nvarchar](500) NULL,
	[DEAR2] [nvarchar](500) NULL,
	[DEAR3] [nvarchar](500) NULL,
	[DEAR4] [nvarchar](500) NULL,
	[DEAR5] [nvarchar](500) NULL,
	[GFORM] [nvarchar](500) NULL,
	[BRAND1] [nvarchar](500) NULL,
	[BRAND2] [nvarchar](500) NULL,
	[BRAND3] [nvarchar](500) NULL,
	[BRAND4] [nvarchar](500) NULL,
	[BRAND5] [nvarchar](500) NULL,
	[EKONT] [nvarchar](500) NULL,
	[UMSAT] [nvarchar](500) NULL,
	[UMJAH] [nvarchar](500) NULL,
	[UWAER] [nvarchar](500) NULL,
	[JMZAH] [nvarchar](500) NULL,
	[JMJAH] [nvarchar](500) NULL,
	[KATR1] [nvarchar](500) NULL,
	[KATR2] [nvarchar](500) NULL,
	[KATR3] [nvarchar](500) NULL,
	[KATR4] [nvarchar](500) NULL,
	[KATR5] [nvarchar](500) NULL,
	[KATR6] [nvarchar](500) NULL,
	[KATR7] [nvarchar](500) NULL,
	[KATR8] [nvarchar](500) NULL,
	[KATR9] [nvarchar](500) NULL,
	[KATR10] [nvarchar](500) NULL,
	[STKZN] [nvarchar](500) NULL,
	[UMSA1] [nvarchar](500) NULL,
	[TXJCD] [nvarchar](500) NULL,
	[PERIV] [nvarchar](500) NULL,
	[ARBVW] [nvarchar](500) NULL,
	[INSPBYDEBI] [nvarchar](500) NULL,
	[INSPATDEBI] [nvarchar](500) NULL,
	[KTOCD] [nvarchar](500) NULL,
	[PFORT] [nvarchar](500) NULL,
	[WERKS] [nvarchar](500) NULL,
	[DTAMS] [nvarchar](500) NULL,
	[DTAWS] [nvarchar](500) NULL,
	[DUEFL] [nvarchar](500) NULL,
	[HZUOR] [nvarchar](500) NULL,
	[SPERZ] [nvarchar](500) NULL,
	[ETIKG] [nvarchar](500) NULL,
	[CIVVE] [nvarchar](500) NULL,
	[MILVE] [nvarchar](500) NULL,
	[KDKG1] [nvarchar](500) NULL,
	[KDKG2] [nvarchar](500) NULL,
	[KDKG3] [nvarchar](500) NULL,
	[KDKG4] [nvarchar](500) NULL,
	[KDKG5] [nvarchar](500) NULL,
	[XKNZA] [nvarchar](500) NULL,
	[FITYP] [nvarchar](500) NULL,
	[STCDT] [nvarchar](500) NULL,
	[STCD3] [nvarchar](500) NULL,
	[STCD4] [nvarchar](500) NULL,
	[STCD5] [nvarchar](500) NULL,
	[XICMS] [nvarchar](500) NULL,
	[XXIPI] [nvarchar](500) NULL,
	[XSUBT] [nvarchar](500) NULL,
	[CFOPC] [nvarchar](500) NULL,
	[TXLW1] [nvarchar](500) NULL,
	[TXLW2] [nvarchar](500) NULL,
	[CCC01] [nvarchar](500) NULL,
	[CCC02] [nvarchar](500) NULL,
	[CCC03] [nvarchar](500) NULL,
	[CCC04] [nvarchar](500) NULL,
	[BONDED_AREA_CONFIRM] [nvarchar](500) NULL,
	[DONATE_MARK] [nvarchar](500) NULL,
	[CASSD] [nvarchar](500) NULL,
	[KNURL] [nvarchar](500) NULL,
	[J_1KFREPRE] [nvarchar](500) NULL,
	[J_1KFTBUS] [nvarchar](500) NULL,
	[J_KFTIND] [nvarchar](500) NULL,
	[CONFS] [nvarchar](500) NULL,
	[UPDAT] [nvarchar](500) NULL,
	[UPTIM] [nvarchar](500) NULL,
	[MODEL] [nvarchar](500) NULL,
	[DEAR6] [nvarchar](500) NULL,
	[CVP_XBLCK] [nvarchar](500) NULL,
	[SUFRAMA] [nvarchar](500) NULL,
	[RG] [nvarchar](500) NULL,
	[EXP] [nvarchar](500) NULL,
	[UF] [nvarchar](500) NULL,
	[RNEDATE] [nvarchar](500) NULL,
	[CNAE] [nvarchar](500) NULL,
	[LEGALNAT] [nvarchar](500) NULL,
	[CRTN] [nvarchar](500) NULL,
	[ICMSTAXPAY] [nvarchar](500) NULL,
	[INDTYP] [nvarchar](500) NULL,
	[TDT] [nvarchar](500) NULL,
	[COMSIZE] [nvarchar](500) NULL,
	[DECREGPC] [nvarchar](500) NULL,
	[KNA1_EEW_CUST] [nvarchar](500) NULL,
	[_-VSO_-R_PALHGT] [nvarchar](500) NULL,
	[_-VSO_-R_PAL_UL] [nvarchar](500) NULL,
	[_-VSO_-R_PK_MAT] [nvarchar](500) NULL,
	[_-VSO_-R_MATPAL] [nvarchar](500) NULL,
	[_-VSO_-R_I_NO_LYR] [nvarchar](500) NULL,
	[_-VSO_-R_ONE_MAT] [nvarchar](500) NULL,
	[_-VSO_-R_ONE_SORT] [nvarchar](500) NULL,
	[_-VSO_-R_ULD_SIDE] [nvarchar](500) NULL,
	[_-VSO_-R_LOAD_PREF] [nvarchar](500) NULL,
	[_-VSO_-R_DPOINT] [nvarchar](500) NULL,
	[ALC] [nvarchar](500) NULL,
	[PMT_OFFICE] [nvarchar](500) NULL,
	[FEE_SCHEDULE] [nvarchar](500) NULL,
	[DUNS] [nvarchar](500) NULL,
	[DUNS4] [nvarchar](500) NULL,
	[PSOFG] [nvarchar](500) NULL,
	[PSOIS] [nvarchar](500) NULL,
	[PSON1] [nvarchar](500) NULL,
	[PSON2] [nvarchar](500) NULL,
	[PSON3] [nvarchar](500) NULL,
	[PSOVN] [nvarchar](500) NULL,
	[PSOTL] [nvarchar](500) NULL,
	[PSOHS] [nvarchar](500) NULL,
	[PSOST] [nvarchar](500) NULL,
	[PSOO1] [nvarchar](500) NULL,
	[PSOO2] [nvarchar](500) NULL,
	[PSOO3] [nvarchar](500) NULL,
	[PSOO4] [nvarchar](500) NULL,
	[PSOO5] [nvarchar](500) NULL,
	[J_1IEXCD] [nvarchar](500) NULL,
	[J_1IEXRN] [nvarchar](500) NULL,
	[J_1IEXRG] [nvarchar](500) NULL,
	[J_1IEXDI] [nvarchar](500) NULL,
	[J_1IEXCO] [nvarchar](500) NULL,
	[J_1ICSTNO] [nvarchar](500) NULL,
	[J_1IPANNO] [nvarchar](500) NULL,
	[J_1IEXCICU] [nvarchar](500) NULL,
	[AEDAT] [nvarchar](500) NULL,
	[USNAM] [nvarchar](500) NULL,
	[J_1ISERN] [nvarchar](500) NULL,
	[J_1IPANREF] [nvarchar](500) NULL,
	[J_3GETYP] [nvarchar](500) NULL,
	[J_3GREFTYP] [nvarchar](500) NULL,
	[PSPNR] [nvarchar](500) NULL,
	[COAUFNR] [nvarchar](500) NULL,
	[J_3GAGEXT] [nvarchar](500) NULL,
	[J_3GAGINT] [nvarchar](500) NULL,
	[J_3GAGDUMI] [nvarchar](500) NULL,
	[J_3GAGSTDI] [nvarchar](500) NULL,
	[LGORT] [nvarchar](500) NULL,
	[KOKRS] [nvarchar](500) NULL,
	[KOSTL] [nvarchar](500) NULL,
	[J_3GABGLG] [nvarchar](500) NULL,
	[J_3GABGVG] [nvarchar](500) NULL,
	[J_3GABRART] [nvarchar](500) NULL,
	[J_3GSTDMON] [nvarchar](500) NULL,
	[J_3GZUGTAG] [nvarchar](500) NULL,
	[J_3GMASCHB] [nvarchar](500) NULL,
	[J_3GMEINSA] [nvarchar](500) NULL,
	[J_3GKEINSA] [nvarchar](500) NULL,
	[J_3GBLSPER] [nvarchar](500) NULL,
	[J_3GKLEIVO] [nvarchar](500) NULL,
	[J_3GCALID] [nvarchar](500) NULL,
	[J_3GVMONAT] [nvarchar](500) NULL,
	[J_3GABRKEN] [nvarchar](500) NULL,
	[J_3GLABRECH] [nvarchar](500) NULL,
	[J_3GAABRECH] [nvarchar](500) NULL,
	[J_3GZUTVHLG] [nvarchar](500) NULL,
	[J_3GNEGMEN] [nvarchar](500) NULL,
	[J_3GFRISTLO] [nvarchar](500) NULL,
	[J_3GEMINBE] [nvarchar](500) NULL,
	[J_3GFMGUE] [nvarchar](500) NULL,
	[J_3GZUSHUE] [nvarchar](500) NULL,
	[J_3GSCHPRS] [nvarchar](500) NULL,
	[J_3GINVSTA] [nvarchar](500) NULL,
	[_-SAPCEM_-DBER] [nvarchar](500) NULL,
	[_-SAPCEM_-KVMEQ] [nvarchar](500) NULL,
	[TYPE] [nvarchar](500) NULL,
	[ID] [nvarchar](500) NULL,
	[NUMBER] [nvarchar](500) NULL,
	[MESSAGE] [nvarchar](500) NULL,
	[LOG_NO] [nvarchar](500) NULL,
	[LOG_MSG_NO] [nvarchar](500) NULL,
	[MESSAGE_V1] [nvarchar](500) NULL,
	[MESSAGE_V2] [nvarchar](500) NULL,
	[MESSAGE_V3] [nvarchar](500) NULL,
	[MESSAGE_V4] [nvarchar](500) NULL,
	[PARAMETER] [nvarchar](500) NULL,
	[ROW] [nvarchar](500) NULL,
	[FIELD] [nvarchar](500) NULL,
	[SYSTEM] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[KNA1_bak]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[KNA1_bak](
	[KUNNR] [nvarchar](255) NULL,
	[LAND1] [nvarchar](255) NULL,
	[NAME1] [nvarchar](255) NULL,
	[NAME2] [nvarchar](255) NULL,
	[ORT01] [nvarchar](255) NULL,
	[PSTLZ] [nvarchar](255) NULL,
	[REGIO] [nvarchar](255) NULL,
	[SORTL] [nvarchar](255) NULL,
	[STRAS] [nvarchar](255) NULL,
	[TELF1] [nvarchar](255) NULL,
	[TELFX] [nvarchar](255) NULL,
	[XCPDK] [nvarchar](255) NULL,
	[ADRNR] [nvarchar](255) NULL,
	[MCOD1] [nvarchar](255) NULL,
	[MCOD2] [nvarchar](255) NULL,
	[MCOD3] [nvarchar](255) NULL,
	[ANRED] [nvarchar](255) NULL,
	[AUFSD] [nvarchar](255) NULL,
	[BAHNE] [nvarchar](255) NULL,
	[BAHNS] [nvarchar](255) NULL,
	[BBBNR] [nvarchar](255) NULL,
	[BBSNR] [nvarchar](255) NULL,
	[BEGRU] [nvarchar](255) NULL,
	[BRSCH] [nvarchar](255) NULL,
	[BUBKZ] [nvarchar](255) NULL,
	[DATLT] [nvarchar](255) NULL,
	[ERDAT] [datetime] NULL,
	[ERNAM] [nvarchar](255) NULL,
	[EXABL] [nvarchar](255) NULL,
	[FAKSD] [nvarchar](255) NULL,
	[FISKN] [nvarchar](255) NULL,
	[KNAZK] [nvarchar](255) NULL,
	[KNRZA] [nvarchar](255) NULL,
	[KONZS] [nvarchar](255) NULL,
	[KTOKD] [nvarchar](255) NULL,
	[KUKLA] [nvarchar](255) NULL,
	[LIFNR] [nvarchar](255) NULL,
	[LIFSD] [nvarchar](255) NULL,
	[LOCCO] [nvarchar](255) NULL,
	[LOEVM] [nvarchar](255) NULL,
	[NAME3] [nvarchar](255) NULL,
	[NAME4] [nvarchar](255) NULL,
	[NIELS] [nvarchar](255) NULL,
	[ORT02] [nvarchar](255) NULL,
	[PFACH] [nvarchar](255) NULL,
	[PSTL2] [nvarchar](255) NULL,
	[COUNC] [nvarchar](255) NULL,
	[CITYC] [nvarchar](255) NULL,
	[RPMKR] [nvarchar](255) NULL,
	[SPERR] [nvarchar](255) NULL,
	[SPRAS] [nvarchar](255) NULL,
	[STCD1] [nvarchar](255) NULL,
	[STCD2] [nvarchar](255) NULL,
	[STKZA] [nvarchar](255) NULL,
	[STKZU] [nvarchar](255) NULL,
	[TELBX] [nvarchar](255) NULL,
	[TELF2] [nvarchar](255) NULL,
	[TELTX] [nvarchar](255) NULL,
	[TELX1] [nvarchar](255) NULL,
	[LZONE] [nvarchar](255) NULL,
	[XZEMP] [nvarchar](255) NULL,
	[VBUND] [nvarchar](255) NULL,
	[STCEG] [nvarchar](255) NULL,
	[DEAR1] [nvarchar](255) NULL,
	[DEAR2] [nvarchar](255) NULL,
	[DEAR3] [nvarchar](255) NULL,
	[DEAR4] [nvarchar](255) NULL,
	[DEAR5] [nvarchar](255) NULL,
	[GFORM] [nvarchar](255) NULL,
	[BRAN1] [nvarchar](255) NULL,
	[BRAN2] [nvarchar](255) NULL,
	[BRAN3] [nvarchar](255) NULL,
	[BRAN4] [nvarchar](255) NULL,
	[BRAN5] [nvarchar](255) NULL,
	[EKONT] [nvarchar](255) NULL,
	[UMSAT] [float] NULL,
	[UMJAH] [nvarchar](255) NULL,
	[UWAER] [nvarchar](255) NULL,
	[JMZAH] [nvarchar](255) NULL,
	[JMJAH] [nvarchar](255) NULL,
	[KATR1] [nvarchar](255) NULL,
	[KATR2] [nvarchar](255) NULL,
	[KATR3] [nvarchar](255) NULL,
	[KATR4] [nvarchar](255) NULL,
	[KATR5] [nvarchar](255) NULL,
	[KATR6] [nvarchar](255) NULL,
	[KATR7] [nvarchar](255) NULL,
	[KATR8] [nvarchar](255) NULL,
	[KATR9] [nvarchar](255) NULL,
	[KATR10] [nvarchar](255) NULL,
	[STKZN] [nvarchar](255) NULL,
	[UMSA1] [float] NULL,
	[TXJCD] [nvarchar](255) NULL,
	[PERIV] [nvarchar](255) NULL,
	[ABRVW] [nvarchar](255) NULL,
	[INSPBYDEBI] [nvarchar](255) NULL,
	[INSPATDEBI] [nvarchar](255) NULL,
	[KTOCD] [nvarchar](255) NULL,
	[PFORT] [nvarchar](255) NULL,
	[WERKS] [nvarchar](255) NULL,
	[DTAMS] [nvarchar](255) NULL,
	[DTAWS] [nvarchar](255) NULL,
	[DUEFL] [nvarchar](255) NULL,
	[HZUOR] [nvarchar](255) NULL,
	[SPERZ] [nvarchar](255) NULL,
	[ETIKG] [nvarchar](255) NULL,
	[CIVVE] [nvarchar](255) NULL,
	[MILVE] [nvarchar](255) NULL,
	[KDKG1] [nvarchar](255) NULL,
	[KDKG2] [nvarchar](255) NULL,
	[KDKG3] [nvarchar](255) NULL,
	[KDKG4] [nvarchar](255) NULL,
	[KDKG5] [nvarchar](255) NULL,
	[XKNZA] [nvarchar](255) NULL,
	[FITYP] [nvarchar](255) NULL,
	[STCDT] [nvarchar](255) NULL,
	[STCD3] [nvarchar](255) NULL,
	[STCD4] [nvarchar](255) NULL,
	[STCD5] [nvarchar](255) NULL,
	[XICMS] [nvarchar](255) NULL,
	[XXIPI] [nvarchar](255) NULL,
	[XSUBT] [nvarchar](255) NULL,
	[CFOPC] [nvarchar](255) NULL,
	[TXLW1] [nvarchar](255) NULL,
	[TXLW2] [nvarchar](255) NULL,
	[CCC01] [nvarchar](255) NULL,
	[CCC02] [nvarchar](255) NULL,
	[CCC03] [nvarchar](255) NULL,
	[CCC04] [nvarchar](255) NULL,
	[BONDED_AREA_CONFIRM] [nvarchar](255) NULL,
	[DONATE_MARK] [nvarchar](255) NULL,
	[CASSD] [nvarchar](255) NULL,
	[KNURL] [nvarchar](255) NULL,
	[J_1KFREPRE] [nvarchar](255) NULL,
	[J_1KFTBUS] [nvarchar](255) NULL,
	[J_1KFTIND] [nvarchar](255) NULL,
	[CONFS] [nvarchar](255) NULL,
	[UPDAT] [datetime] NULL,
	[UPTIM] [datetime] NULL,
	[NODEL] [nvarchar](255) NULL,
	[DEAR6] [nvarchar](255) NULL,
	[CVP_XBLCK] [nvarchar](255) NULL,
	[SUFRAMA] [nvarchar](255) NULL,
	[RG] [nvarchar](255) NULL,
	[EXP] [nvarchar](255) NULL,
	[UF] [nvarchar](255) NULL,
	[RGDATE] [datetime] NULL,
	[RIC] [nvarchar](255) NULL,
	[RNE] [nvarchar](255) NULL,
	[RNEDATE] [datetime] NULL,
	[CNAE] [nvarchar](255) NULL,
	[LEGALNAT] [nvarchar](255) NULL,
	[CRTN] [nvarchar](255) NULL,
	[ICMSTAXPAY] [nvarchar](255) NULL,
	[INDTYP] [nvarchar](255) NULL,
	[TDT] [nvarchar](255) NULL,
	[COMSIZE] [nvarchar](255) NULL,
	[DECREGPC] [nvarchar](255) NULL,
	[KNA1_EEW_CUST] [nvarchar](255) NULL,
	[/VSO/R_PALHGT] [float] NULL,
	[/VSO/R_PAL_UL] [nvarchar](255) NULL,
	[/VSO/R_PK_MAT] [nvarchar](255) NULL,
	[/VSO/R_MATPAL] [nvarchar](255) NULL,
	[/VSO/R_I_NO_LYR] [nvarchar](255) NULL,
	[/VSO/R_ONE_MAT] [nvarchar](255) NULL,
	[/VSO/R_ONE_SORT] [nvarchar](255) NULL,
	[/VSO/R_ULD_SIDE] [nvarchar](255) NULL,
	[/VSO/R_LOAD_PREF] [nvarchar](255) NULL,
	[/VSO/R_DPOINT] [nvarchar](255) NULL,
	[ALC] [nvarchar](255) NULL,
	[PMT_OFFICE] [nvarchar](255) NULL,
	[FEE_SCHEDULE] [nvarchar](255) NULL,
	[DUNS] [nvarchar](255) NULL,
	[DUNS4] [nvarchar](255) NULL,
	[PSOFG] [nvarchar](255) NULL,
	[PSOIS] [nvarchar](255) NULL,
	[PSON1] [nvarchar](255) NULL,
	[PSON2] [nvarchar](255) NULL,
	[PSON3] [nvarchar](255) NULL,
	[PSOVN] [nvarchar](255) NULL,
	[PSOTL] [nvarchar](255) NULL,
	[PSOHS] [nvarchar](255) NULL,
	[PSOST] [nvarchar](255) NULL,
	[PSOO1] [nvarchar](255) NULL,
	[PSOO2] [nvarchar](255) NULL,
	[PSOO3] [nvarchar](255) NULL,
	[PSOO4] [nvarchar](255) NULL,
	[PSOO5] [nvarchar](255) NULL,
	[J_1IEXCD] [nvarchar](255) NULL,
	[J_1IEXRN] [nvarchar](255) NULL,
	[J_1IEXRG] [nvarchar](255) NULL,
	[J_1IEXDI] [nvarchar](255) NULL,
	[J_1IEXCO] [nvarchar](255) NULL,
	[J_1ICSTNO] [nvarchar](255) NULL,
	[J_1ILSTNO] [nvarchar](255) NULL,
	[J_1IPANNO] [nvarchar](255) NULL,
	[J_1IEXCICU] [nvarchar](255) NULL,
	[AEDAT] [datetime] NULL,
	[USNAM] [nvarchar](255) NULL,
	[J_1ISERN] [nvarchar](255) NULL,
	[J_1IPANREF] [nvarchar](255) NULL,
	[J_3GETYP] [nvarchar](255) NULL,
	[J_3GREFTYP] [nvarchar](255) NULL,
	[PSPNR] [nvarchar](255) NULL,
	[COAUFNR] [nvarchar](255) NULL,
	[J_3GAGEXT] [nvarchar](255) NULL,
	[J_3GAGINT] [nvarchar](255) NULL,
	[J_3GAGDUMI] [nvarchar](255) NULL,
	[J_3GAGSTDI] [nvarchar](255) NULL,
	[LGORT] [nvarchar](255) NULL,
	[KOKRS] [nvarchar](255) NULL,
	[KOSTL] [nvarchar](255) NULL,
	[J_3GABGLG] [nvarchar](255) NULL,
	[J_3GABGVG] [nvarchar](255) NULL,
	[J_3GABRART] [nvarchar](255) NULL,
	[J_3GSTDMON] [float] NULL,
	[J_3GSTDTAG] [float] NULL,
	[J_3GTAGMON] [float] NULL,
	[J_3GZUGTAG] [nvarchar](255) NULL,
	[J_3GMASCHB] [nvarchar](255) NULL,
	[J_3GMEINSA] [nvarchar](255) NULL,
	[J_3GKEINSA] [nvarchar](255) NULL,
	[J_3GBLSPER] [nvarchar](255) NULL,
	[J_3GKLEIVO] [nvarchar](255) NULL,
	[J_3GCALID] [nvarchar](255) NULL,
	[J_3GVMONAT] [nvarchar](255) NULL,
	[J_3GABRKEN] [nvarchar](255) NULL,
	[J_3GLABRECH] [datetime] NULL,
	[J_3GAABRECH] [datetime] NULL,
	[J_3GZUTVHLG] [nvarchar](255) NULL,
	[J_3GNEGMEN] [nvarchar](255) NULL,
	[J_3GFRISTLO] [nvarchar](255) NULL,
	[J_3GEMINBE] [nvarchar](255) NULL,
	[J_3GFMGUE] [nvarchar](255) NULL,
	[J_3GZUSCHUE] [nvarchar](255) NULL,
	[J_3GSCHPRS] [nvarchar](255) NULL,
	[J_3GINVSTA] [nvarchar](255) NULL,
	[/SAPCEM/DBER] [nvarchar](255) NULL,
	[/SAPCEM/KVMEQ] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PA0000]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PA0000](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[SUBTY] [nvarchar](4) NULL,
	[OBJPS] [nvarchar](2) NULL,
	[SPRPS] [nvarchar](1) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[SEQNR] [nvarchar](3) NULL,
	[AEDTM] [nvarchar](8) NULL,
	[UNAME] [nvarchar](12) NULL,
	[HISTO] [nvarchar](1) NULL,
	[ITXEX] [nvarchar](1) NULL,
	[REFEX] [nvarchar](1) NULL,
	[ORDEX] [nvarchar](1) NULL,
	[ITBLD] [nvarchar](2) NULL,
	[PREAS] [nvarchar](2) NULL,
	[FLAG1] [nvarchar](1) NULL,
	[FLAG2] [nvarchar](1) NULL,
	[FLAG3] [nvarchar](1) NULL,
	[FLAG4] [nvarchar](1) NULL,
	[RESE1] [nvarchar](2) NULL,
	[RESE2] [nvarchar](2) NULL,
	[GRPVL] [nvarchar](4) NULL,
	[MASSN] [nvarchar](2) NULL,
	[MASSG] [nvarchar](2) NULL,
	[STAT1] [nvarchar](1) NULL,
	[STAT2] [nvarchar](1) NULL,
	[STAT3] [nvarchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PA0001]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PA0001](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[SUBTY] [nvarchar](4) NULL,
	[OBJPS] [nvarchar](2) NULL,
	[SPRPS] [nvarchar](1) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[SEQNR] [nvarchar](3) NULL,
	[AEDTM] [nvarchar](8) NULL,
	[UNAME] [nvarchar](12) NULL,
	[HISTO] [nvarchar](1) NULL,
	[ITXEX] [nvarchar](1) NULL,
	[REFEX] [nvarchar](1) NULL,
	[ORDEX] [nvarchar](1) NULL,
	[ITBLD] [nvarchar](2) NULL,
	[PREAS] [nvarchar](2) NULL,
	[FLAG1] [nvarchar](1) NULL,
	[FLAG2] [nvarchar](1) NULL,
	[FLAG3] [nvarchar](1) NULL,
	[FLAG4] [nvarchar](1) NULL,
	[RESE1] [nvarchar](2) NULL,
	[RESE2] [nvarchar](2) NULL,
	[GRPVL] [nvarchar](4) NULL,
	[BUKRS] [nvarchar](4) NULL,
	[WERKS] [nvarchar](4) NULL,
	[PERSG] [nvarchar](1) NULL,
	[PERSK] [nvarchar](2) NULL,
	[VDSK1] [nvarchar](14) NULL,
	[GSBER] [nvarchar](4) NULL,
	[BTRTL] [nvarchar](4) NULL,
	[JUPER] [nvarchar](4) NULL,
	[ABKRS] [nvarchar](2) NULL,
	[ANSVH] [nvarchar](2) NULL,
	[KOSTL] [nvarchar](10) NULL,
	[ORGEH] [nvarchar](8) NULL,
	[PLANS] [nvarchar](8) NULL,
	[STELL] [nvarchar](8) NULL,
	[MSTBR] [nvarchar](8) NULL,
	[SACHA] [nvarchar](3) NULL,
	[SACHP] [nvarchar](3) NULL,
	[SACHZ] [nvarchar](3) NULL,
	[SNAME] [nvarchar](30) NULL,
	[ENAME] [nvarchar](40) NULL,
	[OTYPE] [nvarchar](2) NULL,
	[SBMOD] [nvarchar](4) NULL,
	[KOKRS] [nvarchar](4) NULL,
	[FISTL] [nvarchar](16) NULL,
	[GEBER] [nvarchar](10) NULL,
	[FKBER] [nvarchar](16) NULL,
	[GRANT_NBR] [nvarchar](20) NULL,
	[SGMNT] [nvarchar](10) NULL,
	[BUDGET_PD] [nvarchar](10) NULL,
	[COMPANY_VENDOR] [nvarchar](4) NULL,
	[OFFICE_EXP_HOME] [nvarchar](4) NULL,
	[COMPANY_PROVIDER] [nvarchar](4) NULL,
	[PRIMARY_APPROVER] [nvarchar](8) NULL,
	[SECONDARY_APPROVER] [nvarchar](8) NULL,
	[HOME_OFFICE_LOCATION] [nvarchar](4) NULL,
	[ACTIVE_ASR] [nvarchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PA0002]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PA0002](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[SUBTY] [nvarchar](4) NULL,
	[OBJPS] [nvarchar](2) NULL,
	[SPRPS] [nvarchar](1) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[SEQNR] [nvarchar](3) NULL,
	[AEDTM] [nvarchar](8) NULL,
	[UNAME] [nvarchar](12) NULL,
	[HISTO] [nvarchar](1) NULL,
	[ITXEX] [nvarchar](1) NULL,
	[REFEX] [nvarchar](1) NULL,
	[ORDEX] [nvarchar](1) NULL,
	[ITBLD] [nvarchar](2) NULL,
	[PREAS] [nvarchar](2) NULL,
	[FLAG1] [nvarchar](1) NULL,
	[FLAG2] [nvarchar](1) NULL,
	[FLAG3] [nvarchar](1) NULL,
	[FLAG4] [nvarchar](1) NULL,
	[RESE1] [nvarchar](2) NULL,
	[RESE2] [nvarchar](2) NULL,
	[GRPVL] [nvarchar](4) NULL,
	[INITS] [nvarchar](10) NULL,
	[NACHN] [nvarchar](40) NULL,
	[NAME2] [nvarchar](40) NULL,
	[NACH2] [nvarchar](40) NULL,
	[VORNA] [nvarchar](40) NULL,
	[CNAME] [nvarchar](80) NULL,
	[TITEL] [nvarchar](15) NULL,
	[TITL2] [nvarchar](15) NULL,
	[NAMZU] [nvarchar](15) NULL,
	[VORSW] [nvarchar](15) NULL,
	[VORS2] [nvarchar](15) NULL,
	[RUFNM] [nvarchar](40) NULL,
	[MIDNM] [nvarchar](40) NULL,
	[KNZNM] [nvarchar](2) NULL,
	[ANRED] [nvarchar](1) NULL,
	[GESCH] [nvarchar](1) NULL,
	[GBDAT] [nvarchar](8) NULL,
	[GBLND] [nvarchar](3) NULL,
	[GBDEP] [nvarchar](3) NULL,
	[GBORT] [nvarchar](40) NULL,
	[NATIO] [nvarchar](3) NULL,
	[NATI2] [nvarchar](3) NULL,
	[NATI3] [nvarchar](3) NULL,
	[SPRSL] [nvarchar](1) NULL,
	[KONFE] [nvarchar](2) NULL,
	[FAMST] [nvarchar](1) NULL,
	[FAMDT] [nvarchar](8) NULL,
	[ANZKD] [numeric](3, 0) NULL,
	[NACON] [nvarchar](1) NULL,
	[PERMO] [nvarchar](2) NULL,
	[PERID] [nvarchar](20) NULL,
	[GBPAS] [nvarchar](8) NULL,
	[FNAMK] [nvarchar](40) NULL,
	[LNAMK] [nvarchar](40) NULL,
	[FNAMR] [nvarchar](40) NULL,
	[LNAMR] [nvarchar](40) NULL,
	[NABIK] [nvarchar](40) NULL,
	[NABIR] [nvarchar](40) NULL,
	[NICKK] [nvarchar](40) NULL,
	[NICKR] [nvarchar](40) NULL,
	[GBJHR] [nvarchar](4) NULL,
	[GBMON] [nvarchar](2) NULL,
	[GBTAG] [nvarchar](2) NULL,
	[NCHMC] [nvarchar](25) NULL,
	[VNAMC] [nvarchar](25) NULL,
	[NAMZ2] [nvarchar](15) NULL,
	[NO_OF_SPOUSE] [nvarchar](2) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PA0007]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PA0007](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[SUBTY] [nvarchar](4) NULL,
	[OBJPS] [nvarchar](2) NULL,
	[SPRPS] [nvarchar](1) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[SEQNR] [nvarchar](3) NULL,
	[AEDTM] [nvarchar](8) NULL,
	[UNAME] [nvarchar](12) NULL,
	[HISTO] [nvarchar](1) NULL,
	[ITXEX] [nvarchar](1) NULL,
	[REFEX] [nvarchar](1) NULL,
	[ORDEX] [nvarchar](1) NULL,
	[ITBLD] [nvarchar](2) NULL,
	[PREAS] [nvarchar](2) NULL,
	[FLAG1] [nvarchar](1) NULL,
	[FLAG2] [nvarchar](1) NULL,
	[FLAG3] [nvarchar](1) NULL,
	[FLAG4] [nvarchar](1) NULL,
	[RESE1] [nvarchar](2) NULL,
	[RESE2] [nvarchar](2) NULL,
	[GRPVL] [nvarchar](4) NULL,
	[SCHKZ] [nvarchar](8) NULL,
	[ZTERF] [nvarchar](1) NULL,
	[EMPCT] [numeric](5, 2) NULL,
	[MOSTD] [numeric](5, 2) NULL,
	[WOSTD] [numeric](5, 2) NULL,
	[ARBST] [numeric](5, 2) NULL,
	[WKWDY] [numeric](4, 2) NULL,
	[JRSTD] [numeric](7, 2) NULL,
	[TEILK] [nvarchar](1) NULL,
	[MINTA] [numeric](5, 2) NULL,
	[MAXTA] [numeric](5, 2) NULL,
	[MINWO] [numeric](5, 2) NULL,
	[MAXWO] [numeric](5, 2) NULL,
	[MINMO] [numeric](5, 2) NULL,
	[MAXMO] [numeric](5, 2) NULL,
	[MINJA] [numeric](7, 2) NULL,
	[MAXJA] [numeric](7, 2) NULL,
	[DYSCH] [nvarchar](1) NULL,
	[KZTIM] [nvarchar](2) NULL,
	[WWEEK] [nvarchar](2) NULL,
	[AWTYP] [nvarchar](5) NULL,
	[TIME_PREFERENCE] [nvarchar](10) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PA0016]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PA0016](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[SUBTY] [nvarchar](4) NULL,
	[OBJPS] [nvarchar](2) NULL,
	[SPRPS] [nvarchar](1) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[SEQNR] [nvarchar](3) NULL,
	[AEDTM] [nvarchar](8) NULL,
	[UNAME] [nvarchar](12) NULL,
	[HISTO] [nvarchar](1) NULL,
	[ITXEX] [nvarchar](1) NULL,
	[REFEX] [nvarchar](1) NULL,
	[ORDEX] [nvarchar](1) NULL,
	[ITBLD] [nvarchar](2) NULL,
	[PREAS] [nvarchar](2) NULL,
	[FLAG1] [nvarchar](1) NULL,
	[FLAG2] [nvarchar](1) NULL,
	[FLAG3] [nvarchar](1) NULL,
	[FLAG4] [nvarchar](1) NULL,
	[RESE1] [nvarchar](2) NULL,
	[RESE2] [nvarchar](2) NULL,
	[GRPVL] [nvarchar](4) NULL,
	[PERSG] [nvarchar](1) NULL,
	[PERSK] [nvarchar](2) NULL,
	[NBTGK] [nvarchar](1) NULL,
	[WTTKL] [nvarchar](1) NULL,
	[LFZFR] [numeric](3, 0) NULL,
	[LFZZH] [nvarchar](3) NULL,
	[LFZSO] [nvarchar](2) NULL,
	[KGZFR] [numeric](3, 0) NULL,
	[KGZZH] [nvarchar](3) NULL,
	[PRBZT] [numeric](3, 0) NULL,
	[PRBEH] [nvarchar](3) NULL,
	[KDGFR] [nvarchar](2) NULL,
	[KDGF2] [nvarchar](2) NULL,
	[ARBER] [nvarchar](8) NULL,
	[EINDT] [nvarchar](8) NULL,
	[KONDT] [nvarchar](8) NULL,
	[KONSL] [nvarchar](2) NULL,
	[CTTYP] [nvarchar](2) NULL,
	[CTEDT] [nvarchar](8) NULL,
	[WRKPL] [nvarchar](40) NULL,
	[CTBEG] [nvarchar](8) NULL,
	[CTNUM] [nvarchar](20) NULL,
	[OBJNB] [nvarchar](12) NULL,
	[LAAYOUNE_STATUS] [nvarchar](1) NULL,
	[EXPATRIATE_STATUS] [nvarchar](1) NULL,
	[OCP_RETIREES] [nvarchar](1) NULL,
	[D28_DAYS_ENTITLEMENT] [nvarchar](1) NULL,
	[PAYROLL_EMPLOYEE_NUMBER] [nvarchar](20) NULL,
	[CONTRACT_NUMBER] [nvarchar](20) NULL,
	[CONTRACT_BONUS] [nvarchar](1) NULL,
	[PREVIOUS_EXPERIENCE] [numeric](4, 2) NULL,
	[AGENCY_EMPLOYEE_NUMBER] [nvarchar](20) NULL,
	[NO_EXP_AVAILABLE] [nvarchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PA0041]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PA0041](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[SUBTY] [nvarchar](4) NULL,
	[OBJPS] [nvarchar](2) NULL,
	[SPRPS] [nvarchar](1) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[SEQNR] [nvarchar](3) NULL,
	[AEDTM] [nvarchar](8) NULL,
	[UNAME] [nvarchar](12) NULL,
	[HISTO] [nvarchar](1) NULL,
	[ITXEX] [nvarchar](1) NULL,
	[REFEX] [nvarchar](1) NULL,
	[ORDEX] [nvarchar](1) NULL,
	[ITBLD] [nvarchar](2) NULL,
	[PREAS] [nvarchar](2) NULL,
	[FLAG1] [nvarchar](1) NULL,
	[FLAG2] [nvarchar](1) NULL,
	[FLAG3] [nvarchar](1) NULL,
	[FLAG4] [nvarchar](1) NULL,
	[RESE1] [nvarchar](2) NULL,
	[RESE2] [nvarchar](2) NULL,
	[GRPVL] [nvarchar](4) NULL,
	[DAR01] [nvarchar](2) NULL,
	[DAT01] [nvarchar](8) NULL,
	[DAR02] [nvarchar](2) NULL,
	[DAT02] [nvarchar](8) NULL,
	[DAR03] [nvarchar](2) NULL,
	[DAT03] [nvarchar](8) NULL,
	[DAR04] [nvarchar](2) NULL,
	[DAT04] [nvarchar](8) NULL,
	[DAR05] [nvarchar](2) NULL,
	[DAT05] [nvarchar](8) NULL,
	[DAR06] [nvarchar](2) NULL,
	[DAT06] [nvarchar](8) NULL,
	[DAR07] [nvarchar](2) NULL,
	[DAT07] [nvarchar](8) NULL,
	[DAR08] [nvarchar](2) NULL,
	[DAT08] [nvarchar](8) NULL,
	[DAR09] [nvarchar](2) NULL,
	[DAT09] [nvarchar](8) NULL,
	[DAR10] [nvarchar](2) NULL,
	[DAT10] [nvarchar](8) NULL,
	[DAR11] [nvarchar](2) NULL,
	[DAT11] [nvarchar](8) NULL,
	[DAR12] [nvarchar](2) NULL,
	[DAT12] [nvarchar](8) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PA0105]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PA0105](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[SUBTY] [nvarchar](4) NULL,
	[OBJPS] [nvarchar](2) NULL,
	[SPRPS] [nvarchar](1) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[SEQNR] [nvarchar](3) NULL,
	[AEDTM] [nvarchar](8) NULL,
	[UNAME] [nvarchar](12) NULL,
	[HISTO] [nvarchar](1) NULL,
	[ITXEX] [nvarchar](1) NULL,
	[REFEX] [nvarchar](1) NULL,
	[ORDEX] [nvarchar](1) NULL,
	[ITBLD] [nvarchar](2) NULL,
	[PREAS] [nvarchar](2) NULL,
	[FLAG1] [nvarchar](1) NULL,
	[FLAG2] [nvarchar](1) NULL,
	[FLAG3] [nvarchar](1) NULL,
	[FLAG4] [nvarchar](1) NULL,
	[RESE1] [nvarchar](2) NULL,
	[RESE2] [nvarchar](2) NULL,
	[GRPVL] [nvarchar](4) NULL,
	[USRTY] [nvarchar](4) NULL,
	[USRID] [nvarchar](30) NULL,
	[USRID_LONG] [nvarchar](241) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PA9001]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PA9001](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[SUBTY] [nvarchar](4) NULL,
	[OBJPS] [nvarchar](2) NULL,
	[SPRPS] [nvarchar](1) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[SEQNR] [nvarchar](3) NULL,
	[AEDTM] [nvarchar](8) NULL,
	[UNAME] [nvarchar](12) NULL,
	[HISTO] [nvarchar](1) NULL,
	[ITXEX] [nvarchar](1) NULL,
	[REFEX] [nvarchar](1) NULL,
	[ORDEX] [nvarchar](1) NULL,
	[ITBLD] [nvarchar](2) NULL,
	[PREAS] [nvarchar](2) NULL,
	[FLAG1] [nvarchar](1) NULL,
	[FLAG2] [nvarchar](1) NULL,
	[FLAG3] [nvarchar](1) NULL,
	[FLAG4] [nvarchar](1) NULL,
	[RESE1] [nvarchar](2) NULL,
	[RESE2] [nvarchar](2) NULL,
	[GRPVL] [nvarchar](4) NULL,
	[EMPLOYEE_ASSIGNMENT_PROJECT] [nvarchar](24) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PLANNING_FORECAST]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PLANNING_FORECAST](
	[Income Statement] [nvarchar](250) NULL,
	[SubIncome] [nvarchar](250) NULL,
	[Month] [nvarchar](250) NULL,
	[Year] [nvarchar](250) NULL,
	[Value] [nvarchar](250) NULL,
	[Sheetname] [nvarchar](250) NULL,
	[Mapping] [nvarchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[PRPS_bak]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[PRPS_bak](
	[MANDT] [nvarchar](3) NULL,
	[PSPNR] [nvarchar](8) NULL,
	[POST1] [nvarchar](40) NULL,
	[OBJNR] [nvarchar](22) NULL,
	[ERNAM] [nvarchar](12) NULL,
	[ERDAT] [nvarchar](8) NULL,
	[AENAM] [nvarchar](12) NULL,
	[AEDAT] [nvarchar](8) NULL,
	[VERNR] [nvarchar](8) NULL,
	[VERNA] [nvarchar](25) NULL,
	[ASTNR] [nvarchar](8) NULL,
	[ASTNA] [nvarchar](25) NULL,
	[PRCTR] [nvarchar](10) NULL,
	[ZUORD] [nvarchar](1) NULL,
	[TRMEQ] [nvarchar](1) NULL,
	[WERKS] [nvarchar](4) NULL,
	[TXTSP] [nvarchar](1) NULL,
	[KOSTL] [nvarchar](10) NULL,
	[KTRG] [nvarchar](12) NULL,
	[BERST] [nvarchar](16) NULL,
	[BERTR] [nvarchar](16) NULL,
	[BERKO] [nvarchar](16) NULL,
	[BERBU] [nvarchar](16) NULL,
	[SPSNR] [nvarchar](8) NULL,
	[SCOPE] [nvarchar](2) NULL,
	[XSTAT] [nvarchar](1) NULL,
	[TXJCD] [nvarchar](15) NULL,
	[ZSCHM] [nvarchar](7) NULL,
	[IMPRF] [nvarchar](6) NULL,
	[ABGSL] [nvarchar](6) NULL,
	[POSTU] [nvarchar](40) NULL,
	[PLINT] [nvarchar](1) NULL,
	[LOEVM] [nvarchar](1) NULL,
	[KZBWS] [nvarchar](1) NULL,
	[PGPRF] [nvarchar](6) NULL,
	[STORT] [nvarchar](10) NULL,
	[LOGSYSTEM] [nvarchar](10) NULL,
	[FUNC_AREA] [nvarchar](16) NULL,
	[VNAME] [nvarchar](6) NULL,
	[RECID] [nvarchar](2) NULL,
	[ETYPE] [nvarchar](3) NULL,
	[OTYPE] [nvarchar](4) NULL,
	[JIBCL] [nvarchar](3) NULL,
	[JIBSA] [nvarchar](5) NULL,
	[SLWID] [nvarchar](7) NULL,
	[USR00] [nvarchar](20) NULL,
	[USR01] [nvarchar](20) NULL,
	[USR02] [nvarchar](10) NULL,
	[USR03] [nvarchar](10) NULL,
	[USR04] [numeric](13, 3) NULL,
	[USE04] [nvarchar](3) NULL,
	[USR05] [numeric](13, 3) NULL,
	[USE05] [nvarchar](3) NULL,
	[USR06] [numeric](13, 3) NULL,
	[USE06] [nvarchar](5) NULL,
	[USR07] [numeric](13, 3) NULL,
	[USE07] [nvarchar](5) NULL,
	[USR08] [nvarchar](8) NULL,
	[USR09] [nvarchar](8) NULL,
	[USR10] [nvarchar](1) NULL,
	[USR11] [nvarchar](1) NULL,
	[CPD_UPDAT] [numeric](15, 0) NULL,
	[FERC_IND] [nvarchar](4) NULL,
	[ZZCLIENT_CURR] [nvarchar](5) NULL,
	[POSID] [nvarchar](24) NULL,
	[PSPHI] [nvarchar](8) NULL,
	[POSKI] [nvarchar](16) NULL,
	[PBUKR] [nvarchar](4) NULL,
	[PGSBR] [nvarchar](4) NULL,
	[PKOKR] [nvarchar](4) NULL,
	[PRART] [nvarchar](2) NULL,
	[STUFE] [smallint] NULL,
	[PLAKZ] [nvarchar](1) NULL,
	[BELKZ] [nvarchar](1) NULL,
	[FAKKZ] [nvarchar](1) NULL,
	[NPFAZ] [nvarchar](1) NULL,
	[KVEWE] [nvarchar](1) NULL,
	[KAPPL] [nvarchar](2) NULL,
	[KALSM] [nvarchar](6) NULL,
	[ZSCHL] [nvarchar](6) NULL,
	[AKOKR] [nvarchar](4) NULL,
	[AKSTL] [nvarchar](10) NULL,
	[FKOKR] [nvarchar](4) NULL,
	[FKSTL] [nvarchar](10) NULL,
	[FABKL] [nvarchar](2) NULL,
	[PSPRI] [nvarchar](1) NULL,
	[EQUNR] [nvarchar](18) NULL,
	[TPLNR] [nvarchar](30) NULL,
	[PWPOS] [nvarchar](5) NULL,
	[CLASF] [nvarchar](1) NULL,
	[EVGEW] [numeric](8, 0) NULL,
	[AENNR] [nvarchar](12) NULL,
	[SUBPR] [nvarchar](12) NULL,
	[FPLNR] [nvarchar](10) NULL,
	[TADAT] [nvarchar](8) NULL,
	[IZWEK] [nvarchar](2) NULL,
	[ISIZE] [nvarchar](2) NULL,
	[IUMKZ] [nvarchar](5) NULL,
	[ABUKR] [nvarchar](4) NULL,
	[GRPKZ] [nvarchar](1) NULL,
	[PSPNR_LOGS] [nvarchar](8) NULL,
	[KLVAR] [nvarchar](4) NULL,
	[KALNR] [nvarchar](12) NULL,
	[POSID_EDIT] [nvarchar](24) NULL,
	[PSPKZ] [nvarchar](1) NULL,
	[MATNR] [nvarchar](40) NULL,
	[VLPSP] [nvarchar](8) NULL,
	[VLPKZ] [nvarchar](1) NULL,
	[SORT1] [nvarchar](10) NULL,
	[SORT2] [nvarchar](10) NULL,
	[SORT3] [nvarchar](10) NULL,
	[CGPL_GUID16] [binary](16) NULL,
	[CGPL_LOGSYS] [nvarchar](10) NULL,
	[CGPL_OBJTYPE] [nvarchar](3) NULL,
	[ADPSP] [nvarchar](40) NULL,
	[RFIPPNT] [nvarchar](20) NULL,
	[EEW_PRPS_PS_DUMMY] [nvarchar](1) NULL,
	[ZAD_REG] [nvarchar](2) NULL,
	[ZAD_SECLOB] [nvarchar](4) NULL,
	[ZAD_LAND] [nvarchar](3) NULL,
	[ZAD_BUSARE] [nvarchar](3) NULL,
	[ZAD_GEO] [nvarchar](3) NULL,
	[ZAD_PRLO] [nvarchar](3) NULL,
	[ZAD_SERTYP] [nvarchar](4) NULL,
	[ZPROJECT_CTRL] [nvarchar](8) NULL,
	[ZPROJECT_DIRECTOR] [nvarchar](8) NULL,
	[ZPROJECT_ACC] [nvarchar](8) NULL,
	[ZAD_CT] [nvarchar](2) NULL,
	[ZZKUNNR] [nvarchar](10) NULL,
	[ZZCT_VAL] [nvarchar](20) NULL,
	[ZZBU_LEAD] [nvarchar](20) NULL,
	[ZZOCP_PROJ] [nvarchar](1) NULL,
	[ZZCLNT_PROJMGR] [nvarchar](20) NULL,
	[ZZCLNT_FMRMGR] [nvarchar](20) NULL,
	[ZZCLNT_PROJDIR] [nvarchar](20) NULL,
	[ZZCOST_CTRL] [nvarchar](8) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[SETHEADER]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[SETHEADER](
	[MANDT] [nvarchar](3) NULL,
	[SETCLASS] [nvarchar](4) NULL,
	[SUBCLASS] [nvarchar](12) NULL,
	[SETNAME] [nvarchar](24) NULL,
	[SETTYPE] [nvarchar](1) NULL,
	[XDYNAMIC] [nvarchar](1) NULL,
	[AUTHGR] [nvarchar](4) NULL,
	[XUNIQ] [nvarchar](1) NULL,
	[RVALUE] [nvarchar](40) NULL,
	[CREUSER] [nvarchar](12) NULL,
	[CREDATE] [nvarchar](8) NULL,
	[CRETIME] [nvarchar](6) NULL,
	[UPDUSER] [nvarchar](12) NULL,
	[UPDDATE] [nvarchar](8) NULL,
	[UPDTIME] [nvarchar](6) NULL,
	[SAPRL] [nvarchar](4) NULL,
	[TABNAME] [nvarchar](30) NULL,
	[FIELDNAME] [nvarchar](30) NULL,
	[ROLLNAME] [nvarchar](30) NULL,
	[SET_OLANGU] [nvarchar](1) NULL,
	[NO_RWSHEADER] [nvarchar](1) NULL,
	[NO_RWSLINE] [nvarchar](1) NULL,
	[NO_SETLINET] [nvarchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[SETLEAF]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[SETLEAF](
	[MANDT] [nvarchar](3) NULL,
	[SETCLASS] [nvarchar](4) NULL,
	[SUBCLASS] [nvarchar](12) NULL,
	[SETNAME] [nvarchar](24) NULL,
	[LINEID] [nvarchar](10) NULL,
	[SEQNR] [int] NULL,
	[VALSIGN] [nvarchar](1) NULL,
	[VALOPTION] [nvarchar](2) NULL,
	[VALFROM] [nvarchar](40) NULL,
	[VALTO] [nvarchar](40) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[SETNODE]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[SETNODE](
	[MANDT] [nvarchar](3) NULL,
	[SETCLASS] [nvarchar](4) NULL,
	[SUBCLASS] [nvarchar](12) NULL,
	[SETNAME] [nvarchar](24) NULL,
	[LINEID] [nvarchar](10) NULL,
	[SUBSETCLS] [nvarchar](4) NULL,
	[SUBSETSCLS] [nvarchar](12) NULL,
	[SUBSETNAME] [nvarchar](24) NULL,
	[SEQNR] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[SKA1]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[SKA1](
	[Chart of Accounts] [nvarchar](255) NULL,
	[G/L Account] [nvarchar](255) NULL,
	[Balance sheet account] [nvarchar](255) NULL,
	[G/L Account1] [nvarchar](255) NULL,
	[Group Account Number] [nvarchar](255) NULL,
	[Created on] [datetime] NULL,
	[Created by] [nvarchar](255) NULL,
	[P&L statmt acct type] [nvarchar](255) NULL,
	[Account Group] [nvarchar](255) NULL,
	[Sample Account] [nvarchar](255) NULL,
	[Trading partner] [nvarchar](255) NULL,
	[Mark for Deletion] [nvarchar](255) NULL,
	[Blocked for Creation] [nvarchar](255) NULL,
	[Blocked for Posting] [nvarchar](255) NULL,
	[Blocked for Planning] [nvarchar](255) NULL,
	[Search Term] [nvarchar](255) NULL,
	[Functional Area] [nvarchar](255) NULL,
	[G/L Account Type] [nvarchar](255) NULL,
	[Time Stamp] [datetime] NULL,
	[Short Text] [nvarchar](255) NULL,
	[G/L Acct Long Text] [nvarchar](255) NULL,
	[G/L Long Text] [nvarchar](255) NULL,
	[Time Stamp1] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[SKAT]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[SKAT](
	[Language Key] [nvarchar](255) NULL,
	[Chart of Accounts] [nvarchar](255) NULL,
	[G/L Account] [nvarchar](255) NULL,
	[Short Text] [nvarchar](255) NULL,
	[G/L Acct Long Text] [nvarchar](255) NULL,
	[G/L Long Text] [nvarchar](255) NULL,
	[Time Stamp] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[SKB1]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[SKB1](
	[Company Code] [nvarchar](255) NULL,
	[G/L Account] [nvarchar](255) NULL,
	[Authorization Group] [nvarchar](255) NULL,
	[Clerk Abbreviation] [nvarchar](255) NULL,
	[Date of Last Interest Calc#] [datetime] NULL,
	[Created on] [datetime] NULL,
	[Created by] [nvarchar](255) NULL,
	[Planning Group] [nvarchar](255) NULL,
	[Planning Level] [nvarchar](255) NULL,
	[Financial Budget] [nvarchar](255) NULL,
	[Field status group] [nvarchar](255) NULL,
	[House bank] [nvarchar](255) NULL,
	[Account ID] [nvarchar](255) NULL,
	[Exchange Rate Difference Key] [nvarchar](255) NULL,
	[Recon# Account for Acct Type] [nvarchar](255) NULL,
	[Tax Category] [nvarchar](255) NULL,
	[G/L Account Additional Text] [nvarchar](255) NULL,
	[Interest indicator] [nvarchar](255) NULL,
	[Account currency] [nvarchar](255) NULL,
	[Acct Managed in Ext# System] [nvarchar](255) NULL,
	[Relevant to Cash Flow] [nvarchar](255) NULL,
	[Post Automatically Only] [nvarchar](255) NULL,
	[Line Item Display Possible] [nvarchar](255) NULL,
	[Mark for Deletion] [nvarchar](255) NULL,
	[Supplement Auto# Postings] [nvarchar](255) NULL,
	[Open Item Management] [nvarchar](255) NULL,
	[Blocked for Posting] [nvarchar](255) NULL,
	[Key Date of Last Int# Calc#] [datetime] NULL,
	[Interest Calc# Frequency] [nvarchar](255) NULL,
	[Sort key] [nvarchar](255) NULL,
	[Alternative Account No#] [nvarchar](255) NULL,
	[Recon# Acct Ready for Input] [nvarchar](255) NULL,
	[Recovery Indicator] [nvarchar](255) NULL,
	[Commitment item] [nvarchar](255) NULL,
	[Posting without tax allowed] [nvarchar](255) NULL,
	[Balances in Local Crcy Only] [nvarchar](255) NULL,
	[Valuation Group] [nvarchar](255) NULL,
	[Inflation key] [nvarchar](255) NULL,
	[Tolerance Group] [nvarchar](255) NULL,
	[Clearing Specific to Ledger Groups] [nvarchar](255) NULL,
	[MCA  Key] [nvarchar](255) NULL,
	[Controlling area data changed] [nvarchar](255) NULL,
	[Time Stamp] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[T528T]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[T528T](
	[MANDT] [nvarchar](3) NULL,
	[OTYPE] [nvarchar](4) NULL,
	[SPRSL] [nvarchar](1) NULL,
	[PLANS] [nvarchar](8) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[PLSTX] [nvarchar](25) NULL,
	[MAINT] [nvarchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[T547S]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[T547S](
	[MANDT] [nvarchar](3) NULL,
	[SPRSL] [nvarchar](1) NULL,
	[CTTYP] [nvarchar](2) NULL,
	[CTTXT] [nvarchar](20) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[TCURR]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[TCURR](
	[TYPE] [nvarchar](500) NULL,
	[ID] [nvarchar](500) NULL,
	[NUMBER] [nvarchar](500) NULL,
	[MESSAGE] [nvarchar](500) NULL,
	[LOG_NO] [nvarchar](500) NULL,
	[LOG_MSG_NO] [nvarchar](500) NULL,
	[MESSAGE_V1] [nvarchar](500) NULL,
	[MESSAGE_V2] [nvarchar](500) NULL,
	[MESSAGE_V3] [nvarchar](500) NULL,
	[MESSAGE_V4] [nvarchar](500) NULL,
	[PARAMETER] [nvarchar](500) NULL,
	[ROW] [nvarchar](500) NULL,
	[FIELD] [nvarchar](500) NULL,
	[SYSTEM] [nvarchar](500) NULL,
	[MANDT] [nvarchar](500) NULL,
	[TCURR] [nvarchar](500) NULL,
	[KURST] [nvarchar](500) NULL,
	[FCURR] [nvarchar](500) NULL,
	[GDATU] [nvarchar](500) NULL,
	[UKURS] [nvarchar](500) NULL,
	[FFACT] [nvarchar](500) NULL,
	[TFACT] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[test_cost_proj]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[test_cost_proj](
	[ProjDef] [nvarchar](24) NULL,
	[WBSElement1] [nvarchar](24) NOT NULL,
	[Network1] [nvarchar](40) NOT NULL,
	[WBSElement2] [nvarchar](24) NOT NULL,
	[Network2] [nvarchar](40) NOT NULL,
	[WBSElement3] [nvarchar](24) NOT NULL,
	[Network3] [nvarchar](40) NOT NULL,
	[WBSElement4] [nvarchar](24) NOT NULL,
	[Network4] [nvarchar](40) NOT NULL,
	[Val_COArea_Crcy] [float] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[TJ02T]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[TJ02T](
	[ISTAT] [nvarchar](5) NULL,
	[SPRAS] [nvarchar](1) NULL,
	[TXT04] [nvarchar](4) NULL,
	[TXT30] [nvarchar](30) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZCOST]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZCOST](
	[Project definition] [nvarchar](255) NULL,
	[WBS element] [nvarchar](255) NULL,
	[G&A] [nvarchar](255) NULL,
	[Company Code] [nvarchar](255) NULL,
	[Cost Element] [nvarchar](255) NULL,
	[Profit Center] [nvarchar](255) NULL,
	[Effective Date] [datetime] NULL,
	[Task Code] [nvarchar](255) NULL,
	[Expenditure Type] [nvarchar](255) NULL,
	[NL TYPE] [nvarchar](255) NULL,
	[Purchasing Document] [nvarchar](255) NULL,
	[Transaction date] [datetime] NULL,
	[Personnel Number] [nvarchar](255) NULL,
	[Employee name] [nvarchar](255) NULL,
	[Total quantity] [float] NULL,
	[Posted unit of meas#] [nvarchar](255) NULL,
	[Val/COArea Crcy] [float] NULL,
	[BWR] [float] NULL,
	[Raw cost] [float] NULL,
	[Total Cost] [float] NULL,
	[Cost price for ODC] [float] NULL,
	[Cost price for ADC] [float] NULL,
	[Cost price for LDC] [float] NULL,
	[Cost price for MDC] [float] NULL,
	[Name] [nvarchar](255) NULL,
	[Reference] [nvarchar](255) NULL,
	[Expense Number] [nvarchar](255) NULL,
	[Billable project (Y/N)] [nvarchar](255) NULL,
	[Sender Cost Center] [nvarchar](255) NULL,
	[Partner-CCtr] [nvarchar](255) NULL,
	[Document Number] [nvarchar](255) NULL,
	[Vendor] [nvarchar](255) NULL,
	[Vendor name] [nvarchar](255) NULL,
	[FileName] [nvarchar](500) NULL,
	[MonthPeriod] [int] NULL,
	[YearPeriod] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZCOST_bak]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZCOST_bak](
	[Project_definition] [nvarchar](255) NULL,
	[WBS_element] [nvarchar](255) NULL,
	[G_A] [nvarchar](255) NULL,
	[Company_Code] [nvarchar](255) NULL,
	[Cost_Element] [nvarchar](255) NULL,
	[Profit_Center] [nvarchar](255) NULL,
	[Effective_Date] [datetime] NULL,
	[Task_Code] [nvarchar](255) NULL,
	[Expenditure_Type] [nvarchar](255) NULL,
	[NL_TYPE] [nvarchar](255) NULL,
	[Purchasing_Document] [nvarchar](255) NULL,
	[Transaction_date] [datetime] NULL,
	[Personnel_Number] [nvarchar](255) NULL,
	[Employee_name] [nvarchar](255) NULL,
	[Total_quantity] [float] NULL,
	[Posted_unit_of_meas] [nvarchar](255) NULL,
	[Val_COArea_Crcy] [float] NULL,
	[BWR] [float] NULL,
	[Raw_cost] [float] NULL,
	[Total_Cost] [float] NULL,
	[Cost_price_for_ODC] [float] NULL,
	[Cost_price_for_ADC] [float] NULL,
	[Cost_price_for_LDC] [float] NULL,
	[Z_Name] [nvarchar](255) NULL,
	[Reference] [nvarchar](255) NULL,
	[Expense_Number] [nvarchar](255) NULL,
	[Billable_project] [nvarchar](255) NULL,
	[Sender_Cost_Center] [nvarchar](255) NULL,
	[Partner_CCtr] [nvarchar](255) NULL,
	[Document_Number] [nvarchar](255) NULL,
	[Vendor] [nvarchar](255) NULL,
	[Vendor_name] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZCOST_TMP]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZCOST_TMP](
	[Project definition] [nvarchar](255) NULL,
	[WBS element] [nvarchar](255) NULL,
	[G&A] [nvarchar](255) NULL,
	[Company Code] [nvarchar](255) NULL,
	[Cost Element] [nvarchar](255) NULL,
	[Profit Center] [nvarchar](255) NULL,
	[Effective Date] [datetime] NULL,
	[Task Code] [nvarchar](255) NULL,
	[Expenditure Type] [nvarchar](255) NULL,
	[NL TYPE] [nvarchar](255) NULL,
	[Purchasing Document] [nvarchar](255) NULL,
	[Transaction date] [datetime] NULL,
	[Personnel Number] [nvarchar](255) NULL,
	[Employee name] [nvarchar](255) NULL,
	[Total quantity] [float] NULL,
	[Posted unit of meas#] [nvarchar](255) NULL,
	[Val/COArea Crcy] [float] NULL,
	[BWR] [float] NULL,
	[Raw cost] [float] NULL,
	[Total Cost] [float] NULL,
	[Cost price for ODC] [float] NULL,
	[Cost price for ADC] [float] NULL,
	[Cost price for LDC] [float] NULL,
	[Cost price for MDC] [float] NULL,
	[Name] [nvarchar](255) NULL,
	[Reference] [nvarchar](255) NULL,
	[Expense Number] [nvarchar](255) NULL,
	[Billable project (Y/N)] [nvarchar](255) NULL,
	[Sender Cost Center] [nvarchar](255) NULL,
	[Partner-CCtr] [nvarchar](255) NULL,
	[Document Number] [nvarchar](255) NULL,
	[Vendor] [nvarchar](255) NULL,
	[Vendor name] [nvarchar](255) NULL,
	[FileName] [nvarchar](500) NULL,
	[MonthPeriod] [int] NULL,
	[YearPeriod] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZFI_LBR]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZFI_LBR](
	[MANDT] [nvarchar](3) NULL,
	[ZEBELN] [nvarchar](10) NULL,
	[ZEBELP] [nvarchar](5) NULL,
	[ZMBLNR] [nvarchar](10) NULL,
	[ZGJAHR] [nvarchar](4) NULL,
	[ZMONAT] [nvarchar](2) NULL,
	[ZMATNR] [nvarchar](40) NULL,
	[ZPS_POSID] [nvarchar](8) NULL,
	[ZNPLNR] [nvarchar](12) NULL,
	[ZVORNR] [nvarchar](4) NULL,
	[ZBUDAT] [nvarchar](8) NULL,
	[ZBELNR] [nvarchar](10) NULL,
	[ZWRBTR] [numeric](23, 2) NULL,
	[ZCURR] [nvarchar](5) NULL,
	[ZDMBTR] [numeric](23, 2) NULL,
	[ZZNL_TYP] [nvarchar](25) NULL,
	[ZBILLABLE] [nvarchar](4) NULL,
	[ZAMT_COF] [numeric](23, 2) NULL,
	[ZTOTAL] [numeric](23, 2) NULL,
	[ZTOTAL_BIS] [numeric](23, 2) NULL,
	[ZTOTAL_LOC] [numeric](23, 2) NULL,
	[ZZEILE] [nvarchar](4) NULL,
	[ZZTOTAL_CT] [numeric](11, 2) NULL,
	[ZZCLIENT_CURR] [nvarchar](5) NULL,
	[ZSHKZG] [nvarchar](1) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZFI_LBR_CAR]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZFI_LBR_CAR](
	[MANDT] [nvarchar](3) NULL,
	[ZGJAHR] [nvarchar](4) NULL,
	[ZBELNR] [nvarchar](10) NULL,
	[ZWRBTR] [numeric](23, 2) NULL,
	[ZCURR] [nvarchar](5) NULL,
	[ZDMBTR] [numeric](23, 2) NULL,
	[ZZNL_TYP] [nvarchar](25) NULL,
	[ZBILLABLE] [nvarchar](4) NULL,
	[ZTOTAL_BIS] [numeric](23, 2) NULL,
	[ZZTOTAL_CT] [numeric](11, 2) NULL,
	[ZZCLIENT_CURR] [nvarchar](5) NULL,
	[ZSHKZG] [nvarchar](1) NULL,
	[ZBUKRS] [nvarchar](4) NULL,
	[ZBUZEI] [nvarchar](3) NULL,
	[BUDAT] [nvarchar](8) NULL,
	[MONAT] [nvarchar](2) NULL,
	[PROJK] [nvarchar](8) NULL,
	[NPLNR] [nvarchar](12) NULL,
	[GJAHR] [nvarchar](4) NULL,
	[BSCHL] [nvarchar](2) NULL,
	[HKONT] [nvarchar](10) NULL,
	[ZRBUDAT] [nvarchar](8) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZFI_LBR_FI]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZFI_LBR_FI](
	[MANDT] [nvarchar](3) NULL,
	[ZGJAHR] [nvarchar](4) NULL,
	[ZBELNR] [nvarchar](10) NULL,
	[ZWRBTR] [numeric](23, 2) NULL,
	[ZCURR] [nvarchar](5) NULL,
	[ZDMBTR] [numeric](23, 2) NULL,
	[ZZNL_TYP] [nvarchar](25) NULL,
	[ZBILLABLE] [nvarchar](4) NULL,
	[ZAMT_COF] [numeric](23, 2) NULL,
	[ZTOTAL] [numeric](23, 2) NULL,
	[ZTOTAL_BIS] [numeric](23, 2) NULL,
	[ZTOTAL_LOC] [numeric](23, 2) NULL,
	[ZZTOTAL_CT] [numeric](11, 2) NULL,
	[ZZCLIENT_CURR] [nvarchar](5) NULL,
	[ZSHKZG] [nvarchar](1) NULL,
	[ZBUKRS] [nvarchar](4) NULL,
	[ZBUZEI] [nvarchar](3) NULL,
	[BUDAT] [nvarchar](8) NULL,
	[MONAT] [nvarchar](2) NULL,
	[PROJK] [nvarchar](8) NULL,
	[NPLNR] [nvarchar](12) NULL,
	[ZTRANS_CURR] [nvarchar](5) NULL,
	[ZAMT_TRANS_CURR] [numeric](11, 2) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZHR_ABS_BALANCES]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZHR_ABS_BALANCES](
	[MANDT] [nvarchar](3) NULL,
	[PERNR] [nvarchar](8) NULL,
	[AWART] [nvarchar](4) NULL,
	[BEGDA] [nvarchar](8) NULL,
	[ENDDA] [nvarchar](8) NULL,
	[ACCRUING] [numeric](7, 2) NULL,
	[RECOVERY] [numeric](7, 2) NULL,
	[QUOTA] [numeric](7, 2) NULL,
	[PAYOUT] [numeric](7, 2) NULL,
	[DESTA] [nvarchar](8) NULL,
	[DEEND] [nvarchar](8) NULL,
	[TIME_BANK] [numeric](7, 2) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZHR_JOB_ACT]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZHR_JOB_ACT](
	[TYPE] [nvarchar](500) NULL,
	[ID] [nvarchar](500) NULL,
	[NUMBER] [nvarchar](500) NULL,
	[MESSAGE] [nvarchar](500) NULL,
	[LOG_NO] [nvarchar](500) NULL,
	[LOG_MSG_NO] [nvarchar](500) NULL,
	[MESSAGE_V1] [nvarchar](500) NULL,
	[MESSAGE_V2] [nvarchar](500) NULL,
	[MESSAGE_V3] [nvarchar](500) NULL,
	[MESSAGE_V4] [nvarchar](500) NULL,
	[PARAMETER] [nvarchar](500) NULL,
	[ROW] [nvarchar](500) NULL,
	[FIELD] [nvarchar](500) NULL,
	[SYSTEM] [nvarchar](500) NULL,
	[MANDT] [nvarchar](500) NULL,
	[BUKRS] [nvarchar](500) NULL,
	[ENDDA] [nvarchar](500) NULL,
	[BEGDA] [nvarchar](500) NULL,
	[ACTIVE] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZHR_JOB_RATE]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZHR_JOB_RATE](
	[MANDT] [nvarchar](500) NULL,
	[STOPT] [nvarchar](500) NULL,
	[ENDDA] [nvarchar](500) NULL,
	[BEGDA] [nvarchar](500) NULL,
	[PRICE_REV_ASR] [nvarchar](500) NULL,
	[PRICE_REV_ASR1] [nvarchar](500) NULL,
	[PRICE_REV_ASR2] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZHR_T_COS_REV_F]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZHR_T_COS_REV_F](
	[TYPE] [nvarchar](1000) NULL,
	[ID] [nvarchar](1000) NULL,
	[NUMBER] [nvarchar](1000) NULL,
	[MESSAGE] [nvarchar](1000) NULL,
	[LOG_NO] [nvarchar](1000) NULL,
	[LOG_MSG_NO] [nvarchar](1000) NULL,
	[MESSAGE_V1] [nvarchar](1000) NULL,
	[MESSAGE_V2] [nvarchar](1000) NULL,
	[MESSAGE_V3] [nvarchar](1000) NULL,
	[MESSAGE_V4] [nvarchar](1000) NULL,
	[PARAMETER] [nvarchar](1000) NULL,
	[ROW] [nvarchar](1000) NULL,
	[FIELD] [nvarchar](1000) NULL,
	[SYSTEM] [nvarchar](1000) NULL,
	[MANDT] [nvarchar](1000) NULL,
	[PERSG] [nvarchar](1000) NULL,
	[BEGDA] [nvarchar](1000) NULL,
	[ENDDA] [nvarchar](1000) NULL,
	[FORMULA] [nvarchar](1000) NULL,
	[COST_ASSIGN] [nvarchar](1000) NULL,
	[BWR1] [nvarchar](1000) NULL,
	[BWR2] [nvarchar](1000) NULL,
	[ODC] [nvarchar](1000) NULL,
	[EDC] [nvarchar](1000) NULL,
	[LDC] [nvarchar](1000) NULL,
	[ADC] [nvarchar](1000) NULL,
	[MDC] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZHR_T_COSTR_JEEA]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZHR_T_COSTR_JEEA](
	[ID] [nvarchar](500) NULL,
	[NUMBER] [nvarchar](500) NULL,
	[MESSAGE] [nvarchar](500) NULL,
	[LOG_NO] [nvarchar](500) NULL,
	[LOG_MSG_NO] [nvarchar](500) NULL,
	[MESSAGE_V1] [nvarchar](500) NULL,
	[MESSAGE_V2] [nvarchar](500) NULL,
	[MESSAGE_V3] [nvarchar](500) NULL,
	[MESSAGE_V4] [nvarchar](500) NULL,
	[PARAMETER] [nvarchar](500) NULL,
	[ROW] [nvarchar](500) NULL,
	[FIELD] [nvarchar](500) NULL,
	[SYSTEM] [nvarchar](500) NULL,
	[MANDT] [nvarchar](500) NULL,
	[PERSG] [nvarchar](500) NULL,
	[BEGDA] [nvarchar](500) NULL,
	[ENDDA] [nvarchar](500) NULL,
	[OFFICE_VALUE] [nvarchar](500) NULL,
	[COST_MULT] [nvarchar](500) NULL,
	[COST_ODC_ST] [nvarchar](500) NULL,
	[COST_ODC_OV] [nvarchar](500) NULL,
	[COST_LDC] [nvarchar](500) NULL,
	[COST_ADC] [nvarchar](500) NULL,
	[REVENUE_MULT] [nvarchar](500) NULL,
	[REVENUE_ODC_ST] [nvarchar](500) NULL,
	[REVENUE_ODC_OT] [nvarchar](500) NULL,
	[REVENUE_LDC] [nvarchar](500) NULL,
	[WAERS] [nvarchar](500) NULL,
	[COST_MDC_ST] [nvarchar](500) NULL,
	[COST_MDC_OV] [nvarchar](500) NULL,
	[REVENUE_MDC_ST] [nvarchar](500) NULL,
	[REVENUE_MDC_OT] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL,
	[REVENUE_EDC_OT] [nvarchar](1000) NULL,
	[REVENUE_EDC_ST] [nvarchar](1000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZHR_T_COSTR_JESA]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZHR_T_COSTR_JESA](
	[TYPE] [nvarchar](1000) NULL,
	[ID] [nvarchar](1000) NULL,
	[NUMBER] [nvarchar](1000) NULL,
	[MESSAGE] [nvarchar](1000) NULL,
	[LOG_NO] [nvarchar](1000) NULL,
	[LOG_MSG_NO] [nvarchar](1000) NULL,
	[MESSAGE_V1] [nvarchar](1000) NULL,
	[MESSAGE_V2] [nvarchar](1000) NULL,
	[MESSAGE_V3] [nvarchar](1000) NULL,
	[MESSAGE_V4] [nvarchar](1000) NULL,
	[PARAMETER] [nvarchar](1000) NULL,
	[ROW] [nvarchar](1000) NULL,
	[FIELD] [nvarchar](1000) NULL,
	[SYSTEM] [nvarchar](1000) NULL,
	[MANDT] [nvarchar](1000) NULL,
	[PERSG] [nvarchar](1000) NULL,
	[BEGDA] [nvarchar](1000) NULL,
	[ENDDA] [nvarchar](1000) NULL,
	[OFFICE_VALUE] [nvarchar](1000) NULL,
	[COST_MULT] [nvarchar](1000) NULL,
	[COST_ODC_ST] [nvarchar](1000) NULL,
	[COST_ODC_OV] [nvarchar](1000) NULL,
	[COST_LDC] [nvarchar](1000) NULL,
	[COST_ADC] [nvarchar](1000) NULL,
	[REVENUE_MULT] [nvarchar](1000) NULL,
	[REVENUE_ODC_ST] [nvarchar](1000) NULL,
	[REVENUE_ODC_OT] [nvarchar](1000) NULL,
	[REVENUE_EDC_ST] [nvarchar](1000) NULL,
	[REVENUE_EDC_OT] [nvarchar](1000) NULL,
	[REVENUE_LDC] [nvarchar](1000) NULL,
	[WAERS] [nvarchar](1000) NULL,
	[COST_MDC_ST] [nvarchar](1000) NULL,
	[COST_MDC_OV] [nvarchar](1000) NULL,
	[REVENUE_MDC_ST] [nvarchar](1000) NULL,
	[REVENUE_MDC_OT] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZHR_T_COSTR_JESE]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZHR_T_COSTR_JESE](
	[TYPE] [nvarchar](1000) NULL,
	[ID] [nvarchar](1000) NULL,
	[NUMBER] [nvarchar](1000) NULL,
	[MESSAGE] [nvarchar](1000) NULL,
	[LOG_NO] [nvarchar](1000) NULL,
	[LOG_MSG_NO] [nvarchar](1000) NULL,
	[MESSAGE_V1] [nvarchar](1000) NULL,
	[MESSAGE_V2] [nvarchar](1000) NULL,
	[MESSAGE_V3] [nvarchar](1000) NULL,
	[MESSAGE_V4] [nvarchar](1000) NULL,
	[PARAMETER] [nvarchar](1000) NULL,
	[ROW] [nvarchar](1000) NULL,
	[FIELD] [nvarchar](1000) NULL,
	[SYSTEM] [nvarchar](1000) NULL,
	[MANDT] [nvarchar](1000) NULL,
	[PERSG] [nvarchar](1000) NULL,
	[BEGDA] [nvarchar](1000) NULL,
	[ENDDA] [nvarchar](1000) NULL,
	[OFFICE_VALUE] [nvarchar](1000) NULL,
	[COST_MULT] [nvarchar](1000) NULL,
	[COST_ODC_ST] [nvarchar](1000) NULL,
	[COST_ODC_OV] [nvarchar](1000) NULL,
	[COST_LDC] [nvarchar](1000) NULL,
	[COST_ADC] [nvarchar](1000) NULL,
	[REVENUE_MULT] [nvarchar](1000) NULL,
	[REVENUE_ODC_ST] [nvarchar](1000) NULL,
	[REVENUE_ODC_OT] [nvarchar](1000) NULL,
	[REVENUE_EDC_ST] [nvarchar](1000) NULL,
	[REVENUE_EDC_OT] [nvarchar](1000) NULL,
	[REVENUE_LDC] [nvarchar](1000) NULL,
	[WAERS] [nvarchar](1000) NULL,
	[COST_MDC_ST] [nvarchar](1000) NULL,
	[COST_MDC_OV] [nvarchar](1000) NULL,
	[REVENUE_MDC_ST] [nvarchar](1000) NULL,
	[REVENUE_MDC_OT] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZHR_T_COSTR_JETM]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZHR_T_COSTR_JETM](
	[TYPE] [nvarchar](1000) NULL,
	[ID] [nvarchar](1000) NULL,
	[NUMBER] [nvarchar](1000) NULL,
	[MESSAGE] [nvarchar](1000) NULL,
	[LOG_NO] [nvarchar](1000) NULL,
	[LOG_MSG_NO] [nvarchar](1000) NULL,
	[MESSAGE_V1] [nvarchar](1000) NULL,
	[MESSAGE_V2] [nvarchar](1000) NULL,
	[MESSAGE_V3] [nvarchar](1000) NULL,
	[MESSAGE_V4] [nvarchar](1000) NULL,
	[PARAMETER] [nvarchar](1000) NULL,
	[ROW] [nvarchar](1000) NULL,
	[FIELD] [nvarchar](1000) NULL,
	[SYSTEM] [nvarchar](1000) NULL,
	[MANDT] [nvarchar](1000) NULL,
	[PERSG] [nvarchar](1000) NULL,
	[BEGDA] [nvarchar](1000) NULL,
	[ENDDA] [nvarchar](1000) NULL,
	[OFFICE_VALUE] [nvarchar](1000) NULL,
	[COST_MULT] [nvarchar](1000) NULL,
	[COST_ODC_ST] [nvarchar](1000) NULL,
	[COST_ODC_OV] [nvarchar](1000) NULL,
	[COST_LDC] [nvarchar](1000) NULL,
	[COST_ADC] [nvarchar](1000) NULL,
	[REVENUE_MULT] [nvarchar](1000) NULL,
	[REVENUE_ODC_ST] [nvarchar](1000) NULL,
	[REVENUE_ODC_OT] [nvarchar](1000) NULL,
	[REVENUE_EDC_ST] [nvarchar](1000) NULL,
	[REVENUE_EDC_OT] [nvarchar](1000) NULL,
	[REVENUE_LDC] [nvarchar](1000) NULL,
	[WAERS] [nvarchar](1000) NULL,
	[COST_MDC_ST] [nvarchar](1000) NULL,
	[COST_MDC_OV] [nvarchar](1000) NULL,
	[REVENUE_MDC_ST] [nvarchar](1000) NULL,
	[REVENUE_MDC_OT] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZHR_T_COSTR_JEUS]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZHR_T_COSTR_JEUS](
	[TYPE] [nvarchar](1000) NULL,
	[ID] [nvarchar](1000) NULL,
	[NUMBER] [nvarchar](1000) NULL,
	[MESSAGE] [nvarchar](1000) NULL,
	[LOG_NO] [nvarchar](1000) NULL,
	[LOG_MSG_NO] [nvarchar](1000) NULL,
	[MESSAGE_V1] [nvarchar](1000) NULL,
	[MESSAGE_V2] [nvarchar](1000) NULL,
	[MESSAGE_V3] [nvarchar](1000) NULL,
	[MESSAGE_V4] [nvarchar](1000) NULL,
	[PARAMETER] [nvarchar](1000) NULL,
	[ROW] [nvarchar](1000) NULL,
	[FIELD] [nvarchar](1000) NULL,
	[SYSTEM] [nvarchar](1000) NULL,
	[MANDT] [nvarchar](1000) NULL,
	[PERSG] [nvarchar](1000) NULL,
	[BEGDA] [nvarchar](1000) NULL,
	[ENDDA] [nvarchar](1000) NULL,
	[OFFICE_VALUE] [nvarchar](1000) NULL,
	[COST_MULT] [nvarchar](1000) NULL,
	[COST_ODC_ST] [nvarchar](1000) NULL,
	[COST_ODC_OV] [nvarchar](1000) NULL,
	[COST_LDC] [nvarchar](1000) NULL,
	[COST_ADC] [nvarchar](1000) NULL,
	[REVENUE_MULT] [nvarchar](1000) NULL,
	[REVENUE_ODC_ST] [nvarchar](1000) NULL,
	[REVENUE_ODC_OT] [nvarchar](1000) NULL,
	[REVENUE_EDC_ST] [nvarchar](1000) NULL,
	[REVENUE_EDC_OT] [nvarchar](1000) NULL,
	[REVENUE_LDC] [nvarchar](1000) NULL,
	[WAERS] [nvarchar](1000) NULL,
	[COST_MDC_ST] [nvarchar](1000) NULL,
	[COST_MDC_OV] [nvarchar](1000) NULL,
	[REVENUE_MDC_ST] [nvarchar](1000) NULL,
	[REVENUE_MDC_OT] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZHR_T_COSTR_JEWA]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZHR_T_COSTR_JEWA](
	[TYPE] [nvarchar](1000) NULL,
	[ID] [nvarchar](1000) NULL,
	[NUMBER] [nvarchar](1000) NULL,
	[MESSAGE] [nvarchar](1000) NULL,
	[LOG_NO] [nvarchar](1000) NULL,
	[LOG_MSG_NO] [nvarchar](1000) NULL,
	[MESSAGE_V1] [nvarchar](1000) NULL,
	[MESSAGE_V2] [nvarchar](1000) NULL,
	[MESSAGE_V3] [nvarchar](1000) NULL,
	[MESSAGE_V4] [nvarchar](1000) NULL,
	[PARAMETER] [nvarchar](1000) NULL,
	[ROW] [nvarchar](1000) NULL,
	[FIELD] [nvarchar](1000) NULL,
	[SYSTEM] [nvarchar](1000) NULL,
	[MANDT] [nvarchar](1000) NULL,
	[PERSG] [nvarchar](1000) NULL,
	[BEGDA] [nvarchar](1000) NULL,
	[ENDDA] [nvarchar](1000) NULL,
	[OFFICE_VALUE] [nvarchar](1000) NULL,
	[COST_MULT] [nvarchar](1000) NULL,
	[COST_ODC_ST] [nvarchar](1000) NULL,
	[COST_ODC_OV] [nvarchar](1000) NULL,
	[COST_LDC] [nvarchar](1000) NULL,
	[COST_ADC] [nvarchar](1000) NULL,
	[REVENUE_MULT] [nvarchar](1000) NULL,
	[REVENUE_ODC_ST] [nvarchar](1000) NULL,
	[REVENUE_ODC_OT] [nvarchar](1000) NULL,
	[REVENUE_EDC_ST] [nvarchar](1000) NULL,
	[REVENUE_EDC_OT] [nvarchar](1000) NULL,
	[REVENUE_LDC] [nvarchar](1000) NULL,
	[WAERS] [nvarchar](1000) NULL,
	[COST_MDC_ST] [nvarchar](1000) NULL,
	[COST_MDC_OV] [nvarchar](1000) NULL,
	[REVENUE_MDC_ST] [nvarchar](1000) NULL,
	[REVENUE_MDC_OT] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZNL_COEF]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZNL_COEF](
	[TYPE] [nvarchar](1000) NULL,
	[ID] [nvarchar](1000) NULL,
	[NUMBER] [nvarchar](1000) NULL,
	[MESSAGE] [nvarchar](1000) NULL,
	[LOG_NO] [nvarchar](1000) NULL,
	[LOG_MSG_NO] [nvarchar](1000) NULL,
	[MESSAGE_V1] [nvarchar](1000) NULL,
	[MESSAGE_V2] [nvarchar](1000) NULL,
	[MESSAGE_V3] [nvarchar](1000) NULL,
	[MESSAGE_V4] [nvarchar](1000) NULL,
	[PARAMETER] [nvarchar](1000) NULL,
	[ROW] [nvarchar](1000) NULL,
	[FIELD] [nvarchar](1000) NULL,
	[SYSTEM] [nvarchar](1000) NULL,
	[MANDT] [nvarchar](1000) NULL,
	[ZZ_WBS] [nvarchar](1000) NULL,
	[NL_TYPE] [nvarchar](1000) NULL,
	[COEF] [nvarchar](1000) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZREV]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZREV](
	[Project definition] [nvarchar](255) NULL,
	[WBS element] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[Legal Entity] [nvarchar](255) NULL,
	[Cost Element] [nvarchar](255) NULL,
	[Profit Center] [nvarchar](255) NULL,
	[Effective Date] [datetime] NULL,
	[Network] [nvarchar](255) NULL,
	[Task Code] [nvarchar](255) NULL,
	[Expenditure Type] [nvarchar](255) NULL,
	[NL TYPE] [nvarchar](255) NULL,
	[NL Type Rate] [float] NULL,
	[NL Margin] [float] NULL,
	[Purchasing Document] [nvarchar](255) NULL,
	[AR invoice] [nvarchar](255) NULL,
	[Document Date] [datetime] NULL,
	[Transaction date] [datetime] NULL,
	[Catsps Date] [datetime] NULL,
	[Personnel Number] [nvarchar](255) NULL,
	[Employee name] [nvarchar](255) NULL,
	[Total quantity] [float] NULL,
	[UoM] [nvarchar](255) NULL,
	[Raw Cost] [float] NULL,
	[Raw Cost BWR] [float] NULL,
	[Total Revenue] [float] NULL,
	[BWR] [float] NULL,
	[Currency] [nvarchar](255) NULL,
	[Value in trans# cur#] [float] NULL,
	[Transaction Currency] [nvarchar](255) NULL,
	[Total Cost] [float] NULL,
	[Revenue Labor] [float] NULL,
	[Revenue ODC] [float] NULL,
	[Revenue EDC] [float] NULL,
	[Revenue LDC] [float] NULL,
	[Revenue MDC] [float] NULL,
	[Reference] [nvarchar](255) NULL,
	[Expense Number] [nvarchar](255) NULL,
	[Billable project (Y/N)] [nvarchar](255) NULL,
	[Document Number] [nvarchar](255) NULL,
	[Document Number G/L] [nvarchar](255) NULL,
	[Vendor] [nvarchar](255) NULL,
	[Vendor name] [nvarchar](255) NULL,
	[Att#/Absence type] [nvarchar](255) NULL,
	[Sender profit center] [nvarchar](255) NULL,
	[Employee group] [nvarchar](255) NULL,
	[Employee subgroup] [nvarchar](255) NULL,
	[Expatriate Home Office ID] [nvarchar](255) NULL,
	[Reversed] [nvarchar](255) NULL,
	[Results analysis key] [nvarchar](255) NULL,
	[Business Transaction] [nvarchar](255) NULL,
	[Comment] [nvarchar](255) NULL,
	[FileName] [nvarchar](500) NULL,
	[MonthPeriod] [int] NULL,
	[YearPeriod] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SAP].[ZREV_TMP]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SAP].[ZREV_TMP](
	[Project definition] [nvarchar](255) NULL,
	[WBS element] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[Legal Entity] [nvarchar](255) NULL,
	[Cost Element] [nvarchar](255) NULL,
	[Profit Center] [nvarchar](255) NULL,
	[Effective Date] [datetime] NULL,
	[Network] [nvarchar](255) NULL,
	[Task Code] [nvarchar](255) NULL,
	[Expenditure Type] [nvarchar](255) NULL,
	[NL TYPE] [nvarchar](255) NULL,
	[NL Type Rate] [float] NULL,
	[NL Margin] [float] NULL,
	[Purchasing Document] [nvarchar](255) NULL,
	[AR invoice] [nvarchar](255) NULL,
	[Document Date] [datetime] NULL,
	[Transaction date] [datetime] NULL,
	[Catsps Date] [datetime] NULL,
	[Personnel Number] [nvarchar](255) NULL,
	[Employee name] [nvarchar](255) NULL,
	[Total quantity] [float] NULL,
	[UoM] [nvarchar](255) NULL,
	[Raw Cost] [float] NULL,
	[Raw Cost BWR] [float] NULL,
	[Total Revenue] [float] NULL,
	[BWR] [float] NULL,
	[Currency] [nvarchar](255) NULL,
	[Value in trans# cur#] [float] NULL,
	[Transaction Currency] [nvarchar](255) NULL,
	[Total Cost] [float] NULL,
	[Revenue Labor] [float] NULL,
	[Revenue ODC] [float] NULL,
	[Revenue EDC] [float] NULL,
	[Revenue LDC] [float] NULL,
	[Revenue MDC] [float] NULL,
	[Reference] [nvarchar](255) NULL,
	[Expense Number] [nvarchar](255) NULL,
	[Billable project (Y/N)] [nvarchar](255) NULL,
	[Document Number] [nvarchar](255) NULL,
	[Document Number G/L] [nvarchar](255) NULL,
	[Vendor] [nvarchar](255) NULL,
	[Vendor name] [nvarchar](255) NULL,
	[Att#/Absence type] [nvarchar](255) NULL,
	[Sender profit center] [nvarchar](255) NULL,
	[Employee group] [nvarchar](255) NULL,
	[Employee subgroup] [nvarchar](255) NULL,
	[Expatriate Home Office ID] [nvarchar](255) NULL,
	[Reversed] [nvarchar](255) NULL,
	[Results analysis key] [nvarchar](255) NULL,
	[Business Transaction] [nvarchar](255) NULL,
	[Comment] [nvarchar](255) NULL,
	[FileName] [nvarchar](500) NULL,
	[MonthPeriod] [int] NULL,
	[YearPeriod] [int] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SPS].[CostCenterMapping]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SPS].[CostCenterMapping](
	[Cost Center] [float] NULL,
	[Company Code] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[Cost Center Owner] [nvarchar](255) NULL,
	[Hierarchy Area] [nvarchar](255) NULL,
	[Currency] [nvarchar](255) NULL,
	[Profit Center] [nvarchar](255) NULL,
	[New P&L] [nvarchar](255) NULL,
	[Category] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SPS].[ExtractionCostCenters]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SPS].[ExtractionCostCenters](
	[Cost Element] [nvarchar](255) NULL,
	[Cost element name] [nvarchar](255) NULL,
	[Val#in rep#cur#] [float] NULL,
	[Posted unit of meas#] [nvarchar](255) NULL,
	[Total quantity] [float] NULL,
	[Offsetting Account Type] [nvarchar](255) NULL,
	[Offsetting Account] [nvarchar](255) NULL,
	[Name of offsetting account] [nvarchar](255) NULL,
	[NoName] [nvarchar](255) NULL,
	[Cost Center] [nvarchar](255) NULL,
	[Document Number] [nvarchar](255) NULL,
	[CO Object Name] [nvarchar](255) NULL,
	[CO Partner Object Name] [nvarchar](255) NULL,
	[Billable project (Y/N)] [nvarchar](255) NULL,
	[Company Code] [nvarchar](255) NULL,
	[Cost element descr#] [nvarchar](255) NULL,
	[Document Date] [datetime] NULL,
	[Document Type] [nvarchar](255) NULL,
	[Material description] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[Name of offsetting account1] [nvarchar](255) NULL,
	[NL TYPE] [nvarchar](255) NULL,
	[Partner Object] [nvarchar](255) NULL,
	[Partner CoCode] [nvarchar](255) NULL,
	[Partner Object Class] [nvarchar](255) NULL,
	[Partner-CCtr] [nvarchar](255) NULL,
	[Material] [nvarchar](255) NULL,
	[Period] [nvarchar](255) NULL,
	[Ref# Document Type] [nvarchar](255) NULL,
	[Ref# document number] [nvarchar](255) NULL,
	[Purchasing Document] [nvarchar](255) NULL,
	[Personnel Number] [nvarchar](255) NULL,
	[Plant] [nvarchar](255) NULL,
	[Total Quantity1] [float] NULL,
	[User Name] [nvarchar](255) NULL,
	[Val/COArea Crcy] [float] NULL,
	[Value in Obj# Crcy] [float] NULL,
	[Posting Date] [datetime] NULL,
	[FilePath] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SPS].[ExtractionCostPB]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SPS].[ExtractionCostPB](
	[Project definition] [nvarchar](255) NULL,
	[WBS element] [nvarchar](255) NULL,
	[G&A] [nvarchar](255) NULL,
	[Company Code] [nvarchar](255) NULL,
	[Cost Element] [nvarchar](255) NULL,
	[Profit Center] [nvarchar](255) NULL,
	[Effective Date] [datetime] NULL,
	[Task Code] [nvarchar](255) NULL,
	[Expenditure Type] [nvarchar](255) NULL,
	[NL TYPE] [nvarchar](255) NULL,
	[Purchasing Document] [nvarchar](255) NULL,
	[Transaction date] [datetime] NULL,
	[Personnel Number] [nvarchar](255) NULL,
	[Employee name] [nvarchar](255) NULL,
	[Total quantity] [float] NULL,
	[Posted unit of meas#] [nvarchar](255) NULL,
	[Val/COArea Crcy] [float] NULL,
	[BWR] [float] NULL,
	[Raw cost] [float] NULL,
	[Total Cost] [float] NULL,
	[Cost price for ODC] [float] NULL,
	[Cost price for ADC] [float] NULL,
	[Cost price for LDC] [float] NULL,
	[Name] [nvarchar](255) NULL,
	[Reference] [nvarchar](255) NULL,
	[Expense Number] [nvarchar](255) NULL,
	[Billable project (Y/N)] [nvarchar](255) NULL,
	[Sender Cost Center] [nvarchar](255) NULL,
	[Partner-CCtr] [nvarchar](255) NULL,
	[Document Number] [nvarchar](255) NULL,
	[Vendor] [nvarchar](255) NULL,
	[Vendor name] [nvarchar](255) NULL,
	[Cost price for MDC] [float] NULL,
	[PRPS Profit Center] [nvarchar](255) NULL,
	[BU] [nvarchar](255) NULL,
	[Labor/Non Labor] [nvarchar](255) NULL,
	[T1/T5] [nvarchar](255) NULL,
	[Project Name] [nvarchar](255) NULL,
	[Project Type] [nvarchar](255) NULL,
	[Project Profit Center] [nvarchar](255) NULL,
	[Sender CC Name] [nvarchar](255) NULL,
	[Partner CC Name] [nvarchar](255) NULL,
	[Cost Element Name] [nvarchar](255) NULL,
	[Employee Category] [nvarchar](255) NULL,
	[Employee Sub Category] [nvarchar](255) NULL,
	[Expat Offices] [nvarchar](255) NULL,
	[Cost Element Cat] [nvarchar](255) NULL,
	[Project Type BP OVH] [nvarchar](255) NULL,
	[Project Type II] [nvarchar](255) NULL,
	[Project Type III] [nvarchar](255) NULL,
	[FilePath] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SPS].[ExtractionCostPB_new]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SPS].[ExtractionCostPB_new](
	[Cost Element] [float] NULL,
	[Cost element name] [nvarchar](255) NULL,
	[Val#in rep#cur#] [float] NULL,
	[Posted unit of meas#] [nvarchar](255) NULL,
	[Total quantity] [float] NULL,
	[Offsetting Account Type] [nvarchar](255) NULL,
	[Offsetting Account] [nvarchar](255) NULL,
	[Name of offsetting account] [nvarchar](255) NULL,
	[X] [nvarchar](255) NULL,
	[Cost Center] [float] NULL,
	[Document Number] [nvarchar](255) NULL,
	[CO Object Name] [nvarchar](255) NULL,
	[CO Partner Object Name] [nvarchar](255) NULL,
	[Billable project (Y/N)] [nvarchar](255) NULL,
	[Company Code] [nvarchar](255) NULL,
	[Cost element descr#] [nvarchar](255) NULL,
	[Document Date] [float] NULL,
	[Document Type] [nvarchar](255) NULL,
	[Material description] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[Name of offsetting account1] [nvarchar](255) NULL,
	[NL TYPE] [nvarchar](255) NULL,
	[Partner Object] [nvarchar](255) NULL,
	[Partner CoCode] [nvarchar](255) NULL,
	[Partner Object Class] [nvarchar](255) NULL,
	[Partner-CCtr] [nvarchar](255) NULL,
	[Material] [nvarchar](255) NULL,
	[Period] [nvarchar](255) NULL,
	[Ref# Document Type] [nvarchar](255) NULL,
	[Ref# document number] [nvarchar](255) NULL,
	[Purchasing Document] [nvarchar](255) NULL,
	[Personnel Number] [nvarchar](255) NULL,
	[Plant] [nvarchar](255) NULL,
	[Total Quantity1] [float] NULL,
	[User Name] [nvarchar](255) NULL,
	[Val/COArea Crcy] [float] NULL,
	[Value in Obj# Crcy] [float] NULL,
	[Posting Date] [float] NULL,
	[Company Code1] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[Cost Center Owner] [nvarchar](255) NULL,
	[Hierarchy Area] [nvarchar](255) NULL,
	[Currency] [nvarchar](255) NULL,
	[Profit Center] [nvarchar](255) NULL,
	[Old P&L Line] [nvarchar](255) NULL,
	[New P&L] [nvarchar](255) NULL,
	[BU] [nvarchar](255) NULL,
	[Categogy] [nvarchar](255) NULL,
	[Labor#non Labor] [nvarchar](255) NULL,
	[CategorieI ] [nvarchar](255) NULL,
	[Categorie II] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SPS].[ExtractionGLPB]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SPS].[ExtractionGLPB](
	[Company Code] [nvarchar](255) NULL,
	[G/L Account] [nvarchar](255) NULL,
	[Vendor] [nvarchar](255) NULL,
	[Vendor Account: Name 1] [nvarchar](255) NULL,
	[Document Date] [datetime] NULL,
	[Reference] [nvarchar](255) NULL,
	[Purchasing Document] [nvarchar](255) NULL,
	[Document Number] [nvarchar](255) NULL,
	[Cleared Item] [nvarchar](255) NULL,
	[Company Code Currency Value] [float] NULL,
	[Company Code Currency Key] [nvarchar](255) NULL,
	[Processed Database Rows] [float] NULL,
	[Transaction type] [nvarchar](255) NULL,
	[Document Header Text] [nvarchar](255) NULL,
	[Document type] [nvarchar](255) NULL,
	[Cost Center] [nvarchar](255) NULL,
	[Entry Date] [datetime] NULL,
	[G/L Account: Long Text] [nvarchar](255) NULL,
	[Clearing Document] [nvarchar](255) NULL,
	[Payment reference] [nvarchar](255) NULL,
	[Material] [nvarchar](255) NULL,
	[Posting period] [nvarchar](255) NULL,
	[Personnel Number] [nvarchar](255) NULL,
	[Invoice Reference] [nvarchar](255) NULL,
	[User Name] [nvarchar](255) NULL,
	[Cost Center: Long Text] [nvarchar](255) NULL,
	[Material: Description] [nvarchar](255) NULL,
	[G/L Account1] [nvarchar](255) NULL,
	[Vendor name] [nvarchar](255) NULL,
	[Text] [nvarchar](255) NULL,
	[Ledger] [nvarchar](255) NULL,
	[Reference quantity] [float] NULL,
	[RefUnit of Measure] [nvarchar](255) NULL,
	[Transaction Currency] [nvarchar](255) NULL,
	[Pmnt currency] [nvarchar](255) NULL,
	[Currency] [nvarchar](255) NULL,
	[Customer] [nvarchar](255) NULL,
	[Customer Account: Name 1] [nvarchar](255) NULL,
	[Origin object] [nvarchar](255) NULL,
	[Assignment] [nvarchar](255) NULL,
	[Network] [nvarchar](255) NULL,
	[Cost Center: Short Text] [nvarchar](255) NULL,
	[Customer Account: Name 2] [nvarchar](255) NULL,
	[Document Currency Value] [float] NULL,
	[Document Currency Key] [nvarchar](255) NULL,
	[Business Area] [nvarchar](255) NULL,
	[Posting Key] [nvarchar](255) NULL,
	[Tax Code] [nvarchar](255) NULL,
	[Tax Code1] [nvarchar](255) NULL,
	[Tax Code2] [nvarchar](255) NULL,
	[Tax Code3] [nvarchar](255) NULL,
	[WBS element] [nvarchar](255) NULL,
	[NL TYPE] [nvarchar](255) NULL,
	[Trading partner] [nvarchar](255) NULL,
	[Billable project (Y/N)] [nvarchar](255) NULL,
	[Posting Date] [datetime] NULL,
	[Trading partner1] [nvarchar](255) NULL,
	[Net Due Date] [datetime] NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SPS].[GAsPreliminaryMappingByCategory]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SPS].[GAsPreliminaryMappingByCategory](
	[Cost Element] [nvarchar](255) NULL,
	[Cost Element Name] [nvarchar](255) NULL,
	[Cost element descr#] [nvarchar](255) NULL,
	[Labor#non Labor] [nvarchar](255) NULL,
	[CategorieI ] [nvarchar](255) NULL,
	[Categorie II] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SPS].[ProfitCenterMasterData]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SPS].[ProfitCenterMasterData](
	[Profit Center] [nvarchar](255) NULL,
	[Valid To] [datetime] NULL,
	[Controlling Area] [nvarchar](255) NULL,
	[Valid From] [datetime] NULL,
	[Entered On] [datetime] NULL,
	[Created By] [nvarchar](255) NULL,
	[Field name of CO-PA characteristic] [nvarchar](255) NULL,
	[Department] [nvarchar](255) NULL,
	[Person Responsible for Profit Center] [nvarchar](255) NULL,
	[User Responsible] [nvarchar](255) NULL,
	[Currency] [nvarchar](255) NULL,
	[Successor profit center] [nvarchar](255) NULL,
	[Country Key] [nvarchar](255) NULL,
	[Title] [nvarchar](255) NULL,
	[Name 1] [nvarchar](255) NULL,
	[Name 2] [nvarchar](255) NULL,
	[Name 3] [nvarchar](255) NULL,
	[Name 4] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[District] [nvarchar](255) NULL,
	[Street] [nvarchar](255) NULL,
	[PO Box] [nvarchar](255) NULL,
	[Postal Code] [nvarchar](255) NULL,
	[P#O# Box Postal Code] [nvarchar](255) NULL,
	[Language Key] [nvarchar](255) NULL,
	[Telebox number] [nvarchar](255) NULL,
	[Telephone 1] [nvarchar](255) NULL,
	[Telephone 2] [nvarchar](255) NULL,
	[Fax Number] [nvarchar](255) NULL,
	[Teletex number] [nvarchar](255) NULL,
	[Telex number] [nvarchar](255) NULL,
	[Data line] [nvarchar](255) NULL,
	[Printer name] [nvarchar](255) NULL,
	[Hierarchy Area] [nvarchar](255) NULL,
	[Company Code] [nvarchar](255) NULL,
	[Joint venture] [nvarchar](255) NULL,
	[Recovery Indicator] [nvarchar](255) NULL,
	[Equity type] [nvarchar](255) NULL,
	[Tax Jurisdiction] [nvarchar](255) NULL,
	[Region] [nvarchar](255) NULL,
	[Usage] [nvarchar](255) NULL,
	[Application] [nvarchar](255) NULL,
	[Procedure] [nvarchar](255) NULL,
	[Logical System] [nvarchar](255) NULL,
	[Lock indicator] [nvarchar](255) NULL,
	[PrCtr Formula Planning Template] [nvarchar](255) NULL,
	[Segment] [nvarchar](255) NULL,
	[Dummy function in length 1] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[Long Text] [nvarchar](255) NULL,
	[Profit center short text for matchcode] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SPS].[RApostingsPB]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SPS].[RApostingsPB](
	[Company Code] [nvarchar](255) NULL,
	[Fiscal Year] [nvarchar](255) NULL,
	[Posting period] [nvarchar](255) NULL,
	[G/L Account] [nvarchar](255) NULL,
	[Processed Database Rows] [float] NULL,
	[Document Currency Value] [float] NULL,
	[Document Currency Key] [nvarchar](255) NULL,
	[WBS Element] [nvarchar](255) NULL,
	[Document Number] [nvarchar](255) NULL,
	[Text] [nvarchar](255) NULL,
	[BU] [nvarchar](255) NULL,
	[Profit Center] [nvarchar](255) NULL,
	[FilePath] [nvarchar](255) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [VER].[CollabVeranoGM]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [VER].[CollabVeranoGM](
	[HierarchyPathID] [nvarchar](255) NULL,
	[CostObjectID] [nvarchar](255) NULL,
	[CostObjectName] [nvarchar](255) NULL,
	[OriginalGrossMargin] [nvarchar](255) NULL,
	[ActualGrossMargin] [nvarchar](255) NULL,
	[EACCostMargin] [nvarchar](255) NULL,
	[ClientPostedHours] [nvarchar](255) NULL,
	[ClientPostedCost] [nvarchar](255) NULL,
	[CostObjectHierarchyLevel] [nvarchar](255) NULL,
	[ProjectStartDate] [nvarchar](255) NULL,
	[ProjectEndDate] [nvarchar](255) NULL,
	[TimePeriod] [nvarchar](20) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [VER].[lookup_collab_verano_asp]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [VER].[lookup_collab_verano_asp](
	[Collab_number] [varchar](250) NULL,
	[Collab_name] [varchar](250) NULL,
	[Verano_number] [varchar](250) NULL,
	[Verano_name] [varchar](250) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [VER].[OracleProjectData]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [VER].[OracleProjectData](
	[PathID] [nvarchar](500) NULL,
	[CostObjectName] [nvarchar](500) NULL,
	[LineofBusiness] [nvarchar](500) NULL,
	[BusinessUnit] [nvarchar](500) NULL,
	[ProjectManager] [nvarchar](500) NULL,
	[DesignatedProjectExecutive] [nvarchar](500) NULL,
	[ManagerofProjects] [nvarchar](500) NULL,
	[Client] [nvarchar](500) NULL,
	[ContractType] [nvarchar](500) NULL,
	[Market] [nvarchar](500) NULL,
	[PerformanceUnit] [nvarchar](500) NULL,
	[ServiceType] [nvarchar](500) NULL,
	[ProjectCostLead] [nvarchar](500) NULL,
	[OracleStatusCode] [nvarchar](500) NULL,
	[ProjectAccountant] [nvarchar](500) NULL,
	[OracleCreateDate] [nvarchar](500) NULL,
	[AllianceCode] [nvarchar](500) NULL,
	[Submarket] [nvarchar](500) NULL,
	[LeadOffice] [nvarchar](500) NULL,
	[UmbrellaCode] [nvarchar](500) NULL,
	[ProjectServiceTypeID] [nvarchar](500) NULL,
	[ECRProject] [nvarchar](500) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [VER].[PSR]    Script Date: 02/08/2024 08:01:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [VER].[PSR](
	[HierarchyPathID] [nvarchar](250) NULL,
	[ReportGroupingName] [nvarchar](250) NULL,
	[Name] [nvarchar](250) NULL,
	[JEGPortfolioBudgetClientCostCPI] [nvarchar](250) NULL,
	[RevProdHours] [nvarchar](250) NULL,
	[CBHoursJTD] [nvarchar](250) NULL,
	[CBHoursCost] [nvarchar](250) NULL,
	[RollupActualUnits] [nvarchar](250) NULL,
	[EarnedHours] [nvarchar](250) NULL,
	[CBCost] [nvarchar](250) NULL,
	[RollupActuals] [nvarchar](250) NULL,
	[EACCost] [nvarchar](250) NULL,
	[EJTDC] [nvarchar](250) NULL,
	[EACHours] [nvarchar](250) NULL,
	[TimePeriod] [nvarchar](20) NULL,
	[insert_date] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [DS].[collab_area] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_cache_ad_users] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_delegation] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_discipline] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_enumeration] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_kpi_frequency] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_privilege] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_profile_privilege] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_program_sector] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_project] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_project_contractor_work_dimension] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_project_details] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_project_phase] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_project_sub_contractor_work_dimension] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_user_cache] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_user_project] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[collab_work_order] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[contractor_management_contract] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[contractor_management_contractor] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[contractor_management_contractor_contract] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[contractor_management_project_contractor_work_dimension] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[contractor_management_project_sub_contractor_work_dimension] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[contractor_management_sub_contractor] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[contractor_management_vendor] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_attachment] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_audit_and_evaluation] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_comment] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_contract_management] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_contractor_hse_supervisor_ratio] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_enumeration] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_flyway_schema_history] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_health_management] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_lagging_indicators] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_management_and_leadership] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_monitoring_and_inspection] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_reward_recognition] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_safety_performance] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_site_presence] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_task_planning] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[csp_training_management] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_association_validation_status] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_certificate] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_construction_equipment] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_construction_equipment_certificate] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_construction_equipment_employee] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_construction_equipment_inspection] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_construction_equipment_project] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_construction_equipment_warning] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_contract] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_contractor_contract] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_contractor_sub_contractor] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_contractor_sub_contractor_jobs] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_country] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_delivery] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_department] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_employee] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_employee_area] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_employee_behavior] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_employee_certificate] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_employee_project] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_employee_training] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_enumeration] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_inspections] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_procured_equipment] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_scan_history] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_sub_equipment] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_sub_equipment_handover] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_task_history] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_training] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_warning] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[jpass_warning_type] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_app_users] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_business_unit] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_client] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_discipline] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_enumeration] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_program] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_project] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_project_area] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_project_discipline_work_dimension] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_project_phase] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_project_platform] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_project_system] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_sector] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_user_project] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_work_location] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_work_location_work_order] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[project_management_work_order] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_activity] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_activity_finding_report] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_activity_planning] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_activity_result] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_activity_trans] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_activity_type] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_app_user] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_cache_ad_user] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_capa] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_css_info] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_enumeration] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_planning] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_project] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_project_detail] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_project_history] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[qa_user_cache] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [DS].[user_management_ad_user] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [ERM].[po_mar] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [ERM].[po_mar_history] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [ERM].[po_tracks] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [ERM].[po_tracks_history] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [HSE].[LOOKUP_COLLAB_HSE] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [HSE].[NEFS_Reporting] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [HSE].[NEFS_Reporting_backup] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [HSE].[SOR] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [HSE].[StatisticInputMonth] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [HSE].[SubEvent] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [HSE].[Training] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[collab_app_user] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[collab_cache_ad_users] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[collab_client] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[collab_enumeration] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[collab_project] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[collab_user_cache] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[ErrorTrack] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[HSE_Monitoring_History] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[hse2_hse] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[hse2_hse_kpi] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[hse2_hse_top_three] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[p6_schedule] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[p6_schedule_level_activity] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[p6_schedule_wbs] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[project_details] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[QA_Monitoring_History] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[qa2_qa_audits] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[qa2_qa_global_pin] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[qa2_qa_global_pin_detail] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[qa2_qa_pass_gate] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[qa2_qa_surveys] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[Timesheet_Monitoring_History] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[timesheet2_activity] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[timesheet2_task] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[timesheet2_timesheet] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[v_HR_TIMESHEET] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[v_HR_TIMESHEET] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[v_HR_TIMESHEET_ERROR] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[ver1_cash_work_order] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[ver2_cash_gross_margin] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[ver2_work_order] ADD  DEFAULT ('FALSE') FOR [is_overall_work_order]
GO
ALTER TABLE [LogBoomi].[ver2_work_order] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[ver2_work_order_period] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[ver3_cost] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[ver3_parent_kpi_cost] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[ver3_professional_service] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[ver3_professional_service_discipline] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[ver4_cost_cpi] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[Verano_Monitoring_History] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[Verano_Monitoring_History_back] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[Verano_Monitoring_History_prod] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vHSE2Collab1] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vHSE2Collab1] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vHSE2Collab2] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vHSE2Collab2] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vP62Collab1] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vP62Collab1] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vP62Collab2] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vP62Collab2] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vQaaudits] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vQaaudits] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vQaaudits_tpr] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vQaaudits_tpr] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vQaglobalpin] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vQaglobalpin] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vQapassgate] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vQapassgate] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vQasurvey] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vQasurvey] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vVer2Collab1] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vVer2Collab1] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vVer2Collab2] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vVer2Collab2] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vVer2Collab3] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vVer2Collab3] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [LogBoomi].[vVer2Collab4] ADD  DEFAULT (getdate()) FOR [Batch_Date]
GO
ALTER TABLE [LogBoomi].[vVer2Collab4] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [MASTER].[lookup_project] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [MASTER].[lookup_project_backup] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [MASTER].[lookup_project_collab_pc] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [MASTER].[lookup_project_kenza20240109] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [MASTER].[PROJECT] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[ACTIVITY] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[ACTIVITYCODE] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[ACTIVITYCODEASSIGNMENT] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[ACTIVITYSPREAD] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[BASELINE] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[CALENDAR] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[PROJECT] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[PROJECTCODEASSIGNMENT] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[RELATIONSHIP] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[RESOURCES] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[WBS] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [P6].[WBSHIERARCHY] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PARAM].[PARAM_UTLITY] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[billing_periods] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[change_events] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[commitments_subcontracts_work_order] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[company_vendor] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[ContractPayment] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[correspondance] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[delay_log_types] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[meetings] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[project_insurrance] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[ProjectRoles] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[projects] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[requisitions] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[variation] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [PROCORE].[weather_conditions] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ACDOCA] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ACDOCA_2023] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ACDOCA_2024] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ACDOCA_TEST] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[AFVC] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[AUFK] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CATSCO] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CATSDB] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CATSDB_2020] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CATSDB_2021] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CATSDB_2022] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CATSDB_2023] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CATSDB_2024] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CATSDB_TMP] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CATSPS] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CEPC] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CEPCT] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CJI3] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CJI3_TMP] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CSKS] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[CSKT] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[DD03L] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[DD04T] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[EKKN] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[EKPO] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[GET_ZHR_T_COSTR_JEIN] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[HRDB] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[HRP1000] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[HRP1001] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[KNA1] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PA0000] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PA0001] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PA0002] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PA0007] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PA0016] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PA0041] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PA0105] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PA9001] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PLANNING_FORECAST] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PRHI] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PROJ] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PRPS] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[PRPS_bak] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[SETHEADER] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[SETLEAF] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[SETNODE] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[SKA1] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[SKAT] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[SKB1] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[T528T] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[T547S] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[TCURR] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[test_cost_proj] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[TJ02T] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZCOST] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZCOST_bak] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZCOST_TMP] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZFI_LBR] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZFI_LBR_CAR] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZFI_LBR_FI] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZHR_ABS_BALANCES] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZHR_JOB_ACT] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZHR_JOB_RATE] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZHR_T_COS_REV_F] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZHR_T_COSTR_JEEA] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZHR_T_COSTR_JESA] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZHR_T_COSTR_JESE] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZHR_T_COSTR_JETM] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZHR_T_COSTR_JEUS] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZHR_T_COSTR_JEWA] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZNL_COEF] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZREV] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SAP].[ZREV_TMP] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SPS].[CostCenterMapping] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SPS].[ExtractionCostCenters] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SPS].[ExtractionCostPB] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SPS].[ExtractionCostPB_new] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SPS].[ExtractionGLPB] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SPS].[GAsPreliminaryMappingByCategory] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SPS].[ProfitCenterMasterData] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [SPS].[RApostingsPB] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [VER].[CollabVeranoGM] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [VER].[lookup_collab_verano_asp] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [VER].[OracleProjectData] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
ALTER TABLE [VER].[PSR] ADD  DEFAULT (getdate()) FOR [insert_date]
GO
/****** Object:  StoredProcedure [dbo].[usp_data_flow_task]    Script Date: 02/08/2024 08:01:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--data flow task 
-- Create the stored procedure
CREATE PROCEDURE [dbo].[usp_data_flow_task]
AS
BEGIN
    -- Ensure the target table is empty before inserting new data
    TRUNCATE TABLE v_SOR_Extended20240719;
    
    -- Insert data from the source table to the destination table
    INSERT INTO v_SOR_Extended20240719
    SELECT *
    FROM STG.HSR.SOR;
END;

GO
/****** Object:  StoredProcedure [dbo].[usp_main_STG_HSE_PACKAGE]    Script Date: 02/08/2024 08:01:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- procedures orchistration

CREATE PROCEDURE [dbo].[usp_main_STG_HSE_PACKAGE]
AS
BEGIN
    -- Start a transaction if you want to ensure atomicity
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Execute the first procedure
        EXEC usp_data_flow_task;

        -- Execute the second procedure
        EXEC usp_MergeProjectData;

        -- Commit the transaction if both procedures succeed
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if any procedure fails
        ROLLBACK TRANSACTION;

        -- Handle the error or rethrow it
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_MergeProjectData]    Script Date: 02/08/2024 08:01:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- merge project

CREATE PROCEDURE [dbo].[usp_MergeProjectData]
AS
BEGIN
    -- Common Table Expression for project data
    WITH proj AS (
        SELECT DISTINCT [Project]
        FROM [STG].[HSE].[SOR]
        UNION
        SELECT DISTINCT [Projectvalue]
        FROM [STG].[HSE].[StatisticInputMonth]
        UNION
        SELECT DISTINCT Projectvalue
        FROM [STG].[HSE].[SubEvent]
        UNION
        SELECT DISTINCT Projectvalue
        FROM [STG].[HSE].[Training]
    ),
    projlist AS (
        SELECT DISTINCT
            CASE 
                WHEN CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) > 0 
                THEN SUBSTRING(Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1, CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) - CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) - 1) 
                ELSE NULL 
            END AS project_number
        FROM proj
    )
    
    -- MERGE statement to update STG.MASTER.PROJECT table
    MERGE STG.MASTER.PROJECT AS T
    USING (
        SELECT LTRIM(RTRIM(project_number)) AS project_number
        FROM projlist
        WHERE project_number IS NOT NULL
    ) AS S
    ON T.project_number = S.project_number
    WHEN MATCHED AND ISNULL(T.hse_project_id, '') <> ISNULL(S.project_number, '')
        THEN UPDATE SET T.hse_project_id = S.project_number 
    WHEN NOT MATCHED BY TARGET
        THEN INSERT (project_number, hse_project_id)
        VALUES (S.project_number, S.project_number)
    WHEN NOT MATCHED BY SOURCE
        THEN UPDATE SET hse_project_id = NULL;
END;
GO
USE [master]
GO
ALTER DATABASE [STG] SET  READ_WRITE 
GO
