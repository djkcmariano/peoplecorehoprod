﻿Imports System.Data
Imports clsLib

Partial Class Secured_SelfPEReviewForm
    Inherits System.Web.UI.Page
    Dim UserNo As Integer
    Dim TransNo As Integer
    Dim PayLocNo As Integer

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Permission.IsAuthenticated()
    End Sub

    

End Class
