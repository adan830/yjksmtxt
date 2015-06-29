object TotalScoreForm: TTotalScoreForm
  Left = 0
  Top = 0
  Caption = 'TotalScoreForm'
  ClientHeight = 508
  ClientWidth = 737
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    737
    508)
  PixelsPerInch = 96
  TextHeight = 13
  object redt1: TRichEdit
    Left = 8
    Top = 8
    Width = 721
    Height = 113
    Anchors = [akLeft, akTop, akRight]
    Enabled = False
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      #12288#12288#27719#24635#19978#25253#26159#25351#23558#25152#26377#32771#35797#26381#21153#22120#19978#30340#8220#25104#32489#24211#8221#27719#24635#21040#19968#20010#24635#30340#25104#32489#24211#26469#19978#25253#65292#21516#26102#20063#26041#20415#26816#26597#24050#32771#12289#26410#32771#12289#32570
      #32771#12289#20316#24330#12289#25104#32489#24322#24120#30340#32771#29983#65292#20351#19978#25253#25104#32489#25968#25454#26356#21152#20934#30830#23436#25972#12290
      #12288#12288#27719#24635#26102#65292#35831#23558#25152#26377#26381#21153#22120#19978#30340#8220#25104#32489#24211'.mdb'#8221#25991#20214#22797#21046#21040#19968#20010#25991#20214#22841#20013#65292#28857#20987#27719#24635#65292#31243#24207#23558#33258#21160#23558#25351#23450#25991#20214#22841#19979#25152#26377#25104#32489#24211#27719#24635
      #21040#19968#20010#25991#20214#12290
      #12288#12288#19978#25253#26102#65292#21482#38656#23558#27719#24635#24471#21040#30340#19968#20010#8220#25104#32489#24211'.mdb'#8221#19978#25253#21363#21487#12290)
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    Zoom = 100
  end
  object scbTotalDir: TcxShellComboBox
    Left = 182
    Top = 151
    Properties.ShowFullPath = sfpAlways
    TabOrder = 1
    Width = 337
  end
  object lst1: TListBox
    Left = 8
    Top = 175
    Width = 193
    Height = 274
    ItemHeight = 13
    TabOrder = 2
  end
  object cxLabel10: TcxLabel
    Left = 32
    Top = 152
    Caption = #38656#21512#24182#25104#32489#24211#25991#20214#22841#65306
  end
  object cxGrid2: TcxGrid
    Left = 176
    Top = 178
    Width = 553
    Height = 272
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 4
    object tvSource: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          FieldName = 'ExamineeName'
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      object clmnSourceExamineeNo: TcxGridDBColumn
        DataBinding.FieldName = 'ExamineeID'
        Width = 99
      end
      object clmnSourceExamineeName: TcxGridDBColumn
        DataBinding.FieldName = 'ExamineeName'
      end
      object clmnSourceIP: TcxGridDBColumn
        DataBinding.FieldName = 'IP'
      end
      object clmnSourcePort: TcxGridDBColumn
        DataBinding.FieldName = 'Port'
        Width = 51
      end
      object clmnSourceStatus: TcxGridDBColumn
        DataBinding.FieldName = 'Status'
      end
      object clmnSourceRemainTime: TcxGridDBColumn
        DataBinding.FieldName = 'RemainTime'
      end
      object clmnSourceTimeStamp: TcxGridDBColumn
        DataBinding.FieldName = 'Stamp'
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = tvSource
    end
  end
  object btnTotals: TButton
    Left = 542
    Top = 147
    Width = 97
    Height = 25
    Caption = #27719#24635
    TabOrder = 5
    OnClick = btnTotalsClick
  end
end
