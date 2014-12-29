class Const

  # @property SURFACE_IMAGE_MARGIN Canvasの背景貼り付け時のマージン
  SURFACE_IMAGE_MARGIN = 5
  # @porperty ZINDEX_MAX z-indexの最大値
  ZINDEX_MAX = 1000
  # @property OPERATION_STORE_MAX 操作履歴保存最大数
  OPERATION_STORE_MAX = 30

  # 操作モード
  class Mode
    # @property [Int] DRAW 描画
    DRAW = 0
    # @property [Int] EDIT 画面編集
    EDIT = 1
    # @property [Int] OPTION アイテムオプション
    OPTION = 2
  end

  # アイテム種別
  class ItemType
    # @property [Int] ARROW 矢印
    ARROW = 0
    # @property [Int] BUTTON ボタン
    BUTTON = 1
  end
  ITEM_PATH_LIST = {ItemType::ARROW.to_s.to_sym => 'arrow', ItemType::BUTTON.to_s.to_sym => 'button'}

  # アイテムに対するアクション
  class ItemActionType
    # @property [Int] MAKE 作成
    MAKE = 0
    # @property [Int] MOVE 移動
    MOVE = 1
    # @property [Int] CHANGE_OPTION オプション変更
    CHANGE_OPTION = 2
    # @property [Int] DELETE 削除
    DELETE = 3
  end

  # アクションイベント種別
  class ActionEventType
    # @property [Int] SCROLL スクロール
    SCROLL = 0
    # @property [Int] CLICK クリック
    CLICK = 1
  end

  # 閲覧モードのアクション変更種別
  class ChapterActionType
    # @property [Int] DRAW 描画
    DRAW = 0
    # @property [Int] CHANGE 変更
    CHANGE = 1
  end

  # キーコード
  class KeyboardKeyCode
    # @property [Int] z zボタン
    Z = 90
  end

  class CssClassName
    EDIT_SELECTED = 'editSelected'
  end

end