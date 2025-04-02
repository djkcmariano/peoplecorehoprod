﻿Imports clsLib
Imports System.Data
Partial Class Secured_PayLastEdit
    Inherits System.Web.UI.Page
    Dim UserNo As Integer = 0
    Dim PayLocNo As Integer = 0
    Dim TransNo As Integer = 0

    Protected Sub btnModify_Click(sender As Object, e As EventArgs)
        If AccessRights.IsAllowUser(UserNo, AccessRights.EnumPermissionType.AllowEdit, "PayLeaveList.aspx") Then
            If txtIsposted.Checked = True Then
                MessageBox.Information(MessageTemplate.PostedTransaction, Me)
            Else
                ViewState("IsEnabled") = True
                EnabledControls()
            End If
        Else
            MessageBox.Information(MessageTemplate.DeniedEdit, Me)
        End If
    End Sub
    Private Sub PopulateData()
        Dim dt As DataTable
        dt = SQLHelper.ExecuteDataTable("EPay_WebOne", UserNo, TransNo)
        For Each row As DataRow In dt.Rows
            Generic.PopulateData(Me, "Panel1", dt)
        Next
    End Sub

    Private Sub PopulateCombo()
        Generic.PopulateDropDownList(UserNo, Me, "Panel1", PayLocNo)
        Try
            cboPayClassNo.DataSource = SQLHelper.ExecuteDataSet("EPayClass_WebLookup", UserNo, Session("xPayLocNo"))
            cboPayClassNo.DataTextField = "tdesc"
            cboPayClassNo.DataValueField = "tno"
            cboPayClassNo.DataBind()
        Catch ex As Exception

        End Try
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        UserNo = Generic.ToInt(Session("OnlineUserNo"))
        TransNo = Generic.ToInt(Request.QueryString("id"))
        PayLocNo = Generic.ToInt(Session("xPayLocNo"))
        AccessRights.CheckUser(UserNo, "PayLeaveList.aspx")

        If Not IsPostBack Then
            Generic.PopulateDropDownList(UserNo, Me, "Panel1", Generic.ToInt(Session("xPayLocNo")))
            PopulateCombo()
            PopulateData()
            PopulateTabHeader()
        End If

        EnabledControls()

    End Sub

    Private Sub EnabledControls()
        If TransNo = 0 Then : ViewState("IsEnabled") = True : End If
        Dim Enabled As Boolean = Generic.ToBol(ViewState("IsEnabled"))

        If Generic.ToBol(txtIsposted.Checked) = True Then
            Enabled = False
        End If

        Generic.EnableControls(Me, "Panel1", Enabled)

        cboApplicableMonth.Enabled = False
        txtApplicableYear.Enabled = False
        txtPayperiod.Enabled = False

        btnModify.Visible = Not Enabled
        btnSave.Visible = Enabled
    End Sub

    Private Sub PopulateTabHeader()
        Try
            Dim dt As DataTable
            dt = SQLHelper.ExecuteDataTable("EPay_WebTabHeader", UserNo, TransNo)
            For Each row As DataRow In dt.Rows
                lbl.Text = Generic.ToStr(row("Display"))
            Next
        Catch ex As Exception

        End Try
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)

        If AccessRights.IsAllowUser(UserNo, AccessRights.EnumPermissionType.AllowEdit, "PayLeaveList.aspx") Then
            Dim RetVal As Boolean = False
            Dim dt As DataTable
            Dim PayNo As Integer = Generic.ToInt(Me.txtPayNo.Text)
            Dim StartDate As String = Generic.ToStr(Me.txtStartDate.Text)
            Dim EndDate As String = Generic.ToStr(Me.txtEndDate.Text)
            Dim PayDate As String = Generic.ToStr(Me.txtPayDate.Text)
            Dim PayClassNo As Integer = Generic.ToInt(Me.cboPayClassNo.SelectedValue)
            Dim PayCateNo As Integer = 3
            Dim IsDeductTax As Boolean = Generic.ToBol(Me.txtIsDeductTax.Checked)
            Dim IsIncludeForw As Boolean = Generic.ToBol(Me.txtIsIncludeForw.Checked)
            Dim IsIncludeLoan As Boolean = Generic.ToBol(Me.txtIsIncludeLoan.Checked)
            Dim IsActivateDed As Boolean = 0
            Dim IsPaymentSuspended As Boolean = Generic.ToBol(Me.txtIsPaymentSuspended.Checked)
            Dim IsIncludeOther As Boolean = Generic.ToBol(Me.txtIsIncludeOther.Checked)
            Dim IsIncludeMass As Boolean = Generic.ToBol(Me.txtIsIncludeMass.Checked)
            Dim BaseDateNo As Integer = 0
            Dim BonusTypeNo As Integer = 0
            Dim PayPeriod As Integer = Generic.ToInt(Me.txtPayperiod.Text)
            Dim ApplicableYear As Integer = Generic.ToInt(Me.txtApplicableYear.Text)
            Dim ApplicableMonth As Integer = Generic.ToInt(Me.cboApplicableMonth.Text)
            Dim PEPeriodNo As Integer = 0
            Dim noofmonthstoAssume As Double = 0
            Dim IsAdvancedCredits As Boolean = Generic.ToBol(Me.txtIsAdvancedCredits.Checked)
            Dim PayTypeNo As Integer = Generic.ToInt(Me.cboPayTypeNo.SelectedValue)
            Dim percentTax As Double = Generic.ToDbl(txtPercentTax.Text)

            '//validate start here
            Dim invalid As Boolean = True, messagedialog As String = "", alerttype As String = ""
            Dim dtx As New DataTable
            dtx = SQLHelper.ExecuteDataTable("EPayLeave_WebValidate", UserNo, PayNo, StartDate, EndDate,
                                     PayDate, PayClassNo, PayCateNo, IsDeductTax, IsIncludeForw,
                                     IsIncludeLoan, IsPaymentSuspended, IsIncludeOther, IsIncludeMass, IsAdvancedCredits, PayTypeNo, PayLocNo)

            For Each rowx As DataRow In dtx.Rows
                invalid = Generic.ToBol(rowx("tProceed"))
                messagedialog = Generic.ToStr(rowx("xMessage"))
                alerttype = Generic.ToStr(rowx("AlertType"))
            Next

            If invalid = True Then
                MessageBox.Alert(messagedialog, alerttype, Me)
                Exit Sub
            End If

            dt = SQLHelper.ExecuteDataTable("EPayLeave_WebSave", UserNo, PayNo, StartDate, EndDate,
                                     PayDate, PayClassNo, PayCateNo, IsDeductTax, IsIncludeForw,
                                     IsIncludeLoan, IsPaymentSuspended, IsIncludeOther, IsIncludeMass, IsAdvancedCredits, PayTypeNo, PayLocNo, percentTax)

            For Each row As DataRow In dt.Rows
                TransNo = Generic.ToInt(row("PayNo"))
                RetVal = True
            Next

            If RetVal = True Then
                If Generic.ToInt(Request.QueryString("id")) = 0 Then
                    Dim url As String = "PayLeaveEntitleList.aspx?id=" & TransNo
                    MessageBox.SuccessResponse(MessageTemplate.SuccessSave, Me, url)
                Else
                    MessageBox.Success(MessageTemplate.SuccessSave, Me)
                    ViewState("IsEnabled") = False
                    PopulateData()
                    EnabledControls()
                End If
                'PopulateTabHeader()
            Else
                MessageBox.Warning(MessageTemplate.ErrorSave, Me)
            End If

        Else
            MessageBox.Information(MessageTemplate.DeniedEdit, Me)
        End If

    End Sub
    Protected Sub cboPaySchedule_TextChanged(sender As Object, e As EventArgs)
        Try
            Dim dt As DataTable
            Dim paycateno As Integer = 3
            Dim paySourceNo As Integer = 0
            Dim payClassNo As Integer = Generic.ToInt(Me.cboPayClassNo.SelectedValue)
            Dim payScheduleNo As Integer = 0


            txtIsDeductTax.Checked = False
            txtIsIncludeForw.Checked = False
            txtIsIncludeLoan.Checked = False
            txtIsIncludeMass.Checked = False
            txtIsIncludeOther.Checked = False

            'dt = SQLHelper.ExecuteDataTable("EPayContributionSchedule_WebSP", Generic.ToInt(Me.cboPayScheduleNo.SelectedValue), Generic.ToInt(Me.cboPayClassNo.SelectedValue))
            dt = SQLHelper.ExecuteDataTable("EPayTemplate_Web_Select", UserNo, paycateno, paySourceNo, payClassNo, payScheduleNo)
            For Each row As DataRow In dt.Rows
                txtIsDeductTax.Checked = Generic.ToBol(row("IsDeductTax"))
                txtIsIncludeForw.Checked = Generic.ToBol(row("IsIncludeForw"))
                txtIsIncludeLoan.Checked = Generic.ToBol(row("IsIncludeLoan"))
                txtIsIncludeMass.Checked = Generic.ToBol(row("IsIncludeMass"))
                txtIsIncludeOther.Checked = Generic.ToBol(row("IsIncludeOther"))
            Next

        Catch ex As Exception

        End Try

    End Sub
End Class
