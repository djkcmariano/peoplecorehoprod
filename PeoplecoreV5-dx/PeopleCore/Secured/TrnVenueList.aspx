﻿<%@ Page Language="VB" AutoEventWireup="false" Theme="PCoreStyle" MasterPageFile="~/MasterPage/masterpage.master" CodeFile="TrnVenueList.aspx.vb" Inherits="Secured_TrnVenueList" EnableEventValidation="false" %>

<asp:content id="Content3" contentplaceholderid="cphBody" runat="server">
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
                    <asp:Dropdownlist ID="cboTabNo" AutoPostBack="true" OnSelectedIndexChanged="lnkSearch_Click" CssClass="form-control"  runat="server" />      
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
                        <dx:ASPxGridView ID="grdMain" ClientInstanceName="grdMain" runat="server" SkinID="grdDX" KeyFieldName="TrnVenueNo"
                        OnCommandButtonInitialize="grdMain_CommandButtonInitialize" OnCustomCallback="gridMain_CustomCallback">                                                                                   
                            <Columns>
                                <dx:GridViewDataColumn CellStyle-HorizontalAlign="Center" Caption="Edit" HeaderStyle-HorizontalAlign="Center">
                                    <DataItemTemplate>
                                        <asp:LinkButton runat="server" ID="lnkEdit" CssClass="fa fa-pencil" Font-Size="Medium" OnClick="lnkEdit_Click" />
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataTextColumn FieldName="Code" Caption="Reference No." />
                                <dx:GridViewDataTextColumn FieldName="TrnVenueCode" Caption="Code" Visible="false" />
                                <dx:GridViewDataTextColumn FieldName="TrnVenueDesc" Caption="Description" /> 
                                <dx:GridViewDataTextColumn FieldName="TrnVenueTypeDesc" Caption="Venue Type" />
                                <dx:GridViewDataTextColumn FieldName="Address" Caption="Address" />   
                                <dx:GridViewDataTextColumn FieldName="Remarks" Caption="Remarks" />
                                <dx:GridViewDataTextColumn FieldName="EncodeBy" Caption="Encoder"/>
                                <dx:GridViewDataTextColumn FieldName="EncodeDate" Caption="Date Encoded" Visible="false" />                                                  
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
</div>

<asp:Button ID="btnShowMain" runat="server" style="display:none" />
<ajaxtoolkit:ModalPopupExtender ID="mdlMain" runat="server" TargetControlID="btnShowMain" PopupControlID="pnlPopupMain" CancelControlID="lnkClose" BackgroundCssClass="modalBackground" ></ajaxtoolkit:ModalPopupExtender>
<asp:Panel id="pnlPopupMain" runat="server" CssClass="entryPopup" style="display:none" >
    <fieldset class="form" id="fsMain">
         <div class="cf popupheader">
              <h4>&nbsp;</h4>
              <asp:Linkbutton runat="server" ID="lnkClose" CssClass="fa fa-times" ToolTip="Close" />&nbsp;<asp:Linkbutton runat="server" ID="lnkSave" OnClick="lnkSave_Click" CssClass="fa fa-floppy-o submit fsMain lnkSave" ToolTip="Save" />
         </div>
        <div  class="entryPopupDetl form-horizontal">

            <div class="form-group">
                <label class="col-md-4 control-label has-space">Reference No. :</label>
                <div class="col-md-7">
                    <asp:Textbox ID="txtCode" ReadOnly="true" runat="server" CssClass="form-control" Placeholder="Autonumber"></asp:Textbox>
                 </div>
            </div>

            <div class="form-group" style="display:none;">
                <label class="col-md-4 control-label has-space">Code :</label>
                <div class="col-md-7"> 
                    <asp:Textbox ID="txtTrnVenueCode" runat="server" CssClass="form-control" ></asp:Textbox>
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label has-required">Description :</label>
                <div class="col-md-7"> 
                    <asp:Textbox ID="txtTrnVenueDesc" runat="server" CssClass="form-control required" ></asp:Textbox>
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label has-required">Venue Type :</label>
                <div class="col-md-7"> 
                    <asp:Dropdownlist ID="cboTrnVenueTypeNo" DataMember="ETrnVenueType" runat="server" CssClass="form-control required" />
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label has-space">Address :</label>
                <div class="col-md-7"> 
                    <asp:Textbox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" ></asp:Textbox>
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label has-space">Mobile No. :</label>
                <div class="col-md-7"> 
                    <asp:Textbox ID="txtPhoneNo" runat="server" CssClass="form-control" ></asp:Textbox>
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label has-space">Phone/Fax No. :</label>
                <div class="col-md-7"> 
                    <asp:Textbox ID="txtFaxNo" runat="server" CssClass="form-control" ></asp:Textbox>
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label has-space">Contact Person :</label>
                <div class="col-md-7"> 
                    <asp:Textbox ID="txtContactPerson" runat="server" CssClass="form-control" ></asp:Textbox>
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label has-space">Position :</label>
                <div class="col-md-7"> 
                    <asp:Textbox ID="txtPosition" runat="server" CssClass="form-control" ></asp:Textbox>
                </div>
            </div>

            <div class="form-group">
                <label class="col-md-4 control-label has-space">Remarks :</label>
                <div class="col-md-7"> 
                    <asp:Textbox ID="txtRemarks" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" ></asp:Textbox>
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
            <br />
        </div>
        <div class="cf popupfooter">
         </div> 
    </fieldset>
</asp:Panel>

</asp:content>
