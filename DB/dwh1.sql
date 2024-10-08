USE [master]
GO
/****** Object:  Database [DWH]    Script Date: 02/08/2024 07:54:08 ******/
CREATE DATABASE [DWH]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DWH', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DWH.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DWH_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DWH_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DWH] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DWH].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DWH] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DWH] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DWH] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DWH] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DWH] SET ARITHABORT OFF 
GO
ALTER DATABASE [DWH] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DWH] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DWH] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DWH] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DWH] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DWH] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DWH] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DWH] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DWH] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DWH] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DWH] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DWH] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DWH] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DWH] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DWH] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DWH] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DWH] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DWH] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DWH] SET  MULTI_USER 
GO
ALTER DATABASE [DWH] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DWH] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DWH] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DWH] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DWH] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DWH] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [DWH] SET QUERY_STORE = ON
GO
ALTER DATABASE [DWH] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DWH]
GO
/****** Object:  Schema [DIM]    Script Date: 02/08/2024 07:54:08 ******/
CREATE SCHEMA [DIM]
GO
/****** Object:  Schema [FACT]    Script Date: 02/08/2024 07:54:08 ******/
CREATE SCHEMA [FACT]
GO
/****** Object:  Schema [mapping]    Script Date: 02/08/2024 07:54:08 ******/
CREATE SCHEMA [mapping]
GO
/****** Object:  Table [DIM].[D_AccOrganization]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_AccOrganization](
	[AccOrganizationSK] [int] IDENTITY(1,1) NOT NULL,
	[AccOrganization] [nvarchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Activity]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Activity](
	[ActivitySK] [int] IDENTITY(1,1) NOT NULL,
	[ActivityID] [int] NULL,
	[ActivityResult] [nvarchar](250) NULL,
	[ActivityResultDesc] [nvarchar](250) NULL,
	[ActivityStatus] [nvarchar](250) NULL,
	[ActivityComment] [nvarchar](2000) NULL,
	[ActivityCategory] [nvarchar](250) NULL,
	[ActivitySubcategory] [nvarchar](250) NULL,
	[activityDiscipline] [nvarchar](250) NULL,
	[activityDisciplineCode] [nvarchar](250) NULL,
	[ActivityProgress] [nvarchar](250) NULL,
	[ReportFindingStatus] [nvarchar](250) NULL,
	[ActivityPreDraft] [nvarchar](250) NULL,
	[ActivityToDelete] [nvarchar](250) NULL,
	[ActivityCreator] [nvarchar](250) NULL,
	[ActivityExtraSource] [nvarchar](250) NULL,
	[ActivityResponsible] [nvarchar](250) NULL,
	[ActivityCreationDate] [datetime] NULL,
	[ActivityCompletedDate] [datetime] NULL,
	[ActivityConductedDate] [datetime] NULL,
	[ActivityPlannedDate] [datetime] NULL,
	[ActivityUpdateDate] [datetime] NULL,
	[ActivityRescheduledDate] [datetime] NULL,
	[ActivityCanceledDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ActivityAnyRaisedCapa] [nvarchar](10) NULL,
	[ActivitySourceId] [nvarchar](20) NULL,
	[ActivityType] [nvarchar](250) NULL,
	[ActivityPlannedConductedDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ActivityHierarchy]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ActivityHierarchy](
	[ActivityHierarchySK] [int] IDENTITY(1,1) NOT NULL,
	[ActivityHierarchyID] [nvarchar](250) NULL,
	[ActivityHierarchyObjectID] [nvarchar](250) NULL,
	[ActivityStatus] [nvarchar](250) NULL,
	[ActivityName] [nvarchar](500) NULL,
	[ActivityType] [nvarchar](250) NULL,
	[gzeroTwoSteps] [nvarchar](250) NULL,
	[gtwelveSupplierSubs] [nvarchar](250) NULL,
	[gsixteenDiscipline] [nvarchar](250) NULL,
	[geighteenWarnActIdentifier] [nvarchar](250) NULL,
	[geighteenEarlyWarning] [nvarchar](200) NULL,
	[PrimaryResourceName] [nvarchar](500) NULL,
	[gTenOcpfieldMilestone] [nvarchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ActivityStatus]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ActivityStatus](
	[ActivityStatusSK] [int] IDENTITY(1,1) NOT NULL,
	[ActivityStatusCode] [nvarchar](50) NULL,
	[ActivityStatusLabel] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ActivityType]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ActivityType](
	[ActivityTypeSK] [int] IDENTITY(1,1) NOT NULL,
	[ActivityType] [nvarchar](50) NULL,
	[ActivityCategory] [nvarchar](250) NULL,
	[ActivitySubCategory] [nvarchar](250) NULL,
	[ActivityDiscipline] [nvarchar](250) NULL,
	[ActivityProgress] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Attachment]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Attachment](
	[AttachmentSK] [int] IDENTITY(1,1) NOT NULL,
	[AttachmentID] [nvarchar](250) NULL,
	[AttachmentURL] [nvarchar](250) NULL,
	[AttachmentFileName] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_BankGuarantee]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_BankGuarantee](
	[BGSK] [int] IDENTITY(1,1) NOT NULL,
	[BGID] [nvarchar](250) NULL,
	[BKType] [nvarchar](500) NULL,
	[BKMilestone] [nvarchar](500) NULL,
	[BKDescription] [nvarchar](max) NULL,
	[BKPositionCorresp] [nvarchar](500) NULL,
	[BKTitle] [nvarchar](500) NULL,
	[BKProvider] [nvarchar](max) NULL,
	[BKContractor] [nvarchar](500) NULL,
	[BKCommitmentNumber] [nvarchar](500) NULL,
	[BKReference] [nvarchar](500) NULL,
	[BKCurrency] [nvarchar](500) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Behavior]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Behavior](
	[BehaviorSK] [int] IDENTITY(1,1) NOT NULL,
	[BehaviorID] [int] NULL,
	[BehaviorReqAction] [nvarchar](250) NULL,
	[BehaviorDescription] [nvarchar](250) NULL,
	[BehaviorLabel] [nvarchar](250) NULL,
	[BehaviorType] [nvarchar](250) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_BehaviorType]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_BehaviorType](
	[BehaviorTypeSK] [int] IDENTITY(1,1) NOT NULL,
	[BehaviorTypeID] [nvarchar](250) NULL,
	[BehaviorLabelID] [nvarchar](250) NULL,
	[BehaviorType] [nvarchar](250) NULL,
	[BehaviorLabel] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_BuSector]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_BuSector](
	[BuSectorSK] [int] IDENTITY(1,1) NOT NULL,
	[BuLabel] [nvarchar](100) NULL,
	[Sector] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_CacheAdUsers]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_CacheAdUsers](
	[CacheAdUserSK] [int] IDENTITY(1,1) NOT NULL,
	[CacheAdUserID] [char](50) NULL,
	[DisplayName] [nvarchar](250) NULL,
	[LastName] [nvarchar](250) NULL,
	[FirstName] [nvarchar](250) NULL,
	[FullName] [nvarchar](250) NULL,
	[isDeleted] [nvarchar](10) NULL,
	[isFrozen] [nvarchar](10) NULL,
	[MobilePhone] [nvarchar](100) NULL,
	[Email] [nvarchar](250) NULL,
	[SourceSystem] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Capa]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Capa](
	[CapaSK] [int] IDENTITY(1,1) NOT NULL,
	[CapaID] [int] NULL,
	[CapaNumber] [nvarchar](50) NULL,
	[CapaComment] [nvarchar](2000) NULL,
	[CapaRootCause] [nvarchar](250) NULL,
	[CapaRootCauseDesc] [nvarchar](500) NULL,
	[NatureOfFinding1] [nvarchar](500) NULL,
	[NatureOfFinding2] [nvarchar](500) NULL,
	[CapaCreationDate] [datetime] NULL,
	[CapaUpdateDate] [datetime] NULL,
	[CapaClosedDate] [datetime] NULL,
	[CapaIssueDate] [datetime] NULL,
	[CapaPlannedImplementation] [datetime] NULL,
	[CapaStatus] [nvarchar](50) NULL,
	[CapaOverdueRating] [nvarchar](100) NULL,
	[CapaRiskLevel] [nvarchar](100) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CapaSourceDescription] [nvarchar](500) NULL,
	[CapaFindingDescription] [nvarchar](500) NULL,
	[CapaActionDescription] [nvarchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_CapaStatus]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_CapaStatus](
	[CapaStatusSK] [int] IDENTITY(1,1) NOT NULL,
	[CapaStatusCode] [nvarchar](50) NULL,
	[CapaStatus] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Certificate]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Certificate](
	[CertificateSK] [int] IDENTITY(1,1) NOT NULL,
	[CertificateID] [int] NULL,
	[CertificateTitle] [nvarchar](250) NULL,
	[CertificateDescription] [nvarchar](500) NULL,
	[CertificateConfidential] [nvarchar](250) NULL,
	[CertificateMedical] [nvarchar](250) NULL,
	[CertificateTypeLabel] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ChangeOrderRequest]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ChangeOrderRequest](
	[CORSK] [int] IDENTITY(1,1) NOT NULL,
	[CORID] [nvarchar](250) NULL,
	[CORTitle] [nvarchar](500) NULL,
	[COPTitle] [nvarchar](500) NULL,
	[CORPotAcrNumber] [nvarchar](250) NULL,
	[CORAcrNumber] [nvarchar](250) NULL,
	[COPAcrNumber] [nvarchar](250) NULL,
	[COTiers] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ChangeRequest]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ChangeRequest](
	[CRSK] [int] IDENTITY(1,1) NOT NULL,
	[CRID] [varchar](250) NULL,
	[CRPosCorresp] [varchar](250) NULL,
	[CRTitle] [varchar](250) NULL,
	[CRDescription] [varchar](max) NULL,
	[CRCommitmentNumber] [nvarchar](500) NULL,
	[CRChangeJustif] [nvarchar](max) NULL,
	[Currency] [nvarchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Company]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Company](
	[CompanySK] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [nvarchar](100) NULL,
	[CompanyName] [nvarchar](100) NULL,
	[CompanyType] [nvarchar](100) NULL,
	[CreationDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ConstructionEquipement]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ConstructionEquipement](
	[EquipementSK] [int] IDENTITY(1,1) NOT NULL,
	[EquipementID] [int] NULL,
	[EquipementName] [nvarchar](250) NULL,
	[EquipementBrand] [nvarchar](250) NULL,
	[EquipementSerialNumber] [nvarchar](250) NULL,
	[EquipementTypeLabel] [nvarchar](250) NULL,
	[EquipementType] [nvarchar](250) NULL,
	[EquipementMatriculation] [nvarchar](250) NULL,
	[EquipementLifting] [nvarchar](250) NULL,
	[EquipementMoreInfo] [nvarchar](250) NULL,
	[EquipementPhoto] [nvarchar](250) NULL,
	[EquipementQrCode] [nvarchar](250) NULL,
	[EquipementCreationDate] [datetime] NULL,
	[EquipementUpdateDate] [datetime] NULL,
	[EquipementLongitude] [nvarchar](250) NULL,
	[EquipementLatitude] [nvarchar](250) NULL,
	[EquipementCompany] [nvarchar](250) NULL,
	[EquipementSubcontractor] [nvarchar](250) NULL,
	[EquipementLinkedAllContracts] [nvarchar](250) NULL,
	[EquipementConstructionName] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Contract]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Contract](
	[ContractSK] [int] IDENTITY(1,1) NOT NULL,
	[ContractID] [int] NULL,
	[ContractNumber] [nvarchar](250) NULL,
	[ContractDescription] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_CorrespDetail]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_CorrespDetail](
	[CorrespSK] [int] IDENTITY(1,1) NOT NULL,
	[CorrespID] [nvarchar](250) NULL,
	[CommitmentNumber] [nvarchar](500) NULL,
	[CorrespPosition] [nvarchar](250) NULL,
	[CorrespStatus] [nvarchar](250) NULL,
	[CorrespTitle] [nvarchar](250) NULL,
	[CorrespUnformPosition] [nvarchar](250) NULL,
	[CorrespDescription] [nvarchar](max) NULL,
	[isPrivate] [nvarchar](250) NULL,
	[CorrespDiscipline] [nvarchar](250) NULL,
	[CorrespArea] [nvarchar](250) NULL,
	[CorrespQuestionBox] [nvarchar](max) NULL,
	[CorrespImportance] [nvarchar](250) NULL,
	[CorrespReplierName] [nvarchar](250) NULL,
	[CorrespContractor] [nvarchar](250) NULL,
	[CorrespComment] [nvarchar](max) NULL,
	[CorrespAnswer] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_CorrespType]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_CorrespType](
	[CorrespTypeSK] [int] IDENTITY(1,1) NOT NULL,
	[CorrespTypeID] [nvarchar](250) NULL,
	[CorrespType] [nvarchar](250) NULL,
	[CorrespTypeName] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_CostCalc]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_CostCalc](
	[CostCalcSK] [int] IDENTITY(1,1) NOT NULL,
	[CostCalcUom] [nvarchar](250) NULL,
	[CostCalcStrategy] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_CostCenter]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_CostCenter](
	[CostCenterID] [int] IDENTITY(1,1) NOT NULL,
	[ProfitCenterID] [int] NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL,
	[Name] [nvarchar](50) NULL,
	[CostCenterOwner] [nvarchar](50) NULL,
	[HierarchyArea] [nvarchar](50) NULL,
	[Description] [nvarchar](255) NULL,
	[CostCenterCode] [nvarchar](20) NULL,
	[CompanyCode] [nvarchar](20) NULL,
	[BusinessArea] [nvarchar](20) NULL,
	[Currency] [nvarchar](5) NULL,
	[PLSubCategory] [nvarchar](50) NULL,
	[PLCategory] [nvarchar](50) NULL,
	[ProfitCenter] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_CostCode]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_CostCode](
	[CostCodeSK] [int] IDENTITY(1,1) NOT NULL,
	[CostCodeID] [nvarchar](250) NULL,
	[CostCodeName] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_CostElement]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_CostElement](
	[CostElementID] [int] IDENTITY(1,1) NOT NULL,
	[CostElementCode] [nvarchar](255) NULL,
	[CostElementDescription] [nvarchar](1) NULL,
	[LaborNonLabor] [nvarchar](20) NULL,
	[CategorieI] [nvarchar](255) NULL,
	[CategorieII] [nvarchar](255) NULL,
	[CostElementName] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_CostObject]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_CostObject](
	[CostObjectSK] [int] IDENTITY(1,1) NOT NULL,
	[CostObjectID] [nvarchar](250) NULL,
	[CostObjectName] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Country]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Country](
	[Name] [varchar](50) NULL,
	[Code] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_CssInfos]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_CssInfos](
	[CssInfoSK] [int] IDENTITY(1,1) NOT NULL,
	[CssInfo] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Date]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Date](
	[DimDate_ID] [varchar](20) NULL,
	[DimDate_Date] [date] NULL,
	[DimDate_Day] [varchar](20) NULL,
	[DimDate_DayOfWeek] [varchar](20) NULL,
	[DimDate_DayOfYear] [varchar](20) NULL,
	[DimDate_WeekOfYear] [varchar](20) NULL,
	[DimDate_WeekOfMonth] [varchar](20) NULL,
	[DimDate_Month] [varchar](20) NULL,
	[DimDate_MonthName] [varchar](20) NULL,
	[DimDate_Quarter] [varchar](20) NULL,
	[DimDate_Year] [varchar](20) NULL,
	[DimDate_FiscalMonth] [int] NULL,
	[DimDate_FiscalYear] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_EmpComments]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_EmpComments](
	[EmpCommentSK] [int] IDENTITY(1,1) NOT NULL,
	[EmpCommentID] [int] NULL,
	[ValidationComment] [nvarchar](250) NULL,
	[Comment] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Employee]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Employee](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[EMP_SAP_ID] [nvarchar](8) NULL,
	[Nationality] [nvarchar](3) NULL,
	[Gender] [nvarchar](1) NULL,
	[DateOfBirth] [nvarchar](8) NULL,
	[ContractType] [nvarchar](2) NULL,
	[SeniorityDate] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_EmployeeAssignment]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_EmployeeAssignment](
	[EmployeeAssignmentID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NULL,
	[OrgaStructureID] [int] NULL,
	[Site] [nvarchar](4) NULL,
	[Structure] [varchar](1) NULL,
	[CostCenter] [nvarchar](10) NULL,
	[Poste] [nvarchar](8) NULL,
	[OrgaUnit] [nvarchar](8) NULL,
	[BeginDate] [nvarchar](8) NULL,
	[EndDate] [nvarchar](8) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_EmployeeDetails]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_EmployeeDetails](
	[EmployeeSK] [int] IDENTITY(1,1) NOT NULL,
	[EmpID] [int] NULL,
	[EmpUniqueRef] [nvarchar](200) NULL,
	[EmpType] [nvarchar](200) NULL,
	[EmpCompanyName] [nvarchar](200) NULL,
	[EmpSubContractor] [nvarchar](200) NULL,
	[EmpJob] [nvarchar](200) NULL,
	[EmpDepartment] [nvarchar](200) NULL,
	[EmpCountry] [nvarchar](200) NULL,
	[EmpCity] [nvarchar](200) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Enumeration]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Enumeration](
	[EnumSK] [int] IDENTITY(1,1) NOT NULL,
	[enumID] [nvarchar](250) NULL,
	[ID] [nvarchar](250) NULL,
	[Type] [nvarchar](250) NULL,
	[Code] [nvarchar](250) NULL,
	[Label] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_EventType]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_EventType](
	[EventTypeSK] [int] IDENTITY(1,1) NOT NULL,
	[EventType] [nvarchar](250) NULL,
	[EventScope] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ExchangeRate]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ExchangeRate](
	[Période] [nvarchar](255) NULL,
	[Devise] [nvarchar](255) NULL,
	[Taux de conversion] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_FindingLevel]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_FindingLevel](
	[FindingLevelSK] [int] IDENTITY(1,1) NOT NULL,
	[FindingLevel] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_FindingReport]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_FindingReport](
	[FindingReportSK] [int] IDENTITY(1,1) NOT NULL,
	[FindingReportID] [nvarchar](100) NULL,
	[FindingReport] [nvarchar](250) NULL,
	[FindingReportStatus] [nvarchar](250) NULL,
	[CreationDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_GLAccount]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_GLAccount](
	[GLAccountID] [int] IDENTITY(1,1) NOT NULL,
	[GLAccount] [nvarchar](20) NULL,
	[GLAccountLongText] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Inspection]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Inspection](
	[InspectionSK] [int] IDENTITY(1,1) NOT NULL,
	[InspectionID] [int] NULL,
	[InspectionName] [nvarchar](250) NULL,
	[InspectionLabel] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Insurance]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Insurance](
	[InsSK] [int] IDENTITY(1,1) NOT NULL,
	[InsID] [nvarchar](250) NULL,
	[InsPolicyNumber] [nvarchar](500) NULL,
	[InsPositionCorresp] [nvarchar](500) NULL,
	[InsCommitmentNumber] [nvarchar](500) NULL,
	[InsTitle] [nvarchar](500) NULL,
	[InsContractor] [nvarchar](500) NULL,
	[InsDescription] [nvarchar](max) NULL,
	[InsCurrency] [nvarchar](500) NULL,
	[InsCompanyProjInsurance] [nvarchar](500) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_InsuranceProvider]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_InsuranceProvider](
	[InsProviderSK] [int] IDENTITY(1,1) NOT NULL,
	[InsProviderName] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_InsuranceType]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_InsuranceType](
	[InsTypeSK] [int] IDENTITY(1,1) NOT NULL,
	[InsType] [nvarchar](250) NULL,
	[InsTypeUnified] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_OverdueRating]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_OverdueRating](
	[CapaOverdueRatingSK] [int] IDENTITY(1,1) NOT NULL,
	[CapaOverdueRatingCode] [nvarchar](50) NULL,
	[CapaOverdueRating] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_PayIssued]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_PayIssued](
	[PayIssuedSK] [int] IDENTITY(1,1) NOT NULL,
	[PayIssuedID] [nvarchar](250) NULL,
	[CheckNumber] [nvarchar](250) NULL,
	[InvoiceNumber] [nvarchar](250) NULL,
	[PaymentNumber] [nvarchar](250) NULL,
	[Notes] [nvarchar](max) NULL,
	[PaymentMethod] [nvarchar](250) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_PDN]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_PDN](
	[PDNSK] [int] IDENTITY(1,1) NOT NULL,
	[PDNID] [varchar](250) NULL,
	[PDNPosCorresp] [varchar](250) NULL,
	[PDNTitle] [varchar](250) NULL,
	[PDNCostImpact] [varchar](250) NULL,
	[PDNstatusCost] [varchar](250) NULL,
	[PDNDescription] [varchar](max) NULL,
	[PDNCommitmentNumber] [nvarchar](500) NULL,
	[PDNContractor] [nvarchar](500) NULL,
	[PDNTrade] [varchar](250) NULL,
	[PDNNameTrades] [nvarchar](500) NULL,
	[PDNChangeJustif] [nvarchar](max) NULL,
	[Currency] [nvarchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Planning]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Planning](
	[PlanningSK] [int] IDENTITY(1,1) NOT NULL,
	[PlanningID] [int] NULL,
	[PlanningStatus] [nvarchar](250) NULL,
	[PlanningActivityType] [nvarchar](250) NULL,
	[PlanningCreationDate] [datetime] NULL,
	[PlanningUpdateDate] [datetime] NULL,
	[ProjectName] [nvarchar](250) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_PlanningActivityType]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_PlanningActivityType](
	[PlanningActivityTypeSK] [int] IDENTITY(1,1) NOT NULL,
	[PlanningActivityTypeCode] [nvarchar](50) NULL,
	[PlanningActivityType] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_PlanningStatus]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_PlanningStatus](
	[PlanningStatusSK] [int] IDENTITY(1,1) NOT NULL,
	[PlanningStatusCode] [nvarchar](50) NULL,
	[PlanningStatus] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ProcContract]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ProcContract](
	[ContractSK] [int] IDENTITY(1,1) NOT NULL,
	[ContractID] [nvarchar](250) NULL,
	[ContractNumber] [nvarchar](500) NULL,
	[ContractTitle] [nvarchar](500) NULL,
	[ContractorName] [nvarchar](250) NULL,
	[AccountingMethod] [nvarchar](250) NULL,
	[CommitmentType] [nvarchar](250) NULL,
	[CompletionDate] [date] NULL,
	[ContractDate] [date] NULL,
	[ContractEstCompletionDate] [date] NULL,
	[ContractStartDate] [date] NULL,
	[ContractDescription] [nvarchar](max) NULL,
	[ContractInclusion] [nvarchar](max) NULL,
	[ContractCurrency] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ProcCorrespStatus]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ProcCorrespStatus](
	[ProcCorrespStatusSK] [int] IDENTITY(1,1) NOT NULL,
	[ProcCorrespStatus] [nvarchar](250) NULL,
	[ProcCorrespStatusType] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ProcStatus]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ProcStatus](
	[ProcStatusSK] [int] IDENTITY(1,1) NOT NULL,
	[ProcStatus] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ProcUser]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ProcUser](
	[UserSK] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](250) NULL,
	[UserLogin] [nvarchar](250) NULL,
	[UserName] [nvarchar](250) NULL,
	[UserCompanyName] [nvarchar](250) NULL,
	[UserType] [nvarchar](1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ProfitCenter]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ProfitCenter](
	[ProfitCenterID] [int] IDENTITY(1,1) NOT NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL,
	[Name] [nvarchar](50) NULL,
	[ProfitCenterLongText] [nvarchar](255) NULL,
	[ProfitCenterCode] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Project]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Project](
	[ProjectSK] [int] IDENTITY(1,1) NOT NULL,
	[ProjectNumber] [nvarchar](250) NULL,
	[QaProjectID] [int] NULL,
	[JPassProjectID] [int] NULL,
	[HSEProjectID] [nvarchar](250) NULL,
	[P6ProjectID] [int] NULL,
	[ProjectBuSectorSk] [int] NULL,
	[ProjectClassSk] [int] NULL,
	[ProjectName] [nvarchar](250) NULL,
	[ProjectCustomer] [nvarchar](250) NULL,
	[ProjectProgram] [nvarchar](250) NULL,
	[ProjectStatus] [nvarchar](250) NULL,
	[ProjectBU] [nvarchar](250) NULL,
	[ProjectSector] [nvarchar](250) NULL,
	[ProjectPhase] [nvarchar](250) NULL,
	[ProjectSize] [nvarchar](250) NULL,
	[ProjectRisk] [nvarchar](250) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[JPassStartDate] [datetime] NULL,
	[JPassForecastDate] [datetime] NULL,
	[QAProjectStatus] [nvarchar](250) NULL,
	[QAProjectScope] [nvarchar](200) NULL,
	[QAProjectLead] [nvarchar](200) NULL,
	[EnumTypeSK] [int] NULL,
	[OBSName] [nvarchar](200) NULL,
	[P6ProjectStatus] [nvarchar](200) NULL,
	[ProjStartDate] [datetime] NULL,
	[ContractualEndDate] [datetime] NULL,
	[P6ForecastDate] [datetime] NULL,
	[EngineeringStartDate] [datetime] NULL,
	[EngineeringEndDate] [datetime] NULL,
	[ProcurementStartDate] [datetime] NULL,
	[ProcurementEndDate] [datetime] NULL,
	[ConstructionStartDate] [datetime] NULL,
	[ConstructionEndDate] [datetime] NULL,
	[CommissioningStartDate] [datetime] NULL,
	[CommissioningEndDate] [datetime] NULL,
	[JProjectSector] [nvarchar](250) NULL,
	[P6StartDate] [datetime] NULL,
	[ProcoreProjectID] [nvarchar](250) NULL,
	[ProcoreProjectName] [nvarchar](250) NULL,
	[TiqadSector] [nvarchar](100) NULL,
	[CollabSector] [nvarchar](100) NULL,
	[ProcoreProgramName] [nvarchar](250) NULL,
	[ProjectSAPBU] [nvarchar](10) NULL,
	[JProjectSchedulingFrequency] [nvarchar](100) NULL,
	[ProcoreBU] [nvarchar](250) NULL,
	[ProcoreSector] [nvarchar](250) NULL,
	[ProcoreServiceType] [nvarchar](250) NULL,
	[ProcoreActive] [nvarchar](250) NULL,
	[ProcoreDemo] [nvarchar](250) NULL,
	[SAPCustomer] [nvarchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[d_project_20240223]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[d_project_20240223](
	[ProjectSK] [int] IDENTITY(1,1) NOT NULL,
	[ProjectNumber] [nvarchar](250) NULL,
	[QaProjectID] [int] NULL,
	[JPassProjectID] [int] NULL,
	[HSEProjectID] [nvarchar](250) NULL,
	[P6ProjectID] [int] NULL,
	[ProjectBuSectorSk] [int] NULL,
	[ProjectClassSk] [int] NULL,
	[ProjectName] [nvarchar](250) NULL,
	[ProjectCustomer] [nvarchar](250) NULL,
	[ProjectProgram] [nvarchar](250) NULL,
	[ProjectStatus] [nvarchar](250) NULL,
	[ProjectBU] [nvarchar](250) NULL,
	[ProjectSector] [nvarchar](250) NULL,
	[ProjectPhase] [nvarchar](250) NULL,
	[ProjectSize] [nvarchar](250) NULL,
	[ProjectRisk] [nvarchar](250) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[JPassStartDate] [datetime] NULL,
	[JPassForecastDate] [datetime] NULL,
	[QAProjectStatus] [nvarchar](250) NULL,
	[QAProjectScope] [nvarchar](200) NULL,
	[QAProjectLead] [nvarchar](200) NULL,
	[EnumTypeSK] [int] NULL,
	[OBSName] [nvarchar](200) NULL,
	[P6ProjectStatus] [nvarchar](200) NULL,
	[ProjStartDate] [datetime] NULL,
	[ContractualEndDate] [datetime] NULL,
	[P6ForecastDate] [datetime] NULL,
	[EngineeringStartDate] [datetime] NULL,
	[EngineeringEndDate] [datetime] NULL,
	[ProcurementStartDate] [datetime] NULL,
	[ProcurementEndDate] [datetime] NULL,
	[ConstructionStartDate] [datetime] NULL,
	[ConstructionEndDate] [datetime] NULL,
	[CommissioningStartDate] [datetime] NULL,
	[CommissioningEndDate] [datetime] NULL,
	[JProjectSector] [nvarchar](250) NULL,
	[P6StartDate] [datetime] NULL,
	[ProcoreProjectID] [nvarchar](250) NULL,
	[ProcoreProjectName] [nvarchar](250) NULL,
	[TiqadSector] [nvarchar](100) NULL,
	[CollabSector] [nvarchar](100) NULL,
	[ProcoreProgramName] [nvarchar](250) NULL,
	[ProjectSAPBU] [nvarchar](10) NULL,
	[JProjectSchedulingFrequency] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ProjectClassif]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ProjectClassif](
	[ProjectClassSK] [int] IDENTITY(1,1) NOT NULL,
	[ProjectPhase] [nvarchar](100) NULL,
	[ProjectSize] [nvarchar](100) NULL,
	[ProjectRisk] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ProjectRole]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ProjectRole](
	[ProjectRoleSK] [int] IDENTITY(1,1) NOT NULL,
	[ProjectRole] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ProjectTasks]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ProjectTasks](
	[ProjectTaskSK] [int] IDENTITY(1,1) NOT NULL,
	[ProjectCode] [nvarchar](50) NULL,
	[ProjectLabel] [nvarchar](250) NULL,
	[TaskLabel] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ReportGrouping]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ReportGrouping](
	[ReportGroupingSK] [int] IDENTITY(1,1) NOT NULL,
	[ReportGroupingName] [nvarchar](250) NULL,
	[ReportGroupingNameDesc] [nvarchar](250) NULL,
	[ReportGroupingNameCollab] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ReportStatus]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ReportStatus](
	[ReportStatusSK] [int] IDENTITY(1,1) NOT NULL,
	[ReportStatusCode] [nvarchar](50) NULL,
	[ReportStatusLabel] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Result]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Result](
	[ResultSK] [int] IDENTITY(1,1) NOT NULL,
	[ResultCode] [nvarchar](50) NULL,
	[ResultLabel] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Risk]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Risk](
	[CapaRiskSK] [int] IDENTITY(1,1) NOT NULL,
	[CapaRiskCode] [nvarchar](50) NULL,
	[CapaRisk] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_RootCause]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_RootCause](
	[RootCauseSK] [int] IDENTITY(1,1) NOT NULL,
	[RootCauseCode] [nvarchar](100) NULL,
	[RootCause] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ScannedOpType]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ScannedOpType](
	[ScannedOpTypeSK] [int] IDENTITY(1,1) NOT NULL,
	[ScannedOpTypeID] [nvarchar](200) NULL,
	[ScannedOpType] [nvarchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_SOR]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_SOR](
	[SORSK] [int] IDENTITY(1,1) NOT NULL,
	[SORID] [int] NULL,
	[SORProject] [nvarchar](1000) NULL,
	[SORDescription] [nvarchar](max) NULL,
	[SORLocation] [nvarchar](2000) NULL,
	[SORGroupValue] [nvarchar](200) NULL,
	[SORStatut] [nvarchar](200) NULL,
	[SORCriticalRisk] [nvarchar](200) NULL,
	[SORSubjectValue] [nvarchar](200) NULL,
	[TypeValue] [nvarchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_SubContracting]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_SubContracting](
	[SubContractingSK] [int] IDENTITY(1,1) NOT NULL,
	[SubContractingID] [varchar](250) NULL,
	[SubContractingPositionCorresp] [varchar](250) NULL,
	[SubContractingTitle] [varchar](250) NULL,
	[SubContractingContractor] [nvarchar](500) NULL,
	[SubContractingName] [nvarchar](500) NULL,
	[SubContractingAddress] [nvarchar](500) NULL,
	[SubContractingEmailAddress] [nvarchar](500) NULL,
	[SubContractingCity] [nvarchar](500) NULL,
	[SubContractingCountry] [nvarchar](500) NULL,
	[SubContractingPhoneNumber] [nvarchar](500) NULL,
	[SubContractingContactName] [nvarchar](500) NULL,
	[SubContractingJobTitle] [nvarchar](500) NULL,
	[SubContractingScopeOfWork] [nvarchar](500) NULL,
	[SubContractingNB] [nvarchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_SubEvent]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_SubEvent](
	[SubEventSK] [int] IDENTITY(1,1) NOT NULL,
	[SubEventID] [int] NULL,
	[UnsafeactsValue] [nvarchar](2000) NULL,
	[UnsafeconditionsValue] [nvarchar](2000) NULL,
	[ExecutionFactorsValue] [nvarchar](2000) NULL,
	[PeopleFactorsValue] [nvarchar](2000) NULL,
	[ManagementAspectsValue] [nvarchar](2000) NULL,
	[ProgramSystemAspectsValue] [nvarchar](2000) NULL,
	[ProjectValue] [nvarchar](250) NULL,
	[Descriptionvalue] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_SubEventType]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_SubEventType](
	[SubEventTypeSK] [int] IDENTITY(1,1) NOT NULL,
	[TypeValue] [nvarchar](50) NULL,
	[SubEventValue] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Submiter]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Submiter](
	[SubmiterSK] [int] IDENTITY(1,1) NOT NULL,
	[SubmiterValue] [nvarchar](250) NULL,
	[MailValue] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_TaskHistory]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_TaskHistory](
	[TaskHistorySK] [int] IDENTITY(1,1) NOT NULL,
	[TaskHistoryID] [nvarchar](250) NULL,
	[TaskHistory] [nvarchar](250) NULL,
	[WorkArea] [nvarchar](250) NULL,
	[Detail] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Times]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Times](
	[TimesID] [int] IDENTITY(1,1) NOT NULL,
	[ID] [nvarchar](5) NULL,
	[Times] [nvarchar](55) NULL,
	[Type] [nvarchar](25) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Trainer]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Trainer](
	[TrainerSK] [int] IDENTITY(1,1) NOT NULL,
	[Trainer] [nvarchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Training]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Training](
	[TrainingSK] [int] IDENTITY(1,1) NOT NULL,
	[TrainingID] [int] NULL,
	[TrainingTitle] [nvarchar](250) NULL,
	[TrainingDescription] [nvarchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_TrainingCategory]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_TrainingCategory](
	[CategorySK] [int] IDENTITY(1,1) NOT NULL,
	[CategoryCode] [nvarchar](250) NULL,
	[CategoryLabel] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_ValidationStatus]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_ValidationStatus](
	[ValidationSK] [int] IDENTITY(1,1) NOT NULL,
	[ValidationID] [nvarchar](200) NULL,
	[ValidationStatus] [nvarchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Vendor]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Vendor](
	[VendorSK] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [nvarchar](250) NULL,
	[VendorName] [nvarchar](max) NULL,
	[VendorAbrvName] [nvarchar](250) NULL,
	[VendorCountry] [nvarchar](250) NULL,
	[VendorAddress] [nvarchar](max) NULL,
	[VendorCity] [nvarchar](250) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_Warning]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_Warning](
	[WarningSK] [int] IDENTITY(1,1) NOT NULL,
	[WarningID] [nvarchar](250) NULL,
	[WarningName] [nvarchar](250) NULL,
	[WarningType] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_WBS]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_WBS](
	[WBSID] [int] IDENTITY(1,1) NOT NULL,
	[ProfitCenterID] [int] NULL,
	[SectorID] [int] NULL,
	[LegalEntityID] [int] NULL,
	[WBSElement] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[ObjectNumber] [nvarchar](255) NULL,
	[CurrentInternalProjectNumber] [nvarchar](255) NULL,
	[CompanyCode] [nvarchar](255) NULL,
	[BusinessArea] [nvarchar](255) NULL,
	[ControllingArea] [nvarchar](255) NULL,
	[Currency] [nvarchar](255) NULL,
	[Plant] [nvarchar](255) NULL,
	[ServiceType] [nvarchar](255) NULL,
	[ContractType] [nvarchar](255) NULL,
	[ProjectType] [nvarchar](255) NULL,
	[CreationDate] [datetime] NULL,
	[Region] [nvarchar](255) NULL,
	[Geography] [nvarchar](255) NULL,
	[LobSector] [nvarchar](255) NULL,
	[CountryID] [nvarchar](255) NULL,
	[Location1] [nvarchar](255) NULL,
	[TimeKey] [time](7) NULL,
	[ONCP] [varchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_WbsHierarchy]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_WbsHierarchy](
	[WbsHierarchySK] [int] IDENTITY(1,1) NOT NULL,
	[WbsHierarchyID] [nvarchar](250) NULL,
	[WbsHierarchyName] [nvarchar](250) NULL,
	[FullPathName] [nvarchar](250) NULL,
	[ProjectNumber] [nvarchar](250) NULL,
	[ChildProjectId] [nvarchar](50) NULL,
	[ParentObjectId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [DIM].[D_WorkOrder]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DIM].[D_WorkOrder](
	[WorkOrderSK] [int] IDENTITY(1,1) NOT NULL,
	[WorkOrderNumber] [nvarchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_Activity]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_Activity](
	[ActivitySK] [int] NOT NULL,
	[ProjectSK] [int] NOT NULL,
	[ResultSK] [int] NOT NULL,
	[ActivityStatusSK] [int] NOT NULL,
	[ActivityTypeSK] [int] NOT NULL,
	[ReportStatusSK] [int] NOT NULL,
	[ActivityCreationDateKey] [int] NULL,
	[ActivityUpdateDateKey] [int] NULL,
	[ActivityPlannedDateKey] [int] NULL,
	[ActivityConductedDateKey] [int] NULL,
	[ActivityCompletedDateKey] [int] NULL,
	[ActivityRescheduledDateKey] [int] NULL,
	[ActivityCanceledDateKey] [int] NULL,
	[ActivityPlannedConductedDateKey] [int] NULL,
	[ActivityMonth] [int] NULL,
	[ActivityScore] [numeric](12, 2) NULL,
	[isPreDraft] [int] NULL,
	[isToDelete] [int] NULL,
	[HasRaisedCapa] [int] NULL,
	[FindingVeryHigh] [int] NULL,
	[FindingHigh] [int] NULL,
	[FindingMedium] [int] NULL,
	[FindingLow] [int] NULL,
	[FindingOppty] [int] NULL,
	[CssSafety] [numeric](12, 2) NULL,
	[CssScope] [numeric](12, 2) NULL,
	[CssCommunication] [numeric](12, 2) NULL,
	[CssTechServices] [numeric](12, 2) NULL,
	[CssStaffing] [numeric](12, 2) NULL,
	[CssSchedule] [numeric](12, 2) NULL,
	[CssCostEstimate] [numeric](12, 2) NULL,
	[CssFieldServices] [numeric](12, 2) NULL,
	[CssSuplyMgmt] [numeric](12, 2) NULL,
	[CssMgmtSupport] [numeric](12, 2) NULL,
	[ActivityActual] [int] NULL,
	[PlannedToDate] [int] NULL,
	[PlannedFY] [int] NULL,
	[ActivityCount] [int] NULL,
	[ActivityRaisedCapa] [int] NULL,
	[PlannedFYOverall] [int] NULL,
	[ActualsOverall] [int] NULL,
	[PlannedToDateOverall] [int] NULL,
	[ReportingDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ActivityHierarchy]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ActivityHierarchy](
	[ActivityHierarchySK] [int] NULL,
	[ProjectSK] [int] NULL,
	[WbsHierarchySK] [int] NULL,
	[PrimaryResourceObjectId] [int] NULL,
	[BaseLineStartDate] [datetime] NULL,
	[BaseLineFinishDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[FinishDate] [datetime] NULL,
	[BaseLineDuration] [numeric](17, 4) NULL,
	[RemainingDuration] [numeric](17, 4) NULL,
	[AtCompletion] [numeric](17, 4) NULL,
	[Schedulepercentcomplete] [numeric](17, 4) NULL,
	[PlannedLaborUnits] [numeric](17, 4) NULL,
	[ActualLaborUnits] [numeric](17, 4) NULL,
	[FloatPath] [numeric](17, 4) NULL,
	[FloatPathOrder] [numeric](17, 4) NULL,
	[TotalFloat] [numeric](17, 4) NULL,
	[UnitsPercentComplete] [numeric](17, 4) NULL,
	[RemainingLaborUnits] [numeric](17, 6) NULL,
	[PlannedDuration] [numeric](17, 6) NULL,
	[PlannedFinishDate] [datetime] NULL,
	[PlannedStartDate] [datetime] NULL,
	[ActualfinishDate] [datetime] NULL,
	[ActualStartDate] [datetime] NULL,
	[DataDate] [datetime] NULL,
	[ActualTotalUnits] [numeric](28, 10) NULL,
	[AtCompletionVariance] [numeric](28, 10) NULL,
	[BaselinePlannedDuration] [numeric](28, 10) NULL,
	[BaselinePlannedLaborUnits] [numeric](28, 10) NULL,
	[BudgetAtCompletion] [numeric](28, 10) NULL,
	[DurationPercentComplete] [numeric](28, 10) NULL,
	[DurationVariance] [numeric](28, 10) NULL,
	[IsCritical] [varchar](1) NULL,
	[IsLongestPath] [varchar](1) NULL,
	[IsStarred] [varchar](1) NULL,
	[PercentComplete] [numeric](28, 10) NULL,
	[PerformancePercentComplete] [numeric](28, 10) NULL,
	[ActualDuration] [numeric](28, 10) NULL,
	[RemainingFloat] [numeric](28, 10) NULL,
	[ScheduleVariance] [numeric](28, 10) NULL,
	[StartdateVariance] [numeric](28, 10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ActivityHours]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ActivityHours](
	[EmployeeID] [int] NULL,
	[TimesID] [int] NULL,
	[AWART] [nvarchar](4) NULL,
	[CATSHOURS] [numeric](4, 2) NULL,
	[EMP_SAP_ID] [nvarchar](8) NULL,
	[WorkDate] [nvarchar](8) NULL,
	[BILLABLE] [int] NULL,
	[ProjectTaskSK] [int] NULL,
	[ModifiedDate] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ActivitySpread]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ActivitySpread](
	[ActivityHierarchySK] [int] NULL,
	[ProjectSK] [int] NULL,
	[WbsHierarchySK] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ActualLaborUnits] [numeric](28, 10) NULL,
	[BaselinePlannedLaborUnits] [numeric](28, 10) NULL,
	[BaselineActualLaborUnits] [numeric](28, 10) NULL,
	[BaselineActualNonLaborUnits] [numeric](28, 10) NULL,
	[Baseline1PlannedLaborUnits] [numeric](28, 10) NULL,
	[EarnedValueLaborUnits] [numeric](28, 10) NULL,
	[EstimateAtCompletionLaborUnits] [numeric](28, 10) NULL,
	[EstimateToCompleteLaborUnits] [numeric](28, 10) NULL,
	[PlannedLaborUnits] [numeric](28, 10) NULL,
	[RemainingLaborUnits] [numeric](28, 10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ActivityUsers]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ActivityUsers](
	[CacheAdUserSK] [int] NULL,
	[ActivitySK] [int] NULL,
	[CacheAdUserType] [nvarchar](100) NULL,
	[ReportingDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_Attachement]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_Attachement](
	[SpAttachementSK] [int] IDENTITY(1,1) NOT NULL,
	[SpID] [nvarchar](50) NULL,
	[AttachementType] [nvarchar](150) NULL,
	[AttachementName] [nvarchar](2000) NULL,
	[UploadedFileName] [nvarchar](2000) NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_BankGuarantee]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_BankGuarantee](
	[BGSK] [int] NULL,
	[ProjectSK] [int] NULL,
	[CreatorSK] [int] NULL,
	[ReceiverSK] [int] NULL,
	[VendorSK] [int] NULL,
	[ContractorSK] [int] NULL,
	[BankGuarStatusSK] [nvarchar](250) NULL,
	[EffectiveDate] [datetime] NULL,
	[ExpirationDate] [datetime] NULL,
	[ClosedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[IssuedDate] [datetime] NULL,
	[BGAmount] [numeric](19, 2) NULL,
	[currency] [nvarchar](10) NULL,
	[IsPrivate] [int] NULL,
	[ContractCurrency] [nvarchar](50) NULL,
	[ConversionRate] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_BaselineProject]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_BaselineProject](
	[ProjectSK] [int] NULL,
	[ParentProjectID] [varchar](40) NULL,
	[BaselineID] [varchar](40) NULL,
	[CurrentBaselineProjectObjectID] [int] NULL,
	[MustFinishByDate] [datetime] NULL,
	[PlannedStartDate] [datetime] NULL,
	[ProjectForecastStartDate] [datetime] NULL,
	[ScheduledFinishDate] [datetime] NULL,
	[SummarizeToWbsLevel] [int] NULL,
	[BaselineName] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_Capa]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_Capa](
	[CapaSK] [int] NOT NULL,
	[ActivitySK] [int] NOT NULL,
	[RootCauseSK] [int] NOT NULL,
	[CapaStatusSK] [int] NOT NULL,
	[CapaOverdueRatingSK] [int] NOT NULL,
	[CapaRiskSK] [int] NOT NULL,
	[ProjectSK] [int] NOT NULL,
	[CapaIssueDateKey] [int] NULL,
	[CapaCreationDateKey] [int] NULL,
	[CapaClosedDateKey] [int] NULL,
	[CapaPlannedImplementationKey] [int] NULL,
	[CapaOverdueActionDelays] [int] NULL,
	[CapaCount] [int] NULL,
	[ReportingDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ChangeEvent]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ChangeEvent](
	[ChangeEventNumber] [int] NULL,
	[ChangeEventAlphNum] [varchar](50) NULL,
	[ProjectSK] [int] NULL,
	[EventTypeSK] [int] NULL,
	[CostCodeSK] [int] NULL,
	[ContractSK] [int] NULL,
	[ChangeStatusSK] [int] NULL,
	[PropContractSK] [int] NULL,
	[PropVendorSK] [int] NULL,
	[CostCalcSK] [int] NULL,
	[CreationDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[EstCostQuantity] [numeric](17, 2) NULL,
	[EstCostUnit] [numeric](17, 2) NULL,
	[EstCostAmount] [numeric](17, 2) NULL,
	[ContractCurrency] [nvarchar](50) NULL,
	[ConversionRate] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ChangeRequest]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ChangeRequest](
	[CRSK] [int] NULL,
	[ProjectSK] [int] NULL,
	[ProcCorrespStatusSK] [int] NULL,
	[SK_UserAssignee] [int] NULL,
	[SK_UserDistribution] [int] NULL,
	[VendorSK] [int] NULL,
	[ContractorSK] [int] NULL,
	[ContractSK] [int] NULL,
	[ClosedDate] [datetime] NULL,
	[CreationDate] [datetime] NULL,
	[IssuedDate] [datetime] NULL,
	[ValueCost] [numeric](17, 3) NULL,
	[HasHSEImpact] [int] NULL,
	[IsActiveTrades] [int] NULL,
	[ContractCurrency] [nvarchar](50) NULL,
	[ConversionRate] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_CompanyEquipement]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_CompanyEquipement](
	[EquipementSK] [int] NULL,
	[EnumTypeSK] [int] NULL,
	[CompanySK] [int] NULL,
	[SubContractorSK] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_CorrespInsigth]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_CorrespInsigth](
	[CorrespTypeID] [varchar](250) NOT NULL,
	[ProjectSK] [int] NOT NULL,
	[CorrespTypeSK] [int] NOT NULL,
	[VendorSK] [int] NOT NULL,
	[ContractSK] [int] NOT NULL,
	[ContractorSK] [int] NOT NULL,
	[ProccorrespStatusSK] [int] NOT NULL,
	[CreatedAtDate] [datetime] NULL,
	[ClosedAtDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_Correspondance]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_Correspondance](
	[CorrespSK] [int] NULL,
	[ProjectSK] [int] NULL,
	[CorrespTypeSK] [int] NULL,
	[ReceiverSK] [int] NULL,
	[VendorSK] [int] NULL,
	[CreatorSK] [int] NULL,
	[ContractorSK] [int] NULL,
	[ContractSK] [int] NULL,
	[ClosedDate] [datetime] NULL,
	[CreationDate] [datetime] NULL,
	[IssuedDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[CorrespCount] [int] NULL,
	[IssuedAtDate] [datetime] NULL,
	[TargetDate] [datetime] NULL,
	[ClosureDate] [datetime] NULL,
	[ContractCurrency] [nvarchar](50) NULL,
	[ConversionRate] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_COST]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_COST](
	[CostElementID] [int] NULL,
	[CostCenterID] [int] NULL,
	[Document Number] [nvarchar](255) NULL,
	[Company Code] [nvarchar](255) NULL,
	[Total Quantity1] [float] NULL,
	[Val/COArea Crcy] [float] NULL,
	[Value in Obj# Crcy] [float] NULL,
	[Posting Date] [datetime] NULL,
	[EmployeeID] [int] NULL,
	[EmployeeCostCenterID] [int] NULL,
	[UnitOfMeasure] [nvarchar](5) NULL,
	[Billable project (Y/N)] [nvarchar](5) NULL,
	[WBSID] [int] NULL,
	[wbs_element] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_CSS]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_CSS](
	[ActivitySK] [int] NULL,
	[CssInfoSK] [int] NULL,
	[CssValue] [numeric](17, 2) NULL,
	[ReportingDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_EmpBehavior]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_EmpBehavior](
	[EmployeeSK] [int] NOT NULL,
	[BehaviorSK] [int] NOT NULL,
	[CompanySK] [int] NOT NULL,
	[ValidationSK] [int] NOT NULL,
	[BehaviorTypeSK] [int] NOT NULL,
	[BehaviorDateKey] [int] NULL,
	[BehaviorDate] [datetime] NULL,
	[BehaviorExpDateKey] [int] NULL,
	[BehaviorExpDate] [datetime] NULL,
	[CalculateDate] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_EmpCertificate]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_EmpCertificate](
	[EmployeeSK] [int] NOT NULL,
	[CompanySK] [int] NOT NULL,
	[CertificateSK] [int] NOT NULL,
	[AccOrganizationSK] [int] NOT NULL,
	[ValidationSK] [int] NOT NULL,
	[CertificateDateKey] [int] NULL,
	[CertificateDate] [datetime] NULL,
	[IsMedical] [int] NOT NULL,
	[IsApt] [int] NOT NULL,
	[CertificateExpiringDateKey] [int] NULL,
	[CertificateExpiringDate] [datetime] NULL,
	[CalculateDate] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_EmpProjectScan]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_EmpProjectScan](
	[EmployeeSK] [int] NULL,
	[ProjectSK] [int] NULL,
	[ScannedOpTypeSK] [int] NULL,
	[EmpProjStatus] [int] NULL,
	[EmpIsDeleted] [int] NULL,
	[StartDateKey] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDateKey] [int] NULL,
	[EndDate] [datetime] NULL,
	[ScannedDateKey] [int] NULL,
	[ScannedDate] [datetime] NULL,
	[CalculateDate] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_EmpTraining]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_EmpTraining](
	[EmpTrainingID] [int] NOT NULL,
	[TrainingSK] [int] NOT NULL,
	[TrainerSK] [int] NOT NULL,
	[CategorySK] [int] NOT NULL,
	[EmpCommentSK] [int] NOT NULL,
	[ValidationSK] [int] NOT NULL,
	[EmployeeSK] [int] NOT NULL,
	[StartDateKey] [int] NULL,
	[StartDate] [datetime] NULL,
	[ExpiringDateKey] [int] NULL,
	[ExpiringDate] [datetime] NULL,
	[EmpIsPresent] [int] NOT NULL,
	[EmpIsPassed] [int] NOT NULL,
	[TraningDuration] [int] NULL,
	[EmpInitialScore] [int] NULL,
	[EmpFinalScore] [int] NULL,
	[EmpPasseGate] [int] NULL,
	[CalculateDate] [nvarchar](20) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_EquipementCertificate]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_EquipementCertificate](
	[EquipementCertifcateID] [int] NULL,
	[CertificateSK] [int] NULL,
	[EquipementSK] [int] NULL,
	[ValidationSK] [int] NULL,
	[CertificateDateKey] [int] NULL,
	[CertificateDate] [datetime] NULL,
	[CertificateExpiringDateKey] [int] NULL,
	[CertificateExpiringDate] [datetime] NULL,
	[AccOrganizationSK] [int] NULL,
	[CreationDateKey] [int] NULL,
	[CreationDate] [datetime] NULL,
	[UpdateDateKey] [int] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_EquipementEmployee]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_EquipementEmployee](
	[id] [int] NULL,
	[EquipementSK] [int] NULL,
	[EmployeeSK] [int] NULL,
	[CreationDateKey] [int] NULL,
	[CreationDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_EquipementInspection]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_EquipementInspection](
	[id] [int] NULL,
	[EquipementSK] [int] NULL,
	[InspectionSK] [int] NULL,
	[ValidationSK] [int] NULL,
	[InspectionDateKey] [int] NULL,
	[InspectionDate] [datetime] NULL,
	[ExpiringDateKey] [int] NULL,
	[ExpiringDate] [datetime] NULL,
	[CreationDateKey] [int] NULL,
	[CreationDate] [datetime] NULL,
	[UpdateDateKey] [int] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_EquipementProject]    Script Date: 02/08/2024 07:54:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_EquipementProject](
	[id] [int] NULL,
	[EquipementSK] [int] NULL,
	[ProjectSK] [int] NULL,
	[StartDateKey] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDateKey] [int] NULL,
	[EndDate] [datetime] NULL,
	[StatusKey] [int] NULL,
	[assignment_rate] [numeric](17, 2) NULL,
	[IsDeleted] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_EquipementWarning]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_EquipementWarning](
	[id] [int] NULL,
	[EquipementSK] [int] NULL,
	[WarningSK] [int] NULL,
	[ValidationSK] [int] NULL,
	[WarningDateKey] [int] NULL,
	[WarningDate] [datetime] NULL,
	[CreationDateKey] [int] NULL,
	[CreationDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_FindingReport]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_FindingReport](
	[ActivitySK] [int] NULL,
	[FindingReportSK] [int] NULL,
	[FindingLevelSK] [int] NULL,
	[FindingLevelValue] [int] NULL,
	[ReportingDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_GAs]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_GAs](
	[CostCenterID] [int] NOT NULL,
	[CostElementID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[Cost Elemet Name] [nvarchar](255) NULL,
	[Cost Element Desc] [nvarchar](255) NULL,
	[Personnel Number] [nvarchar](255) NULL,
	[Company Code] [nvarchar](255) NULL,
	[Posting Date] [datetime] NULL,
	[CO Object Name] [nvarchar](255) NULL,
	[Posted unit of meas#] [nvarchar](255) NULL,
	[Total quantity] [float] NULL,
	[Val/COArea Crcy] [float] NULL,
	[EmployeeCostCenterID] [int] NULL,
	[Period] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_GL]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_GL](
	[GLAccountID] [int] NULL,
	[CostCenterID] [int] NULL,
	[CompanyCode] [nvarchar](255) NULL,
	[DocumentCurrencyValue] [float] NULL,
	[DocumentCurrencyKey] [nvarchar](255) NULL,
	[PersonalNumber] [nvarchar](255) NULL,
	[BusinessArea] [nvarchar](255) NULL,
	[PostingDate] [datetime] NULL,
	[PostingPeriod] [nvarchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_Insurance]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_Insurance](
	[InsSK] [int] NULL,
	[ProjectSK] [int] NULL,
	[VendorSK] [int] NULL,
	[ContractSK] [int] NULL,
	[ContractorSK] [int] NULL,
	[InsProviderSK] [int] NULL,
	[InsTypeSK] [int] NULL,
	[CreatorSK] [int] NULL,
	[ReceiverSK] [int] NULL,
	[ProcInsStatusSK] [int] NULL,
	[EffectiveDate] [datetime] NULL,
	[ExpirationDate] [datetime] NULL,
	[ClosedDate] [datetime] NULL,
	[CreationDate] [datetime] NULL,
	[IssuedDate] [datetime] NULL,
	[LimitAmout] [numeric](19, 2) NULL,
	[HasPaymentReceipt] [int] NULL,
	[IsPrivate] [int] NULL,
	[ContractCurrency] [nvarchar](50) NULL,
	[ConversionRate] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_MonitoringInspection]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_MonitoringInspection](
	[SPID] [int] NULL,
	[TypeEnumSK] [int] NULL,
	[Creationdate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[Planned] [int] NULL,
	[Conducted] [int] NULL,
	[RaisedAction] [int] NULL,
	[ClosedAction] [int] NULL,
	[ClosedWithin] [int] NULL,
	[RecordedByKeyPersons] [int] NULL,
	[totalSors] [int] NULL,
	[NumberOfAreas] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_PayAttachment]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_PayAttachment](
	[PayIssuedSK] [int] NOT NULL,
	[AttachmentSK] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_PayIssued]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_PayIssued](
	[PayIssuedID] [nvarchar](1000) NOT NULL,
	[RequisitionID] [nvarchar](1000) NULL,
	[PayIssuedSK] [int] NOT NULL,
	[ProjectSK] [int] NOT NULL,
	[ContractSK] [int] NOT NULL,
	[PayIssuedCreationDate] [datetime] NULL,
	[PayIssuedDate] [nvarchar](1000) NULL,
	[DatePaymentSettled] [date] NULL,
	[datePaymentInitiated] [date] NULL,
	[PaymentStatus] [nvarchar](1000) NULL,
	[PaymentAmount] [numeric](17, 2) NULL,
	[ContractCurrency] [nvarchar](50) NULL,
	[ConversionRate] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_PDN]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_PDN](
	[PDNSK] [int] NOT NULL,
	[ProjectSK] [int] NOT NULL,
	[ProcCorrespStatusSK] [int] NOT NULL,
	[SK_UserAssignee] [int] NOT NULL,
	[SK_UserDistribution] [int] NOT NULL,
	[VendorSK] [int] NOT NULL,
	[ContractorSK] [int] NULL,
	[ContractSK] [int] NOT NULL,
	[ClosedDate] [datetime] NULL,
	[CreationDate] [datetime] NULL,
	[IssuedDate] [datetime] NULL,
	[ValueCost] [numeric](17, 3) NULL,
	[HasHSEImpact] [int] NULL,
	[IsActiveTrades] [int] NULL,
	[ContractCurrency] [nvarchar](50) NULL,
	[ConversionRate] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_Planning]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_Planning](
	[PlanningSK] [int] NOT NULL,
	[PlanningStatusSK] [int] NOT NULL,
	[PlanningActivityTypeSK] [int] NOT NULL,
	[ProjectSK] [int] NOT NULL,
	[PlanningCreationDateKey] [int] NULL,
	[PlanningUpdateDateKey] [int] NULL,
	[fiscal_year] [int] NULL,
	[PlanningCount] [int] NULL,
	[ReportingDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_PlanningActivity]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_PlanningActivity](
	[ActivitySK] [int] NOT NULL,
	[PlanningSK] [int] NOT NULL,
	[ReportingDate] [date] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ProcContract]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ProcContract](
	[ContractSK] [int] NOT NULL,
	[VendorSK] [int] NOT NULL,
	[ProjectSK] [int] NOT NULL,
	[ContractorSK] [int] NOT NULL,
	[ProcStatusSK] [int] NOT NULL,
	[CreationDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[ApprovedChangeOrders] [numeric](17, 2) NULL,
	[PendingRevisedContract] [numeric](17, 2) NULL,
	[GrandTotal] [numeric](17, 2) NULL,
	[PendingChangeOrders] [numeric](17, 2) NULL,
	[DraftChangeOrdersAmount] [numeric](17, 2) NULL,
	[RemainingBalanceOutstanding] [numeric](17, 2) NULL,
	[TotalDrawRequestsAmount] [numeric](17, 2) NULL,
	[TotalPayments] [numeric](17, 2) NULL,
	[TotalRequisitionsAmount] [numeric](17, 2) NULL,
	[RevisedContract] [numeric](17, 2) NULL,
	[ContratPeriod] [nvarchar](500) NULL,
	[ContractCurrency] [nvarchar](50) NULL,
	[ConversionRate] [float] NULL,
	[ContractCount] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ProjectCompany]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ProjectCompany](
	[ProjectSK] [int] NULL,
	[CompanySK] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ProjectPhase]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ProjectPhase](
	[ID] [int] NULL,
	[EnumSK] [int] NULL,
	[ProjectSK] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ProjectRole]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ProjectRole](
	[ID] [nvarchar](1000) NULL,
	[ProjectSK] [int] NOT NULL,
	[ProjectRoleSK] [int] NOT NULL,
	[UserSK] [int] NOT NULL,
	[IsActive] [nvarchar](1000) NULL,
	[CreationDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_ProjectSchedule]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_ProjectSchedule](
	[ProjectSK] [int] NOT NULL,
	[CurrentBaselineProjectObjectId] [int] NULL,
	[SumActualStartDate] [datetime] NULL,
	[SumPlannedFinishDate] [datetime] NULL,
	[SumBaselineFinishDate] [datetime] NULL,
	[SumBaselineStartDate] [datetime] NULL,
	[SumPlannedStartDate] [datetime] NULL,
	[PlannedStartDate] [datetime] NULL,
	[DataDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[FinishDate] [datetime] NULL,
	[LastUpdateDate] [datetime] NULL,
	[OriginalBudget] [numeric](28, 10) NULL,
	[OverallProjectScore] [numeric](28, 10) NULL,
	[EarnedValueUserPercent] [numeric](28, 10) NULL,
	[CurrentVariance] [numeric](28, 10) NULL,
	[SumActivityCount] [numeric](28, 10) NULL,
	[SumActualDuration] [numeric](28, 10) NULL,
	[SumActualLaborunits] [numeric](28, 10) NULL,
	[SumAtCompletionDuration] [numeric](28, 10) NULL,
	[SumAtCompletionLaborUnits] [numeric](28, 10) NULL,
	[SumBaselineDuration] [numeric](28, 10) NULL,
	[SumBlinProgressActivityCount] [numeric](28, 10) NULL,
	[SumDurationPercentComplete] [numeric](28, 10) NULL,
	[SumDurationPercentOfPlanned] [numeric](28, 10) NULL,
	[SumDurationVariance] [numeric](28, 10) NULL,
	[SumFinishdateVariance] [numeric](28, 10) NULL,
	[SumInProgressActivityCount] [numeric](28, 10) NULL,
	[SumNotStartedActivityCount] [numeric](28, 10) NULL,
	[SumPlannedDuration] [numeric](28, 10) NULL,
	[SumPlannedLaborUnits] [numeric](28, 10) NULL,
	[SumRemainingLaborUnits] [numeric](28, 10) NULL,
	[SumSchdVarianceByLaborUnits] [numeric](28, 10) NULL,
	[SumSchedulePercentComplete] [numeric](28, 10) NULL,
	[SumStartDateVariance] [numeric](28, 10) NULL,
	[SumTotalFloat] [numeric](28, 10) NULL,
	[SumRemainingDuration] [numeric](28, 10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_PSR]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_PSR](
	[HierarchyPathID] [nvarchar](250) NULL,
	[ReportGroupingSK] [int] NOT NULL,
	[JEGPortfolioBudgetClientCostCPI] [int] NULL,
	[RevProdHours] [int] NULL,
	[CBHoursJTD] [int] NULL,
	[CBHoursCost] [int] NULL,
	[RollupActualUnits] [int] NULL,
	[EarnedHours] [int] NULL,
	[CBCost] [int] NULL,
	[RollupActuals] [int] NULL,
	[EACCost] [bigint] NULL,
	[EJTDC] [int] NULL,
	[EACHours] [int] NULL,
	[TimePeriod] [nvarchar](20) NULL,
	[ProjectSK] [int] NULL,
	[WorkOrderSK] [int] NULL,
	[isPostCutOff] [int] NULL,
	[isLast] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_Requisitions]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_Requisitions](
	[RequisitionID] [varchar](250) NULL,
	[InvoiceNumber] [varchar](100) NULL,
	[ReqStatusSK] [int] NOT NULL,
	[ProjectSK] [int] NOT NULL,
	[ContractSK] [int] NOT NULL,
	[CreatorSK] [int] NOT NULL,
	[VendorSK] [int] NOT NULL,
	[BillingDate] [datetime] NULL,
	[ReqCreationDate] [datetime] NULL,
	[ReqUpdateDate] [datetime] NULL,
	[BillingPeriodDueDate] [datetime] NULL,
	[BillingPeriodStartDate] [datetime] NULL,
	[BillingPeriodEndDate] [datetime] NULL,
	[ReqSubmittionDate] [datetime] NULL,
	[ReqStartDate] [datetime] NULL,
	[ReqEndDate] [datetime] NULL,
	[PaymentDate] [datetime] NULL,
	[PctComplete] [numeric](17, 2) NULL,
	[Number] [int] NULL,
	[BalanceToFinishIncludingRetainage] [numeric](17, 2) NULL,
	[CompletedWorkRetainageAmount] [numeric](17, 2) NULL,
	[ContractSumToDate] [numeric](17, 2) NULL,
	[CurrentPaymentDue] [numeric](17, 2) NULL,
	[LessPreviousCertificatesForPayment] [numeric](17, 2) NULL,
	[NegativeChangeOrderItemTotal] [numeric](17, 2) NULL,
	[NegativeNewChangeOrderItemTotal] [numeric](17, 2) NULL,
	[NegativePreviousChangeOrderItemTotal] [numeric](17, 2) NULL,
	[NetChangeByChangeOrders] [numeric](17, 2) NULL,
	[OriginalContractSum] [numeric](17, 2) NULL,
	[PositiveChangeOrderItemTotal] [numeric](17, 2) NULL,
	[PositiveNewChangeOrderItemTotal] [numeric](17, 2) NULL,
	[PositivePreviousChangeOrderItemTotal] [numeric](17, 2) NULL,
	[StoredMaterialsRetainageAmount] [numeric](17, 2) NULL,
	[StoredMaterialsRetainagePercent] [numeric](17, 2) NULL,
	[TaxApplicableToThisPayment] [numeric](17, 2) NULL,
	[TotalCompletedAndStoredToDate] [numeric](17, 2) NULL,
	[TotalEarnedLessRetainage] [numeric](17, 2) NULL,
	[TotalRetainage] [numeric](17, 2) NULL,
	[FormattedPeriod] [varchar](50) NULL,
	[IsFinalRequisitions] [int] NOT NULL,
	[IsLatest] [int] NOT NULL,
	[PeriodRequisition] [nvarchar](50) NULL,
	[ContractCurrency] [nvarchar](50) NULL,
	[ConversionRate] [float] NULL,
	[TotalClaimedAmount] [numeric](17, 2) NULL,
	[LineItemAmount] [numeric](17, 2) NULL,
	[PayIssuedDate] [date] NULL,
	[PaymentAmount] [numeric](17, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_Revenue]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_Revenue](
	[ProfitCenterID] [int] NULL,
	[WBSID] [int] NULL,
	[GLAccountID] [int] NULL,
	[CompanyCode] [nvarchar](255) NULL,
	[FiscalYear] [nvarchar](255) NULL,
	[PostingPeriod] [nvarchar](255) NULL,
	[DocumentCurrencyValue] [float] NULL,
	[DocumentCurrencyKey] [nvarchar](255) NULL,
	[DocumentNumber] [nvarchar](255) NULL,
	[BusinessUnit] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_SafetyPerformance]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_SafetyPerformance](
	[SpID] [int] NULL,
	[ProjectSK] [int] NULL,
	[ContractSK] [int] NULL,
	[StatusEnumSK] [int] NULL,
	[CompanySK] [int] NULL,
	[CreatorSK] [int] NULL,
	[CreationDate] [datetime] NULL,
	[Updatedate] [datetime] NULL,
	[SpMonth] [int] NULL,
	[SpYear] [int] NULL,
	[SpQualEvalRaisedActions] [int] NULL,
	[AuditEvalPlanned] [int] NULL,
	[AuditEvalConducted] [int] NULL,
	[CmHseEnforcement] [int] NULL,
	[CmHseNonCompliance] [int] NULL,
	[CmNcrCloseOut] [int] NULL,
	[ChsrNbContractorsHseSupervisor] [int] NULL,
	[HmFitToWorkHealthAssesment] [int] NULL,
	[HmWorkingHeightMedAssesTraining] [int] NULL,
	[HmPplWorkingHeight] [int] NULL,
	[HmActualFirstAidersOnSite] [int] NULL,
	[Ltifr] [numeric](17, 2) NULL,
	[Trifr] [numeric](17, 2) NULL,
	[Fatality] [numeric](17, 2) NULL,
	[MalPlannedSiteLeadership] [int] NULL,
	[MalSiteLeadershipWalksCond] [int] NULL,
	[MalRaisedInMeeting] [int] NULL,
	[RrActuals] [int] NULL,
	[RrPlanned] [int] NULL,
	[TotalOnsite] [int] NULL,
	[ContKeyPersons] [int] NULL,
	[WorkingHoursMonth] [int] NULL,
	[NbcompletedbyCs] [int] NULL,
	[NbSampledContractor] [int] NULL,
	[NbTasksCarried] [int] NULL,
	[Average] [int] NULL,
	[HseTrainingHours] [int] NULL,
	[NbStartsOnProject] [int] NULL,
	[Attended] [int] NULL,
	[TbtConducted] [int] NULL,
	[TbtPlanned] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_SOR]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_SOR](
	[SORID] [int] NULL,
	[SORSK] [int] NULL,
	[ProjectSK] [int] NULL,
	[SubmiterSK] [int] NULL,
	[SORDateKey] [int] NULL,
	[DateOfClosureKey] [int] NULL,
	[DueDateKey] [int] NULL,
	[CreatedKey] [int] NULL,
	[ModifiedKey] [int] NULL,
	[SORDate] [datetime] NULL,
	[DateOfClosure] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_SpComments]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_SpComments](
	[SpCommentSK] [int] IDENTITY(1,1) NOT NULL,
	[SpID] [nvarchar](50) NULL,
	[ProfileName] [nvarchar](150) NULL,
	[SpComment] [nvarchar](2000) NULL,
	[isDeleted] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_StaticInputMonth]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_StaticInputMonth](
	[SIMID] [int] NULL,
	[ProjectSK] [int] NULL,
	[DatevalueKey] [int] NULL,
	[ValidatedKey] [int] NULL,
	[CreatedKey] [int] NULL,
	[ModifiedKey] [int] NULL,
	[MPValue] [int] NULL,
	[MHValue] [int] NULL,
	[SPAValue] [int] NULL,
	[SORValue] [int] NULL,
	[TBTValue] [int] NULL,
	[TrainingHours] [numeric](17, 2) NULL,
	[InductionValue] [int] NULL,
	[Validated] [int] NULL,
	[Datevalue] [datetime] NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_SubContracting]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_SubContracting](
	[SubContractingSK] [int] NOT NULL,
	[VendorSK] [int] NOT NULL,
	[ContractorSK] [int] NULL,
	[SubContractingStatusSK] [nvarchar](250) NOT NULL,
	[ProjectSK] [int] NOT NULL,
	[Creationdate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_SubEvent]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_SubEvent](
	[SubEventID] [int] NULL,
	[SubEventTypeSK] [int] NULL,
	[SubmiterSK] [int] NULL,
	[SubEventSK] [int] NULL,
	[ProjectSK] [int] NULL,
	[DatevalueKey] [int] NULL,
	[CreatedDateKey] [int] NULL,
	[ModifiedDateKey] [int] NULL,
	[Datevalue] [datetime] NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_TaskHistory]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_TaskHistory](
	[TaskHistorySK] [int] NULL,
	[ConsEquipmentSK] [int] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[CreationDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_Variation]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_Variation](
	[VARID] [varchar](250) NULL,
	[VarNumber] [varchar](250) NULL,
	[VarRevision] [varchar](50) NULL,
	[ProjectSK] [int] NULL,
	[ContractSK] [int] NULL,
	[VarStatusSK] [int] NULL,
	[CORSK] [int] NULL,
	[CreatorSK] [int] NULL,
	[CreationDate] [datetime] NULL,
	[InvoiceDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[PaidDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[isExecuted] [int] NULL,
	[VarGrandTotal] [numeric](17, 2) NULL,
	[ContractCurrency] [nvarchar](50) NULL,
	[ConversionRate] [float] NULL,
	[VendorSK] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_VER_GM]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_VER_GM](
	[HierarchyPathID] [nvarchar](255) NULL,
	[CostObjectSK] [int] NULL,
	[ProjectStartDateKey] [int] NULL,
	[ProjectEndDateKey] [int] NULL,
	[OriginalGrossMargin] [int] NULL,
	[ActualGrossMargin] [int] NULL,
	[EACCostMargin] [bigint] NULL,
	[ClientPostedHours] [int] NULL,
	[ClientPostedCost] [bigint] NULL,
	[CostObjectHierarchyLevel] [int] NULL,
	[ProjectStartDate] [date] NULL,
	[ProjectEndDate] [date] NULL,
	[TimePeriod] [nvarchar](20) NULL,
	[ProjectSK] [int] NULL,
	[WorkOrderSK] [int] NULL,
	[isPostCutOff] [int] NULL,
	[ReportingPeriod] [nvarchar](10) NULL,
	[isLast] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [FACT].[F_WorkOrder]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [FACT].[F_WorkOrder](
	[WorkOrderID] [int] NULL,
	[WorkOrderSK] [int] NULL,
	[ProjectSK] [int] NULL,
	[CreationDateKey] [int] NULL,
	[UpdateDateKey] [int] NULL,
	[IsOverallWorkOrder] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [mapping].[ODC_LDC]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [mapping].[ODC_LDC](
	[Cost element name] [nvarchar](255) NULL,
	[Category] [nvarchar](255) NULL,
	[Type] [nvarchar](255) NULL,
	[OdcLdc] [varchar](3) NOT NULL,
	[CostElementID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [DIM].[usp_CSP]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DIM].[usp_CSP]
AS
BEGIN
   ------------D_Enumeration---------------------------------
MERGE DWH.DIM.D_Enumeration AS T
USING (SELECT 'CSP-'+cast([id] as nvarchar(10)) EnumID
    ,[id]
      ,[type] EnumType
      ,[code] EnumCode
      ,[label] EnumLabel
  FROM [STG].ds.[csp_enumeration]

  ) S 
ON  T.EnumID = S.EnumID 
WHEN MATCHED AND (isnull(T.Type,'') <> isnull(S.enumType,'') or isnull(T.Code,'') <> isnull(S.enumCode,'') or isnull(T.Label,'') <> isnull(S.EnumLabel,''))
   THEN UPDATE SET T.Type = S.EnumType, T.Code = S.EnumCode, T.Label = S.EnumLabel 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (enumID,ID,Type,Code,Label)
   VALUES (S.enumID,S.ID,S.EnumType,S.EnumCode,S.EnumLabel);

------------D_Contract---------------------------------
MERGE DWH.DIM.D_Contract AS T
USING (  select c.id ContractID,c.contract_number ContractNumber,c.description ContractDescription
  from stg.ds.jpass_contract c
) S 
ON  T.ContractID = S.ContractID
WHEN MATCHED AND 
(isnull(T.ContractNumber,'') <> isnull(S.ContractNumber,'') OR
isnull(T.ContractDescription,'') <> isnull(S.ContractDescription,'') 
)
   THEN UPDATE SET T.ContractNumber = S.ContractNumber ,
   T.ContractDescription = S.ContractDescription
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ContractID,ContractNumber,ContractDescription)
   VALUES (S.ContractID,S.ContractNumber,S.ContractDescription);

------------D_CacheAdUsers---------------------------------
MERGE DWH.DIM.D_CacheAdUsers AS T
USING (  select cache_ad_user_id,
user_last_name,
user_first_name,
case when user_last_name is not null or user_first_name is not null then isnull(user_last_name,'') +' ' +isnull(user_first_name,'')
else SUBSTRING([user_mail], 0, charindex('@', [user_mail], 0)) end user_full_name,
[user_mail],
user_deleted,
SourceSystem,
v.user_display_name,
v.user_frozen,
v.user_phone
from [STG].[ds].[v_collab_cach_users] v
) S 
ON  T.CacheAdUserID = S.cache_ad_user_id and T.SourceSystem='Collab'
WHEN MATCHED AND 
(isnull(T.LastName,'') <> isnull(S.user_last_name,'') OR
isnull(T.FirstName,'') <> isnull(S.user_first_name,'') OR
isnull(T.Email,'') <> isnull(S.user_mail,'')  OR
isnull(T.isdeleted,'') <> isnull(S.user_deleted,'')  OR
isnull(T.FullName,'') <> isnull(S.user_full_name,'') OR
isnull(T.SourceSystem,'') <> isnull(S.SourceSystem,'') OR
isnull(T.isFrozen,'') <> isnull(S.user_frozen,'') OR
isnull(T.MobilePhone,'') <> isnull(S.user_phone,'') OR
isnull(T.DisplayName,'') <> isnull(S.user_display_name,'') 
)
   THEN UPDATE SET T.LastName = S.user_last_name ,
   T.FirstName = S.user_first_name ,
   T.Email = S.user_mail ,
   T.FullName = S.user_full_name ,
   T.isdeleted = S.user_deleted,
   T.SourceSystem=S.SourceSystem,
   T.isFrozen=S.user_frozen,
   T.MobilePhone=S.user_phone,
   T.DisplayName=S.user_display_name
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CacheAdUserID,LastName,FirstName,Email,FullName,isdeleted,SourceSystem,isFrozen,MobilePhone,DisplayName)
   VALUES (S.cache_ad_user_id,S.user_last_name,S.user_first_name,S.user_mail,S.user_full_name ,S.user_deleted,S.SourceSystem,S.user_frozen,S.user_phone,S.user_display_name);
END;
GO
/****** Object:  StoredProcedure [DIM].[usp_HSE]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DIM].[usp_HSE]
AS
BEGIN
------------D_SubEvent---------------------------------
MERGE DWH.DIM.D_SubEvent AS T
USING (select distinct id,
UnsafeactsValue,
UnsafeconditionsValue,
PeopleFactorsValue,
ExecutionFactorsValue,
ManagementAspectsValue,
ProgramSystemAspectsValue,
Projectvalue,
Descriptionvalue
from stg.hse.SubEvent
) S 
ON  T.SubeventID = S.id 
WHEN MATCHED AND (
isnull(T.UnsafeactsValue,'') <> isnull(S.UnsafeactsValue,'') OR 
isnull(T.UnsafeconditionsValue,'') <> isnull(S.UnsafeconditionsValue,'') OR 
isnull(T.PeopleFactorsValue,'') <> isnull(S.PeopleFactorsValue,'') OR 
isnull(T.ExecutionFactorsValue,'') <> isnull(S.ExecutionFactorsValue,'') OR 
isnull(T.ManagementAspectsValue,'') <> isnull(S.ManagementAspectsValue,'') OR 
isnull(T.ProgramSystemAspectsValue,'') <> isnull(S.ProgramSystemAspectsValue,'') OR 
isnull(T.Projectvalue,'') <> isnull(S.Projectvalue,'') OR 
isnull(T.Descriptionvalue,'') <> isnull(S.Descriptionvalue,'')
)
THEN UPDATE SET T.UnsafeactsValue = S.UnsafeactsValue,
T.UnsafeconditionsValue = S.UnsafeconditionsValue,
T.PeopleFactorsValue = S.PeopleFactorsValue,
T.ExecutionFactorsValue = S.ExecutionFactorsValue,
T.ManagementAspectsValue = S.ManagementAspectsValue,
T.ProgramSystemAspectsValue = S.ProgramSystemAspectsValue,
T.Projectvalue = S.Projectvalue,
T.Descriptionvalue = S.Descriptionvalue
WHEN NOT MATCHED BY TARGET
   THEN INSERT (SubEventID,UnsafeactsValue ,
UnsafeconditionsValue ,
PeopleFactorsValue ,
ExecutionFactorsValue ,
ManagementAspectsValue ,
ProgramSystemAspectsValue ,
Projectvalue ,
Descriptionvalue )
   VALUES (S.ID,S.UnsafeactsValue ,
S.UnsafeconditionsValue ,
S.PeopleFactorsValue ,
S.ExecutionFactorsValue ,
S.ManagementAspectsValue ,
S.ProgramSystemAspectsValue ,
S.Projectvalue ,
S.Descriptionvalue )
;
------------D_Submiter---------------------------------
with sub as (
select distinct MailValue
from stg.hse.SubEvent
where MailValue is not null
union
select distinct MailValue
from stg.hse.sor 
where MailValue is not null
),subenr as (
select sub.MailValue,isnull(se.SubmiterValue,'-') SubmiterValue
from sub
outer apply (select distinct SubmiterValue from stg.hse.SubEvent s where s.MailValue = sub.MailValue) se
)

MERGE DWH.DIM.D_Submiter AS T
USING (select distinct  MailValue,SubmiterValue from subenr) S 
ON  T.SubmiterValue = S.SubmiterValue and T.MailValue=S.MailValue
WHEN NOT MATCHED BY TARGET
   THEN INSERT (SubmiterValue,MailValue)
   VALUES (S.SubmiterValue,S.MailValue)
;


------------D_SubeventType---------------------------------
MERGE DWH.DIM.D_SubEventType AS T
USING (select distinct isnull(TypeValue,'-') TypeValue,
isnull(SubEventValue,'-') SubEventValue
from stg.hse.SubEvent
where isnull(TypeValue,SubEventValue) is not null) S 
ON  T.TypeValue = S.TypeValue and T.SubEventValue=S.SubEventValue
WHEN NOT MATCHED BY TARGET
   THEN INSERT (TypeValue,SubEventValue)
   VALUES (S.TypeValue,S.SubEventValue)
;
------------D_SOR---------------------------------
MERGE DWH.DIM.D_SOR AS T
USING (select distinct Id SORID,
Project SORProject,
 Description SORDescription,
 LocationOfSORValue SORLocation,
 GroupValue as SORGroupValue,
 Statut SORStatut,
 CriticalRisk SORCriticalRisk,
 SubjectValue SORSubjectValue,
 TypeValue TypeValue
from stg.hse.sor
) S 
ON  T.SORID = S.SORID 
WHEN MATCHED AND (
isnull(T.SORProject,'') <> isnull(S.SORProject,'') OR 
isnull(T.SORLocation,'') <> isnull(S.SORLocation,'') OR 
isnull(T.SORDescription,'') <> isnull(S.SORDescription,'') OR 
isnull(T.SORGroupValue,'') <> isnull(S.SORGroupValue,'')OR 
isnull(T.SORStatut,'') <> isnull(S.SORStatut,'')OR 
isnull(T.SORCriticalRisk,'') <> isnull(S.SORCriticalRisk,'')OR 
isnull(T.SORSubjectValue,'') <> isnull(S.SORSubjectValue,'')OR 
isnull(T.TypeValue,'') <> isnull(S.TypeValue,'')
)
THEN UPDATE SET T.SORProject = S.SORProject,
T.SORLocation = S.SORLocation,
T.SORDescription = S.SORDescription,
T.SORGroupValue = S.SORGroupValue,
T.SORStatut = S.SORStatut,
T.SORCriticalRisk = S.SORCriticalRisk,
T.SORSubjectValue = S.SORSubjectValue,
T.TypeValue = S.TypeValue
WHEN NOT MATCHED BY TARGET
   THEN INSERT (SORID,SORProject ,SORLocation,SORDescription,SORGroupValue,SORStatut,SORCriticalRisk,SORSubjectValue,TypeValue)
   VALUES (S.SORID,S.SORProject ,S.SORLocation,S.SORDescription,S.SORGroupValue,S.SORStatut,S.SORCriticalRisk,S.SORSubjectValue,S.TypeValue);

END;
GO
/****** Object:  StoredProcedure [DIM].[usp_JPASS]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DIM].[usp_JPASS]
AS
BEGIN

------------D_Training---------------------------------
MERGE DWH.DIM.D_TRAINING AS T
USING (select distinct training_id ,training_title,Training_Description
FROM STG.ds.V_jpass_training_title
where training_id is not null) S 
ON  T.TrainingID = S.Training_ID
WHEN MATCHED AND 
(isnull(T.TrainingTitle,'') <> isnull(S.Training_Title,'') OR
isnull(T.TrainingDescription,'') <> isnull(S.Training_Description,'')
)
   THEN UPDATE SET T.TrainingTitle = S.Training_Title,
   T.TrainingDescription=S.Training_Description
WHEN NOT MATCHED BY TARGET
   THEN INSERT (TrainingID,TrainingTitle,TrainingDescription)
   VALUES (S.Training_ID,S.Training_Title,Training_Description)
;
------------D_TrainingCategory---------------------------------
MERGE DWH.DIM.D_TrainingCategory AS T
USING (select distinct  employee_category_id,employee_category
FROM STG.dS.v_jpass_training
where employee_category_id is not null) S 
ON  T.CategoryCode = S.employee_category_id
WHEN MATCHED AND isnull(T.CategoryLabel,'') <> isnull(S.employee_category,'') 
   THEN UPDATE SET T.CategoryLabel = S.employee_category
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CategoryCode,CategoryLabel)
   VALUES (S.employee_category_id,S.employee_category);
------------D_Company---------------------------------
MERGE DWH.DIM.D_Company AS T
USING (select distinct  company_id,company_name,company_type,left(company_creation_date,23) company_creation_date FROM STG.ds.v_jpass_sub_contractor
where company_id is not null ) S 
ON  T.CompanyID = S.company_id
WHEN MATCHED AND (isnull(T.CompanyName,'') <> isnull(S.company_name,'') OR isnull(T.CompanyType,'') <> isnull(S.company_type,''))
   THEN UPDATE SET T.CompanyName = S.Company_Name,T.CompanyType=S.company_type
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CompanyID,CompanyName,CompanyType,CreationDate)
   VALUES (S.company_id,S.company_name,S.company_type,S.company_creation_date);
------------D_ScannedOpType---------------------------------
MERGE DWH.DIM.D_ScannedOpType AS T
USING (select distinct [scanned_operation_type_code],[scanned_operation_type]
  FROM [STG].[dS].v_jpass_scan_history p
  where [scanned_operation_type_code]<>'' and [scanned_operation_type_code] is not null) S 
ON  T.ScannedOpTypeID = S.scanned_operation_type_code
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ScannedOpTypeID,ScannedOpType)
   VALUES (S.scanned_operation_type_code ,S.scanned_operation_type);
------------D_CacheAdUsers---------------------------------
MERGE DWH.DIM.D_CacheAdUsers AS T
USING (  select cache_ad_user_id,
user_last_name,
user_first_name,
case when user_last_name is not null or user_first_name is not null then isnull(user_last_name,'') +' ' +isnull(user_first_name,'')
else SUBSTRING([user_mail], 0, charindex('@', [user_mail], 0)) end user_full_name,
[user_mail],
user_deleted,
SourceSystem,
v.user_display_name,
v.user_frozen,
v.user_phone
from [STG].[ds].[v_collab_cach_users] v
) S 
ON  T.CacheAdUserID = S.cache_ad_user_id and T.SourceSystem='Collab'
WHEN MATCHED AND 
(isnull(T.LastName,'') <> isnull(S.user_last_name,'') OR
isnull(T.FirstName,'') <> isnull(S.user_first_name,'') OR
isnull(T.Email,'') <> isnull(S.user_mail,'')  OR
isnull(T.isdeleted,'') <> isnull(S.user_deleted,'')  OR
isnull(T.FullName,'') <> isnull(S.user_full_name,'') OR
isnull(T.SourceSystem,'') <> isnull(S.SourceSystem,'') OR
isnull(T.isFrozen,'') <> isnull(S.user_frozen,'') OR
isnull(T.MobilePhone,'') <> isnull(S.user_phone,'') OR
isnull(T.DisplayName,'') <> isnull(S.user_display_name,'') 
)
   THEN UPDATE SET T.LastName = S.user_last_name ,
   T.FirstName = S.user_first_name ,
   T.Email = S.user_mail ,
   T.FullName = S.user_full_name ,
   T.isdeleted = S.user_deleted,
   T.SourceSystem=S.SourceSystem,
   T.isFrozen=S.user_frozen,
   T.MobilePhone=S.user_phone,
   T.DisplayName=S.user_display_name
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CacheAdUserID,LastName,FirstName,Email,FullName,isdeleted,SourceSystem,isFrozen,MobilePhone,DisplayName)
   VALUES (S.cache_ad_user_id,S.user_last_name,S.user_first_name,S.user_mail,S.user_full_name ,S.user_deleted,S.SourceSystem,S.user_frozen,S.user_phone,S.user_display_name);
------------D_Inspection---------------------------------
MERGE DWH.DIM.D_Inspection AS T
USING STG.ds.v_jpass_inspection S 
ON  T.InspectionID = S.inspections_id
WHEN MATCHED AND 
(isnull(T.InspectionName,'') <> isnull(S.name,'') OR 
isnull(T.InspectionLabel,'') <> isnull(S.label,'') 
)
   THEN UPDATE SET T.InspectionName = S.name ,
T.InspectionLabel = S.label 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (InspectionID ,
InspectionName ,
InspectionLabel  )
   VALUES (S.inspections_id,
S.name,
S.label)
;
------------D_Warning---------------------------------
MERGE DWH.DIM.D_Warning AS T
USING STG.dS.v_jpass_warning S 
ON  T.WarningID = S.Warning_ID
WHEN MATCHED AND 
(isnull(T.WarningName,'') <> isnull(S.warning_name,'') OR 
isnull(T.WarningType,'') <> isnull(S.warning_type,'') 
)
   THEN UPDATE SET T.WarningName = S.warning_name ,
T.WarningType = S.warning_type 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (WarningID ,
WarningName ,
WarningType  )
   VALUES (S.warning_id,
S.warning_name,
S.warning_type)
;
------------D_ConstructionEquipement---------------------------------
MERGE DWH.DIM.D_ConstructionEquipement AS T
USING STG.ds.v_jpass_construction_equipement S 
ON  T.EquipementID = S.ID
WHEN MATCHED AND 
(isnull(T.EquipementName,'') <> isnull(S.name,'') OR 
isnull(T.EquipementBrand,'') <> isnull(S.brand,'') OR 
isnull(T.EquipementSerialNumber,'') <> isnull(S.serial_number,'') OR 
isnull(T.EquipementTypeLabel,'') <> isnull(S.label,'') OR 
isnull(T.EquipementType,'') <> isnull(S.type,'') OR 
isnull(T.EquipementMatriculation,'') <> isnull(S.matriculation,'') OR 
isnull(T.EquipementLifting,'') <> isnull(S.lifting_equip,'') OR 
isnull(T.EquipementMoreInfo,'') <> isnull(S.more_information,'') OR 
isnull(T.EquipementPhoto,'') <> isnull(S.photo,'') OR 
isnull(T.EquipementQrCode,'') <> isnull(S.qr_code,'') OR 
isnull(T.EquipementCreationDate,'9999-12-31') <> isnull(S.creation_date,'9999-12-31') OR 
isnull(T.EquipementUpdateDate,'9999-12-31') <> isnull(S.update_date,'9999-12-31') OR 
isnull(T.EquipementLongitude,'') <> isnull(S.longitude,'') OR 
isnull(T.EquipementLatitude,'') <> isnull(S.latitude,'') OR 
isnull(T.EquipementCompany,'') <> isnull(S.company,'') OR 
isnull(T.EquipementSubcontractor,'') <> isnull(S.subcontractor,'') OR 
isnull(T.EquipementLinkedAllContracts,'') <> isnull(S.linked_all_contracts,'') OR 
isnull(T.EquipementConstructionName,'') <> isnull(S.construction_equipment_name,'')
)
   THEN UPDATE SET T.EquipementName = S.name ,
T.EquipementBrand = S.brand ,
T.EquipementSerialNumber = S.serial_number ,
T.EquipementTypeLabel = S.label ,
T.EquipementType = S.type ,
T.EquipementMatriculation = S.matriculation ,
T.EquipementLifting = S.lifting_equip ,
T.EquipementMoreInfo = S.more_information ,
T.EquipementPhoto = S.photo ,
T.EquipementQrCode = S.qr_code ,
T.EquipementCreationDate = S.creation_date ,
T.EquipementUpdateDate = S.update_date ,
T.EquipementLongitude = S.longitude ,
T.EquipementLatitude = S.latitude ,
T.EquipementCompany = S.company ,
T.EquipementSubcontractor = S.subcontractor ,
T.EquipementLinkedAllContracts = S.linked_all_contracts ,
T.EquipementConstructionName = S.construction_equipment_name 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (EquipementID ,
EquipementName ,
EquipementBrand ,
EquipementSerialNumber ,
EquipementTypeLabel ,
EquipementType ,
EquipementMatriculation ,
EquipementLifting ,
EquipementMoreInfo ,
EquipementPhoto ,
EquipementQrCode ,
EquipementCreationDate ,
EquipementUpdateDate ,
EquipementLongitude ,
EquipementLatitude ,
EquipementCompany ,
EquipementSubcontractor ,
EquipementLinkedAllContracts ,
EquipementConstructionName )
   VALUES (S.id,
S.name,
S.brand,
S.serial_number,
S.label,
S.type,
S.matriculation,
S.lifting_equip,
S.more_information,
S.photo,
S.qr_code,
S.creation_date,
S.update_date,
S.longitude,
S.latitude,
S.company,
S.subcontractor,
S.linked_all_contracts,
S.construction_equipment_name)
;
------------D_TaskHistory---------------------------------
MERGE DWH.DIM.D_TaskHistory AS T
USING (  SELECT [id] TaskHistoryID
      ,[task] TaskHistory
      ,[work_area] WorkArea
      ,[detail] Detail
  FROM [STG].[dS].[jpass_task_history]
) S 
ON  T.TaskHistoryID = S.TaskHistoryID
WHEN MATCHED AND 
(isnull(T.TaskHistory,'') <> isnull(S.TaskHistory,'') OR
isnull(T.WorkArea,'') <> isnull(S.WorkArea,'') OR
isnull(T.Detail,'') <> isnull(S.Detail,'')
)
   THEN UPDATE SET T.TaskHistory = S.TaskHistory ,
   T.WorkArea = S.WorkArea ,
   T.Detail = S.Detail
WHEN NOT MATCHED BY TARGET
   THEN INSERT (TaskHistoryID,TaskHistory,WorkArea,Detail)
   VALUES (S.TaskHistoryID,S.TaskHistory,S.WorkArea,S.Detail);

------------D_EmployeeDetails---------------------------------
MERGE DWH.DIM.D_EmployeeDetails AS T
USING (select distinct  employee_id,employee_unique_reference,employee_type,employee_company_name
      ,employee_subcontractor,employee_job,employee_department,employee_country,employee_city
  FROM STG.ds.v_jpass_EMPLOYEE
where [employee_id] is not null ) S 
ON  T.EmpID = S.employee_id
WHEN MATCHED AND 
(isnull(T.EmpUniqueRef,'') <> isnull(S.employee_unique_reference,'') 
OR isnull(T.EmpType,'') <> isnull(S.employee_type,'')
OR isnull(T.EmpCompanyName,'') <> isnull(S.employee_company_name,'')
OR isnull(T.EmpSubContractor,'') <> isnull(S.employee_subcontractor,'')
OR isnull(T.EmpDepartment,'') <> isnull(S.employee_department,'')
OR isnull(T.EmpCountry,'') <> isnull(S.employee_country,'')
OR isnull(T.EmpCity,'') <> isnull(S.employee_city,'')
)
   THEN UPDATE SET 
T.EmpUniqueRef = S.employee_unique_reference , 
T.EmpType = S.employee_type ,
T.EmpCompanyName = S.employee_company_name ,
T.EmpSubContractor = S.employee_subcontractor ,
T.EmpDepartment = S.employee_department ,
T.EmpCountry = S.employee_country ,
T.EmpCity = S.employee_city 

WHEN NOT MATCHED BY TARGET
   THEN INSERT (EmpID,EmpUniqueRef,EmpType,EmpCompanyName,EmpSubContractor,EmpJob,EmpDepartment,EmpCountry,EmpCity,StartDate)
   VALUES (S.employee_id ,S.employee_unique_reference ,S.employee_type ,S.employee_company_name,S.employee_subcontractor ,S.employee_job ,S.employee_department ,S.employee_country ,S.employee_city,cast(cast(getdate() as date) as datetime));
------------D_ValidationStatus---------------------------------
MERGE DWH.DIM.D_ValidationStatus AS T
USING (
SELECT distinct training_validation_status_code,training_validation_status FROM STG.dS.v_jpass_training
where training_validation_status_code is not null
union
SELECT distinct behavior_validation_status_code,behavior_validation_status FROM STG.ds.v_jpass_behavior
where behavior_validation_status_code is not null
union
SELECT distinct CERTIFICATE_validation_status_code,CERTIFICATE_validation_status FROM STG.ds.v_jpass_emp_certificates
where CERTIFICATE_validation_status_code is not null
) S 
ON  T.ValidationID = S.training_validation_status_code
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ValidationID,ValidationStatus)
   VALUES (S.training_validation_status_code ,S.training_validation_status);

------------D_Trainer---------------------------------
MERGE DWH.DIM.D_Trainer AS T
USING (SELECT distinct training_trainer FROM STG.ds.v_jpass_training
where training_trainer is not null and training_trainer<> '') S 
ON  T.Trainer = S.training_trainer
WHEN NOT MATCHED BY TARGET
   THEN INSERT (Trainer)
   VALUES (S.training_trainer);
------------D_BehaviorType---------------------------------
MERGE DWH.DIM.D_BehaviorType AS T
USING (select behavior_label_id,behavior_type_id,behavior_label,behavior_type from stg.ds.v_jpass_BEHAVIOR_TYPE) S 
ON  T.BehaviorTypeID = S.behavior_type_id and  T.BehaviorLabelID = S.behavior_label_id
WHEN MATCHED AND (isnull(T.BehaviorType,'') <> isnull(S.behavior_type,'') 
or isnull(T.BehaviorLabel,'') <> isnull(S.behavior_label,'') 
)
THEN UPDATE SET T.BehaviorType = S.behavior_type ,T.Behaviorlabel = S.behavior_label
WHEN NOT MATCHED BY TARGET
   THEN INSERT (BehaviorTypeID,BehaviorType,Behaviorlabel,BehaviorlabelID)
   VALUES (S.behavior_type_id ,S.behavior_type,Behavior_label,Behavior_label_ID);
------------D_Enumeration---------------------------------
MERGE DWH.DIM.D_Enumeration AS T
USING (SELECT 'JPass-'+cast([id] as nvarchar(10)) EnumID
    ,[id]
      ,[type] EnumType
      ,[code] EnumCode
      ,[label] EnumLabel
  FROM [STG].[dS].[jpass_enumeration]
union
  SELECT 'Collab-'+cast([id] as nvarchar(10)) EnumID
   , [id]
      ,[type]
      ,[code]
      ,[label]

  FROM [STG].[ds].[collab_enumeration]
  ) S 
ON  T.EnumID = S.EnumID 
WHEN MATCHED AND (isnull(T.Type,'') <> isnull(S.enumType,'') or isnull(T.Code,'') <> isnull(S.enumCode,'') or isnull(T.Label,'') <> isnull(S.EnumLabel,''))
   THEN UPDATE SET T.Type = S.EnumType, T.Code = S.EnumCode, T.Label = S.EnumLabel 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (enumID,ID,Type,Code,Label)
   VALUES (S.enumID,S.ID,S.EnumType,S.EnumCode,S.EnumLabel);
------------D_Certificate---------------------------------
--CertificateSK,CertificateID,CertificateTitle,CertificateDescription,CertificateConfidential,CertificateMedical,CertificateTypeLabel
MERGE DWH.DIM.D_Certificate AS T
USING (select certificate_id,certificate_title,
   certificate_description,certificate_medical, 
   certificate_confidential,certificate_type_label
   from stg.ds.v_jpass_CERTIFICATION) S 
ON  T.CertificateID = S.certificate_id
WHEN MATCHED AND (
isnull(T.certificatetitle,'') <> isnull(S.certificate_title,'') 
OR isnull(T.certificatedescription,'') <> isnull(S.certificate_description,'')
OR isnull(T.certificatemedical,'') <> isnull(S.certificate_medical,'')
OR isnull(T.certificateconfidential,'') <> isnull(S.certificate_confidential,'')
OR isnull(T.certificatetypelabel,'') <> isnull(S.certificate_type_label,'')
)
   THEN UPDATE SET 
   T.certificatetitle = S.certificate_title
   ,T.certificatedescription=S.certificate_description
   ,T.certificatemedical=S.certificate_medical
   ,T.certificateconfidential=S.certificate_confidential
   ,T.certificatetypelabel=S.certificate_type_label
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CertificateID,CertificateTitle,CertificateDescription,CertificateConfidential,CertificateMedical,CertificateTypeLabel)
   VALUES (Certificate_ID,Certificate_Title,Certificate_Description,Certificate_Confidential,Certificate_Medical,Certificate_Type_Label);
------------D_AccOrganization---------------------------------
MERGE DWH.DIM.D_AccOrganization AS T
USING (SELECT distinct certificate_accredited_organization FROM STG.dS.v_jpass_emp_certificates
where certificate_accredited_organization is not null and certificate_accredited_organization<> '') S 
ON  T.AccOrganization = S.certificate_accredited_organization
WHEN NOT MATCHED BY TARGET
   THEN INSERT (AccOrganization)
   VALUES (S.certificate_accredited_organization);

------------D_Behavior---------------------------------
MERGE DWH.DIM.D_Behavior AS T
USING (SELECT distinct behavior_id,behavior_req_action,behavior_description,behavior_label,behavior_type
 FROM STG.dS.v_jpass_behavior
where behavior_id is not null) S 
ON  T.BehaviorID = S.behavior_id
WHEN MATCHED AND 
(isnull(T.BehaviorReqAction,'') <> isnull(S.behavior_req_action,'') 
OR isnull(T.BehaviorDescription,'') <> isnull(S.behavior_description,'')
OR isnull(T.behaviorlabel,'') <> isnull(S.behavior_label,'')
OR isnull(T.behaviortype,'') <> isnull(S.behavior_type,'')
)
   THEN UPDATE SET 
T.BehaviorReqAction = S.behavior_req_action , 
T.BehaviorDescription = S.behavior_description,
T.behaviorlabel = S.behavior_label,
T.behaviortype = S.behavior_type

WHEN NOT MATCHED BY TARGET
   THEN INSERT (BehaviorID,BehaviorReqAction,BehaviorDescription,behaviorlabel,behaviortype,StartDate)
   VALUES (S.behavior_id ,S.behavior_req_action,S.behavior_description,behavior_label,behavior_type,cast(cast(getdate() as date) as datetime));
------------Emp Comments---------------------------------

MERGE DWH.DIM.D_EmpComments AS T
USING (select emp_training_id EmpCommentID,
  training_validation_comment ValidationComment,
  training_comment Comment
  from [STG].[dS].V_jpass_TRAINING
  where ISNULL(training_validation_comment,training_comment) is not null
  ) S 
ON  T.EmpCommentID = S.EmpCommentID
WHEN MATCHED AND (isnull(T.ValidationComment,'') <> isnull(S.ValidationComment,'') 
or isnull(T.Comment,'') <> isnull(S.Comment,'') 
)
THEN UPDATE SET T.ValidationComment = S.ValidationComment ,T.Comment = S.Comment
WHEN NOT MATCHED BY TARGET
   THEN INSERT (EmpCommentID,ValidationComment,Comment)
   VALUES (S.EmpCommentID,S.ValidationComment,S.Comment);
------------D_WorkOrder---------------------------------
MERGE DWH.DIM.D_WorkOrder AS T
USING (SELECT distinct number as WorkOrderNumber
  FROM stg.ds.collab_work_order
  ) S 
ON  T.WorkOrderNumber = S.WorkOrderNumber 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (WorkOrderNumber)
   VALUES (S.WorkOrderNumber);


END;
GO
/****** Object:  StoredProcedure [DIM].[usp_PG]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DIM].[usp_PG]
AS
BEGIN
------------D_ActivityHierarchy---------------------------------
MERGE DWH.DIM.D_ActivityHierarchy AS T
USING (SELECT distinct 
[Id] as ActivityHierarchyID
,[objectid] ActivityHierarchyObjectID
,[status] ActivityStatus
,[name] ActivityName
,[type] ActivityType
,PrimaryResourceName,
acaG02.activitycodedescription gzeroTwoSteps,
acaG12.activitycodedescription gtwelveSupplierSubs,
acaG16.activitycodedescription gsixteenDiscipline,
acaG18.activitycodedescription geighteenEarlyWarning,
acaG18a.activitycodedescription geighteenWarnActIdentifier,
acaG10.activitycodedescription gtenOcpfieldMilestone
FROM [STG].[P6].[ACTIVITY] a
LEFT JOIN [STG].[P6].[ACTIVITYCODEASSIGNMENT] acaG02 on a.objectid = acaG02.activityobjectid and a.projectobjectid=acaG02.projectobjectid and acaG02.activitycodetypename = 'G02 - JSTEPS'
LEFT JOIN [STG].[P6].[ACTIVITYCODEASSIGNMENT] acaG12 on a.objectid = acaG12.activityobjectid and a.projectobjectid=acaG12.projectobjectid and acaG12.activitycodetypename = 'G12 - Supplier / Subs'
LEFT JOIN [STG].[P6].[ACTIVITYCODEASSIGNMENT] acaG16 on a.objectid = acaG16.activityobjectid and a.projectobjectid=acaG16.projectobjectid and acaG16.activitycodetypename = 'G16 - Discipline'
LEFT JOIN [STG].[P6].[ACTIVITYCODEASSIGNMENT] acaG18 on a.objectid = acaG18.activityobjectid and a.projectobjectid=acaG18.projectobjectid and acaG18.activitycodetypename = 'G18 - Early Warning'
LEFT JOIN [STG].[P6].[ACTIVITYCODEASSIGNMENT] acaG18a on a.objectid = acaG18a.activityobjectid and a.projectobjectid=acaG18a.projectobjectid and acaG18a.activitycodetypename = 'G18a - Warning Activity Identifier'
LEFT JOIN [STG].[P6].[ACTIVITYCODEASSIGNMENT] acaG10 on a.objectid = acaG10.activityobjectid and a.projectobjectid=acaG10.projectobjectid and acaG10.activitycodetypename = 'G10 - OCP Field - Milestones'
) S 
ON  T.ActivityHierarchyID = S.ActivityHierarchyID and  T.ActivityHierarchyObjectID=S.ActivityHierarchyObjectID
WHEN MATCHED AND 
(isnull(T.ActivityStatus,'') <> isnull(S.ActivityStatus,'') OR
isnull(T.ActivityName,'') <> isnull(S.ActivityName,'') OR
isnull(T.PrimaryResourceName,'') <> isnull(S.PrimaryResourceName,'') OR 
isnull(T.ActivityType,'') <> isnull(S.ActivityType,'') OR 
isnull(T.gzeroTwoSteps,'') <> isnull(S.gzeroTwoSteps,'') OR 
isnull(T.gtwelveSupplierSubs,'') <> isnull(S.gtwelveSupplierSubs,'') OR 
isnull(T.gsixteenDiscipline,'') <> isnull(S.gsixteenDiscipline,'') OR 
isnull(T.geighteenWarnActIdentifier,'') <> isnull(S.geighteenWarnActIdentifier,'') OR 
isnull(T.geighteenEarlyWarning,'') <> isnull(S.geighteenEarlyWarning,'') OR
isnull(T.gtenOcpfieldMilestone,'') <> isnull(S.gtenOcpfieldMilestone,'') 

)
   THEN UPDATE SET T.ActivityType = S.ActivityType ,T.ActivityName = S.ActivityName ,T.ActivityStatus = S.ActivityStatus , T.gtenOcpfieldMilestone=S.gtenOcpfieldMilestone,
      T.gzeroTwoSteps = S.gzeroTwoSteps , T.gtwelveSupplierSubs = S.gtwelveSupplierSubs , T.gsixteenDiscipline = S.gsixteenDiscipline 
	  , T.geighteenWarnActIdentifier = S.geighteenWarnActIdentifier,T.geighteenEarlyWarning=S.geighteenEarlyWarning,T.PrimaryResourceName=S.PrimaryResourceName
WHEN NOT MATCHED BY TARGET
   THEN INSERT (gtenOcpfieldMilestone,PrimaryResourceName,ActivityHierarchyID,ActivityHierarchyObjectID,ActivityStatus,ActivityName,ActivityType,gzeroTwoSteps,gtwelveSupplierSubs,gsixteenDiscipline,geighteenWarnActIdentifier,geighteenEarlyWarning)
   VALUES (s.gtenOcpfieldMilestone,S.PrimaryResourceName,S.ActivityHierarchyID,S.ActivityHierarchyObjectID,S.ActivityStatus,S.ActivityName,S.ActivityType,S.gzeroTwoSteps,S.gtwelveSupplierSubs,S.gsixteenDiscipline,S.geighteenWarnActIdentifier,S.geighteenEarlyWarning);

------------D_WbsHierarchy---------------------------------
MERGE DWH.DIM.D_WbsHierarchy AS T
USING ( select distinct  
childobjectid,
childname,
fullpathname,
p.id as project_number,
h.childprojectid
from stg.p6.WBSHIERARCHY h
inner join stg.p6.PROJECT p on p.objectid = h.childprojectid
) S 
ON  T.WbsHierarchyID = S.childobjectid and T.childprojectid=S.childprojectid
WHEN MATCHED AND 
(isnull(T.WbsHierarchyName,'') <> isnull(S.childname,'') OR
isnull(T.ProjectNumber,'') <> isnull(S.project_number,'') OR
isnull(T.FullPathName,'') <> isnull(S.FullPathName,'') 
)
   THEN UPDATE SET T.WbsHierarchyName = S.childname ,T.ProjectNumber = S.project_number ,T.FullPathName = S.FullPathName 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (WbsHierarchyID,WbsHierarchyName,ProjectNumber,FullPathName,childprojectid)
   VALUES (S.childobjectid,S.childname,S.project_number,S.FullPathName,S.childprojectid);
END;
GO
/****** Object:  StoredProcedure [DIM].[usp_PROCORE]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create a stored procedure to insert a new order
CREATE PROCEDURE [DIM].[usp_PROCORE]

AS
BEGIN
  ------------D_PROC_USER---------------------------------
MERGE DWH.DIM.D_PROCUSER AS T
USING (  select distinct [id_creator] UserID
      ,[login_creator] UserLogin
      ,[name_creator] UserName
      ,[company_name_creator] UserCompanyName
,N'-' as UserType
	  from  stg.PROCORE.requisitions
	  where isnull(id_creator,'') <> ''
union
SELECT distinct 
	   [id_received_from]
	   ,[login_receiver]
	   ,[name_receiver]
	   ,name_company
,N'-'
  FROM [STG].[PROCORE].[correspondance] c
  where isnull([id_received_from],'') <> ''

  union
SELECT distinct 
	   id_creator
	   ,[login_creator]
	   ,[name_creator]
	   ,company_creator
,N'-'
  FROM [STG].[PROCORE].[correspondance] c
  where isnull(id_creator,'') <> ''
union
select distinct id_assignee
,login_assignees
,name_assignees
,company_name_assignees
,N'-'
  FROM [STG].[PROCORE].[correspondance] c
  where isnull(id_assignee,'') <> ''
union
select distinct id_distribution
,login_distribution
,name_distribution
,company_name_distribution
,N'-'
  FROM [STG].[PROCORE].[correspondance] c
  where isnull(id_distribution,'') <> ''

) S 
ON  T.UserID = S.UserID and T.UserType = S.UserType 
WHEN MATCHED AND 
(isnull(T.UserLogin,'') <> isnull(S.UserLogin,'') OR
isnull(T.UserName,'') <> isnull(S.UserName,'') OR
isnull(T.UserCompanyName,'') <> isnull(S.UserCompanyName,'') 
)
   THEN UPDATE SET 
   T.UserName = S.UserName ,
   T.UserCompanyName = S.UserCompanyName
WHEN NOT MATCHED BY TARGET
   THEN INSERT (UserLogin,UserName,UserCompanyName,UserID,UserType)
   VALUES (S.UserLogin,S.UserName,S.UserCompanyName,S.UserID,S.UserType);
------------DATA FLOW TASK---------------------------------
INSERT INTO DWH.DIM.D_PROCUSER (UserID, UserName, UserType)
SELECT DISTINCT 
    [user_id], 
    [name], 
    N'-' AS UserType
FROM [STG].[PROCORE].[ProjectRoles] u
WHERE NOT EXISTS (
    SELECT 1 
    FROM DWH.DIM.D_PROCUSER d 
    WHERE d.UserID = u.user_id
);
------------D_PROC_CONTRACT---------------------------------

MERGE DWH.DIM.D_PROCCONTRACT AS T
USING (  SELECT c.[id] ContractID 
	  ,vendor_company ContractorName
	  ,r.commitment_type CommitmentType
      ,[actual_completion_date] CompletionDate
	  ,[accounting_method] AccountingMethod
      ,[contract_date] ContractDate
      ,[contract_estimated_completion_date] ContractEstCompletionDate
      ,[contract_start_date]  ContractStartDate
      ,[description] ContractDescription
	  ,[inclusions]  ContractInclusion
	  ,[title] ContractTitle
	  ,[number] ContractNumber
	  ,custom_fields_custom_field_78686_value ContractCurrency

  FROM [STG].[PROCORE].[commitments_subcontracts_work_order] c
  outer apply (select distinct commitment_type from stg.PROCORE.requisitions r where r.commitment_id = c.id)r
) S 
ON  T.ContractID = S.ContractID
WHEN MATCHED AND 
(isnull(T.ContractorName,'') <> isnull(S.ContractorName,'') OR
isnull(T.CommitmentType,'') <> isnull(S.CommitmentType,'') OR
isnull(T.ContractTitle,'') <> isnull(S.ContractTitle,'') OR
isnull(T.ContractNumber,'') <> isnull(S.ContractNumber,'') OR
isnull(T.CompletionDate,'9999-12-31') <> isnull(S.CompletionDate,'9999-12-31') OR
isnull(T.ContractDate,'9999-12-31') <> isnull(S.ContractDate,'9999-12-31') OR
isnull(T.ContractEstCompletionDate,'9999-12-31') <> isnull(S.ContractEstCompletionDate,'9999-12-31') OR
isnull(T.ContractStartDate,'9999-12-31') <> isnull(S.ContractStartDate,'9999-12-31') OR
isnull(T.AccountingMethod,'') <> isnull(S.AccountingMethod,'') OR
isnull(T.ContractDescription,'') <> isnull(S.ContractDescription,'') OR
isnull(T.ContractCurrency,'') <> isnull(S.ContractCurrency,'') OR
isnull(T.ContractInclusion,'') <> isnull(S.ContractInclusion,'') 
)
THEN UPDATE SET T.ContractorName = S.ContractorName ,
T.CommitmentType = S.CommitmentType ,
T.CompletionDate = S.CompletionDate ,
T.ContractDate = S.ContractDate ,
T.ContractEstCompletionDate = S.ContractEstCompletionDate ,
T.ContractStartDate = S.ContractStartDate ,
T.AccountingMethod = S.AccountingMethod ,
T.ContractDescription = S.ContractDescription ,
T.ContractInclusion = S.ContractInclusion ,
T.ContractNumber=S.ContractNumber,
T.ContractTitle=S.ContractTitle,
T.ContractCurrency=s.ContractCurrency
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ContractCurrency,ContractTitle,ContractNumber,ContractID,ContractorName,CommitmentType,CompletionDate,ContractDate,ContractEstCompletionDate,ContractStartDate,AccountingMethod,ContractDescription,ContractInclusion)
   VALUES (S.ContractCurrency,S.ContractTitle,S.ContractNumber,S.ContractID,S.ContractorName,S.CommitmentType,S.CompletionDate,S.ContractDate,S.ContractEstCompletionDate,S.ContractStartDate,S.AccountingMethod,S.ContractDescription,S.ContractInclusion);

------------D_EventType---------------------------------
MERGE DWH.DIM.D_EventType AS T
USING (  SELECT DISTINCT isnull([event_type],'-') EventType,isnull([event_scope],'-')    EventScope
 FROM [STG].[PROCORE].[change_events]
) S 
ON  T.EventType = S.EventType and t.EventScope=s.EventScope
WHEN NOT MATCHED BY TARGET
   THEN INSERT (EventType,EventScope)
   VALUES (S.EventType,S.EventScope);
------------D_ProcCorrespStatus---------------------------------
MERGE DWH.DIM.D_ProcCorrespStatus AS T
USING (  
SELECT  distinct [status] Status,status_type  FROM [STG].[PROCORE].v_correspondance c where isnull([status],'') <> ''
) S 
ON  T.ProccorrespStatus = S.Status and T.ProccorrespStatusType=S.status_type
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ProccorrespStatus,ProccorrespStatusType)
   VALUES (S.Status,S.status_type);
------------D_Insurance---------------------------------
MERGE DWH.DIM.D_Insurance AS T
USING (
select *
from (  SELECT distinct [id] InsID
,[policy_number] InsPolicyNumber
      ,[description] InsDescription
      ,[title] InsTitle
      ,[contractor] InsContractor
	  ,[currency] InsCurrency
      ,[position_correspondance] InsPositionCorresp
	  ,[company_project_insurance] InsCompanyProjInsurance
      ,[commitment_number] InsCommitmentNumber
	  ,row_number() over (partition by [id] order by [contractor] desc) ord
	  
  FROM [STG].[PROCORE].[v_correspondance] c
  where title_generic_tool ='Insurance')x
  where x.ord>0
) S 
ON  T.InsID = S.InsID
WHEN MATCHED AND 
(isnull(T.InsPolicyNumber,'') <> isnull(S.InsPolicyNumber,'') OR 
isnull(T.InsPositionCorresp,'') <> isnull(S.InsPositionCorresp,'') OR 
isnull(T.InsCommitmentNumber,'') <> isnull(S.InsCommitmentNumber,'') OR 
isnull(T.InsTitle,'') <> isnull(S.InsTitle,'') OR 
isnull(T.InsContractor,'') <> isnull(S.InsContractor,'') OR 
isnull(T.InsDescription,'') <> isnull(S.InsDescription,'') OR 
isnull(T.InsCurrency,'') <> isnull(S.InsCurrency,'') OR 
isnull(T.InsCompanyProjInsurance,'') <> isnull(S.InsCompanyProjInsurance,'') 
)
   THEN UPDATE SET T.InsPolicyNumber = S.InsPolicyNumber,
T.InsPositionCorresp = S.InsPositionCorresp,
T.InsCommitmentNumber = S.InsCommitmentNumber,
T.InsTitle = S.InsTitle,
T.InsContractor = S.InsContractor,
T.InsDescription = S.InsDescription,
T.InsCurrency = S.InsCurrency,
T.InsCompanyProjInsurance = S.InsCompanyProjInsurance
WHEN NOT MATCHED BY TARGET
   THEN INSERT (InsID	,
InsPolicyNumber	,
InsPositionCorresp	,
InsCommitmentNumber	,
InsTitle	,
InsContractor	,
InsDescription	,
InsCurrency	,
InsCompanyProjInsurance	)
   VALUES (S.InsID	,
S.InsPolicyNumber	,
S.InsPositionCorresp	,
S.InsCommitmentNumber	,
S.InsTitle	,
S.InsContractor	,
S.InsDescription	,
S.InsCurrency	,
S.InsCompanyProjInsurance	
);
------------D_PDN---------------------------------

MERGE DWH.DIM.D_PDN AS T
USING (  SELECT distinct c.id PDNID,position_correspondance PDNPosCorresp,title PDNTitle,cost_impact PDNCostImpact
,status_cost PDNstatusCost,c.description PDNDescription,c.commitment_number PDNCommitmentNumber,c.contractor PDNContractor
,c.trade PDNTrade,c.name_trades PDNNameTrades,c.change_justification PDNChangeJustif,cast(currency as nvarchar(10)) Currency
FROM [STG].[PROCORE].[v_correspondance] c
where title_generic_tool='Potential Deviation Notice'
) S 
ON  T.PDNID = S.PDNID
WHEN MATCHED AND 
(isnull(T.PDNPosCorresp,'') <> isnull(S.PDNPosCorresp,'') OR 
isnull(T.PDNTitle,'') <> isnull(S.PDNTitle,'') OR 
isnull(T.PDNCostImpact,'') <> isnull(S.PDNCostImpact,'') OR 
isnull(T.PDNstatusCost,'') <> isnull(S.PDNstatusCost,'') OR 
isnull(T.PDNDescription,'') <> isnull(S.PDNDescription,'') OR 
isnull(T.PDNCommitmentNumber,'') <> isnull(S.PDNCommitmentNumber,'') OR 
isnull(T.PDNContractor,'') <> isnull(S.PDNContractor,'') OR 
isnull(T.PDNTrade,'') <> isnull(S.PDNTrade,'') OR 
isnull(T.PDNNameTrades,'') <> isnull(S.PDNNameTrades,'') OR 
isnull(T.PDNChangeJustif,'') <> isnull(S.PDNChangeJustif,'') OR 
isnull(T.Currency,'') <> isnull(S.Currency,'') 
)
   THEN UPDATE SET 
   T.PDNPosCorresp = S.PDNPosCorresp,
T.PDNTitle = S.PDNTitle,
T.PDNCostImpact = S.PDNCostImpact,
T.PDNstatusCost = S.PDNstatusCost,
T.PDNDescription = S.PDNDescription,
T.PDNCommitmentNumber = S.PDNCommitmentNumber,
T.PDNContractor = S.PDNContractor,
T.PDNTrade = S.PDNTrade,
T.PDNNameTrades = S.PDNNameTrades,
T.PDNChangeJustif = S.PDNChangeJustif,
T.Currency = S.Currency

WHEN NOT MATCHED BY TARGET
   THEN INSERT (PDNID,PDNPosCorresp,PDNTitle,PDNCostImpact,PDNstatusCost,PDNDescription,PDNCommitmentNumber,PDNContractor,PDNTrade,PDNNameTrades,PDNChangeJustif,Currency)
   VALUES (S.PDNID,S.PDNPosCorresp,S.PDNTitle,S.PDNCostImpact,S.PDNstatusCost,S.PDNDescription,S.PDNCommitmentNumber,S.PDNContractor,S.PDNTrade,S.PDNNameTrades,S.PDNChangeJustif,S.Currency);

------------D_ChangeRequest---------------------------------

MERGE DWH.DIM.D_ChangeRequest AS T
USING (  select distinct 
	C.id CRID
	,c.description CRDescription
	,c.commitment_number CRCommitmentNumber
	,c.change_justification CRChangeJustif
	,c.position_correspondance CRPosCorresp
	,c.title CRTitle
	,Currency
FROM [STG].[PROCORE].[v_correspondance] c
where title_generic_tool='Change Request'
) S 
ON  T.CRID = S.CRID
WHEN MATCHED AND 
(
isnull(t.CRPosCorresp,'') <> isnull(s.CRPosCorresp,'') OR 
isnull(t.CRTitle,'') <> isnull(s.CRTitle,'') OR 
isnull(t.CRDescription,'') <> isnull(s.CRDescription,'') OR 
isnull(t.CRCommitmentNumber,'') <> isnull(s.CRCommitmentNumber,'') OR 
isnull(t.CRChangeJustif,'') <> isnull(s.CRChangeJustif,'') OR 
isnull(t.Currency,'') <> isnull(s.Currency,'') 
)
   THEN UPDATE SET 
	T.CRPosCorresp= S.CRPosCorresp,
	T.CRTitle= S.CRTitle,
	T.CRDescription= S.CRDescription,
	T.CRCommitmentNumber= S.CRCommitmentNumber,
	T.CRChangeJustif= S.CRChangeJustif,
	T.Currency= S.Currency

WHEN NOT MATCHED BY TARGET
   THEN INSERT (CRID	,CRPosCorresp	,CRTitle	,CRDescription	,CRCommitmentNumber	,CRChangeJustif	,Currency	
)
   VALUES (s.CRID	,s.CRPosCorresp	,s.CRTitle	,s.CRDescription	,s.CRCommitmentNumber	,s.CRChangeJustif	,s.Currency	);

------------D_SubContracting---------------------------------
MERGE DWH.DIM.D_SubContracting AS T
USING (  
select distinct id SubContractingID,
position_correspondance SubContractingPositionCorresp,
title SubContractingTitle,
contractor SubContractingContractor,

[subcontractor_name] SubContractingName
      ,[subcontractor_address] SubContractingAddress
      ,[subcontractor_email_address] SubContractingEmailAddress
      ,[subcontractor_city] SubContractingCity
      ,[subcontractor_country] SubContractingCountry
      ,[subcontractor_phone_number] SubContractingPhoneNumber
      ,[subcontractor_contact_name] SubContractingContactName
      ,[subcontractor_job_title] SubContractingJobTitle
      ,[subcontractor_scope_of_work] SubContractingScopeOfWork
      ,[subcontractor_nb] SubContractingNB
	    FROM [STG].[PROCORE].[v_correspondance]
		where title_generic_tool ='Subcontracting Request'
		
) S 
ON  T.SubContractingID = S.SubContractingID
WHEN MATCHED AND 
(
isnull(t.[SubContractingPositionCorresp],'') <> isnull(s.[SubContractingPositionCorresp],'') OR 
isnull(t.[SubContractingTitle],'') <> isnull(s.[SubContractingTitle],'') OR 
isnull(t.[SubContractingContractor],'') <> isnull(s.[SubContractingContractor],'') OR 
isnull(t.[SubContractingName],'') <> isnull(s.[SubContractingName],'') OR 
isnull(t.[SubContractingAddress],'') <> isnull(s.[SubContractingAddress],'') OR 
isnull(t.[SubContractingEmailAddress],'') <> isnull(s.[SubContractingEmailAddress],'') OR 
isnull(t.[SubContractingCity],'') <> isnull(s.[SubContractingCity],'') OR 
isnull(t.[SubContractingCountry],'') <> isnull(s.[SubContractingCountry],'') OR 
isnull(t.[SubContractingPhoneNumber],'') <> isnull(s.[SubContractingPhoneNumber],'') OR 
isnull(t.[SubContractingContactName],'') <> isnull(s.[SubContractingContactName],'') OR 
isnull(t.[SubContractingJobTitle],'') <> isnull(s.[SubContractingJobTitle],'') OR 
isnull(t.[SubContractingScopeOfWork],'') <> isnull(s.[SubContractingScopeOfWork],'') OR 
isnull(t.[SubContractingNB],'') <> isnull(s.[SubContractingNB],'')  
)
   THEN UPDATE SET T.[SubContractingPositionCorresp] = S.[SubContractingPositionCorresp] ,
T.[SubContractingTitle] = S.[SubContractingTitle] ,
T.[SubContractingContractor] = S.[SubContractingContractor] ,
T.[SubContractingName] = S.[SubContractingName] ,
T.[SubContractingAddress] = S.[SubContractingAddress] ,
T.[SubContractingEmailAddress] = S.[SubContractingEmailAddress] ,
T.[SubContractingCity] = S.[SubContractingCity] ,
T.[SubContractingCountry] = S.[SubContractingCountry] ,
T.[SubContractingPhoneNumber] = S.[SubContractingPhoneNumber] ,
T.[SubContractingContactName] = S.[SubContractingContactName] ,
T.[SubContractingJobTitle] = S.[SubContractingJobTitle] ,
T.[SubContractingScopeOfWork] = S.[SubContractingScopeOfWork] ,
T.[SubContractingNB] = S.[SubContractingNB] 
WHEN NOT MATCHED BY TARGET
   THEN INSERT ([SubContractingID]	,
[SubContractingPositionCorresp]	,
[SubContractingTitle]	,
[SubContractingContractor]	,
[SubContractingName]	,
[SubContractingAddress]	,
[SubContractingEmailAddress]	,
[SubContractingCity]	,
[SubContractingCountry]	,
[SubContractingPhoneNumber]	,
[SubContractingContactName]	,
[SubContractingJobTitle]	,
[SubContractingScopeOfWork]	,
[SubContractingNB])
   VALUES (S.[SubContractingID],
S.[SubContractingPositionCorresp],
S.[SubContractingTitle],
S.[SubContractingContractor],
S.[SubContractingName],
S.[SubContractingAddress],
S.[SubContractingEmailAddress],
S.[SubContractingCity],
S.[SubContractingCountry],
S.[SubContractingPhoneNumber],
S.[SubContractingContactName],
S.[SubContractingJobTitle],
S.[SubContractingScopeOfWork],
S.[SubContractingNB]);

------------D_Vendor---------------------------------

MERGE DWH.DIM.D_VENDOR AS T
USING (  select distinct  [id] VendorID
      ,[abbreviated_name] VendorAbrvName
      ,[company] VendorName
      ,[country_code] VendorCountry
      ,[city] VendorCity
      ,[address] VendorAddress
  FROM [STG].[PROCORE].[company_vendor]
) S 
ON  T.VendorID = S.VendorID
WHEN MATCHED AND 
(
isnull(T.VendorName,'') <> isnull(S.VendorName,'') OR 
isnull(T.VendorAbrvName,'') <> isnull(S.VendorAbrvName,'') OR 
isnull(T.VendorCountry,'') <> isnull(S.VendorCountry,'') OR 
isnull(T.VendorCity,'') <> isnull(S.VendorCity,'') OR 
isnull(T.VendorAddress,'') <> isnull(S.VendorAddress,'')  
)
   THEN UPDATE SET T.VendorName = S.VendorName,
   T.VendorAbrvName=S.VendorAbrvName,
   T.VendorCountry=S.VendorCountry,
   T.VendorCity=S.VendorCity,
   T.VendorAddress=S.VendorAddress
WHEN NOT MATCHED BY TARGET
   THEN INSERT (VendorID,VendorName,VendorAbrvName,VendorCountry,VendorCity,VendorAddress)
   VALUES (S.VendorID,S.VendorName,S.VendorAbrvName,S.VendorCountry,S.VendorCity,S.VendorAddress);

------------D_CostCode---------------------------------
MERGE DWH.DIM.D_CostCode AS T
USING (  select distinct 
  [id_cost_code] CostCodeID
  ,  [name_cost_code] CostCodeName
FROM [STG].[PROCORE].[change_events]
where  [id_cost_code] is not null
) S 
ON  T.CostCodeID = S.CostCodeID
WHEN MATCHED AND 
(isnull(T.CostCodeName,'') <> isnull(S.CostCodeName,'') 
)
  THEN UPDATE SET T.CostCodeName = S.CostCodeName
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CostCodeID,CostCodeName)
   VALUES (S.CostCodeID,S.CostCodeName);

------------D_CostCalc---------------------------------
MERGE DWH.DIM.D_CostCalc AS T
USING (  select distinct isnull([uom],'-') CostCalcUom, isnull([estimated_cost_calculation_strategy],'-') CostCalcStrategy
from [STG].[PROCORE].[change_events]
) S 
ON  T.CostCalcUom = S.CostCalcUom and T.CostCalcStrategy=S.CostCalcStrategy
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CostCalcUom,CostCalcStrategy)
   VALUES (S.CostCalcUom,S.CostCalcStrategy);

------------D_ProcStatus---------------------------------
MERGE DWH.DIM.D_ProcStatus AS T
USING (  
select distinct status ProcStatus from [STG].[PROCORE].[commitments_subcontracts_work_order] c where isnull([status],'') <> ''
union
SELECT  distinct [status] InsStatus  FROM [STG].[PROCORE].[project_insurrance] c where isnull([status],'') <> ''
union
SELECT distinct [status] ReqStatus FROM [STG].[PROCORE].[requisitions] where isnull(status,'') <> ''
union
SELECT distinct [status]   VarStatus FROM [STG].[PROCORE].[variation] where isnull([status],'') <> ''
union
select distinct status ChangeStatus from stg.PROCORE.change_events  where isnull([status],'') <> ''

) S 
ON  T.ProcStatus = S.ProcStatus
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ProcStatus)
   VALUES (S.ProcStatus);

------------D_CorresDetail---------------------------------
MERGE DWH.DIM.D_CorrespDetail AS T
USING (  

select *
from (
SELECT distinct 
		id CorrespID,
      [position_correspondance] CorrespPosition
      ,[private] isPrivate
      ,[status] CorrespStatus
      ,[title] CorrespTitle
      ,[unformatted_position] CorrespUnformPosition
	  ,[description] CorrespDescription
	  ,Commitment_Number CommitmentNumber
	  ,Area CorrespArea
	  ,Question_box CorrespQuestionBox
	  ,Importance CorrespImportance
	  ,Replier_name CorrespReplierName
	  ,Contractor CorrespContractor
	  ,Comment CorrespComment
	  ,Answer CorrespAnswer
	  ,ROW_NUMBER() over(partition by id order by Commitment_Number desc) ord
  FROM [STG].[PROCORE].[v_correspondance]
 where  title_generic_tool in ('Letter','Request For Information')
)x where x.ord>0

) S 
ON  T.CorrespID = S.CorrespID
WHEN MATCHED AND 
(isnull(T.CommitmentNumber,'') <> isnull(S.CommitmentNumber,'') OR
isnull(T.CorrespArea,'') <> isnull(S.CorrespArea,'') OR
isnull(T.CorrespQuestionBox,'') <> isnull(S.CorrespQuestionBox,'') OR
isnull(T.CorrespImportance,'') <> isnull(S.CorrespImportance,'') OR
isnull(T.CorrespPosition,'') <> isnull(S.CorrespPosition,'') OR
isnull(T.CorrespReplierName,'') <> isnull(S.CorrespReplierName,'') OR
isnull(T.CorrespContractor,'') <> isnull(S.CorrespContractor,'') OR
isnull(T.CorrespComment,'') <> isnull(S.CorrespComment,'') OR
isnull(T.CorrespAnswer,'') <> isnull(S.CorrespAnswer,'') OR
isnull(T.isPrivate,'') <> isnull(S.isPrivate,'') OR
isnull(T.CorrespStatus,'') <> isnull(S.CorrespStatus,'') OR
isnull(T.CorrespTitle,'') <> isnull(S.CorrespTitle,'') OR
isnull(T.CorrespUnformPosition,'') <> isnull(S.CorrespUnformPosition,'') OR
isnull(T.CorrespDescription,'') <> isnull(S.CorrespDescription,'') 
)
   THEN UPDATE SET T.CorrespPosition = S.CorrespPosition ,
   T.isPrivate = S.isPrivate,
   T.CorrespStatus = S.CorrespStatus,
   T.CorrespTitle = S.CorrespTitle,
   T.CorrespUnformPosition = S.CorrespUnformPosition,
   T.CorrespDescription = S.CorrespDescription,
   T.CommitmentNumber=S.CommitmentNumber,
   T.CorrespArea=S.CorrespArea,
   T.CorrespQuestionBox=S.CorrespQuestionBox,
   T.CorrespImportance=S.CorrespImportance,
   T.CorrespReplierName=S.CorrespReplierName,
   T.CorrespContractor=S.CorrespContractor,
   T.CorrespComment=S.CorrespComment,
   T.CorrespAnswer=S.CorrespAnswer
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CorrespID,CorrespPosition,CorrespStatus
,CorrespTitle,CorrespUnformPosition,CorrespDescription,isPrivate,CommitmentNumber,CorrespArea,CorrespQuestionBox,CorrespImportance,CorrespReplierName,CorrespContractor,CorrespComment,CorrespAnswer)
   VALUES (S.CorrespID,S.CorrespPosition,S.CorrespStatus
,S.CorrespTitle,S.CorrespUnformPosition,S.CorrespDescription,S.isPrivate,S.CommitmentNumber,S.CorrespArea,S.CorrespQuestionBox,S.CorrespImportance,S.CorrespReplierName,S.CorrespContractor,S.CorrespComment,S.CorrespAnswer);

------------D_BankGuarantee---------------------------------
MERGE [DWH].[DIM].[D_BankGuarantee] AS T
USING (

select distinct
		[id] BGID
		,[bank_guarantee_type] BKType
		,[milestone] BKMilestone
		,[description] BKDescription
		,[position_correspondance] BKPositionCorresp
		,[title] BKTitle
		,[bank_guarantee_provider] BKProvider
		,[contractor] BKContractor
		,[commitment_number] BKCommitmentNumber
		,[reference] BKReference
		,[currency] BKCurrency
		
	FROM [STG].[PROCORE].[v_correspondance]  c
  where title_generic_tool='Bank Guarantee'
) S 
ON  T.BGID = S.BGID
WHEN MATCHED AND 
(
isnull(t.[BKType],'') <> isnull(s.[BKType],'') OR 
isnull(t.[BKMilestone],'') <> isnull(s.[BKMilestone],'') OR 
isnull(t.[BKDescription],'') <> isnull(s.[BKDescription],'') OR 
isnull(t.[BKPositionCorresp],'') <> isnull(s.[BKPositionCorresp],'') OR 
isnull(t.[BKTitle],'') <> isnull(s.[BKTitle],'') OR 
isnull(t.[BKProvider],'') <> isnull(s.[BKProvider],'') OR 
isnull(t.[BKContractor],'') <> isnull(s.[BKContractor],'') OR 
isnull(t.[BKCommitmentNumber],'') <> isnull(s.[BKCommitmentNumber],'') OR 
isnull(t.[BKReference],'') <> isnull(s.[BKReference],'') OR 
isnull(t.[BKCurrency],'') <> isnull(s.[BKCurrency],'') 
)
   THEN UPDATE SET 
   T.[BKType] = S.[BKType] ,
T.[BKMilestone] = S.[BKMilestone] ,
T.[BKDescription] = S.[BKDescription] ,
T.[BKPositionCorresp] = S.[BKPositionCorresp] ,
T.[BKTitle] = S.[BKTitle] ,
T.[BKProvider] = S.[BKProvider] ,
T.[BKContractor] = S.[BKContractor] ,
T.[BKCommitmentNumber] = S.[BKCommitmentNumber] ,
T.[BKReference] = S.[BKReference] ,
T.[BKCurrency] = S.[BKCurrency]

WHEN NOT MATCHED BY TARGET
   THEN INSERT ([BGID]	,
[BKType]	,
[BKMilestone]	,
[BKDescription]	,
[BKPositionCorresp]	,
[BKTitle]	,
[BKProvider]	,
[BKContractor]	,
[BKCommitmentNumber]	,
[BKReference]	,
[BKCurrency]	
	)
   VALUES (S.[BGID],
S.[BKType],
S.[BKMilestone],
S.[BKDescription],
S.[BKPositionCorresp],
S.[BKTitle],
S.[BKProvider],
S.[BKContractor],
S.[BKCommitmentNumber],
S.[BKReference],
S.[BKCurrency]
);

------------D_Attachment---------------------------------
MERGE DWH.DIM.D_Attachment AS T
USING (  select distinct [attachments_id]  AttachmentID
      ,[attachments_url] AttachmentURL
	  ,[attachments_filename] AttachmentFileName
  FROM [STG].[PROCORE].[ContractPayment] 
  where [attachments_id] is not null
) S 
ON  T.AttachmentID = S.AttachmentID
WHEN MATCHED AND 
(
isnull(t.AttachmentID,'') <> isnull(s.AttachmentID,'') OR 
isnull(t.AttachmentURL,'') <> isnull(s.AttachmentURL,'') OR 
isnull(t.AttachmentFileName,'') <> isnull(s.AttachmentFileName,'') 
)
   THEN UPDATE SET 
T.AttachmentID = S.AttachmentID ,
T.AttachmentURL = S.AttachmentURL ,
T.AttachmentFileName = S.AttachmentFileName 

WHEN NOT MATCHED BY TARGET
   THEN INSERT (AttachmentID,AttachmentURL,AttachmentFileName)
   VALUES (S.AttachmentID,S.AttachmentURL,S.AttachmentFileName);

------------D_InsuranceType---------------------------------
MERGE DWH.DIM.D_InsuranceType AS T
USING (   select distinct insurance_type InsType FROM [STG].[PROCORE].[v_correspondance] c where title_generic_tool ='Insurance' and isnull([insurance_type],'') <> ''
) S 
ON  T.InsType = S.InsType
WHEN NOT MATCHED BY TARGET
   THEN INSERT (InsType)
   VALUES (S.InsType);
   
------------Update ins type unified---------------------------------
update DWH.DIM.D_InsuranceType
set InsTypeUnified = case 
						when InsType=N'AT' then N'Accident de travail ( AT)'
						when InsType=N'RC' then N'Other'
						when InsType=N'TRC' then N'Tous Risques Chantier (TRC)'
						when InsType=N'Accident de travail' then N'Accident de travail ( AT)'
						when InsType=N'Accidents  de travail' then N'Accident de travail ( AT)'
						when InsType=N'Flotte Automobile' then N'Other'
						when InsType=N'Multirisques industriels' then N'Other'
						when InsType=N'Responsabilité civile exploitataion' then N'Other'
						when InsType=N'Responsabilité Civile Exploitation' then N'Other'
						when InsType=N'Responsabilité civile professionnelle' then N'Responsabilité civile Professionnelle (RCP)'
						when InsType=N'Tous risques chantier' then N'Tous Risques Chantier (TRC)'
						when InsType=N'Tous risques chantier TRC' then N'Tous Risques Chantier (TRC)'
						when InsType=N'TRANSORT tous risques' then N'Tous Risque Transport (TRT)'
						else InsType
						end 

------------D_InsuranceProvider---------------------------------
MERGE DWH.DIM.D_InsuranceProvider AS T
USING (  select distinct insurance_provider InsProviderName FROM [STG].[PROCORE].[v_correspondance] c where title_generic_tool ='Insurance' and isnull(insurance_provider,'') <> ''
) S 
ON  T.InsProviderName = S.InsProviderName
WHEN NOT MATCHED BY TARGET
   THEN INSERT (InsProviderName)
   VALUES (S.InsProviderName);

------------D_ChangeOrderRequest---------------------------------
MERGE DWH.DIM.D_ChangeOrderRequest AS T
USING (  SELECT distinct [change_order_request_id] CORID
      ,[change_order_request_title] CORTitle
      ,[change_order_package_title] COPTitle
      ,[potential_change_order_acronym_number] CORPotAcrNumber
      ,[change_order_request_acronym_number] CORAcrNumber
      ,[change_order_package_acronym_number] COPAcrNumber
      ,[change_order_tiers] COTiers     
  FROM [STG].[PROCORE].[variation] c
  where isnull([change_order_request_id],'')<>''

) S 
ON  T.CORID = S.CORID
WHEN MATCHED AND 
(isnull(T.CORTitle,'') <> isnull(S.CORTitle,'') OR
isnull(T.COPTitle,'') <> isnull(S.COPTitle,'') OR
isnull(T.CORPotAcrNumber,'') <> isnull(S.CORPotAcrNumber,'') OR
isnull(T.CORAcrNumber,'') <> isnull(S.CORAcrNumber,'') OR
isnull(T.COPAcrNumber,'') <> isnull(S.COPAcrNumber,'') OR
isnull(T.COTiers,'') <> isnull(S.COTiers,'') 
)
   THEN UPDATE SET T.CORTitle = S.CORTitle ,
   T.COPTitle = S.COPTitle ,
   T.CORPotAcrNumber = S.CORPotAcrNumber,
   T.CORAcrNumber=S.CORAcrNumber,
   T.COPAcrNumber=S.COPAcrNumber,
   T.COTiers=S.COTiers
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CORID,CORTitle,COPTitle,CORPotAcrNumber,CORAcrNumber,COPAcrNumber,COTiers)
   VALUES (S.CORID,S.CORTitle,S.COPTitle,S.CORPotAcrNumber,S.CORAcrNumber,S.COPAcrNumber,S.COTiers);
   
------------D_CorrespType---------------------------------
MERGE DWH.DIM.D_CorrespType AS T
USING (  SELECT distinct [id_generic_tool] CorrespTypeID
      ,case when [abbreviation_generic_tool] is null and [title_generic_tool]='Request For Information'
	  then N'RFI'
	  Else [abbreviation_generic_tool] end as CorrespType
      ,[title_generic_tool] CorrespTypeName
      
  FROM [STG].[PROCORE].[correspondance]


) S 
ON  T.CorrespTypeID = S.CorrespTypeID
WHEN MATCHED AND 
(isnull(T.CorrespType,'') <> isnull(S.CorrespType,'') OR
isnull(T.CorrespTypeName,'') <> isnull(S.CorrespTypeName,'') 
)
   THEN UPDATE SET T.CorrespType = S.CorrespType ,
   T.CorrespTypeName = S.CorrespTypeName
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CorrespTypeID,CorrespType,CorrespTypeName)
   VALUES (S.CorrespTypeID,S.CorrespType,S.CorrespTypeName);

------------D_PayIssued---------------------------------

MERGE DWH.DIM.D_PayIssued AS T
USING (  select distinct [id]  PayIssuedID
      ,[check_number] CheckNumber
	  ,[invoice_number] InvoiceNumber
	  ,[payment_number] PaymentNumber
	  ,[notes] Notes
	  ,[payment_method] PaymentMethod

  FROM [STG].[PROCORE].[ContractPayment]
  
) S 
ON  T.PayIssuedID = S.PayIssuedID
WHEN MATCHED AND 
(
isnull(t.PayIssuedID,'') <> isnull(s.PayIssuedID,'') OR 
isnull(t.CheckNumber,'') <> isnull(s.CheckNumber,'') OR 
isnull(t.InvoiceNumber,'') <> isnull(s.InvoiceNumber,'') OR 
isnull(t.PaymentNumber,'') <> isnull(s.PaymentNumber,'') OR 
isnull(t.Notes,'') <> isnull(s.Notes,'') OR 
isnull(t.PaymentMethod,'') <> isnull(s.PaymentMethod,'')
)
   THEN UPDATE SET 
	T.CheckNumber = S.CheckNumber ,
T.InvoiceNumber = S.InvoiceNumber ,
T.PaymentNumber = S.PaymentNumber ,
T.Notes = S.Notes ,
T.PaymentMethod = S.PaymentMethod 

WHEN NOT MATCHED BY TARGET
   THEN INSERT (PayIssuedID	,CheckNumber	,InvoiceNumber	,PaymentNumber	,Notes	,PaymentMethod		)
   VALUES (S.PayIssuedID,S.CheckNumber,S.InvoiceNumber,S.PaymentNumber,S.Notes,S.PaymentMethod	);

------------D_ProjectRole---------------------------------
 MERGE DWH.DIM.D_ProjectRole AS T
USING (  select distinct role ProjectRole from [STG].[PROCORE].[ProjectRoles] r where role is not null
) S 
ON  T.ProjectRole = S.ProjectRole
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ProjectRole)
   VALUES (S.ProjectRole);
   
END;
GO
/****** Object:  StoredProcedure [DIM].[usp_QA]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DIM].[usp_QA]
AS
BEGIN
------------D_Result---------------------------------
MERGE DWH.DIM.D_Result AS T
USING (select distinct activity_result,activity_result_code
from STG.ds.QA_ACTIVITY_TRANS
where activity_result_code is not null) S 
ON  T.ResultCode = S.activity_result_code
WHEN MATCHED AND isnull(T.ResultLabel,'') <> isnull(S.activity_result,'') 
   THEN UPDATE SET T.ResultLabel = S.activity_result 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ResultCode,ResultLabel)
   VALUES (S.activity_result_code,S.activity_result);

------------D_Enumeration---------------------------------
MERGE DWH.DIM.D_Enumeration AS T
USING (SELECT 'QA-'+cast([id] as nvarchar(10)) EnumID
   ,[id]
      ,[type] EnumType
      ,[code] EnumCode
      ,[label] EnumLabel
  FROM [STG].[ds].[qa_enumeration] ) S 
ON  T.EnumID = S.EnumID 
WHEN MATCHED AND (isnull(T.Type,'') <> isnull(S.EnumType,'') or isnull(T.Code,'') <> isnull(S.EnumCode,'') or isnull(T.Label,'') <> isnull(S.EnumLabel,''))
   THEN UPDATE SET T.Type = S.EnumType, T.Code = S.EnumCode, T.Label = S.EnumLabel 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (enumID,ID,Type,Code,Label)
   VALUES (S.enumID,S.ID,S.EnumType,S.EnumCode,S.EnumLabel);
------------D_OverdueRating---------------------------------
MERGE DWH.DIM.D_OverdueRating AS T
USING (select distinct capa_overdue_rating,capa_overdue_rating_code
from stg.ds.v_qa_CAPA
where capa_overdue_rating_code is not null ) S 
ON  T.CapaOverdueRatingCode = S.capa_overdue_rating_code 
WHEN MATCHED AND isnull(T.CapaOverdueRating,'') <> isnull(S.capa_overdue_rating,'')
   THEN UPDATE SET T.CapaOverdueRating = S.capa_overdue_rating 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CapaOverdueRatingCode,CapaOverdueRating)
   VALUES (S.capa_overdue_rating_code,S.capa_overdue_rating);
------------D_CacheAdUsers---------------------------------
MERGE DWH.DIM.D_CacheAdUsers AS T
USING (select cache_ad_user_id,
user_last_name,
user_first_name,
case when user_last_name is not null or user_first_name is not null then isnull(user_last_name,'') +' ' +isnull(user_first_name,'')
else SUBSTRING(user_email, 0, charindex('@', user_email, 0)) end user_full_name,
user_email,
user_deleted,
SourceSystem,
user_phone
from STG.ds.v_qa_user

) S 
ON  T.CacheAdUserID = S.cache_ad_user_id  and T.SourceSystem=N'QA'
WHEN MATCHED AND 
(isnull(T.LastName,'') <> isnull(S.user_last_name,'') OR
isnull(T.FirstName,'') <> isnull(S.user_first_name,'') OR
isnull(T.Email,'') <> isnull(S.user_email,'')  OR
isnull(T.isdeleted,'') <> isnull(S.user_deleted,'')  OR
isnull(T.FullName,'') <> isnull(S.user_full_name,'') OR
isnull(T.SourceSystem,'') <> isnull(S.SourceSystem,'') OR
isnull(T.MobilePhone,'') <> isnull(S.user_phone,'') 
)
   THEN UPDATE SET T.LastName = S.user_last_name ,T.FirstName = S.user_first_name ,T.Email = S.user_email ,T.FullName = S.user_full_name 
   ,T.isdeleted = S.user_deleted,T.SourceSystem=S.SourceSystem,T.MobilePhone=S.user_phone
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CacheAdUserID,LastName,FirstName,Email,FullName,isdeleted,SourceSystem,MobilePhone)
   VALUES (S.cache_ad_user_id,S.user_last_name,S.user_first_name,S.user_email,S.user_full_name ,S.user_deleted,SourceSystem,user_phone);
------------D_ActivityStatus---------------------------------
MERGE DWH.DIM.D_ActivityStatus AS T
USING (select distinct activity_status,activity_status_code
from STG.ds.QA_ACTIVITY_TRANS
where activity_status_code is not null) S 
ON  T.ActivityStatusCode = S.activity_status_code
WHEN MATCHED AND isnull(T.ActivityStatusLabel,'') <> isnull(S.activity_status,'') 
   THEN UPDATE SET T.ActivityStatusLabel = S.activity_status
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ActivityStatusCode,ActivityStatusLabel)
   VALUES (S.activity_status_code,S.activity_status);

------------D_Activity---------------------------------
MERGE DWH.DIM.D_Activity AS T
USING (SELECT distinct activity_id,activity_result,activity_result_desc,activity_status,activity_category,activity_subcategory,Activity_Comment
,activity_discipline,activity_progress,report_finding_status,activity_pre_draft,activity_to_delete,activity_type,
activity_creation_date activity_creation_date,activity_update_date,activity_planned_date,activity_conducted_date
,activity_completed_date,activity_rescheduled_date,activity_canceled_date,activity_discipline_code,Activity_Any_Raised_Capa,activity_source_id,
isnull(activity_planned_date,activity_conducted_date) activity_planned_conducted
FROM STG.ds.QA_ACTIVITY_TRANS ) S 
ON  T.activityid = S.activity_id and T.EndDate is null
WHEN MATCHED AND 
(
isnull(T.activityResult,'') <> isnull(S.activity_result,'') OR
isnull(T.activityResultDesc,'') <> isnull(S.activity_result_desc,'') OR
isnull(T.activityStatus,'') <> isnull(S.activity_status,'') OR
isnull(T.ActivityComment,'') <> isnull(S.Activity_Comment,'') OR
isnull(T.activityCategory,'') <> isnull(S.activity_category,'') OR
isnull(T.activitySubcategory,'') <> isnull(S.activity_subcategory,'') OR
isnull(T.activityDiscipline,'') <> isnull(S.activity_discipline,'') OR
isnull(T.activityProgress,'') <> isnull(S.activity_progress,'') OR
isnull(T.reportFindingStatus,'') <> isnull(S.report_finding_status,'') OR
isnull(T.activityPreDraft,'') <> isnull(S.activity_pre_draft,'') OR
isnull(T.activityToDelete,'') <> isnull(S.activity_to_delete,'') OR
isnull(T.activitycreationdate,'') <> isnull(S.activity_creation_date,'') OR
isnull(T.activityupdatedate,'') <> isnull(S.activity_update_date,'') OR
isnull(T.activityplanneddate,'') <> isnull(S.activity_planned_date,'') OR
isnull(T.activityconducteddate,'') <> isnull(S.activity_conducted_date,'') OR
isnull(T.activitycompleteddate,'') <> isnull(S.activity_completed_date,'') OR
isnull(T.activityrescheduleddate,'') <> isnull(S.activity_rescheduled_date,'') OR 
isnull(T.activityDisciplineCode,'') <> isnull(S.activity_discipline_code,'') OR 
isnull(T.activitycanceleddate,'') <> isnull(S.activity_canceled_date,'') OR
isnull(T.ActivityAnyRaisedCapa,'') <> isnull(S.Activity_Any_Raised_Capa,'')OR
isnull(T.ActivityType,'') <> isnull(S.Activity_Type,'')OR
isnull(T.ActivityPlannedConductedDate,'') <> isnull(S.activity_planned_conducted,'')OR
isnull(T.activitysourceid,'') <> isnull(S.activity_source_id,'')
)

   THEN UPDATE SET  T.activityResult = S.activity_result, 
   T.ActivityPlannedConductedDate=S.activity_planned_conducted,
     T.activityResultDesc = S.activity_result_desc, 
     T.activityStatus = S.activity_status, 
     T.activityCategory = S.activity_category, 
     T.activitySubcategory = S.activity_subcategory, 
     T.activityDiscipline = S.activity_discipline, 
     T.activityProgress = S.activity_progress, 
     T.reportFindingStatus = S.report_finding_status, 
     T.activityPreDraft = S.activity_pre_draft, 
     T.activityToDelete = S.activity_to_delete,
     T.activitycreationdate = S.activity_creation_date,
     T.activityupdatedate = S.activity_update_date,
     T.activityplanneddate = S.activity_planned_date,
     T.ActivityComment=S.Activity_Comment,
     T.activityconducteddate = S.activity_conducted_date,
     T.activitycompleteddate = S.activity_completed_date,
     T.activityrescheduleddate = S.activity_rescheduled_date,
     T.activitycanceleddate = S.activity_canceled_date,
T.activityDisciplineCode=S.activity_discipline_code,
T.ActivityAnyRaisedCapa=S.Activity_Any_Raised_Capa,
T.activitysourceid = S.activity_source_id,
T.ActivityType = S.Activity_Type


WHEN NOT MATCHED BY TARGET
   THEN INSERT ( ActivityID
   ,ActivityPlannedConductedDate
    ,activityResult
    ,activityResultDesc
    ,activityStatus
    ,activityCategory
    ,activitySubcategory
    ,activityDiscipline
    ,activityProgress
    ,reportFindingStatus
    ,activityPreDraft
    ,activityToDelete
    ,activitycreationdate
    ,activityupdatedate
    ,activityplanneddate
    ,activityconducteddate
    ,activitycompleteddate
    ,activityrescheduleddate
    ,activitycanceleddate
    ,StartDate
,activityDisciplineCode
,ActivityComment
,ActivityAnyRaisedCapa
,activitysourceid
,ActivityType
)
   VALUES ( S.activity_id, 
   S.activity_planned_conducted,
   S.activity_result, 
   S.activity_result_desc, 
   S.activity_status, 
   S.activity_category, 
   S.activity_subcategory, 
   S.activity_discipline, 
   S.activity_progress, 
   S.report_finding_status, 
   S.activity_pre_draft, 
   S.activity_to_delete,
   s.activity_creation_date,
   s.activity_update_date,
   s.activity_planned_date,
   s.activity_conducted_date,
   s.activity_completed_date,
   S.activity_rescheduled_date,
   S.activity_canceled_date,
   cast(cast(getdate() as date) as datetime)
,S.activity_discipline_code
,Activity_Comment
,S.Activity_Any_Raised_Capa
,S.activity_source_id
,S.Activity_Type
  );

------------D_Risk---------------------------------
MERGE DWH.DIM.D_Risk AS T
USING (select distinct capa_risk_level,capa_risk_level_code
from stg.ds.v_qa_CAPA
where capa_risk_level_code is not null ) S 
ON  T.CapaRiskCode = S.capa_risk_level_code 
WHEN MATCHED AND isnull(T.CapaRisk,'') <> isnull(S.capa_risk_level,'')
   THEN UPDATE SET T.CapaRisk = S.capa_risk_level 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CapaRiskCode,CapaRisk)
   VALUES (S.capa_risk_level_code,S.capa_risk_level);

------------D_ReportStatus---------------------------------
MERGE DWH.DIM.D_ReportStatus AS T
USING (select distinct report_finding_status,report_finding_code
from STG.ds.QA_ACTIVITY_TRANS
where report_finding_code is not null ) S 
ON  T.ReportStatusCode = S.report_finding_code 
WHEN MATCHED AND isnull(T.ReportStatusLabel,'') <> isnull(S.report_finding_status,'')
   THEN UPDATE SET T.ReportStatusLabel = S.report_finding_status 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ReportStatusCode,ReportStatusLabel)
   VALUES (S.report_finding_code,S.report_finding_status);
------------D_Planning---------------------------------

MERGE DWH.DIM.D_Planning AS T
USING (select distinct o.planning_id,
o.planning_status,
case when planning_activity_type = 'CRR / Pass Gate' then 'CRR (Construction Readiness Review)'
  when planning_activity_type='CES (Customer Expectation Survey)' then 'CSS (Customer Satisfaction Survey)'
  else isnull(planning_activity_type,'-')
  end planning_activity_type,
p.project_name,
cast(left(planning_creation_date,23) as datetime) planning_creation_date,
cast(left(planning_update_date,23) as datetime )  planning_update_date
from stg.ds.v_qa_planning o
left outer join stg.ds.qa_project_detail s on s.id=o.project_id
left outer join stg.ds.v_qa_project p on s.project_id = p.project_id  ) S 
ON  T.planningid = S.planning_id and T.EndDate is null
WHEN MATCHED AND 
(
isnull(T.planningstatus,'') <> isnull(S.planning_status,'') OR
isnull(T.planningactivitytype,'') <> isnull(S.planning_activity_type,'') OR
isnull(T.projectname,'') <> isnull(S.project_name,'') OR
isnull(T.planningcreationdate,'') <> isnull(S.planning_creation_date,'') OR
isnull(T.planningupdatedate,'') <> isnull(S.planning_update_date,'') 
)

   THEN UPDATE SET  T.planningstatus = S.planning_status, 
     T.planningactivitytype = S.planning_activity_type, 
     T.projectname = S.project_name,
     T.planningcreationdate = S.planning_creation_date,
     T.planningupdatedate = S.planning_update_date

WHEN NOT MATCHED BY TARGET
   THEN INSERT ( PlanningID,PlanningStatus,PlanningActivityType,ProjectName,planningcreationdate,planningupdatedate,StartDate)
   VALUES ( S.planning_id,
   S.planning_status,
   S.planning_activity_type,
   S.project_name,
   S.planning_creation_date,
   S.planning_update_date,
   cast(cast(getdate() as date) as datetime)
  );
------------D_RootCause---------------------------------
MERGE DWH.DIM.D_RootCause AS T
USING (select distinct capa_root_cause,capa_root_cause_code
from stg.ds.v_qa_CAPA
where capa_root_cause_code is not null ) S 
ON  T.RootCauseCode = S.capa_root_cause_code 
WHEN MATCHED AND isnull(T.RootCause,'') <> isnull(S.capa_root_cause,'')
   THEN UPDATE SET T.RootCause = S.capa_root_cause 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (RootCause,RootCauseCode)
   VALUES (S.capa_root_cause,S.capa_root_cause_code);
------------D_CapaStatus---------------------------------
MERGE DWH.DIM.D_CapaStatus AS T
USING (select distinct capa_status,capa_status_code
from stg.ds.v_qa_CAPA
where capa_status_code is not null ) S 
ON  T.CapaStatusCode = S.capa_status_code 
WHEN MATCHED AND isnull(T.CapaStatus,'') <> isnull(S.capa_status,'')
   THEN UPDATE SET T.CapaStatus = S.capa_status 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CapaStatus,CapaStatusCode)
   VALUES (S.capa_status_code,S.capa_status);
------------D_FindingReport---------------------------------
MERGE DWH.DIM.D_FindingReport AS T
USING (select * 
from (
SELECT  [report_id]
      ,[report]
   ,e.label as report_status
   ,[terms_of_reference]
      ,left([creation_date],23) [creation_date]
      ,left([update_date],23) [update_date]
	  ,ROW_NUMBER() over(partition by [report_id] order by update_date desc) ord
  FROM [STG].[ds].[qa_activity_finding_report] c
  inner join stg.ds.qa_enumeration e on e.id = c.report_status
  )x
  where x.ord=1) S 
ON  T.FindingReportID = S.[report_id] 
WHEN MATCHED AND (
   isnull(T.FindingReport,'') <> isnull(S.[report],'') OR
   isnull(T.FindingReportStatus,'') <> isnull(S.report_status,'') OR
   isnull(T.CreationDate,'9999-12-31') <> isnull(S.[creation_date],'9999-12-31') OR
   isnull(T.UpdateDate,'9999-12-31') <> isnull(S.[update_date],'9999-12-31') 
    )

   THEN UPDATE SET  T.FindingReport = S.[report] ,
     T.FindingReportStatus = S.report_status,
     T.CreationDate = S.[creation_date] ,
     T.UpdateDate = S.[update_date] 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (FindingReportID,FindingReport,FindingReportStatus,CreationDate,UpdateDate)
   VALUES (S.[report_id],S.[report],S.report_status,S.[creation_date],S.[update_date]);
------------D_PlanningStatus---------------------------------
MERGE DWH.DIM.D_PlanningStatus AS T
USING (select distinct planning_status_code,planning_status
from stg.ds.v_qa_PLANNING
where planning_status_code is not null ) S 
ON  T.PlanningStatusCode = S.planning_status_code 
WHEN MATCHED AND isnull(T.PlanningStatus,'') <> isnull(S.planning_status,'')
   THEN UPDATE SET T.PlanningStatus = S.planning_status 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (PlanningStatus,PlanningStatusCode)
   VALUES (S.planning_status,S.planning_status_code);
------------D_PlanningActivityType---------------------------------

MERGE DWH.DIM.D_PlanningActivityType AS T
USING (select distinct planning_activity_type,planning_activity_type_code
from stg.ds.v_qa_PLANNING
where planning_activity_type_code is not null ) S 
ON  T.PlanningActivityTypeCode = S.planning_activity_type_code 
WHEN MATCHED AND isnull(T.PlanningActivityType,'') <> isnull(S.planning_activity_type,'')
   THEN UPDATE SET T.PlanningActivityType = S.planning_activity_type 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (PlanningActivityTypeCode,PlanningActivityType)
   VALUES (S.planning_activity_type_code,S.planning_activity_type);
------------D_Capa---------------------------------
MERGE DWH.DIM.D_Capa AS T
USING (SELECT distinct  capa_id
      ,capa_number 
      ,capa_root_cause
      ,capa_root_cause_description
   ,capa_source_description
   ,capa_finding_description
   ,capa_action_description
      ,capa_status
   ,nature_of_finding_level1
   ,nature_of_finding_level2
   ,capa_comment
      ,capa_overdue_rating
      ,capa_risk_level
      ,cast(left(capa_issue_date,23) as datetime) capa_issue_date
   ,cast(left(capa_closed_date,23) as datetime)capa_closed_date 
   ,cast(left(capa_creation_date,23) as datetime) capa_creation_date 
   ,cast(left(capa_planned_implementation,23) as datetime) capa_planned_implementation
  FROM STG.ds.v_qa_CAPA) S 
ON  T.capaid = S.capa_id 
WHEN MATCHED AND (
   isnull(T.CapaNumber,'') <> isnull(S.capa_number,'') OR
   isnull(T.CapaRootCause,'') <> isnull(S.capa_root_cause,'') OR
   isnull(T.CapaRootCauseDesc,'') <> isnull(S.capa_root_cause_description,'') OR
   isnull(T.capasourcedescription,'') <> isnull(S.capa_source_description,'') OR
   isnull(T.capafindingdescription,'') <> isnull(S.capa_finding_description,'') OR
   isnull(T.capaactiondescription,'') <> isnull(S.capa_action_description,'') OR
   isnull(T.CapaStatus,'') <> isnull(S.capa_status,'') OR
   isnull(T.CapaOverdueRating,'') <> isnull(S.capa_overdue_rating,'') OR
   isnull(T.NatureOfFinding1,'') <> isnull(S.nature_of_finding_level1,'') OR
   isnull(T.NatureOfFinding2,'') <> isnull(S.nature_of_finding_level2,'') OR
   isnull(T.CapaRiskLevel,'') <> isnull(S.capa_risk_level,'') OR
   isnull(T.CapaComment,'') <> isnull(S.capa_comment,'') OR
   isnull(T.CapaCreationDate,'') <> isnull(S.capa_creation_date,'') OR
   isnull(T.CapaClosedDate,'') <> isnull(S.capa_closed_date,'') OR
   isnull(T.CapaIssueDate,'') <> isnull(S.capa_issue_date,'') OR
   isnull(T.CapaPlannedImplementation,'') <> isnull(S.capa_planned_implementation,'') 
    )

   THEN UPDATE SET  T.CapaNumber = S.capa_number ,
     T.CapaRootCause = S.capa_root_cause,
     T.CapaRootCauseDesc = S.capa_root_cause_description ,
     T.CapaStatus = S.capa_status ,
     T.capasourcedescription=S.capa_source_description,
     T.capafindingdescription=S.capa_finding_description,
     T.capaactiondescription=S.capa_action_description,
     T.CapaOverdueRating = S.capa_overdue_rating ,
     T.CapaRiskLevel = S.capa_risk_level ,
     T.capacomment = S.capa_comment ,
     T.NatureOfFinding1 = S.nature_of_finding_level1 ,
     T.NatureOfFinding2 = S.nature_of_finding_level2 ,
     T.CapaCreationDate = S.capa_creation_date ,
     T.CapaClosedDate = S.capa_closed_date ,
     T.CapaIssueDate = S.capa_issue_date,
     T.CapaPlannedImplementation = S.capa_planned_implementation
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CapaID,capasourcedescription,capafindingdescription,capaactiondescription,CapaNumber,CapaRootCause,CapaRootCauseDesc,CapaStatus,CapaOverdueRating,CapaRiskLevel,NatureOfFinding1,NatureOfFinding2,CapaCreationDate,CapaClosedDate,CapaIssueDate,CapaPlannedImplementation,StartDate,capacomment)
   VALUES (S.capa_id,capa_source_description,capa_finding_description,capa_action_description,S.capa_number,S.capa_root_cause,S.capa_root_cause_description,S.capa_status,S.capa_overdue_rating,S.capa_risk_level,nature_of_finding_level1,nature_of_finding_level2,S.capa_creation_date,S.capa_closed_date,S.capa_issue_date,S.capa_planned_implementation,cast(cast(getdate() as date) as datetime),capa_comment);

END;
GO
/****** Object:  StoredProcedure [DIM].[usp_SAP]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DIM].[usp_SAP]
AS
BEGIN
------------D_ProfiCenter---------------------------------
MERGE DWH.DIM.D_ProfitCenter AS T
USING (   select PRCTR ProfitCenterCode,
  cast(datab as datetime) ValidFrom,
  cast(datbi as datetime) ValidTo,
  [Name] as ProfitCenterName,
  [long text] as ProfitCenterLongText
   from stg.sap.cepc c 
   left outer join [STG].[SPS].[ProfitCenterMasterData]  s on s.[Profit Center] = c.PRCTR
) S 
ON  T.ProfitCenterCode = S.ProfitCenterCode 
WHEN MATCHED AND 
(isnull(T.Name,'') <> isnull(S.ProfitCenterName,'') OR
isnull(T.ProfitCenterLongText,'') <> isnull(S.ProfitCenterLongText,'') 
)
   THEN UPDATE SET T.Name = S.ProfitCenterName ,T.ProfitCenterLongText = S.ProfitCenterLongText 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ValidFrom,ValidTo,Name,ProfitCenterLongText,ProfitCenterCode)
   VALUES (S.ValidFrom,S.ValidTo,S.ProfitCenterName,S.ProfitCenterLongText,S.ProfitCenterCode);
------------D_WBS---------------------------------
MERGE DWH.DIM.D_WBS AS T
USING (  
SELECT ProfitCenterID,
-1 as SectorID
,-1 as LegalEntityID
,[PRCTR] [ProfitCenter]
,[POSID] as WBSElement
,[POST1] [Description]
,[OBJNR] ObjectNumber
,pro.PSPID CurrentInternalProjectNumber
,[WERKS]  CompanyCode
,PGSBR BusinessArea
,PKOKR ControllingArea
,[PWPOS] [Currency]
,PBUKR Plant
,[ZAD_SERTYP] [Service_Type]
,[ZAD_CT] [Contracttype]
,left([PRART],2) ProjectType
,cast([ERDAT] as datetime) CreationDate
,[ZAD_REG] [Region]
,[ZAD_GEO] [Geography]
,[ZAD_SECLOB] LobSector
,[ZAD_LAND] CountryID
,[ZAD_PRLO] [Location1]  
,null  ONCP     
FROM [STG].[SAP].[PRPS] p
outer apply (select distinct pr.PSPID from stg.sap.proj pr where pr.PSPNR=p.[PSPHI]) pro
left join dwh.dim.D_ProfitCenter pr on pr.ProfitCenterCode = p.PRCTR
) S 
ON  T.WBSElement = S.WBSElement 
WHEN MATCHED AND 
(
isnull(T.Description,'') <> isnull(S.Description,'') OR 
isnull(T.ObjectNumber,'') <> isnull(S.ObjectNumber,'') OR 
isnull(T.CurrentInternalProjectNumber,'') <> isnull(S.CurrentInternalProjectNumber,'') OR 
isnull(T.CompanyCode,'') <> isnull(S.CompanyCode,'') OR 
isnull(T.BusinessArea,'') <> isnull(S.BusinessArea,'') OR 
isnull(T.ControllingArea,'') <> isnull(S.ControllingArea,'') OR 
isnull(T.Currency,'') <> isnull(S.Currency,'') OR 
isnull(T.Plant,'') <> isnull(S.Plant,'') OR 
isnull(T.ServiceType,'') <> isnull(S.Service_Type,'') OR 
isnull(T.ContractType,'') <> isnull(S.ContractType,'') OR 
isnull(T.ProjectType,'') <> isnull(S.ProjectType,'') OR 
isnull(T.CreationDate,'') <> isnull(S.CreationDate,'') OR 
isnull(T.Region,'') <> isnull(S.Region,'') OR 
isnull(T.Geography,'') <> isnull(S.Geography,'') OR 
isnull(T.LobSector,'') <> isnull(S.LobSector,'') OR 
isnull(T.CountryID,'') <> isnull(S.CountryID,'') OR 
isnull(T.Location1,'') <> isnull(S.Location1,'') OR 
isnull(T.ONCP,'') <> isnull(S.ONCP,'') OR 
isnull(T.ProfitCenterID,'') <> isnull(S.ProfitCenterID,'') OR
isnull(T.SectorID,'') <> isnull(S.SectorID,'') OR 
isnull(T.LegalEntityID,'') <> isnull(S.LegalEntityID,'') 
)
   THEN UPDATE SET T.SectorID = S.SectorID,
T.LegalEntityID = S.LegalEntityID,
T.Description = S.Description,
T.ObjectNumber = S.ObjectNumber,
T.CurrentInternalProjectNumber = S.CurrentInternalProjectNumber,
T.CompanyCode = S.CompanyCode,
T.BusinessArea = S.BusinessArea,
T.ControllingArea = S.ControllingArea,
T.Currency = S.Currency,
T.Plant = S.Plant,
T.ServiceType = S.Service_Type,
T.ContractType = S.ContractType,
T.ProjectType = S.ProjectType,
T.CreationDate = S.CreationDate,
T.Region = S.Region,
T.Geography = S.Geography,
T.LobSector = S.LobSector,
T.CountryID = S.CountryID,
T.Location1 = S.Location1,
T.ONCP = S.ONCP,
T.ProfitCenterID = S.ProfitCenterID 
WHEN NOT MATCHED BY TARGET
   THEN INSERT (WBSElement ,
SectorID ,
LegalEntityID ,
Description ,
ObjectNumber ,
CurrentInternalProjectNumber ,
CompanyCode ,
BusinessArea ,
ControllingArea ,
Currency ,
Plant ,
ServiceType ,
ContractType ,
ProjectType ,
CreationDate ,
Region ,
Geography ,
LobSector ,
CountryID ,
Location1 ,
ONCP ,
ProfitCenterID 
)
   VALUES (S.WBSElement,
-1,
-1,
S.Description,
S.ObjectNumber,
S.CurrentInternalProjectNumber,
S.CompanyCode,
S.BusinessArea,
S.ControllingArea,
S.Currency,
S.Plant,
S.Service_Type,
S.ContractType,
S.ProjectType,
S.CreationDate,
S.Region,
S.Geography,
S.LobSector,
S.CountryID,
S.Location1,
S.ONCP,
S.ProfitCenterID
);
------------D_CostCenter---------------------------------
MERGE DWH.DIM.D_CostCenter AS T
USING (
SELECT distinct 
cast([Cost Center] as int) AS CostCenter
,[Company Code] AS CompanyCode
,[Description] AS Description
,isnull([Cost Center Owner] ,'') AS CostCenterOwner
,[Hierarchy Area] AS HierarchyArea
,[Currency] AS Currency
,[Profit Center] AS ProfitCenterLabel
,[New P&L] AS NewPLSub
,isnull(p.ProfitCenterID,-1) ProfitCenterID
,case when Category='Do not use' then null
	  when [New P&L]='Intra' then 'Intra BU'
	  when Category='Operational G&As' and [New P&L]='Direct Bus' then 'Direct G&As'
	  when Category='Operational G&As' and [New P&L]='Services Bus' then 'Services Direct G&As'
	  else Category
end NewPL
--,case [New P&L]
-- when N'Labor Direct G&A' then 'Direct G&As'
-- when N'Conventional' then 'Direct G&As'
-- when N'General Services Overheads' then N'Services G&As'
-- when N'Supply Chain Overheads' then N'Services G&As'
-- when N'JESA Academy Overheads' then N'Services G&As'
-- when N'R&D Overheads' then N'Services G&As'
-- when N'Assurance Overheads' then N'Services G&As'
-- when N'Growth BA' then N'Services G&As'
-- when N'JESA Institute' then N'Services G&As'
-- when N'Project Control' then N'Services G&As'
-- when N'E&D' then N'Services G&As'
-- when N'Growth Overheads' then N'Services G&As'
-- when N'Field Services' then N'Services G&As'
-- when N'project Delivery' then N'Services G&As'
-- when N'R3 Overheads' then N'Services G&As'
-- when N'Digital Transformation' then N'Services G&As'
-- when N'Services Direct G&As' then N'Services Direct G&As'
-- when N'General Management BA' then N'Corporate G&As'
-- when N'Legal BA' then N'Corporate G&As'
-- when N'Audit & Risk BA' then N'Corporate G&As'
-- when N'Human Resources BA' then N'Corporate G&As'
-- when N'Com & PR BA' then N'Corporate G&As'
-- when N'Finance Overheads BA' then N'Corporate G&As'
-- when N'JFN' then N'Corporate G&As'
-- when N'Information Technology BA' then N'Variances'
-- when N'Information Technology Overheads' then N'Variances'
-- when N'LDC Variances' then N'Variances'
-- when N'ODC Variances' then N'Variances'
-- when N'ADC Variances' then N'Variances'
-- when N'Other Variances' then N'Variances'
-- when N'Intra ADS' then N'Intra BU '
-- when N'Intra AMT' then N'Intra BU '
-- when N'Intra M&I' then N'Intra BU '
-- when N'Intra B&I' then N'Intra BU '
-- when N'Intra SUR' then N'Intra BU '
-- when N'Intra JET' then N'Intra BU '
-- when N'Other Cost' then N'Other Cost'
-- when N'Audit & Risk Overheads' then N'Corporate G&As'
-- when N'Com & PR Overheads' then N'Corporate G&As'
-- when N'Exchange Rate Differences' then N'A ne pas prendre en compte'
-- when N'Finance Overheads' then N'Corporate G&As'
-- when N'General Management Overheads' then N'Corporate G&As'
-- when N'Human Resources Overheads' then N'Corporate G&As'
-- when N'Interests' then N'A ne pas prendre en compte'
-- when N'JESA Foundation' then N'Services G&As'
-- when N'Legal Overheads' then N'Corporate G&As'
-- when N'Non Operating Expenses' then N'A ne pas prendre en compte'
-- when N'Operational Taxes' then N'A ne pas prendre en compte'
-- when N'Other Expenses' then N'A ne pas prendre en compte'
-- when N'Others - Curr/G&L' then N'A ne pas prendre en compte'
--end NewPL
FROM [STG].[SPS].[CostCenterMapping] c
left outer join DWH.DIM.D_ProfitCenter p on p.ProfitCenterCode = c.[Profit Center]
where c.[Cost Center] is not null 
) S 
ON  T.CostCenterCode = S.CostCenter 
WHEN MATCHED AND 
(isnull(T.CompanyCode,'') <> isnull(S.CompanyCode,'') OR 
isnull(T.Description,'') <> isnull(S.Description,'') OR 
isnull(T.CostCenterOwner,'') <> isnull(S.CostCenterOwner,'') OR 
isnull(T.HierarchyArea,'') <> isnull(S.HierarchyArea,'') OR 
isnull(T.Currency,'') <> isnull(S.Currency,'') OR 
isnull(T.ProfitCenter,'') <> isnull(S.ProfitCenterLabel,'') OR 
isnull(T.PLSubCategory,'') <> isnull(S.NewPLSub,'') OR 
isnull(T.ProfitCenterID,'-1') <> isnull(S.ProfitCenterID,'-1') OR 
isnull(T.PLCategory,'') <> isnull(S.NewPL,'') 
)
   THEN UPDATE SET T.CompanyCode = S.CompanyCode , 
T.Description = S.Description , 
T.CostCenterOwner = S.CostCenterOwner , 
T.HierarchyArea = S.HierarchyArea , 
T.Currency = S.Currency , 
T.ProfitCenter = S.ProfitCenterLabel , 
T.PLSubCategory = S.NewPLSub , 
T.ProfitCenterID = S.ProfitCenterID , 
T.PLCategory = S.NewPL  
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CostCenterCode ,CompanyCode ,Description ,CostCenterOwner ,HierarchyArea ,
Currency ,ProfitCenter ,PLSubCategory ,ProfitCenterID ,PLCategory)
   VALUES (S.CostCenter,S.CompanyCode,S.Description,S.CostCenterOwner,S.HierarchyArea,S.Currency,
S.ProfitCenterLabel,S.NewPLSub,S.ProfitCenterID,S.NewPL);
------------D_Employee---------------------------------
MERGE DWH.DIM.[D_Employee] AS T
USING (select 
P2.PERNR as EMP_SAP_ID,
NATIO as Nationality,
GESCH as Gender,
GBDAT as DateOfBirth,
NULL as ContractType,
CASE 
--02 : contract zffzctivz date
--03 : senioriry date
WHEN DAR01 = '02' THEN DAT01
WHEN DAR02 = '02' THEN DAT02
WHEN DAR03 = '02' THEN DAT03
END as SeniorityDate
FROM [STG].SAP.PA0002 P2
--LEFT JOIN [STG].SAP.PA0016 P16 ON P2.PERNR = P16.PERNR AND P2.MANDT = P16.MANDT
LEFT JOIN [STG].SAP.PA0001 P1 ON P2.PERNR = P1.PERNR AND P2.MANDT = P1.MANDT and P1.ENDDA = 99991231
LEFT JOIN [STG].[SAP].[PA0041] P41 ON P2.PERNR = P41.PERNR AND P2.MANDT = P41.MANDT AND P41.ENDDA = 99991231
WHERE P2.MANDT = 100
AND P2.ENDDA=99991231
AND P1.PERSG NOT IN ('S','Y')
GROUP BY P2.PERNR,NATIO,GESCH,GBDAT,DAR01,DAR02,DAR03,DAT01,DAT02,DAT03 
) S 
ON  T.EMP_SAP_ID = S.EMP_SAP_ID 
WHEN MATCHED AND 
(isnull(T.Nationality,'') <> isnull(S.Nationality,'') OR 
isnull(T.Gender,'') <> isnull(S.Gender,'') OR 
isnull(T.DateOfBirth,'') <> isnull(S.DateOfBirth,'') OR 
isnull(T.ContractType,'') <> isnull(S.ContractType,'') OR 
isnull(T.SeniorityDate,'') <> isnull(S.SeniorityDate,'') 
)
   THEN UPDATE SET T.Nationality = S.Nationality ,
T.Gender = S.Gender ,
T.DateOfBirth = S.DateOfBirth ,
T.ContractType = S.ContractType ,
T.SeniorityDate = S.SeniorityDate   
WHEN NOT MATCHED BY TARGET
   THEN INSERT (EMP_SAP_ID ,Nationality ,Gender ,DateOfBirth ,ContractType ,SeniorityDate)
   VALUES (S.EMP_SAP_ID ,S.Nationality ,S.Gender ,S.DateOfBirth ,S.ContractType ,S.SeniorityDate);
------------D_CostElement---------------------------------
MERGE DWH.DIM.D_CostElement AS T
USING (SELECT [Cost Element] CostElementCode
      ,[Cost Element Name]  CostElementName
      ,left([Cost element descr#],1) CostElementDescription
      ,[Labor#non Labor] LaborNonLabor
      ,[CategorieI ] CategorieI
      ,[Categorie II] CategorieII
  FROM [STG].[SPS].[GAsPreliminaryMappingByCategory]
GROUP BY [Cost Element]
      ,[Cost Element Name]
      ,[Cost element descr#]
      ,[Labor#non Labor]
      ,[CategorieI ]
      ,[Categorie II]
) S 
ON  T.CostElementCode = S.CostElementCode 
WHEN MATCHED AND 
(isnull(T.CostElementDescription,'') <> isnull(S.CostElementDescription,'') OR 
isnull(T.LaborNonLabor,'') <> isnull(S.LaborNonLabor,'') OR 
isnull(T.CategorieI,'') <> isnull(S.CategorieI,'') OR 
isnull(T.CategorieII,'') <> isnull(S.CategorieII,'') OR 
isnull(T.CostElementName,'') <> isnull(S.CostElementName,'')
)
   THEN UPDATE SET T.CostElementDescription = S.CostElementDescription ,
T.LaborNonLabor = S.LaborNonLabor ,
T.CategorieI = S.CategorieI ,
T.CategorieII = S.CategorieII ,
T.CostElementName = S.CostElementName  
WHEN NOT MATCHED BY TARGET
   THEN INSERT (CostElementCode ,CostElementDescription ,LaborNonLabor ,CategorieI ,CategorieII ,CostElementName)
   VALUES (S.CostElementCode ,S.CostElementDescription ,S.LaborNonLabor ,S.CategorieI ,S.CategorieII ,S.CostElementName);
------------D_GLAccount---------------------------------
MERGE DWH.DIM.[D_GLAccount] AS T
USING (select [G/L Account] GLAccount,[G/L Account: Long Text]  GLAccountLongText
  FROM [STG].[SPS].[ExtractionGLPB] 
  where [G/L Account]<> ''
  GROUP BY [G/L Account],[G/L Account: Long Text]
) S 
ON  T.GLAccount = S.GLAccount 
WHEN MATCHED AND 
(isnull(T.GLAccountLongText,'') <> isnull(S.GLAccountLongText,'')
)
   THEN UPDATE SET T.GLAccountLongText = S.GLAccountLongText
WHEN NOT MATCHED BY TARGET
   THEN INSERT (GLAccount ,GLAccountLongText)
   VALUES (S.GLAccount ,S.GLAccountLongText);
------------D_ProjectTasks---------------------------------
MERGE DWH.DIM.D_ProjectTasks AS T
USING (select distinct substring(RNETWORK_TXT ,0,charindex('(',RNETWORK_TXT ,0))   TaskLabel,
RPROJ_TXT ProjectLabel,
replace(reverse(SUBSTRING(reverse(RPROJ_TXT),CHARINDEX(')',reverse(RPROJ_TXT),0)+1,
CHARINDEX('(',reverse(RPROJ_TXT),0)-CHARINDEX(')',reverse(RPROJ_TXT),0) )),'(','') ProjectCode 
from STG.SAP.CATSDB
where  MANDT = 100 and RPROJ_TXT is not null) S 
ON  T.ProjectCode = S.ProjectCode and isnull(T.TaskLabel,'') = isnull(T.TaskLabel,'') and  T.ProjectLabel = S.ProjectLabel
WHEN NOT MATCHED BY TARGET
   THEN INSERT (ProjectCode,ProjectLabel,TaskLabel)
   VALUES (S.ProjectCode,S.ProjectLabel,S.TaskLabel)
;

END;
GO
/****** Object:  StoredProcedure [DIM].[usp_SHARED]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [DIM].[usp_SHARED]
AS
BEGIN

------------D_PROJECT Step 1---------------------------------
MERGE DWH.DIM.D_Project AS T
USING (
SELECT 
	[project_number]
	,[j_project_bu] project_bu
	,isnull(b.BuSectorSK,-1) BuSectorSK 
	,isnull(pc.ProjectClassSK,-1) ProjectClassSK 
	,coalesce([q_project_name],[j_project_name],p6_project_name) as project_name
	,isnull(e.EnumSK,-1) EnumTypeSK
	,[j_project_program] as project_program
	,[q_project_customer] as project_customer
	,[j_project_state]  project_status
	,[q_project_status] q_project_status
	,[q_project_phase] project_phase
	,[q_project_risk] project_risk
	,[q_project_sector] project_sector
	,[q_project_size] as project_size
	,procore_project_name as procoreprojectname
	,p6_obsname as OBSName
	,p6_project_status
	,p6_fcst_start_date
	,p6_plan_end_date
	,p6_scd_end_date
	,p6_engineeringStartDate
	,p6_engineeringEndDate
	,p6_procurementStartDate
	,p6_procurementEndDate
	,p6_constructionStartDate
	,p6_constructionEndDate
	,p6_commissioningStartDate
	,p6_commissioningEndDate
	,q_project_id
	,j_project_id
	,p6_project_id
	,j_fcst_date
	,j_start_date
	,q_project_lead
	,q_project_scope
	,hse_project_id
	,p.j_project_sector as JProjectSector
	,p.P6_Start_Date as P6StartDate
,p.procore_project_id ProcoreProjectID
,P.[procore_program_name] [procoreprogramname]
,j_scheduling_frequency JProjectSchedulingFrequency
  FROM [STG].[MASTER].[PROJECT] p
  left outer join dwh.dim.D_Enumeration e on e.enumID = 'Collab-'+cast(p.enum_type as nvarchar(10))
  left outer join dwh.dim.D_BuSector b on b.Sector = isnull(p.[q_project_sector],'') and b.BuLabel = coalesce([q_project_bu],[j_project_bu],'') 
  left outer join dwh.dim.D_ProjectClassif pc on pc.ProjectPhase = isnull(p.[q_project_phase],'-') and pc.ProjectSize = isnull(p.q_project_size,'-') and pc.ProjectRisk = isnull(p.q_project_risk,'-')
 ) S 
ON  T.ProjectNumber = S.project_number and T.EndDate is null  and T.ProjectSK <> -1
WHEN MATCHED AND 
(
isnull(T.EnumTypeSK,'') <> isnull(S.EnumTypeSK,'') OR
isnull(T.JProjectSchedulingFrequency,'') <> isnull(S.JProjectSchedulingFrequency,'') OR
isnull(T.JpassForecastDate,'') <> isnull(S.j_fcst_date,'') OR
isnull(T.JpassStartDate,'') <> isnull(S.j_start_date,'') OR
isnull(T.JProjectSector,'') <> isnull(S.JProjectSector,'') OR
isnull(T.projectname,'') <> isnull(S.project_name,'') OR
isnull(T.projectcustomer,'') <> isnull(S.project_customer,'') OR
isnull(T.projectbu,'') <> isnull(S.project_bu,'') OR
isnull(T.projectsector,'') <> isnull(S.project_sector,'') OR
isnull(T.ProjectProgram,'') <> isnull(S.project_program,'') OR
isnull(T.projectsize,'') <> isnull(S.project_size,'') OR
isnull(T.projectphase,'') <> isnull(S.project_phase,'') OR
isnull(T.projectstatus,'') <> isnull(S.project_status,'') OR
isnull(T.projectrisk,'') <> isnull(S.project_risk,'')  OR
isnull(T.QaProjectID,'') <> isnull(S.q_project_id,'')  OR
isnull(T.jpassprojectid,'') <> isnull(S.j_project_id,'')  OR
isnull(T.ProjectBuSectorSK,'') <> isnull(S.BuSectorSK,'') OR
isnull(T.ProjectClassSK,'') <> isnull(S.ProjectClassSK,'') OR
isnull(T.QAProjectStatus,'') <> isnull(S.q_project_status,'') OR
isnull(T.QAProjectScope,'') <> isnull(S.q_project_scope,'')OR
isnull(T.QAProjectLead,'') <> isnull(S.q_project_lead,'') OR
isnull(T.P6ProjectID,'') <> isnull(S.p6_project_id,'') OR 
isnull(T.HSEProjectID,'') <> isnull(S.hse_project_id,'') OR 
isnull(T.OBSName,'') <> isnull(S.OBSName,'') OR 
isnull(T.procoreprojectname,'') <> isnull(S.procoreprojectname,'') OR
isnull(T.P6ProjectStatus,'9999-12-31') <> isnull(S.p6_project_status,'9999-12-31') OR 
isnull(T.ProjStartDate,'9999-12-31') <> isnull(S.p6_fcst_start_date,'9999-12-31') OR 
isnull(T.ContractualEndDate,'9999-12-31') <> isnull(S.p6_plan_end_date,'9999-12-31') OR 
isnull(T.p6ForecastDate,'9999-12-31') <> isnull(S.p6_scd_end_date,'9999-12-31') OR 
isnull(T.EngineeringStartDate,'9999-12-31') <> isnull(S.p6_engineeringStartDate,'9999-12-31') OR 
isnull(T.EngineeringEndDate,'9999-12-31') <> isnull(S.p6_engineeringEndDate,'9999-12-31') OR 
isnull(T.ProcurementStartDate,'9999-12-31') <> isnull(S.p6_procurementStartDate,'9999-12-31') OR 
isnull(T.ProcurementEndDate,'9999-12-31') <> isnull(S.p6_procurementEndDate,'9999-12-31') OR 
isnull(T.ConstructionStartDate,'9999-12-31') <> isnull(S.p6_constructionStartDate,'9999-12-31') OR 
isnull(T.ConstructionEndDate,'9999-12-31') <> isnull(S.p6_constructionEndDate,'9999-12-31') OR 
isnull(T.CommissioningStartDate,'9999-12-31') <> isnull(S.p6_commissioningStartDate,'9999-12-31') OR 
isnull(T.CommissioningEndDate ,'9999-12-31') <> isnull(S.p6_commissioningEndDate,'9999-12-31') OR
isnull(T.P6StartDate ,'9999-12-31') <> isnull(S.P6StartDate,'9999-12-31') OR
isnull(T.ProcoreProjectID,'') <> isnull(S.ProcoreProjectID,'') OR
isnull(T.[procoreprogramname],'') <> isnull(S.[procoreprogramname],'') 

)
 THEN UPDATE SET  T.enddate = cast(cast(getdate() as date) as datetime)

WHEN NOT MATCHED BY SOURCE AND T.EndDate is null and T.ProjectSK <> -1
THEN UPDATE SET T.EndDate=cast(cast(getdate() as date) as datetime) ;

------------D_PROJECT Step 2---------------------------------
MERGE DWH.DIM.D_Project AS T
USING (
SELECT 
	[project_number],procore_project_name as procoreprojectname
	,[j_project_bu] project_bu
	,isnull(b.BuSectorSK,-1) BuSectorSK 
	,isnull(pc.ProjectClassSK,-1) ProjectClassSK 
	,coalesce([q_project_name],[j_project_name],p6_project_name) as project_name
	,isnull(e.EnumSK,-1) EnumTypeSK
	,[j_project_program] as project_program
	,[q_project_customer] as project_customer
	,[j_project_state]  project_status
	,[q_project_status] q_project_status
	,[q_project_phase] project_phase
	,[q_project_risk] project_risk
	,[q_project_sector] project_sector
	,[q_project_size] as project_size
	,p6_obsname as OBSName
	,p6_project_status
	,p6_fcst_start_date
	,p6_plan_end_date
	,p6_scd_end_date
	,p6_engineeringStartDate
	,p6_engineeringEndDate
	,p6_procurementStartDate
	,p6_procurementEndDate
	,p6_constructionStartDate
	,p6_constructionEndDate
	,p6_commissioningStartDate
	,p6_commissioningEndDate
	,q_project_id
	,j_project_id
	,p6_project_id
	,j_fcst_date
	,j_start_date
	,q_project_lead
	,q_project_scope
	,hse_project_id
	,p.j_project_sector as JProjectSector
	,p.P6_Start_Date as P6StartDate
,p.procore_project_id ProcoreProjectID
,P.[procore_program_name] [procoreprogramname]
,j_scheduling_frequency JProjectSchedulingFrequency
  FROM [STG].[MASTER].[PROJECT] p
  left outer join dwh.dim.D_Enumeration e on e.enumID = 'Collab-'+cast(p.enum_type as nvarchar(10))
  left outer join dwh.dim.D_BuSector b on b.Sector = isnull(p.[q_project_sector],'') and b.BuLabel = coalesce([q_project_bu],[j_project_bu],'') 
  left outer join dwh.dim.D_ProjectClassif pc on pc.ProjectPhase = isnull(p.[q_project_phase],'-') and pc.ProjectSize = isnull(p.q_project_size,'-') and pc.ProjectRisk = isnull(p.q_project_risk,'-')
 ) S 
ON  T.ProjectNumber = S.project_number and T.EndDate is null  and T.ProjectSK <> -1
WHEN NOT MATCHED BY TARGET
THEN INSERT (JProjectSchedulingFrequency,[procoreprogramname],procoreprojectname,ProcoreProjectID,P6StartDate,JProjectSector,hseprojectid,P6ProjectID,OBSName,P6ProjectStatus,ProjStartDate,ContractualEndDate,p6ForecastDate,EngineeringStartDate,EngineeringEndDate,ProcurementStartDate,ProcurementEndDate,ConstructionStartDate,ConstructionEndDate,CommissioningStartDate,CommissioningEndDate,QAProjectScope,QAProjectLead,QAProjectStatus,JpassForecastDate,JpassStartDate,ProjectBuSectorSk,ProjectClassSk,ProjectNumber,ProjectName,Projectcustomer,projectstatus,ProjectBU,ProjectSector,ProjectPhase,ProjectSize,ProjectRisk,ProjectProgram,StartDate,jpassprojectid,qaprojectid,EnumTypeSK)
   VALUES (S.JProjectSchedulingFrequency,S.[procoreprogramname],S.procoreprojectname,S.ProcoreProjectID,S.P6StartDate,S.JProjectSector, S.hse_project_id,S.p6_project_id,S.obsname,S.p6_project_status,S.p6_fcst_start_date,S.p6_plan_end_date,S.p6_scd_end_date,S.p6_engineeringStartDate,S.p6_engineeringEndDate,S.p6_procurementStartDate,S.p6_procurementEndDate,S.p6_constructionStartDate,S.p6_constructionEndDate,S.p6_commissioningStartDate,S.p6_commissioningEndDate,S.q_project_scope,S.q_project_lead,S.q_project_status,S.j_fcst_date,S.j_start_date,S.BuSectorSK,S.ProjectClassSK,S.project_number,S.project_name,S.project_customer,S.project_status,S.project_bu,S.project_sector,s.project_phase,s.project_size,S.project_risk,S.project_program,cast(cast(getdate() as date) as datetime),j_project_id,q_project_id,S.EnumTypeSK)
;
------------Update Tiqad & Collab sector---------------------------------

update p
set 
CollabSector = case 
	when j_project_sector = 'Asset Management' or q_project_bu ='Asset Management' or q_project_sector = 'Fusion' then N'Asset Management'
	when j_project_sector = 'Building' or q_project_sector = 'Buildings & Urban' then N'Building'
	when j_project_sector = 'Energy' or q_project_sector = 'Energy' then N'Energy'
	when j_project_sector = 'Fertilizer' or q_project_sector = 'Fertilizer' then N'Fertilizer'
	when j_project_sector = 'Ma''aden' or q_project_name like '%Ma''aden%' then N'Ma''aden'
	when j_project_sector = 'Mining' or q_project_sector = 'Mining' then N'Mining'
	when j_project_sector = 'MPH' or q_project_sector = 'Central Axis' then N'MPH'
	when j_project_sector = 'South AXE M&I' or q_project_sector = 'South Axis (PFC)' then N'South AXE M&I'
	when j_project_sector = 'Transport' or q_project_sector = 'Port & Transport' then N'Transport'
	when j_project_sector = 'Water' or q_project_sector = 'Water & Environment' then N'Water'
end ,
TiqadSector = case 
	when j_project_sector = 'Asset Management' or q_project_bu ='Asset Management' or q_project_sector = 'Fusion' then N'Asset Management'
	when j_project_sector = 'Building' or q_project_sector = 'Buildings & Urban' then N'Buildings & Urban'
	when j_project_sector = 'Energy' or q_project_sector = 'Energy' then N'Energy'
	when j_project_sector = 'Fertilizer' or q_project_sector = 'Fertilizer' then N'Fertilizer'
	when j_project_sector = 'Ma''aden' or q_project_name like '%Ma''aden%' then N'Ma''aden'
	when j_project_sector = 'Mining' or q_project_sector = 'Mining' then N'Mining'
	when j_project_sector = 'MPH' or q_project_sector = 'Central Axis' then N'Central Axis'
	when j_project_sector = 'South AXE M&I' or q_project_sector = 'South Axis (PFC)' then N'South Axis (PFC)'
	when j_project_sector = 'Transport' or q_project_sector = 'Port & Transport' then N'Port & Transport'
	when j_project_sector = 'Water' or q_project_sector = 'Water & Environment' then N'Water & Environment'
end

from dwh.dim.d_project p
inner join stg.master.PROJECT pp on p.ProjectNumber = pP.Project_Number
------------Update BU from SAP---------------------------------
update  project
set ProjectSAPBU = isnull(left(p.PRCTR,3),'-')
from dwh.dim.D_Project project
inner join stg.sap.proj p on p.PSPID = project.ProjectNumber
------------Update Procore Project---------------------------------
update  project
set [ProcoreBU] = [custom_fields_custom_field_82842_value_label]
,[ProcoreSector]=[custom_fields_custom_field_82849_value_label]
,[ProcoreServiceType]=[custom_fields_custom_field_82909_value_label]
,[ProcoreActive]=is_demo
,[ProcoreDemo]=active

from dwh.dim.D_Project project
inner join stg.PROCORE.projects p on p.id_project = project.ProcoreProjectID

------------Update SAP Customer---------------------------------
update  t
set t.SAPCustomer = s.CustomerName
from dwh.dim.D_Project t
outer apply (select distinct k.NAME1 CustomerName
from [STG].[SAP].[PRPS] p
outer apply (select distinct pr.PSPID from stg.sap.proj pr where pr.PSPNR=p.[PSPHI]) pro
left join dwh.dim.D_ProfitCenter pr on pr.ProfitCenterCode = p.PRCTR
left outer join stg.sap.kna1 k on RIGHT('00000000000' + Convert(varchar,k.KUNNR ), 10)=p.ZZKUNNR
where ZZKUNNR is not null
and (t.ProjectNumber=pro.PSPID or t.ProjectNumber=p.POSID)
)s

END;
GO
/****** Object:  StoredProcedure [FACT].[PROCORE_PROD]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FACT].[PROCORE_PROD]
AS
BEGIN
------------F_PayIssued--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table DWH.FACT.F_PayIssued
-------insert into F_PayIssued -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_PayIssued] (
      [PayIssuedID]
    , [RequisitionID]
    , [PayIssuedSK]
    , [ProjectSK]
    , [ContractSK]
    , [PayIssuedCreationDate]
    , [PayIssuedDate]
    , [DatePaymentSettled]
    , [DatePaymentInitiated]
    , [PaymentStatus]
    , [PaymentAmount]
    , [ContractCurrency]
    , [ConversionRate]
)

select distinct [id] PayIssuedID
		,[requisition_id] RequisitionID
		,isnull(PayIssuedSK,-1) PayIssuedSK
	  ,isnull(p.projectsk,-1) ProjectSK
 ,isnull(cr.ContractSK,-1) ContractSK


      ,cast([created_at] as datetime) PayIssuedCreationDate
      ,[date] PayIssuedDate
      ,cast([date_payment_settled] as date) DatePaymentSettled
      ,cast([date_payment_initiated] as date) datePaymentInitiated

      ,[status] PaymentStatus
	   ,cast([amount] as numeric(17,2)) PaymentAmount
	   ,cr.ContractCurrency
,case when cr.ContractCurrency='MAD' then 1 else ex.[Taux de conversion] end ConversionRate
  FROM [STG].[PROCORE].[ContractPayment] c
  left outer join DWH.DIM.D_PayIssued dp on dp.PayIssuedID = c.id
     left outer join dwh.dim.D_PROCCONTRACT cr on cr.ContractID=c.[contract_id]
	    left outer join dwh.dim.D_Project p  on p.procoreprojectid = c.project_id and p.EndDate is null
		   left outer join dwh.dim.D_ExchangeRate ex on ex.Période='T' + CAST(DATEPART(QUARTER, c.[created_at]) AS VARCHAR(1)) + ' ' + CAST(DATEPART(YEAR, c.[created_at]) AS VARCHAR(4))
   and ex.Devise=cr.ContractCurrency

------------F_Variation--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
Truncate table dwh.fact.F_Variation
-------insert into F_Variation -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_Variation] (
      [VARID]
    , [VarNumber]
    , [VarRevision]
    , [ProjectSK]
    , [ContractSK]
    , [VarStatusSK]
    , [CORSK]
    , [CreatorSK]
    , [CreationDate]
    , [InvoiceDate]
    , [DueDate]
    , [PaidDate]
    , [UpdateDate]
    , [IsExecuted]
    , [VarGrandTotal]
    , [ContractCurrency]
    , [ConversionRate]
    , [VendorSK]
)

SELECT distinct cast(c.id as varchar(250)) VARID 
,cast(c.number as varchar(250)) VarNumber
,cast(revision  as varchar(50)) VarRevision 
,isnull(ProjectSK,-1) ProjectSK
,isnull(ContractSK,-1) ContractSK
,isnull(ProcStatusSK,-1) VarStatusSK
,isnull(CORSK,-1) CORSK
,isnull(u.UserSK,-1) CreatorSK
  
,cast(c.created_at as datetime) CreationDate
,cast(invoiced_date as datetime) InvoiceDate
,cast(due_date as datetime) DueDate
,cast(paid_date as datetime) PaidDate
,cast(c.updated_at as datetime) UpdateDate
,case when c.executed='false' then 0 when c.executed='true' then 1 else -1 end isExecuted 
,cast(c.grand_total as numeric(17,2))VarGrandTotal 
,v.ContractCurrency ContractCurrency
,case when ContractCurrency='MAD' then 1 else ex.[Taux de conversion] end ConversionRate 
,isnull(vc.VendorSK,-1) VendorSK
FROM STG.PROCORE.variation c
left outer join DWH.DIM.D_procStatus vs on vs.ProcStatus=c.Status
left outer join DWH.DIM.D_ChangeOrderRequest co on co.CORID=c.change_order_request_id
left outer join dwh.dim.D_ProcContract v on v.ContractID=c.contract_id
left outer join dwh.dim.D_Project pr on pr.ProcoreProjectID = c.id_project and pr.EndDate is null
left outer join dwh.dim.D_ProcUser u on u.UserID = c.created_by_id
left join stg.procore.commitments_subcontracts_work_order oc on oc.id=c.contract_id
  left outer join dwh.dim.D_Vendor vc on vc.VendorID = oc.vendor_id  
  left outer join dwh.dim.D_ExchangeRate ex on ex.Période='T' + CAST(DATEPART(QUARTER, c.created_at) AS VARCHAR(1)) + ' ' + CAST(DATEPART(YEAR, c.created_at) AS VARCHAR(4))
   and ex.Devise=v.ContractCurrency


END;
GO
/****** Object:  StoredProcedure [FACT].[usp_CSP]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FACT].[usp_CSP]
AS
BEGIN
------------f_safetyperformance--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table dwh.fact.f_safetyperformance
-------insert into f_safetyperformance -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_SafetyPerformance] (
      [SpID]
    , [ProjectSK]
    , [ContractSK]
    , [StatusEnumSK]
    , [CompanySK]
    , [CreatorSK]
    , [CreationDate]
    , [Updatedate]
    , [SpMonth]
    , [SpYear]
    , [SpQualEvalRaisedActions]
    , [AuditEvalPlanned]
    , [AuditEvalConducted]
    , [CmHseEnforcement]
    , [CmHseNonCompliance]
    , [CmNcrCloseOut]
    , [ChsrNbContractorsHseSupervisor]
    , [HmFitToWorkHealthAssesment]
    , [HmWorkingHeightMedAssesTraining]
    , [HmPplWorkingHeight]
    , [HmActualFirstAidersOnSite]
    , [Ltifr]
    , [Trifr]
    , [Fatality]
    , [MalPlannedSiteLeadership]
    , [MalSiteLeadershipWalksCond]
    , [MalRaisedInMeeting]
    , [RrActuals]
    , [RrPlanned]
    , [TotalOnsite]
    , [ContKeyPersons]
    , [WorkingHoursMonth]
    , [NbcompletedbyCs]
    , [NbSampledContractor]
    , [NbTasksCarried]
    , [Average]
    , [HseTrainingHours]
    , [NbStartsOnProject]
    , [Attended]
    , [TbtConducted]
    , [TbtPlanned]
)

SELECT  sp_id as SpID
      ,isnull(p.ProjectSK,-1) ProjectSK
      ,isnull(co.ContractSK,-1) ContractSK
      ,isnull(e.enumSK,-1) StatusEnumSK
      ,isnull(c.CompanySK,-1) CompanySK
      ,isnull(ca.CacheAdUserSK,-1) CreatorSK
      ,cast(left(sp_creation_date,23) as datetime) CreationDate
      ,cast(left(sp_update_date,23) as datetime) Updatedate
      ,cast(sp_month as int) SpMonth
      ,cast(sp_year as int) SpYear
      ,cast(sp_qual_eval_raised_actions as int)  SpQualEvalRaisedActions
      ,cast(audit_evaluation_planned as int)  AuditEvalPlanned
      ,cast(audit_evaluation_conducted as int)  AuditEvalConducted
      ,cast(cm_hse_enforcement as int)  CmHseEnforcement
      ,cast(cm_hse_non_compliance as int)  CmHseNonCompliance
      ,cast(cm_ncr_close_out as int)  CmNcrCloseOut
      ,cast(chsr_nb_contractors_hse_supervisor as int)  ChsrNbContractorsHseSupervisor
      ,cast(hm_fit_to_work_health_assessment as int)  HmFitToWorkHealthAssesment
      ,cast(hm_working_at_height_medical_assessments_and_training as int)  HmWorkingHeightMedAssesTraining
      ,cast(hm_people_working_at_height as int)  HmPplWorkingHeight
      ,cast(hm_actual_first_aiders_on_site as int)  HmActualFirstAidersOnSite
      ,cast(li_ltifr as numeric(17,2)) Ltifr
      ,cast(li_trifr as numeric(17,2)) Trifr
      ,cast(li_fatality as numeric(17,2)) Fatality
      ,cast(mal_planned_site_leadership_walks as int) MalPlannedSiteLeadership
      ,cast(mal_site_leadership_walks_conducted as int)  MalSiteLeadershipWalksCond
      ,cast(mal_raised_in_meeting as int)  MalRaisedInMeeting
      ,cast(rr_actual as int)  RrActuals
      ,cast(rr_planned as int)  RrPlanned
      ,cast(sp2_total_on_site as int)  TotalOnsite
      ,cast(sp2_contractors_key_persons as int)  ContKeyPersons
      ,cast(sp2_working_hours_during_the_month as int)  WorkingHoursMonth
      ,cast(tp_number_of_completed_by_cs as int)  NbcompletedbyCs
      ,cast(tp_number_of_sampled_by_contractors as int)  NbSampledContractor
      ,cast(tp_number_of_tasks_carried as int)  NbTasksCarried
      ,cast(tp_average as int)  Average
	  ,cast(tm_all_hse_training_hours as int)  HseTrainingHours
	  ,cast(tm_number_of_starts_on_project as int)  NbStartsOnProject
	  ,cast(tm_attended as int)  Attended
	  ,cast(tm_number_of_tbt_conducted as int)  TbtConducted
	  ,cast(tm_number_of_tbt_planned as int)  TbtPlanned
  FROM STG.ds.v_csp_safety_performance sp
  left outer join dwh.dim.D_Project p on p.JPassProjectID = sp.project_id and p.EndDate is null
  left outer join dwh.dim.D_Company c on c.CompanyID = sp.sp_contractor_id
  left outer join dwh.dim.D_Enumeration e on e.enumID =   'CSP-'+cast(sp_status as nvarchar(10)) 
  left outer join dwh.dim.D_CacheAdUsers ca on ca.CacheAdUserID = sp.sp_creator_id and ca.SourceSystem='Collab'
  left outer join dwh.dim.D_Contract co on co.ContractID = sp.contract_id

------------F_SpComments--------------------------------------------------------------------------------------------------------------------------------
MERGE DWH.FACT.F_SpComments AS T
USING (select c.safety_performance_id as SpID,profile_name,comment,0 isDeleted from stg.ds.csp_comment c where isnull(c.safety_performance_id,'') <> ''
  ) S 
ON  T.SpID = S.SpID and T.ProfileName=S.profile_name and T.SpComment=S.comment 

WHEN NOT MATCHED BY TARGET
   THEN INSERT (SpID,ProfileName,SpComment,isDeleted)
   VALUES (S.SpID,S.profile_name,S.comment,S.isDeleted)
WHEN NOT MATCHED BY SOURCE and T.spcommentsk<> -1
THEN UPDATE SET t.isDeleted=1;


------------F_Attachement--------------------------------------------------------------------------------------------------------------------------------
MERGE DWH.FACT.F_Attachement AS T
USING (select a.safety_performance_id SpID,a.type attachementtype,a.attachment_name AttachementName,a.uploaded_file_name UploadedFileName,0 isDeleted from stg.ds.csp_attachment a
  ) S 
ON  T.SpID = S.SpID and T.AttachementType=S.AttachementType and T.AttachementName=S.AttachementName  and T.UploadedFileName=S.UploadedFileName 

WHEN NOT MATCHED BY TARGET
   THEN INSERT (SpID,AttachementType,AttachementName,UploadedFileName,isDeleted)
   VALUES (S.SpID,S.AttachementType,S.AttachementName,S.UploadedFileName,S.isDeleted)
WHEN NOT MATCHED BY SOURCE and T.SpAttachementSK<> -1
THEN UPDATE SET t.isDeleted=1;



------------F_MonitoringInspection--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table DWH.FACT.F_MonitoringInspection
-------insert into F_MonitoringInspection -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_MonitoringInspection] (
      [SPID]
    , [TypeEnumSK]
    , [CreationDate]
    , [UpdateDate]
    , [Planned]
    , [Conducted]
    , [RaisedAction]
    , [ClosedAction]
    , [ClosedWithin]
    , [RecordedByKeyPersons]
    , [TotalSors]
    , [NumberOfAreas]
)

select c.safety_performance_id SPID,
isnull(e.EnumSK,-1) TypeEnumSK,
cast(left(creation_date,23) as datetime) Creationdate,
cast(left(update_date,23) as datetime) UpdateDate,
case when isnull(planned,'')='' then null else cast(planned as int) end as Planned,
case when isnull(conducted,'')='' then null else cast(conducted as int) end as Conducted,
case when isnull(raised_action,'')='' then null else cast(raised_action as int) end as RaisedAction,
case when isnull(closed_action,'')='' then null else cast(closed_action as int) end as ClosedAction,
case when isnull(cosed_within,'')='' then null else cast(cosed_within as int) end as ClosedWithin,
case when isnull(recorded_by_key_persons,'')='' then null else cast(recorded_by_key_persons as int) end as RecordedByKeyPersons,
case when isnull(total_sors,'')='' then null else cast(total_sors as int) end as totalSors,
case when isnull(number_of_area,'')='' then null else cast(number_of_area as int) end as NumberOfAreas
 from stg.ds.csp_monitoring_and_inspection c
 left outer join dwh.dim.D_Enumeration e on e.enumID = 'CSP-'+cast(c.type as nvarchar(10))
END;
GO
/****** Object:  StoredProcedure [FACT].[usp_HSE]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FACT].[usp_HSE]
AS
BEGIN
-- Truncate tables
TRUNCATE TABLE dwh.fact.F_SubEvent;
TRUNCATE TABLE dwh.fact.f_sor;
TRUNCATE TABLE dwh.fact.F_StaticInputMonth;

-- Define CTEs and create temp table
WITH proj AS (
    SELECT DISTINCT [Project]
    FROM [STG].[HSE].[SOR]
    UNION
    SELECT DISTINCT [Projectvalue]
    FROM [STG].[HSE].[StatisticInputMonth]
    UNION
    SELECT DISTINCT [Projectvalue]
    FROM [STG].[HSE].[SubEvent]
),
projList AS (
    SELECT DISTINCT Project,
        CASE 
            WHEN CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) > 0 
            THEN SUBSTRING(Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1, CHARINDEX('- ', Project, CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) + 1) - CHARINDEX('- ', Project, CHARINDEX('- ', Project) + 1) - 1) 
            ELSE NULL 
        END AS project_number
    FROM proj
)
SELECT * INTO #projList FROM projList;

-- Insert into F_SubEvent
INSERT INTO [FACT].[F_SubEvent] (
    SubEventID,
    SubEventTypeSK,
    SubmiterSK,
    SubEventSK,
    ProjectSK,
    DatevalueKey,
    CreatedDateKey,
    ModifiedDateKey,
    Datevalue,
    Created,
    Modified
)
select Id SubEventID,
isnull(se.SubEventTypeSK,-1) SubEventTypeSK,
isnull(sm.SubmiterSK,-1) SubmiterSK,
isnull(su.SubEventSK,-1) SubEventSK,
isnull(p.projectsk,-1) ProjectSK,
year(cast(cast(dateadd(hour,5,datevalue) as date)  as datetime))*10000+month(cast(cast(dateadd(hour,5,datevalue) as date)  as datetime))*100+day(cast(cast(dateadd(hour,5,datevalue) as date)  as datetime)) DatevalueKey,
year(Created)*10000+month(Created)*100+day(Created) CreatedDateKey,
year(Modified)*10000+month(Modified)*100+day(Modified) ModifiedDateKey,
cast(cast(dateadd(hour,5,datevalue) as date)  as datetime) Datevalue,
Created,
Modified
from stg.hse.SubEvent s
left outer join dwh.dim.D_SubEventType se on se.SubEventValue = isnull(s.SubEventValue,'-') and se.TypeValue = isnull(s.TypeValue,'-')
left outer join dwh.dim.D_Submiter sm on sm.SubmiterValue = isnull(s.SubmiterValue,'-') and sm.MailValue = isnull(s.MailValue,'-')
left outer join dwh.dim.D_SubEvent su on su.SubEventID = s.Id
left outer join #projList pj on pj.Project = s.Projectvalue
left outer join dwh.dim.D_Project p on p.ProjectNumber = rtrim(ltrim(pj.project_number)) and enddate is null


-- Insert into f_sor 
INSERT INTO [FACT].[F_SOR] (
    SORID,
    SORSK,
    ProjectSK,
    SubmiterSK,
    SORDateKey,
    DateOfClosureKey,
    DueDateKey,
    CreatedKey,
    ModifiedKey,
    SORDate,
    DateOfClosure,
    DueDate,
    Created,
    Modified
)
select Id SORID,
isnull(ds.SORSK,-1) SORSK,
isnull(p.projectsk,-1) ProjectSK,
isnull(sm.SubmiterSK,-1) SubmiterSK,
isnull(year(cast(cast(dateadd(hour,5,date) as date)  as datetime))*10000+month(cast(cast(dateadd(hour,5,date) as date)  as datetime))*100+
day(cast(cast(dateadd(hour,5,date) as date)  as datetime)),-1) SORDateKey,
isnull(year(cast(cast(dateadd(hour,5,DateOfClosure) as date)  as datetime))*10000+month(cast(cast(dateadd(hour,5,DateOfClosure) as date)  as datetime))*100
+day(cast(cast(dateadd(hour,5,DateOfClosure) as date)  as datetime)),-1) DateOfClosureKey,
isnull(year(cast(cast(dateadd(hour,5,DueDate) as date)  as datetime))*10000+month(cast(cast(dateadd(hour,5,DueDate) as date)  as datetime))*100+
day(cast(cast(dateadd(hour,5,DueDate) as date)  as datetime)),-1) DueDateKey,
isnull(year(Created)*10000+month(Created)*100+day(Created),-1) CreatedKey,
isnull(year(Modified)*10000+month(Modified)*100+day(Modified),-1) ModifiedKey,
 cast(cast(dateadd(hour,5,date) as date)  as datetime) SORDate,
 cast(cast(dateadd(hour,5,DateOfClosure) as date)  as datetime) DateOfClosure,
 cast(cast(dateadd(hour,5,DueDate) as date)  as datetime) DueDate,
 Created,
 Modified
from stg.hse.sor s
left outer join dwh.dim.D_SOR ds on ds.SORID = s.id
left outer join #projList pj on pj.Project = s.Project
left outer join dwh.dim.D_Project p on p.ProjectNumber = rtrim(ltrim(pj.project_number)) and enddate is null
left outer join dwh.dim.D_Submiter sm on sm.MailValue = isnull(s.MailValue,'-')

-- Insert data into F_StatisticInputMonth table
INSERT INTO [FACT].[F_StaticInputMonth] (
    SIMID,
    ProjectSK,
    DatevalueKey,
    ValidatedKey,
    CreatedKey,
    ModifiedKey,
    MPValue,
    MHValue,
    SPAValue,
    SORValue,
    TBTValue,
    InductionValue,
    Datevalue,
    TrainingHours,
    Validated,
    Created,
    Modified
)
select Id,
isnull(p.projectsk,-1) ProjectSK,
isnull(year(cast(cast(dateadd(hour,5,datevalue) as date)  as datetime))*10000+month(cast(cast(dateadd(hour,5,datevalue) as date)  as datetime))*100
+day(cast(cast(dateadd(hour,5,datevalue) as date)  as datetime)),-1) DatevalueKey,
isnull(year(Validated)*10000+month(Validated)*100+day(Validated),-1) ValidatedKey,
isnull(year(Created)*10000+month(Created)*100+day(Created),-1) CreatedKey,
isnull(year(Modified)*10000+month(Modified)*100+day(Modified),-1) ModifiedKey,
MPValue,
MHValue,
SPAValue,
SORValue,
TBTValue,
InductionValue,
cast(cast(dateadd(hour,5,datevalue) as date)  as datetime) Datevalue,
TrainingHours,
Validated,
Created,
Modified
from stg.hse.StatisticInputMonth s
outer apply (select sum(cast(People_Trained as numeric(17,2))*cast(Hours_of_training as numeric(17,2))) TrainingHours from stg.hse.Training t
where t.Projectvalue=s.Projectvalue and dateadd(d,1,cast(left(Training_Date,8) as datetime))= cast(cast(dateadd(hour,5,datevalue) as date)  as datetime))tr
left outer join #projList pj on pj.Project = s.Projectvalue
left outer join dwh.dim.D_Project p on p.ProjectNumber = rtrim(ltrim(pj.project_number)) and enddate is null


-- Drop temp table
    DROP TABLE #projList;

END;	
GO
/****** Object:  StoredProcedure [FACT].[usp_JPASS]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FACT].[usp_JPASS]
AS
BEGIN
------------F_EmpTraining--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
TRUNCATE TABLE  dwh.FACT.F_EmpTraining
-------insert into F_EmpTraining -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_EmpTraining] (
        [EmpTrainingID],
        [TrainingSK],
        [TrainerSK],
        [CategorySK],
        [EmpCommentSK],
        [ValidationSK],
        [EmployeeSK],
        [StartDateKey],
        [StartDate],
        [ExpiringDateKey],
        [ExpiringDate],
        [EmpIsPresent],
        [EmpIsPassed],
        [TraningDuration],
        [EmpInitialScore],
        [EmpFinalScore],
        [EmpPasseGate],
        [CalculateDate]
    )
SELECT  ft.emp_training_id EmpTrainingID,ISNULL(DT.TrainingSK,-1) TrainingSK,
ISNULL(DTR.TrainerSK,-1) TrainerSK,
ISNULL(DTC.CategorySK,-1) CategorySK,
ISNULL(DVS.ValidationSK,-1) ValidationSK,
ISNULL(DE.EmployeeSK,-1) EmployeeSK,
ISNULL(DC.EmpCommentSK,-1) EmpCommentSK,
year(training_start_date)*10000+month(training_start_date)*100+day(training_start_date) StartDateKey,
cast(training_start_date as datetime) as StartDate,
year(training_expiring_date)*10000+month(training_expiring_date)*100+day(training_expiring_date) ExpiringDateKey,
cast(training_expiring_date as datetime) as ExpiringDate,
case when left(employee_is_present,1)='t' then 1 when left(employee_is_present,1)='f' then 0 else -1 end EmpIsPresent,  
case when left(employee_is_passed,1)='t' then 1 when left(employee_is_passed,1)='f' then 0 else -1 end EmpIsPassed,  
case when training_duration='' or training_duration is null then null else  training_duration end TraningDuration,   
case when employee_initial_score='' or employee_initial_score is null then null else  employee_initial_score end EmpInitialScore,
case when employee_final_score='' or employee_final_score is null then null else  employee_final_score end EmpFinalScore,
case when employee_passe_gate='' or employee_passe_gate is null then null else  employee_passe_gate end EmpPasseGate,
(select param_value from stg.param.param_utlity where param_label='Last Execution Month') calc_date
  FROM [STG].ds.V_jpass_training FT
  LEFT OUTER JOIN DWH.DIM.D_Training DT ON DT.TrainingID = FT.training_id  
  LEFT OUTER JOIN DWH.DIM.D_Trainer DTR ON DTR.Trainer = FT.training_trainer  
  LEFT OUTER JOIN DWH.DIM.D_TrainingCategory DTC ON DTC.CategoryCode = FT.employee_category_id
  LEFT OUTER JOIN DWH.DIM.D_ValidationStatus DVS ON DVS.ValidationID = FT.training_validation_status_code
  LEFT OUTER JOIN DWH.DIM.D_EmployeeDetails DE ON DE.EmpID = FT.employee_id
  LEFT OUTER JOIN DWH.DIM.D_EmpComments  DC ON DC.EmpCommentID = FT.emp_training_id
where year(ft.training_start_date)>=2021

------------f_workorder--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table dwh.fact.f_workorder
-------insert into f_workorder -----------------------------------------------------------

INSERT INTO [DWH].[FACT].[F_WorkOrder] (
        [WorkOrderID],
        [WorkOrderSK],
        [ProjectSK],
        [CreationDateKey],
        [UpdateDateKey],
        [IsOverallWorkOrder]
    )
select id as WorkOrderID,
isnull(dw.WorkOrderSK,-1) WorkOrderSK,
isnull(p.ProjectSK,-1) ProjectSK,
year(creation_date)*10000 + month(creation_date)*100 + day(creation_date) CreationDateKey,
case when isnull(update_date,'')='' then -1 else year(update_date)*10000 + month(update_date)*100 + day(update_date) end UpdateDateKey,
case when left(is_overall_work_order,1)='f' then 0 else 1 end as IsOverallWorkOrder
from stg.ds.COLLAB_work_order wo
left outer join dwh.dim.D_WorkOrder dw on dw.WorkOrderNumber = wo.number
left outer join dwh.dim.D_Project p on p.JPassProjectID = wo.id_project and p.EndDate is null

------------F_EmpCertificate--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
TRUNCATE TABLE  dwh.fact.F_EmpCertificate 

-------insert into F_EmpCertificate -----------------------------------------------------------
    INSERT INTO [DWH].[FACT].[F_EmpCertificate] (
        [EmployeeSK],
        [CompanySK],
        [CertificateSK],
        [AccOrganizationSK],
        [ValidationSK],
        [CertificateDateKey],
        [CertificateDate],
        [IsMedical],
        [IsApt],
        [CertificateExpiringDateKey],
        [CertificateExpiringDate],
        [CalculateDate]
    )
    SELECT 
        ISNULL(DE.EmployeeSK, -1) AS EmployeeSK,
        ISNULL(DC.CompanySK, -1) AS CompanySK,
        ISNULL(DCC.CertificateSK, -1) AS CertificateSK,
        ISNULL(DAO.AccOrganizationSK, -1) AS AccOrganizationSK,
        ISNULL(VS.ValidationSK, -1) AS ValidationSK,
        YEAR(c.certificate_date) * 10000 + MONTH(c.certificate_date) * 100 + DAY(c.certificate_date) AS CertificateDateKey,
        CAST(c.certificate_date AS DATETIME) AS CertificateDate,
        CASE 
            WHEN LEFT(sc.certificate_medical, 1) = 't' THEN 1 
            WHEN LEFT(sc.certificate_medical, 1) = 'f' THEN 0 
            ELSE -1 
        END AS IsMedical,
        CASE 
            WHEN LEFT(c.certificate_apt, 1) = 't' THEN 1 
            WHEN LEFT(c.certificate_apt, 1) = 'f' THEN 0 
            ELSE -1 
        END AS IsApt,
        YEAR(c.certificate_expiring_date) * 10000 + MONTH(c.certificate_expiring_date) * 100 + DAY(c.certificate_expiring_date) AS CertificateExpiringDateKey,
        CAST(c.certificate_expiring_date AS DATETIME) AS CertificateExpiringDate,
        (SELECT param_value FROM stg.param.param_utlity WHERE param_label = 'Last Execution Month') AS CalculateDate  /*chanement de calc_date a CalculateDate */
    FROM 
        STG.ds.v_jpass_emp_certificates c
        LEFT OUTER JOIN stg.ds.v_jpass_certification sc ON sc.certificate_id = c.certificate_id
        LEFT OUTER JOIN DWH.DIM.D_EmployeeDetails DE ON DE.EmpID = c.employee_id
        LEFT OUTER JOIN DWH.DIM.D_Company DC ON DC.CompanyID = c.company_id
        LEFT OUTER JOIN DWH.DIM.D_CERTIFICATE DCC ON DCC.CertificateID = c.certificate_id
        LEFT OUTER JOIN DWH.DIM.D_ValidationStatus VS ON VS.ValidationStatus = c.certificate_validation_status
        LEFT OUTER JOIN DWH.DIM.D_AccOrganization DAO ON DAO.AccOrganization = c.certificate_accredited_organization;
------------F_EmpBehavior--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
TRUNCATE TABLE dwh.FACT.F_EmpBehavior
-------insert into F_EmpBehavior -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_EmpBehavior] (
        [EmployeeSK],
        [BehaviorSK],
        [CompanySK],
        [ValidationSK],
        [BehaviorTypeSK],
        [BehaviorDateKey],
        [BehaviorDate],
        [BehaviorExpDateKey],
        [BehaviorExpDate],
        [CalculateDate]
    )

SELECT  ISNULL(DE.EmployeeSK,-1) EmployeeSK,
		ISNULL(DB.BehaviorSK,-1) BehaviorSK,
		ISNULL(DC.CompanySK,-1) CompanySK,
		ISNULL(VS.ValidationSK,-1) ValidationSK,
		ISNULL(BT.BehaviorTypeSK,-1) BehaviorTypeSK,
		year(behavior_date)*10000+month(behavior_date)*100+day(behavior_date) BehaviorDateKey,
        cast(behavior_date as datetime) BehaviorDate,
		year(behavior_expiring_date)*10000+month(behavior_expiring_date)*100+day(behavior_expiring_date) BehaviorExpDateKey,
        cast(behavior_expiring_date as datetime) BehaviorExpDate,
(select param_value from stg.param.param_utlity where param_label='Last Execution Month') calc_date
  FROM STG.ds.v_jpass_behavior B
  LEFT OUTER JOIN DWH.DIM.D_EmployeeDetails DE ON DE.EmpID = B.employee_id  
  LEFT OUTER JOIN DWH.DIM.D_Behavior DB ON DB.BehaviorID = B.behavior_id
  LEFT OUTER JOIN DWH.DIM.D_Company DC ON DC.CompanyID = B.company_id
  LEFT OUTER JOIN DWH.DIM.D_BehaviorType BT ON BT.BehaviorTypeID = B.behavior_type_id and bt.BehaviorLabelID = b.behavior_label_id
  LEFT OUTER JOIN DWH.DIM.D_ValidationStatus VS ON vs.ValidationID = b.behavior_validation_status_code

------------F_EmpProjectScan--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
TRUNCATE TABLE dwh.FACT.F_EmpProjectScan

-------insert into F_EmpProjectScan -----------------------------------------------------------
    INSERT INTO [DWH].[FACT].[F_EmpProjectScan] (
        [EmployeeSK],
        [ProjectSK],
        [ScannedOpTypeSK],
        [EmpProjStatus],
        [EmpIsDeleted],
        [StartDateKey],
        [StartDate],
        [EndDateKey],
        [EndDate],
        [ScannedDateKey],
        [ScannedDate],
        [CalculateDate]
    )
SELECT ISNULL(DE.EmployeeSK,-1) EmployeeSK,
       ISNULL(DP.ProjectSK,-1) ProjectSK,
       ISNULL(DS.ScannedOpTypeSK,-1) ScannedOpTypeSK,
       case when left(employee_project_status,1)='t' then 1 when left(employee_project_status,1)='f' then 0 else -1 end EmpProjStatus,
       case when left(employee_is_deleted,1)='t' then 1 when left(employee_is_deleted,1)='f' then 0 else -1 end EmpIsDeleted,
	   year(employee_project_start_date)*10000+month(employee_project_start_date)*100+day(employee_project_start_date) StartDateKey,
	   cast(employee_project_start_date as datetime) as StartDate,
	   year(employee_project_end_date)*10000+month(employee_project_end_date)*100+day(employee_project_end_date) EndDateKey,
	   cast(employee_project_end_date as datetime) as EndDate,
	   year(scanned_date)*10000+month(scanned_date)*100+day(scanned_date) ScannedDateKey,
	  cast( left(scanned_date,19) as datetime) as ScannedDate,
(select param_value from stg.param.param_utlity where param_label='Last Execution Month') calc_date
  FROM [STG].[ds].v_jpass_scan_history p
  --left outer join stg.ds.v_collab_project pr on pr.project_id=p.project_id
   LEFT OUTER JOIN DWH.DIM.D_EmployeeDetails DE ON DE.EmpID = P.employee_id  
   LEFT OUTER JOIN DWH.DIM.D_Project DP ON DP.JPassProjectID = p.project_id and dp.EndDate is null --and dp.ProjectName = pr.project_name
   LEFT OUTER JOIN dwh.dim.D_ScannedOpType DS on ds.ScannedOpTypeID = p.scanned_operation_type_code

------------F_CompanyEquipement--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table dwh.fact.F_CompanyEquipement
-------insert into F_CompanyEquipement -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_CompanyEquipement] (
        [EquipementSK],
        [EnumTypeSK],
        [CompanySK],
        [SubContractorSK]
    )
SELECT  isnull(EquipementSK,-1) EquipementSK
      ,isnull(de.EnumSK,-1) EnumTypeSK
      ,isnull(co.CompanySK,-1) CompanySK
      ,isnull(cs.CompanySK,-1) SubContractorSK
  FROM STG.ds.v_jpass_company_equipement e
  left outer join dwh.dim.D_Enumeration de on 'JPass-'+cast(e.enum_type as nvarchar(20)) = de.enumID
  left outer join dwh.dim.D_Company co on co.CompanyID = e.company_id 
  left outer join dwh.dim.D_Company cs on cs.CompanyID = e.subcontractor_id
  left outer join dwh.dim.D_ConstructionEquipement eq on eq.EquipementID = e.equipment_id

------------f_projectCompany--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table fact.f_projectCompany
-------insert into f_projectCompany -----------------------------------------------------------

INSERT INTO [DWH].[FACT].[F_ProjectCompany] (
        [ProjectSK],
        [CompanySK]
    )

SELECT distinct isnull(p.ProjectSK,-1) ProjectSK
,isnull(cc.CompanySK,-1) CompanySK
from stg.[ds].[v_collab_project_work_dimension] c
left outer join dwh.dim.D_Project p on p.JPassProjectID = c.id_project and p.EndDate is null
left outer join dwh.dim.D_Company cc on cc.CompanyID = c.contractor

---------F_EquipementCertificate--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table DWH.FACT.F_EquipementCertificate
-------insert into F_EquipementCertificate -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_EquipementCertificate] (
        [EquipementCertifcateID],
        [CertificateSK],
        [EquipementSK],
        [ValidationSK],
        [CertificateDateKey],
        [CertificateDate],
        [CertificateExpiringDateKey],
        [CertificateExpiringDate],
        [AccOrganizationSK],
        [CreationDateKey],
        [CreationDate],
        [UpdateDateKey],
        [UpdateDate]
    )
 
SELECT  [id] EquipementCertifcateID
,isnull(ce.CertificateSK ,-1) CertificateSK
      ,isnull(co.EquipementSK,-1) EquipementSK
      ,isnull(va.ValidationSK,-1) ValidationSK
	
      ,year(certificate_date)*10000+month(certificate_date)*100+day(certificate_date) CertificateDateKey
	  ,certificate_date CertificateDate
      ,year([certificate_expiring_date])*10000+month([certificate_expiring_date])*100+day([certificate_expiring_date]) CertificateExpiringDateKey
      ,[certificate_expiring_date] CertificateExpiringDate
      ,isnull(ac.AccOrganizationSK,-1) AccOrganizationSK
	  ,year([creation_date])*10000+month([creation_date])*100+day([creation_date]) CreationDateKey
	  ,[creation_date] CreationDate
	  ,case when [update_date] is null then -1 else year([update_date])*10000+month([update_date])*100+day([update_date]) end UpdateDateKey
	  ,[update_date] UpdateDate
      
  FROM [STG].[ds].[v_jpass_equipment_certificate] c
  left outer join dwh.dim.D_AccOrganization ac on ac.AccOrganization = c.[accredited_organization]
  left outer join dwh.dim.D_Certificate ce on ce.CertificateID = c.[certificate_id]
  left outer join dwh.dim.D_ConstructionEquipement co on co.EquipementID = c.[construction_equipment_id]
  left outer join dwh.dim.D_ValidationStatus va on va.ValidationID = c.[validation_status_id]

------------F_EquipementEmployee--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table  DWH.FACT.F_EquipementEmployee 
-------insert into F_EquipementEmployee -----------------------------------------------------------

 INSERT INTO [DWH].[FACT].[F_EquipementEmployee] (
        [id],
        [EquipementSK],
        [EmployeeSK],
        [CreationDateKey],
        [CreationDate]
    )
SELECT  [id]
      ,isnull(dc.EquipementSK,-1) EquipementSK
      ,isnull(de.EmployeeSK,-1) EmployeeSK
	  ,year([creation_date])*10000+month([creation_date])*100+day([creation_date]) CreationDateKey
	  ,[creation_date] CreationDate
  FROM [STG].[ds].[v_jpass_equipment_employee] e
  left outer join dwh.dim.D_ConstructionEquipement dc on dc.EquipementID = e.[construction_equipment_id]
  left outer join dwh.dim.D_EmployeeDetails de on de.EmpID = e.[employee_id]

------------F_EquipementInspection--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table DWH.FACT.F_EquipementInspection
-------insert into F_EquipementInspection -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_EquipementInspection] (
        [id],
        [EquipementSK],
        [InspectionSK],
        [ValidationSK],
        [InspectionDateKey],
        [InspectionDate],
        [ExpiringDateKey],
        [ExpiringDate],
        [CreationDateKey],
        [CreationDate],
        [UpdateDateKey],
        [UpdateDate]
    )

SELECT  [id]
,isnull(ce.EquipementSK,-1) EquipementSK
      ,isnull(di.InspectionSK,-1) InspectionSK
      ,isnull(va.ValidationSK,-1) ValidationSK
      ,year([inspection_date])*10000+month([inspection_date])*100+day([inspection_date]) InspectionDateKey
	  ,[inspection_date]
	  ,year([expiring_date])*10000+month([expiring_date])*100+day([expiring_date]) ExpiringDateKey
      ,[expiring_date]
      --,[required_action]
      --,[description]
      ,year([creation_date])*10000+month([creation_date])*100+day([creation_date]) CreationDateKey
	  ,[creation_date] CreationDate
	  ,year([update_date])*10000+month([update_date])*100+day([update_date]) UpdateDateKey
	  ,[update_date] UpdateDate
      
  FROM [STG].ds.[v_jpass_equipment_inspection] i
  left outer join DWH.DIM.D_ConstructionEquipement ce on ce.EquipementID = i.[construction_equipment_id]
  left outer join dwh.dim.D_Inspection di on di.InspectionID = i.[inspection]
  left outer join dwh.dim.D_ValidationStatus va on va.ValidationID = i.[validation_status_id]

------------F_EquipementProject--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table DWH.FACT.F_EquipementProject
-------insert into F_EquipementProject -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_EquipementProject] (
        [id],
        [EquipementSK],
        [ProjectSK],
        [StartDateKey],
        [StartDate],
        [EndDateKey],
        [EndDate],
        [StatusKey],
        [assignment_rate],
        [IsDeleted]
    )

SELECT id
      ,isnull(dc.EquipementSK,-1) EquipementSK
      ,isnull(d.ProjectSK,-1) ProjectSK
	  ,year([start_date])*10000+month([start_date])*100+day([start_date]) StartDateKey
      ,[start_date] StartDate
	  ,year([end_date])*10000+month([end_date])*100+day([end_date]) EndDateKey
      ,[end_date] EndDate
      ,case when [status] = 'f' then 0 when [status] = 't' then 1 end StatusKey 
      ,cast([assignment_rate] as numeric(17,2)) [assignment_rate]
      ,case when [is_deleted] = 'f' then 0 when [is_deleted] = 't' then 1 end IsDeleted
  FROM [STG].[ds].[v_jpass_equipment_project] e
  left outer join DWH.DIM.D_ConstructionEquipement dc on dc.EquipementID = e.[construction_equipment_id]
  left outer join dwh.dim.d_project d on d.jpassprojectid = e.[project_id] and d.enddate is null

------------F_EquipementWarning--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate TABLE DWH.FACT.F_EquipementWarning
-------insert into F_EquipementWarning -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_EquipementWarning] (
        [id],
        [EquipementSK],
        [WarningSK],
        [ValidationSK],
        [WarningDateKey],
        [WarningDate],
        [CreationDateKey],
        [CreationDate]
    
)
SELECT id
,isnull(dc.EquipementSK,-1) EquipementSK
,isnull(dw.WarningSK,-1) WarningSK
,isnull(dv.ValidationSK,-1) ValidationSK
      ,year([warning_date])*10000+month([warning_date])*100+day([warning_date]) WarningDateKey 
	  ,[warning_date] WarningDate
	  ,year([creation_date])*10000+month([creation_date])*100+day([creation_date]) CreationDateKey 
	  ,[creation_date] CreationDate

  FROM [STG].[ds].[v_jpass_equipment_warning] w
  left outer join dwh.dim.D_ConstructionEquipement dc on dc.EquipementID = w.[construction_equipment_id]
  left outer join dwh.dim.D_Warning dw on dw.WarningID = w.[warning]
  left outer join dwh.dim.D_ValidationStatus dv on dv.ValidationID = [validation_status_id]


------------F_TaskHistory--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table DWH.FACT.F_TaskHistory
-------insert into F_TaskHistory -----------------------------------------------------------
INSERT INTO [DWH].[FACT].[F_TaskHistory] (
        [TaskHistorySK],
        [ConsEquipmentSK],
        [StartDate],
        [EndDate],
        [CreationDate],
        [UpdateDate]
    )
SELECT isnull(TaskHistorySK,-1) TaskHistorySK
      ,isnull(c.EquipementSK,-1) ConsEquipmentSK
	  ,cast([start_date] as date) StartDate
      ,cast([end_date] as date) EndDate
      ,cast(left([creation_date],23) as datetime) CreationDate
      ,cast(left([update_date],23) as datetime) UpdateDate
           
  FROM [STG].[ds].[jpass_task_history] t
  left outer join DWH.DIM.D_TaskHistory th on th.TaskHistoryID=t.id
  left outer join DWH.DIM.D_ConstructionEquipement c on c.EquipementID=t.[construction_equipment_id]


END;
GO
/****** Object:  StoredProcedure [FACT].[usp_P6]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FACT].[usp_P6]
AS
BEGIN
-- truncate tables
truncate table DWH.FACT.F_ActivityHierarchy
truncate table DWH.FACT.F_PROJECTPHASE
truncate table DWH.FACT.F_ActivitySpread
truncate TABLE DWH.FACT.F_BaselineProject
-- inserting to tables:
  -- F_ActivityHierarchy table
    INSERT INTO [DWH].[FACT].[F_ActivityHierarchy]
          ([ActivityHierarchySK]
          ,[ProjectSK]
          ,[WbsHierarchySK]
          ,[PrimaryResourceObjectId]
          ,[BaseLineStartDate]
          ,[BaseLineFinishDate]
          ,[StartDate]
          ,[FinishDate]
          ,[BaseLineDuration]
          ,[RemainingDuration]
          ,[AtCompletion]
          ,[Schedulepercentcomplete]
          ,[PlannedLaborUnits]
          ,[ActualLaborUnits]
          ,[FloatPath]
          ,[FloatPathOrder]
          ,[TotalFloat]
          ,[UnitsPercentComplete]
          ,[RemainingLaborUnits]
          ,[PlannedDuration]
          ,[PlannedFinishDate]
          ,[PlannedStartDate]
          ,[ActualfinishDate]
          ,[ActualStartDate]
          ,[DataDate]
          ,[ActualTotalUnits]
          ,[AtCompletionVariance]
          ,[BaselinePlannedDuration]
          ,[BaselinePlannedLaborUnits]
          ,[BudgetAtCompletion]
          ,[DurationPercentComplete]
          ,[DurationVariance]
          ,[IsCritical]
          ,[IsLongestPath]
          ,[IsStarred]
          ,[PercentComplete]
          ,[PerformancePercentComplete]
          ,[ActualDuration]
          ,[RemainingFloat]
          ,[ScheduleVariance]
          ,[StartDateVariance])
    SELECT 
        ISNULL(ac.ActivityHierarchySK, -1) AS ActivityHierarchySK
        ,ISNULL(p.ProjectSK, -1) AS ProjectSK
        ,ISNULL(w.WbsHierarchySK, -1) AS WbsHierarchySK
        ,primaryresourceobjectid AS PrimaryResourceObjectId
        ,baselinestartdate AS BaseLineStartDate
        ,baselinefinishdate AS BaseLineFinishDate
        ,a.startdate AS StartDate
        ,finishdate AS FinishDate
        ,baselineduration AS BaseLineDuration
        ,remainingduration AS RemainingDuration
        ,atcompletionduration AS AtCompletion
        ,schedulepercentcomplete AS Schedulepercentcomplete
        ,plannedlaborunits AS PlannedLaborUnits
        ,actuallaborunits AS ActualLaborUnits
        ,floatpath AS FloatPath
        ,floatpathorder AS FloatPathOrder
        ,totalfloat AS TotalFloat
        ,unitspercentcomplete AS UnitsPercentComplete
        ,remaininglaborunits AS RemainingLaborUnits
        ,plannedduration AS PlannedDuration
        ,plannedfinishdate AS PlannedFinishDate
        ,plannedstartdate AS PlannedStartDate
        ,actualfinishdate AS ActualfinishDate
        ,actualstartdate AS ActualStartDate
        ,datadate AS DataDate
        ,actualtotalunits AS ActualTotalUnits
        ,atcompletionvariance AS AtCompletionVariance
        ,baselineplannedduration AS BaselinePlannedDuration
        ,baselineplannedlaborunits AS BaselinePlannedLaborUnits
        ,budgetatcompletion AS BudgetAtCompletion
        ,durationpercentcomplete AS DurationPercentComplete
        ,durationvariance AS DurationVariance
        ,iscritical AS IsCritical
        ,islongestpath AS IsLongestPath
        ,isstarred AS IsStarred
        ,percentcomplete AS PercentComplete
        ,performancepercentcomplete AS PerformancePercentComplete
        ,actualduration AS ActualDuration
        ,remainingfloat AS RemainingFloat
        ,schedulevariance AS ScheduleVariance
        ,startdatevariance AS StartDateVariance
    FROM [STG].[P6].[ACTIVITY] a
    LEFT OUTER JOIN dwh.dim.D_ActivityHierarchy ac 
        ON ac.ActivityHierarchyObjectID = a.objectid 
        AND ac.ActivityHierarchyID = a.id
    LEFT OUTER JOIN dwh.dim.D_Project p 
        ON p.P6ProjectID = a.projectobjectid 
        AND p.EndDate IS NULL
    LEFT OUTER JOIN dwh.dim.D_WbsHierarchy w 
        ON w.WbsHierarchyID = a.wbsobjectid 
        AND w.ChildProjectId = a.projectobjectid;
END;    
GO
/****** Object:  StoredProcedure [FACT].[usp_QA]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FACT].[usp_QA]
AS
BEGIN
--------------F_ACTIVITY TABLE------------------------------------------------------------------------------------------------------

-- PRETRAITEMENT DE LA TABLE  F_ACTIVITY
delete from  FACT.F_ACTIVITY 
where  DAY(ReportingDate)<>5 
    and DATEPART(dw, ReportingDate) <>6 
    and ReportingDate<>'2024-07-02'
-- insert data to F_ACTIVITY----------------------------------
INSERT INTO [DWH].[FACT].[F_Activity] (
    [ActivitySK],
    [ProjectSK],
    [ResultSK],
    [ActivityStatusSK],
    [ActivityTypeSK],
    [ReportStatusSK],
    [ActivityCreationDateKey],
    [ActivityUpdateDateKey],
    [ActivityPlannedDateKey],
    [ActivityConductedDateKey],
    [ActivityCompletedDateKey],
    [ActivityRescheduledDateKey],
    [ActivityCanceledDateKey],
    [ActivityPlannedConductedDateKey],
    [ActivityMonth],
    [ActivityScore],
    [isPreDraft],
    [isToDelete],
    [HasRaisedCapa],
    [FindingVeryHigh],
    [FindingHigh],
    [FindingMedium],
    [FindingLow],
    [FindingOppty],
    [CssSafety],
    [CssScope],
    [CssCommunication],
    [CssTechServices],
    [CssStaffing],
    [CssSchedule],
    [CssCostEstimate],
    [CssFieldServices],
    [CssSuplyMgmt],
    [CssMgmtSupport],
    [ActivityActual],
    [PlannedToDate],
    [PlannedFY],
    [ActivityCount],
    [ActivityRaisedCapa],
    [PlannedFYOverall],
    [ActualsOverall],
    [PlannedToDateOverall],
    [ReportingDate]
)

SELECT  distinct isnull(da.ActivitySK,-1) as ActivitySK
	  ,isnull(dr.ResultSK,-1) ResultSK
	  ,isnull(pr.ProjectSK,-1) ProjectSK
	  ,isnull(das.ActivityStatusSK,-1) ActivityStatusSK
	  ,isnull(dat.ActivityTypeSK,-1) ActivityTypeSK
	  ,isnull(drs.ReportStatusSK,-1) ReportStatusSK
	  ,year(activity_creation_date)*10000+month(activity_creation_date)*100+day(activity_creation_date) ActivityCreationDateKey
	  ,case when activity_update_date is null or activity_update_date='' 
			then -1
			else year(activity_update_date)*10000+month(activity_update_date)*100+day(activity_update_date) 
	   end ActivityUpdateDatekey
	  
	   ,case when activity_planned_date is null or activity_planned_date='' 
			then -1
			else year(activity_planned_date)*10000+month(activity_planned_date)*100+day(activity_planned_date) 
	   end ActivityPlannedDateKey
	   
      ,case when activity_conducted_date is null or activity_conducted_date='' 
			then -1
			else year(activity_conducted_date)*10000+month(activity_conducted_date)*100+day(activity_conducted_date) 
	   end ActivityConductedDateKey
	  
	   ,case when activity_completed_date is null or activity_completed_date='' 
			then -1
			else year(activity_completed_date)*10000+month(activity_completed_date)*100+day(activity_completed_date) 
	   end ActivityCompletedDateKey
	   ,case when activity_rescheduled_date is null or activity_rescheduled_date='' 
			then -1
			else year(activity_rescheduled_date)*10000+month(activity_rescheduled_date)*100+day(activity_rescheduled_date) 
	   end activityrescheduleddatekey
	   ,case when isnull(activity_planned_date,activity_conducted_date) is null or (activity_planned_date='' and activity_conducted_date='')
			then -1
			else year(isnull(activity_planned_date,activity_conducted_date))*10000+month(isnull(activity_planned_date,activity_conducted_date))*100+day(isnull(activity_planned_date,activity_conducted_date)) 
	   end activityplannedconducteddatekey
	   ,case when activity_canceled_date is null or activity_canceled_date='' 
			then -1
			else year(activity_canceled_date)*10000+month(activity_canceled_date)*100+day(activity_canceled_date) 
	   end activitycanceleddatekey
      ,activity_month ActivityMonth
      ,activity_score ActivityScore
      ,case when activity_pre_draft='f' then 0 else 1 end isPreDraft
	  ,case when activity_to_delete='f' then 0 else 1 end isToDelete
	   ,case when activity_any_raised_capa='f' then 0 else 1 end HasRaisedCapa
	   ,cast(activity_raised_capa_number as int) as ActivityRaisedCapa
     
      ,finding_very_high as FindingVeryHigh
      ,finding_high as FindingHigh
      ,finding_medium as FindingMedium
      ,finding_low as FindingLow
      ,finding_opportunity as FindingOppty
      --,css_infos_id
      ,css_safety as CssSafety
      ,css_scope as CssScope
      ,css_communication as CssCommunication
      ,css_tech_services as CssTechServices
      ,css_staffing as CssStaffing
      ,css_schedule as CssSchedule
      ,css_cost_estimate as CssCostEstimate
      ,css_field_services as CssFieldServices
      ,css_supply_mgmt as CssSuplyMgmt
      ,css_mgmt_support as CssMgmtSupport
	  ,k.Actuals
	  ,k.PlannedFY
	  ,k.PlannedToDate
	  ,kk.PlannedFY as PlannedFYOverall
	  ,kk.PlannedToDate PlannedToDateOverall
	  ,kk.Actuals ActualsOverall
,1 ActivityCount
--,isnull(dc.CacheAdUserSK,-1) CreatorSK
--,isnull(de.CacheAdUserSK,-1) ExtraSourceSK
--,isnull(dre.CacheAdUserSK,-1) ResponsibleSK
,cast(getdate() as date) ReportingDate

  FROM stg.ds.QA_ACTIVITY_TRANS a
  left outer join dwh.dim.d_activity da on da.ActivityID = a.activity_id and da.EndDate is null
  left outer join DWH.DIM.D_Result dr on dr.ResultCode = a.activity_result_code
  left outer join DWH.DIM.D_ActivityStatus das on das.ActivityStatusCode = a.activity_status_code
  left outer join dwh.dim.D_Project pr on pr.QaProjectID = a.project_id and pr.EndDate is null
  left outer join DWH.DIM.D_ActivityType dat on dat.ActivityCategory = a.activity_category and dat.ActivityDiscipline=a.activity_discipline and dat.ActivityProgress=a.activity_progress and dat.ActivitySubCategory=a.activity_subcategory and dat.ActivityType=a.activity_type
  left outer join DWH.DIM.D_ReportStatus drs on drs.ReportStatusCode = a.report_finding_code
  left outer join DWH.dim.D_CacheAdUsers dc on dc.CacheAdUserID = a.activity_creator_id  
  left outer join DWH.dim.D_CacheAdUsers de on de.CacheAdUserID = a.activity_extra_source_id
  left outer join DWH.dim.D_CacheAdUsers dre on dre.CacheAdUserID = a.activity_responsible_id
  outer apply (
  select cast(coalesce((case when (activity_status = 'CONDUCTED' or activity_status = 'COMPLETED')  and (ac.activity_month in (select * from dbo.getPriorFiscalMonth(month(getdate())))) then 1 else 0 end), 0) as int) as Actuals,
	cast(coalesce((case when activity_status <> 'CANCELED'  and (ac.activity_planned_date is not null or ac.activity_rescheduled_date is not null) and (ac.activity_month in (select * from dbo.getPriorFiscalMonth(month(getdate())))) then 1 else 0 end), 0) as int) as PlannedToDate,
	cast(coalesce((case when activity_status <> 'CANCELED'  and (ac.activity_planned_date is not null or ac.activity_rescheduled_date is not null) then 1 else 0 end), 0) as int) as PlannedFY 
    FROM [STG].ds.[v_qa_activity_kpi] ac
	where ac.activity_id = a.activity_id
	and planning_fiscal_year=dbo.getFiscalYear(getdate())
  )k
    outer apply (
  select cast(coalesce((case when (activity_status = 'CONDUCTED' or activity_status = 'COMPLETED')  and (ac.activity_month in (select * from dbo.getPriorFiscalMonth(month(getdate())))) then 1 else 0 end), 0) as int) as Actuals,
	cast(coalesce((case when activity_status <> 'CANCELED'  and (ac.activity_planned_date is not null or ac.activity_rescheduled_date is not null) and (ac.activity_month in (select * from dbo.getPriorFiscalMonth(month(getdate())))) then 1 else 0 end), 0) as int) as PlannedToDate,
	cast(coalesce((case when activity_status <> 'CANCELED'  and (ac.activity_planned_date is not null or ac.activity_rescheduled_date is not null) then 1 else 0 end), 0) as int) as PlannedFY 
    FROM [STG].ds.[v_qa_activity_kpi] ac
	where ac.activity_id = a.activity_id
  )kk

-------------F_Planing-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------- F_Planing table ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--praitraitement de la table F_Planing 
delete from  FACT.F_PLANNING where  DAY(ReportingDate)<>5 and DATEPART(dw, ReportingDate) <>6 and ReportingDate<>'2024-07-02'
-- insert into F_Plaining table-------------
INSERT INTO [DWH].[FACT].[F_Planning]
(
      [PlanningSK]
    , [PlanningStatusSK]
    , [PlanningActivityTypeSK]
    , [ProjectSK]
    , [PlanningCreationDateKey]
    , [PlanningUpdateDateKey]
    , [fiscal_year]
    , [PlanningCount]
    , [ReportingDate]
)
SELECT distinct   isnull(PlanningSK,-1) as PlanningSK
      ,isnull(PlanningStatusSK,-1) as PlanningStatusSK
      ,isnull(dp.PlanningActivityTypeSK,-1) as PlanningActivityTypeSK
	  ,isnull(ProjectSK,-1) as ProjectSK


	  ,case when planning_creation_date is null or planning_creation_date='' 
			then -1
			else year(planning_creation_date)*10000+month(planning_creation_date)*100+day(planning_creation_date) 
	   end PlanningCreationDateKey
	   ,case when planning_update_date is null or planning_update_date='' 
			then -1
			else year(planning_update_date)*10000+month(planning_update_date)*100+day(planning_update_date) 
	   end PlanningUpdateDateKey
      ,fiscal_year
      ,1 PlanningCount
,cast(getdate() as date) ReportingDate
  FROM STG.ds.v_qa_PLANNING p
  left outer join stg.ds.v_qa_PROJECT po on po.project_id = p.project_id
  left outer join DWH.DIM.D_PlanningActivityType dp on dp.PlanningActivityTypeCode = p.planning_activity_type_code
  left outer join DWH.DIM.D_PROJECT pr on pr.QaProjectID = po.project_id and pr.enddate is null
  left outer join DWH.DIM.D_PlanningStatus ps on ps.PlanningStatusCode = p.planning_status_code
  left outer join DWH.DIM.D_Planning pp on pp.PlanningID = p.planning_id and pp.EndDate is null

--------- F_CAPA ---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- praitraitement de la table F_CAPA -------
delete from  FACT.F_CAPA where  DAY(ReportingDate)<>5 and DATEPART(dw, ReportingDate) <>6 and ReportingDate<>'2024-07-02'
-- insert into F_CAPA------------------------
INSERT INTO [DWH].[FACT].[F_Capa]
(
      [CapaSK]
    , [ActivitySK]
    , [RootCauseSK]
    , [CapaStatusSK]
    , [CapaOverdueRatingSK]
    , [CapaRiskSK]
    , [ProjectSK]
    , [CapaIssueDateKey]
    , [CapaCreationDateKey]
    , [CapaClosedDateKey]
    , [CapaPlannedImplementationKey]
    , [CapaOverdueActionDelays]
    , [CapaCount]
    , [ReportingDate]
)
SELECT distinct  isnull(dc.CapaSK,-1) CapaSK
      ,isnull(da.ActivitySK,-1) as ActivitySK
	  ,isnull(drc.RootCauseSK,-1) as RootCauseSK
	  ,isnull(cs.CapaStatusSK,-1) CapaStatusSK
	  ,isnull(od.CapaOverdueRatingSK,-1) CapaOverdueRatingSK 
	  ,isnull(dr.CapaRiskSK,-1) CapaRiskSK 
	  ,isnull(dp.ProjectSK,-1) ProjectSK
	  ,case when capa_issue_date is null or capa_issue_date='' 
			then -1
			else year(capa_issue_date)*10000+month(capa_issue_date)*100+day(capa_issue_date) 
	   end CapaIssueDateKey
	   ,case when capa_creation_date is null or capa_creation_date='' 
			then -1
			else year(capa_creation_date)*10000+month(capa_creation_date)*100+day(capa_creation_date) 
	   end CapaCreationDateKey
	   ,case when capa_closed_date is null or capa_closed_date='' 
			then -1
			else year(capa_closed_date)*10000+month(capa_closed_date)*100+day(capa_closed_date) 
	   end CapaClosedDateKey
	  ,case when capa_planned_implementation is null or capa_planned_implementation='' 
			then -1
			else year(capa_planned_implementation)*10000+month(capa_planned_implementation)*100+day(capa_planned_implementation) 
	   end CapaPlannedImplementationKey
      ,case when capa_overdue_action_delays='' then null else capa_overdue_action_delays end as CapaOverdueActionDelays
	  ,1 as CapaCount
,cast(getdate() as date) ReportingDate
  FROM STG.ds.v_qa_CAPA c
  --left outer join stg.ds.v_qa_PROJECT po on po.project_id = c.project_id
  left outer join dwh.dim.d_capa dc on dc.CapaID = c.capa_id and dc.EndDate is null  
  left outer join dwh.dim.D_Activity da on da.ActivityID = c.activity_id and da.EndDate is null
  left outer join dwh.dim.D_Project dp on dp.QaProjectID = c.project_id and dp.EndDate is null
  left outer join dwh.dim.D_RootCause drc on drc.RootCauseCode = c.capa_root_cause_code  
  left outer join dwh.dim.D_CapaStatus cs on cs.CapaStatusCode = c.capa_status_code  
  left outer join dwh.dim.D_OverdueRating od on od.CapaOverdueRatingCode = c.capa_overdue_rating_code 
  left outer join dwh.dim.D_Risk dr on dr.CapaRiskCode = c.capa_risk_level_code

--------------F_PlanningActivity--------------------------------------------------------------------------------------------------------------------------------
--praitraitement---------------------------------
delete from  FACT.F_PlanningActivity where  DAY(ReportingDate)<>5 and DATEPART(dw, ReportingDate) <>6 and ReportingDate<>'2024-07-02'
--insert into table-----------------------------
INSERT INTO [DWH].[FACT].[F_PlanningActivity]
(
      [ActivitySK]
    , [PlanningSK]
    , [ReportingDate]
)
select distinct isnull(a.ActivitySK,-1) ActivitySK,
	   isnull(d.PlanningSK,-1) PlanningSK 
,cast(getdate() as date) ReportingDate
from stg.ds.v_qa_ACTIVITY_PLANNING ap
left outer join dwh.dim.D_Activity a on a.ActivityID = ap.activity_id and a.EndDate is null
left outer join dwh.dim.D_Planning d on d.PlanningID = ap.planning_id and d.EndDate is null

-------F_FindingReport-------------------------------------------------------------------------------------------------------------------------------------------------------
--praitraitement de table F_FindingReport ----------------------------------------------------
delete from  FACT.F_FindingReport where  DAY(ReportingDate)<>5 and DATEPART(dw, ReportingDate) <>6;
-- insert into the table F_FindingReport-------------------------------------------------------
WITH findingReport AS (
    SELECT c.id AS activityFindingID,
           a.id AS activity_id,
           c.report_id,
           N'Very high' AS FindingLevel,
           [very_high] AS FindingLevelValue
      FROM [STG].[ds].[qa_activity_finding_report] c
      INNER JOIN [stg].[ds].[qa_activity] a ON a.activity_finding_report = c.id
      INNER JOIN [stg].[ds].[qa_enumeration] e ON e.id = c.report_status

    UNION

    SELECT c.id AS activityFindingID,
           a.id AS activity_id,
           c.report_id,
           N'High' AS FindingLevel,
           [high] AS FindingLevelValue
      FROM [STG].[ds].[qa_activity_finding_report] c
      INNER JOIN [stg].[ds].[qa_activity] a ON a.activity_finding_report = c.id
      INNER JOIN [stg].[ds].[qa_enumeration] e ON e.id = c.report_status

    UNION

    SELECT c.id AS activityFindingID,
           a.id AS activity_id,
           c.report_id,
           N'Medium' AS FindingLevel,
           [medium] AS FindingLevelValue
      FROM [STG].[ds].[qa_activity_finding_report] c
      INNER JOIN [stg].[ds].[qa_activity] a ON a.activity_finding_report = c.id
      INNER JOIN [stg].[ds].[qa_enumeration] e ON e.id = c.report_status

    UNION

    SELECT c.id AS activityFindingID,
           a.id AS activity_id,
           c.report_id,
           N'Low' AS FindingLevel,
           [low] AS FindingLevelValue
      FROM [STG].[ds].[qa_activity_finding_report] c
      INNER JOIN [stg].[ds].[qa_activity] a ON a.activity_finding_report = c.id
      INNER JOIN [stg].[ds].[qa_enumeration] e ON e.id = c.report_status

    UNION

    SELECT c.id AS activityFindingID,
           a.id AS activity_id,
           c.report_id,
           N'Opportunity' AS FindingLevel,
           [opportunity] AS FindingLevelValue
      FROM [STG].[ds].[qa_activity_finding_report] c
      INNER JOIN [stg].[ds].[qa_activity] a ON a.activity_finding_report = c.id
      INNER JOIN [stg].[ds].[qa_enumeration] e ON e.id = c.report_status
)
INSERT INTO [DWH].[FACT].[F_FindingReport]
(
      [ActivitySK]
    , [FindingReportSK]
    , [FindingLevelSK]
    , [FindingLevelValue]
    , [ReportingDate]
)
SELECT DISTINCT
      ISNULL(da.ActivitySK, -1) AS ActivitySK,
      ISNULL(fr.FindingReportSK, -1) AS FindingReportSK,
      ISNULL(df.FindingLevelSK, -1) AS FindingLevelSK,
      a.FindingLevelValue,
      CAST(GETDATE() AS DATE) AS ReportingDate
FROM findingReport a
LEFT OUTER JOIN [DWH].[DIM].[D_Activity] da ON da.ActivityID = a.activity_id AND da.EndDate IS NULL
LEFT OUTER JOIN [DWH].[DIM].[D_FindingReport] fr ON fr.FindingReportID = a.report_id
LEFT OUTER JOIN [DWH].[DIM].[D_FindingLevel] df ON df.FindingLevel = a.FindingLevel;

------------F_CSS---------------------------------
--pretraitement-----------------
delete from  FACT.F_CSS where  DAY(ReportingDate)<>5 and DATEPART(dw, ReportingDate) <>6 and ReportingDate<>'2024-07-02';
-- insert into the table F_FindingReport-------------------------------------------------------
    WITH activity AS (
        SELECT  
            activity_id,
            css_safety AS [Css Safety],
            css_scope AS [Css Scope],
            css_communication AS [Css Communication],
            css_tech_services AS [Css Tech Services],
            css_staffing AS [Css Staffing],
            css_schedule AS [Css Schedule],
            css_cost_estimate AS [Css Cost Estimate],
            css_field_services AS [Css Field Services],
            css_supply_mgmt AS [Css Suply Mgmt],
            css_mgmt_support AS [Css Mgmt Support]
        FROM 
            stg.ds.QA_ACTIVITY_TRANS a
    ), 
    data_trans AS ( 
        SELECT 
            activity_id, 
            css_infos, 
            css_info_value  
        FROM   
            (SELECT 
                activity_id, 
                [Css Safety], 
                [Css Scope], 
                [Css Communication], 
                [Css Tech Services], 
                [Css Staffing], 
                [Css Schedule], 
                [Css Cost Estimate], 
                [Css Field Services], 
                [Css Suply Mgmt], 
                [Css Mgmt Support]
            FROM 
                activity) p  
        UNPIVOT (  
            css_info_value FOR css_infos IN ( 
                [Css Safety], 
                [Css Scope], 
                [Css Communication], 
                [Css Tech Services], 
                [Css Staffing], 
                [Css Schedule], 
                [Css Cost Estimate], 
                [Css Field Services], 
                [Css Suply Mgmt], 
                [Css Mgmt Support]
            )
        ) AS unpvt
    )
    
    -- Insert into the target table
    INSERT INTO [DWH].[FACT].[F_CSS] ([ActivitySK], [CssInfoSK], [CssValue], [ReportingDate])
    SELECT DISTINCT  
        ISNULL(da.ActivitySK, -1) AS ActivitySK,
        ISNULL(c.CssInfoSK, -1) AS CssInfoSK,
        a.css_info_value AS CssValue,
        CAST(GETDATE() AS DATE) AS ReportingDate
    FROM 
        data_trans a
    LEFT OUTER JOIN 
        dwh.dim.d_activity da ON da.ActivityID = a.activity_id AND da.EndDate IS NULL 
    LEFT OUTER JOIN 
        DWH.DIM.D_CssInfos c ON c.CssInfo = a.css_infos;

------------F_ActivityUsers---------------------------------
--pretraitement-----------------
delete from  FACT.F_ActivityUsers where  DAY(ReportingDate)<>5 and DATEPART(dw, ReportingDate) <>6 and ReportingDate<>'2024-07-02';
------ insert into F_ActivityUsers -------------------------------------------------
    WITH actv AS (
        SELECT 
            a.activity_id,
            a.activity_creator_id AS cache_ad_user_id,
            N'Creator' AS cache_ad_user_type 
        FROM 
            stg.ds.qa_ACTIVITY_TRANS a 
        WHERE 
            a.activity_creator_id IS NOT NULL 
        UNION ALL
        SELECT 
            a.activity_id,
            a.activity_extra_source_id AS cache_ad_user_id,
            N'Extra Source' AS cache_ad_user_type 
        FROM 
            stg.ds.qa_ACTIVITY_TRANS a  
        WHERE 
            a.activity_extra_source_id IS NOT NULL 
        UNION ALL
        SELECT 
            a.activity_id,
            a.activity_responsible_id AS cache_ad_user_id,
            N'Responsible' AS cache_ad_user_type 
        FROM 
            stg.ds.qa_ACTIVITY_TRANS a 
        WHERE 
            a.activity_responsible_id IS NOT NULL
    )

    -- Insert into the target table
    INSERT INTO [DWH].[FACT].[F_ActivityUsers] ([CacheAdUserSK], [ActivitySK], [CacheAdUserType], [ReportingDate])
    SELECT DISTINCT
        ISNULL(dc.CacheAdUserSK, -1) AS CacheAdUserSK,
        ISNULL(ac.ActivitySK, -1) AS ActivitySK,
        a.cache_ad_user_type AS CacheAdUserType,
        CAST(GETDATE() AS DATE) AS ReportingDate
    FROM 
        actv a
    LEFT OUTER JOIN 
        DWH.dim.D_CacheAdUsers dc ON dc.CacheAdUserID = a.cache_ad_user_id  
    LEFT OUTER JOIN 
        DWH.dim.D_Activity ac ON ac.ActivityID = a.activity_id AND ac.EndDate IS NULL;

END;    
GO
/****** Object:  StoredProcedure [FACT].[usp_SAP]    Script Date: 02/08/2024 07:54:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [FACT].[usp_SAP]
AS
BEGIN
------------F_GAs--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
TRUNCATE TABLE [FACT].[F_GAs]
-------insert into F_GAs -----------------------------------------------------------

INSERT INTO FACT.F_GAs (CostCenterID,CostElementID,EmployeeID,
[Cost Elemet Name],[Cost Element Desc],[Personnel Number],
[Company Code],[Posting Date],[CO Object Name],
[Posted unit of meas#],[Total quantity],[Val/COArea Crcy],
EmployeeCostCenterID,Period) 

SELECT 
 isnull(cc.CostCenterID,-1),
 isnull(CostElementID,-1),
 isnull(emp.EmployeeID,-1) EmployeeID,
 ecc.[Cost element name],
 ecc.[Cost element descr#],
 [Personnel Number],
 [Company Code],
 [Posting Date],
 [CO Object Name],
 [Posted unit of meas#],
 [Total quantity],
 [Val/COArea Crcy],
 isnull(cceEmp.CostCenterID,-1) as [EmployeeCostCenterID],
 Period
FROM [STG].[SPS].[ExtractionCostCenters] ecc
 LEFT JOIN DWH.DIM.D_CostCenter cc on ecc.[Cost Center] = cc.CostCenterCode and ecc.[Company Code] = cc.CompanyCode
 LEFT JOIN DWH.DIM.D_CostElement ce on ecc.[Cost Element] = ce.CostElementCode 
 LEFT JOIN DWH.DIM.D_Employee emp on emp.EMP_SAP_ID =  RIGHT('000000000' + Convert(varchar,[Personnel Number] ), 8)
 OUTER APPLY (
 select distinct 
    PERNR as EMP_SAP_ID,
    KOSTL as CostCenter
FROM stg.SAP.PA0001 P1 
WHERE MANDT = 100 AND P1.PERSG NOT IN ('S','Y') and [Posting Date] between CONVERT(datetime, convert(varchar(10), BEGDA)) and CONVERT(datetime, convert(varchar(10), ENDDA))
and p1.PERNR = emp.EMP_SAP_ID
 )empAs
 --LEFT JOIN DWH.DIM.D_EmployeeAssignment empAs on empAs.EmployeeID = emp.EmployeeID and empAs.EndDate = 99991231
 LEFT JOIN DWH.DIM.D_CostCenter cceEmp on RIGHT('00000000000' + Convert(varchar,cceEmp.CostCenterCode ), 10) = empAs.CostCenter  and cceEmp.CompanyCode = ecc.[Company Code]

------------F_Revenue--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
truncate table dwh.fact.F_Revenue
-------insert into F_Revenue -----------------------------------------------------------
INSERT INTO DWH.FACT.F_Revenue([ProfitCenterID]
      ,[WBSID]
      ,[GLAccountID]
      ,[CompanyCode]
      ,[FiscalYear]
      ,[PostingPeriod]
      ,[DocumentCurrencyValue]
      ,[DocumentCurrencyKey]
      ,[DocumentNumber]
      ,[BusinessUnit]
)
SELECT 
  isnull(pc.ProfitCenterID,-1),
  isnull(WBSID,-1) ,
  isnull(GLAccountID,-1),
  [Company Code] as CompanyCode
      ,[Fiscal Year] as FiscalYear
      ,[Posting period] as PostingPeriod
      ,[Document Currency Value] as DocumentCurrencyValue
      ,[Document Currency Key] as DocumentCurrencyKey
      ,[Document Number] as DocumentNumber
      ,[BU] as BusinessUnit
  FROM [STG].[SPS].[RApostingsPB] ra
  left join DWH.DIM.D_ProfitCenter pc on pc.ProfitCenterCode = ra.[Profit Center]
  left join DWH.DIM.D_WBS wbs on wbs.[WBSElement] = ra.[WBS Element]
  left join DWH.DIM.D_GLAccount gl on gl.[GLAccount] = ra.[G/L Account]
 where [Document Currency Key] is not null
------------F_GL--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
TRUNCATE TABLE FACT.F_GL
-------insert into F_GL -----------------------------------------------------------
insert into DWH.FACT.F_GL([GLAccountID]
      ,[CostCenterID]
      ,[CompanyCode]
      ,[DocumentCurrencyValue]
      ,[DocumentCurrencyKey]
      ,[PersonalNumber]
      ,[BusinessArea]
      ,[PostingDate]
      ,[PostingPeriod])
SELECT 
  isnull(gl.GLAccountID,-1) GLAccountID
  ,isnull(cs.CostCenterID,-1)
  ,[Company Code] as CompanyCode
  ,[Document Currency Value] as DocumentCurrencyValue
        ,[Document Currency Key] as DocumentCurrencyKey
  ,[Personnel Number] as PersonalNumber
  ,[Business Area] as BusinessArea
  ,[Posting Date] as PostingDate
  ,[Posting period] as PostingPeriod
  FROM [STG].[SPS].[ExtractionGLPB] glpb
  LEFT JOIN DWH.DIM.D_GLAccount gl on glpb.[G/L Account] = gl.GLAccount
  LEFT JOIN DWH.DIM.D_CostCenter cs on cs.CostCenterCode = glpb.[Cost Center]
  where [Document Date] is not null
------------F_ActivityHours--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
TRUNCATE TABLE DWH.FACT.F_ActivityHours
-------insert into F_ActivityHours -----------------------------------------------------------
insert into dwh.fact.F_ActivityHours (
[EmployeeID]
      ,[TimesID]
      ,[AWART]
      ,[CATSHOURS]
      ,[EMP_SAP_ID]
      ,[WorkDate]
      ,[BILLABLE]
      ,[ProjectTaskSK],ModifiedDate)
select 
isnull(de.EmployeeID,-1) EmployeeID,
isnull(t.TimesID,-1) TimesID,
AWART,
CATSHOURS,
RIGHT('000000000' + Convert(varchar,c.PERNR ), 8) PERNR,
year(WORKDATE)*10000+Month(WORKDATE)*100+day(Workdate) WORKDATE,
case when ltrim(rtrim(ZBILLABLE)) ='Y' then 1 when  ltrim(rtrim(ZBILLABLE)) = 'N' then 0 else -1 end BILLABLE,
isnull(d.ProjectTaskSK,-1) ProjectTaskSK,
LAEDA as ModifiedDate
from STG.SAP.CATSDB c
left outer join DWH.DIM.D_ProjectTasks d on d.ProjectLabel = c.RPROJ_TXT and isnull(d.TaskLabel,'')=isnull(substring(RNETWORK_TXT ,0,charindex('(',RNETWORK_TXT ,0)) ,'')
left outer join dwh.dim.D_Times t on t.ID = c.AWART
left outer join dwh.dim.D_Employee de on de.EMP_SAP_ID =  RIGHT('000000000' + Convert(varchar,c.PERNR ), 8)
------------F_COST--------------------------------------------------------------------------------------------------------------------------------
--truncate table -----------------------------------------------------------------------------------
TRUNCATE TABLE DWH.FACT.F_COST
-------insert into F_COST -----------------------------------------------------------
 insert into dwh.fact.F_COST (
 [CostElementID]
      ,[CostCenterID]
    ,[EmployeeID]
      ,[EmployeeCostCenterID]
   ,[WBSID]
      ,[Document Number]
      ,[Company Code]
      ,[Total Quantity1]
      ,[Val/COArea Crcy]
      ,[Value in Obj# Crcy]
      ,[Posting Date]
     
      ,[UnitOfMeasure]
      ,[Billable project (Y/N)]
      
      ,[wbs_element])
SELECT isnull([CostElementID],-1)
      ,isnull(pc.CostCenterID,-1)
    ,isnull(emp.[EmployeeID],-1)
   ,isnull(cceEmp.CostCenterID,-1) as [EmployeeCostCenterID]
    ,isnull(wbs.WBSID,-1)
      ,[Document Number]
      ,[Company Code]
      ,[Total Quantity] as [Total Quantity1]
      ,[Val/COArea Crcy]
      ,[Val/COArea Crcy] as [Value in Obj# Crcy]
      ,[Transaction date]
  
   ,[Posted unit of meas#] as UnitOfMeasure
   ,[Billable project (Y/N)] 
  
   ,cc.[WBS element]
  FROM [STG].[SPS].[ExtractionCostPB] cc
 LEFT JOIN DWH.DIM.D_CostElement ce on ce.CostElementCode = cc.[Cost Element] 
 LEFT JOIN DWH.DIM.D_CostCenter pc on pc.CostCenterCode = cc.[Sender Cost Center] and pc.CompanyCode = cc.[Company Code]
 LEFT JOIN DWH.DIM.D_Employee emp on RIGHT('000000000' + Convert(varchar,[Personnel Number] ), 8) = emp.EMP_SAP_ID 
 LEFT JOIN DWH.DIM.D_EmployeeAssignment empAs on empAs.EmployeeID = emp.EmployeeID and empAs.EndDate = 99991231
 LEFT JOIN DWH.DIM.D_CostCenter cceEmp on RIGHT('00000000000' + Convert(varchar,cceEmp.CostCenterCode ), 10) = empAs.CostCenter  and cceEmp.CompanyCode = cc.[Company Code]
 LEFT JOIN DWH.DIM.D_WBS wbs on wbs.WBSElement = cc.[WBS element]
where isnull(rtrim(ltrim([Project definition])),'')<>''
END;

GO
USE [master]
GO
ALTER DATABASE [DWH] SET  READ_WRITE 
GO
