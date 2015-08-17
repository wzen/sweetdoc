if gon?
  # 定数
  constant = gon.const

  class Constant
    # @property OPERATION_STORE_MAX 操作履歴保存最大数
    @OPERATION_STORE_MAX = constant.OPERATION_STORE_MAX
    # @property [Array] ITEM_PATH_LIST JSファイル名
    @ITEM_PATH_LIST = constant.ITEM_PATH_LIST
    # @property [String] EVENT_ITEM_SEPERATOR イベント(アイテム)値のセパレータ
    @EVENT_ITEM_SEPERATOR = "&"
    # @property [String] EVENT_COMMON_PREFIX 共通イベントプレフィックス
    @EVENT_COMMON_PREFIX = constant.EVENT_COMMON_PREFIX

    # ZIndex
    class @Zindex
      @GRID = 5
      @EVENTBOTTOM = constant.Zindex.EVENTBOTTOM
      @EVENTFLOAT = constant.Zindex.EVENTFLOAT
      @MAX = constant.Zindex.MAX

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

    # ページ内値保存キー
    class @PageValueKey
      # @property [String] PV_ROOT ページ値ルート
      @PV_ROOT = constant.PageValueKey.PV_ROOT
      # @property [String] E_ROOT イベント値ルート
      @E_ROOT = constant.PageValueKey.E_ROOT
      # @property [String] E_PREFIX イベントプレフィックス
      @E_PREFIX = constant.PageValueKey.E_PREFIX
      # @property [String] E_COUNT イベント数
      @E_COUNT = constant.PageValueKey.E_COUNT
      # @property [String] E_CSS CSSデータ
      @E_CSS = constant.PageValueKey.E_CSS
      # @property [String] PAGE_VALUES_SEPERATOR ページ値のセパレータ
      @PAGE_VALUES_SEPERATOR = constant.PageValueKey.PAGE_VALUES_SEPERATOR
      # @property [String] E_NUM_PREFIX イベント番号プレフィックス
      @E_NUM_PREFIX = constant.PageValueKey.E_NUM_PREFIX
      # @property [String] ITEM_PREFIX アイテムプレフィックス
      @ITEM_PREFIX = 'item'
      # @property [String] ITEM アイテムRoot
      @ITEM_VALUE = @ITEM_PREFIX + ':@id:value'
      # @property [String] ITEM アイテムキャッシュRoot
      @ITEM_VALUE_CACHE = @ITEM_PREFIX + ':cache:@id:value'
      # @property [String] ITEM_INFO_PREFIX アイテム情報プレフィックス
      @ITEM_INFO_PREFIX = 'iteminfo'
      # @property [String] ITEM_DEFAULT_METHODNAME デフォルトメソッド名
      @ITEM_DEFAULT_METHODNAME = @ITEM_INFO_PREFIX + ':@item_id:default:methodname'
      # @property [String] ITEM_DEFAULT_METHODACTIONTYPE デフォルトアクションタイプ
      @ITEM_DEFAULT_ACTIONTYPE = @ITEM_INFO_PREFIX + ':@item_id:default:actiontype'
      # @property [String] ITEM_DEFAULT_ANIMATIONTYPE デフォルトアニメーションタイプ
      @ITEM_DEFAULT_ANIMATIONTYPE = @ITEM_INFO_PREFIX + ':@item_id:default:animationtype'
      # @property [String] CONFIG_OPENED_SCROLL コンフィグ表示時のスクロール位置保存
      @CONFIG_OPENED_SCROLL = 'config_opened_scroll'
      # @property [String] IS_RUNWINDOW_RELOAD Runビューをリロードしたか
      @IS_RUNWINDOW_RELOAD = constant.PageValueKey.IS_RUNWINDOW_RELOAD

    class @ElementAttribute
      # @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
      @DESIGN_CONFIG_ROOT_ID = 'design_config_@id'

    class @CommonActionEventChangeType
      # @property [Int] BACKGROUND 背景
      @BACKGROUND = constant.CommonActionEventChangeType.BACKGROUND
      # @property [Int] SCREEN 画面表示
      @SCREEN = constant.CommonActionEventChangeType.SCREEN
