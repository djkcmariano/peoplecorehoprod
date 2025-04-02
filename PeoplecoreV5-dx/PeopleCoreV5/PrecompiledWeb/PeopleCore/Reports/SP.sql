
GO

/****** Object:  StoredProcedure [dbo].[EPerformance_RptTemplate]    Script Date: 1/20/2014 5:19:16 PM ******/
DROP PROCEDURE [dbo].[EPerformance_RptTemplate]
GO

/****** Object:  StoredProcedure [dbo].[EPEReview_WebSelf]    Script Date: 1/20/2014 5:19:16 PM ******/
DROP PROCEDURE [dbo].[EPEReview_WebSelf]
GO

/****** Object:  StoredProcedure [dbo].[EPEReview_WebValidate]    Script Date: 1/20/2014 5:19:16 PM ******/
DROP PROCEDURE [dbo].[EPEReview_WebValidate]
GO

/****** Object:  StoredProcedure [dbo].[EPEReviewMain_Web]    Script Date: 1/20/2014 5:19:16 PM ******/
DROP PROCEDURE [dbo].[EPEReviewMain_Web]
GO

/****** Object:  StoredProcedure [dbo].[EPEReviewMain_Web]    Script Date: 1/20/2014 5:19:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [dbo].[EPEReviewMain_Web]
	@onlineuserno INT,
	@applicableyear VARCHAR(100),
	@IsPosted BIT,
	@PayLocNo SMALLINT	
AS


IF ISNULL(@applicableyear,'') > ''
BEGIN
		SELECT     dbo.EPadZero(8, A.PEReviewMainNo) AS Code, A.PEReviewMainNo, B.ApplyToAll, A.ApplicableYear, F.PositionDesc, B.PositionNo, A.PEStandardMainNo, 
                      E.PETemplateDesc, D.PEEvalPeriodDesc, ISNULL(A.IsPosted, 0) AS Isposted, A.PENormsNo, C.PENormsDesc, C.StartDate, A.PEPeriodNo, A.PEEvalPeriodNo, 
					  A.PECycleNo, dbo.EPECycle.PECycleDesc, dbo.EPEPeriod.PEPeriodDesc, dbo.aSDate(Effectivitydate) As Effectivitydate,A.EmployeeStatNo,St.EmployeeStatDesc,
					  (CASE Isnull(PerformanceStatNo, 0) WHEN 1 THEN 'Open for Review' When 2 then 'Ready for Evaluation' ELSE 'Posted' END) AS tstatus, (CASE Isnull(Isposted, 0) WHEN 1 THEN 0 ELSE 1 END) AS xIsPosted,
					  (Case Isnull(PerformanceStatNo, 0) When 2 then 0 Else 1 End) As IsEnableTag
		FROM          dbo.EPEReviewMain AS A INNER JOIN
                      dbo.EPEStandardMain AS B ON A.PEStandardMainNo = B.PEStandardMainNo LEFT OUTER JOIN
                      dbo.EPEPeriod ON A.PEPeriodNo = dbo.EPEPeriod.PEPeriodNo LEFT OUTER JOIN
                      dbo.EPECycle ON A.PECycleNo = dbo.EPECycle.PECycleNo LEFT OUTER JOIN
                      dbo.EPEEvalPeriod AS D ON A.PEEvalPeriodNo = D.PEEvalPeriodNo LEFT OUTER JOIN
                      dbo.EPENorms AS C ON A.PENormsNo = C.PeNormsNo LEFT OUTER JOIN
                      dbo.EPETemplate AS E ON B.PETemplateNo = E.PETemplateNo LEFT OUTER JOIN
                      dbo.EPosition AS F ON B.PositionNo = F.PositionNo Left Outer Join
                      dbo.EEmployeeStat St On A.EmployeeStatNo=St.EmployeeStatNo Inner Join
					  dbo.EgetPayCompanyPermission(@Onlineuserno,@paylocNo) PL On Isnull(A.PayLocNo,0) = Isnull(PL.xPayLocNo,0)
		WHERE ISNULL(A.IsPosted,0)=@IsPosted AND (A.ApplicableYear like '%' + @applicableyear + '%' OR F.PositionDesc like '%' + @applicableyear + '%')
END
ELSE
BEGIN
		SELECT     dbo.EPadZero(8, A.PEReviewMainNo) AS Code, A.PEReviewMainNo, B.ApplyToAll, A.ApplicableYear, F.PositionDesc, B.PositionNo, A.PEStandardMainNo, 
                      E.PETemplateDesc, D.PEEvalPeriodDesc, ISNULL(A.IsPosted, 0) AS Isposted, A.PENormsNo, C.PENormsDesc, C.StartDate, A.PEPeriodNo, A.PEEvalPeriodNo, 
					  A.PECycleNo, dbo.EPECycle.PECycleDesc, dbo.EPEPeriod.PEPeriodDesc, dbo.aSDate(Effectivitydate) As Effectivitydate,A.EmployeeStatNo,St.EmployeeStatDesc,
					  (CASE Isnull(PerformanceStatNo, 0) WHEN 1 THEN 'Open for Review' When 2 then 'Ready for Evaluation' ELSE 'Posted' END) AS tstatus, (CASE Isnull(Isposted, 0) WHEN 1 THEN 0 ELSE 1 END) AS xIsPosted,
					  (Case Isnull(PerformanceStatNo, 0) When 2 then 0 Else 1 End) As IsEnableTag
		FROM          dbo.EPEReviewMain AS A INNER JOIN
                      dbo.EPEStandardMain AS B ON A.PEStandardMainNo = B.PEStandardMainNo LEFT OUTER JOIN
                      dbo.EPEPeriod ON A.PEPeriodNo = dbo.EPEPeriod.PEPeriodNo LEFT OUTER JOIN
                      dbo.EPECycle ON A.PECycleNo = dbo.EPECycle.PECycleNo LEFT OUTER JOIN
                      dbo.EPEEvalPeriod AS D ON A.PEEvalPeriodNo = D.PEEvalPeriodNo LEFT OUTER JOIN
                      dbo.EPENorms AS C ON A.PENormsNo = C.PeNormsNo LEFT OUTER JOIN
                      dbo.EPETemplate AS E ON B.PETemplateNo = E.PETemplateNo LEFT OUTER JOIN
                      dbo.EPosition AS F ON B.PositionNo = F.PositionNo Left Outer Join
                      dbo.EEmployeeStat St On A.EmployeeStatNo=St.EmployeeStatNo Inner Join
					  dbo.EgetPayCompanyPermission(@Onlineuserno,@paylocNo) PL On Isnull(A.PayLocNo,0) = Isnull(PL.xPayLocNo,0)
		WHERE ISNULL(A.IsPosted,0)=@IsPosted
END














GO

/****** Object:  StoredProcedure [dbo].[EPEReview_WebValidate]    Script Date: 1/20/2014 5:19:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EPEReview_WebValidate]
@onlineuserno INT,
@PEReviewEvaluatorNo INT

AS


DECLARE @tProceed SMALLINT
DECLARE @xMessage VARCHAR(1000)


IF EXISTS(SELECT * FROM EPEReviewEvaluator WHERE PEReviewEvaluatorNo=@PEReviewEvaluatorNo AND ApprovalStatNo=2) 	
BEGIN
	SET @tProceed=0
	SET @xMessage=''
END
ELSE
BEGIN
	SET @tProceed=1
	SET @xMessage='Unable to print'
END

SELECT @tProceed as tProceed, @xMessage as xMessage 
GO

/****** Object:  StoredProcedure [dbo].[EPEReview_WebSelf]    Script Date: 1/20/2014 5:19:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[EPEReview_WebSelf]
	@onlineuserno INT,
	@PEReviewMainNo INT,
	@FullName VARCHAR(100)

AS

DECLARE @EmployeeNo INT
SET @EmployeeNo = (SELECT EmployeeNo FROM dbo.SUser WHERE UserNo=@Onlineuserno)


SELECT     TOP (100) PERCENT dbo.EPadZero(8, A.PEReviewMainNo) AS Code, dbo.EPadZero(8, C.PEReviewNo) AS CodeDeti, A.PEReviewMainNo, B.ApplyToAll, B.ApplicableYear, J.PositionDesc, B.PositionNo, 
						A.PEStandardMainNo, I.PETemplateDesc, H.PEEvalPeriodDesc, C.EmployeeNo, D.EmployeeCode, G.PEPeriodDesc, D.FullName, (CASE WHEN ISNULL(A.IsPosted, 0)=1 OR Isnull(e.approvalstatno,0)=2 THEN 1 ELSE 0 END)  AS IsPosted, A.DatePosted, 
						A.PostedByNo, C.PEReviewNo, E.EValuatorNo, E.PEEvaluatorNo, F.PEEvaluatorDesc, E.PEReviewEvaluatorNo, 
						CONVERT(BIT,(CASE WHEN E.PEEvaluatorNo=7 THEN 1 ELSE 0 END)) as IsEnabledPer, C.AveRating, L.PERatingDesc,
						Isnull(A.performanceStatno,0) performanceStatno,case Isnull(e.approvalstatno,0) when 0  
						then 'For Evaluation' when 1 then 'For Approval' when 2 then 'Approved' Else 'Disapproved' End As tStatus,
						Case Isnull(e.ApprovalStatNo,0) When 2 then 0 Else 1 End As IsEnabled, dbo.EDateToChar(D.HiredDate) as HiredDate, dbo.EDateToChar(D.RegularizedDate) as RegularizedDate
FROM         dbo.EPEReviewMain AS A INNER JOIN
						dbo.EPEStandardMain AS B ON A.PEStandardMainNo = B.PEStandardMainNo INNER JOIN
						dbo.EPEReview AS C ON A.PEReviewMainNo = C.PEReviewMainNo INNER JOIN
						dbo.EEmployee AS D ON C.EmployeeNo = D.EmployeeNo INNER JOIN
						dbo.EPEReviewEvaluator AS E ON C.PEReviewNo = E.PEReviewNo INNER JOIN
						dbo.EPEEvaluator AS F ON E.PEEvaluatorNo = F.PEEvaluatorNo LEFT OUTER JOIN
						dbo.EPEPeriod AS G ON B.PEPeriodNo = G.PEPeriodNo LEFT OUTER JOIN
						dbo.EPEEvalPeriod AS H ON B.PEEvalPeriodNo = H.PEEvalPeriodNo LEFT OUTER JOIN
						dbo.EPETemplate AS I ON B.PETemplateNo = I.PETemplateNo LEFT OUTER JOIN
						dbo.EPosition AS J ON B.PositionNo = J.PositionNo LEFT OUTER JOIN
						dbo.EPENormsDeti AS K ON C.PENormsDetiNo = K.PENormsDetiNo LEFT OUTER JOIN
						dbo.EPERating L ON K.PERatingNO = L.PERatingNo 
WHERE     A.PEReviewMainNo=@PEReviewMainNo AND E.EValuatorNo = @EmployeeNo AND D.FullName like '%' + @FullName + '%' ORDER BY D.FullName







GO

/****** Object:  StoredProcedure [dbo].[EPerformance_RptTemplate]    Script Date: 1/20/2014 5:19:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[EPerformance_RptTemplate] --99,1,656,2,0
@onlineuserno INT,
@filterbyno SMALLINT,
@filterbyid INT,
@pereviewmainno INT,
@peevaluatorno SMALLINT

AS

DECLARE @SqlString NVARCHAR(1000)
DECLARE @Criteria NVARCHAR(200)
DECLARE @Emp TABLE(EmployeeNo INT)
DECLARE @Temp TABLE(PEStandardRevNo INT,
					PEStandardRevDetiNo INT,
					PEReviewMainNo INT,
					PEReviewNo INT,
					PEStandardMainNo INT,
					PEReviewEvaluatorNo INT,
					EmployeeNo INT,
					FullName VARCHAR(100),
					EmployeeCode VARCHAR(100),
					HiredDate VARCHAR(100),
					DepartmentDesc VARCHAR(500),
					SectionDesc VARCHAR(500),
					tCompany VARCHAR(500),
					JDCode VARCHAR(100),
					PETemplateDesc VARCHAR(500),
					PositionDesc VARCHAR(500),
					PEStandardCateNo INT,
					PECateDesc VARCHAR(500),
					OrderLevelCate VARCHAR(100),
					WeightedCate NUMERIC(12,2),
					PEStandardDimNo INT,
					PEDimensionTypeDesc VARCHAR(500),
					OrderLevelDim VARCHAR(100), 
					WeightedDim NUMERIC(12,2), 
					PEStandardCode VARCHAR(100),
					PEStandardDesc VARCHAR(2000),
					Standard VARCHAR(2000), 
					OrderLevel INT,
					Instruction VARCHAR(2000), 
					RatingStandard1 VARCHAR(2000),
					RatingStandard2 VARCHAR(2000),
					RatingStandard3 VARCHAR(2000),
					RatingStandard4 VARCHAR(2000),
					RatingStandard5 VARCHAR(2000),
					RatingStandard6 VARCHAR(2000),
					PEEvaluatorNo	SMALLINT,
					ResponseTypeNo  SMALLINT,
					Comments VARCHAR(2000),
					PERatingNo	INT,
					PERatingCode VARCHAR(100),
					Profeciency NUMERIC(12,2),
					Percentage NUMERIC(12,5),
					AveRating NUMERIC(12,5),
					TotalPercentage NUMERIC(12,5),
					TotalAveRating NUMERIC(12,5),
					xCount INT,
					PEReviewDetiNo INT,
					Remarks VARCHAR(2000),
					AddRemarks VARCHAR(2000),
					Goals VARCHAR(2000),
					Recommendation VARCHAR(2000),
					GeneralComments VARCHAR(2000)
					)

SET @Criteria=''
IF @filterbyno>0 AND @filterbyid>0
BEGIN
	SET @Criteria = dbo.EGetFilterCriteria(@filterbyno,@filterbyid)
END

IF @peevaluatorno=0
BEGIN
	SET @peevaluatorno=NULL
END

SET @SqlString = N'SELECT EmployeeNo FROM EEmployeeFilterDataAll' + @Criteria

PRINT @SqlString
INSERT @Emp(EmployeeNo)
EXEC SP_EXECUTESQL @SqlString


INSERT @Temp(PEStandardRevNo,
					PEStandardMainNo,
					PEReviewMainNo,
					PEReviewNo,
					PEReviewEvaluatorNo,
					EmployeeNo,
					tCompany,
					JDCode,
					PETemplateDesc,
					PositionDesc,
					PEStandardCateNo,
					PECateDesc,
					OrderLevelCate,
					WeightedCate,
					PEStandardDimNo,
					PEDimensionTypeDesc,
					OrderLevelDim, 
					WeightedDim, 
					PEStandardCode,
					PEStandardDesc,
					Standard, 
					OrderLevel,
					Instruction, 
					RatingStandard1,
					RatingStandard2,
					RatingStandard3,
					RatingStandard4,
					RatingStandard5,
					RatingStandard6,
					PEEvaluatorNo,
					ResponseTypeNo
					)

SELECT  B.PEStandardRevNo, A.PEStandardMainNo, I.PEReviewMainNo, J.PEReviewNo, K.PEReviewEvaluatorNo, J.EmployeeNo, dbo.rpt_HeadCN() as tCompany,'' as JDCode, G.PETemplateDesc, H.PositionDesc, B.PEStandardCateNo, E.PECateDesc, C.OrderLevel as OrderLevelCate, C.Weighted as WeightedCate, 
		B.PEStandardDimNo, (CASE WHEN F.PEDimensionTypeDesc>'' THEN F.PEDimensionTypeDesc ELSE '' END) as PEDimensionTypeDesc, D.OrderLevel + '.' as OrderLevelDim, D.Weighted as WeightedDim, B.PEStandardCode + '.', B.PEStandardDesc, B.[Standard] as [Standard], CONVERT(INT,B.OrderLevel) as OrderLevel,
		G.Instruction, G.RatingStandard1, G.RatingStandard2, G.RatingStandard3, G.RatingStandard4, G.RatingStandard5, G.RatingStandard6, K.PEEvaluatorNo, B.ResponseTypeNo
		FROM EPEStandardMain A LEFT OUTER JOIN
				EPETemplate G ON A.PETemplateNo = G.PETemplateNo LEFT OUTER JOIN
				EPosition H ON A.PositionNo = H.PositionNo 	INNER JOIN		
				EPEReviewMain I ON A.PEStandardMainNo=I.PEStandardMainNo INNER JOIN
				EPEReview J ON I.PEReviewMainNo=J.PEReviewMainNo INNER JOIN	
				EPEStandardRev B ON J.PEReviewNo = B.PEReviewNo LEFT OUTER JOIN
				EPEStandardCate C ON B.PEStandardCateNo = C.PEStandardCateNo LEFT OUTER JOIN
				EPEStandardDim D ON B.PEStandardDimNo = D.PEStandardDimNo LEFT OUTER JOIN
				EPECate E ON C.PECateNo = E.PECateNo LEFT OUTER JOIN
				EPEDimensionType F ON D.PEDimensionTypeNo = F.PEDimensionTypeNo INNER JOIN
				EPEReviewEvaluator K ON J.PEReviewNo=K.PEReviewNo
				WHERE I.PEReviewMainNo=@pereviewmainno AND K.PEEvaluatorNo=ISNULL(@peevaluatorno,K.PEEvaluatorNo) AND J.EmployeeNo IN(SELECT EmployeeNo FROM @Emp)

UPDATE @Temp SET Comments=B.ENarative, PEStandardRevDetiNo=B.PEStandarddetiRevNo, PEReviewDetiNo=B.PEReviewDetiNo FROM @Temp A INNER JOIN
EPEReviewDeti B ON A.PEStandardRevNo=B.PEStandardRevNo AND A.PEEvaluatorNo=B.PEEvaluatorNo

UPDATE @Temp SET PERatingNo=B.PERatingNo, PERatingCode=C.PERatingCode, Profeciency=B.Profeciency FROM @Temp A INNER JOIN
EPEStandardDetiRev B ON A.PEStandardRevDetiNo=B.PEStandardDetiRevNo LEFT OUTER JOIN
EPERating C ON B.PERatingNo=C.PERatingNo WHERE A.ResponseTypeNo IN(1,2,4)

UPDATE @Temp SET Percentage=D.Weighted FROM @Temp A LEFT OUTER JOIN
EPEReviewDeti B ON A.PEReviewDetiNo=B.PEReviewDetiNo LEFT OUTER JOIN
EPEStandardRev C ON B.PEStandardRevNo = C.PEStandardRevNo LEFT OUTER JOIN
EPEReviewDim D ON A.PEReviewNo=C.PEReviewNo AND A.PEEvaluatorNo=D.PEEvaluatorNo AND A.PEStandardDimNo=D.PEStandardDimNo WHERE A.ResponseTypeNo IN(1,2,4)

UPDATE @Temp SET Percentage = 0 WHERE PERatingCode='NR'
UPDATE @Temp SET TotalPercentage = A.Percentage/B.Percentage FROM @Temp A INNER JOIN
(SELECT PEReviewEvaluatorNo,PEStandardCateNo, SUM(Percentage) as Percentage FROM @Temp WHERE ResponseTypeNo IN(1,2,4) GROUP BY PEReviewEvaluatorNo,PEStandardCateNo) B ON A.PEReviewEvaluatorNo=B.PEReviewEvaluatorNo AND A.PEStandardCateNo=B.PEStandardCateNo
UPDATE @Temp SET xCount = B.xCount FROM @Temp A INNER JOIN
(SELECT PEReviewEvaluatorNo,PEStandardCateNo, PEStandardDimNo, Count(*) as xCount FROM @Temp WHERE ResponseTypeNo IN(1,2,4) GROUP BY PEReviewEvaluatorNo,PEStandardCateNo,PEStandardDimNo) B ON A.PEReviewEvaluatorNo=B.PEReviewEvaluatorNo AND A.PEStandardCateNo=B.PEStandardCateNo AND A.PEStandardDimNo=B.PEStandardDimNo

UPDATE @Temp SET AveRating = Percentage*Profeciency
UPDATE @Temp SET TotalAveRating = TotalPercentage*Profeciency

--UPDATE @Temp SET WeightedDim=1 WHERE WeightedDim IS NULL

UPDATE @Temp SET Remarks=B.Remarks ,AddRemarks=B.AddRemarks ,Goals=B.Goals ,Recommendation=B.Recommendation ,GeneralComments=B.GeneralComments  FROM @Temp A INNER JOIN
EPEReviewNarrative B ON A.PEReviewNo=B.PEReviewNo AND A.PEEvaluatorNo=B.PEEvaluatorNo 

--UPDATE @Temp SET EvaluatorName=dbo.EGetFullname  FROM @Temp A INNER JOIN
--EPEReviewEvaluator B ON A.PEReviewNo=B.PEReviewNo AND A.PEEvaluatorNo=B.PEEvaluatorNo WHERE A.PEEvaluatorNo=3

UPDATE @Temp SET EmployeeCode=B.EmployeeCode, FullName=B.FullName, HiredDate=B.HiredDate, DepartmentDesc=B.DepartmentDesc, SectionDesc=B.SectionDesc
FROM @Temp A INNER JOIN EEmployeeFilterDataAll B ON A.EmployeeNo=B.EmployeeNo

SELECT * FROM @Temp

GO


