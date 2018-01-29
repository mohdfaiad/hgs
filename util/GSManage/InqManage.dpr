program InqManage;

uses
  Vcl.Forms,
  SynSqlite3Static,
  FrmInqManage in 'FrmInqManage.pas' {InquiryF},
  UViewMailList in 'UViewMailList.pas' {ViewMailListF},
  UElecDataRecord in 'UElecDataRecord.pas',
  TaskForm in 'TaskForm.pas' {TaskEditF},
  VarRecUtils in '..\..\common\openarr\source\VarRecUtils.pas',
  FrameDisplayTaskInfo in 'FrameDisplayTaskInfo.pas' {DisplayTaskF: TFrame},
  FrmDisplayTaskInfo in 'FrmDisplayTaskInfo.pas' {DisplayTaskInfoF},
  FrmFileSelect in 'FrmFileSelect.pas' {FileSelectF},
  FSMClass_Dic in '..\..\common\FSMClass_Dic.pas',
  FSMState in '..\..\common\FSMState.pas',
  UnitMakeReport in 'UnitMakeReport.pas',
  FrmEditSubCon in 'FrmEditSubCon.pas' {Form2},
  FrmEditEmailInfo in 'FrmEditEmailInfo.pas' {EmailInfoF},
  UnitStringUtil in '..\..\common\UnitStringUtil.pas',
  UnitIPCModule in 'UnitIPCModule.pas',
  UnitTodo_Detail in 'UnitTodo_Detail.pas' {ToDoDetailF},
  UnitTodoList in 'UnitTodoList.pas' {ToDoListF},
  UnitDateUtil in '..\..\common\UnitDateUtil.pas',
  UnitTodoCollect in 'UnitTodoCollect.pas',
  FrmSearchCustomer in 'FrmSearchCustomer.pas' {SearchCustomerF},
  UnitRegistryUtil in '..\..\common\UnitRegistryUtil.pas',
  UnitRegistrationClass in '..\..\common\UnitRegistrationClass.pas',
  UnitRegCodeConst in '..\..\common\UnitRegCodeConst.pas',
  UnitHttpModule in 'UnitHttpModule.pas',
  UnitRegCodeServerInterface in '..\RegCodeManager\Common\UnitRegCodeServerInterface.pas',
  FrmRegistration in '..\..\common\FrmRegistration.pas' {RegistrationF},
  getIp in '..\..\common\getIp.pas',
  UnitMAPSMacro in 'UnitMAPSMacro.pas',
  thundax.lib.actions in '..\..\OpenSrc\thundax-macro-actions-master\thundax.lib.actions.pas',
  UnitNextGridFrame in '..\..\common\Frames\UnitNextGridFrame.pas' {Frame1: TFrame},
  UnitDragUtil in '..\..\common\UnitDragUtil.pas',
  UnitVariantJsonUtil in 'UnitVariantJsonUtil.pas',
  UnitConfigIniClass2 in '..\..\common\UnitConfigIniClass2.pas',
  OLMailWSCallbackInterface in '..\OutLookAddIn\OLMail4InqManage\OLMailWSCallbackInterface.pas',
  FrmInqManageConfig in 'FrmInqManageConfig.pas',
  UnitIniConfigSetting in 'UnitIniConfigSetting.pas',
  UnitComboBoxUtil in '..\..\common\UnitComboBoxUtil.pas',
  UnitVesselMasterRecord in 'UnitVesselMasterRecord.pas',
  UnitMakeHgsDB in 'UnitMakeHgsDB.pas',
  UnitMakeHimsenWaringSpareDB in 'QuotationManage\UnitMakeHimsenWaringSpareDB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TInquiryF, InquiryF);
  Application.Run;
end.
