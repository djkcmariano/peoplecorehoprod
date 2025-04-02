﻿<%@ Page Language="VB" AutoEventWireup="false" Theme="PCoreStyle" MasterPageFile="~/MasterPage/masterpage.master" CodeFile="BenBenefitPackageList.aspx.vb" Inherits="Secured_SecCMSTemplateList" EnableEventValidation="false" %>


<asp:content id="Content3" contentplaceholderid="cphBody" runat="server">

<div class="page-content-wrap">         
    <div class="row">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="col-md-2">                    
                        <asp:Dropdownlist ID="cboTabNo" AutoPostBack="true" OnSelectedIndexChanged="lnkSearch_Click" CssClass="form-control"  runat="server" />            
                    </div>
                    <div>
                    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
                        <ContentTemplate>                    
                            <ul class="panel-controls">
                                <li><asp:LinkButton runat="server" ID="lnkAdd" OnClick="lnkAdd_Click" Text="Add" CssClass="control-primary" /></li>
                                <li><asp:LinkButton runat="server" ID="lnkDelete" OnClick="lnkDelete_Click" Text="Delete" CssClass="control-primary" Visible="false" /></li>
                                <li><asp:LinkButton runat="server" ID="lnkArchive" OnClick="lnkArchive_Click" Text="Archive" CssClass="control-primary" /></li>
                                <li><asp:LinkButton runat="server" ID="lnkExport" OnClick="lnkExport_Click" Text="Export" CssClass="control-primary" /></li>
                            </ul> 
                            <uc:ConfirmBox runat="server" ID="cfbDelete" TargetControlID="lnkDelete" ConfirmMessage="Selected items will be permanently deleted and cannot be recovered. Proceed?"  />    
                            <uc:ConfirmBox runat="server" ID="cfbArchive" TargetControlID="lnkArchive" ConfirmMessage="Are you sure you want to archive selected item(s)?"  />                                               
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
                        <dx:ASPxGridView ID="grdMain" ClientInstanceName="grdMain" runat="server" SkinID="grdDX" KeyFieldName="BenefitPackageNo" 
                        OnCommandButtonInitialize="grdMain_CommandButtonInitialize" OnCustomCallback="gridMain_CustomCallback">                                                                                   
                            <Columns>
                                <dx:GridViewDataColumn CellStyle-HorizontalAlign="Center" Caption="Edit" HeaderStyle-HorizontalAlign="Center">
                                        <DataItemTemplate>
                                            <asp:LinkButton runat="server" ID="lnkEdit" CssClass="fa fa-pencil" Font-Size="Medium" OnClick="lnkEdit_Click" />
                                        </DataItemTemplate>
                                    </dx:GridViewDataColumn>                            
                                <dx:GridViewDataTextColumn FieldName="Code" Caption="Reference No." />
                                <dx:GridViewDataTextColumn FieldName="BenefitPackageCode" Caption="Code" />                                                                           
                                <dx:GridViewDataTextColumn FieldName="BenefitPackageDesc" Caption="Description" />                                                                                                
                                <dx:GridViewDataTextColumn FieldName="EncodeBy" Caption="Encoder"/>   
                                <dx:GridViewDataColumn CellStyle-HorizontalAlign="Center" Caption="Details" HeaderStyle-HorizontalAlign="Center">
                                        <DataItemTemplate>
                                            <asp:LinkButton runat="server" ID="lnkDetail" CssClass="fa fa-list" Font-Size="Medium" OnClick="lnkDetail_Click" />
                                        </DataItemTemplate>
                                    </dx:GridViewDataColumn>                    
                                    <dx:GridViewCommandColumn ShowSelectCheckbox="True" Caption="Select" Width="2%">
					                    <HeaderTemplate>
                                            <dx:ASPxCheckBox ID="cbCheckAll" runat="server" OnInit="cbCheckAll_Init" >
                                            </dx:ASPxCheckBox>
                                        </HeaderTemplate>
				                    </dx:GridViewCommandColumn>
                            </Columns>                            
                        </dx:ASPxGridView>
                        <dx:ASPxGridViewExporter ID="grdExport" runat="server" GridViewID="grdMain" />
                    </div>
                </div>                                                           
            </div>   
                   
            </div>
       </div>       
    <div class="row">
        <div class="panel panel-default">
            <div class="panel-heading">
                <div class="col-md-6 panel-title">
                    Reference No. : <asp:Label ID="lblDetl" runat="server"></asp:Label>
                </div>
                <asp:UpdatePanel runat="server" ID="UpdatePanel2">
                    <ContentTemplate>
                        <ul class="panel-controls">
                            <li><asp:LinkButton runat="server" ID="lnkAddDetl" OnClick="lnkAddDetl_Click" Text="Add" CssClass="control-primary" /></li>                                                    
                            <li><asp:LinkButton runat="server" ID="lnkDeleteDetl" OnClick="lnkDeleteDetl_Click" Text="Delete" CssClass="control-primary" /></li>
                            <li><asp:LinkButton runat="server" ID="lnkExportDetl" OnClick="lnkExportDetl_Click" Text="Export" CssClass="control-primary" /></li>
                        </ul>
                        <uc:ConfirmBox runat="server" ID="cfbDeleteDetl" TargetControlID="lnkDeleteDetl" ConfirmMessage="Selected items will be permanently deleted and cannot be recovered. Proceed?"  />
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="lnkExportDetl" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="table-responsive">
                        <dx:ASPxGridView ID="grdDetl" ClientInstanceName="grdDetl" runat="server" Width="100%" KeyFieldName="BenefitPackageDetiNo"
                        OnCustomCallback="grdDetl_CustomCallback" OnCustomColumnSort="grdDetl_CustomColumnSort" OnCustomColumnDisplayText="grdDetl_CustomColumnDisplayText">                                                                                   
                            <Columns>                            
                                <dx:GridViewDataColumn CellStyle-HorizontalAlign="Center" Caption="Edit" HeaderStyle-HorizontalAlign="Center">
                                    <DataItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkEditDetl" CssClass="fa fa-pencil" Font-Size="Medium" OnClick="lnkEditDetl_Click" />
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataTextColumn FieldName="CodeDeti" Caption="Detail No." />
                                <dx:GridViewDataTextColumn FieldName="BenefitPackageTypeDesc" Caption="Benefit Package Type" GroupIndex="0" >
                                    <Settings SortMode="Custom" />
					            </dx:GridViewDataTextColumn>  
                                <dx:GridViewDataTextColumn FieldName="BenefitPackageDetiDesc" Caption="Benefit Description" />
                                <dx:GridViewDataTextColumn FieldName="Remarks" Caption="Remarks" />
                                <dx:GridViewDataTextColumn FieldName="OrderLevel" Caption="Order" />
                                <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" Caption="Select" /> 
                            </Columns>     
                            <SettingsContextMenu Enabled="true">                                
                                    <RowMenuItemVisibility CollapseDetailRow="false" CollapseRow="false" DeleteRow="false" EditRow="false" ExpandDetailRow="false" ExpandRow="false" NewRow="false" Refresh="false" /> 
                            </SettingsContextMenu>                                                                                            
                            <SettingsBehavior EnableCustomizationWindow="true" AllowFocusedRow="True" /> 
                            <SettingsSearchPanel Visible="true" />                       
                        </dx:ASPxGridView>
                        <dx:ASPxGridViewExporter ID="grdExportDetl" runat="server" GridViewID="grdDetl" />   
                    </div>
                </div>
            </div>                   
        </div>
    </div>
    
    

    <asp:Button ID="btnShow" runat="server" style="display:none" />
    <ajaxtoolkit:ModalPopupExtender ID="mdlShow" runat="server" TargetControlID="btnShow" PopupControlID="pnlPopup"
        CancelControlID="imgClose" BackgroundCssClass="modalBackground" >
    </ajaxtoolkit:ModalPopupExtender>

    <asp:Panel id="pnlPopup" runat="server" CssClass="entryPopup" style="display:none">
            <fieldset class="form" id="Fieldset1">
            <!-- Header here -->
             <div class="cf popupheader">
                    <h4>&nbsp;</h4>
                    <asp:Linkbutton runat="server" ID="imgClose" CssClass="cancel fa fa-times" ToolTip="Close" />&nbsp;
                    <asp:LinkButton runat="server" ID="btnSave" CssClass="fa fa-floppy-o submit fsMain btnSave" OnClick="btnSave_Click"  />   
             </div>
             <!-- Body here -->
             <div  class="entryPopupDetl form-horizontal">
                <div class="form-group" style="display:none;">
                    <label class="col-md-4 control-label">Reference No. :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtBenefitPackageNo" runat="server" CssClass="form-control" 
                            ></asp:Textbox>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-4 control-label has-space">Reference No. :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtCode" runat="server" CssClass="form-control" Enabled="false" Placeholder="Autonumber"
                            ></asp:Textbox>
                    </div>
                </div> 

                <div class="form-group">
                    <label class="col-md-4 control-label has-required">Code :</label>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtBenefitPackageCode" runat="server" CssClass="required form-control" />
                    </div>
                </div> 
                <div class="form-group">
                    <label class="col-md-4 control-label has-required">Description :</label>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtBenefitPackageDesc" runat="server" CssClass="required form-control" />
                    </div>
                </div> 

                <div class="form-group" style="display:none;">
                    <label class="col-md-4 control-label has-space">
                    Company Name :</label>
                    <div class="col-md-7">
                        <asp:Dropdownlist ID="cboPayLocNo" runat="server" CssClass="number form-control" >
                        </asp:Dropdownlist>
                    </div>
                </div>            
                <div class="form-group">
                    <label class="col-md-4 control-label has-space">&nbsp;</label>
                    <div class="col-md-7">
                        <asp:CheckBox runat="server" ID="txtIsArchived" Text="&nbsp;Archive" />
                    </div>
                </div>
                </div>
              <!-- Footer here -->
         
             </fieldset>
    </asp:Panel>
    


    <asp:Button ID="btnShowD" runat="server" style="display:none" />
    <ajaxtoolkit:ModalPopupExtender ID="mdlShowDetl" runat="server" TargetControlID="btnShowD" PopupControlID="pnlPopupDetl" CancelControlID="imgClosed" BackgroundCssClass="modalBackground" >
    </ajaxtoolkit:ModalPopupExtender>

    <asp:Panel id="pnlPopupDetl" runat="server" CssClass="entryPopup" style="display:none">
            <fieldset class="form" id="fsDetl">
            <!-- Header here -->
             <div class="cf popupheader">
                    <asp:Linkbutton runat="server" ID="imgClosed" CssClass="cancel fa fa-times" ToolTip="Close" />&nbsp;
                    <asp:LinkButton runat="server" ID="btnSaveDetl" CssClass="fa fa-floppy-o submit fsDetl btnSaveDetl" OnClick="btnSaveDetl_Click"  />   
             </div>
             <!-- Body here -->
             <div  class="entryPopupDetl form-horizontal">
                <div class="form-group" style="display:none;">
                    <label class="col-md-4 control-label">Reference No. :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtBenefitPackageDetiNo" runat="server" CssClass="form-control" 
                            ></asp:Textbox>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-4 control-label has-space">Detail No. :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtCodeDeti" runat="server" CssClass="form-control" Enabled="false" Placeholder="Autonumber"></asp:Textbox>
                     </div>
                </div>
             
                <div class="form-group">
                    <label class="col-md-4 control-label has-space">Benefit Package Type :</label>
                    <div class="col-md-7">
                        <asp:DropDownList ID="cboBenefitPackageTypeNo" runat="server" DataMember="EBenefitPackageType" CssClass="form-control"  />
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-4 control-label has-required">Benefit Description :</label>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtBenefitPackageDetiDesc" runat="server" CssClass="required form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                </div> 

                <div class="form-group">
                    <label class="col-md-4 control-label has-space">Remarks :</label>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtRemarks" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                </div> 

                <div class="form-group">
                    <label class="col-md-4 control-label has-space">Order :</label>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtOrderLevel" runat="server" CssClass="form-control number" />
                    </div>
                </div> 

                <br />
                </div>
              <!-- Footer here -->
         
             </fieldset>
    </asp:Panel>



 </div>


</asp:content>
