object DM1: TDM1
  OldCreateOrder = False
  Height = 585
  Width = 730
  object OraSession1: TOraSession
    Options.Charset = 'KO16KSC5601'
    Options.Direct = True
    Username = 'HITEMS'
    Server = '10.100.23.114:1521:TBACS'
    Connected = True
    LoginPrompt = False
    Schema = 'HITEMS'
    Left = 248
    Top = 40
    EncryptedPassword = 'B7FFB6FFABFFBAFFB2FFACFF'
  end
  object OraQuery1: TOraQuery
    Session = OraSession1
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 312
    Top = 40
  end
  object OraTransaction1: TOraTransaction
    DefaultSession = OraSession1
    Left = 168
    Top = 40
  end
  object OraDataSource1: TOraDataSource
    DataSet = OraQuery1
    Left = 376
    Top = 40
  end
  object OraQuery2: TOraQuery
    Session = OraSession2
    SQL.Strings = (
      'select * from kx01.gtaa004')
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 312
    Top = 120
  end
  object OraSession2: TOraSession
    Options.Direct = True
    Username = 'ku02'
    Server = '10.100.17.11:1521:sn=HIDB'
    LoginPrompt = False
    Left = 248
    Top = 120
    EncryptedPassword = '94FF8AFFCFFFCDFFCFFFC8FFCEFFC8FF'
  end
  object OraTransaction2: TOraTransaction
    DefaultSession = OraSession2
    Left = 168
    Top = 120
  end
  object OraQuery3: TOraQuery
    Session = OraSession1
    FetchAll = True
    Options.TemporaryLobUpdate = True
    Left = 432
    Top = 40
  end
end