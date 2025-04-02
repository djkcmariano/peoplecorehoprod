﻿Imports System.Data
Imports clsLib
Imports System.Math
Imports DevExpress.Web
Imports DevExpress.Export
Imports DevExpress.XtraPrinting
Imports Microsoft.VisualBasic.FileIO
Imports System.IO

Partial Class Secured_PayTemplate_Last
    Inherits System.Web.UI.Page

    Dim UserNo As Integer
    Dim PayLocNo As Integer
    Dim TransNo As Integer
    Dim PayCateNo As Integer



    Private Sub PopulateDataEntitled(id As Integer)
        Dim dt As DataTable
        dt = SQLHelper.ExecuteDataTable("EPayTemplateBonus_WebOne", UserNo, id)
        Generic.PopulateData(Me, "Panel2", dt)
        For Each row As DataRow In dt.Rows
            txtIsUpload.Checked = Generic.ToBol(row("IsUpload"))
            cboPEPeriodNo.Text = Generic.ToStr(row("PEPeriodNo"))
            txtEligibleDate.Text = Generic.ToStr(row("EligibleDate"))
        Next

    End Sub

    Private Sub PopulateGrid(Optional IsMain As Boolean = False)
        Dim _dt As DataTable
        _dt = SQLHelper.ExecuteDataTable("EPayTemplateBonus_Web", UserNo, TransNo, 2, PayLocNo)
        Me.grdMain.DataSource = _dt
        Me.grdMain.DataBind()

        If ViewState("TransNo") = 0 Or IsMain = True Then
            Dim obj As Object() = grdMain.GetRowValues(grdMain.VisibleStartIndex(), New String() {"PayTemplateBonusNo", "Code", "IsUpload"})
            'Dim obj As Object() = grdMain.GetRowValues(grdMain.VisibleStartIndex(), New String() {"PayTemplateBonusNo", "Code"})
            ViewState("TransNo") = obj(0)
            ViewState("IsUpload") = obj(2)
        End If

    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        UserNo = Generic.ToInt(Session("OnlineUserNo"))
        PayLocNo = Generic.ToInt(Session("xPayLocNo"))
        TransNo = Generic.ToInt(Request.QueryString("id"))
        Permission.IsAuthenticatedCoreUser()
        If Not IsPostBack Then
            Generic.PopulateDropDownList(UserNo, Me, "Panel2", PayLocNo)
            Try
                cboPEPeriodNo.DataSource = SQLHelper.ExecuteDataTable("xTable_Lookup", UserNo, "EPEPeriod", PayLocNo, "", "")
                cboPEPeriodNo.DataTextField = "tDesc"
                cboPEPeriodNo.DataValueField = "tNo"
                cboPEPeriodNo.DataBind()
            Catch ex As Exception
            End Try
            PopulateDropdownListL()
            PopulateDropDownListb()
        End If
        PopulateGrid()
        PopulateGridL()
        PopulateGridb()
    End Sub



    Protected Sub lnkAdd_Click(sender As Object, e As EventArgs)
        Generic.ClearControls(Me, "Panel2")
        txtIsUpload.Checked = False
        cboPEPeriodNo.Text = ""
        txtEligibleDate.Text = ""
        ModalPopupExtender1.Show()
    End Sub

    Protected Sub lnkDelete_Click(sender As Object, e As EventArgs)
        Dim fieldValues As List(Of Object) = grdMain.GetSelectedFieldValues(New String() {"PayTemplateBonusNo"})
        Dim i As Integer = 0
        For Each item As Integer In fieldValues
            Generic.DeleteRecordAudit("EPayTemplateBonus", UserNo, item)
            i = i + 1
        Next
        MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccessDelete, Me)
        PopulateGrid()
    End Sub

    Protected Sub lnkEdit_Click(sender As Object, e As EventArgs)

        Dim lnk As New LinkButton, IsEnabled As Boolean = False
        lnk = sender
        Dim container As GridViewDataItemTemplateContainer = TryCast(lnk.NamingContainer, GridViewDataItemTemplateContainer)
        Generic.ClearControls(Me, "Panel2")
        PopulateDataEntitled(Generic.ToInt(container.Grid.GetRowValues(container.VisibleIndex, New String() {"PayTemplateBonusNo"})))

        'Generic.EnableControls(Me, "Panel2", IsEnabled)
        'lnkSave.Enabled = IsEnabled
        'EnabledControls(IsEnabled)

        ModalPopupExtender1.Show()

    End Sub


    Protected Sub lnkSave_Click(sender As Object, e As EventArgs)

        Dim Retval As Boolean = False
        Dim datebaseNo As Integer = Generic.ToInt(cboDatebaseNo.SelectedValue)
        Dim bonusTypeNo As Integer = Generic.ToInt(cboBonusTypeNo.SelectedValue)
        Dim bonusBasisNo As Integer = Generic.ToInt(cboBonusBasisNo.SelectedValue)
        Dim noofmonthsassume As Double = Generic.ToDec(txtnoofmonthsassume.Text)
        Dim IsUpload As Boolean = Generic.ToBol(txtIsUpload.Checked)
        Dim PEPeriodNo As Integer = Generic.ToInt(cboPEPeriodNo.SelectedValue)
        Dim fixedamount As Double = 0 'Generic.ToDbl(txtFixedAmount.Text)
        '//validate start here
        Dim invalid As Boolean = True, messagedialog As String = "", alerttype As String = ""
        Dim dtx As New DataTable

        'dtx = SQLHelper.ExecuteDataTable("EPayTemplateBonus_WebValidate", UserNo, Generic.ToInt(txtPayTemplateBonusNo.Text), TransNo, Generic.ToInt(Me.cboEmployeeStatNo.SelectedValue), _
        '                             Generic.ToInt(Me.cboEmployeeClassNo.SelectedValue), Generic.ToDec(Me.txtMinServiceYear.Text), Generic.ToDec(Me.txtPercentFactor.Text), _
        '                             txtIsApplytoAll.Checked, datebaseNo, bonusBasisNo, bonusTypeNo, txtcStartDate.Text.ToString, txtcEndDate.Text.ToString, noofmonthsassume,
        '                             Generic.ToInt(Generic.Split(hifEmployeeNo.Value, 0)), Generic.ToStr(txtEligibleDate.Text), IsUpload, PEPeriodNo)

        'For Each rowx As DataRow In dtx.Rows
        '    invalid = Generic.ToBol(rowx("tProceed"))
        '    messagedialog = Generic.ToStr(rowx("xMessage"))
        '    alerttype = Generic.ToStr(rowx("AlertType"))
        'Next

        'If invalid = True Then
        '    MessageBox.Alert(messagedialog, alerttype, Me)
        '    ModalPopupExtender1.Show()
        '    Exit Sub
        'End If

        Dim dt As DataTable, error_num As Integer = 0, error_message As String = ""
        dt = SQLHelper.ExecuteDataTable("EPayTemplateBonus_WebSave", UserNo, Generic.ToInt(txtPayTemplateBonusNo.Text), Generic.ToInt(cboPayClassNo.SelectedValue), Generic.ToInt(Me.cboEmployeeStatNo.SelectedValue), _
                                      Generic.ToInt(Me.cboEmployeeClassNo.SelectedValue), Generic.ToDec(Me.txtMinServiceYear.Text), Generic.ToDec(Me.txtPercentFactor.Text), _
                                      txtIsApplytoAll.Checked, 0, datebaseNo, bonusBasisNo, bonusTypeNo, "", "", noofmonthsassume,
                                      PEPeriodNo, Generic.ToStr(txtEligibleDate.Text), IsUpload, 2, PayLocNo, fixedamount)

        ViewState("IsUpload") = IsUpload
        For Each row As DataRow In dt.Rows
            Retval = True
            error_num = Generic.ToInt(row("Error_num"))
            If error_num > 0 Then
                error_message = Generic.ToStr(row("ErrorMessage"))
                MessageBox.Critical(error_message, Me)
                Retval = False
            End If

        Next
        If Retval = False And error_message = "" Then
            MessageBox.Critical(MessageTemplate.ErrorSave, Me)
        End If
        If Retval = True Then
            PopulateGrid()
            MessageBox.Success(MessageTemplate.SuccessSave, Me)
        End If
    End Sub



    Protected Sub lnkExport_Click(sender As Object, e As EventArgs)
        Try
            grdExport.WriteXlsxToResponse(New XlsxExportOptionsEx With {.ExportType = ExportType.WYSIWYG})
        Catch ex As Exception
            MessageBox.Warning("Error exporting to excel file.", Me)
        End Try

    End Sub


#Region "Leave Template"



    Private Sub PopulateDataEntitledL(id As Integer)
        Dim dt As DataTable
        dt = SQLHelper.ExecuteDataTable("EPayTemplateLeave_WebOne", UserNo, id)
        Generic.PopulateData(Me, "Panel2", dt)
        For Each row As DataRow In dt.Rows
            Try
                cboLeaveTypeNo.DataSource = SQLHelper.ExecuteDataSet("ELeaveType_WebLookup_Union", UserNo, row("LeaveTypeNo"), PayLocNo)
                cboLeaveTypeNo.DataTextField = "tDesc"
                cboLeaveTypeNo.DataValueField = "tNo"
                cboLeaveTypeNo.DataBind()
            Catch ex As Exception
            End Try
            txtIsUpload.Checked = Generic.ToBol(row("IsUpload"))
            txtExcessOf.Text = Generic.ToDec(row("ExcessOf"))
            txtMaximumOf.Text = Generic.ToDec(row("MaximunOf"))
            txtismaximumInPercent.Checked = Generic.ToBol(row("IsMaximumInPercent"))
        Next
    End Sub

    Private Sub PopulateGridL(Optional IsMain As Boolean = False)
        Dim _dt As DataTable
        _dt = SQLHelper.ExecuteDataTable("EPayTemplateLeave_Web", UserNo, 0, PayLocNo, 2)
        Me.grdLeave.DataSource = _dt
        Me.grdLeave.DataBind()

        If ViewState("TransNo") = 0 Or IsMain = True Then
            Dim obj As Object() = grdLeave.GetRowValues(grdLeave.VisibleStartIndex(), New String() {"PayTemplateLeaveNo", "Code", "IsUpload"})
            ViewState("TransNo") = obj(0)
            ViewState("IsUpload") = obj(2)
        End If


    End Sub

    'Populate Combo box
    Private Sub PopulateDropdownListL()
        Generic.PopulateDropDownList(UserNo, Me, "Panel1", PayLocNo)
        Try
            cboLeaveTypeNo.DataSource = SQLHelper.ExecuteDataSet("ELeaveType_WebLookup_Union", UserNo, 0, PayLocNo)
            cboLeaveTypeNo.DataTextField = "tDesc"
            cboLeaveTypeNo.DataValueField = "tNo"
            cboLeaveTypeNo.DataBind()
        Catch ex As Exception
        End Try


    End Sub


    Protected Sub lnkEditL_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim lnk As New LinkButton, IsEnabled As Boolean = False
        lnk = sender
        Dim container As GridViewDataItemTemplateContainer = TryCast(lnk.NamingContainer, GridViewDataItemTemplateContainer)
        Generic.ClearControls(Me, "Panel1")
        PopulateDataEntitledL(Generic.ToInt(container.Grid.GetRowValues(container.VisibleIndex, New String() {"PayTemplateLeaveNo"})))
        mdlShow.Show()

    End Sub

    Protected Sub lnkAddL_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Generic.ClearControls(Me, "Panel1")
        txtIsUpload.Checked = False
        txtExcessOf.Text = ""
        txtMaximumOf.Text = ""
        txtismaximumInPercent.Checked = False
        mdlShow.Show()
    End Sub


    Protected Sub lnkDeleteL_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim fieldValues As List(Of Object) = grdMain.GetSelectedFieldValues(New String() {"PayTemplateLeaveNo"})
        Dim i As Integer = 0
        For Each item As Integer In fieldValues
            Generic.DeleteRecordAudit("EPayTemplateLeave", UserNo, item)
            i = i + 1
        Next
        MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccessDelete, Me)
        PopulateGrid()
    End Sub
    'Submit record
    Protected Sub btnSaveL_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        Dim Retval As Boolean = False
        Dim tNo As Integer = Generic.ToInt(txtPayTemplateLeaveNo.Text)
        Dim employeeStatNo As Integer = Generic.ToInt(cboEmployeeStatNo.SelectedValue)
        Dim employeeClassNo As Integer = Generic.ToInt(cboEmployeeClassNo.SelectedValue)
        Dim IsUpload As Boolean = Generic.ToBol(txtIsUpload.Checked)
        Dim BonusBasisNo As Integer = Generic.ToInt(cboBonusBasisNo.SelectedValue)


        '//validate start here
        Dim invalid As Boolean = True, messagedialog As String = "", alerttype As String = ""
        'Dim dtx As New DataTable
        'dtx = SQLHelper.ExecuteDataTable("EPayTemplateLeave_WebValidate", UserNo, tNo,
        '                             TransNo,
        '                             employeeStatNo,
        '                             employeeClassNo,
        '                             Generic.ToDec(txtExcessOf.Text),
        '                             Generic.ToDec(txtMaximumOf.Text),
        '                             Generic.ToInt(cboLeaveTypeNo.SelectedValue),
        '                             Generic.ToInt(Generic.Split(hifEmployeeNo.Value, 0)),
        '                             Generic.ToInt(cboLeaveMonitizedtypeNo.SelectedValue),
        '                             Generic.ToBol(txtismaximumInPercent.Checked),
        '                             txtcStartDate.Text.ToString, txtcEndDate.Text.ToString, IsUpload, BonusBasisNo)

        'For Each rowx As DataRow In dtx.Rows
        '    invalid = Generic.ToBol(rowx("tProceed"))
        '    messagedialog = Generic.ToStr(rowx("xMessage"))
        '    alerttype = Generic.ToStr(rowx("AlertType"))
        'Next

        'If invalid = True Then
        '    MessageBox.Alert(messagedialog, alerttype, Me)
        '    mdlShow.Show()
        '    Exit Sub
        'End If


        Dim dt As DataTable, error_num As Integer = 0, error_message As String = ""
        dt = SQLHelper.ExecuteDataTable("EPayTemplateLeave_WebSave", UserNo, tNo,
                                     Generic.ToInt(cboPayClassNoL.SelectedValue),
                                     2,
                                     employeeStatNo,
                                     employeeClassNo,
                                     Generic.ToDec(txtExcessOf.Text),
                                     Generic.ToDec(txtMaximumOf.Text),
                                     txtIsApplyToAllL.Checked,
                                     0,
                                     Generic.ToInt(cboLeaveTypeNo.SelectedValue),
                                     Generic.ToInt(cboLeaveMonitizedtypeNo.SelectedValue),
                                     0,
                                     Generic.ToBol(txtismaximumInPercent.Checked),
                                     IsUpload,
                                     "",
                                     "",
                                     PayLocNo)

        ViewState("IsUpload") = IsUpload
        For Each row As DataRow In dt.Rows
            Retval = True
            error_num = Generic.ToInt(row("Error_num"))
            If error_num > 0 Then
                error_message = Generic.ToStr(row("ErrorMessage"))
                MessageBox.Critical(error_message, Me)
                Retval = False
            End If

        Next
        If Retval = False And error_message = "" Then
            MessageBox.Critical(MessageTemplate.ErrorSave, Me)
        End If
        If Retval = True Then
            PopulateGrid()
            MessageBox.Success(MessageTemplate.SuccessSave, Me)
        End If

    End Sub

    Protected Sub lnkExportL_Click(sender As Object, e As EventArgs)
        Try
            grdExport.WriteXlsxToResponse(New XlsxExportOptionsEx With {.ExportType = ExportType.WYSIWYG})
        Catch ex As Exception
            MessageBox.Warning("Error exporting to excel file.", Me)
        End Try

    End Sub
#End Region

#Region "Payroll Components"
    Protected Sub PopulateGridb()
        Try
            Dim dt As DataTable
            dt = SQLHelper.ExecuteDataTable("EPayTemplate_Web", UserNo, TransNo, 2, PayLocNo)
            grdPay.DataSource = dt
            grdPay.DataBind()
        Catch ex As Exception

        End Try
    End Sub

    Private Sub PopulateDropDownListb()
        Generic.PopulateDropDownList(UserNo, Me, "pnlPopupDetl", Generic.ToInt(Session("xPayLocNo")))

    End Sub

    Protected Sub lnkAddb_Click(sender As Object, e As EventArgs)
        If AccessRights.IsAllowUser(UserNo, AccessRights.EnumPermissionType.AllowAdd) Then
            Generic.ClearControls(Me, "pnlPopupDetl")
            Generic.EnableControls(Me, "pnlPopupDetl", True)
            lnkSaveb.Enabled = True
            mdlDetl.Show()
        Else
            MessageBox.Warning(MessageTemplate.DeniedAdd, Me)
        End If
    End Sub
    Protected Sub lnkEditb_Click(sender As Object, e As EventArgs)
        If AccessRights.IsAllowUser(UserNo, AccessRights.EnumPermissionType.AllowEdit) Then
            Dim lnk As New LinkButton
            lnk = sender
            Dim container As GridViewDataItemTemplateContainer = TryCast(lnk.NamingContainer, GridViewDataItemTemplateContainer)
            Dim INo As String = Generic.ToStr(container.Grid.GetRowValues(container.VisibleIndex, New String() {"PayTemplateNo"}))
            PopulateDatab(INo)
            Generic.EnableControls(Me, "pnlPopupDetl", True)
            lnkSaveb.Enabled = True
            mdlDetl.Show()
        Else
            MessageBox.Warning(MessageTemplate.DeniedEdit, Me)
        End If
    End Sub
    Protected Sub lnkDeleteb_Click(sender As Object, e As EventArgs)
        If AccessRights.IsAllowUser(UserNo, AccessRights.EnumPermissionType.AllowDelete) Then
            Dim fieldValues As List(Of Object) = grdPay.GetSelectedFieldValues(New String() {"PayTemplateNo"})
            Dim str As String = "", i As Integer = 0
            For Each item As Integer In fieldValues
                Generic.DeleteRecordAudit("EPayTemplate", UserNo, item)
                i = i + 1
            Next
            MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccessDelete, Me)
            PopulateGridb()
        Else
            MessageBox.Warning(MessageTemplate.DeniedDelete, Me)
        End If
    End Sub
    Protected Sub lnkSaveb_Click(sender As Object, e As EventArgs)
        Dim payclassNo As Integer = Generic.ToInt(cboPayClassNoB.SelectedValue)
        Dim payTemplateNo As Integer = Generic.ToInt(txtPayTemplateNo.Text)
        Dim payScheduleNo As Integer = Generic.ToInt(cboPayScheduleNo.SelectedValue)
        Dim payCateNo As Integer = 2
        Dim paySourceNo As Integer = Generic.ToInt(cboPaySourceNo.SelectedValue)
        Dim isDeductTax = Generic.ToBol(txtIsDeductTax.Checked)
        Dim isDeductSSS = Generic.ToBol(txtIsDeductSSS.Checked)
        Dim isDeductPH = Generic.ToBol(txtIsDeductPH.Checked)
        Dim isDeductHDMF = Generic.ToBol(txtIsDeductHDMF.Checked)

        Dim IsAttendanceBase = Generic.ToBol(txtIsAttendanceBase.Checked)
        Dim IsIncludeForw = Generic.ToBol(txtIsIncludeForw.Checked)
        Dim IsIncludeMass = Generic.ToBol(txtIsIncludeMass.Checked)
        Dim IsIncludeOther = Generic.ToBol(txtIsIncludeOther.Checked)
        Dim IsIncludeLoan = Generic.ToBol(txtIsIncludeLoan.Checked)

        Dim IsRATA As Boolean = False 'Generic.ToBol(txtIsRATA.Checked)
        Dim IsLoyalTy As Boolean = False 'Generic.ToBol(txtIsLoyalty.Checked)
        Dim IsMedical As Boolean = False 'Generic.ToBol(txtIsMedical.Checked)
        Dim IsRice As Boolean = False 'Generic.ToBol(txtIsRice.Checked)

        Dim isDeductPF As Boolean = False 'Generic.ToBol(txtIsDeductPF.Checked)
        Dim isDeductIHP As Boolean = False 'Generic.ToBol(txtIsDeductIHP.Checked)

        Dim RetVal As Boolean = True
        Dim invalid As Boolean = True, messagedialog As String = "", alerttype As String = ""
        Dim dtx As New DataTable

        Dim dt As DataTable, error_num As Integer = 0, error_message As String = ""

        dt = SQLHelper.ExecuteDataTable("EPayTemplate_WebSave", UserNo, payTemplateNo, payclassNo, payScheduleNo, payCateNo, paySourceNo, isDeductTax, isDeductSSS, isDeductPH, isDeductHDMF, IsAttendanceBase, IsIncludeForw, IsIncludeMass, IsIncludeOther, IsIncludeLoan, PayLocNo, IsRATA, IsLoyalTy, IsMedical, IsRice, isDeductPF, isDeductIHP)
        For Each row As DataRow In dt.Rows
            RetVal = True
            error_num = Generic.ToInt(row("Error_num"))
            If error_num > 0 Then
                error_message = Generic.ToStr(row("ErrorMessage"))
                MessageBox.Critical(error_message, Me)
                RetVal = False
            End If

        Next
        If RetVal = False And error_message = "" Then
            MessageBox.Critical(MessageTemplate.ErrorSave, Me)
        End If
        If RetVal = True Then
            PopulateGridb()
            MessageBox.Success(MessageTemplate.SuccessSave, Me)
        End If
    End Sub


    Private Sub PopulateDatab(iNo As Integer)
        Dim dt As DataTable
        dt = SQLHelper.ExecuteDataTable("EPayTemplate_WebOne", UserNo, iNo)
        Generic.PopulateData(Me, "pnlPopupDetl", dt)
        For Each row As DataRow In dt.Rows
            cboPayClassNoB.Text = Generic.ToInt(row("PayClassNo"))
        Next
    End Sub

#End Region


End Class








