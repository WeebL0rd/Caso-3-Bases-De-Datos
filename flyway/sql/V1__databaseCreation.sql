USE [pvDB]
GO
/****** Object:  Schema [pvDB]    Script Date: 6/9/2025 7:08:50 PM ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'pvDB')
BEGIN
    EXEC('CREATE SCHEMA pvDB');
END
GO
/****** Object:  Table [pvDB].[cf_crowfundingEvents]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[cf_crowfundingEvents](
	[crowfundingID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[equity] [decimal](18, 2) NOT NULL,
	[fundingGoal] [decimal](18, 3) NOT NULL,
	[currency_id] [int] NOT NULL,
	[startDate] [date] NOT NULL,
	[endDate] [date] NOT NULL,
	[checksum] [varbinary](400) NOT NULL,
	[crowfundingStatusID] [smallint] NOT NULL,
 CONSTRAINT [PK_cf_crowfundingEvents_crowfundingID] PRIMARY KEY CLUSTERED 
(
	[crowfundingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[cf_financialReports]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[cf_financialReports](
	[financialReportID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[reportPeriodStart] [date] NOT NULL,
	[reportPeriodEnd] [date] NOT NULL,
	[uploadedBy] [int] NOT NULL,
	[uploadDate] [datetime2](0) NOT NULL,
	[reportStatusID] [int] NOT NULL,
	[proposalDocumentID] [int] NOT NULL,
 CONSTRAINT [PK_cf_financialReports_financialReportID] PRIMARY KEY CLUSTERED 
(
	[financialReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[cf_financialResults]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[cf_financialResults](
	[financialResultID] [int] IDENTITY(1,1) NOT NULL,
	[financialReportID] [int] NOT NULL,
	[grossIncome] [decimal](18, 2) NOT NULL,
	[operationalCosts] [decimal](18, 2) NOT NULL,
	[netProfit] [decimal](18, 2) NOT NULL,
	[currencyID] [int] NOT NULL,
 CONSTRAINT [PK_cf_financialResults_financialResultID] PRIMARY KEY CLUSTERED 
(
	[financialResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[cf_fundingProgresses]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[cf_fundingProgresses](
	[progressID] [int] IDENTITY(1,1) NOT NULL,
	[crowfundingID] [int] NOT NULL,
	[currentFunding] [decimal](18, 3) NOT NULL,
	[investors] [int] NOT NULL,
	[creationDate] [date] NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
	[active] [binary](1) NOT NULL,
 CONSTRAINT [PK_cf_fundingProgresses_progressID] PRIMARY KEY CLUSTERED 
(
	[progressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[cf_investments]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[cf_investments](
	[investmentID] [int] IDENTITY(1,1) NOT NULL,
	[crowfundingID] [int] NOT NULL,
	[investedAmount] [decimal](18, 3) NOT NULL,
	[equityEarned] [decimal](18, 5) NOT NULL,
	[investmentDate] [datetime2](0) NOT NULL,
	[statusID] [smallint] NOT NULL,
	[userID] [int] NOT NULL,
	[transactionID] [int] NOT NULL,
	[checksum] [varbinary](400) NOT NULL,
 CONSTRAINT [PK_cf_investments_investmentID] PRIMARY KEY CLUSTERED 
(
	[investmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[cf_payouts]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[cf_payouts](
	[payoutID] [int] IDENTITY(1,1) NOT NULL,
	[financialReportID] [int] NOT NULL,
	[investmentID] [int] NOT NULL,
	[equityPercent] [decimal](5, 2) NOT NULL,
	[amountToPay] [decimal](18, 2) NOT NULL,
	[paymentStatusID] [smallint] NOT NULL,
	[transactionID] [int] NULL,
	[paid] [binary](1) NOT NULL,
 CONSTRAINT [PK_cf_payouts_payoutID] PRIMARY KEY CLUSTERED 
(
	[payoutID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_addresses]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_addresses](
	[addressID] [int] IDENTITY(1,1) NOT NULL,
	[line1] [nvarchar](200) NOT NULL,
	[line2] [nvarchar](200) NULL,
	[zipcode] [nvarchar](9) NOT NULL,
	[geoposition] [geometry] NOT NULL,
	[cityID] [int] NOT NULL,
 CONSTRAINT [PK_pv_addresses_addressID] PRIMARY KEY CLUSTERED 
(
	[addressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_approvalCriteriaTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_approvalCriteriaTypes](
	[approvalTypeID] [int] IDENTITY(1,1) NOT NULL,
	[type] [nvarchar](60) NOT NULL,
 CONSTRAINT [PK_pv_approvalCriteriaTypes_approvalTypeID] PRIMARY KEY CLUSTERED 
(
	[approvalTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_availablePayMethods]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_availablePayMethods](
	[available_method_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[userID] [int] NOT NULL,
	[token] [varbinary](400) NOT NULL,
	[expToken] [date] NOT NULL,
	[maskAccount] [nvarchar](50) NOT NULL,
	[methodID] [int] NOT NULL,
 CONSTRAINT [PK_pv_availablePayMethods_available_method_id] PRIMARY KEY CLUSTERED 
(
	[available_method_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_biometricData]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_biometricData](
	[biometricDataID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
	[biometricTypeID] [smallint] NOT NULL,
	[deviceID] [int] NOT NULL,
 CONSTRAINT [PK_pv_biometricData_biometricDataID] PRIMARY KEY CLUSTERED 
(
	[biometricDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_biometricDevices]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_biometricDevices](
	[deviceID] [int] IDENTITY(1,1) NOT NULL,
	[model] [nvarchar](30) NOT NULL,
	[brand] [nvarchar](30) NOT NULL,
	[serialNumber] [nvarchar](30) NOT NULL,
	[manufacturer] [nvarchar](50) NOT NULL,
	[creationDate] [datetime2](0) NOT NULL,
	[deleted] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_biometricDevices_deviceID] PRIMARY KEY CLUSTERED 
(
	[deviceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [pv_biometricDevices$serialNumber_UNIQUE] UNIQUE NONCLUSTERED 
(
	[serialNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_biometricFiles]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_biometricFiles](
	[biometricFileID] [int] IDENTITY(1,1) NOT NULL,
	[biometricDataID] [int] NOT NULL,
	[mediaFileID] [int] NOT NULL,
 CONSTRAINT [PK_pv_biometricFiles_biometricFileID] PRIMARY KEY CLUSTERED 
(
	[biometricFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_biometricResults]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_biometricResults](
	[biometricResultID] [int] IDENTITY(1,1) NOT NULL,
	[biometricDataID] [int] NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
	[confidence] [decimal](5, 2) NOT NULL,
	[biometricFeatures] [nvarchar](max) NULL,
	[result] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_biometricResults_biometricResultID] PRIMARY KEY CLUSTERED 
(
	[biometricResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_biometricTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_biometricTypes](
	[biometricTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[minConfidence] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_pv_biometricTypes_biometricTypeID] PRIMARY KEY CLUSTERED 
(
	[biometricTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_cities]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_cities](
	[cityID] [int] IDENTITY(1,1) NOT NULL,
	[stateID] [int] NOT NULL,
	[name] [nvarchar](60) NOT NULL,
 CONSTRAINT [PK_pv_cities_cityID] PRIMARY KEY CLUSTERED 
(
	[cityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_commentDocuments]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_commentDocuments](
	[commentDocID] [int] IDENTITY(1,1) NOT NULL,
	[documentID] [int] NOT NULL,
	[commentID] [int] NOT NULL,
 CONSTRAINT [PK_pv_commentDocuments_commentDocID] PRIMARY KEY CLUSTERED 
(
	[commentDocID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_comments]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_comments](
	[commentID] [int] IDENTITY(1,1) NOT NULL,
	[proposeID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[commentStatusID] [smallint] NOT NULL,
	[title] [nvarchar](80) NOT NULL,
	[text] [nvarchar](max) NOT NULL,
	[date] [datetime2](0) NOT NULL,
	[previousCommentID] [int] NULL,
 CONSTRAINT [PK_pv_comments_commentID] PRIMARY KEY CLUSTERED 
(
	[commentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_commentStatus]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_commentStatus](
	[commentStatusID] [smallint] NOT NULL,
	[name] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_pv_commentStatus_commentStatusID] PRIMARY KEY CLUSTERED 
(
	[commentStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_communicationChannels]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_communicationChannels](
	[communicationChannelID] [int] NOT NULL,
	[channel] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_communicationChannels_communicationChannelID] PRIMARY KEY CLUSTERED 
(
	[communicationChannelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_conditions]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_conditions](
	[conditionID] [int] IDENTITY(1,1) NOT NULL,
	[voteID] [int] NOT NULL,
	[conditionTypeID] [int] NOT NULL,
	[description] [nvarchar](150) NOT NULL,
	[unitTypeID] [int] NOT NULL,
	[value] [nvarchar](40) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[deleted]  AS ((0)),
	[checksum] [varbinary](500) NOT NULL,
	[organizationID] [int] NOT NULL,
 CONSTRAINT [PK_pv_conditions_conditionID] PRIMARY KEY CLUSTERED 
(
	[conditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_conditionTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_conditionTypes](
	[conditionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[conditionType] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_conditionTypes_conditionTypeID] PRIMARY KEY CLUSTERED 
(
	[conditionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_confirmedVoteDemographics]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_confirmedVoteDemographics](
	[confirmedVoteDemographicID] [int] IDENTITY(1,1) NOT NULL,
	[targetDemographicID] [int] NOT NULL,
	[confirmedVoteID] [bigint] NOT NULL,
 CONSTRAINT [PK_pv_confirmedVoteDemographics_confirmedVoteDemographicID] PRIMARY KEY CLUSTERED 
(
	[confirmedVoteDemographicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_confirmedVotes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_confirmedVotes](
	[confirmedVoteID] [bigint] IDENTITY(1,1) NOT NULL,
	[optionVoteID] [int] NOT NULL,
	[weight] [decimal](5, 2) NOT NULL,
	[encryptedVote] [varbinary](300) NOT NULL,
	[tokenID] [bigint] NOT NULL,
	[checksum] [varbinary](300) NOT NULL,
 CONSTRAINT [PK_pv_confirmedVotes_confirmedVoteID] PRIMARY KEY CLUSTERED 
(
	[confirmedVoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_contactDepartments]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_contactDepartments](
	[contactDepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_contactDepartments_contactDepartmentId] PRIMARY KEY CLUSTERED 
(
	[contactDepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_contactInfo]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_contactInfo](
	[contactInfoID] [int] IDENTITY(1,1) NOT NULL,
	[value] [nvarchar](100) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
	[contactTypeID] [int] NOT NULL,
	[contactDepartmentId] [int] NULL,
 CONSTRAINT [PK_pv_contactInfo_contactInfoID] PRIMARY KEY CLUSTERED 
(
	[contactInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_contactTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_contactTypes](
	[contactTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_contactTypes_contactTypeID] PRIMARY KEY CLUSTERED 
(
	[contactTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_countries]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_countries](
	[countryID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](60) NOT NULL,
 CONSTRAINT [PK_pv_countries_countryID] PRIMARY KEY CLUSTERED 
(
	[countryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_countryWhitelists]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_countryWhitelists](
	[countryWhitelistID] [int] NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[countryID] [int] NOT NULL,
 CONSTRAINT [PK_pv_countryWhitelists_countryWhitelistID] PRIMARY KEY CLUSTERED 
(
	[countryWhitelistID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_crowfundingStatuses]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_crowfundingStatuses](
	[crowfundingStatusID] [smallint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_crowfundingStatuses_crowfundingStatusID] PRIMARY KEY CLUSTERED 
(
	[crowfundingStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_currencies]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_currencies](
	[currencyID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[acronym] [nvarchar](5) NOT NULL,
	[symbol] [nvarchar](5) NOT NULL,
	[countryID] [int] NOT NULL,
 CONSTRAINT [PK_pv_currencies_currencyID] PRIMARY KEY CLUSTERED 
(
	[currencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_deliverables]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_deliverables](
	[deliverableID] [smallint] IDENTITY(1,1) NOT NULL,
	[milestoneID] [smallint] NOT NULL,
	[postDate] [datetime2](0) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[startDate] [date] NOT NULL,
	[endDate] [date] NOT NULL,
	[KPITypeID] [int] NOT NULL,
	[KPIValue] [nvarchar](300) NOT NULL,
	[cost] [decimal](18, 2) NOT NULL,
	[currencyID] [int] NOT NULL,
	[voteID] [int] NOT NULL,
 CONSTRAINT [PK_pv_deliverables_deliverableID] PRIMARY KEY CLUSTERED 
(
	[deliverableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_demographicTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_demographicTypes](
	[demographicTypeID] [int] IDENTITY(1,1) NOT NULL,
	[targetType] [nvarchar](60) NOT NULL,
	[datatype] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_demographicTypes_demographicTypeID] PRIMARY KEY CLUSTERED 
(
	[demographicTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_documents]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_documents](
	[documentID] [int] IDENTITY(1,1) NOT NULL,
	[mediaFileID] [int] NOT NULL,
	[documentTypeID] [int] NOT NULL,
	[documentStatusID] [smallint] NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[uploadDate] [datetime2](0) NOT NULL,
	[version] [decimal](6, 4) NOT NULL,
	[renewalDate] [date] NOT NULL,
 CONSTRAINT [PK_pv_documents_documentID] PRIMARY KEY CLUSTERED 
(
	[documentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_documentStatus]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_documentStatus](
	[documentStatusID] [smallint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_documentStatus_documentStatusID] PRIMARY KEY CLUSTERED 
(
	[documentStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_documentTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_documentTypes](
	[documentTypeID] [int] NOT NULL,
	[documentType] [nvarchar](50) NOT NULL,
	[daysUntilRenewal] [smallint] NOT NULL,
 CONSTRAINT [PK_pv_documentTypes_documentTypeID] PRIMARY KEY CLUSTERED 
(
	[documentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_documentTypeWorkflows]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_documentTypeWorkflows](
	[documentTypeWorkflowID] [int] IDENTITY(1,1) NOT NULL,
	[documentTypeID] [int] NOT NULL,
	[workflowID] [int] NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_pv_documentTypeWorkflows_documentTypeWorkflowID] PRIMARY KEY CLUSTERED 
(
	[documentTypeWorkflowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_educationLevels]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_educationLevels](
	[educationLevelID] [int] IDENTITY(1,1) NOT NULL,
	[educationLevel] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_educationLevels_educationLevelID] PRIMARY KEY CLUSTERED 
(
	[educationLevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_encryptionKeyMetadata]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_encryptionKeyMetadata](
	[keyMetadataID] [int] IDENTITY(1,1) NOT NULL,
	[keyName] [nvarchar](50) NOT NULL,
	[keyTypeID] [int] NOT NULL,
	[owningEntityID] [int] NULL,
	[owningEntityTypeID] [int] NOT NULL,
	[creationDate] [datetime2](0) NOT NULL,
	[expirationDate] [datetime2](0) NULL,
	[isActive] [binary](1) NOT NULL,
	[keyPath] [nvarchar](150) NULL,
	[externalKeyID] [int] NULL,
 CONSTRAINT [PK_pv_encryptionKeyMetadata_keyMetadataID] PRIMARY KEY CLUSTERED 
(
	[keyMetadataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_entityType]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_entityType](
	[entityTypeID] [int] IDENTITY(1,1) NOT NULL,
	[entity] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_entityType_entityTypeID] PRIMARY KEY CLUSTERED 
(
	[entityTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_exchangeCurrencies]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_exchangeCurrencies](
	[exchangeCurrencyID] [int] IDENTITY(1,1) NOT NULL,
	[sourceID] [int] NOT NULL,
	[destinyID] [int] NOT NULL,
	[startDate] [date] NOT NULL,
	[endDate] [date] NULL,
	[exchange_rate] [decimal](12, 3) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[currentExchange] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_exchangeCurrencies_exchangeCurrencyID] PRIMARY KEY CLUSTERED 
(
	[exchangeCurrencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_executionPlans]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_executionPlans](
	[executionPlanID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[proposalDocumentID] [int] NOT NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_executionPlans_executionPlanID] PRIMARY KEY CLUSTERED 
(
	[executionPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_impactDemographics]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_impactDemographics](
	[impactDemographicID] [int] IDENTITY(1,1) NOT NULL,
	[proposalImpactID] [int] NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_pv_impactDemographics_impactDemographicID] PRIMARY KEY CLUSTERED 
(
	[impactDemographicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_impactedEntityTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_impactedEntityTypes](
	[impactedEntityTypeID] [int] NOT NULL,
	[name] [nvarchar](75) NOT NULL,
 CONSTRAINT [PK_pv_impactedEntityTypes_impactedEntityTypeID] PRIMARY KEY CLUSTERED 
(
	[impactedEntityTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_jobPositions]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_jobPositions](
	[positionID] [int] NOT NULL,
	[position] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_jobPositions_positionID] PRIMARY KEY CLUSTERED 
(
	[positionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_keyTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_keyTypes](
	[keyTypeID] [int] IDENTITY(1,1) NOT NULL,
	[keyTypeName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_keyTypes_keyTypeID] PRIMARY KEY CLUSTERED 
(
	[keyTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_KPITypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_KPITypes](
	[KPITypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[datatype] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_KPITypes_KPITypeID] PRIMARY KEY CLUSTERED 
(
	[KPITypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_languages]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_languages](
	[languageID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
	[culture] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_pv_languages_languageID] PRIMARY KEY CLUSTERED 
(
	[languageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_logs]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_logs](
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[description] [nvarchar](200) NOT NULL,
	[postTime] [datetime2](0) NOT NULL,
	[computer] [nvarchar](75) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[trace] [nvarchar](100) NOT NULL,
	[referenceId1] [bigint] NULL,
	[referenceId2] [bigint] NULL,
	[value1] [nvarchar](180) NULL,
	[value2] [nvarchar](180) NULL,
	[checksum] [varbinary](250) NOT NULL,
	[logSeverityID] [int] NOT NULL,
	[logTypesID] [int] NOT NULL,
	[logSourcesID] [int] NOT NULL,
 CONSTRAINT [PK_pv_logs_log_id] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_logSources]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_logSources](
	[logSourcesID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_logSources_logSourcesID] PRIMARY KEY CLUSTERED 
(
	[logSourcesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_logsSererity]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_logsSererity](
	[logSererityID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_logsSererity_logSererityID] PRIMARY KEY CLUSTERED 
(
	[logSererityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_logTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_logTypes](
	[logTypesID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
	[reference1Description] [nvarchar](75) NULL,
	[reference2Description] [nvarchar](75) NULL,
	[value1Description] [nvarchar](75) NULL,
	[value2Description] [nvarchar](75) NULL,
 CONSTRAINT [PK_pv_logTypes_logTypesID] PRIMARY KEY CLUSTERED 
(
	[logTypesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_mediaFile]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_mediaFile](
	[mediaFileID] [int] IDENTITY(1,1) NOT NULL,
	[encryptedUrl] [varbinary](600) NOT NULL,
	[mediaTypeID] [int] NOT NULL,
 CONSTRAINT [PK_pv_mediaFile_mediaFileID] PRIMARY KEY CLUSTERED 
(
	[mediaFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_mediaTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_mediaTypes](
	[mediaTypeID] [int] IDENTITY(1,1) NOT NULL,
	[type] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_mediaTypes_mediaTypeID] PRIMARY KEY CLUSTERED 
(
	[mediaTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_milestones]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_milestones](
	[milestoneID] [smallint] IDENTITY(1,1) NOT NULL,
	[executionPlanID] [int] NOT NULL,
	[name] [nvarchar](30) NOT NULL,
	[description] [nvarchar](100) NOT NULL,
	[duration] [smallint] NOT NULL,
	[timeUnitID] [smallint] NOT NULL,
	[budget] [decimal](18, 2) NOT NULL,
	[currencyID] [int] NOT NULL,
	[userID] [int] NOT NULL,
 CONSTRAINT [PK_pv_milestones_milestoneID] PRIMARY KEY CLUSTERED 
(
	[milestoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_modules]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_modules](
	[moduleID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_pv_modules_moduleID] PRIMARY KEY CLUSTERED 
(
	[moduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_nationalities]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_nationalities](
	[nationalityID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[countryID] [int] NOT NULL,
 CONSTRAINT [PK_pv_nationalities_nationalityID] PRIMARY KEY CLUSTERED 
(
	[nationalityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_notificationConfigurations]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_notificationConfigurations](
	[configurationID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[notificationTypeID] [smallint] NOT NULL,
	[communicationChannelID] [int] NOT NULL,
	[settings] [nvarchar](max) NOT NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_notificationConfigurations_configurationID] PRIMARY KEY CLUSTERED 
(
	[configurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_notifications]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_notifications](
	[notificationID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[communicationChannelID] [int] NOT NULL,
	[notificationStatusID] [smallint] NOT NULL,
	[notificationTypeID] [smallint] NOT NULL,
	[message] [nvarchar](300) NOT NULL,
	[sentTime] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_pv_notifications_notificationID] PRIMARY KEY CLUSTERED 
(
	[notificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_notificationStatus]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_notificationStatus](
	[notificationStatusID] [smallint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_notificationStatus_notificationStatusID] PRIMARY KEY CLUSTERED 
(
	[notificationStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_notificationTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_notificationTypes](
	[notificationTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](70) NOT NULL,
 CONSTRAINT [PK_pv_notificationTypes_notificationTypeID] PRIMARY KEY CLUSTERED 
(
	[notificationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_organization_type_has_pv_documentType]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_organization_type_has_pv_documentType](
	[pv_organization_type_organizationTypeId] [int] NOT NULL,
	[pv_documentType_idDocumentType] [int] NOT NULL,
 CONSTRAINT [PK_pv_organization_type_has_pv_documentType_pv_organization_type_organizationTypeId] PRIMARY KEY CLUSTERED 
(
	[pv_organization_type_organizationTypeId] ASC,
	[pv_documentType_idDocumentType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_organizationAdresses]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_organizationAdresses](
	[organizationAdressID] [int] IDENTITY(1,1) NOT NULL,
	[addressID] [int] NOT NULL,
	[organizationID] [int] NOT NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_organizationAdresses_organizationAdressID] PRIMARY KEY CLUSTERED 
(
	[organizationAdressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_organizationAffiliates]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_organizationAffiliates](
	[orgAffiliateID] [int] NOT NULL,
	[organizationID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[positionID] [int] NOT NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_organizationAffiliates_orgAffiliateID] PRIMARY KEY CLUSTERED 
(
	[orgAffiliateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_organizationDocuments]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_organizationDocuments](
	[organizationDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[documentID] [int] NOT NULL,
	[organizationID] [int] NOT NULL,
 CONSTRAINT [PK_pv_organizationDocuments_organizationDocumentID] PRIMARY KEY CLUSTERED 
(
	[organizationDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_organizationProposals]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_organizationProposals](
	[organizationProposalID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[organizationID] [int] NOT NULL,
 CONSTRAINT [PK_pv_organizationProposals_organizationProposalID] PRIMARY KEY CLUSTERED 
(
	[organizationProposalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_organizations]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_organizations](
	[organizationID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[legalName] [nvarchar](60) NOT NULL,
	[dateRegister] [datetime2](0) NOT NULL,
	[registryNumber] [int] NOT NULL,
	[description] [nvarchar](100) NOT NULL,
	[userId] [int] NOT NULL,
	[organizationTypeId] [int] NOT NULL,
	[statusID] [int] NOT NULL,
 CONSTRAINT [PK_pv_organizations_organizationID] PRIMARY KEY CLUSTERED 
(
	[organizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_organizationsContactInfo]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_organizationsContactInfo](
	[organizationContactInfoID] [int] IDENTITY(1,1) NOT NULL,
	[organizationID] [int] NOT NULL,
	[contactInfoID] [int] NOT NULL,
 CONSTRAINT [PK_pv_organizationsContactInfo_organizationContactInfoID] PRIMARY KEY CLUSTERED 
(
	[organizationContactInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_organizationStatuses]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_organizationStatuses](
	[statusID] [int] IDENTITY(1,1) NOT NULL,
	[status] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_organizationStatuses_statusID] PRIMARY KEY CLUSTERED 
(
	[statusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_organizationTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_organizationTypes](
	[organizationTypeID] [int] NOT NULL,
	[type] [nvarchar](60) NOT NULL,
 CONSTRAINT [PK_pv_organizationTypes_organizationTypeID] PRIMARY KEY CLUSTERED 
(
	[organizationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_owningEntityTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_owningEntityTypes](
	[owningEntityTypeID] [int] IDENTITY(1,1) NOT NULL,
	[owningEntityTypeName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_owningEntityTypes_owningEntityTypeID] PRIMARY KEY CLUSTERED 
(
	[owningEntityTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_payments]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_payments](
	[paymentID] [int] IDENTITY(1,1) NOT NULL,
	[availableMethodID] [int] NOT NULL,
	[currencyID] [int] NOT NULL,
	[methodID] [int] NOT NULL,
	[amount] [decimal](9, 2) NOT NULL,
	[date_pay] [date] NOT NULL,
	[confirmed] [binary](1) NOT NULL,
	[result] [nvarchar](200) NOT NULL,
	[auth] [nvarchar](60) NOT NULL,
	[reference] [nvarchar](100) NOT NULL,
	[charge_token] [varbinary](255) NOT NULL,
	[description] [nvarchar](100) NOT NULL,
	[error] [nvarchar](200) NULL,
	[checksum] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_payments_paymentID] PRIMARY KEY CLUSTERED 
(
	[paymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_paymentStatuses]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_paymentStatuses](
	[paymentStatusID] [smallint] NOT NULL,
	[name] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_pv_paymentStatuses_paymentStatusID] PRIMARY KEY CLUSTERED 
(
	[paymentStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_payMethod]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_payMethod](
	[payMethodID] [int] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[apiURL] [nvarchar](200) NOT NULL,
	[secretKey] [varbinary](255) NOT NULL,
	[key] [nvarchar](255) NOT NULL,
	[logoIconURL] [nvarchar](200) NOT NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_payMethod_payMethodID] PRIMARY KEY CLUSTERED 
(
	[payMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_permissions]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_permissions](
	[permissionID] [int] IDENTITY(1,1) NOT NULL,
	[description] [nvarchar](200) NOT NULL,
	[code] [nvarchar](10) NOT NULL,
	[moduleID] [int] NOT NULL,
 CONSTRAINT [PK_pv_permissions_permissionID] PRIMARY KEY CLUSTERED 
(
	[permissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [pv_permissions$code_UNIQUE] UNIQUE NONCLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_proposalBenefits]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_proposalBenefits](
	[proposalBenefitID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](300) NOT NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_proposalBenefits_proposalBenefitID] PRIMARY KEY CLUSTERED 
(
	[proposalBenefitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_proposalDemographics]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_proposalDemographics](
	[proposalDemographicID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[targetDemographicID] [int] NOT NULL,
	[creationDate] [datetime2](0) NOT NULL,
	[deleted] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_proposalDemographics_proposalDemographicID] PRIMARY KEY CLUSTERED 
(
	[proposalDemographicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_proposalDocuments]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_proposalDocuments](
	[proposalDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[documentID] [int] NOT NULL,
	[proposalID] [int] NOT NULL,
 CONSTRAINT [PK_pv_proposalDocuments_proposalDocumentID] PRIMARY KEY CLUSTERED 
(
	[proposalDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_proposalImpacts]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_proposalImpacts](
	[proposalImpactID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[impactedEntityTypeID] [int] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](300) NOT NULL,
	[value] [decimal](5, 2) NOT NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_proposalImpacts_proposalImpactID] PRIMARY KEY CLUSTERED 
(
	[proposalImpactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_proposalRecords]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_proposalRecords](
	[proposalRecordID] [int] IDENTITY(1,1) NOT NULL,
	[lastProposalID] [int] NOT NULL,
	[currentProposalID] [int] NOT NULL,
 CONSTRAINT [PK_pv_proposalRecords_proposalRecordID] PRIMARY KEY CLUSTERED 
(
	[proposalRecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_proposals]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_proposals](
	[proposalID] [int] IDENTITY(1,1) NOT NULL,
	[proposalTypeID] [smallint] NOT NULL,
	[proposalStatusID] [smallint] NOT NULL,
	[title] [nvarchar](75) NOT NULL,
	[description] [nvarchar](300) NOT NULL,
	[creationDate] [date] NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
	[current] [binary](1) NOT NULL,
	[version] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_pv_proposals_proposalID] PRIMARY KEY CLUSTERED 
(
	[proposalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_proposalStatus]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_proposalStatus](
	[proposalStatusID] [smallint] NOT NULL,
	[name] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_pv_proposalStatus_proposalStatusID] PRIMARY KEY CLUSTERED 
(
	[proposalStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_proposalTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_proposalTypes](
	[proposalTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[type] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_pv_proposalTypes_proposalTypeID] PRIMARY KEY CLUSTERED 
(
	[proposalTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_requestResults]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_requestResults](
	[requestResultID] [int] IDENTITY(1,1) NOT NULL,
	[requestID] [int] NOT NULL,
	[jobID] [nvarchar](45) NOT NULL,
	[response] [nvarchar](100) NOT NULL,
	[executionDate] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_pv_requestResults_requestResultID] PRIMARY KEY CLUSTERED 
(
	[requestResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_requests]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_requests](
	[requestID] [int] IDENTITY(1,1) NOT NULL,
	[payload] [nvarchar](max) NOT NULL,
	[createdAt] [datetime2](0) NOT NULL,
	[executed] [binary](1) NOT NULL,
	[workflowID] [int] NOT NULL,
 CONSTRAINT [PK_pv_requests_requestID] PRIMARY KEY CLUSTERED 
(
	[requestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_requiredDocuments]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_requiredDocuments](
	[requiredDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[documentTypeID] [int] NOT NULL,
	[entityTypeID] [int] NOT NULL,
	[mandatory] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_requiredDocuments_requiredDocumentID] PRIMARY KEY CLUSTERED 
(
	[requiredDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_rolePermissions]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_rolePermissions](
	[rolePermissionID] [int] IDENTITY(1,1) NOT NULL,
	[roleID] [smallint] NOT NULL,
	[permissionID] [int] NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[lastPermUpdate] [datetime2](0) NOT NULL,
	[username] [nvarchar](45) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_pv_rolePermissions_rolePermissionID] PRIMARY KEY CLUSTERED 
(
	[rolePermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_roles]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_roles](
	[roleID] [smallint] IDENTITY(1,1) NOT NULL,
	[roleName] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_roles_roleID] PRIMARY KEY CLUSTERED 
(
	[roleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_schedules]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_schedules](
	[scheduleID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](70) NOT NULL,
	[repit] [binary](1) NOT NULL,
	[repetitions] [smallint] NOT NULL,
	[recurrencyType] [smallint] NOT NULL,
	[endDate] [datetime2](0) NULL,
	[startDate] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_pv_schedules_scheduleID] PRIMARY KEY CLUSTERED 
(
	[scheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_schedulesDetails]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_schedulesDetails](
	[scheduleDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[schedule_id] [int] NOT NULL,
	[baseDate] [datetime2](0) NOT NULL,
	[datePart] [date] NOT NULL,
	[lastExecute] [datetime2](0) NULL,
	[nextExecute] [datetime2](0) NOT NULL,
	[description] [varchar](100) NOT NULL,
	[detail] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_pv_schedulesDetails_scheduleDetailsID] PRIMARY KEY CLUSTERED 
(
	[scheduleDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_states]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_states](
	[stateID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](40) NOT NULL,
	[countryID] [int] NOT NULL,
 CONSTRAINT [PK_pv_states_stateID] PRIMARY KEY CLUSTERED 
(
	[stateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_targetDemographics]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_targetDemographics](
	[targetDemographicID] [int] IDENTITY(1,1) NOT NULL,
	[value] [nvarchar](70) NOT NULL,
	[maxRange] [decimal](5, 2) NULL,
	[enabled] [binary](1) NOT NULL,
	[demographicTypeID] [int] NOT NULL,
	[targetTypeID] [int] NOT NULL,
	[weight] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_pv_targetDemographics_targetDemographicID] PRIMARY KEY CLUSTERED 
(
	[targetDemographicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_targetOrganizations]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_targetOrganizations](
	[targetOrganizationID] [int] IDENTITY(1,1) NOT NULL,
	[voteID] [int] NOT NULL,
	[organizationID] [int] NOT NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_targetOrganizations_targetOrganizationID] PRIMARY KEY CLUSTERED 
(
	[targetOrganizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_targetTypes]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_targetTypes](
	[targetTypeID] [int] IDENTITY(1,1) NOT NULL,
	[type] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_targetTypes_targetTypeID] PRIMARY KEY CLUSTERED 
(
	[targetTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_tempConfirmations]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_tempConfirmations](
	[tempConfirmationId] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[passwordSalt] [nvarchar](30) NOT NULL,
	[epoch] [datetime] NULL,
 CONSTRAINT [PK_pv_tempConfirmations_tempConfirmationId] PRIMARY KEY CLUSTERED 
(
	[tempConfirmationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_timeUnits]    Script Date: 6/9/2025 7:08:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_timeUnits](
	[timeUnitID] [smallint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_pv_timeUnits_timeUnitID] PRIMARY KEY CLUSTERED 
(
	[timeUnitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_tokens]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_tokens](
	[tokenID] [bigint] IDENTITY(1,1) NOT NULL,
	[tokenHash] [varbinary](300) NOT NULL,
	[creationDate] [datetime2](0) NOT NULL,
	[postDate] [datetime2](0) NOT NULL,
	[isUsed] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_tokens_tokenID] PRIMARY KEY CLUSTERED 
(
	[tokenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_transactions]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_transactions](
	[transactionID] [int] IDENTITY(1,1) NOT NULL,
	[payment_id] [int] NULL,
	[userID] [int] NOT NULL,
	[transactionTypesID] [int] NOT NULL,
	[transactionSubtypesID] [int] NOT NULL,
	[exchangeCurrencyID] [int] NULL,
	[date] [datetime2](0) NOT NULL,
	[postTime] [datetime2](0) NOT NULL,
	[refNumber] [nvarchar](50) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[exchangeRate] [decimal](12, 3) NOT NULL,
	[convertedAmount] [decimal](12, 2) NOT NULL,
	[amount] [decimal](12, 2) NULL,
 CONSTRAINT [PK_pv_transactions_transactionID] PRIMARY KEY CLUSTERED 
(
	[transactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_transactionSubtypes]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_transactionSubtypes](
	[transactionSubtypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_transactionSubtypes_transactionSubtypeID] PRIMARY KEY CLUSTERED 
(
	[transactionSubtypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_transactionTypes]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_transactionTypes](
	[transactionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_transactionTypes_transactionTypeID] PRIMARY KEY CLUSTERED 
(
	[transactionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_translations]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_translations](
	[translationsID] [int] IDENTITY(1,1) NOT NULL,
	[moduleID] [int] NOT NULL,
	[code] [nvarchar](100) NOT NULL,
	[caption] [nvarchar](100) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[languageID] [int] NOT NULL,
 CONSTRAINT [PK_pv_translations_translationsID] PRIMARY KEY CLUSTERED 
(
	[translationsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_unitTypes]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_unitTypes](
	[unitTypeID] [int] IDENTITY(1,1) NOT NULL,
	[unitType] [nvarchar](40) NOT NULL,
 CONSTRAINT [PK_pv_unitTypes_unitTypeID] PRIMARY KEY CLUSTERED 
(
	[unitTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_userAddresses]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_userAddresses](
	[userAddressID] [int] IDENTITY(1,1) NOT NULL,
	[addressID] [int] NOT NULL,
	[userID] [int] NOT NULL,
	[enabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_userAddresses_userAddressID] PRIMARY KEY CLUSTERED 
(
	[userAddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_userDemographics]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_userDemographics](
	[userDemographicID] [int] IDENTITY(1,1) NOT NULL,
	[value] [nvarchar](100) NOT NULL,
	[userID] [int] NOT NULL,
	[demographicTypeID] [int] NOT NULL,
	[creationDate] [date] NOT NULL,
	[deleted] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_userDemographics_userDemographicID] PRIMARY KEY CLUSTERED 
(
	[userDemographicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_userDocuments]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_userDocuments](
	[userDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[documentID] [int] NOT NULL,
	[userID] [int] NOT NULL,
 CONSTRAINT [PK_pv_userDocuments_userDocumentID] PRIMARY KEY CLUSTERED 
(
	[userDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_userIdTypes]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_userIdTypes](
	[userIdTypeID] [int] IDENTITY(1,1) NOT NULL,
	[idType] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_userIdTypes_userIdTypeID] PRIMARY KEY CLUSTERED 
(
	[userIdTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_userPermissions]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_userPermissions](
	[userPermissionID] [int] IDENTITY(1,1) NOT NULL,
	[permissionID] [int] NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[lastPermUpdate] [datetime2](0) NOT NULL,
	[username] [nvarchar](45) NOT NULL,
	[checksum] [varbinary](400) NOT NULL,
	[userID] [int] NOT NULL,
 CONSTRAINT [PK_pv_userPermissions_userPermissionID] PRIMARY KEY CLUSTERED 
(
	[userPermissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_userProfiles]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_userProfiles](
	[userProfileID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[personalID] [nvarchar](50) NOT NULL,
	[userIdTypeID] [int] NOT NULL,
	[birthdate] [date] NOT NULL,
	[sex] [smallint] NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
	[educationLevelID] [int] NULL,
 CONSTRAINT [PK_pv_userProfiles_userProfileID] PRIMARY KEY CLUSTERED 
(
	[userProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_UserProposals]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_UserProposals](
	[userProposalID] [int] IDENTITY(1,1) NOT NULL,
	[proposalID] [int] NOT NULL,
	[userID] [int] NOT NULL,
 CONSTRAINT [PK_pv_UserProposals_userProposalID] PRIMARY KEY CLUSTERED 
(
	[userProposalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_userRoles]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_userRoles](
	[userRoleID] [int] IDENTITY(1,1) NOT NULL,
	[roleID] [smallint] NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
	[username] [nvarchar](45) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[userID] [int] NOT NULL,
 CONSTRAINT [PK_pv_userRoles_userRoleID] PRIMARY KEY CLUSTERED 
(
	[userRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_users]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_users](
	[userID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](60) NOT NULL,
	[lastName] [nvarchar](60) NOT NULL,
	[email] [nvarchar](80) NOT NULL,
	[password] [varbinary](250) NOT NULL,
	[creationDate] [date] NOT NULL,
	[statusID] [smallint] NOT NULL,
 CONSTRAINT [PK_pv_users_userID] PRIMARY KEY CLUSTERED 
(
	[userID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_usersContactInfo]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_usersContactInfo](
	[userContactInfoID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[contactInfoID] [int] NOT NULL,
 CONSTRAINT [PK_pv_usersContactInfo_userContactInfoID] PRIMARY KEY CLUSTERED 
(
	[userContactInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_userSessions]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_userSessions](
	[userSessionID] [int] IDENTITY(1,1) NOT NULL,
	[userID] [int] NOT NULL,
	[sessionID] [nvarchar](255) NOT NULL,
	[token] [varbinary](400) NOT NULL,
	[refreshToken] [varbinary](400) NOT NULL,
	[lastRevision] [datetime2](0) NOT NULL,
	[expirationDate] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_pv_userSessions_userSessionID] PRIMARY KEY CLUSTERED 
(
	[userSessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_userStatuses]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_userStatuses](
	[statusID] [smallint] NOT NULL,
	[name] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_pv_userStatuses_statusID] PRIMARY KEY CLUSTERED 
(
	[statusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_voteDemographics]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_voteDemographics](
	[voteDemographicID] [int] IDENTITY(1,1) NOT NULL,
	[voteID] [int] NOT NULL,
	[targetDemographicID] [int] NOT NULL,
	[creationDate] [datetime2](0) NOT NULL,
	[deleted] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_voteDemographics_voteDemographicID] PRIMARY KEY CLUSTERED 
(
	[voteDemographicID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_voteOptions]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_voteOptions](
	[voteOptionID] [int] IDENTITY(1,1) NOT NULL,
	[voteQuestionID] [int] NOT NULL,
	[optionText] [nvarchar](100) NOT NULL,
	[optionNumber] [smallint] NOT NULL,
	[value] [nvarchar](20) NOT NULL,
	[url] [nvarchar](60) NULL,
	[creationDate] [datetime2](0) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[checksum] [varbinary](300) NOT NULL,
 CONSTRAINT [PK_pv_voteOptions_voteOptionID] PRIMARY KEY CLUSTERED 
(
	[voteOptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_voteQuestions]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_voteQuestions](
	[voteQuestionID] [int] IDENTITY(1,1) NOT NULL,
	[voteID] [int] NOT NULL,
	[question] [nvarchar](100) NOT NULL,
	[answerQuantity] [smallint] NOT NULL,
	[creationDate] [datetime2](0) NOT NULL,
	[deleted] [binary](1) NOT NULL,
	[checksum] [nvarchar](300) NOT NULL,
 CONSTRAINT [PK_pv_voteQuestions_voteQuestionID] PRIMARY KEY CLUSTERED 
(
	[voteQuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_voteResults]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_voteResults](
	[voteResultID] [bigint] IDENTITY(1,1) NOT NULL,
	[optionVoteID] [int] NOT NULL,
	[VoteCount] [int] NOT NULL,
	[WeightedCount] [decimal](18, 4) NOT NULL,
	[checksum] [varbinary](400) NOT NULL,
	[creationDate] [datetime2](0) NOT NULL,
 CONSTRAINT [PK_pv_voteResults_voteResultID] PRIMARY KEY CLUSTERED 
(
	[voteResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_votes]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_votes](
	[voteID] [int] IDENTITY(1,1) NOT NULL,
	[voteTypeID] [int] NOT NULL,
	[voteStatusID] [smallint] NOT NULL,
	[proposalID] [int] NOT NULL,
	[approvalTypeID] [int] NOT NULL,
	[topic] [nvarchar](100) NOT NULL,
	[startDate] [datetime2](0) NOT NULL,
	[endDate] [datetime2](0) NOT NULL,
	[creationDate] [datetime2](0) NOT NULL,
	[lastUpdate] [datetime2](0) NOT NULL,
	[approvalCriteria] [nvarchar](80) NOT NULL,
	[strictDemographic] [binary](1) NOT NULL,
	[commentsEnabled] [binary](1) NOT NULL,
 CONSTRAINT [PK_pv_votes_voteID] PRIMARY KEY CLUSTERED 
(
	[voteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_voteStatus]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_voteStatus](
	[voteStatusID] [smallint] NOT NULL,
	[name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_voteStatus_voteStatusID] PRIMARY KEY CLUSTERED 
(
	[voteStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_voteTypes]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_voteTypes](
	[voteTypeID] [int] IDENTITY(1,1) NOT NULL,
	[voteType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_pv_voteTypes_voteTypeID] PRIMARY KEY CLUSTERED 
(
	[voteTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_workflowHeaders]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_workflowHeaders](
	[headerID] [int] IDENTITY(1,1) NOT NULL,
	[workflowID] [int] NOT NULL,
	[name] [nvarchar](60) NOT NULL,
	[value] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_pv_workflowHeaders_headerID] PRIMARY KEY CLUSTERED 
(
	[headerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_workflowParameters]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_workflowParameters](
	[parameterID] [int] IDENTITY(1,1) NOT NULL,
	[workflowID] [int] NOT NULL,
	[parameter] [nvarchar](60) NOT NULL,
	[dataType] [nvarchar](50) NOT NULL,
	[required] [binary](1) NOT NULL,
	[description] [nvarchar](100) NOT NULL,
	[defaultValue] [nvarchar](250) NULL,
 CONSTRAINT [PK_pv_workflowParameters_parameterID] PRIMARY KEY CLUSTERED 
(
	[parameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_workflows]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_workflows](
	[workflowID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](150) NOT NULL,
	[enpointUrl] [nvarchar](250) NOT NULL,
	[enabled] [binary](1) NOT NULL,
	[workflowTypeID] [int] NOT NULL,
 CONSTRAINT [PK_pv_workflows_workflowID] PRIMARY KEY CLUSTERED 
(
	[workflowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[pv_workflowTypes]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[pv_workflowTypes](
	[workflowTypeID] [int] IDENTITY(1,1) NOT NULL,
	[type] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_pv_workflowTypes_workflowTypeID] PRIMARY KEY CLUSTERED 
(
	[workflowTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [pvDB].[reportStatuses]    Script Date: 6/9/2025 7:08:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [pvDB].[reportStatuses](
	[reportStatusID] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_reportStatuses_reportStatusID] PRIMARY KEY CLUSTERED 
(
	[reportStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [pvDB].[cf_financialReports] ADD  DEFAULT (getdate()) FOR [uploadDate]
GO
ALTER TABLE [pvDB].[cf_fundingProgresses] ADD  DEFAULT ((0)) FOR [investors]
GO
ALTER TABLE [pvDB].[cf_payouts] ADD  DEFAULT ((0.00)) FOR [amountToPay]
GO
ALTER TABLE [pvDB].[cf_payouts] ADD  DEFAULT (NULL) FOR [transactionID]
GO
ALTER TABLE [pvDB].[cf_payouts] ADD  DEFAULT (0x00) FOR [paid]
GO
ALTER TABLE [pvDB].[pv_addresses] ADD  DEFAULT (NULL) FOR [line2]
GO
ALTER TABLE [pvDB].[pv_biometricDevices] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_biometricResults] ADD  DEFAULT ((0.00)) FOR [confidence]
GO
ALTER TABLE [pvDB].[pv_biometricResults] ADD  DEFAULT (NULL) FOR [biometricFeatures]
GO
ALTER TABLE [pvDB].[pv_comments] ADD  DEFAULT (NULL) FOR [previousCommentID]
GO
ALTER TABLE [pvDB].[pv_conditions] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_contactInfo] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_contactInfo] ADD  DEFAULT (NULL) FOR [contactDepartmentId]
GO
ALTER TABLE [pvDB].[pv_countryWhitelists] ADD  DEFAULT (0x00) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_documents] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_documents] ADD  DEFAULT ((1.0000)) FOR [version]
GO
ALTER TABLE [pvDB].[pv_documentTypeWorkflows] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_encryptionKeyMetadata] ADD  DEFAULT (NULL) FOR [owningEntityID]
GO
ALTER TABLE [pvDB].[pv_encryptionKeyMetadata] ADD  DEFAULT (NULL) FOR [expirationDate]
GO
ALTER TABLE [pvDB].[pv_encryptionKeyMetadata] ADD  DEFAULT (0x01) FOR [isActive]
GO
ALTER TABLE [pvDB].[pv_encryptionKeyMetadata] ADD  DEFAULT (NULL) FOR [keyPath]
GO
ALTER TABLE [pvDB].[pv_encryptionKeyMetadata] ADD  DEFAULT (NULL) FOR [externalKeyID]
GO
ALTER TABLE [pvDB].[pv_exchangeCurrencies] ADD  DEFAULT (NULL) FOR [endDate]
GO
ALTER TABLE [pvDB].[pv_exchangeCurrencies] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_exchangeCurrencies] ADD  DEFAULT (0x01) FOR [currentExchange]
GO
ALTER TABLE [pvDB].[pv_impactDemographics] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_logs] ADD  DEFAULT (NULL) FOR [referenceId1]
GO
ALTER TABLE [pvDB].[pv_logs] ADD  DEFAULT (NULL) FOR [referenceId2]
GO
ALTER TABLE [pvDB].[pv_logs] ADD  DEFAULT (NULL) FOR [value1]
GO
ALTER TABLE [pvDB].[pv_logs] ADD  DEFAULT (NULL) FOR [value2]
GO
ALTER TABLE [pvDB].[pv_logTypes] ADD  DEFAULT (NULL) FOR [reference1Description]
GO
ALTER TABLE [pvDB].[pv_logTypes] ADD  DEFAULT (NULL) FOR [reference2Description]
GO
ALTER TABLE [pvDB].[pv_logTypes] ADD  DEFAULT (NULL) FOR [value1Description]
GO
ALTER TABLE [pvDB].[pv_logTypes] ADD  DEFAULT (NULL) FOR [value2Description]
GO
ALTER TABLE [pvDB].[pv_notificationConfigurations] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_organizationAdresses] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_organizationAffiliates] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_payments] ADD  DEFAULT (0x00) FOR [confirmed]
GO
ALTER TABLE [pvDB].[pv_payments] ADD  DEFAULT (N'En proceso') FOR [result]
GO
ALTER TABLE [pvDB].[pv_payments] ADD  DEFAULT (NULL) FOR [error]
GO
ALTER TABLE [pvDB].[pv_payMethod] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_proposalBenefits] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_proposalDemographics] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_proposalImpacts] ADD  DEFAULT ((0.00)) FOR [value]
GO
ALTER TABLE [pvDB].[pv_proposalImpacts] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_proposals] ADD  DEFAULT (0x01) FOR [current]
GO
ALTER TABLE [pvDB].[pv_proposals] ADD  DEFAULT (N'1.0') FOR [version]
GO
ALTER TABLE [pvDB].[pv_requests] ADD  DEFAULT (0x00) FOR [executed]
GO
ALTER TABLE [pvDB].[pv_requiredDocuments] ADD  DEFAULT (0x01) FOR [mandatory]
GO
ALTER TABLE [pvDB].[pv_rolePermissions] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_rolePermissions] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_rolePermissions] ADD  DEFAULT (getdate()) FOR [lastPermUpdate]
GO
ALTER TABLE [pvDB].[pv_schedules] ADD  DEFAULT (NULL) FOR [endDate]
GO
ALTER TABLE [pvDB].[pv_schedulesDetails] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_schedulesDetails] ADD  DEFAULT (NULL) FOR [lastExecute]
GO
ALTER TABLE [pvDB].[pv_targetDemographics] ADD  DEFAULT (NULL) FOR [maxRange]
GO
ALTER TABLE [pvDB].[pv_targetDemographics] ADD  DEFAULT ((1.00)) FOR [weight]
GO
ALTER TABLE [pvDB].[pv_targetOrganizations] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_tempConfirmations] ADD  DEFAULT (NULL) FOR [epoch]
GO
ALTER TABLE [pvDB].[pv_transactions] ADD  DEFAULT (NULL) FOR [payment_id]
GO
ALTER TABLE [pvDB].[pv_transactions] ADD  DEFAULT (NULL) FOR [exchangeCurrencyID]
GO
ALTER TABLE [pvDB].[pv_transactions] ADD  DEFAULT (NULL) FOR [amount]
GO
ALTER TABLE [pvDB].[pv_userAddresses] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_userDemographics] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_userPermissions] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_userPermissions] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_userPermissions] ADD  DEFAULT (getdate()) FOR [lastPermUpdate]
GO
ALTER TABLE [pvDB].[pv_userProfiles] ADD  DEFAULT (NULL) FOR [educationLevelID]
GO
ALTER TABLE [pvDB].[pv_userRoles] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_userRoles] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_userRoles] ADD  DEFAULT (getdate()) FOR [lastUpdate]
GO
ALTER TABLE [pvDB].[pv_voteOptions] ADD  DEFAULT (NULL) FOR [url]
GO
ALTER TABLE [pvDB].[pv_voteOptions] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[pv_voteOptions] ADD  DEFAULT (0x00) FOR [deleted]
GO
ALTER TABLE [pvDB].[pv_votes] ADD  DEFAULT (0x00) FOR [strictDemographic]
GO
ALTER TABLE [pvDB].[pv_votes] ADD  DEFAULT (0x01) FOR [commentsEnabled]
GO
ALTER TABLE [pvDB].[pv_workflowParameters] ADD  DEFAULT (0x01) FOR [required]
GO
ALTER TABLE [pvDB].[pv_workflowParameters] ADD  DEFAULT (NULL) FOR [defaultValue]
GO
ALTER TABLE [pvDB].[pv_workflows] ADD  DEFAULT (0x01) FOR [enabled]
GO
ALTER TABLE [pvDB].[cf_crowfundingEvents]  WITH CHECK ADD  CONSTRAINT [cf_crowfundingEvents$fk_cf_crowfundingEvents_pv_crowfundingStatuses1] FOREIGN KEY([crowfundingStatusID])
REFERENCES [pvDB].[pv_crowfundingStatuses] ([crowfundingStatusID])
GO
ALTER TABLE [pvDB].[cf_crowfundingEvents] CHECK CONSTRAINT [cf_crowfundingEvents$fk_cf_crowfundingEvents_pv_crowfundingStatuses1]
GO
ALTER TABLE [pvDB].[cf_crowfundingEvents]  WITH CHECK ADD  CONSTRAINT [cf_crowfundingEvents$fk_cf_crowfundingEvents_pv_proposals1] FOREIGN KEY([proposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[cf_crowfundingEvents] CHECK CONSTRAINT [cf_crowfundingEvents$fk_cf_crowfundingEvents_pv_proposals1]
GO
ALTER TABLE [pvDB].[cf_crowfundingEvents]  WITH CHECK ADD  CONSTRAINT [cf_crowfundingEvents$fk_cf_crowfundingEvents_sol_currencies1] FOREIGN KEY([currency_id])
REFERENCES [pvDB].[pv_currencies] ([currencyID])
GO
ALTER TABLE [pvDB].[cf_crowfundingEvents] CHECK CONSTRAINT [cf_crowfundingEvents$fk_cf_crowfundingEvents_sol_currencies1]
GO
ALTER TABLE [pvDB].[cf_financialReports]  WITH CHECK ADD  CONSTRAINT [cf_financialReports$fk_cf_financialReports_pv_proposalDocuments1] FOREIGN KEY([proposalDocumentID])
REFERENCES [pvDB].[pv_proposalDocuments] ([proposalDocumentID])
GO
ALTER TABLE [pvDB].[cf_financialReports] CHECK CONSTRAINT [cf_financialReports$fk_cf_financialReports_pv_proposalDocuments1]
GO
ALTER TABLE [pvDB].[cf_financialReports]  WITH CHECK ADD  CONSTRAINT [cf_financialReports$fk_cf_financialReports_pv_proposals1] FOREIGN KEY([proposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[cf_financialReports] CHECK CONSTRAINT [cf_financialReports$fk_cf_financialReports_pv_proposals1]
GO
ALTER TABLE [pvDB].[cf_financialReports]  WITH CHECK ADD  CONSTRAINT [cf_financialReports$fk_cf_financialReports_pv_users1] FOREIGN KEY([uploadedBy])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[cf_financialReports] CHECK CONSTRAINT [cf_financialReports$fk_cf_financialReports_pv_users1]
GO
ALTER TABLE [pvDB].[cf_financialReports]  WITH CHECK ADD  CONSTRAINT [cf_financialReports$fk_cf_financialReports_reportStatuses1] FOREIGN KEY([reportStatusID])
REFERENCES [pvDB].[reportStatuses] ([reportStatusID])
GO
ALTER TABLE [pvDB].[cf_financialReports] CHECK CONSTRAINT [cf_financialReports$fk_cf_financialReports_reportStatuses1]
GO
ALTER TABLE [pvDB].[cf_financialResults]  WITH CHECK ADD  CONSTRAINT [cf_financialResults$fk_cf_financialResults_cf_financialReports1] FOREIGN KEY([financialReportID])
REFERENCES [pvDB].[cf_financialReports] ([financialReportID])
GO
ALTER TABLE [pvDB].[cf_financialResults] CHECK CONSTRAINT [cf_financialResults$fk_cf_financialResults_cf_financialReports1]
GO
ALTER TABLE [pvDB].[cf_financialResults]  WITH CHECK ADD  CONSTRAINT [cf_financialResults$fk_cf_financialResults_pv_currencies1] FOREIGN KEY([currencyID])
REFERENCES [pvDB].[pv_currencies] ([currencyID])
GO
ALTER TABLE [pvDB].[cf_financialResults] CHECK CONSTRAINT [cf_financialResults$fk_cf_financialResults_pv_currencies1]
GO
ALTER TABLE [pvDB].[cf_fundingProgresses]  WITH CHECK ADD  CONSTRAINT [cf_fundingProgresses$fk_cf_fundingProgresses_cf_crowfundingEvents1] FOREIGN KEY([crowfundingID])
REFERENCES [pvDB].[cf_crowfundingEvents] ([crowfundingID])
GO
ALTER TABLE [pvDB].[cf_fundingProgresses] CHECK CONSTRAINT [cf_fundingProgresses$fk_cf_fundingProgresses_cf_crowfundingEvents1]
GO
ALTER TABLE [pvDB].[cf_investments]  WITH CHECK ADD  CONSTRAINT [cf_investments$fk_cf_investments_cf_crowfundingEvents1] FOREIGN KEY([crowfundingID])
REFERENCES [pvDB].[cf_crowfundingEvents] ([crowfundingID])
GO
ALTER TABLE [pvDB].[cf_investments] CHECK CONSTRAINT [cf_investments$fk_cf_investments_cf_crowfundingEvents1]
GO
ALTER TABLE [pvDB].[cf_investments]  WITH CHECK ADD  CONSTRAINT [cf_investments$fk_cf_investments_pv_paymentStatuses1] FOREIGN KEY([statusID])
REFERENCES [pvDB].[pv_paymentStatuses] ([paymentStatusID])
GO
ALTER TABLE [pvDB].[cf_investments] CHECK CONSTRAINT [cf_investments$fk_cf_investments_pv_paymentStatuses1]
GO
ALTER TABLE [pvDB].[cf_investments]  WITH CHECK ADD  CONSTRAINT [cf_investments$fk_cf_investments_pv_transactions1] FOREIGN KEY([transactionID])
REFERENCES [pvDB].[pv_transactions] ([transactionID])
GO
ALTER TABLE [pvDB].[cf_investments] CHECK CONSTRAINT [cf_investments$fk_cf_investments_pv_transactions1]
GO
ALTER TABLE [pvDB].[cf_investments]  WITH CHECK ADD  CONSTRAINT [cf_investments$fk_cf_investments_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[cf_investments] CHECK CONSTRAINT [cf_investments$fk_cf_investments_pv_users1]
GO
ALTER TABLE [pvDB].[cf_payouts]  WITH CHECK ADD  CONSTRAINT [cf_payouts$fk_cf_payouts_cf_financialReports1] FOREIGN KEY([financialReportID])
REFERENCES [pvDB].[cf_financialReports] ([financialReportID])
GO
ALTER TABLE [pvDB].[cf_payouts] CHECK CONSTRAINT [cf_payouts$fk_cf_payouts_cf_financialReports1]
GO
ALTER TABLE [pvDB].[cf_payouts]  WITH CHECK ADD  CONSTRAINT [cf_payouts$fk_cf_payouts_cf_investments1] FOREIGN KEY([investmentID])
REFERENCES [pvDB].[cf_investments] ([investmentID])
GO
ALTER TABLE [pvDB].[cf_payouts] CHECK CONSTRAINT [cf_payouts$fk_cf_payouts_cf_investments1]
GO
ALTER TABLE [pvDB].[cf_payouts]  WITH CHECK ADD  CONSTRAINT [cf_payouts$fk_cf_payouts_pv_paymentStatuses1] FOREIGN KEY([paymentStatusID])
REFERENCES [pvDB].[pv_paymentStatuses] ([paymentStatusID])
GO
ALTER TABLE [pvDB].[cf_payouts] CHECK CONSTRAINT [cf_payouts$fk_cf_payouts_pv_paymentStatuses1]
GO
ALTER TABLE [pvDB].[cf_payouts]  WITH CHECK ADD  CONSTRAINT [cf_payouts$fk_cf_payouts_pv_transactions1] FOREIGN KEY([transactionID])
REFERENCES [pvDB].[pv_transactions] ([transactionID])
GO
ALTER TABLE [pvDB].[cf_payouts] CHECK CONSTRAINT [cf_payouts$fk_cf_payouts_pv_transactions1]
GO
ALTER TABLE [pvDB].[pv_addresses]  WITH CHECK ADD  CONSTRAINT [pv_addresses$fk_pay_Addresses_pay_city1] FOREIGN KEY([cityID])
REFERENCES [pvDB].[pv_cities] ([cityID])
GO
ALTER TABLE [pvDB].[pv_addresses] CHECK CONSTRAINT [pv_addresses$fk_pay_Addresses_pay_city1]
GO
ALTER TABLE [pvDB].[pv_availablePayMethods]  WITH CHECK ADD  CONSTRAINT [pv_availablePayMethods$fk_pay_available_media_pay_pay_method1] FOREIGN KEY([methodID])
REFERENCES [pvDB].[pv_payMethod] ([payMethodID])
GO
ALTER TABLE [pvDB].[pv_availablePayMethods] CHECK CONSTRAINT [pv_availablePayMethods$fk_pay_available_media_pay_pay_method1]
GO
ALTER TABLE [pvDB].[pv_biometricData]  WITH CHECK ADD  CONSTRAINT [pv_biometricData$fk_pv_biometricData_pv_biometricTypes1] FOREIGN KEY([biometricTypeID])
REFERENCES [pvDB].[pv_biometricTypes] ([biometricTypeID])
GO
ALTER TABLE [pvDB].[pv_biometricData] CHECK CONSTRAINT [pv_biometricData$fk_pv_biometricData_pv_biometricTypes1]
GO
ALTER TABLE [pvDB].[pv_biometricData]  WITH CHECK ADD  CONSTRAINT [pv_biometricData$fk_pv_biometricData_pv_devices1] FOREIGN KEY([deviceID])
REFERENCES [pvDB].[pv_biometricDevices] ([deviceID])
GO
ALTER TABLE [pvDB].[pv_biometricData] CHECK CONSTRAINT [pv_biometricData$fk_pv_biometricData_pv_devices1]
GO
ALTER TABLE [pvDB].[pv_biometricData]  WITH CHECK ADD  CONSTRAINT [pv_biometricData$fk_pv_biometricData_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_biometricData] CHECK CONSTRAINT [pv_biometricData$fk_pv_biometricData_pv_users1]
GO
ALTER TABLE [pvDB].[pv_biometricFiles]  WITH CHECK ADD  CONSTRAINT [pv_biometricFiles$fk_pv_biometricFiles_pv_biometricData1] FOREIGN KEY([biometricDataID])
REFERENCES [pvDB].[pv_biometricData] ([biometricDataID])
GO
ALTER TABLE [pvDB].[pv_biometricFiles] CHECK CONSTRAINT [pv_biometricFiles$fk_pv_biometricFiles_pv_biometricData1]
GO
ALTER TABLE [pvDB].[pv_biometricFiles]  WITH CHECK ADD  CONSTRAINT [pv_biometricFiles$fk_pv_biometricFiles_pv_mediaFile1] FOREIGN KEY([mediaFileID])
REFERENCES [pvDB].[pv_mediaFile] ([mediaFileID])
GO
ALTER TABLE [pvDB].[pv_biometricFiles] CHECK CONSTRAINT [pv_biometricFiles$fk_pv_biometricFiles_pv_mediaFile1]
GO
ALTER TABLE [pvDB].[pv_biometricResults]  WITH CHECK ADD  CONSTRAINT [pv_biometricResults$fk_pv_biometricResults_pv_biometricData1] FOREIGN KEY([biometricDataID])
REFERENCES [pvDB].[pv_biometricData] ([biometricDataID])
GO
ALTER TABLE [pvDB].[pv_biometricResults] CHECK CONSTRAINT [pv_biometricResults$fk_pv_biometricResults_pv_biometricData1]
GO
ALTER TABLE [pvDB].[pv_cities]  WITH CHECK ADD  CONSTRAINT [pv_cities$fk_pay_city_pay_states1] FOREIGN KEY([stateID])
REFERENCES [pvDB].[pv_states] ([stateID])
GO
ALTER TABLE [pvDB].[pv_cities] CHECK CONSTRAINT [pv_cities$fk_pay_city_pay_states1]
GO
ALTER TABLE [pvDB].[pv_commentDocuments]  WITH CHECK ADD  CONSTRAINT [pv_commentDocuments$fk_pv_commentDocuments_pv_comments1] FOREIGN KEY([commentID])
REFERENCES [pvDB].[pv_comments] ([commentID])
GO
ALTER TABLE [pvDB].[pv_commentDocuments] CHECK CONSTRAINT [pv_commentDocuments$fk_pv_commentDocuments_pv_comments1]
GO
ALTER TABLE [pvDB].[pv_commentDocuments]  WITH CHECK ADD  CONSTRAINT [pv_commentDocuments$fk_pv_commentDocuments_pv_documents1] FOREIGN KEY([documentID])
REFERENCES [pvDB].[pv_documents] ([documentID])
GO
ALTER TABLE [pvDB].[pv_commentDocuments] CHECK CONSTRAINT [pv_commentDocuments$fk_pv_commentDocuments_pv_documents1]
GO
ALTER TABLE [pvDB].[pv_comments]  WITH CHECK ADD  CONSTRAINT [pv_comments$FK_Comentario_Propuesta] FOREIGN KEY([proposeID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_comments] CHECK CONSTRAINT [pv_comments$FK_Comentario_Propuesta]
GO
ALTER TABLE [pvDB].[pv_comments]  WITH CHECK ADD  CONSTRAINT [pv_comments$fk_Comentario_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_comments] CHECK CONSTRAINT [pv_comments$fk_Comentario_pv_users1]
GO
ALTER TABLE [pvDB].[pv_comments]  WITH CHECK ADD  CONSTRAINT [pv_comments$FK_Comentario_Self] FOREIGN KEY([previousCommentID])
REFERENCES [pvDB].[pv_comments] ([commentID])
GO
ALTER TABLE [pvDB].[pv_comments] CHECK CONSTRAINT [pv_comments$FK_Comentario_Self]
GO
ALTER TABLE [pvDB].[pv_comments]  WITH CHECK ADD  CONSTRAINT [pv_comments$fk_pv_comments_pv_commentStatus1] FOREIGN KEY([commentStatusID])
REFERENCES [pvDB].[pv_commentStatus] ([commentStatusID])
GO
ALTER TABLE [pvDB].[pv_comments] CHECK CONSTRAINT [pv_comments$fk_pv_comments_pv_commentStatus1]
GO
ALTER TABLE [pvDB].[pv_conditions]  WITH CHECK ADD  CONSTRAINT [pv_conditions$fk_pv_conditions_pv_conditionTypes1] FOREIGN KEY([conditionTypeID])
REFERENCES [pvDB].[pv_conditionTypes] ([conditionTypeID])
GO
ALTER TABLE [pvDB].[pv_conditions] CHECK CONSTRAINT [pv_conditions$fk_pv_conditions_pv_conditionTypes1]
GO
ALTER TABLE [pvDB].[pv_conditions]  WITH CHECK ADD  CONSTRAINT [pv_conditions$fk_pv_conditions_pv_organizations1] FOREIGN KEY([organizationID])
REFERENCES [pvDB].[pv_organizations] ([organizationID])
GO
ALTER TABLE [pvDB].[pv_conditions] CHECK CONSTRAINT [pv_conditions$fk_pv_conditions_pv_organizations1]
GO
ALTER TABLE [pvDB].[pv_conditions]  WITH CHECK ADD  CONSTRAINT [pv_conditions$fk_pv_conditions_pv_unitTypes1] FOREIGN KEY([unitTypeID])
REFERENCES [pvDB].[pv_unitTypes] ([unitTypeID])
GO
ALTER TABLE [pvDB].[pv_conditions] CHECK CONSTRAINT [pv_conditions$fk_pv_conditions_pv_unitTypes1]
GO
ALTER TABLE [pvDB].[pv_conditions]  WITH CHECK ADD  CONSTRAINT [pv_conditions$fk_pv_conditions_pv_votes1] FOREIGN KEY([voteID])
REFERENCES [pvDB].[pv_votes] ([voteID])
GO
ALTER TABLE [pvDB].[pv_conditions] CHECK CONSTRAINT [pv_conditions$fk_pv_conditions_pv_votes1]
GO
ALTER TABLE [pvDB].[pv_confirmedVoteDemographics]  WITH CHECK ADD  CONSTRAINT [pv_confirmedVoteDemographics$fk_pv_voteDemographics_pv_confirmedVotes1] FOREIGN KEY([confirmedVoteID])
REFERENCES [pvDB].[pv_confirmedVotes] ([confirmedVoteID])
GO
ALTER TABLE [pvDB].[pv_confirmedVoteDemographics] CHECK CONSTRAINT [pv_confirmedVoteDemographics$fk_pv_voteDemographics_pv_confirmedVotes1]
GO
ALTER TABLE [pvDB].[pv_confirmedVoteDemographics]  WITH CHECK ADD  CONSTRAINT [pv_confirmedVoteDemographics$fk_pv_voteDemographics_pv_targetDemographics1] FOREIGN KEY([targetDemographicID])
REFERENCES [pvDB].[pv_targetDemographics] ([targetDemographicID])
GO
ALTER TABLE [pvDB].[pv_confirmedVoteDemographics] CHECK CONSTRAINT [pv_confirmedVoteDemographics$fk_pv_voteDemographics_pv_targetDemographics1]
GO
ALTER TABLE [pvDB].[pv_confirmedVotes]  WITH CHECK ADD  CONSTRAINT [pv_confirmedVotes$fk_pv_confirmedVotes_pv_tokens1] FOREIGN KEY([tokenID])
REFERENCES [pvDB].[pv_tokens] ([tokenID])
GO
ALTER TABLE [pvDB].[pv_confirmedVotes] CHECK CONSTRAINT [pv_confirmedVotes$fk_pv_confirmedVotes_pv_tokens1]
GO
ALTER TABLE [pvDB].[pv_confirmedVotes]  WITH CHECK ADD  CONSTRAINT [pv_confirmedVotes$FK_Votes_Opcion] FOREIGN KEY([optionVoteID])
REFERENCES [pvDB].[pv_voteOptions] ([voteOptionID])
GO
ALTER TABLE [pvDB].[pv_confirmedVotes] CHECK CONSTRAINT [pv_confirmedVotes$FK_Votes_Opcion]
GO
ALTER TABLE [pvDB].[pv_contactInfo]  WITH CHECK ADD  CONSTRAINT [pv_contactInfo$fk_pay_contact_info_pay_contact_type1] FOREIGN KEY([contactTypeID])
REFERENCES [pvDB].[pv_contactTypes] ([contactTypeID])
GO
ALTER TABLE [pvDB].[pv_contactInfo] CHECK CONSTRAINT [pv_contactInfo$fk_pay_contact_info_pay_contact_type1]
GO
ALTER TABLE [pvDB].[pv_contactInfo]  WITH CHECK ADD  CONSTRAINT [pv_contactInfo$fk_sol_contact_info_sol_contact_departments1] FOREIGN KEY([contactDepartmentId])
REFERENCES [pvDB].[pv_contactDepartments] ([contactDepartmentId])
GO
ALTER TABLE [pvDB].[pv_contactInfo] CHECK CONSTRAINT [pv_contactInfo$fk_sol_contact_info_sol_contact_departments1]
GO
ALTER TABLE [pvDB].[pv_countryWhitelists]  WITH CHECK ADD  CONSTRAINT [pv_countryWhitelists$fk_pv_countryWhitelists_pv_countries1] FOREIGN KEY([countryID])
REFERENCES [pvDB].[pv_countries] ([countryID])
GO
ALTER TABLE [pvDB].[pv_countryWhitelists] CHECK CONSTRAINT [pv_countryWhitelists$fk_pv_countryWhitelists_pv_countries1]
GO
ALTER TABLE [pvDB].[pv_currencies]  WITH CHECK ADD  CONSTRAINT [pv_currencies$fk_pay_currencies_pay_countries1] FOREIGN KEY([countryID])
REFERENCES [pvDB].[pv_countries] ([countryID])
GO
ALTER TABLE [pvDB].[pv_currencies] CHECK CONSTRAINT [pv_currencies$fk_pay_currencies_pay_countries1]
GO
ALTER TABLE [pvDB].[pv_deliverables]  WITH CHECK ADD  CONSTRAINT [pv_deliverables$fk_pv_deliverables_pv_currencies1] FOREIGN KEY([currencyID])
REFERENCES [pvDB].[pv_currencies] ([currencyID])
GO
ALTER TABLE [pvDB].[pv_deliverables] CHECK CONSTRAINT [pv_deliverables$fk_pv_deliverables_pv_currencies1]
GO
ALTER TABLE [pvDB].[pv_deliverables]  WITH CHECK ADD  CONSTRAINT [pv_deliverables$fk_pv_deliverables_pv_KPITypes1] FOREIGN KEY([KPITypeID])
REFERENCES [pvDB].[pv_KPITypes] ([KPITypeID])
GO
ALTER TABLE [pvDB].[pv_deliverables] CHECK CONSTRAINT [pv_deliverables$fk_pv_deliverables_pv_KPITypes1]
GO
ALTER TABLE [pvDB].[pv_deliverables]  WITH CHECK ADD  CONSTRAINT [pv_deliverables$fk_pv_deliverables_pv_milestones1] FOREIGN KEY([milestoneID])
REFERENCES [pvDB].[pv_milestones] ([milestoneID])
GO
ALTER TABLE [pvDB].[pv_deliverables] CHECK CONSTRAINT [pv_deliverables$fk_pv_deliverables_pv_milestones1]
GO
ALTER TABLE [pvDB].[pv_deliverables]  WITH CHECK ADD  CONSTRAINT [pv_deliverables$fk_pv_deliverables_pv_votes1] FOREIGN KEY([voteID])
REFERENCES [pvDB].[pv_votes] ([voteID])
GO
ALTER TABLE [pvDB].[pv_deliverables] CHECK CONSTRAINT [pv_deliverables$fk_pv_deliverables_pv_votes1]
GO
ALTER TABLE [pvDB].[pv_documents]  WITH CHECK ADD  CONSTRAINT [pv_documents$fk_pv_documents_pv_documentStatus1] FOREIGN KEY([documentStatusID])
REFERENCES [pvDB].[pv_documentStatus] ([documentStatusID])
GO
ALTER TABLE [pvDB].[pv_documents] CHECK CONSTRAINT [pv_documents$fk_pv_documents_pv_documentStatus1]
GO
ALTER TABLE [pvDB].[pv_documents]  WITH CHECK ADD  CONSTRAINT [pv_documents$fk_pv_documents_pv_documentTypes1] FOREIGN KEY([documentTypeID])
REFERENCES [pvDB].[pv_documentTypes] ([documentTypeID])
GO
ALTER TABLE [pvDB].[pv_documents] CHECK CONSTRAINT [pv_documents$fk_pv_documents_pv_documentTypes1]
GO
ALTER TABLE [pvDB].[pv_documents]  WITH CHECK ADD  CONSTRAINT [pv_documents$fk_pv_documents_pv_mediaFile1] FOREIGN KEY([mediaFileID])
REFERENCES [pvDB].[pv_mediaFile] ([mediaFileID])
GO
ALTER TABLE [pvDB].[pv_documents] CHECK CONSTRAINT [pv_documents$fk_pv_documents_pv_mediaFile1]
GO
ALTER TABLE [pvDB].[pv_documentTypeWorkflows]  WITH CHECK ADD  CONSTRAINT [pv_documentTypeWorkflows$fk_pv_documentTypeWorkflows_pv_documentTypes1] FOREIGN KEY([documentTypeID])
REFERENCES [pvDB].[pv_documentTypes] ([documentTypeID])
GO
ALTER TABLE [pvDB].[pv_documentTypeWorkflows] CHECK CONSTRAINT [pv_documentTypeWorkflows$fk_pv_documentTypeWorkflows_pv_documentTypes1]
GO
ALTER TABLE [pvDB].[pv_documentTypeWorkflows]  WITH CHECK ADD  CONSTRAINT [pv_documentTypeWorkflows$fk_pv_documentTypeWorkflows_pv_workflows1] FOREIGN KEY([workflowID])
REFERENCES [pvDB].[pv_workflows] ([workflowID])
GO
ALTER TABLE [pvDB].[pv_documentTypeWorkflows] CHECK CONSTRAINT [pv_documentTypeWorkflows$fk_pv_documentTypeWorkflows_pv_workflows1]
GO
ALTER TABLE [pvDB].[pv_encryptionKeyMetadata]  WITH CHECK ADD  CONSTRAINT [pv_encryptionKeyMetadata$fk_pv_encryptionKeyMetadata_pv_keyTypes1] FOREIGN KEY([keyTypeID])
REFERENCES [pvDB].[pv_keyTypes] ([keyTypeID])
GO
ALTER TABLE [pvDB].[pv_encryptionKeyMetadata] CHECK CONSTRAINT [pv_encryptionKeyMetadata$fk_pv_encryptionKeyMetadata_pv_keyTypes1]
GO
ALTER TABLE [pvDB].[pv_encryptionKeyMetadata]  WITH CHECK ADD  CONSTRAINT [pv_encryptionKeyMetadata$fk_pv_encryptionKeyMetadata_pv_owningEntityTypes1] FOREIGN KEY([owningEntityTypeID])
REFERENCES [pvDB].[pv_owningEntityTypes] ([owningEntityTypeID])
GO
ALTER TABLE [pvDB].[pv_encryptionKeyMetadata] CHECK CONSTRAINT [pv_encryptionKeyMetadata$fk_pv_encryptionKeyMetadata_pv_owningEntityTypes1]
GO
ALTER TABLE [pvDB].[pv_exchangeCurrencies]  WITH CHECK ADD  CONSTRAINT [pv_exchangeCurrencies$fk_pay_exchange_currency_pay_currency1] FOREIGN KEY([sourceID])
REFERENCES [pvDB].[pv_currencies] ([currencyID])
GO
ALTER TABLE [pvDB].[pv_exchangeCurrencies] CHECK CONSTRAINT [pv_exchangeCurrencies$fk_pay_exchange_currency_pay_currency1]
GO
ALTER TABLE [pvDB].[pv_exchangeCurrencies]  WITH CHECK ADD  CONSTRAINT [pv_exchangeCurrencies$fk_pay_exchange_currency_pay_currency2] FOREIGN KEY([destinyID])
REFERENCES [pvDB].[pv_currencies] ([currencyID])
GO
ALTER TABLE [pvDB].[pv_exchangeCurrencies] CHECK CONSTRAINT [pv_exchangeCurrencies$fk_pay_exchange_currency_pay_currency2]
GO
ALTER TABLE [pvDB].[pv_executionPlans]  WITH CHECK ADD  CONSTRAINT [pv_executionPlans$fk_pv_executionPlans_pv_proposalDocuments2] FOREIGN KEY([proposalDocumentID])
REFERENCES [pvDB].[pv_proposalDocuments] ([proposalDocumentID])
GO
ALTER TABLE [pvDB].[pv_executionPlans] CHECK CONSTRAINT [pv_executionPlans$fk_pv_executionPlans_pv_proposalDocuments2]
GO
ALTER TABLE [pvDB].[pv_executionPlans]  WITH CHECK ADD  CONSTRAINT [pv_executionPlans$fk_pv_executionPlans1_pv_proposals1] FOREIGN KEY([proposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_executionPlans] CHECK CONSTRAINT [pv_executionPlans$fk_pv_executionPlans1_pv_proposals1]
GO
ALTER TABLE [pvDB].[pv_impactDemographics]  WITH CHECK ADD  CONSTRAINT [pv_impactDemographics$fk_pv_ImpactDemographics_pv_proposalImpacts1] FOREIGN KEY([proposalImpactID])
REFERENCES [pvDB].[pv_proposalImpacts] ([proposalImpactID])
GO
ALTER TABLE [pvDB].[pv_impactDemographics] CHECK CONSTRAINT [pv_impactDemographics$fk_pv_ImpactDemographics_pv_proposalImpacts1]
GO
ALTER TABLE [pvDB].[pv_logs]  WITH CHECK ADD  CONSTRAINT [pv_logs$fk_pay_logs_pay_log_severity1] FOREIGN KEY([logSeverityID])
REFERENCES [pvDB].[pv_logsSererity] ([logSererityID])
GO
ALTER TABLE [pvDB].[pv_logs] CHECK CONSTRAINT [pv_logs$fk_pay_logs_pay_log_severity1]
GO
ALTER TABLE [pvDB].[pv_logs]  WITH CHECK ADD  CONSTRAINT [pv_logs$fk_pay_logs_pay_log_sources1] FOREIGN KEY([logSourcesID])
REFERENCES [pvDB].[pv_logSources] ([logSourcesID])
GO
ALTER TABLE [pvDB].[pv_logs] CHECK CONSTRAINT [pv_logs$fk_pay_logs_pay_log_sources1]
GO
ALTER TABLE [pvDB].[pv_logs]  WITH CHECK ADD  CONSTRAINT [pv_logs$fk_pay_logs_pay_log_types1] FOREIGN KEY([logTypesID])
REFERENCES [pvDB].[pv_logTypes] ([logTypesID])
GO
ALTER TABLE [pvDB].[pv_logs] CHECK CONSTRAINT [pv_logs$fk_pay_logs_pay_log_types1]
GO
ALTER TABLE [pvDB].[pv_mediaFile]  WITH CHECK ADD  CONSTRAINT [pv_mediaFile$fk_pv_mediaFile_pv_mediaTypes1] FOREIGN KEY([mediaTypeID])
REFERENCES [pvDB].[pv_mediaTypes] ([mediaTypeID])
GO
ALTER TABLE [pvDB].[pv_mediaFile] CHECK CONSTRAINT [pv_mediaFile$fk_pv_mediaFile_pv_mediaTypes1]
GO
ALTER TABLE [pvDB].[pv_milestones]  WITH CHECK ADD  CONSTRAINT [pv_milestones$fk_pv_milestones_pv_currencies1] FOREIGN KEY([currencyID])
REFERENCES [pvDB].[pv_currencies] ([currencyID])
GO
ALTER TABLE [pvDB].[pv_milestones] CHECK CONSTRAINT [pv_milestones$fk_pv_milestones_pv_currencies1]
GO
ALTER TABLE [pvDB].[pv_milestones]  WITH CHECK ADD  CONSTRAINT [pv_milestones$fk_pv_milestones_pv_executionPlans11] FOREIGN KEY([executionPlanID])
REFERENCES [pvDB].[pv_executionPlans] ([executionPlanID])
GO
ALTER TABLE [pvDB].[pv_milestones] CHECK CONSTRAINT [pv_milestones$fk_pv_milestones_pv_executionPlans11]
GO
ALTER TABLE [pvDB].[pv_milestones]  WITH CHECK ADD  CONSTRAINT [pv_milestones$fk_pv_milestones_pv_timeUnits1] FOREIGN KEY([timeUnitID])
REFERENCES [pvDB].[pv_timeUnits] ([timeUnitID])
GO
ALTER TABLE [pvDB].[pv_milestones] CHECK CONSTRAINT [pv_milestones$fk_pv_milestones_pv_timeUnits1]
GO
ALTER TABLE [pvDB].[pv_milestones]  WITH CHECK ADD  CONSTRAINT [pv_milestones$fk_pv_milestones_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_milestones] CHECK CONSTRAINT [pv_milestones$fk_pv_milestones_pv_users1]
GO
ALTER TABLE [pvDB].[pv_nationalities]  WITH CHECK ADD  CONSTRAINT [pv_nationalities$fk_pv_nationalities_pv_countries1] FOREIGN KEY([countryID])
REFERENCES [pvDB].[pv_countries] ([countryID])
GO
ALTER TABLE [pvDB].[pv_nationalities] CHECK CONSTRAINT [pv_nationalities$fk_pv_nationalities_pv_countries1]
GO
ALTER TABLE [pvDB].[pv_notificationConfigurations]  WITH CHECK ADD  CONSTRAINT [pv_notificationConfigurations$fk_notification_configurations_pay_communication_channels1] FOREIGN KEY([communicationChannelID])
REFERENCES [pvDB].[pv_communicationChannels] ([communicationChannelID])
GO
ALTER TABLE [pvDB].[pv_notificationConfigurations] CHECK CONSTRAINT [pv_notificationConfigurations$fk_notification_configurations_pay_communication_channels1]
GO
ALTER TABLE [pvDB].[pv_notificationConfigurations]  WITH CHECK ADD  CONSTRAINT [pv_notificationConfigurations$fk_notification_configurations_pay_notification_types1] FOREIGN KEY([notificationTypeID])
REFERENCES [pvDB].[pv_notificationTypes] ([notificationTypeID])
GO
ALTER TABLE [pvDB].[pv_notificationConfigurations] CHECK CONSTRAINT [pv_notificationConfigurations$fk_notification_configurations_pay_notification_types1]
GO
ALTER TABLE [pvDB].[pv_notificationConfigurations]  WITH CHECK ADD  CONSTRAINT [pv_notificationConfigurations$fk_pv_notificationConfigurations_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_notificationConfigurations] CHECK CONSTRAINT [pv_notificationConfigurations$fk_pv_notificationConfigurations_pv_users1]
GO
ALTER TABLE [pvDB].[pv_notifications]  WITH CHECK ADD  CONSTRAINT [pv_notifications$fk_pay_notifications_pay_channel_types1] FOREIGN KEY([communicationChannelID])
REFERENCES [pvDB].[pv_communicationChannels] ([communicationChannelID])
GO
ALTER TABLE [pvDB].[pv_notifications] CHECK CONSTRAINT [pv_notifications$fk_pay_notifications_pay_channel_types1]
GO
ALTER TABLE [pvDB].[pv_notifications]  WITH CHECK ADD  CONSTRAINT [pv_notifications$fk_pay_notifications_pay_notification_types1] FOREIGN KEY([notificationTypeID])
REFERENCES [pvDB].[pv_notificationTypes] ([notificationTypeID])
GO
ALTER TABLE [pvDB].[pv_notifications] CHECK CONSTRAINT [pv_notifications$fk_pay_notifications_pay_notification_types1]
GO
ALTER TABLE [pvDB].[pv_notifications]  WITH CHECK ADD  CONSTRAINT [pv_notifications$fk_pv_notifications_pv_notificationStatus1] FOREIGN KEY([notificationStatusID])
REFERENCES [pvDB].[pv_notificationStatus] ([notificationStatusID])
GO
ALTER TABLE [pvDB].[pv_notifications] CHECK CONSTRAINT [pv_notifications$fk_pv_notifications_pv_notificationStatus1]
GO
ALTER TABLE [pvDB].[pv_notifications]  WITH CHECK ADD  CONSTRAINT [pv_notifications$fk_pv_notifications_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_notifications] CHECK CONSTRAINT [pv_notifications$fk_pv_notifications_pv_users1]
GO
ALTER TABLE [pvDB].[pv_organization_type_has_pv_documentType]  WITH CHECK ADD  CONSTRAINT [pv_organization_type_has_pv_documentType$fk_pv_organization_type_has_pv_documentType_pv_documentType1] FOREIGN KEY([pv_documentType_idDocumentType])
REFERENCES [pvDB].[pv_documentTypes] ([documentTypeID])
GO
ALTER TABLE [pvDB].[pv_organization_type_has_pv_documentType] CHECK CONSTRAINT [pv_organization_type_has_pv_documentType$fk_pv_organization_type_has_pv_documentType_pv_documentType1]
GO
ALTER TABLE [pvDB].[pv_organization_type_has_pv_documentType]  WITH CHECK ADD  CONSTRAINT [pv_organization_type_has_pv_documentType$fk_pv_organization_type_has_pv_documentType_pv_organization_t1] FOREIGN KEY([pv_organization_type_organizationTypeId])
REFERENCES [pvDB].[pv_organizationTypes] ([organizationTypeID])
GO
ALTER TABLE [pvDB].[pv_organization_type_has_pv_documentType] CHECK CONSTRAINT [pv_organization_type_has_pv_documentType$fk_pv_organization_type_has_pv_documentType_pv_organization_t1]
GO
ALTER TABLE [pvDB].[pv_organizationAdresses]  WITH CHECK ADD  CONSTRAINT [pv_organizationAdresses$fk_pv_organizationAdresses_pv_addresses1] FOREIGN KEY([addressID])
REFERENCES [pvDB].[pv_addresses] ([addressID])
GO
ALTER TABLE [pvDB].[pv_organizationAdresses] CHECK CONSTRAINT [pv_organizationAdresses$fk_pv_organizationAdresses_pv_addresses1]
GO
ALTER TABLE [pvDB].[pv_organizationAdresses]  WITH CHECK ADD  CONSTRAINT [pv_organizationAdresses$fk_pv_organizationAdresses_pv_organizations1] FOREIGN KEY([organizationID])
REFERENCES [pvDB].[pv_organizations] ([organizationID])
GO
ALTER TABLE [pvDB].[pv_organizationAdresses] CHECK CONSTRAINT [pv_organizationAdresses$fk_pv_organizationAdresses_pv_organizations1]
GO
ALTER TABLE [pvDB].[pv_organizationAffiliates]  WITH CHECK ADD  CONSTRAINT [pv_organizationAffiliates$fk_pv_organizationAffiliates_pv_jobPositions1] FOREIGN KEY([positionID])
REFERENCES [pvDB].[pv_jobPositions] ([positionID])
GO
ALTER TABLE [pvDB].[pv_organizationAffiliates] CHECK CONSTRAINT [pv_organizationAffiliates$fk_pv_organizationAffiliates_pv_jobPositions1]
GO
ALTER TABLE [pvDB].[pv_organizationAffiliates]  WITH CHECK ADD  CONSTRAINT [pv_organizationAffiliates$fk_pv_organizationAffiliates_pv_organizations1] FOREIGN KEY([organizationID])
REFERENCES [pvDB].[pv_organizations] ([organizationID])
GO
ALTER TABLE [pvDB].[pv_organizationAffiliates] CHECK CONSTRAINT [pv_organizationAffiliates$fk_pv_organizationAffiliates_pv_organizations1]
GO
ALTER TABLE [pvDB].[pv_organizationAffiliates]  WITH CHECK ADD  CONSTRAINT [pv_organizationAffiliates$fk_pv_organizationAffiliates_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_organizationAffiliates] CHECK CONSTRAINT [pv_organizationAffiliates$fk_pv_organizationAffiliates_pv_users1]
GO
ALTER TABLE [pvDB].[pv_organizationDocuments]  WITH CHECK ADD  CONSTRAINT [pv_organizationDocuments$fk_pv_organizationDocuments_pv_documents1] FOREIGN KEY([documentID])
REFERENCES [pvDB].[pv_documents] ([documentID])
GO
ALTER TABLE [pvDB].[pv_organizationDocuments] CHECK CONSTRAINT [pv_organizationDocuments$fk_pv_organizationDocuments_pv_documents1]
GO
ALTER TABLE [pvDB].[pv_organizationDocuments]  WITH CHECK ADD  CONSTRAINT [pv_organizationDocuments$fk_pv_organizationDocuments_pv_organizations1] FOREIGN KEY([organizationID])
REFERENCES [pvDB].[pv_organizations] ([organizationID])
GO
ALTER TABLE [pvDB].[pv_organizationDocuments] CHECK CONSTRAINT [pv_organizationDocuments$fk_pv_organizationDocuments_pv_organizations1]
GO
ALTER TABLE [pvDB].[pv_organizationProposals]  WITH CHECK ADD  CONSTRAINT [pv_organizationProposals$fk_pv_organizationProposals_pv_organizations1] FOREIGN KEY([organizationID])
REFERENCES [pvDB].[pv_organizations] ([organizationID])
GO
ALTER TABLE [pvDB].[pv_organizationProposals] CHECK CONSTRAINT [pv_organizationProposals$fk_pv_organizationProposals_pv_organizations1]
GO
ALTER TABLE [pvDB].[pv_organizationProposals]  WITH CHECK ADD  CONSTRAINT [pv_organizationProposals$fk_pv_organizationProposals_pv_proposals1] FOREIGN KEY([proposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_organizationProposals] CHECK CONSTRAINT [pv_organizationProposals$fk_pv_organizationProposals_pv_proposals1]
GO
ALTER TABLE [pvDB].[pv_organizations]  WITH CHECK ADD  CONSTRAINT [pv_organizations$fk_pv_organizations_pv_organization_type1] FOREIGN KEY([organizationTypeId])
REFERENCES [pvDB].[pv_organizationTypes] ([organizationTypeID])
GO
ALTER TABLE [pvDB].[pv_organizations] CHECK CONSTRAINT [pv_organizations$fk_pv_organizations_pv_organization_type1]
GO
ALTER TABLE [pvDB].[pv_organizations]  WITH CHECK ADD  CONSTRAINT [pv_organizations$fk_pv_organizations_pv_organizationStatuses1] FOREIGN KEY([statusID])
REFERENCES [pvDB].[pv_organizationStatuses] ([statusID])
GO
ALTER TABLE [pvDB].[pv_organizations] CHECK CONSTRAINT [pv_organizations$fk_pv_organizations_pv_organizationStatuses1]
GO
ALTER TABLE [pvDB].[pv_organizations]  WITH CHECK ADD  CONSTRAINT [pv_organizations$fk_pv_organizations_pv_users1] FOREIGN KEY([userId])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_organizations] CHECK CONSTRAINT [pv_organizations$fk_pv_organizations_pv_users1]
GO
ALTER TABLE [pvDB].[pv_organizationsContactInfo]  WITH CHECK ADD  CONSTRAINT [pv_organizationsContactInfo$fk_pv_organizationsContactInfo_pv_contactInfo1] FOREIGN KEY([contactInfoID])
REFERENCES [pvDB].[pv_contactInfo] ([contactInfoID])
GO
ALTER TABLE [pvDB].[pv_organizationsContactInfo] CHECK CONSTRAINT [pv_organizationsContactInfo$fk_pv_organizationsContactInfo_pv_contactInfo1]
GO
ALTER TABLE [pvDB].[pv_organizationsContactInfo]  WITH CHECK ADD  CONSTRAINT [pv_organizationsContactInfo$fk_pv_organizationsContactInfo_pv_organizations1] FOREIGN KEY([organizationID])
REFERENCES [pvDB].[pv_organizations] ([organizationID])
GO
ALTER TABLE [pvDB].[pv_organizationsContactInfo] CHECK CONSTRAINT [pv_organizationsContactInfo$fk_pv_organizationsContactInfo_pv_organizations1]
GO
ALTER TABLE [pvDB].[pv_payments]  WITH CHECK ADD  CONSTRAINT [pv_payments$fk_pay_payments_pay_available_pay_methods1] FOREIGN KEY([availableMethodID])
REFERENCES [pvDB].[pv_availablePayMethods] ([available_method_id])
GO
ALTER TABLE [pvDB].[pv_payments] CHECK CONSTRAINT [pv_payments$fk_pay_payments_pay_available_pay_methods1]
GO
ALTER TABLE [pvDB].[pv_payments]  WITH CHECK ADD  CONSTRAINT [pv_payments$fk_pay_payments_pay_currency1] FOREIGN KEY([currencyID])
REFERENCES [pvDB].[pv_currencies] ([currencyID])
GO
ALTER TABLE [pvDB].[pv_payments] CHECK CONSTRAINT [pv_payments$fk_pay_payments_pay_currency1]
GO
ALTER TABLE [pvDB].[pv_payments]  WITH CHECK ADD  CONSTRAINT [pv_payments$fk_pay_pays_pay_pay_method1] FOREIGN KEY([methodID])
REFERENCES [pvDB].[pv_payMethod] ([payMethodID])
GO
ALTER TABLE [pvDB].[pv_payments] CHECK CONSTRAINT [pv_payments$fk_pay_pays_pay_pay_method1]
GO
ALTER TABLE [pvDB].[pv_permissions]  WITH CHECK ADD  CONSTRAINT [pv_permissions$fk_pay_permissions_pay_modules1] FOREIGN KEY([moduleID])
REFERENCES [pvDB].[pv_modules] ([moduleID])
GO
ALTER TABLE [pvDB].[pv_permissions] CHECK CONSTRAINT [pv_permissions$fk_pay_permissions_pay_modules1]
GO
ALTER TABLE [pvDB].[pv_proposalBenefits]  WITH CHECK ADD  CONSTRAINT [pv_proposalBenefits$fk_pv_proposalBenefits_pv_proposals1] FOREIGN KEY([proposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_proposalBenefits] CHECK CONSTRAINT [pv_proposalBenefits$fk_pv_proposalBenefits_pv_proposals1]
GO
ALTER TABLE [pvDB].[pv_proposalDemographics]  WITH CHECK ADD  CONSTRAINT [pv_proposalDemographics$fk_pv_proposalDemographics_pv_proposals1] FOREIGN KEY([proposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_proposalDemographics] CHECK CONSTRAINT [pv_proposalDemographics$fk_pv_proposalDemographics_pv_proposals1]
GO
ALTER TABLE [pvDB].[pv_proposalDemographics]  WITH CHECK ADD  CONSTRAINT [pv_proposalDemographics$fk_pv_proposalDemographics_pv_targetDemographics1] FOREIGN KEY([targetDemographicID])
REFERENCES [pvDB].[pv_targetDemographics] ([targetDemographicID])
GO
ALTER TABLE [pvDB].[pv_proposalDemographics] CHECK CONSTRAINT [pv_proposalDemographics$fk_pv_proposalDemographics_pv_targetDemographics1]
GO
ALTER TABLE [pvDB].[pv_proposalDocuments]  WITH CHECK ADD  CONSTRAINT [pv_proposalDocuments$fk_pv_proposalDocuments_pv_documents1] FOREIGN KEY([documentID])
REFERENCES [pvDB].[pv_documents] ([documentID])
GO
ALTER TABLE [pvDB].[pv_proposalDocuments] CHECK CONSTRAINT [pv_proposalDocuments$fk_pv_proposalDocuments_pv_documents1]
GO
ALTER TABLE [pvDB].[pv_proposalDocuments]  WITH CHECK ADD  CONSTRAINT [pv_proposalDocuments$fk_pv_proposalDocuments_pv_proposals1] FOREIGN KEY([proposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_proposalDocuments] CHECK CONSTRAINT [pv_proposalDocuments$fk_pv_proposalDocuments_pv_proposals1]
GO
ALTER TABLE [pvDB].[pv_proposalImpacts]  WITH CHECK ADD  CONSTRAINT [pv_proposalImpacts$fk_pv_proposalImpacts_pv_impactedEntityTypes1] FOREIGN KEY([impactedEntityTypeID])
REFERENCES [pvDB].[pv_impactedEntityTypes] ([impactedEntityTypeID])
GO
ALTER TABLE [pvDB].[pv_proposalImpacts] CHECK CONSTRAINT [pv_proposalImpacts$fk_pv_proposalImpacts_pv_impactedEntityTypes1]
GO
ALTER TABLE [pvDB].[pv_proposalImpacts]  WITH CHECK ADD  CONSTRAINT [pv_proposalImpacts$fk_pv_proposalImpacts_pv_proposals1] FOREIGN KEY([proposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_proposalImpacts] CHECK CONSTRAINT [pv_proposalImpacts$fk_pv_proposalImpacts_pv_proposals1]
GO
ALTER TABLE [pvDB].[pv_proposalRecords]  WITH CHECK ADD  CONSTRAINT [pv_proposalRecords$fk_pv_proposalRecords_pv_proposals1] FOREIGN KEY([lastProposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_proposalRecords] CHECK CONSTRAINT [pv_proposalRecords$fk_pv_proposalRecords_pv_proposals1]
GO
ALTER TABLE [pvDB].[pv_proposalRecords]  WITH CHECK ADD  CONSTRAINT [pv_proposalRecords$fk_pv_proposalRecords_pv_proposals2] FOREIGN KEY([currentProposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_proposalRecords] CHECK CONSTRAINT [pv_proposalRecords$fk_pv_proposalRecords_pv_proposals2]
GO
ALTER TABLE [pvDB].[pv_proposals]  WITH CHECK ADD  CONSTRAINT [pv_proposals$FK_Propuesta_Tipo] FOREIGN KEY([proposalTypeID])
REFERENCES [pvDB].[pv_proposalTypes] ([proposalTypeID])
GO
ALTER TABLE [pvDB].[pv_proposals] CHECK CONSTRAINT [pv_proposals$FK_Propuesta_Tipo]
GO
ALTER TABLE [pvDB].[pv_proposals]  WITH CHECK ADD  CONSTRAINT [pv_proposals$fk_pv_proposals_pv_proposalStatuses1] FOREIGN KEY([proposalStatusID])
REFERENCES [pvDB].[pv_proposalStatus] ([proposalStatusID])
GO
ALTER TABLE [pvDB].[pv_proposals] CHECK CONSTRAINT [pv_proposals$fk_pv_proposals_pv_proposalStatuses1]
GO
ALTER TABLE [pvDB].[pv_requestResults]  WITH CHECK ADD  CONSTRAINT [pv_requestResults$fk_pv_requestResults_pv_requests1] FOREIGN KEY([requestID])
REFERENCES [pvDB].[pv_requests] ([requestID])
GO
ALTER TABLE [pvDB].[pv_requestResults] CHECK CONSTRAINT [pv_requestResults$fk_pv_requestResults_pv_requests1]
GO
ALTER TABLE [pvDB].[pv_requests]  WITH CHECK ADD  CONSTRAINT [pv_requests$fk_pv_requests_pv_workflows1] FOREIGN KEY([workflowID])
REFERENCES [pvDB].[pv_workflows] ([workflowID])
GO
ALTER TABLE [pvDB].[pv_requests] CHECK CONSTRAINT [pv_requests$fk_pv_requests_pv_workflows1]
GO
ALTER TABLE [pvDB].[pv_requiredDocuments]  WITH CHECK ADD  CONSTRAINT [pv_requiredDocuments$fk_pv_requiredDocuments_pv_entityType1] FOREIGN KEY([entityTypeID])
REFERENCES [pvDB].[pv_entityType] ([entityTypeID])
GO
ALTER TABLE [pvDB].[pv_requiredDocuments] CHECK CONSTRAINT [pv_requiredDocuments$fk_pv_requiredDocuments_pv_entityType1]
GO
ALTER TABLE [pvDB].[pv_requiredDocuments]  WITH CHECK ADD  CONSTRAINT [pv_requiredDocuments$fk_pv_requiredProposalDocuments_pv_documentTypes1] FOREIGN KEY([documentTypeID])
REFERENCES [pvDB].[pv_documentTypes] ([documentTypeID])
GO
ALTER TABLE [pvDB].[pv_requiredDocuments] CHECK CONSTRAINT [pv_requiredDocuments$fk_pv_requiredProposalDocuments_pv_documentTypes1]
GO
ALTER TABLE [pvDB].[pv_rolePermissions]  WITH CHECK ADD  CONSTRAINT [pv_rolePermissions$fk_pay_role_permissions_pay_permissions1] FOREIGN KEY([permissionID])
REFERENCES [pvDB].[pv_permissions] ([permissionID])
GO
ALTER TABLE [pvDB].[pv_rolePermissions] CHECK CONSTRAINT [pv_rolePermissions$fk_pay_role_permissions_pay_permissions1]
GO
ALTER TABLE [pvDB].[pv_rolePermissions]  WITH CHECK ADD  CONSTRAINT [pv_rolePermissions$fk_pay_role_permissions_pay_roles1] FOREIGN KEY([roleID])
REFERENCES [pvDB].[pv_roles] ([roleID])
GO
ALTER TABLE [pvDB].[pv_rolePermissions] CHECK CONSTRAINT [pv_rolePermissions$fk_pay_role_permissions_pay_roles1]
GO
ALTER TABLE [pvDB].[pv_schedulesDetails]  WITH CHECK ADD  CONSTRAINT [pv_schedulesDetails$fk_pay_schedules_details_pay_schedules1] FOREIGN KEY([schedule_id])
REFERENCES [pvDB].[pv_schedules] ([scheduleID])
GO
ALTER TABLE [pvDB].[pv_schedulesDetails] CHECK CONSTRAINT [pv_schedulesDetails$fk_pay_schedules_details_pay_schedules1]
GO
ALTER TABLE [pvDB].[pv_states]  WITH CHECK ADD  CONSTRAINT [pv_states$fk_pay_states_pay_countries1] FOREIGN KEY([countryID])
REFERENCES [pvDB].[pv_countries] ([countryID])
GO
ALTER TABLE [pvDB].[pv_states] CHECK CONSTRAINT [pv_states$fk_pay_states_pay_countries1]
GO
ALTER TABLE [pvDB].[pv_targetDemographics]  WITH CHECK ADD  CONSTRAINT [pv_targetDemographics$fk_pv_targetDemographics_pv_demographicType1] FOREIGN KEY([demographicTypeID])
REFERENCES [pvDB].[pv_demographicTypes] ([demographicTypeID])
GO
ALTER TABLE [pvDB].[pv_targetDemographics] CHECK CONSTRAINT [pv_targetDemographics$fk_pv_targetDemographics_pv_demographicType1]
GO
ALTER TABLE [pvDB].[pv_targetDemographics]  WITH CHECK ADD  CONSTRAINT [pv_targetDemographics$fk_pv_targetDemographics_pv_targetTypes1] FOREIGN KEY([targetTypeID])
REFERENCES [pvDB].[pv_targetTypes] ([targetTypeID])
GO
ALTER TABLE [pvDB].[pv_targetDemographics] CHECK CONSTRAINT [pv_targetDemographics$fk_pv_targetDemographics_pv_targetTypes1]
GO
ALTER TABLE [pvDB].[pv_targetOrganizations]  WITH CHECK ADD  CONSTRAINT [pv_targetOrganizations$fk_pv_targetOrganizations_pv_votes1] FOREIGN KEY([voteID])
REFERENCES [pvDB].[pv_votes] ([voteID])
GO
ALTER TABLE [pvDB].[pv_targetOrganizations] CHECK CONSTRAINT [pv_targetOrganizations$fk_pv_targetOrganizations_pv_votes1]
GO
ALTER TABLE [pvDB].[pv_targetOrganizations]  WITH CHECK ADD  CONSTRAINT [pv_targetOrganizations$fk_pv_voteTargetOrganizations_pv_organizations1] FOREIGN KEY([organizationID])
REFERENCES [pvDB].[pv_organizations] ([organizationID])
GO
ALTER TABLE [pvDB].[pv_targetOrganizations] CHECK CONSTRAINT [pv_targetOrganizations$fk_pv_voteTargetOrganizations_pv_organizations1]
GO
ALTER TABLE [pvDB].[pv_tempConfirmations]  WITH CHECK ADD  CONSTRAINT [pv_tempConfirmations$fk_pv_tempConfirmations_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_tempConfirmations] CHECK CONSTRAINT [pv_tempConfirmations$fk_pv_tempConfirmations_pv_users1]
GO
ALTER TABLE [pvDB].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [pv_transactions$fk_pay_transactions_pay_pays1] FOREIGN KEY([payment_id])
REFERENCES [pvDB].[pv_payments] ([paymentID])
GO
ALTER TABLE [pvDB].[pv_transactions] CHECK CONSTRAINT [pv_transactions$fk_pay_transactions_pay_pays1]
GO
ALTER TABLE [pvDB].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [pv_transactions$fk_pay_transactions_pay_transaction_subtypes1] FOREIGN KEY([transactionSubtypesID])
REFERENCES [pvDB].[pv_transactionSubtypes] ([transactionSubtypeID])
GO
ALTER TABLE [pvDB].[pv_transactions] CHECK CONSTRAINT [pv_transactions$fk_pay_transactions_pay_transaction_subtypes1]
GO
ALTER TABLE [pvDB].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [pv_transactions$fk_pay_transactions_pay_transaction_types1] FOREIGN KEY([transactionTypesID])
REFERENCES [pvDB].[pv_transactionTypes] ([transactionTypeID])
GO
ALTER TABLE [pvDB].[pv_transactions] CHECK CONSTRAINT [pv_transactions$fk_pay_transactions_pay_transaction_types1]
GO
ALTER TABLE [pvDB].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [pv_transactions$fk_pv_transactions_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_transactions] CHECK CONSTRAINT [pv_transactions$fk_pv_transactions_pv_users1]
GO
ALTER TABLE [pvDB].[pv_transactions]  WITH CHECK ADD  CONSTRAINT [pv_transactions$fk_sol_transactions_sol_exchangeCurrencies1] FOREIGN KEY([exchangeCurrencyID])
REFERENCES [pvDB].[pv_exchangeCurrencies] ([exchangeCurrencyID])
GO
ALTER TABLE [pvDB].[pv_transactions] CHECK CONSTRAINT [pv_transactions$fk_sol_transactions_sol_exchangeCurrencies1]
GO
ALTER TABLE [pvDB].[pv_translations]  WITH CHECK ADD  CONSTRAINT [pv_translations$fk_pay_translations_pay_languages1] FOREIGN KEY([languageID])
REFERENCES [pvDB].[pv_languages] ([languageID])
GO
ALTER TABLE [pvDB].[pv_translations] CHECK CONSTRAINT [pv_translations$fk_pay_translations_pay_languages1]
GO
ALTER TABLE [pvDB].[pv_translations]  WITH CHECK ADD  CONSTRAINT [pv_translations$fk_pay_translations_pay_modules1] FOREIGN KEY([moduleID])
REFERENCES [pvDB].[pv_modules] ([moduleID])
GO
ALTER TABLE [pvDB].[pv_translations] CHECK CONSTRAINT [pv_translations$fk_pay_translations_pay_modules1]
GO
ALTER TABLE [pvDB].[pv_userAddresses]  WITH CHECK ADD  CONSTRAINT [pv_userAddresses$fk_pay_users_adresses_pay_addresses1] FOREIGN KEY([addressID])
REFERENCES [pvDB].[pv_addresses] ([addressID])
GO
ALTER TABLE [pvDB].[pv_userAddresses] CHECK CONSTRAINT [pv_userAddresses$fk_pay_users_adresses_pay_addresses1]
GO
ALTER TABLE [pvDB].[pv_userAddresses]  WITH CHECK ADD  CONSTRAINT [pv_userAddresses$fk_pv_userAddresses_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_userAddresses] CHECK CONSTRAINT [pv_userAddresses$fk_pv_userAddresses_pv_users1]
GO
ALTER TABLE [pvDB].[pv_userDemographics]  WITH CHECK ADD  CONSTRAINT [pv_userDemographics$fk_pv_userDemographics_pv_demographicType1] FOREIGN KEY([demographicTypeID])
REFERENCES [pvDB].[pv_demographicTypes] ([demographicTypeID])
GO
ALTER TABLE [pvDB].[pv_userDemographics] CHECK CONSTRAINT [pv_userDemographics$fk_pv_userDemographics_pv_demographicType1]
GO
ALTER TABLE [pvDB].[pv_userDemographics]  WITH CHECK ADD  CONSTRAINT [pv_userDemographics$fk_pv_userDemographics_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_userDemographics] CHECK CONSTRAINT [pv_userDemographics$fk_pv_userDemographics_pv_users1]
GO
ALTER TABLE [pvDB].[pv_userDocuments]  WITH CHECK ADD  CONSTRAINT [pv_userDocuments$fk_pv_userDocuments_pv_documents1] FOREIGN KEY([documentID])
REFERENCES [pvDB].[pv_documents] ([documentID])
GO
ALTER TABLE [pvDB].[pv_userDocuments] CHECK CONSTRAINT [pv_userDocuments$fk_pv_userDocuments_pv_documents1]
GO
ALTER TABLE [pvDB].[pv_userDocuments]  WITH CHECK ADD  CONSTRAINT [pv_userDocuments$fk_pv_userDocuments_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_userDocuments] CHECK CONSTRAINT [pv_userDocuments$fk_pv_userDocuments_pv_users1]
GO
ALTER TABLE [pvDB].[pv_userPermissions]  WITH CHECK ADD  CONSTRAINT [pv_userPermissions$fk_pay_role_permissions_pay_permissions10] FOREIGN KEY([permissionID])
REFERENCES [pvDB].[pv_permissions] ([permissionID])
GO
ALTER TABLE [pvDB].[pv_userPermissions] CHECK CONSTRAINT [pv_userPermissions$fk_pay_role_permissions_pay_permissions10]
GO
ALTER TABLE [pvDB].[pv_userPermissions]  WITH CHECK ADD  CONSTRAINT [pv_userPermissions$fk_pv_userPermissions_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_userPermissions] CHECK CONSTRAINT [pv_userPermissions$fk_pv_userPermissions_pv_users1]
GO
ALTER TABLE [pvDB].[pv_userProfiles]  WITH CHECK ADD  CONSTRAINT [pv_userProfiles$fk_pv_userProfiles_pv_educationLevels1] FOREIGN KEY([educationLevelID])
REFERENCES [pvDB].[pv_educationLevels] ([educationLevelID])
GO
ALTER TABLE [pvDB].[pv_userProfiles] CHECK CONSTRAINT [pv_userProfiles$fk_pv_userProfiles_pv_educationLevels1]
GO
ALTER TABLE [pvDB].[pv_userProfiles]  WITH CHECK ADD  CONSTRAINT [pv_userProfiles$fk_pv_userProfiles_pv_userIdTypes1] FOREIGN KEY([userIdTypeID])
REFERENCES [pvDB].[pv_userIdTypes] ([userIdTypeID])
GO
ALTER TABLE [pvDB].[pv_userProfiles] CHECK CONSTRAINT [pv_userProfiles$fk_pv_userProfiles_pv_userIdTypes1]
GO
ALTER TABLE [pvDB].[pv_userProfiles]  WITH CHECK ADD  CONSTRAINT [pv_userProfiles$fk_pv_userProfiles_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_userProfiles] CHECK CONSTRAINT [pv_userProfiles$fk_pv_userProfiles_pv_users1]
GO
ALTER TABLE [pvDB].[pv_UserProposals]  WITH CHECK ADD  CONSTRAINT [pv_UserProposals$fk_pv_UserProposals_pv_proposals1] FOREIGN KEY([proposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_UserProposals] CHECK CONSTRAINT [pv_UserProposals$fk_pv_UserProposals_pv_proposals1]
GO
ALTER TABLE [pvDB].[pv_UserProposals]  WITH CHECK ADD  CONSTRAINT [pv_UserProposals$fk_pv_UserProposals_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_UserProposals] CHECK CONSTRAINT [pv_UserProposals$fk_pv_UserProposals_pv_users1]
GO
ALTER TABLE [pvDB].[pv_userRoles]  WITH CHECK ADD  CONSTRAINT [pv_userRoles$fk_pay_users_has_pay_roles_pay_roles1] FOREIGN KEY([roleID])
REFERENCES [pvDB].[pv_roles] ([roleID])
GO
ALTER TABLE [pvDB].[pv_userRoles] CHECK CONSTRAINT [pv_userRoles$fk_pay_users_has_pay_roles_pay_roles1]
GO
ALTER TABLE [pvDB].[pv_userRoles]  WITH CHECK ADD  CONSTRAINT [pv_userRoles$fk_pv_userRoles_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_userRoles] CHECK CONSTRAINT [pv_userRoles$fk_pv_userRoles_pv_users1]
GO
ALTER TABLE [pvDB].[pv_users]  WITH CHECK ADD  CONSTRAINT [pv_users$fk_pv_users_pv_userStatuses1] FOREIGN KEY([statusID])
REFERENCES [pvDB].[pv_userStatuses] ([statusID])
GO
ALTER TABLE [pvDB].[pv_users] CHECK CONSTRAINT [pv_users$fk_pv_users_pv_userStatuses1]
GO
ALTER TABLE [pvDB].[pv_usersContactInfo]  WITH CHECK ADD  CONSTRAINT [pv_usersContactInfo$fk_pv_usersContactInfo_pv_contactInfo1] FOREIGN KEY([contactInfoID])
REFERENCES [pvDB].[pv_contactInfo] ([contactInfoID])
GO
ALTER TABLE [pvDB].[pv_usersContactInfo] CHECK CONSTRAINT [pv_usersContactInfo$fk_pv_usersContactInfo_pv_contactInfo1]
GO
ALTER TABLE [pvDB].[pv_usersContactInfo]  WITH CHECK ADD  CONSTRAINT [pv_usersContactInfo$fk_pv_usersContactInfo_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_usersContactInfo] CHECK CONSTRAINT [pv_usersContactInfo$fk_pv_usersContactInfo_pv_users1]
GO
ALTER TABLE [pvDB].[pv_userSessions]  WITH CHECK ADD  CONSTRAINT [pv_userSessions$fk_pv_MFAs_pv_users1] FOREIGN KEY([userID])
REFERENCES [pvDB].[pv_users] ([userID])
GO
ALTER TABLE [pvDB].[pv_userSessions] CHECK CONSTRAINT [pv_userSessions$fk_pv_MFAs_pv_users1]
GO
ALTER TABLE [pvDB].[pv_voteDemographics]  WITH CHECK ADD  CONSTRAINT [pv_voteDemographics$fk_pv_voteDemographics_pv_targetDemographics2] FOREIGN KEY([targetDemographicID])
REFERENCES [pvDB].[pv_targetDemographics] ([targetDemographicID])
GO
ALTER TABLE [pvDB].[pv_voteDemographics] CHECK CONSTRAINT [pv_voteDemographics$fk_pv_voteDemographics_pv_targetDemographics2]
GO
ALTER TABLE [pvDB].[pv_voteDemographics]  WITH CHECK ADD  CONSTRAINT [pv_voteDemographics$fk_pv_voteDemographics_pv_votes1] FOREIGN KEY([voteID])
REFERENCES [pvDB].[pv_votes] ([voteID])
GO
ALTER TABLE [pvDB].[pv_voteDemographics] CHECK CONSTRAINT [pv_voteDemographics$fk_pv_voteDemographics_pv_votes1]
GO
ALTER TABLE [pvDB].[pv_voteOptions]  WITH CHECK ADD  CONSTRAINT [pv_voteOptions$fk_pv_voteOptions_pv_voteQuestions1] FOREIGN KEY([voteQuestionID])
REFERENCES [pvDB].[pv_voteQuestions] ([voteQuestionID])
GO
ALTER TABLE [pvDB].[pv_voteOptions] CHECK CONSTRAINT [pv_voteOptions$fk_pv_voteOptions_pv_voteQuestions1]
GO
ALTER TABLE [pvDB].[pv_voteQuestions]  WITH CHECK ADD  CONSTRAINT [pv_voteQuestions$fk_pv_voteQuestions_pv_votes1] FOREIGN KEY([voteID])
REFERENCES [pvDB].[pv_votes] ([voteID])
GO
ALTER TABLE [pvDB].[pv_voteQuestions] CHECK CONSTRAINT [pv_voteQuestions$fk_pv_voteQuestions_pv_votes1]
GO
ALTER TABLE [pvDB].[pv_voteResults]  WITH CHECK ADD  CONSTRAINT [pv_voteResults$FK_Results_Opcion] FOREIGN KEY([optionVoteID])
REFERENCES [pvDB].[pv_voteOptions] ([voteOptionID])
GO
ALTER TABLE [pvDB].[pv_voteResults] CHECK CONSTRAINT [pv_voteResults$FK_Results_Opcion]
GO
ALTER TABLE [pvDB].[pv_votes]  WITH CHECK ADD  CONSTRAINT [pv_votes$fk_pv_votes_pv_approvalCriteriaTypes1] FOREIGN KEY([approvalTypeID])
REFERENCES [pvDB].[pv_approvalCriteriaTypes] ([approvalTypeID])
GO
ALTER TABLE [pvDB].[pv_votes] CHECK CONSTRAINT [pv_votes$fk_pv_votes_pv_approvalCriteriaTypes1]
GO
ALTER TABLE [pvDB].[pv_votes]  WITH CHECK ADD  CONSTRAINT [pv_votes$fk_pv_votes_pv_proposals1] FOREIGN KEY([proposalID])
REFERENCES [pvDB].[pv_proposals] ([proposalID])
GO
ALTER TABLE [pvDB].[pv_votes] CHECK CONSTRAINT [pv_votes$fk_pv_votes_pv_proposals1]
GO
ALTER TABLE [pvDB].[pv_votes]  WITH CHECK ADD  CONSTRAINT [pv_votes$fk_pv_votes_pv_voteStatus1] FOREIGN KEY([voteStatusID])
REFERENCES [pvDB].[pv_voteStatus] ([voteStatusID])
GO
ALTER TABLE [pvDB].[pv_votes] CHECK CONSTRAINT [pv_votes$fk_pv_votes_pv_voteStatus1]
GO
ALTER TABLE [pvDB].[pv_votes]  WITH CHECK ADD  CONSTRAINT [pv_votes$fk_pv_votes_pv_voteTypes1] FOREIGN KEY([voteTypeID])
REFERENCES [pvDB].[pv_voteTypes] ([voteTypeID])
GO
ALTER TABLE [pvDB].[pv_votes] CHECK CONSTRAINT [pv_votes$fk_pv_votes_pv_voteTypes1]
GO
ALTER TABLE [pvDB].[pv_workflowHeaders]  WITH CHECK ADD  CONSTRAINT [pv_workflowHeaders$fk_pv_workflowHeaders_pv_workflows1] FOREIGN KEY([workflowID])
REFERENCES [pvDB].[pv_workflows] ([workflowID])
GO
ALTER TABLE [pvDB].[pv_workflowHeaders] CHECK CONSTRAINT [pv_workflowHeaders$fk_pv_workflowHeaders_pv_workflows1]
GO
ALTER TABLE [pvDB].[pv_workflowParameters]  WITH CHECK ADD  CONSTRAINT [pv_workflowParameters$fk_pv_workflowParameters_pv_workflows1] FOREIGN KEY([workflowID])
REFERENCES [pvDB].[pv_workflows] ([workflowID])
GO
ALTER TABLE [pvDB].[pv_workflowParameters] CHECK CONSTRAINT [pv_workflowParameters$fk_pv_workflowParameters_pv_workflows1]
GO
ALTER TABLE [pvDB].[pv_workflows]  WITH CHECK ADD  CONSTRAINT [pv_workflows$fk_pv_workflows_pv_workflowTypes1] FOREIGN KEY([workflowTypeID])
REFERENCES [pvDB].[pv_workflowTypes] ([workflowTypeID])
GO
ALTER TABLE [pvDB].[pv_workflows] CHECK CONSTRAINT [pv_workflows$fk_pv_workflows_pv_workflowTypes1]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.cf_crowfundingEvents' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'cf_crowfundingEvents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.cf_financialReports' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'cf_financialReports'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.cf_financialResults' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'cf_financialResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.cf_fundingProgresses' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'cf_fundingProgresses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.cf_investments' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'cf_investments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.cf_payouts' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'cf_payouts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_addresses' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_addresses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_approvalCriteriaTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_approvalCriteriaTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_availablePayMethods' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_availablePayMethods'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_biometricData' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_biometricData'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_biometricDevices' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_biometricDevices'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_biometricFiles' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_biometricFiles'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_biometricResults' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_biometricResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_biometricTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_biometricTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_cities' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_cities'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_commentDocuments' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_commentDocuments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_comments' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_comments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_commentStatus' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_commentStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_communicationChannels' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_communicationChannels'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_conditions' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_conditions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_conditionTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_conditionTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_confirmedVoteDemographics' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_confirmedVoteDemographics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_confirmedVotes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_confirmedVotes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_contactDepartments' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_contactDepartments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_contactInfo' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_contactInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_contactTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_contactTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_countries' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_countries'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_countryWhitelists' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_countryWhitelists'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_crowfundingStatuses' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_crowfundingStatuses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_currencies' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_currencies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_deliverables' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_deliverables'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_demographicTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_demographicTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_documents' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_documents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_documentStatus' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_documentStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_documentTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_documentTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_documentTypeWorkflows' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_documentTypeWorkflows'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_educationLevels' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_educationLevels'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_encryptionKeyMetadata' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_encryptionKeyMetadata'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_entityType' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_entityType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_exchangeCurrencies' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_exchangeCurrencies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_executionPlans' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_executionPlans'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_impactDemographics' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_impactDemographics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_impactedEntityTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_impactedEntityTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_jobPositions' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_jobPositions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_keyTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_keyTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_KPITypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_KPITypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_languages' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_languages'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_logs' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_logs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_logSources' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_logSources'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_logsSererity' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_logsSererity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_logTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_logTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_mediaFile' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_mediaFile'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_mediaTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_mediaTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_milestones' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_milestones'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_modules' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_modules'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_nationalities' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_nationalities'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_notificationConfigurations' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_notificationConfigurations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_notifications' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_notifications'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_notificationStatus' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_notificationStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_notificationTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_notificationTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_organization_type_has_pv_documentType' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_organization_type_has_pv_documentType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_organizationAdresses' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_organizationAdresses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_organizationAffiliates' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_organizationAffiliates'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_organizationDocuments' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_organizationDocuments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_organizationProposals' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_organizationProposals'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_organizations' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_organizations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_organizationsContactInfo' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_organizationsContactInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_organizationStatuses' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_organizationStatuses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_organizationTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_organizationTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_owningEntityTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_owningEntityTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_payments' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_payments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_paymentStatuses' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_paymentStatuses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_payMethod' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_payMethod'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_permissions' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_permissions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_proposalBenefits' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_proposalBenefits'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_proposalDemographics' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_proposalDemographics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_proposalDocuments' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_proposalDocuments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_proposalImpacts' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_proposalImpacts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_proposalRecords' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_proposalRecords'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_proposals' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_proposals'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_proposalStatus' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_proposalStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_proposalTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_proposalTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_requestResults' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_requestResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_requests' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_requests'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_requiredDocuments' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_requiredDocuments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_rolePermissions' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_rolePermissions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_roles' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_roles'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_schedules' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_schedules'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_schedulesDetails' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_schedulesDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_states' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_states'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_targetDemographics' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_targetDemographics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_targetOrganizations' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_targetOrganizations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_targetTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_targetTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_tempConfirmations' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_tempConfirmations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_timeUnits' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_timeUnits'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_tokens' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_tokens'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_transactions' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_transactions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_transactionSubtypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_transactionSubtypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_transactionTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_transactionTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_translations' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_translations'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_unitTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_unitTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_userAddresses' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_userAddresses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_userDemographics' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_userDemographics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_userDocuments' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_userDocuments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_userIdTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_userIdTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_userPermissions' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_userPermissions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_userProfiles' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_userProfiles'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_UserProposals' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_UserProposals'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_userRoles' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_userRoles'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_users' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_users'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_usersContactInfo' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_usersContactInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_userSessions' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_userSessions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_userStatuses' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_userStatuses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_voteDemographics' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_voteDemographics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_voteOptions' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_voteOptions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_voteQuestions' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_voteQuestions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_voteResults' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_voteResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_votes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_votes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_voteStatus' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_voteStatus'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_voteTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_voteTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_workflowHeaders' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_workflowHeaders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_workflowParameters' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_workflowParameters'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_workflows' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_workflows'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.pv_workflowTypes' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'pv_workflowTypes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_SSMA_SOURCE', @value=N'pvDB.reportStatuses' , @level0type=N'SCHEMA',@level0name=N'pvDB', @level1type=N'TABLE',@level1name=N'reportStatuses'
GO
