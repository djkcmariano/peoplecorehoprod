﻿<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EmpPlantillaHierarchyChart.aspx.vb" Inherits="Secured_EmpPlantillaHierarchyChart" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>    
    <style type="text/css">
                  
        body
        {
            font-family:Arial;                        
            font-size:.6em;                                                                                       
        }
                  
    </style>       
</head>
<body>
<form id="form1" runat="server">
<asp:ScriptManager runat="server" ID="ScriptManager1" />
<asp:UpdatePanel runat="server" ID="UpdatePanel1">
<ContentTemplate>

<div id="page-content-wrap-id" class="panel-body table-responsive">
    <div class="page-content-wrap">               
        <div class="row text-center">        
            <h2><asp:Label runat="server" ID="lbl" /></h2>
        </div>
        <div class="row">
            <asp:DataBoundOrganisationChart runat="server" ID="DataBoundOrganisationChart1" ChartItem-AutoGenerateFields="false" EnableSmartDraw="false" ShowFrame="false" NoDataHtml="Organizational chart not available." AssistantItem-AssistantField="IsHeadStaff">
                <DetailedTemplate>        
                        <%#Container.DataElement("Content")%>
                </DetailedTemplate>
                <AssistantTemplate>
                    <%#Container.DataElement("Content")%>
                </AssistantTemplate>                                                                
            </asp:DataBoundOrganisationChart>           
            <br /><br />        
        </div>
    </div>
</div>
</ContentTemplate>
</asp:UpdatePanel>
</form>
</body>
</html>
