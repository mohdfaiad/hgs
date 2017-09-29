unit IPCThrd_ECS_kumo;

{
  IPCThrd Unit���� ������ �߰���
  1. IPCThread ���� Create�� ��ɼ���(Shared Memeory ������ �̸��� �Ű������� �Ҵ���)
}

interface

uses
  SysUtils, Classes, Windows, MyKernelObject, IPCThrdConst_ECS_kumo;

{$MINENUMSIZE 4}  { DWORD sized enums to keep TEventInfo DWORD aligned }


const
  BUF_SIZE = 1 * 1024;

{ IPC Classes }

{ These are the classes used by the Monitor and Client to perform the
  inter-process communication }

type

  EMonitorActive = class(Exception);

  TIPCThread_ECS_kumo = class;

{ TIPCEvent_ECS_kumo }

{ Win32 events are very basic.  They are either signaled or non-signaled.
  The TIPCEvent2 class creates a "typed" TEvent, by using a block of shared
  memory to hold an "EventKind" property.  The shared memory is also used
  to hold an ID, which is important when running multiple clients, and
  a Data area for communicating data along with the event }

  TEventKind_ECS_kumo = (
    evMonitorSignal,    // Monitor signaling client
    evClientSignal,     // Client signaling monitor
    evClientExit        // Client is exiting
  );

  // �ٸ� ������Ʈ�� ����� �� �κ��� �����ؾ� ��. (change)
  // �ݵ�� �ش� ���丮�� �����Ͽ� ����� ��.
  TClientFlag_ECS_kumo = (cfError, cfModBusCom);
  TClientFlag_ECS_kumos = set of TClientFlag_ECS_kumo;

  PEventData_ECS_kumo = ^TEventData_ECS_kumo;
  TEventData_ECS_kumo = packed record
    InpDataBuf: array[0..255] of integer;
    InpDataBuf2: array[0..255] of Byte;
    InpDataBuf_double: array[0..255] of double;
    NumOfData: integer;//����Ÿ ���� �ݳ�
    NumOfBit: integer;//Bit ���� �ݳ�(01 function �� ��� Bit ������ ���޵Ǳ� ������)
    //Block Mode �ϰ�� Modbus Block Start Address,
    //Individual Mode�ϰ�� Modbus Address
    ModBusFunctionCode: integer;
    ModBusAddress: string[5];//String ������ �����޸𸮿� ��� �Ұ���
    //ModBusAddress: array[0..19] of char;//String ������ �����޸𸮿� ��� �Ұ���
    //ASCII Mode = 0, RTU Mode = 1, RTU mode simulation = 3;
    ModBusMode: integer;
    BlockNo: integer;
    ModBusMapFileName: string[255];
  end;

  TIPCNotifyEvent_ECS_kumo = procedure (Sender: TIPCThread_ECS_kumo; Data: TEventData_ECS_kumo) of Object;

  PIPCEventInfo_ECS_kumo = ^TIPCEventInfo_ECS_kumo;
  TIPCEventInfo_ECS_kumo = record
    FID: Integer;
    FKind: TEventKind_ECS_kumo;
    FData: TEventData_ECS_kumo;
  end;

  TIPCEvent_ECS_kumo = class(TEvent)
  private
    FOwner: TIPCThread_ECS_kumo;
    FOwnerID: Integer;
    FSharedMem: TSharedMem;
    function GetID: Integer;
    procedure SetID(Value: Integer);
    function GetKind: TEventKind_ECS_kumo;
    procedure SetKind(Value: TEventKind_ECS_kumo);
    function GetData: TEventData_ECS_kumo;
    procedure SetData(Value: TEventData_ECS_kumo);
  public
    FEventInfo: PIPCEventInfo_ECS_kumo;

    constructor Create(AOwner: TIPCThread_ECS_kumo; const Name: string; Manual: Boolean);
    destructor Destroy; override;
    procedure Signal(Kind: TEventKind_ECS_kumo);
    procedure SignalID(Kind: TEventKind_ECS_kumo; ID: Integer);
    procedure SignalData(Kind: TEventKind_ECS_kumo; ID: Integer; Data: TEventData_ECS_kumo);
    procedure PulseData(Kind: TEventKind_ECS_kumo; ID: Integer; Data: TEventData_ECS_kumo);
    function WaitFor(TimeOut, ID: Integer; Kind: TEventKind_ECS_kumo): Boolean;
    property ID: Integer read GetID write SetID;
    property Kind: TEventKind_ECS_kumo read GetKind write SetKind;
    property Data: TEventData_ECS_kumo read GetData write SetData;
    property OwnerID: Integer read FOwnerID write FOwnerID;
  end;

{ TIPCThread_ECS_kumo }

{ The TIPCThread_ECS_kumo class implements the functionality which is common between
  the monitor and client thread classes. }

  TIPCThread_ECS_kumo = class(TThread)
  protected
    FID: Integer;
    FName: string;
    FClientEvent: TIPCEvent_ECS_kumo;
    FOnSignal: TIPCNotifyEvent_ECS_kumo;
  public
    FMonitorEvent: TIPCEvent_ECS_kumo;

    constructor Create(AID: Integer; const AName: string; AMalual: Boolean);
    destructor Destroy; override;
    procedure DbgStr(const S: string);
  published
    property OnSignal: TIPCNotifyEvent_ECS_kumo read FOnSignal write FOnSignal;
  end;

implementation

uses TypInfo;

{ TIPCEvent_ECS_kumo }

constructor TIPCEvent_ECS_kumo.Create(AOwner: TIPCThread_ECS_kumo; const Name: string;
  Manual: Boolean);
begin
  inherited Create(Name, Manual);
  FOwner := AOwner;
  FSharedMem := TSharedMem.Create(Format('%s.Data', [Name]), SizeOf(TIPCEventInfo_ECS_kumo));
  FEventInfo := FSharedMem.Buffer;
end;

destructor TIPCEvent_ECS_kumo.Destroy;
begin
  FSharedMem.Free;
  inherited Destroy;
end;

function TIPCEvent_ECS_kumo.GetID: Integer;
begin
  Result := FEventInfo.FID;
end;

procedure TIPCEvent_ECS_kumo.SetID(Value: Integer);
begin
  FEventInfo.FID := Value;
end;

function TIPCEvent_ECS_kumo.GetKind: TEventKind_ECS_kumo;
begin
  Result := FEventInfo.FKind;
end;

procedure TIPCEvent_ECS_kumo.SetKind(Value: TEventKind_ECS_kumo);
begin
  FEventInfo.FKind := Value;
end;

function TIPCEvent_ECS_kumo.GetData: TEventData_ECS_kumo;
begin
  Result := FEventInfo.FData;
end;

procedure TIPCEvent_ECS_kumo.SetData(Value: TEventData_ECS_kumo);
begin
  FEventInfo.FData := Value;
end;

procedure TIPCEvent_ECS_kumo.Signal(Kind: TEventKind_ECS_kumo);
begin
  FEventInfo.FID := FOwnerID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_ECS_kumo.SignalID(Kind: TEventKind_ECS_kumo; ID: Integer);
begin
  FEventInfo.FID := ID;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_ECS_kumo.SignalData(Kind: TEventKind_ECS_kumo; ID: Integer; Data: TEventData_ECS_kumo);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Signal;
end;

procedure TIPCEvent_ECS_kumo.PulseData(Kind: TEventKind_ECS_kumo; ID: Integer; Data: TEventData_ECS_kumo);
begin
  FEventInfo.FID := ID;
  FEventInfo.FData := Data;
  FEventInfo.FKind := Kind;
  inherited Pulse;
end;

function TIPCEvent_ECS_kumo.WaitFor(TimeOut, ID: Integer; Kind: TEventKind_ECS_kumo): Boolean;
begin
  Result := Wait(TimeOut);
  if Result then
    Result := (ID = FEventInfo.FID) and (Kind = FEventInfo.FKind);
end;

{ TIPCThread_ECS_kumo }

constructor TIPCThread_ECS_kumo.Create(AID: Integer; const AName: string; AMalual: Boolean);
begin
  inherited Create(True);
  FID := AID;
  FName := AName;
  FMonitorEvent := TIPCEvent_ECS_kumo.Create(Self, AName+'_'+MONITOR_EVENT_NAME, AMalual);
end;

destructor TIPCThread_ECS_kumo.Destroy;
begin
  Terminate;
  //FMonitorEvent.Signal(TEventKind_ECS_kumo(0));
  //Client ����� Monitor���� FMonitorEvent �� ��� Signaled ���·� �����־
  //CPU �������� ����ϴ� ���� �ذ� ���� �Ʒ� �ڵ�� ��ü��
  FMonitorEvent.Pulse;
  inherited Destroy;
  FMonitorEvent.Free;
end;

{ This procedure is called all over the place to keep track of what is
  going on }

procedure TIPCThread_ECS_kumo.DbgStr(const S: string);
begin
{$IFDEF DEBUG}
  //FTracer.Add(PChar(S));
{$ENDIF}
end;

end.