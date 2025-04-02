﻿Imports clsLib
Imports System.Data
Imports DevExpress.Export
Imports DevExpress.XtraPrinting
Imports DevExpress.Web

Partial Class SecuredManager_SelfDTRShiftMassListAppr
    Inherits System.Web.UI.Page
    Dim UserNo As Int64 = 0
    Dim TransNo As Int64 = 0
    Dim PayLocNo As Integer = 0


#Region "********Main********"
    Protected Sub PopulateGrid(Optional IsMain As Boolean = False)
        Try

            Dim tStatus As Integer = Generic.ToInt(cboTabNo.SelectedValue)
            If tStatus = 1 Then
                lnkAppend.Visible = False
                lnkDeleteDetl.Visible = False
            Else
                lnkAppend.Visible = True
                lnkDeleteDetl.Visible = True
            End If

            Dim dt As DataTable
            dt = SQLHelper.ExecuteDataTable("EDTRShiftMass_WebManager", UserNo, Generic.ToInt(cboTabNo.SelectedValue), PayLocNo)
            grdMain.DataSource = dt
            grdMain.DataBind()

            If ViewState("TransNo") = 0 Or IsMain = True Then
                Dim obj As Object() = grdMain.GetRowValues(grdMain.VisibleStartIndex(), New String() {"DTRShiftMassNo", "DTRShiftMassTransNo"})
                ViewState("TransNo") = obj(0)
                lbl.Text = obj(1)
            End If

            PopulateGridDetl()
        Catch ex As Exception

        End Try
    End Sub

    Protected Sub PopulateData(id As Int64)
        Try
            Dim dt As DataTable
            dt = SQLHelper.ExecuteDataTable("EDTRShiftMass_WebOne", UserNo, id)
            For Each row As DataRow In dt.Rows
                Generic.PopulateData(Me, "pnlPopupMain", dt)
            Next
        Catch ex As Exception

        End Try
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        UserNo = Generic.ToInt(Session("OnlineUserNo"))
        TransNo = Generic.ToInt(Request.QueryString("id"))
        PayLocNo = Generic.ToInt(Session("xPayLocNo"))
        Permission.IsAuthenticatedSuperior()
        If Not IsPostBack Then
            PopulateDropDown()
            Generic.PopulateDropDownList_Self(UserNo, Me, "pnlPopupAppend", PayLocNo)
        End If

        PopulateGrid()
        Generic.PopulateDXGridFilter(grdMain, UserNo, PayLocNo)

        PopulateGridDetl()
        Generic.PopulateDXGridFilter(grdDetl, UserNo, PayLocNo)

        Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1)) : Response.Cache.SetCacheability(HttpCacheability.NoCache) : Response.Cache.SetNoStore()

    End Sub

    Private Sub PopulateDropDown()
        Generic.PopulateDropDownList(UserNo, Me, "pnlPopupMain", Generic.ToInt(Session("xPayLocNo")))
        Try
            cboTabNo.DataSource = SQLHelper.ExecuteDataSet("ETab_WebLookup", UserNo, 4)
            cboTabNo.DataTextField = "tDesc"
            cboTabNo.DataValueField = "tno"
            cboTabNo.DataBind()
        Catch ex As Exception
        End Try

    End Sub

    Protected Sub lnkAdd_Click(sender As Object, e As EventArgs)

        Generic.ClearControls(Me, "pnlPopupMain")
        Generic.EnableControls(Me, "pnlPopupMain", True)
        lnkSave.Enabled = True
        mdlMain.Show()

    End Sub

    Protected Sub lnkEdit_Click(sender As Object, e As EventArgs)

        Dim lnk As New LinkButton
        lnk = sender
        Dim container As GridViewDataItemTemplateContainer = TryCast(lnk.NamingContainer, GridViewDataItemTemplateContainer)
        PopulateData(Generic.ToInt(container.Grid.GetRowValues(container.VisibleIndex, New String() {"DTRShiftMassNo"})))
        Dim IsEnabled As Boolean = Generic.ToBol(container.Grid.GetRowValues(container.VisibleIndex, New String() {"IsEnabled"}))
        Generic.EnableControls(Me, "pnlPopupMain", IsEnabled)
        lnkSave.Enabled = IsEnabled
        mdlMain.Show()

    End Sub

    Protected Sub lnkDelete_Click(sender As Object, e As EventArgs)

        Dim fieldValues As List(Of Object) = grdMain.GetSelectedFieldValues(New String() {"DTRShiftMassNo"})
        Dim str As String = "", i As Integer = 0
        For Each item As Integer In fieldValues
            Generic.DeleteRecordAuditCol("EDTRShiftMassDeti", UserNo, "DTRShiftMassNo", item)
            Generic.DeleteRecordAudit("EDTRShiftMass", UserNo, item)
            i = i + 1
        Next

        If i > 0 Then
            PopulateGrid(True)
            MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccessDelete, Me)
        Else
            MessageBox.Warning(MessageTemplate.NoSelectedTransaction, Me)
        End If

    End Sub

    Protected Sub lnkDetail_Click(sender As Object, e As EventArgs)
        Dim lnk As New LinkButton
        lnk = sender
        Dim container As GridViewDataItemTemplateContainer = TryCast(lnk.NamingContainer, GridViewDataItemTemplateContainer)
        Dim obj As Object() = container.Grid.GetRowValues(container.VisibleIndex, New String() {"DTRShiftMassNo", "DTRShiftMassTransNo"})
        ViewState("TransNo") = obj(0)
        lbl.Text = obj(1)
        PopulateGridDetl()
    End Sub

    Protected Sub lnkPost_Click(sender As Object, e As EventArgs)
        Dim chk As New CheckBox, ib As New ImageButton, Count As Integer = 0

        Dim fieldValues As List(Of Object) = grdMain.GetSelectedFieldValues(New String() {"DTRShiftMassNo"})
        Dim str As String = "", i As Integer = 0
        For Each item As Integer In fieldValues
            If SQLHelper.ExecuteNonQuery("EDTRShiftMass_WebForward", UserNo, item, PayLocNo) > 0 Then
                Count = Count + 1
            End If
            i = i + 1
        Next

        If i > 0 Then
            PopulateGrid(True)
            MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccesPost, Me)
        Else
            MessageBox.Warning(MessageTemplate.NoSelectedTransaction, Me)
        End If

    End Sub

    Protected Sub lnkSearch_Click(sender As Object, e As EventArgs)
        PopulateGrid(True)
    End Sub

    Protected Sub grdMain_CommandButtonInitialize(sender As Object, e As DevExpress.Web.ASPxGridViewCommandButtonEventArgs) Handles grdMain.CommandButtonInitialize
        If e.ButtonType = ColumnCommandButtonType.SelectCheckbox Then
            Dim value As Boolean = Generic.ToInt(grdMain.GetRowValues(e.VisibleIndex, "IsEnabled"))
            e.Enabled = value
        End If
    End Sub

    Protected Sub lnkSave_Click(sender As Object, e As EventArgs)
        Dim RetVal As Boolean = False
        Dim DTRShiftMassNo As Integer = Generic.ToInt(txtDTRShiftMassNo.Text)
        Dim Description As String = Generic.ToStr(txtDescription.Text)
        Dim DateFrom As String = Generic.ToStr(txtDateFrom.Text)
        Dim DateTo As String = Generic.ToStr(txtDateTo.Text)
        Dim ShiftNo As Integer = Generic.ToInt(cboShiftNo.SelectedValue)
        Dim ShiftNoMon As Integer = Generic.ToInt(cboShiftNoMon.SelectedValue)
        Dim ShiftNoTue As Integer = Generic.ToInt(cboShiftNoTue.SelectedValue)
        Dim ShiftNoWed As Integer = Generic.ToInt(cboShiftNoWed.SelectedValue)
        Dim ShiftNoThu As Integer = Generic.ToInt(cboShiftNoThu.SelectedValue)
        Dim ShiftNoFri As Integer = Generic.ToInt(cboShiftNoFri.SelectedValue)
        Dim ShiftNoSat As Integer = Generic.ToInt(cboShiftNoSat.SelectedValue)
        Dim ShiftNoSun As Integer = Generic.ToInt(cboShiftNoSun.SelectedValue)
        Dim ApprovalStatNo As Integer = 0
        Dim ComponentNo As Integer = 2 'Managerial
        Dim IsFromOnline As Boolean = True

        '//validate start here
        Dim invalid As Boolean = True, messagedialog As String = "", alerttype As String = ""
        Dim dtx As New DataTable
        dtx = SQLHelper.ExecuteDataTable("EDTRShift_WebValidate", UserNo, 0, 0, DateFrom, DateTo, ShiftNo, ApprovalStatNo, PayLocNo, ComponentNo)

        For Each rowx As DataRow In dtx.Rows
            invalid = Generic.ToBol(rowx("tProceed"))
            messagedialog = Generic.ToStr(rowx("xMessage"))
            alerttype = Generic.ToStr(rowx("AlertType"))
        Next

        If invalid = True Then
            MessageBox.Alert(messagedialog, alerttype, Me)
            mdlMain.Show()
            Exit Sub
        End If

        If SQLHelper.ExecuteNonQuery("EDTRShiftMass_WebSave", UserNo, DTRShiftMassNo, Description, DateFrom, DateTo, ShiftNo, PayLocNo,
                                     ShiftNoMon, ShiftNoTue, ShiftNoWed, ShiftNoThu, ShiftNoFri, ShiftNoSat, ShiftNoSun, IsFromOnline) > 0 Then
            RetVal = True
        Else
            RetVal = False
        End If

        If RetVal = True Then
            PopulateGrid()
            MessageBox.Success(MessageTemplate.SuccessSave, Me)
        Else
            MessageBox.Critical(MessageTemplate.ErrorSave, Me)
        End If
    End Sub


    Protected Sub lnkExport_Click(sender As Object, e As EventArgs)
        Try
            grdExport.WriteXlsxToResponse(New XlsxExportOptionsEx With {.ExportType = ExportType.WYSIWYG})
        Catch ex As Exception
            MessageBox.Warning("Error exporting to excel file.", Me)
        End Try

    End Sub

#End Region

#Region "********Details********"
    Protected Sub PopulateGridDetl()
        Try

            Dim dt As DataTable
            dt = SQLHelper.ExecuteDataTable("EDTRShiftMassDeti_Web", UserNo, Generic.ToInt(ViewState("TransNo")), "")
            grdDetl.DataSource = dt
            grdDetl.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub lnkDeleteDetl_Click(sender As Object, e As EventArgs)

        Dim fieldValues As List(Of Object) = grdDetl.GetSelectedFieldValues(New String() {"DTRShiftMassDetiNo"})
        Dim str As String = "", i As Integer = 0
        For Each item As Integer In fieldValues
            Generic.DeleteRecordAudit("EDTRShiftMassDeti", UserNo, item)
            i = i + 1
        Next
        MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccessDelete, Me)
        PopulateGridDetl()

    End Sub

    Protected Sub cboShiftNo_SelectedIndexChanged(sender As Object, e As System.EventArgs)
        If Generic.ToInt(cboShiftNo.SelectedValue) > 0 Then
            Dim xShiftNo As Integer = Generic.ToInt(cboShiftNo.SelectedValue)
            cboShiftNoMon.Enabled = True
            cboShiftNoTue.Enabled = True
            cboShiftNoWed.Enabled = True
            cboShiftNoThu.Enabled = True
            cboShiftNoFri.Enabled = True
            cboShiftNoSat.Enabled = True
            cboShiftNoSun.Enabled = True

            cboShiftNoMon.Text = xShiftNo
            cboShiftNoTue.Text = xShiftNo
            cboShiftNoWed.Text = xShiftNo
            cboShiftNoThu.Text = xShiftNo
            cboShiftNoFri.Text = xShiftNo
            cboShiftNoSat.Text = xShiftNo
            cboShiftNoSun.Text = xShiftNo
        Else
            Try
                cboShiftNoMon.Enabled = False
                cboShiftNoTue.Enabled = False
                cboShiftNoWed.Enabled = False
                cboShiftNoThu.Enabled = False
                cboShiftNoFri.Enabled = False
                cboShiftNoSat.Enabled = False
                cboShiftNoSun.Enabled = False

                cboShiftNoMon.Text = ""
                cboShiftNoTue.Text = ""
                cboShiftNoWed.Text = ""
                cboShiftNoThu.Text = ""
                cboShiftNoFri.Text = ""
                cboShiftNoSat.Text = ""
                cboShiftNoSun.Text = ""
            Catch ex As Exception

            End Try
        End If

        mdlMain.Show()
    End Sub

    Protected Sub lnkExportDetl_Click(sender As Object, e As EventArgs)
        Try
            grdExportDetl.WriteXlsxToResponse(New XlsxExportOptionsEx With {.ExportType = ExportType.WYSIWYG})
        Catch ex As Exception
            MessageBox.Warning("Error exporting to excel file.", Me)
        End Try

    End Sub
#End Region

#Region "********Detail Check All********"


    Protected Sub grdDetl_CommandButtonInitialize(sender As Object, e As DevExpress.Web.ASPxGridViewCommandButtonEventArgs)
        If e.ButtonType <> ColumnCommandButtonType.SelectCheckbox Then
            Return
        End If
        Dim rowEnabled As Boolean = getRowEnabledStatus(e.VisibleIndex)
        e.Enabled = rowEnabled
    End Sub
    Private Function getRowEnabledStatus(ByVal VisibleIndex As Integer) As Boolean
        Dim value As Boolean = Generic.ToInt(grdDetl.GetRowValues(VisibleIndex, "IsEnabled"))
        If value = True Then
            Return True
        Else
            Return False
        End If
    End Function
    Protected Sub cbCheckAll_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim cb As ASPxCheckBox = DirectCast(sender, ASPxCheckBox)
        cb.ClientSideEvents.CheckedChanged = String.Format("cbCheckAll_CheckedChanged")
        cb.Checked = False
        Dim count As Integer = 0
        Dim startIndex As Integer = grdDetl.PageIndex * grdDetl.SettingsPager.PageSize
        Dim endIndex As Integer = Math.Min(grdDetl.VisibleRowCount, startIndex + grdDetl.SettingsPager.PageSize)

        For i As Integer = startIndex To endIndex - 1
            If grdDetl.Selection.IsRowSelected(i) Then
                count = count + 1
            End If
        Next i

        If count > 0 Then
            cb.Checked = True
        End If

    End Sub
    Protected Sub gridDetl_CustomCallback(ByVal sender As Object, ByVal e As ASPxGridViewCustomCallbackEventArgs)
        Boolean.TryParse(e.Parameters, False)

        Dim startIndex As Integer = grdDetl.PageIndex * grdDetl.SettingsPager.PageSize
        Dim endIndex As Integer = Math.Min(grdDetl.VisibleRowCount, startIndex + grdDetl.SettingsPager.PageSize)
        For i As Integer = startIndex To endIndex - 1
            Dim rowEnabled As Boolean = getRowEnabledStatus(i)
            If rowEnabled AndAlso e.Parameters = "true" Then
                grdDetl.Selection.SelectRow(i)
            Else
                grdDetl.Selection.UnselectRow(i)
            End If
        Next i

    End Sub

#End Region

#Region "********Append*******"

    Protected Sub lnkAppend_Click(sender As Object, e As EventArgs)

        If Generic.ToInt(ViewState("TransNo")) > 0 Then
            Generic.ClearControls(Me, "pnlPopupAppend")
            cboFilteredbyNo.Text = 1
            drpAC.CompletionSetCount = 1
            mdlAppend.Show()
        Else
            MessageBox.Warning(MessageTemplate.NoSelectedTransaction, Me)
        End If

    End Sub

    Protected Sub cboFilteredbyNo_SelectedIndexChanged(sender As Object, e As System.EventArgs)
        Try
            Dim fId As Integer
            fId = Generic.ToInt(Generic.CheckDBNull(cboFilteredbyNo.SelectedValue, clsBase.clsBaseLibrary.enumObjectType.IntType))
            txtName.Text = ""
            If fId > 0 Then
                txtName.Enabled = True
                drpAC.CompletionSetCount = fId
            Else
                txtName.Enabled = False
                drpAC.CompletionSetCount = 0
            End If

            mdlAppend.Show()
        Catch ex As Exception

        End Try
    End Sub

    Protected Sub lnkSaveAppend_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim Retval As Boolean = False
        Dim tno As Integer = Generic.ToInt(ViewState("TransNo"))
        Dim FilteredbyNo As Integer = Generic.ToInt(Me.cboFilteredbyNo.SelectedValue)
        Dim FilterValue As Integer = Generic.ToInt(Me.hiffilterbyid.Value)

        If SQLHelper.ExecuteNonQuery("EDTRShiftMassDeti_WebSaveManager", UserNo, tno, FilteredbyNo, FilterValue) >= 0 Then
            Retval = True
        Else
            Retval = False
        End If

        If Retval Then
            PopulateGridDetl()
            MessageBox.Success(MessageTemplate.SuccessSave, Me)
        Else
            MessageBox.Warning(MessageTemplate.ErrorSave, Me)
        End If

    End Sub

    <System.Web.Script.Services.ScriptMethod()> _
<System.Web.Services.WebMethod()> _
    Public Shared Function populateDataDropdown(prefixText As String, count As Integer, contextKey As String) As List(Of String)
        Dim items As New List(Of String)()
        Dim _ds As New DataSet()
        Dim sqlhelp As New clsBase.SQLHelper
        Dim clsbase As New clsBase.clsBaseLibrary
        Dim UserNo As Integer = 0, PayLocNo As Integer = 0
        UserNo = (HttpContext.Current.Session("onlineuserno"))
        PayLocNo = (HttpContext.Current.Session("xPayLocNo"))

        _ds = SQLHelper.ExecuteDataSet("EFilterBy_WebLookup_AC_Manager", UserNo, prefixText, PayLocNo, count)
        For Each row As DataRow In _ds.Tables(0).Rows
            Dim item As String = AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(Generic.ToStr(row("tDesc")),
                                Generic.ToStr(row("tNo")))
            items.Add(item)
        Next
        _ds.Dispose()
        Return items


    End Function

#End Region

End Class

