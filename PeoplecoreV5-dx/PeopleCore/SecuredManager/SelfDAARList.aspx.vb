﻿Imports System.Data
Imports System.Math
Imports System.Threading
Imports clsLib
Imports DevExpress.Web
Imports DevExpress.XtraPrinting
Imports DevExpress.Export

Partial Class Secured_ERDAARList
    Inherits System.Web.UI.Page

    Dim clsArray As New clsBase.clsArray
    Dim xScript As String = ""

    Dim UserNo As Integer = 0
    Dim PayLocNo As Integer = 0


    Private Sub PopulateGrid(Optional IsMain As Boolean = False, Optional ByVal SortExp As String = "", Optional ByVal sordir As String = "")
        lnkPost.Visible = False
        lnkCancel.Visible = False
        lnkReceived.Visible = False

        Dim tabOrderNo As String = "", tstatus As Integer = 0

        tabOrderNo = Generic.ToStr(cboTabNo.SelectedValue)
        If tabOrderNo = "" Then
            tstatus = 1
        Else
            tstatus = CInt(tabOrderNo)
        End If

        Dim _dt As DataTable
        _dt = SQLHelper.ExecuteDataTable("EDAAR_WebManager", UserNo, PayLocNo, Generic.ToInt(cboTabNo.SelectedValue))
        Me.grdMain.DataSource = _dt
        Me.grdMain.DataBind()

        Session(xScript & "TabNo") = tabOrderNo
    End Sub

    Private Sub PopulateGridDetl()
        Try
            Dim dt As DataTable
            dt = SQLHelper.ExecuteDataTable("EDAARDetl_Web", UserNo, Generic.ToInt(ViewState("DAARNo")))
            grdDetl.DataSource = dt
            grdDetl.DataBind()
            If Len(Generic.ToStr(ViewState("DAARCode"))) > 0 Then
                lblDetl.Text = "Transaction No. : " & Generic.ToStr(ViewState("DAARCode"))
            Else
                lblDetl.Text = ""
            End If
        Catch ex As Exception

        End Try
    End Sub


    Private Sub PopulateCombo()
        Generic.PopulateDropDownList_Self(UserNo, Me, "Panel1", PayLocNo)

        Try
            cboTabNo.DataSource = SQLHelper.ExecuteDataSet("ETab_WebLookup", UserNo, 16)
            cboTabNo.DataValueField = "tNo"
            cboTabNo.DataTextField = "tDesc"
            cboTabNo.DataBind()

        Catch ex As Exception
        End Try

    End Sub

    Private Sub PopulateData(id As Integer)
        Dim dt As DataTable
        dt = SQLHelper.ExecuteDataTable("EDAARDetl_WebOne", UserNo, id)
        Generic.PopulateData(Me, "Panel2", dt)
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        UserNo = Generic.ToInt(Session("OnlineUserNo"))
        PayLocNo = Generic.ToInt(Session("xPayLocNo"))
        Permission.IsAuthenticatedSuperior()

        clsArray.myPage.Pagename = Request.ServerVariables("SCRIPT_NAME")
        clsArray.myPage.Pagename = clsArray.GetPath(clsArray.myPage.Pagename)
        xScript = clsArray.myPage.Pagename

        If Not IsPostBack Then
            cboTabNo.Text = Generic.ToStr(Session(xScript & "TabNo"))
            PopulateCombo()
        End If

        PopulateGrid()
        'PopulateGridDetl()
        Generic.PopulateDXGridFilter(grdMain, UserNo, PayLocNo)

    End Sub
#Region "MAIN"



    Protected Sub lnkEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim lnk As New LinkButton
        lnk = sender
        Dim container As GridViewDataItemTemplateContainer = TryCast(lnk.NamingContainer, GridViewDataItemTemplateContainer)
        Response.Redirect("~/securedmanager/SelfDAAREdit.aspx?id=" & container.Grid.GetRowValues(container.VisibleIndex, New String() {"DAARNo"}))
       

    End Sub
    

    Protected Sub lnkDetails_Click(sender As Object, e As EventArgs)
        Dim lnk As New LinkButton
        lnk = sender
        Dim container As GridViewDataItemTemplateContainer = TryCast(lnk.NamingContainer, GridViewDataItemTemplateContainer)
        Dim obj As Object() = container.Grid.GetRowValues(container.VisibleIndex, New String() {"DAARNo", "Code"})
        ViewState("DAARNo") = Generic.ToStr(obj(0))
        ViewState("DAARCode") = Generic.ToStr(obj(1))
        PopulateGridDetl()
    End Sub


    Protected Sub lnkAdd_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("~/securedmanager/SelfDAAREdit.aspx?id=0")
    End Sub

    Protected Sub lnkDelete_Click(sender As Object, e As EventArgs)

        Dim fieldValues As List(Of Object) = grdMain.GetSelectedFieldValues(New String() {"DAARNo"})
        Dim i As Integer = 0
        For Each item As Integer In fieldValues
            Generic.DeleteRecordAuditCol("EDAARDetl", UserNo, "DAARNo", item)
            Generic.DeleteRecordAudit("EDAAR", UserNo, item)
            i = i + 1
        Next
        MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccessDelete, Me)
        PopulateGrid()

    End Sub
    

    Protected Sub lnkPost_Click(sender As Object, e As EventArgs)

        Dim fieldValues As List(Of Object) = grdMain.GetSelectedFieldValues(New String() {"DAARNo"})
        Dim i As Integer = 0
        For Each item As Integer In fieldValues
            SQLHelper.ExecuteNonQuery("EDAAR_WebPost", UserNo, item)
            i = i + 1
        Next
        MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccesPost, Me)
        PopulateGrid()

    End Sub
    Protected Sub lnkReceived_Click(sender As Object, e As EventArgs)

        Dim fieldValues As List(Of Object) = grdMain.GetSelectedFieldValues(New String() {"DAARNo"})
        Dim i As Integer = 0
        For Each item As Integer In fieldValues
            SQLHelper.ExecuteNonQuery("EDAAR_WebReceived", UserNo, item)
            i = i + 1
        Next
        MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccesPost, Me)
        PopulateGrid()

    End Sub
    Protected Sub lnkCancel_Click(sender As Object, e As EventArgs)

        Dim fieldValues As List(Of Object) = grdMain.GetSelectedFieldValues(New String() {"DAARNo"})
        Dim i As Integer = 0
        For Each item As Integer In fieldValues
            SQLHelper.ExecuteNonQuery("EDAAR_WebCancel", UserNo, item)
            i = i + 1
        Next
        MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccesPost, Me)
        PopulateGrid()

    End Sub
 
    Protected Sub lnkExport_Click(sender As Object, e As EventArgs)
        Try
            grdExport.WriteXlsxToResponse(New XlsxExportOptionsEx With {.ExportType = ExportType.WYSIWYG})
        Catch ex As Exception
            MessageBox.Warning("Error exporting to excel file.", Me)
        End Try
    End Sub

    Protected Sub lnkSearch_Click(sender As Object, e As EventArgs)
        PopulateGrid()
    End Sub

    Protected Sub grdMain_CommandButtonInitialize(sender As Object, e As DevExpress.Web.ASPxGridViewCommandButtonEventArgs) Handles grdMain.CommandButtonInitialize
        If e.ButtonType = ColumnCommandButtonType.SelectCheckbox Then
            Dim value As Boolean = Generic.ToInt(grdMain.GetRowValues(e.VisibleIndex, "IsEnabled"))
            e.Enabled = value
        End If
    End Sub


#End Region

#Region "Detail"
    


    Protected Sub lnkAddD_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        Generic.ClearControls(Me, "Panel2")
        mdlDetl.Show()


    End Sub
    Protected Sub lnkEditD_Click(ByVal sender As Object, ByVal e As System.EventArgs)
      

        Dim lnk As New LinkButton
        lnk = sender
        Dim container As GridViewDataItemTemplateContainer = TryCast(lnk.NamingContainer, GridViewDataItemTemplateContainer)
        PopulateData(container.Grid.GetRowValues(container.VisibleIndex, New String() {"DAARNo"}))
        mdlDetl.Show()

    End Sub
    Protected Sub lnkDeleteD_Click(sender As Object, e As EventArgs)

        Dim fieldValues As List(Of Object) = grdDetl.GetSelectedFieldValues(New String() {"DAARDetlNo"})
        Dim i As Integer = 0

        For Each item As Integer In fieldValues
            Generic.DeleteRecordAudit("EDAARDetl", UserNo, item)
            i = i + 1
        Next
        MessageBox.Success("(" + i.ToString + ") " + MessageTemplate.SuccessDelete, Me)
        PopulateGrid()
 
    End Sub

    'Submit record
    Protected Sub btnSaveDetl_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        If SaveRecordDetl() Then
            MessageBox.Success(MessageTemplate.SuccessSave, Me)
            PopulateGridDetl()
        Else
            MessageBox.Critical(MessageTemplate.ErrorSave, Me)
        End If
    End Sub


    Private Function SaveRecordDetl() As Boolean
        Dim employeeno As Integer = Generic.CheckDBNull(hifEmployeeNo.Value, clsBase.clsBaseLibrary.enumObjectType.IntType)
        Dim departmentno As Integer = Generic.CheckDBNull(Me.cboDepartmentNo.SelectedValue, clsBase.clsBaseLibrary.enumObjectType.IntType)
        Dim present As String = Generic.CheckDBNull(Me.txtPresentAddress.Text, clsBase.clsBaseLibrary.enumObjectType.StrType)
        Dim permanent As String = Generic.CheckDBNull(Me.txtPermanentAddress.Text, clsBase.clsBaseLibrary.enumObjectType.StrType)
        Dim remarks As String = Generic.CheckDBNull(Me.txtRemarks.Text, clsBase.clsBaseLibrary.enumObjectType.StrType)

        If SQLHelper.ExecuteNonQuery("EDAARDetl_WebSave", UserNo, ViewState("DAARNo"), Generic.ToInt(txtCodeDeti.Text), employeeno, departmentno, present, permanent, remarks) > 0 Then
            SaveRecordDetl = True
        Else
            SaveRecordDetl = False
        End If
    End Function
    Protected Sub lnkExportD_Click(sender As Object, e As EventArgs)
        Try
            grdExportD.WriteXlsxToResponse(New XlsxExportOptionsEx With {.ExportType = ExportType.WYSIWYG})
        Catch ex As Exception
            MessageBox.Warning("Error exporting to excel file.", Me)
        End Try
    End Sub
    'Protected Sub lnkPrint_PreRender(ByVal sender As Object, ByVal e As EventArgs)
    '    Dim lnk As LinkButton = TryCast(sender, LinkButton)
    '    Dim NewScriptManager As ScriptManager = ScriptManager.GetCurrent(Me.Page)
    '    NewScriptManager.RegisterPostBackControl(lnk)
    'End Sub

    Private Sub fRegisterStartupScript(key As String, script As String)
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), key, script, True)
    End Sub
    <System.Web.Script.Services.ScriptMethod()> _
    <System.Web.Services.WebMethod()> _
    Public Shared Function cboEmployee(prefixText As String, count As Integer, contextKey As String) As List(Of String)
        Dim items As New List(Of String)()
        Dim ds As New DataSet()
        Dim UserNo As Integer = 0, payLocno As Integer = 0
        UserNo = (HttpContext.Current.Session("onlineuserno"))
        payLocno = (HttpContext.Current.Session("xPayLocNo"))
        Dim payclassNo As Integer = (HttpContext.Current.Session("PayLastList_PayclassNo"))

        ds = SQLHelper.ExecuteDataSet("EEmployee_WebLookup_AC_PayClass", UserNo, prefixText, payclassNo, payLocno, count)
        For Each row As DataRow In ds.Tables(0).Rows
            Dim item As String = AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem((row("tDesc")), (row("tNo")))
            items.Add(item)
        Next
        ds.Dispose()
        Return items
    End Function

#End Region


#Region "print"

    Protected Sub lnkPrint_PreRender(ByVal sender As Object, ByVal e As EventArgs)
        Dim lnk As LinkButton = TryCast(sender, LinkButton)
        Dim NewScriptManager As ScriptManager = ScriptManager.GetCurrent(Me.Page)
        NewScriptManager.RegisterPostBackControl(lnk)
    End Sub

    Protected Sub lnkPrint_Click(sender As Object, e As EventArgs)
        Dim lnk As New LinkButton
        Dim sb As New StringBuilder
        lnk = sender

        Dim param As String = Generic.ReportParam(New ReportParameter(ReportParameter.Type.int, Generic.ToInt(lnk.CommandArgument)))
        sb.Append("<script>")
        sb.Append("window.open('RptTemplateViewerDX.aspx?reportno=432&param=" & param & "','_blank','toolbars=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=yes');")
        sb.Append("</script>")
        ClientScript.RegisterStartupScript(e.GetType, "test", sb.ToString())
    End Sub
#End Region


End Class



