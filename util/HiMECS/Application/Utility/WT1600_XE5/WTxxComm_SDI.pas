unit WTxxComm_SDI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SyncObjs, inifiles, iComponent, iVCLComponent,
  iCustomComponent, iSwitchLed, WT1600Const, WT1600CommThread, ExtCtrls, Menus,
  WT1600Config, MyKernelObject, CopyData, //IPCThrd_WT1600, IPCThrdClient_WT1600,
  IPCThreadEvent, IPCThrdClient_Generic, UnitIPCClientAll, HiMECSConst,
  IPC_WT1600_Const, EngineParameterClass,
  ComCtrls, WT1600PingThread, Buttons, WT1600_Watch, JvComponentBase, JvTrayIcon,
  IPCThrd_HiMECS_MDI, JvFormPlacement, JvAppStorage, JvAppIniStorage,
  //STOMP units
  UnitSTOMPClass
  ;

type
  TDisplayTarget = (dtSendMemo, dtRecvMemo, dtStatusBar);

  TWT1600CommSDIF = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    SendComMemo: TMemo;
    Splitter1: TSplitter;
    RecvComMemo: TMemo;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel28: TPanel;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    Panel32: TPanel;
    Panel33: TPanel;
    Panel36: TPanel;
    Panel23: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel34: TPanel;
    Panel8: TPanel;
    Panel83: TPanel;
    PSIGMA: TPanel;
    SSIGMA: TPanel;
    QSIGMA: TPanel;
    FREQUENCY: TPanel;
    RAMDA: TPanel;
    IRMS1: TPanel;
    IRMS2: TPanel;
    IRMS3: TPanel;
    URMS1: TPanel;
    URMS2: TPanel;
    URMS3: TPanel;
    Panel9: TPanel;
    Panel18: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel19: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    iSwitchLed1: TiSwitchLed;
    BitBtn1: TBitBtn;
    Label10: TLabel;
    IntervalEdit: TEdit;
    Button2: TButton;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    Config1: TMenuItem;
    IRMSAVG000: TPanel;
    Panel24: TPanel;
    IRMSAVG: TPanel;
    URMSAVG: TPanel;
    Panel27: TPanel;
    Panel35: TPanel;
    Splitter2: TSplitter;
    Panel22: TPanel;
    F1: TPanel;
    Panel26: TPanel;
    Label2: TLabel;
    StayOnTopCB: TCheckBox;
    iSwitchLed2: TiSwitchLed;
    JvAppIniFileStorage1: TJvAppIniFileStorage;
    JvFormStorage1: TJvFormStorage;
    GetEventName1: TMenuItem;
    GetEngineName1: TMenuItem;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure CONSUMPTIONQDblClick(Sender: TObject);
    procedure iSwitchLed1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PSIGMADblClick(Sender: TObject);
    procedure SSIGMADblClick(Sender: TObject);
    procedure QSIGMADblClick(Sender: TObject);
    procedure FREQUENCYDblClick(Sender: TObject);
    procedure RAMDADblClick(Sender: TObject);
    procedure IRMS1DblClick(Sender: TObject);
    procedure IRMS2DblClick(Sender: TObject);
    procedure IRMS3DblClick(Sender: TObject);
    procedure URMS1DblClick(Sender: TObject);
    procedure URMS2DblClick(Sender: TObject);
    procedure URMS3DblClick(Sender: TObject);
    procedure Config1Click(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure StayOnTopCBClick(Sender: TObject);
    procedure GetEventName1Click(Sender: TObject);
    procedure GetEngineName1Click(Sender: TObject);
  private
    //FThreadPool: TThreadPool;
    FFirst: Boolean;//맨처음에 실행될때 True 그 다음부터는 False
    FFilePath: string;      //파일을 저장할 경로
    //FStoreType: TStoreType; //저장방식(ini or registry)
    //FIPCClient: TIPCClient_WT1600;//공유 메모리 및 이벤트 객체
    FIPCClientAll: TIPCClientAll;
    FWT1600CommThread: TWT1600CommThread;
    FWT1600PingThread:TWT1600PingThread;
    FRecvStrBuf: Ansistring; //Thread 통신 객체
    FPingFailCount: integer;//Ping 오류 횟수(Ping 오류시 NullScreen 실행되기 때문에)
    FMaxPingFailCount: integer;//Ping 최대 오류횟수 지정
    FLauncherHandle: integer; //자동 실행 시키는 프로그램 window handle

    //IPC Thread -->
    Flags: TClientFlags;
    IPCClient_HiMECS_MDI: TIPCClient_HiMECS_MDI;

    FpjhSTOMPClass: TpjhSTOMPClass;
    FMQServerIp,
    FMQUser,
    FMQPasswd,
    FMQTopic: string;
    FMQServerEnable: boolean;
    FMQServerPortNum: integer;
    FMQServerBindIPAddress: string;

    procedure OnConnect(Sender: TIPCThread_HiMECS_MDI; Connecting: Boolean);
    procedure OnSignal(Sender: TIPCThread_HiMECS_MDI; Data: TEventData_HiMECS_MDI);
    procedure UpdateStatusBar(var Msg: TMessage); message WM_UPDATESTATUS_HiMECS_MDI;
    //IPC Thread <--

    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMPowerMeterOn(var Msg: TMessage); message WM_POWERMETER_ON;
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure SetCurrentCommandIndex(aIndex: integer);

    procedure DestroyAll;
  protected
  public
    FOwner: TForm;
    FWT1600On: Boolean;
    FIPAddress: Ansistring;
//    FBindIPAddress: string;
    FPingInterval: Word;
    FWT1600CommInterval: Word;
    FModel: integer;//0: WT500, 1: WT1600

    FStop: boolean;
    FSuspend: boolean;
    ///
    FSendCommandList: TStringList;//WT1600 통신 명령 리스트
    //현재 Comport에 Write한 FSendCommandList의 Index(0부터 시작함)
    FCurrentCommandIndex: integer;
    //일정시간 이상 통신에 대한 반응이 없으면 제어기 다운으로 간주(Wait 시간 설정)
    FCommFail: Boolean;
    FCommFailCount: integer; //통신 반응이 없이 FQueryInterval이 경과한 횟수
    FCriticalSection: TCriticalSection;
    FErrCnt: integer; //LRC Error Log

    FMenuItem: TMenuItem;//메인 메뉴에서 메뉴를 선택한 아이템
    FPowerMeterNo: word;//Power Meter No.
    FIdleMode: Bool;//Kw 값이 < 10이면 query를 천천히 하기 위한 옵션

    FParamSource: TParameterSource;
    FEngParamEncrypt: Boolean;
    FEngParamFileFormat: integer;
    FParamFileName: string;
    FSharedMemName: string; //IPCMonitor Shared Memory Name
    FDisplayCaption: string;
    FUniqueEngineName: string;

    //constructor Create(AIpAddress: string);
    function InitVar: Boolean;
    procedure MakeCommand;
    procedure DisplayMessage(msg: string; ADspNo: TDisplayTarget);
    procedure Value2Screen(AData: Ansistring);
    procedure NullValue2Screen;
    procedure ApplyInterval;

    procedure LoadConfigDataini2Form(ConfigForm:TWT1600ConfigF);
    procedure LoadConfigDataini2Var;
    procedure SaveConfigDataForm2ini(ConfigForm:TWT1600ConfigF);
    function SetConfigData: Boolean;

    procedure ExecWatchWindow;
  published
    property FilePath: string read FFilePath;
    //property StoreType: TStoreType read FStoreType;
    property StrBuf: Ansistring read FRecvStrBuf write FRecvStrBuf;
    property CurrentCommandIndex: integer read FCurrentCommandIndex write SetCurrentCommandIndex;
  end;

var
  WT1600CommSDIF: TWT1600CommSDIF;
  WatchList: TThreadList;

implementation

uses WT1600_Util, WT1600Select, RunOne_WT1600, IPC_Modbus_Standard_Const,
  CommonUtil;

{$R *.dfm}

function TWT1600CommSDIF.InitVar: Boolean;
var
  i: integer;
  LStr: string;
begin
  if not Assigned(FIPCClientAll) then
    FIPCClientAll := TIPCClientAll.Create;

  FFilePath := ExtractFilePath(Application.ExeName); //맨끝에 '\' 포함됨
  SetCurrentDir(FilePath);

  LoadConfigDataini2Var;

  if RunProgram <> '' then
  begin
    LStr := RunProgram;
    FParamFileName := '..\Doc\WT(' + LStr + ').param';
  end;

  if not FileExists(FParamFileName) then
  begin
    Result := False;
    ShowMessage(FParamFileName + ' file is not exist');
    exit;
  end;

  FErrCnt := 0;
  //FStoreType := stIniFile;
  //FIPAddress := '10.14.21.112';
  FPingInterval := 1000;

  FSendCommandList := TStringList.Create;
  //FThreadPool := TThreadPool.Create(5,10,0); //max 10 thread
  //FThreadPool.ExecuteProc(CheckPowerMeterOn,Pointer(self));

  FStop := False;
  FIdleMode := False;

  FCriticalSection := TCriticalSection.Create;
  //FIPCClient := TIPCClient_WT1600.Create(0, FIPAddress, True);
  FIPCClientAll.ReadAddressFromParamFile(FParamFileName);
  FIPCClientAll.CreateIPCClientAll;
  FUniqueEngineName := FIPCClientAll.FProjNo + '_' + FIPCClientAll.FEngNo;

  for i := 0 to FIPCClientAll.FEngineParameter.EngineParameterCollect.Count - 1 do
  begin
    FParamSource := FIPCClientAll.FEngineParameter.EngineParameterCollect.Items[i].ParameterSource;
    break;
  end;

  if FIPCClientAll.FIPCClientList.Count > 0 then
  begin
    FSharedMemName := FIPCClientAll.FIPCClientList.Strings[0];

    if FMQServerEnable then
    begin
      if FMQUser = '' then
        FMQUser := 'pjh';
      if FMQPasswd = '' then
        FMQPasswd := 'pjh';
      if FMQTopic = '' then
        FMQTopic := FUniqueEngineName;
      if FMQServerIp = '' then
        FMQServerIp := '10.14.21.117';

      if not Assigned(FpjhSTOMPClass) then
        FpjhSTOMPClass := TpjhSTOMPClass.Create(FMQUser,FMQPasswd,FMQServerIp,FMQTopic,Self.Handle);
    end;
  end;

  FWT1600CommThread := TWT1600CommThread.Create(Self,FIPAddress,'anonymous',FModel);
  FWT1600CommThread.FreeOnTerminate := True;
  FWT1600CommThread.StopComm := True;
  FWT1600CommThread.FWT1600ID := 1;

  FWT1600PingThread := TWT1600PingThread.Create(Self, FIPAddress);
  FWT1600PingThread.FreeOnTerminate := True;

  LoadConfigDataini2Form(nil);
  Result := True;
  Caption := Caption + ' ==> ( '+ FWT1600CommThread.FWT1600Connection.DLLName + ' )';
end;

procedure TWT1600CommSDIF.IRMS1DblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel33.Caption;
    LWatchF.FWatchTag := Panel33.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.IRMS2DblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel36.Caption;
    LWatchF.FWatchTag := Panel36.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.IRMS3DblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel23.Caption;
    LWatchF.FWatchTag := Panel23.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.FormCreate(Sender: TObject);
var
  LStr: string;
begin
  WatchList := TThreadList.Create;

  LStr := RunOne_WT1600.RunProgram;

  FPowerMeterNo := StrToIntDef(RunOne_WT1600.RunProgram,0);

  if Length(LStr) > 2 then
    FIPAddress := RunProgram
  else
    FIPAddress := '192.168.0.4' + LStr;

  Application.Title := FIPAddress;
  FFirst := True;
  FPingFailCount := 0;
  Timer1.Enabled := True;
  JvAppIniFileStorage1.FileName := FIPAddress+'_WTxx.ini';
end;

procedure TWT1600CommSDIF.FREQUENCYDblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel32.Caption;
    LWatchF.FWatchTag := Panel32.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.GetEngineName1Click(Sender: TObject);
begin
  ShowMessage(FIPCClientAll.GetEngineName);
end;

procedure TWT1600CommSDIF.GetEventName1Click(Sender: TObject);
begin
  ShowMessage(FIPCClientAll.GetEventName);
end;

procedure TWT1600CommSDIF.WMPowerMeterOn(var Msg: TMessage);
begin
//  FCriticalSection.Enter;
  if FStop then
    exit;

  FWT1600On := (Msg.WParamLo = 1);
  FWT1600CommThread.FPingOK := FWT1600On;
  iSwitchLed1.Active := FWT1600On;
  FWT1600CommThread.FWT1600Connected := FWT1600On;

  //SendMessage(FOwner.Handle, WM_POWERMETER_ON, Msg.WParam, Msg.LParam);
//  FCriticalSection.Leave;
end;

procedure TWT1600CommSDIF.FormClose(Sender: TObject; var Action: TCloseAction);
var
  LMsg: TMessage;
  Li: integer;
  LF: TWatchF;
begin
  //LMsg.WParamLo := 0;
  //LMsg.WParamHi := FPowerMeterNo;
  //SendMessage(FOwner.Handle, WM_POWERMETER_ON, LMsg.WParam, 0);

  //FMenuItem.Enabled := True;
{  with WatchList.LockList do
  try
    for Li := Count-1 downto 0 do  // iterate through client-list
    begin
      LF := TWatchF(Items[Li]);  // get client-object
      Remove(LF);
      LF.FIPCMonitor.Terminate;
      //LF.Close;
      LF.Free;
     end;//for
  finally
    WatchList.UnlockList;
  end;
}
  FWT1600CommThread.StopComm := True;
  WatchList.Free;
  FStop := True;
  IPCClient_HiMECS_MDI.Free;
  DestroyAll;
  //Action := caFree;
end;

procedure TWT1600CommSDIF.DisplayMessage(msg: string; ADspNo: TDisplayTarget);
begin
  case ADspNo of
    dtSendMemo : begin
      if msg = ' ' then
      begin
        exit;
      end
      else
        ;

      with SendComMemo do
      begin
        if Lines.Count > 100 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtSendMemo

    dtRecvMemo: begin
      if msg = 'RxTrue' then
      begin
        exit;
      end
      else
      if msg = 'RxFalse' then
      begin
        exit;
      end;

      with RecvComMemo do
      begin
        if Lines.Count > 100 then
          Clear;

        Lines.Add(msg);
      end;//with
    end;//dtRecvMemo

    dtStatusBar: begin
       StatusBar1.SimplePanel := True;
       StatusBar1.SimpleText := DateTimeToStr(now) + ' : ' + msg;
    end;//dtStatusBar
  end;//case
end;

procedure TWT1600CommSDIF.ExecWatchWindow;
begin

end;

procedure TWT1600CommSDIF.LoadConfigDataini2Form(ConfigForm: TWT1600ConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create('WT1600(' + FIPAddress + ').ini');
  try
    with iniFile, ConfigForm do
    begin
      if Assigned(ConfigForm) then
      begin
        ModelSelectRG.ItemIndex := ReadInteger(WT1600_SECTION, 'Model', 0);
        QueryIntervalEdit.Text := ReadString(WT1600_SECTION, 'Query Interval','0');
        ResponseWaitTimeOutEdit.Text := ReadString(WT1600_SECTION, 'Response Wait Time Out','0');
        MaxPingFailEdit.Text := ReadString(WT1600_SECTION, 'Max Ping Fail Count', '10');

        try
          ParaFilenameEdit.FileName := ReadString(WT1600_SECTION, 'Parameter File Name', '');
        except on E : Exception do
          ShowMessage(E.ClassName+' error raised, with message : '+E.Message + #13#10 + 'Check the charter: [' + '/<>"?*|' + ']');
        end;

        EngParamEncryptCB.Checked := ReadBool(WT1600_SECTION, 'Parameter Encrypt', False);
        ConfFileFormatRG.ItemIndex := ReadInteger(WT1600_SECTION, 'Param File Format', 0);
        SharedNameEdit.Text := ReadString(WT1600_SECTION, 'Shared Name', ParameterSource2SharedMN(FParamSource));
        DisplayEdit.Text := ReadString(WT1600_SECTION, 'Display Caption', FDisplayCaption);
      end
      else
        IntervalEdit.Text := ReadString(WT1600_SECTION, 'Query Interval', '1000');
    end;//with
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWT1600CommSDIF.LoadConfigDataini2Var;
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create('WT1600(' + FIPAddress + ').ini');
  try
    with iniFile do
    begin
      FModel := ReadInteger(WT1600_SECTION, 'Model', 0);

      FWT1600CommInterval := ReadInteger(WT1600_SECTION, 'Query Interval', 1000);
      FMaxPingFailCount := ReadInteger(WT1600_SECTION, 'Max Ping Fail Count', 10);
      //FWT1600CommThread.QueryInterval :=
      //                       ReadInteger(WT1600_SECTION, 'Query Interval',0);
      //FWT1600CommThread.TimeOut :=
                      //ReadInteger(WT1600_SECTION, 'Response Wait Time Out',0);
      FParamFileName := ReadString(WT1600_SECTION, 'Parameter File Name', '');
      FEngParamEncrypt := ReadBool(WT1600_SECTION, 'Parameter Encrypt', false);
      FEngParamFileFormat := ReadInteger(WT1600_SECTION, 'Param File Format', 0);
      FSharedMemName := ReadString(WT1600_SECTION, 'Shared Name', ParameterSource2SharedMN(FParamSource));
      FDisplayCaption := ReadString(WT1600_SECTION, 'Display Caption', '');

      Statusbar1.Panels[2].Text := FDisplayCaption;
      Caption := Caption + ':' + FDisplayCaption;
    end;//with

  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

procedure TWT1600CommSDIF.MakeCommand;
begin
  FSendCommandList.Clear;
  FSendCommandList.Add(':NUMERIC:NORMAL:VALUE?');
  FWT1600CommThread.FSendCommandList.Assign(FSendCommandList);
  FWT1600CommThread.FWT1600ID := FPowerMeterNo - 1;
  //FWT1600CommThread.InitVar(FWT1600CommThread.FWT1600ID);
  //FWT1600CommThread.SendItemSettings;
  FWT1600CommThread.FIsInitExec := True;

  FWT1600PingThread.FIpAddress := FIPAddress;
  FWT1600PingThread.FPingInterval := FPingInterval;
  FWT1600PingThread.FPowerMeterNo := FPowerMeterNo;
  FWT1600PingThread.Priority := tpLowest;
  DisplayMessage('MakeCommand Executed', TDisplayTarget(1));
end;

procedure TWT1600CommSDIF.SaveConfigDataForm2ini(ConfigForm: TWT1600ConfigF);
var
  iniFile: TIniFile;
begin
  SetCurrentDir(FilePath);
  iniFile := nil;
  iniFile := TInifile.create('WT1600(' + FIPAddress + ').ini');
  try
    if Assigned(ConfigForm) then
    begin
      with iniFile, ConfigForm do
      begin
        WriteInteger(WT1600_SECTION, 'Model', ModelSelectRG.ItemIndex);
        WriteString(WT1600_SECTION, 'Max Ping Fail Count', MaxPingFailEdit.Text);
        WriteString(WT1600_SECTION, 'Query Interval',QueryIntervalEdit.Text);
        WriteString(WT1600_SECTION, 'Response Wait Time Out', ResponseWaitTimeOutEdit.Text);

        WriteString(WT1600_SECTION, 'Parameter File Name', ParaFilenameEdit.FileName);
        WriteBool(WT1600_SECTION, 'Parameter Encrypt', EngParamEncryptCB.Checked);
        WriteInteger(WT1600_SECTION, 'Param File Format', ConfFileFormatRG.ItemIndex);
        WriteString(WT1600_SECTION, 'Shared Name', SharedNameEdit.Text);
        WriteString(WT1600_SECTION, 'Display Caption', DisplayEdit.Text);
      end;//with
    end
    else
      iniFile.WriteString(WT1600_SECTION, 'Query Interval', IntervalEdit.Text);
  finally
    iniFile.Free;
    iniFile := nil;
  end;//try
end;

function TWT1600CommSDIF.SetConfigData: Boolean;
var
  ConfigData: TWT1600ConfigF;
begin
  Result := False;
  ConfigData := nil;
  ConfigData := TWT1600ConfigF.Create(Self);
  try
    with ConfigData do
    begin
      SharedName2Combo(SharedNameEdit);
      LoadConfigDataini2Form(ConfigData);
      if ShowModal = mrOK then
      begin
        SaveConfigDataForm2ini(ConfigData);
        LoadConfigDataini2Var;
        Result := True;
      end;
    end;//with
  finally
    ConfigData.Free;
    ConfigData := nil;
  end;//try
end;

procedure TWT1600CommSDIF.SetCurrentCommandIndex(aIndex: integer);
begin
  if FCurrentCommandIndex <> aIndex then
    FCurrentCommandIndex := aIndex;
end;

procedure TWT1600CommSDIF.SSIGMADblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel30.Caption;
    LWatchF.FWatchTag := Panel30.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.StatusBar1Click(Sender: TObject);
begin
  StatusBar1.SimplePanel := not StatusBar1.SimplePanel;
  //StatusBar1.SimpleText := FormatDateTime('yyyy-mm-dd hh:nn:ss', now);
end;

procedure TWT1600CommSDIF.Timer1Timer(Sender: TObject);
var
  LStr: string;
begin
  with Timer1 do
  begin
    Enabled := False;
    try
      if FFirst then
      begin
        if not InitVar then
        begin
          if not SetConfigData then
            halt;
          exit;
        end;

        FFirst := False;
        Interval := 1000;
        Caption := Caption + ' ('+ FIPAddress + ')';
        FWT1600PingThread.CheckPowerMeterOn;
        DisplayMessage('FWT1600PingThread.CheckPowerMeterOn', TDisplayTarget(1));

        FWT1600CommThread.StopComm := False;
        FWT1600CommThread.Resume;
        DisplayMessage('FWT1600CommThread.Resume', TDisplayTarget(1));

        FWT1600PingThread.FStopPing := False;
        FWT1600PingThread.Resume;
        DisplayMessage('FWT1600PingThread.Resume', TDisplayTarget(1));
        Interval := FPingInterval;

        MakeCommand;

        ///======================================================================
        //LStr := Format('%s (%X)', [Application.Title, GetCurrentProcessID]);
        //Label4.Caption := IntToStr(GetCurrentProcessID);
        try
          IPCClient_HiMECS_MDI := TIPCClient_HiMECS_MDI.Create(GetCurrentProcessID, Self.Caption);
          //IPCClient_HiMECS_MDI := TIPCClient_HiMECS_MDI.Create(GetCurrentProcessID, LStr);
          //IPCClient_HiMECS_MDI.OnConnect := OnConnect;
          //IPCClient_HiMECS_MDI.OnSignal := OnSignal;
          IPCClient_HiMECS_MDI.Activate;

          if not (IPCClient_HiMECS_MDI.State = stConnected) then
            OnConnect(nil, False);
        except
          Application.HandleException(ExceptObject);
          Application.Terminate;
        end;

      end//if
      else
      begin
        if FStop then
          exit;
          
        if (FWT1600CommThread.FPingOK) and (not FWT1600CommThread.FWT1600Connected) then
        begin
          Interval := 1000;
          MakeCommand;
        end
        else
        begin
          if not FIdleMode then
          begin
            Interval := FWT1600CommInterval;
            StatusBar1.Panels[0].Text := 'Idel Mode';
          end
          else
          begin
            StatusBar1.Panels[0].Text := '';
            Interval := 1000;
          end;
        end;

        FWT1600PingThread.FEventHandle.Pulse;
        //DisplayMessage('WT1600PingThread.FEventHandle.Pulse', TDisplayTarget(1));

        if not FWT1600On then
        begin
          Inc(FPingFailCount);

          if FPingFailCount > FMaxPingFailCount then
          begin
            NullValue2Screen;
            FPingFailCount := 0;
            Interval := 1000;
          end;
        end
        else
        begin
          FWT1600CommThread.FEventHandle.Pulse;
          FPingFailCount := 0;
        end;
          //ShowWindow(Application.Handle, SW_HIDE);
        //Enabled := False;
        //DisplayMessage('FWT1600CommThread.FEventHandle.Pulse : ' + IntToStr(ord(FWT1600On)) , TDisplayTarget(1));
      end;
    finally
      Enabled := True;
    end;//try
  end;//with
end;

procedure TWT1600CommSDIF.UpdateStatusBar(var Msg: TMessage);
const
  ConnectStr: Array[Boolean] of PChar = ('Not Connected', 'Connected');
begin
  StatusBar1.SimpleText := ConnectStr[Boolean(Msg.WParam)];
end;

procedure TWT1600CommSDIF.URMS1DblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel5.Caption;
    LWatchF.FWatchTag := Panel5.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.URMS2DblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel6.Caption;
    LWatchF.FWatchTag := Panel6.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.URMS3DblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel7.Caption;
    LWatchF.FWatchTag := Panel7.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.ApplyInterval;
begin
  SaveConfigDataForm2ini(nil);
  LoadConfigDataini2Form(nil);
  LoadConfigDataini2Var;
end;

procedure TWT1600CommSDIF.Button2Click(Sender: TObject);
begin
  ApplyInterval;
end;

procedure TWT1600CommSDIF.StayOnTopCBClick(Sender: TObject);
begin
  if StayOnTopCB.Checked then
    FormStyle := fsStayOnTop
  else
    FormStyle := fsNormal;
end;

procedure TWT1600CommSDIF.Config1Click(Sender: TObject);
begin
  SetConfigData;
end;

procedure TWT1600CommSDIF.CONSUMPTIONQDblClick(Sender: TObject);
begin
{  with TWatchF.Create(Application) do
  begin
    FWatchName := TPanel(Sender).Hint;
    FLabelName := Panel29.Caption;
    Show;
  end;
}
end;

procedure TWT1600CommSDIF.CreateParams(var Params: TCreateParams);
begin
  inherited;
  //Params.Style := Params.Style and not WS_VISIBLE;
  Params.ExStyle := Params.ExStyle and not WS_EX_APPWINDOW;
end;

procedure TWT1600CommSDIF.WMCopyData(var Msg: TMessage);
begin
  case Msg.WParam of //Echo
    WParam_SENDWINHANDLE: begin//Handle 수신 OK
      if PCopyDataStruct(Msg.LParam)^.dwData = Handle then
      begin
        FLauncherHandle := PCopyDataStruct(Msg.LParam)^.cbData;
        SendHandleCopyData(FLauncherHandle, Handle, WParam_RECVHANDLEOK);
        //StatusBarPro1.SimplePanel := True;
        StatusBar1.SimpleText := FormatDateTime('hh:mi:ss: ', now) + 'WParam_SENDWINHANDLE Receive OK!';
        //Caption := FormatDateTime('hh:mi:ss: ', now) + 'WParam_SENDWINHANDLE Receive OK!';
        exit;
      end;
    end;

    WParam_RECVHANDLEOK: begin
      exit;
    end;

    WParam_DISPLAYMSG: begin
      if FStop then
        exit;

      if (PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle = 4) or
        (PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle = 5) then
      begin//Data인 경우
        Value2Screen(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg);
      end
      else
        DisplayMessage(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.StrMsg,
          TDisplayTarget(PRecToPass(PCopyDataStruct(Msg.LParam)^.lpData)^.iHandle));
    end;
  end;

end;

procedure TWT1600CommSDIF.Value2Screen(AData: Ansistring);
var
  EventData: TEventData_Modbus_Standard;
  LEventData: TEventData_WT1600;
  LData: AnsiString;
  LStr: string;
  LDouble, LIAvg, LUAvg: double;
begin
  //DisplayMessage(AData, dtSendMemo);
  LData := AData;

  {URMS1.Caption := GetToken(AData, ',');
  URMS2.Caption := GetToken(AData, ',');
  URMS3.Caption := GetToken(AData, ',');
  IRMS1.Caption := GetToken(AData, ',');
  IRMS2.Caption := GetToken(AData, ',');
  IRMS3.Caption := GetToken(AData, ',');
  FREQUENCY.Caption := GetToken(AData, ',');
  RAMDA.Caption := GetToken(AData, ',');
  PSIGMA.Caption := GetToken(AData, ',');
  SSIGMA.Caption := GetToken(AData, ',');
  QSIGMA.Caption := GetToken(AData, ',');
  }
  LDouble := StrToFloatDef(String(GetToken(LData, ',')),0.0);
  EventData.InpDataBuf_double[0] := LDouble;
  LUAvg := LDouble;
  URMS1.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(String(GetToken(LData, ',')),0.0);
  EventData.InpDataBuf_double[1] := LDouble;
  LUAvg := LUAvg + LDouble;
  URMS2.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(String(GetToken(LData, ',')),0.0);
  EventData.InpDataBuf_double[2] := LDouble;
  LUAvg := (LUAvg + LDouble)/3;
  URMS3.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  EventData.InpDataBuf_double[3] := LDouble;
  LIAvg := LDouble;
  IRMS1.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  EventData.InpDataBuf_double[4] := LDouble;
  LIAvg := LIAvg + LDouble;
  IRMS2.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  EventData.InpDataBuf_double[5] := LDouble;
  LIAvg := (LIAvg + LDouble)/3;
  IRMS3.Caption := Format('%.2f', [LDouble]);

  URMSAVG.Caption := Format('%.2f', [LUAvg]);
  IRMSAVG.Caption := Format('%.2f', [LIAvg]);

  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  EventData.InpDataBuf_double[6] := LDouble;
  FREQUENCY.Caption := Format('%.2f', [LDouble]);
  LDouble := StrToFloatDef(GetToken(LData, ','),0.0);
  EventData.InpDataBuf_double[7] := LDouble;
  RAMDA.Caption := Format('%.4f', [LDouble]);

  LDouble := StrToFloatDef(String(GetToken(LData, ',')),0.0);
  EventData.InpDataBuf_double[8] := LDouble;

  LDouble := LDouble/1000;
  PSIGMA.Caption := Format('%.2f', [LDouble]);

  if LDouble < 10.0 then
    FIdleMode := True
  else
    FIdleMode := False;


  LDouble := StrToFloatDef(String(GetToken(LData, ',')),0.0);
  EventData.InpDataBuf_double[9] := LDouble;
  SSIGMA.Caption := Format('%.2f', [LDouble/1000]);
  LDouble := StrToFloatDef(String(GetToken(LData, ',')),0.0);
  EventData.InpDataBuf_double[10] := LDouble;
  QSIGMA.Caption := Format('%.2f', [LDouble/1000]);
  LDouble := StrToFloatDef(String(GetToken(LData, ',')),0.0);
  EventData.InpDataBuf_double[11] := LDouble;
  F1.Caption := Format('%.2f', [LDouble/1000]);
  EventData.InpDataBuf_double[12] := LUAvg;
  EventData.InpDataBuf_double[13] := LIAvg;

  EventData.IPAddress := FIPAddress;
  EventData.ModBusMode := Ord(FWT1600On);
  EventData.BlockNo := FPowerMeterNo;
//  EventData.EngineName := FUniqueEngineName;

  LEventData.IpAddress := EventData.IPAddress;
  LEventData.URMS1 := Format('%.2f', [EventData.InpDataBuf_double[0]]);
  LEventData.URMS2 := Format('%.2f', [EventData.InpDataBuf_double[1]]);
  LEventData.URMS3 := Format('%.2f', [EventData.InpDataBuf_double[2]]);
  LEventData.IRMS1 := Format('%.2f', [EventData.InpDataBuf_double[3]]);
  LEventData.IRMS2 := Format('%.2f', [EventData.InpDataBuf_double[4]]);
  LEventData.IRMS3 := Format('%.2f', [EventData.InpDataBuf_double[5]]);
  LEventData.FREQUENCY := Format('%.2f', [EventData.InpDataBuf_double[6]]);
  LEventData.RAMDA := Format('%.4f', [EventData.InpDataBuf_double[7]]);
  LEventData.PSIGMA := Format('%.2f', [EventData.InpDataBuf_double[8]/1000]);
  LEventData.SSIGMA := Format('%.2f', [EventData.InpDataBuf_double[9]/1000]);
  LEventData.QSIGMA := Format('%.2f', [EventData.InpDataBuf_double[10]/1000]);
  LEventData.F1 := Format('%.2f', [EventData.InpDataBuf_double[11]]);
  LEventData.URMSAVG := Format('%.2f', [EventData.InpDataBuf_double[12]]);
  LEventData.IRMSAVG := Format('%.2f', [EventData.InpDataBuf_double[13]]);

  LEventData.PowerMeterOn := Boolean(EventData.ModBusMode);
  LEventData.PowerMeterNo := EventData.BlockNo;
  LEventData.UniqueEngineName := FUniqueEngineName;

  FIPCClientAll.PulseEventData<TEventData_WT1600>(LEventData);
  LStr := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', now) + ' : ' + '********* 공유메모리';
  LStr := LStr + '(' + FSharedMemName +')에 데이타 전달함!!! **********'+#13#10;
  DisplayMessage(LStr, TDisplayTarget(1));
end;

procedure TWT1600CommSDIF.NullValue2Screen;
var
  EventData: TEventData_Modbus_Standard;
begin
  FillChar(EventData, SizeOf(EventData), #0);

{  EventData.URMS1 := '0.0';
  EventData.URMS2 := '0.0';
  EventData.URMS3 := '0.0';
  EventData.IRMS1 := '0.0';
  EventData.IRMS2 := '0.0';
  EventData.IRMS3 := '0.0';
  EventData.FREQUENCY := '0.0';
  EventData.RAMDA := '0.0';
  EventData.PSIGMA := '0.0';
  EventData.SSIGMA := '0.0';
  EventData.QSIGMA := '0.0';
}
{  StrPCopy(@EventData.URMS1[0],'0.0');
  StrPCopy(@EventData.URMS2[0],'0.0');
  StrPCopy(@EventData.URMS3[0],'0.0');
  StrPCopy(@EventData.IRMS1[0],'0.0');
  StrPCopy(@EventData.IRMS2[0],'0.0');
  StrPCopy(@EventData.IRMS3[0],'0.0');
  StrPCopy(@EventData.FREQUENCY[0],'0.0');
  StrPCopy(@EventData.RAMDA[0],'0.0');
  StrPCopy(@EventData.PSIGMA[0],'0.0');
  StrPCopy(@EventData.SSIGMA[0],'0.0');
  StrPCopy(@EventData.QSIGMA[0],'0.0'); }

  //EventData.PowerMeterOn := False;
  //EventData.PowerMeterNo := FPowerMeterNo;
  EventData.ModBusMode := 0;
  EventData.BlockNo := FPowerMeterNo;
  FIPCClientAll.PulseEventData(EventData);
  //FIPCClient.PulseMonitor(EventData);
  FWT1600CommThread.FEventHandle.Pulse;
end;

procedure TWT1600CommSDIF.OnConnect(Sender: TIPCThread_HiMECS_MDI;
  Connecting: Boolean);
begin
  PostMessage(Handle, WM_UPDATESTATUS_HiMECS_MDI, WPARAM(Connecting), 0);
end;

procedure TWT1600CommSDIF.OnSignal(Sender: TIPCThread_HiMECS_MDI;
  Data: TEventData_HiMECS_MDI);
begin
  Flags := Data.Flags;
end;

procedure TWT1600CommSDIF.PSIGMADblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel29.Caption;
    LWatchF.FWatchTag := Panel29.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.QSIGMADblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel31.Caption;
    LWatchF.FWatchTag := Panel31.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.RAMDADblClick(Sender: TObject);
var
  LWatchF: TWatchF;
begin
  LWatchF := TWatchF.Create(self);

  try
    WatchList.LockList.Add(LWatchF);
    LWatchF.FLabelName := Panel34.Caption;
    LWatchF.FWatchTag := Panel34.Tag;
    LWatchF.FWatchName := FIPAddress;
    LWatchF.Show;
  finally
    WatchList.UnlockList;
  end;
end;

procedure TWT1600CommSDIF.iSwitchLed1Click(Sender: TObject);
begin
  FWT1600CommThread.StopComm := not FWT1600CommThread.StopComm;
  iSwitchLed2.Active := not FWT1600CommThread.StopComm;
end;

procedure TWT1600CommSDIF.DestroyAll;
begin
  FCriticalSection.Enter;

  //FWT1600CommThread.StopComm := True;

  if FWT1600CommThread.Suspended then
    FWT1600CommThread.Resume;

  FWT1600CommThread.FEventHandle.Signal;
  DisplayMessage('FWT1600CommThread.FEventHandle.Signal', TDisplayTarget(1));
  FWT1600CommThread.Terminate;
  DisplayMessage('FWT1600CommThread.Terminate', TDisplayTarget(1));


  //FWT1600CommThread.WaitFor;
  //DisplayMessage('FWT1600CommThread.WaitFor', TDisplayTarget(1));
  //FWT1600CommThread.Free;
  //DisplayMessage('FWT1600CommThread.Free', TDisplayTarget(1));

  if FWT1600PingThread.Suspended then
    FWT1600PingThread.Resume;

  FWT1600PingThread.FEventHandle.Signal;
  DisplayMessage('FWT1600PingThread.FEventHandle.Signal', TDisplayTarget(1));
  FWT1600PingThread.Terminate;
  DisplayMessage('FWT1600PingThread.Terminate', TDisplayTarget(1));
  //FWT1600PingThread.WaitFor;
  //DisplayMessage('FWT1600PingThread.WaitFor', TDisplayTarget(1));
  //FWT1600PingThread.Free;
  //DisplayMessage('FWT1600PingThread.Free', TDisplayTarget(1));

  FIPCClientAll.Free;

  FreeAndNil(FSendCommandList);//.Free;
  DisplayMessage('FreeAndNil(FSendCommandList)', TDisplayTarget(1));
  //FEventHandle.Free;

//  while FThreadPool.RunningThreadCount > 0 do
//    FThreadPool.CleanUp;
  //try FThreadPool.Free; except end; //wait for ThreadPool threads
  if Assigned(FpjhSTOMPClass) then
    FpjhSTOMPClass.Free;

  FCriticalSection.Leave;
  FreeAndNil(FCriticalSection);//.Free;
  DisplayMessage('FreeAndNil(FCriticalSection)', TDisplayTarget(1));
end;

end.
