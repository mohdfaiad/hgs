program InvoiceManage;

uses
  Vcl.Forms,
  FrmMainInvoiceManage in 'FrmMainInvoiceManage.pas' {InvoiceManageF},
  FrmInvoiceEdit in 'FrmInvoiceEdit.pas' {InvoiceTaskEditF},
  FrmFileList in 'FrmFileList.pas' {FileListF},
  UnitDM in '..\UnitDM.pas' {DM1: TDataModule},
  UnitStringUtil in '..\..\..\common\UnitStringUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TInvoiceManageF, InvoiceManageF);
  Application.Run;
end.
