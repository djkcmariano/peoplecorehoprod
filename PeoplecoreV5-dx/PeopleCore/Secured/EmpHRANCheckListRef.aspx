﻿<%@ Page Language="VB" AutoEventWireup="false" Theme="PCoreStyle"  MasterPageFile="~/MasterPage/MasterPage.master" CodeFile="EmpHRANCheckListRef.aspx.vb" Inherits="Secured_HRANCheckListRef" %>

<asp:Content id="Content3" contentplaceholderid="cphBody" runat="server">
<script type="text/javascript">
    function cbCheckAll_CheckedChanged(s, e) {
        grdMain.PerformCallback(s.GetChecked().toString());
    }

    </script>
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
                    <div class="table-responsive">

                        <dx:ASPxGridView ID="grdMain" ClientInstanceName="grdMain" runat="server" SkinID="grdDX" KeyFieldName="ApplicantStandardCheckListNo"
                        OnCommandButtonInitialize="grdMain_CommandButtonInitialize" OnCustomCallback="gridMain_CustomCallback">                                                                                   
                            <Columns>
                                <dx:GridViewDataColumn CellStyle-HorizontalAlign="Center" Caption="Edit" HeaderStyle-HorizontalAlign="Center">
                                    <DataItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkEdit" CssClass="fa fa-pencil" Font-Size="Medium" CommandArgument='<%# Bind("ApplicantStandardCheckListNo") %>' OnClick="lnkEdit_Click" />
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>                                
                                <dx:GridViewDataTextColumn FieldName="Code" Caption="Reference No." />
                                <dx:GridViewDataTextColumn FieldName="ApplicantStandardCheckListCode" Caption="Code" />                                                                           
                                <dx:GridViewDataTextColumn FieldName="ApplicantStandardCheckListDesc" Caption="Description" />
                                <dx:GridViewDataTextColumn FieldName="EncodeBy" Caption="Encoder"/>
                                <dx:GridViewDataTextColumn FieldName="ApplicantCheckListTypeDesc" Caption="Checklist Type" Visible="false" />
                                <dx:GridViewDataTextColumn FieldName="ApplicantCheckListCateDesc" Caption="Checklist Category" Visible="false" />                           
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



<asp:Button ID="btnShow" runat="server" style="display:none" />
<ajaxtoolkit:ModalPopupExtender ID="mdlShow" runat="server" TargetControlID="btnShow" PopupControlID="pnlPopup"
    CancelControlID="imgClose" BackgroundCssClass="modalBackground" >
</ajaxtoolkit:ModalPopupExtender>

<asp:Panel id="pnlPopup" runat="server" CssClass="entryPopup" style="display:none">
        <fieldset class="form" id="fsMain">
        <!-- Header here -->
         <div class="cf popupheader">
                <asp:Linkbutton runat="server" ID="imgClose" CssClass="cancel fa fa-times" ToolTip="Close" />&nbsp;
                <asp:LinkButton runat="server" ID="btnSave" CssClass="fa fa-floppy-o submit fsMain btnSave" OnClick="lnkSave_Click"  />   
         </div>
         <!-- Body here -->
         <div  class="entryPopupDetl form-horizontal">

                <div class="form-group" style="display:none;">
                    <label class="col-md-4 control-label">Reference No. :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtApplicantStandardCheckListNo" ReadOnly="true" runat="server" CssClass="form-control" Placeholder="Autonumber" ></asp:Textbox>
                    </div>
                </div> 

                <div class="form-group">
                    <label class="col-md-4 control-label">Reference No. :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtCode" ReadOnly="true" runat="server" CssClass="form-control" Placeholder="Autonumber" ></asp:Textbox>
                    </div>
                </div> 

                <div class="form-group">
                    <label class="col-md-4 control-label has-required">Code :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtApplicantStandardCheckListCode" runat="server" CssClass="required form-control" ></asp:Textbox>
                    </div>
                </div> 

                <div class="form-group">
                    <label class="col-md-4 control-label has-required">Description :</label>
                    <div class="col-md-7">
                        <asp:Textbox ID="txtApplicantStandardCheckListDesc" runat="server" CssClass="required form-control" TextMode="MultiLine" Rows="3" ></asp:Textbox>
                    </div>
                </div> 

                <div class="form-group" style="display:block;">
                    <label class="col-md-4 control-label has-required">Checklist Category :</label>
                    <div class="col-md-7">
                        <asp:DropDownList ID="cboApplicantCheckListCateNo" DataMember="EApplicantCheckListCate" CssClass="form-control required" runat="server"></asp:DropDownList>
                    </div>
                </div>

                <div class="form-group" style="display:none;">
                    <label class="col-md-4 control-label has-space">Checklist type :</label>
                    <div class="col-md-7">
                        <asp:DropDownList ID="cboApplicantCheckListTypeNo" DataMember="EApplicantCheckListType" CssClass="form-control" runat="server"></asp:DropDownList>
                    </div>
                </div>

                <div class="form-group" style="visibility:hidden; position:absolute;">
                    <label class="col-md-4 control-label"></label>
                    <div class="col-md-7">
                            <asp:CheckBox ID="txtIsRequired" runat="server" Text="&nbsp; Please check here if checklist is required." />
                     </div>
                </div>

                <div class="form-group" style="visibility:hidden; position:absolute;">
                    <label class="col-md-4 control-label"></label>
                    <div class="col-md-7">
                            <asp:CheckBox ID="txtIsOnline" runat="server" Text="&nbsp; Please check here if can be viewed by applicant." />
                     </div>
                </div>

                <div class="form-group" style="visibility:hidden; position:absolute;">
                    <label class="col-md-4 control-label"></label>
                    <div class="col-md-7">
                            <asp:CheckBox ID="txtIsDownload" runat="server" Text="&nbsp; Please check here if file is downloadable." />
                     </div>
                </div>
                <div class="form-group">
                <label class="col-md-4 control-label has-space">Company Name :</label>
                    <div class="col-md-7">
                        <asp:Dropdownlist ID="cboPayLocNo" runat="server" CssClass=" number form-control" >
                        </asp:Dropdownlist>
                    </div>
             </div> 
            </div>
          <!-- Footer here -->
         </fieldset>
</asp:Panel> 
</asp:Content>