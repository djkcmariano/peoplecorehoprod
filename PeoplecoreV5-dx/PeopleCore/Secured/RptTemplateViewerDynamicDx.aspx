﻿<%@ Page Language="VB" AutoEventWireup="false" Theme="PCoreStyle" MasterPageFile="~/MasterPage/MasterPage.master" CodeFile="RptTemplateViewerDynamicDx.aspx.vb" Inherits="Secured_rptTemplateViewerDynamic" %>

<%@ Register Assembly="DevExpress.XtraReports.v15.2.Web, Version=15.2.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.XtraReports.Web" TagPrefix="dx" %>

<asp:Content id="Content3" contentplaceholderid="cphBody" runat="server">

<script type="text/javascript">
    function GetRecord(source, eventArgs) {
        document.getElementById('<%= hifNo.ClientID %>').value = eventArgs.get_value();
    }

    function btShowReport_Click(s, e) {
        callbackPanel.PerformCallback();
    }
</script>

    <div class="page-content-wrap">
        <div class="row">
            <div class="panel panel-default">
                <div class="panel-body">
                    <div class="row">
                        <fieldset class="form" id="fsMain">
                            <div  class="form-horizontal">
                                <asp:Panel runat="server" ID="pForm" />
                                <asp:HiddenField runat="server" ID="hifNo" />
                                <br />
                                <div class="form-group">
                                    <label class="col-md-4 control-label has-space">
                                        
                                    </label>
                                    <div class="col-md-6">
                                        <%--<asp:Button runat="server" ID="lnkPreview" CssClass="btn btn-primary submit fsMain" Text="Preview" OnClick="lnkPreview_Click" />--%>
                                        <dx:ASPxButton ID="lnkPreview" runat="server" Text="Preview" AutoPostBack="false" CssClass="btn btn-primary submit fsMain">
                                            <ClientSideEvents Click="btShowReport_Click" />
                                        </dx:ASPxButton>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <dx:ASPxCallbackPanel ID="callbackPanel" runat="server" ClientInstanceName="callbackPanel" Width="100%" oncallback="callbackPanel_Callback">
                <PanelCollection>
                    <dx:PanelContent ID="PanelContent1" runat="server">
                        <asp:Checkbox ID="txtIsView" runat="server" style="visibility:hidden; position:absolute;"></asp:Checkbox> 
                        <dx:ASPxDocumentViewer ID="ASPxDocumentViewer1" runat="server" ToolbarMode="Ribbon" >
                        </dx:ASPxDocumentViewer>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>
        </div>
    </div>

</asp:Content> 

