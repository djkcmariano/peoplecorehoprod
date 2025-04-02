﻿<%@ Page Language="VB" AutoEventWireup="false" Theme="PCoreStyle" MasterPageFile="~/MasterPage/MasterPage.master" CodeFile="BSProjectList.aspx.vb" Inherits="Secured_BSProjectList" EnableEventValidation="false" %>

<asp:Content runat="server" id="Content1" ContentPlaceHolderID="head">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="cphBody" runat="server">

     <script type="text/javascript">
         function cbCheckAll_CheckedChanged(s, e) {
             grdMain.PerformCallback(s.GetChecked().toString());
         }

         function grid_ContextMenu(s, e) {
             if (e.objectType == "row")
                 hiddenfield.Set('VisibleIndex', parseInt(e.index));
             pmRowMenu.ShowAtPos(ASPxClientUtils.GetEventX(e.htmlEvent), ASPxClientUtils.GetEventY(e.htmlEvent));
         }
    </script>

    <br />
    <div class="page-content-wrap" >
        <div class="row">
            <div class="panel panel-default">
                <div class="panel-heading">
                    
                    <div>
                        <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                            <ContentTemplate>
                                <ul class="panel-controls">
                                    <li><asp:LinkButton runat="server" ID="lnkAdd" OnClick="lnkAdd_Click" Text="Add" CssClass="control-primary" /></li>
                                    <li><asp:LinkButton runat="server" ID="lnkDelete" OnClick="lnkDelete_Click" Text="Delete" CssClass="control-primary" /></li>
                                    <li><asp:LinkButton runat="server" ID="lnkExport" OnClick="lnkExport_Click" Text="Export" CssClass="control-primary" /></li>
                                    <uc:ConfirmBox runat="server" ID="cfbDelete" TargetControlID="lnkDelete" ConfirmMessage="Selected items will be permanently deleted and cannot be recovered. Proceed?"  />
                                </ul>
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
                            <dx:ASPxGridView ID="grdMain" ClientInstanceName="grdMain" runat="server" SkinID="grdDX" KeyFieldName="ProjectNo"
                            OnCommandButtonInitialize="grdMain_CommandButtonInitialize" OnCustomCallback="gridMain_CustomCallback"
                            OnFillContextMenuItems="MyGridView_FillContextMenuItems">
                                <Columns>
                                    <dx:GridViewDataColumn CellStyle-HorizontalAlign="Center" Caption="Edit" HeaderStyle-HorizontalAlign="Center">
                                        <DataItemTemplate>
                                            <asp:LinkButton runat="server" ID="lnkEdit" CssClass="fa fa-pencil" Font-Size="Medium" CommandArgument='<%# Bind("ProjectNo") %>' OnClick="lnkEdit_Click" />
                                        </DataItemTemplate>
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataTextColumn FieldName="Code" Caption="Trans No." />
                                    <dx:GridViewDataTextColumn FieldName="ProjectCode" Caption="Project Code" />
                                    <dx:GridViewDataTextColumn FieldName="ProjectDesc" Caption="Project Description" />
                                    <dx:GridViewDataTextColumn FieldName="Details" Caption="Details" />
                                    <dx:GridViewDataComboBoxColumn FieldName="BSActivityDesc" Caption="Activity" />
                                    <dx:GridViewDataComboBoxColumn FieldName="BSClientDesc" Caption="Client Description" />
                                    <dx:GridViewDataComboBoxColumn FieldName="BSCategoryDesc" Caption="Category" />
                                    
                                    <dx:GridViewDataComboBoxColumn FieldName="BSPriorityDesc" Caption="Priority" />
                                    <dx:GridViewDataComboBoxColumn FieldName="BSStatusDesc" Caption="Status"/>
                                    <dx:GridViewDataTextColumn FieldName="BudgetDays" Caption="Budget Per Day" Visible="false" />
                                    <dx:GridViewDataTextColumn FieldName="ProjectCost" Caption="Project Cost" Visible="false" />
                                    <dx:GridViewDataTextColumn FieldName="Notes" Caption="Notes" Visible="false" />
                                    <dx:GridViewDataTextColumn FieldName="Reference" Caption="Client Reference Name" Visible="false" />
                                    <dx:GridViewDataComboBoxColumn FieldName="CostCenterDesc" Caption="CostCenter" Visible="false" />
                                    <dx:GridViewDataComboBoxColumn FieldName="DocDesc" Caption="Document Description" Visible="false" />
                                    <dx:GridViewDataTextColumn FieldName="DocExt" Caption="Document Ext" Visible="false" />
                                    <dx:GridViewDataTextColumn FieldName="TaxRate" Caption="Tax Rate" Visible="false" />
                                    <dx:GridViewDataTextColumn FieldName="ASFRate" Caption="ASF Rate" Visible="false" />
                                    <dx:GridViewDataTextColumn FieldName="Terms" Caption="Terms" Visible="false" />
                                    <dx:GridViewDataTextColumn FieldName="BillingRate" Caption="Billing Rate" Visible="false" />
                                    <dx:GridViewDataDateColumn FieldName="StartDate" Caption="Project Start" Visible="false" />
                                    <dx:GridViewDataDateColumn FieldName="EndDate" Caption="Project End" Visible="false" />
                                    
                                    <dx:GridViewCommandColumn ShowSelectCheckbox="True" Caption="Select" Width="2%">
					                    <HeaderTemplate>
                                            <dx:ASPxCheckBox ID="cbCheckAll" runat="server" OnInit="cbCheckAll_Init" >
                                            </dx:ASPxCheckBox>
                                        </HeaderTemplate>
				                    </dx:GridViewCommandColumn>

                                </Columns>
                                <ClientSideEvents ContextMenu="grid_ContextMenu" />
                            </dx:ASPxGridView>
                            <dx:ASPxGridViewExporter ID="grdExport" runat="server" GridViewID="grdMain" />

                            <dx:ASPxHiddenField ID="hf" runat="server" ClientInstanceName="hiddenfield" />

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>