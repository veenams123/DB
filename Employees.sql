USE [Employees]
GO
/****** Object:  Table [dbo].[Departments]    Script Date: 26/02/2024 10:13:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeMaster]    Script Date: 26/02/2024 10:13:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeMaster](
	[EmployeeId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[DOB] [datetime] NULL,
	[DepartmentId] [tinyint] NULL,
	[Active] [bit] NULL,
	[CreatedDate] [datetime2](7) NULL,
 CONSTRAINT [PK_EmployeeMaster] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeMaster] ADD  CONSTRAINT [DF_EmployeeMaster_Active]  DEFAULT ((1)) FOR [Active]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 26/02/2024 10:13:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetEmployees] 
@Name varchar(50) = NULL,
@PageNumber tinyint,
@PageSize tinyint

AS
BEGIN

	
SELECT [EmployeeId]
      ,[FirstName]
      ,[LastName]	  
      ,[Email]
      ,[DOB]      
	  ,Departments.[Name] DepartmentName
  FROM [dbo].[EmployeeMaster] 
  LEFT JOIN
  [dbo].[Departments] ON EmployeeMaster.DepartmentId = Departments.DepartmentId
  where (@Name is  null or([FirstName] = @Name))
  order by EmployeeId
  OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
 
END
GO
/****** Object:  StoredProcedure [dbo].[InsertEmployeeData]    Script Date: 26/02/2024 10:13:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertEmployeeData] 
@FirstName varchar(50),
@LastName varchar(50),
@Email varchar(100),
@DOB datetime,
@DepartmentId tinyint
AS
BEGIN
INSERT INTO [dbo].[EmployeeMaster]
           (FirstName
           ,[LastName]
           ,[Email]
           ,[DOB]
           ,[DepartmentId]
		   ,[CreatedDate]
           )
     VALUES
           (
		   @FirstName,
@LastName,
@Email ,
@DOB ,
@DepartmentId,
GETDATE()
)
END
GO
