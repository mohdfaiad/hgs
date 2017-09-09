unit DataModule_Unit;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Ora, MemDS, OraTransaction,
  OraSmart, OraCall;

type
  TDM1 = class(TDataModule)
    OraSession1: TOraSession;
    OraQuery1: TOraQuery;
    OraTransaction1: TOraTransaction;
    OraDataSource1: TOraDataSource;
    OraQuery2: TOraQuery;
    OraSession2: TOraSession;
    OraTransaction2: TOraTransaction;
    OraQuery3: TOraQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM1: TDM1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.