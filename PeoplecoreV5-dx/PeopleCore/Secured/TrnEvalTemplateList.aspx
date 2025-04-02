﻿<%@ Page Title="" Theme="PCoreStyle" Language="VB" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="false" CodeFile="TrnEvalTemplateList.aspx.vb" Inherits="Secured_TrnEvalTemplateList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" Runat="Server">
    <uc:Tab runat="server" ID="Tab">
        <Header>
            <asp:Label runat="server" ID="lbl" /> 
        </Header>
        <Content>
        <br />
        <div class="page-content-wrap">         
            <div class="row">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="col-md-2">
                    
                        </div>
                        <div>
                            <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                            <ContentTemplate>                    
                                <ul class="panel-controls">
                                    <li><asp:LinkButton runat="server" ID="lnkAdd" OnClick="lnkAdd_Click" Text="Add" CssClass="control-primary" /></li>
                                    <li><asp:LinkButton runat="server" ID="lnkDelete" OnClick="lnkDelete_Click" Text="Delete" CssClass="control-primary" /></li>
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
                                <dx:ASPxGridView ID="grdMain" ClientInstanceName="grdMain" runat="server" SkinID="grdDX" KeyFieldName="TrnEvalTemplateNo">                                                                                   
                                    <Columns>
                                        <dx:GridViewDataColumn CellStyle-HorizontalAlign="Center" Caption="Edit" HeaderStyle-HorizontalAlign="Center">
                                                <DataItemTemplate>
                                                    <asp:LinkButton runat="server" ID="lnkEdit" CssClass="fa fa-pencil" Font-Size="Medium" OnClick="lnkEdit_Click" />
                                                </DataItemTemplate>
                                            </dx:GridViewDataColumn>                            
                                        <dx:GridViewDataTextColumn FieldName="Code" Caption="Transaction No." />
                                        <dx:GridViewDataTextColumn FieldName="EvalTemplateDesc" Caption="Evaluation Template" />                                                                           
                                        <dx:GridViewDataTextColumn FieldName="TrnEvalTypeDesc" Caption="Evalution Type" /> 
                                        <dx:GridViewDataTextColumn FieldName="TrnEvaluatorDesc" Caption="Evaluator" Visible="false" />                                                                                                                                                                         
                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" Caption="Select" />
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
            <ajaxtoolkit:ModalPopupExtender ID="mdlMain" runat="server" TargetControlID="Button1" PopupControlID="Panel1" CancelControlID="lnkClose" BackgroundCssClass="modalBackground" />
            <asp:Panel id="Panel1" runat="server" CssClass="entryPopup" style="display:none;">
                <fieldset class="form" id="fsMain">                    
                    <div class="cf popupheader">
                        <h4>&nbsp;</h4>
                        <asp:Linkbutton runat="server" ID="lnkClose" CssClass="fa fa-times" ToolTip="Close" />&nbsp;<asp:Linkbutton runat="server" ID="lnkSave" OnClick="lnkSave_Click" CssClass="fa fa-floppy-o submit lnkSave" ToolTip="Save" />
                    </div>                                            
                    <div class="entryPopupDetl form-horizontal">       
                        <div class="form-group" style="display:none;">
                            <label class="col-md-4 control-label has-space">Transaction No. :</label>
                            <div class="col-md-7">
                                <asp:Textbox ID="txtTrnEvalTemplateNo" ReadOnly="true" runat="server" CssClass="form-control" />
                            </div>
                        </div>
                                         
                        <div class="form-group">
                            <label class="col-md-4 control-label has-space">Transaction No. :</label>
                            <div class="col-md-7">
                                <asp:Textbox ID="txtCode" ReadOnly="true" runat="server" CssClass="form-control" Placeholder="Autonumber" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-4 control-label has-required">Evaluation Template :</label>
                            <div class="col-md-7">
                                <asp:Dropdownlist ID="cboEvalTemplateNo" runat="server" CssClass="form-control required" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-4 control-label has-required">Evaluation Type :</label>
                            <div class="col-md-7">
                                <asp:Dropdownlist ID="cboTrnEvalTypeNo" DataMember="ETrnEvalType" runat="server" CssClass="form-control required" />
                            </div>
                        </div>

                         <div class="form-group" style="display:none;">
                            <label class="col-md-4 control-label has-space">Evaluator :</label>
                            <div class="col-md-7">
                                <asp:Dropdownlist ID="cboTrnEvaluatorNo" DataMember="ETrnEvaluator" runat="server" CssClass="form-control" />
                            </div>
                        </div>


                    </div>                    
                </fieldset>
            </asp:Panel>

        </Content>
    </uc:Tab>
</asp:Content>

