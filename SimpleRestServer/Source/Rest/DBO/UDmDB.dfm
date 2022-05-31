object DmDB: TDmDB
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 316
  Width = 302
  object ADGUIxWaitCursor1: TADGUIxWaitCursor
    Provider = 'Forms'
    Left = 120
    Top = 24
  end
  object ADPhysOracleDriverLink1: TADPhysOracleDriverLink
    Left = 200
    Top = 88
  end
  object ADConnection: TADConnection
    FetchOptions.AssignedValues = [evMode, evRecordCountMode, evCursorKind, evAutoFetchAll]
    FetchOptions.Mode = fmAll
    FetchOptions.CursorKind = ckDefault
    FetchOptions.RecordCountMode = cmTotal
    LoginPrompt = False
    Left = 120
    Top = 144
  end
  object adqExe: TADQuery
    Connection = ADConnection
    Left = 120
    Top = 224
  end
  object adqRead: TADQuery
    Connection = ADConnection
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    Left = 40
    Top = 224
  end
  object ADPhysMSSQLDriverLink1: TADPhysMSSQLDriverLink
    Left = 64
    Top = 96
  end
end
