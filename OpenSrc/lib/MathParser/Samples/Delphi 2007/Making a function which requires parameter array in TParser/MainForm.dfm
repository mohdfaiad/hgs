object Main: TMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Sample'
  ClientHeight = 90
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object laHint: TLabel
    Left = 8
    Top = 8
    Width = 473
    Height = 16
    AutoSize = False
    BiDiMode = bdLeftToRight
    Caption = 
      'We have the new function "Largest" which returns the largest par' +
      'ameter.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
    WordWrap = True
  end
  object Bevel: TBevel
    Left = 8
    Top = 45
    Width = 476
    Height = 37
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 473
    Height = 16
    AutoSize = False
    BiDiMode = bdLeftToRight
    Caption = 'The number of input parameters is unlimited:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
    WordWrap = True
  end
  object eFormula: TEdit
    Left = 97
    Top = 53
    Width = 379
    Height = 21
    TabOrder = 1
    Text = 'Largest (10, 20, Pi, 4, 1, Pi ^ 2, 3!)'
  end
  object bExecute: TButton
    Left = 16
    Top = 53
    Width = 75
    Height = 21
    Caption = 'Execute'
    Default = True
    TabOrder = 0
    OnClick = bExecuteClick
  end
end
