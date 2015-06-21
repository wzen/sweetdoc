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

    # 操作モード
    class @Mode
      # @property [Int] DRAW 描画
      @DRAW = constant.Mode.DRAW
      # @property [Int] EDIT 画面編集
      @EDIT = constant.Mode.EDIT
      # @property [Int] OPTION アイテムオプション
      @OPTION = constant.Mode.OPTION

    # アイテム種別
    class @ItemType
      # @property [Int] ARROW 矢印
      @ARROW = constant.ItemType.ARROW
      # @property [Int] BUTTON ボタン
      @BUTTON = constant.ItemType.BUTTON

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

      # @property [String] TE タイムラインイベントRoot
      @TE = 'timeline_event:@te_num'
      # @property [String] TE タイムラインイベント数
      @TE_COUNT = 'timeline_event:count'
      # @property [String] TE_VALUE タイムラインイベント値
      @TE_VALUE = @TE + ':value'
      # @property [String] TE_VALUE タイムライン変更前の値
      #@TE_ORIGINAL_VALUE = @TE + ':originalvalue'
      # @property [String] TE_SORT ソート番号
      @TE_SORT = @TE + ':sort'
      # @property [String] TE_METHODNAME イベント名
      @TE_METHODNAME = @TE + ':mn'
      # @property [String] TE_DELAY 遅延
      @TE_DELAY = @TE + ':delay'

      # @property [String] CONFIG_OPENED_SCROLL コンフィグ表示時のスクロール位置保存
      @CONFIG_OPENED_SCROLL = 'config_opened_scroll'

    class @ElementAttribute
      # @property [String] ITEM_ID アイテム要素ID
      @ITEM_ID = '@it_@id'
      # @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
      @DESIGN_CONFIG_ROOT_ID = 'design_config_@id'
      # @property [String] TE_ITEM_ROOT_ID タイムラインイベントRoot
      @TE_ITEM_ROOT_ID = 'timeline_event_@te_num'
      # @property [String] TE_ACTION_CLASS タイムラインイベント アクション一覧
      @TE_ACTION_CLASS = 'timeline_event_action_@itemid'
      # @property [String] TE_VALUES_DIV タイムラインイベント アクションUI
      @TE_VALUES_CLASS = constant.ElementAttribute.TE_VALUES_CLASS
