if gon?

  constant = gon.const

  # アプリ共通定数
  class Constant
    # @property [String] EVENT_ITEM_SEPERATOR イベント(アイテム)値のセパレータ
    @EVENT_ITEM_SEPERATOR = "&"
    # @property [String] EVENT_COMMON_PREFIX 共通イベントプレフィックス
    @EVENT_COMMON_PREFIX = constant.EVENT_COMMON_PREFIX

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

    # アイテム種別
    class @ItemId
      # @property [Int] ARROW 矢印
      @ARROW = constant.ItemId.ARROW
      # @property [Int] BUTTON ボタン
      @BUTTON = constant.ItemId.BUTTON

    # アイテムに対するアクション
    class @ItemActionType
      # @property [Int] MAKE 作成
      @MAKE = constant.ItemActionType.MAKE
      # @property [Int] MOVE 移動
      @MOVE = constant.ItemActionType.MOVE
      # @property [int] CHANGE_OPTION オプション変更
      @CHANGE_OPTION = constant.ItemActionType.CHANGE_OPTION

    # アクションイベント種別
    class @ActionEventHandleType
      # @property [Int] SCROLL スクロール
      @SCROLL = constant.ActionEventHandleType.SCROLL
      # @property [Int] CLICK クリック
      @CLICK = constant.ActionEventHandleType.CLICK

    # アクションイベントクラス名
    class @ActionEventTypeClassName
      # @property [Int] BLANK ブランク
      @BLANK = constant.ActionEventTypeClassName.BLANK
      # @property [Int] SCROLL スクロール
      @SCROLL = constant.ActionEventTypeClassName.SCROLL
      # @property [Int] CLICK クリック
      @CLICK = constant.ActionEventTypeClassName.CLICK

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
      # @property [String] MAIN_TEMP_ID mainコンテンツテンプレート
      @MAIN_TEMP_ID = constant.ElementAttribute.MAIN_TEMP_ID
      # @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
      @DESIGN_CONFIG_ROOT_ID = 'design_config_@id'
      # @property [String] NAVBAR_ROOT ナビヘッダーRoot
      @NAVBAR_ROOT = constant.ElementAttribute.NAVBAR_ROOT
      # @property [String] RUN_CSS CSSスタイルRoot
      @RUN_CSS = constant.ElementAttribute.RUN_CSS

    # 共通イベントタイプ
    class @CommonActionEventChangeType
      # @property [Int] BACKGROUND 背景
      @BACKGROUND = constant.CommonActionEventChangeType.BACKGROUND
      # @property [Int] SCREEN 画面表示
      @SCREEN = constant.CommonActionEventChangeType.SCREEN

    # モーダルビュータイプ
    class @ModalViewType
      @ABOUT = constant.ModalViewType.ABOUT

    # スクロール方向
    class @ScrollDirection
      @TOP = constant.ScrollDirection.TOP
      @BOTTOM = constant.ScrollDirection.BOTTOM
      @LEFT = constant.ScrollDirection.LEFT
      @RIGHT = constant.ScrollDirection.RIGHT

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