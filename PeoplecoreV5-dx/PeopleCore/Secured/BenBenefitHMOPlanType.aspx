﻿<%@ Page Language="VB" AutoEventWireup="false" Theme="PCoreStyle" MasterPageFile="~/MasterPage/MasterPage.master" CodeFile="BenBenefitHMOPlanType.aspx.vb" Inherits="Secured_BenBenefitHMOPlanType" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" Runat="Server">
<br />
<div class="page-content-wrap">         
<div class="row">
        <div class="panel panel-default">
            <div class="panel-heading">
                <div class="col-md-2">
                    <asp:Dropdownlist ID="cboTabNo" AutoPostBack="true" OnSelectedIndexChanged="lnkSearch_Click" CssClass="form-control" runat="server" />
                </div>
                <div>
                    <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                    <ContentTemplate>                    
                        <ul class="panel-controls">
                            <li><asp:LinkButton runat="server" ID="lnkAdd" OnClick="lnkAdd_Click" Text="Add" CssClass="control-primary" /></li>
                            <li><asp:LinkButton runat="server" ID="lnkDelete" OnClick="lnkDelete_Click" Text="Delete" CssClass="control-primary" Visible="false"/></li>
                            <li><asp:LinkButton runat="server" ID="lnkExport" OnClick="lnkExport_Click" Text="Export" CssClass="control-primary" /></li>                    
                        </ul>
                        <uc:ConfirmBox runat="server" ID="cfbDelete" TargetControlID="lnkDelete" ConfirmMessage="Selected items will be permanently deleted and cannot be recovered. Proceed?"  />
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="lnkExport" />
                    </Triggers>
                    </asp:UpdatePanel> 
                </div>                                                                                                   
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="table-responsive">
                        <dx:ASPxGridView ID="grdMain" ClientInstanceName="grdMain" runat="server" SkinID="grdDX" KeyFieldName="BenefitHMOPlanTypeNo">                                                                                   
                            <Columns>
                                <dx:GridViewDataColumn CellStyle-HorizontalAlign="Center" Caption="Edit" HeaderStyle-HorizontalAlign="Center">
                                    <DataItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkEdit" CssClass="fa fa-pencil" Font-Size="Medium" OnClick="lnkEdit_Click" />
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataTextColumn FieldName="Code" Caption="Referrence No." />
                                <dx:GridViewDataTextColumn FieldName="BenefitHMOPlanTypeCode" Caption="Code" />
                                <dx:GridViewDataTextColumn FieldName="BenefitHMOPlanTypeDesc" Caption="Description" /> 
                                <dx:GridViewDataTextColumn FieldName="MBL" Caption="MBL" />
                                <dx:GridViewDataTextColumn FieldName="AddPremiumCost" Caption="Addt'l Premium Cost" />
                                <dx:GridViewDataTextColumn FieldName="PercentCost" Caption="Percentage for Premium Cost" />
                                <dx:GridViewDataCheckColumn FieldName="IsPrincipalPlan" Caption="Principal Plan" /> 
                                <dx:GridViewDataTextColumn FieldName="EncodeBy" Caption="Encoder" />                                                          
                                <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" Caption="Select" />
                            </Columns>                            
                        </dx:ASPxGridView>
                        <dx:ASPxGridViewExporter ID="grdExport" runat="server" GridViewID="grdMain" />
                    </div>
                </div>                                                           
            </div>                   
        </div>
</div>
</div>

    <asp:Button ID="Button1" runat="server" style="display:none" />
    <ajaxtoolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="Button1" PopupControlID="Panel1" CancelControlID="lnkClose" BackgroundCssClass="modalBackground" />
    <asp:Panel id="Panel1" runat="server" CssClass="entryPopup" style="display:none" >
        <fieldset class="form" id="fsMain">                    
            <div class="cf popupheader">
                <h4>&nbsp;</h4>
                <asp:Linkbutton runat="server" ID="lnkClose" CssClass="fa fa-times" ToolTip="Close" />&nbsp;<asp:Linkbutton runat="server" ID="lnkSave" OnClick="lnkSave_Click" CssClass="fa fa-floppy-o submit lnkSave" ToolTip="Save" />
            </div>                                            
            <div class="entryPopupDetl form-horizontal">                        `
                <div class="form-group">
                    <label class="col-md-4 control-label has-space">Transaction No. :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtCode" ReadOnly="true" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-4 control-label has-required">Code :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtBenefitHMOPlanTypeCode" runat="server" CssClass="form-control required" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-4 control-label has-required">Description :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtBenefitHMOPlanTypeDesc" runat="server" CssClass="form-control required" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-4 control-label has-required">Maximum Benefit Limit :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtMBL" runat="server" CssClass="form-control required number" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-4 control-label has-space">Percent Cost :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtPercentCost" runat="server" CssClass="form-control number" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-4 control-label has-space">Addtional Premium Cost :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtAddPremiumCost" runat="server" CssClass="form-control number" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-4 control-label has-space">Remarks :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" />
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="col-md-4 control-label has-space">&nbsp;</label>
                    <div class="col-md-7">
                        <asp:CheckBox runat="server" ID="chkIsPrincipalPlan" Text="&nbsp;Principal PLAN only." />
                    </div>
                </div>
                <div class="form-group">
                <label class="col-md-4 control-label has-space">Company Name :</label>
                    <div class="col-md-7">
                        <asp:Dropdownlist ID="cboPayLocNo" runat="server" CssClass=" number form-control" >
                        </asp:Dropdownlist>
                    </div>
                </div>  
                <div class="form-group">
                    <label class="col-md-4 control-label has-space">&nbsp;</label>
                    <div class="col-md-7">
                        <asp:CheckBox runat="server" ID="chkIsArchived" Text="&nbsp;Archive" />
                    </div>
                </div>                       
                               
            </div>                    
        </fieldset>
    </asp:Panel>   
</asp:Content>

