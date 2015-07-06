if gon?
  # 定数
  constant = gon.const

  class Constant
    # @porperty ZINDEX_MAX z-indexの最大値
    @ZINDEX_MAX = constant.ZINDEX_MAX
    # @property OPERATION_STORE_MAX 操作履歴保存最大数
    @OPERATION_STORE_MAX = constant.OPERATION_STORE_MAX
    # @property [Array] ITEM_PATH_LIST JSファイル名
    @ITEM_PATH_LIST = constant.ITEM_PATH_LIST
    # @property [String] PAGE_VALUES_SEPERATOR ページ値のセパレータ
    @PAGE_VALUES_SEPERATOR = ":"
    # @property [String] TIMELINE_ITEM_SEPERATOR タイムラインイベント(アイテム)値のセパレータ
    @TIMELINE_ITEM_SEPERATOR = "&"
    # @property [String] TIMELINE_COMMON_PREFIX 共通タイムラインイベントプレフィックス
    @TIMELINE_COMMON_PREFIX = constant.TIMELINE_COMMON_PREFIX
    # @property TIMELINE_COMMON_ACTION_CLASSNAME 共通タイムラインイベント アクションクラス名
    @TIMELINE_COMMON_ACTION_CLASSNAME = constant.TIMELINE_COMMON_ACTION_CLASSNAME

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

    # 閲覧モードのチャプターアクション種類
    class @ActionEventChangeType
      # @property [Int] DRAW 描画
      @DRAW = constant.ActionEventChangeType.DRAW
      # @property [Int] ANIMATION CSSアニメーション
      @ANIMATION = constant.ActionEventChangeType.ANIMATION
      # @property [Int] OPTION_CHANGE デザイン変更
      @CHANGE_OPTION = constant.ActionEventChangeType.CHANGE_OPTION
      # @property [Int] DELETE 削除
      @DELETE = constant.ActionEventChangeType.DELETE

    # キーコード
    class @KeyboardKeyCode
      # @property [Int] Z zボタン
      @Z = constant.KeyboardKeyCode.Z

    # ページ内値保存キー
    class @PageValueKey
      # @property [String] ITEM アイテムRoot
      @ITEM_VALUE = 'item:@id:value'
      # @property [String] ITEM アイテムキャッシュRoot
      @ITEM_VALUE_CACHE = 'item:cache:@id:value'
      # @property [String] CONFIG_OPENED_SCROLL コンフィグ表示時のスクロール位置保存
      @CONFIG_OPENED_SCROLL = 'config_opened_scroll'
      # @property [String] TE タイムラインイベント数
      @TE_COUNT = 'timeline_event:count'

    class @ElementAttribute
      # @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
      @DESIGN_CONFIG_ROOT_ID = 'design_config_@id'

    class @CommonActionEventChangeType
      # @property [Int] BACKGROUND 背景
      @BACKGROUND = constant.CommonActionEventChangeType.BACKGROUND
      # @property [Int] MOVE ズーム
      @MOVE = constant.CommonActionEventChangeType.MOVE
