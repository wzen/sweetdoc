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
      # @property [Int] z zボタン
      @Z = constant.KeyboardKeyCode.Z

    class @CssClassName
      @EDIT_SELECTED = constant.CssClassName.EDIT_SELECTED
