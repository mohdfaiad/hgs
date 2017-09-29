unit ModbusComStruct;

interface

Type
  THiMap = class(TObject)
    FSid: integer;//ID = 200�� ���� Block Scanning��
    FName: string;//�̸�
    FAddress: string;//Modbus �ּ�
    FDescription: string;//����
    FBlockNo: integer;//ModBus Block Scanning ��ȣ(DB�� cnt �ʵ� ��)
    FMaxval: real;//�ִ밪
    FUnit: string;//����
    FAlarm: Boolean;//Alarm�̸� True
    FValue: Variant;//������� �޴� ��
    //FValue2: Variant;//FValue�� ���������� ��ȯ�� ��
    FContact: Integer;//1: A����(1�϶� On), 2: B����(1�϶� Off), 3: C����
    FListIndex: integer;//FAddressMap���� index
    FListIndexNoDummy: integer;//FAddressMap���� index(dummy�� �ǳʶ�-simulate�� �����Ͱ� dummy�� ���� ���·� ��)
  public
    procedure GetMapDataFromFile;

  end;

  TModbusBlock = class(TObject)
    FFunctionCode: integer;
    FStartAddr: string;//Block Scanning ���� �ּ�
    FCount: integer;   //Block Scanning Count
    FBlockNo: integer;
    //4: ptMatrix1, 5: ptMatrix2, 6: ptMatrix3, 7: ptMatrix1f...
    FParamType: integer;
  end;

  TWMModbusData = record
    InpDataBuf: array[0..255] of integer;
    NumOfData: integer;//����Ÿ ���� �ݳ�
    //Block Mode �ϰ�� Modbus Block Start Address,
    //Individual Mode�ϰ�� Modbus Address
    ModBusFunctionCode: integer;
    ModBusAddress: string;
  end;

implementation

{ THiMap }

//File�� ���� Map Data�� �о�ͼ� Ŭ���� ������ ������.
procedure THiMap.GetMapDataFromFile;
begin

end;

end.