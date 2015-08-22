object frmScore: TfrmScore
  Left = 0
  Top = 0
  Width = 720
  Height = 493
  Caption = #27719#24635#25104#32489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  DesignSize = (
    712
    459)
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 8
    Top = 32
    Width = 689
    Height = 401
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tvscore: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = dmMain.dsScore
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = tvscorestatus
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsView.Footer = True
      object tvscorezkh: TcxGridDBColumn
        DataBinding.FieldName = 'zkh'
      end
      object tvscorexm: TcxGridDBColumn
        DataBinding.FieldName = 'xm'
      end
      object tvscorezsj: TcxGridDBColumn
        DataBinding.FieldName = 'zsj'
      end
      object tvscorestatus: TcxGridDBColumn
        DataBinding.FieldName = 'status'
      end
      object tvscorexz1_fs: TcxGridDBColumn
        DataBinding.FieldName = 'xz1_fs'
      end
      object tvscorepd_fs: TcxGridDBColumn
        DataBinding.FieldName = 'pd_fs'
      end
      object tvscoredz_fs: TcxGridDBColumn
        DataBinding.FieldName = 'dz_fs'
      end
      object tvscorewin_fs: TcxGridDBColumn
        DataBinding.FieldName = 'win_fs'
      end
      object tvscoreword_fs: TcxGridDBColumn
        DataBinding.FieldName = 'word_fs'
      end
      object tvscoreexcel_fs: TcxGridDBColumn
        DataBinding.FieldName = 'excel_fs'
      end
      object tvscoreppt_fs: TcxGridDBColumn
        DataBinding.FieldName = 'ppt_fs'
      end
      object tvscoreie_fs: TcxGridDBColumn
        DataBinding.FieldName = 'ie_fs'
      end
      object tvscorezf: TcxGridDBColumn
        DataBinding.FieldName = 'zf'
      end
      object tvscorexzinfo: TcxGridDBColumn
        DataBinding.FieldName = 'xzinfo'
        PropertiesClassName = 'TcxBlobEditProperties'
      end
      object tvscorepdinfo: TcxGridDBColumn
        DataBinding.FieldName = 'pdinfo'
        PropertiesClassName = 'TcxBlobEditProperties'
      end
      object tvscoredzinfo: TcxGridDBColumn
        DataBinding.FieldName = 'dzinfo'
      end
      object tvscorewininfo: TcxGridDBColumn
        DataBinding.FieldName = 'wininfo'
        PropertiesClassName = 'TcxBlobEditProperties'
      end
      object tvscorewordinfo: TcxGridDBColumn
        DataBinding.FieldName = 'wordinfo'
        PropertiesClassName = 'TcxBlobEditProperties'
      end
      object tvscoreexcelinfo: TcxGridDBColumn
        DataBinding.FieldName = 'excelinfo'
        PropertiesClassName = 'TcxBlobEditProperties'
      end
      object tvscorepptinfo: TcxGridDBColumn
        DataBinding.FieldName = 'pptinfo'
        PropertiesClassName = 'TcxBlobEditProperties'
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = tvscore
    end
  end
  object cxButton1: TcxButton
    Left = 16
    Top = 8
    Width = 75
    Height = 25
    Caption = #25171#24320
    TabOrder = 1
    OnClick = cxButton1Click
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 8
    Width = 75
    Height = 25
    Caption = 'cxButton2'
    TabOrder = 2
  end
end
