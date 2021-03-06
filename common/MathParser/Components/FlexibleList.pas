{ *********************************************************************** }
{                                                                         }
{ FlexibleList                                                            }
{                                                                         }
{ Copyright (c) 2008 Pisarev Yuriy (post@pisarev.net)                     }
{                                                                         }
{ *********************************************************************** }

unit FlexibleList;

{$B-}
{$I Directives.inc}

interface

uses
  Windows, Classes, TextList;

type
  TListType = (ltList, ltFast, ltHash);

const
  DefaultListType = ltHash;

type
  TFlexibleList = class(TComponent)
  private
    FListType: TListType;
    FList: TStrings;
    {$IFDEF DELPHI_7}
    function GetNameValueSeparator: Char;
    {$ENDIF}
    procedure SetList(const Value: TStrings);
    procedure SetListType(const Value: TListType);
    {$IFDEF DELPHI_7}
    procedure SetNameValueSeparator(const Value: Char);
    {$ENDIF}
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {$IFDEF DELPHI_7}
    property NameValueSeparator: Char read GetNameValueSeparator
      write SetNameValueSeparator;
    {$ENDIF}
  published
    property List: TStrings read FList write SetList;
    property ListType: TListType read FListType write SetListType
      default DefaultListType;
  end;

implementation

uses
  NumberConsts;

{ TFlexibleList }

procedure TFlexibleList.AssignTo(Dest: TPersistent);
var
  AList: TFlexibleList absolute Dest;
begin
  if Dest is TFlexibleList then
  begin
    AList.List := List;
    AList.ListType := ListType;
  end
  else inherited;
end;

constructor TFlexibleList.Create(AOwner: TComponent);
begin
  inherited;
  ListType := DefaultListType;
end;

destructor TFlexibleList.Destroy;
begin
  FList.Free;
  inherited;
end;

{$IFDEF DELPHI_7}

function TFlexibleList.GetNameValueSeparator: Char;
begin
  if FList is TFastStringList then
    Result := TFastStringList(FList).NameValueSeparator[BIndex]
  else Result := FList.NameValueSeparator;
end;

{$ENDIF}

procedure TFlexibleList.SetList(const Value: TStrings);
begin
  FList.Assign(Value);
end;

procedure TFlexibleList.SetListType(const Value: TListType);
var
  AList: TStrings;
begin
  if not Assigned(FList) or (FListType <> Value) then
  begin
    case Value of
      ltFast: AList := TFastStringList.Create;
      ltHash: AList := THashStringList.Create;
    else AList := TStringList.Create;
    end;
    try
      if Assigned(FList) then AList.Assign(FList);
      Integer(FList) := InterlockedExchange(Integer(AList), Integer(FList));
      FListType := Value;
    finally
      AList.Free;
    end;
  end;
end;

{$IFDEF DELPHI_7}

procedure TFlexibleList.SetNameValueSeparator(const Value: Char);
begin
  if FList is TFastStringList then
    TFastStringList(FList).NameValueSeparator := Value
  else FList.NameValueSeparator := Value;
end;

{$ENDIF}

end.
