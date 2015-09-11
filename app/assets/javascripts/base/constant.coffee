if gon?

  constant = gon.const

  # アプリ共通定数
  class Constant
    # ZIndex
    class @Zindex
      # @property GRID グリッド線
      @GRID = 5
      # @property EVENTBOTTOM イベント最底面
      @EVENTBOTTOM = constant.Zindex.EVENTBOTTOM
      # @property EVENTFLOAT イベント最高面
      @EVENTFLOAT = constant.Zindex.EVENTFLOAT

    # 操作モード
    class @Mode
      # @property [Int] DRAW 描画
      @DRAW = constant.Mode.DRAW
      # @property [Int] EDIT 画面編集
      @EDIT = constant.Mode.EDIT
      # @property [Int] OPTION アイテムオプション
      @OPTION = constant.Mode.OPTION

    # アクションイベント種別
    class @ActionEventHandleType
      # @property [Int] SCROLL スクロール
      @SCROLL = constant.ActionEventHandleType.SCROLL
      # @property [Int] CLICK クリック
      @CLICK = constant.ActionEventHandleType.CLICK

    # アクションイベントクラス名
    class @TimelineActionTypeClassName
      # @property [Int] BLANK ブランク
      @BLANK = constant.TimelineActionTypeClassName.BLANK
      # @property [Int] SCROLL スクロール
      @SCROLL = constant.TimelineActionTypeClassName.SCROLL
      # @property [Int] CLICK クリック
      @CLICK = constant.TimelineActionTypeClassName.CLICK

    # イベントアクション種類
    class @ActionAnimationType
      # @property [Int] JQUERY_ANIMATION JQeury描画
      @JQUERY_ANIMATION = constant.ActionAnimationType.JQUERY_ANIMATION
      # @property [Int] CSS3_ANIMATION CSS3アニメーション
      @CSS3_ANIMATION = constant.ActionAnimationType.CSS3_ANIMATION

    # キーコード
    class @KeyboardKeyCode
      # @property [Int] Z zボタン
      @Z = constant.KeyboardKeyCode.Z
      # @property [Int] C cボタン
      @C = constant.KeyboardKeyCode.C
      # @property [Int] X xボタン
      @X = constant.KeyboardKeyCode.X
      # @property [Int] V vボタン
      @V = constant.KeyboardKeyCode.V

    class @ElementAttribute


    # 共通イベントタイプ
    class @CommonActionEventChangeType
      # @property [Int] BACKGROUND 背景
      @BACKGROUND = constant.CommonActionEventChangeType.BACKGROUND
      # @property [Int] SCREEN 画面表示
      @SCREEN = constant.CommonActionEventChangeType.SCREEN

    # モーダルビュータイプ
    class @ModalViewType
      # @property [Int] ABOUT 概要
      @ABOUT = constant.ModalViewType.ABOUT

    # ページング
    class @Paging
      @ROOT_ID = constant.Paging.ROOT_ID
      @MAIN_PAGING_SECTION_CLASS = constant.Paging.MAIN_PAGING_SECTION_CLASS
      @NAV_ROOT_ID = constant.Paging.NAV_ROOT_ID
      @NAV_SELECTED_CLASS = constant.Paging.NAV_SELECTED_CLASS
      @NAV_SELECT_ROOT_CLASS = constant.Paging.NAV_SELECT_ROOT_CLASS
      @NAV_MENU_NAME = 'Page @pagenum'
      @NAV_MENU_CLASS = 'paging-@pagenum'
      @NAV_MENU_ADDPAGE_CLASS = 'paging-new'
      @PRELOAD_PAGEVALUE_NUM = 0