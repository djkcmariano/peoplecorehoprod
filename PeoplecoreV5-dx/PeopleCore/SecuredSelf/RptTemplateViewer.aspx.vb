﻿Imports clsLib
Imports System.Data
Imports Microsoft.Reporting.WebForms

Partial Class SecuredSelf_RptTemplateViewer
    Inherits System.Web.UI.Page
    Dim UserNo As Integer = 0
    Dim ReportNo As Integer = 0
    Dim StrParam As String = ""
    Dim PayLocNo As Integer = 0

    Private Sub PopulateReportQS()

        Try
            Dim dsRpt As New ReportDataSource
            Dim rpt As ServerReport = ReportViewer1.ServerReport
            Dim report_name As String = "", report_ds As String = "", ds As New DataSet, dt As DataTable
            Me.ReportViewer1.ProcessingMode = ProcessingMode.Local
            Me.ReportViewer1.LocalReport.EnableExternalImages = True
            Me.ReportViewer1.Reset()

            'Report Information
            dt = SQLHelper.ExecuteDataTable("SELECT TOP 1 * FROM EReport WHERE ReportNo=" & ReportNo.ToString())
            For Each row As DataRow In dt.Rows
                report_name = row("AccessReportName").ToString()
                report_ds = row("Datasource").ToString()
            Next

            'Retrieve param in query string
            Dim arrParam As String() = StrParam.Split("~"), i As Integer = 0
            Dim obj_len = arrParam.Length - 1
            Dim obj(obj_len) As Object
            For Each param As String In arrParam
                Dim type As String = Generic.Split(param, 0)
                Dim value As String = Generic.Split(param, 1)
                Select Case type
                    Case "str"
                        obj(i) = Generic.ToStr(value)
                    Case "int"
                        obj(i) = Generic.ToInt(value)
                    Case "dec"
                        obj(i) = Generic.ToDec(value)
                    Case "bol"
                        obj(i) = Generic.ToBol(value)
                End Select
                i = i + 1
            Next

            ds = SQLHelper.ExecuteDataSet(report_ds, obj)

            If ds.Tables.Count > 0 Then
                If ds.Tables(0).Rows.Count > 0 Then
                    dsRpt.Name = "ds"
                    dsRpt.Value = ds.Tables(0)
                    ReportViewer1.LocalReport.DisplayName = ds.Tables(0).TableName
                    ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/Reports/") & report_name
                    ReportViewer1.LocalReport.DataSources.Clear()
                    ReportViewer1.LocalReport.DataSources.Add(dsRpt)
                    ReportViewer1.LocalReport.DisplayName = dsRpt.Name
                    ReportViewer1.ShowPrintButton = True
                    ReportViewer1.LocalReport.EnableExternalImages = True
                    AddHandler ReportViewer1.LocalReport.SubreportProcessing, AddressOf SetSubDataSource
                    ReportViewer1.LocalReport.Refresh()
                Else
                    lbl.Text = "<br />No data to display "
                End If
            End If

        Catch ex As Exception

        End Try

    End Sub

    Protected Sub SetSubDataSource(ByVal sender As Object, ByVal e As SubreportProcessingEventArgs)
        Try
            Dim dsD As DataSet
            Dim mpath As String = Server.MapPath("~/Reports/")
            Dim dsSource As DataSet, fDatasource As String = "", dsName As String = "", reportdetiNo As Integer = 0

            Dim ParamName As String = ""
            Dim orderNo As Integer = 0

            dsD = SQLHelper.ExecuteDataSet("EReportDeti_Web", UserNo, ReportNo)
            If dsD.Tables.Count > 0 Then
                If dsD.Tables(0).Rows.Count > 0 Then
                    For i As Integer = 0 To dsD.Tables(0).Rows.Count - 1
                        fDatasource = Generic.ToStr(dsD.Tables(0).Rows(i)("dataSource"))
                        dsName = Generic.ToStr(dsD.Tables(0).Rows(i)("dsName"))
                        reportdetiNo = Generic.ToStr(dsD.Tables(0).Rows(i)("reportDetiNo"))

                        Dim dsDeti As DataSet, rCount As Integer = 0

                        dsDeti = SQLHelper.ExecuteDataSet("EReportDetiParam_Web", UserNo, reportdetiNo)
                        If dsDeti.Tables.Count > 0 Then
                            If dsDeti.Tables(0).Rows.Count > 0 Then
                                rCount = dsDeti.Tables(0).Rows.Count - 1
                                Dim parmV(rCount) As Object
                                'Populate parameter of subreport
                                For ii As Integer = 0 To dsDeti.Tables(0).Rows.Count - 1
                                    ParamName = Generic.ToStr(dsDeti.Tables(0).Rows(ii)("ParamName"))
                                    orderNo = Generic.ToInt(dsDeti.Tables(0).Rows(ii)("orderNo"))
                                    parmV(ii) = e.Parameters(ParamName).Values(0)
                                Next
                                If rCount >= 0 Then
                                    dsSource = SQLHelper.ExecuteDataSet(fDatasource, parmV)
                                    If dsSource.Tables.Count > 0 Then
                                        'If dsSource.Tables(0).Rows.Count > 0 Then
                                        'Display Report
                                        e.DataSources.Add(New ReportDataSource(dsName, dsSource.Tables(0)))
                                        'End If
                                    End If
                                End If
                            End If
                        End If
                    Next
                End If
            End If
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        UserNo = Generic.ToInt(Session("OnlineUserNo"))
        ReportNo = Generic.ToInt(Request.QueryString("ReportNo"))
        PayLocNo = Generic.ToInt(Session("xPayLocNo"))
        StrParam = "int|" & UserNo & "~" & "int|" & PayLocNo & "~" & Generic.ToStr(Request.QueryString("param"))
        Permission.IsAuthenticated()
        If Not IsPostBack Then
            PopulateReportQS()
        End If
    End Sub
End Class
