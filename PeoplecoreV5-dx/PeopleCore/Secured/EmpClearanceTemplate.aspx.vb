Imports clsLib
Imports System.Data
Imports DevExpress.Web

Partial Class Secured_EmpClearanceTemplate
    Inherits System.Web.UI.Page
    Dim UserNo As Integer = 0
    Dim PayLocNo As Integer = 0
    Dim TabNo As Integer = 0
    Protected Sub lnkAdd_Click(sender As Object, e As EventArgs)
        Dim URL As String
        URL = Generic.GetFirstTab(0)
        If URL <> "" Then
            Response.Redirect(URL)
        End If
    End Sub

    Protected Sub lnkEdit_Click(sender As Object, e As EventArgs)
        Dim lnk As New LinkButton
        lnk = sender
        Dim URL As String
        Dim container As GridViewDataItemTemplateContainer = TryCast(lnk.NamingContainer, GridViewDataItemTemplateContainer)
        URL = Generic.GetFirstTab(Generic.ToInt(container.Grid.GetRowValues(container.VisibleIndex, New String() {"ClearanceTemplateNo"})))
        If URL <> "" Then
            Response.Redirect(URL)
        End If
    End Sub


    'Protected Sub lnkDelete_Click(sender As Object, e As EventArgs)

    'End Sub

    Protected Sub cboTabNo_SelectedIndexChanged(sender As Object, e As EventArgs)
        PopulateGrid()
    End Sub

    Private Sub PopulateDropDown()
        Try
            cboTabNo.DataSource = SQLHelper.ExecuteDataSet("ETab_WebLookup", UserNo, 14)
            cboTabNo.DataTextField = "tDesc"
            cboTabNo.DataValueField = "tno"
            cboTabNo.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        UserNo = Generic.ToInt(Session("OnlineUserNo"))
        PayLocNo = Generic.ToInt(Session("xPayLocNo"))
        AccessRights.CheckUser(UserNo)

        If Not IsPostBack Then
            PopulateDropDown()
            PopulateGrid()
        End If
    End Sub

    Private Sub PopulateGrid()

        lnkAdd.Enabled = True
        'lnkDelete.Enabled = True

        If TabNo = 0 Then
            TabNo = 1
        End If

        If TabNo <> 1 Then
            lnkAdd.Enabled = False
            'lnkDelete.Enabled = False            
        End If

        Dim _dt As DataTable
        _dt = SQLHelper.ExecuteDataTable("EClearanceTemplate_Web", UserNo, PayLocNo, Generic.ToInt(cboTabNo.SelectedValue))
        Me.grdMain.DataSource = _dt
        Me.grdMain.DataBind()

    End Sub

End Class
