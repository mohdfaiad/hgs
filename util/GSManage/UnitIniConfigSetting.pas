unit UnitIniConfigSetting;

interface

uses IniPersist, UnitConfigIniClass2;

type
  TConfigSettings = class (TINIConfigBase)
  private
//    FMQServerEnable,
    FMQServerIP,
    FMQServerPort,
    FMQServerUserId,
    FMQServerPasswd,
    FMQServerTopic,
    FParamFileName,

    FSalesDirectorEmailAddr,
    FMaterialInputEmailAddr,
    FForeignInputEmailAddr,
    FElecHullRegEmailAddr,
    FShippingReqEmailAddr,
    FFieldServiceReqEmailAddr,
    FSubConPaymentEmailAddr,
    FMyNameSig,
    FShippingPICSig,
    FSalesPICSig,
    FFieldServicePICSig,
    FElecHullRegPICSig,
    FSubConPaymentPICSig
    : string;
  public
    //Section Name, Key Name, Default Key Value  (Control.hint = SectionName;KeyName ���� ���� ��)
//    [IniValue('MQ Server','MQ Server Enable', 'False')]
//    property MQServerEnable : string read FMQServerEnable write FMQServerEnable;
    [IniValue('MQ Server','MQ Server IP','10.14.21.117',1)]
    property MQServerIP : string read FMQServerIP write FMQServerIP;
    [IniValue('MQ Server','MQ Server Port','61613',2)]
    property MQServerPort : string read FMQServerPort write FMQServerPort;
    [IniValue('MQ Server','MQ Server UserId','pjh',3)]
    property MQServerUserId : string read FMQServerUserId write FMQServerUserId;
    [IniValue('MQ Server','MQ Server Passwd','pjh',4)]
    property MQServerPasswd : string read FMQServerPasswd write FMQServerPasswd;
    [IniValue('MQ Server','MQ Server Topic','',5)]
    property MQServerTopic : string read FMQServerTopic write FMQServerTopic;
    [IniValue('File','Param File Name','',6)]




    [IniValue('EMail','���������Դ����','geunhyuk.lim@pantos.com',8)]

    [IniValue('EMail','��ü��ϴ����','seryeongkim@hyundai-gs.com',9)]

    [IniValue('EMail','ǥ�ذ����ϴ����','seryeongkim@hyundai-gs.com',10)]

    [IniValue('EMail','���Ͽ�û�����','yungem.kim@pantos.com',11)]

    [IniValue('EMail','�ʵ弭�񽺴����','yongjunelee@hyundai-gs.com',12)]

    [IniValue('Signature','���̸�����','��ǰ����2�� ������ ����',13)]

    [IniValue('Signature','���ϴ���ڼ���','���佺 ������ ���Ӵ�',14)]

    [IniValue('Signature','�������ڼ���','��ǰ����2�� �ż�����',15)]

    [IniValue('Signature','�ʵ弭�񽺴���ڼ���','�ʵ弭���� �̿��� �����',16)]

    [IniValue('Signature','ǥ�ذ����ϴ���ڼ���','ICT�� �輼�� �����',17)]

    [IniValue('EMail','�⼺ó�������','mjsong@hyundai-gs.com',18)]

    [IniValue('Signature','�⼺ó������ڼ���','�ʵ弭���� �۹��� �����',19)]

  end;

implementation

end.