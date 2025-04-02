﻿<%@ Page Language="VB" AutoEventWireup="false" Theme="PCoreStyle" MasterPageFile="~/MasterPage/MasterPage.master" CodeFile="BSBillingCollection_EditORPay.aspx.vb" Inherits="Secured_BSBillingCollection_EditORPay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content id="Content3" contentplaceholderid="cphBody" runat="server">
<uc:Tab runat="server" ID="Tab" HeaderVisible="true">

<Content>
 <br />
<div class="page-content-wrap">         
    <div class="row">
        <div class="panel panel-default">
            <div class="panel-heading">
                <div class="col-md-2">
                    <h3>&nbsp;</h3>
                </div>
                <div>
                    &nbsp;                  
                </div> 
                <div>                                                
                    <ul class="panel-controls"> 
                        <li><asp:LinkButton runat="server" ID="lnkPaid" OnClick="lnkPaid_Click" Text="Update Payment" CssClass="control-primary" Visible="false" /></li>     
                        <li><asp:LinkButton runat="server" ID="lnkPost" OnClick="lnkPost_Click" Text="Post/Force Paid" CssClass="control-primary" /></li>     
                        <li><asp:LinkButton runat="server" ID="lnkAdd" OnClick="lnkAdd_Click" Text="Add" CssClass="control-primary" /></li>                            
                        <li><asp:LinkButton runat="server" ID="lnkDelete" OnClick="lnkDelete_Click" Text="Delete" CssClass="control-primary" /></li>                                                        
                        <uc:ConfirmBox runat="server" ID="ConfirmBox1" TargetControlID="lnkDelete" ConfirmMessage="Selected items will be permanently deleted and cannot be recovered. Proceed?"  />
                    </ul>                                                                                                                                                     
                </div>
            </div>
            <div class="panel-body">
                <div class="table-responsive">
                    <dx:ASPxGridView ID="grdMain" ClientInstanceName="grdMain" runat="server" SkinID="grdDX" KeyFieldName="BSORPayNo">                                                                                   
                        <Columns>         
                            <dx:GridViewDataColumn CellStyle-HorizontalAlign="Center" Caption="Edit" HeaderStyle-HorizontalAlign="Center">
                                <DataItemTemplate>
                                    <asp:LinkButton runat="server" ID="lnkEdit" CssClass="fa fa-pencil" Font-Size="Medium" CommandArgument='<%# Bind("BSORPayNo") %>' OnClick="lnkEdit_Click" />
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>
                       
                            <dx:GridViewDataTextColumn FieldName="BSORCode" Caption="Transaction No."/>
                            <dx:GridViewDataTextColumn FieldName="InvoiceNo" Caption="Invoice No."/>
                            <dx:GridViewDataTextColumn FieldName="PayrollNo" Caption="Payroll No."/>
                            <dx:GridViewDataTextColumn FieldName="PayClassDesc" Caption="Payroll Group"/>
                            <dx:GridViewDataTextColumn FieldName="PayDate" Caption="Pay Date"/>
                            <dx:GridViewDataTextColumn FieldName="PayPeriod" Caption="Pay Period"/>
                            <dx:GridViewDataTextColumn FieldName="MonthDesc" Caption="Month"/>
                            <dx:GridViewDataTextColumn FieldName="ApplicableYear" Caption="Applicable Year"/>
                            <dx:GridViewDataTextColumn FieldName="TotalBilling" Caption="Total Billing"/>
                            <dx:GridViewDataTextColumn FieldName="PaidAmount" Caption="Paid Amount"/>
                            <dx:GridViewDataTextColumn FieldName="Balance" Caption="Balance"/>
                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" Caption="Select" />       
                            
                        </Columns>                            
                    </dx:ASPxGridView>
                    <dx:ASPxGridViewExporter ID="grdExport" runat="server" GridViewID="grdMain" />                                        
                </div>                            
            </div>
        </div>
    </div>
</div>

</Content>
</uc:Tab>
<br /><br />

<asp:Button ID="btnShow" runat="server" style="display:none" />
<ajaxToolkit:ModalPopupExtender ID="mdlPopupMain" runat="server" BackgroundCssClass="modalBackground" CancelControlID="imgClose" PopupControlID="pnlPopupMain" TargetControlID="btnShow" />
<asp:Panel id="pnlPopupMain" runat="server" CssClass="entryPopup" style="display:none;">
       <fieldset class="form" id="fsMain">
        <!-- Header here -->
         <div class="cf popupheader">
                <h4>&nbsp;</h4>
                <asp:Linkbutton runat="server" ID="imgClose" CssClass="cancel fa fa-times" ToolTip="Close" />&nbsp;
                <asp:LinkButton runat="server" ID="btnSave" CssClass="fa fa-floppy-o submit fsMain btnSave" OnClick="btnSave_Click"  />      
         </div>
         <!-- Body here -->
         <div  class="entryPopupDetl form-horizontal">
            <div class="form-group">
                <label class="col-md-4 control-label">Transaction No. :</label>
                <div class="col-md-7">
                    <asp:TextBox ID="txtBSORPayNo" runat="server" CssClass="form-control" ReadOnly="true" />
                </div>
            </div>
                
            <div class="form-group">
                <label class="col-md-4 control-label has-space-required">Invoice No. :</label>
                <div class="col-md-7">
                    <asp:DropDownList ID="cboBSPayNo" runat="server" CssClass="form-control required" />                    
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label">Total Billing :</label>
                <div class="col-md-7">
                    <asp:TextBox ID="txtTotalBilling" runat="server" CssClass="form-control" ReadOnly="true" Enabled="false" />
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label">Balance :</label>
                <div class="col-md-7">
                    <asp:TextBox ID="txtBalanceD" runat="server" CssClass="form-control" ReadOnly="true" Enabled="false" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-md-4 control-label">Paid Amount :</label>
                <div class="col-md-7">
                    <asp:TextBox ID="txtPaidAmount" runat="server" CssClass="form-control"  />
                </div>
            </div>

            <br />
            <br />
                           
        </div>
        <br />
        </fieldset>
    </asp:Panel>

</asp:Content>
