class Const

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
    # @property [Int] BUTTON ボタン
    BUTTON = 1
    # @property [Int] ARROW 矢印
    ARROW = 2
  end
  ITEM_PATH_LIST = {ItemType::ARROW.to_s.to_sym => 'arrow', ItemType::BUTTON.to_s.to_sym => 'button'}

  # アイテム種別
  class ItemDrawType
    # @property [Int] CANVAS CANVAS
    CANVAS = 0
    # @property [Int] CSS CSS
    CSS = 1
  end

  # アイテムに対する操作アクション(履歴用)
  class ItemActionType
    # @property [Int] MAKE 作成
    MAKE = 0
    # @property [Int] MOVE 移動
    MOVE = 1
    # @property [Int] CHANGE_OPTION オプション(デザイン)変更
    CHANGE_OPTION = 2
    # @property [Int] DELETE 削除
    DELETE = 3
  end

  # アイテムアクションの引数
  class ItemActionOptionType
    # @property [Int] INTEGER 数値
    INTEGER = 0
    # @property [Int] STRING 文字列
    STRING = 1
    # @property [Int] COLOR 色
    COLOR = 2
    # @property [Int] DESIGN デザイン
    DESIGN = 3
  end

  # アクションイベント種別
  class ActionEventType
    # @property [Int] SCROLL スクロール
    SCROLL = 0
    # @property [Int] CLICK クリック
    CLICK = 1
  end

  # 共通アクションイベント対象
  class CommonActionEventTargetType
    # @property [Int] BACKGROUND 背景
    BACKGROUND = 0
    # @property [Int] ZOOM ズーム
    ZOOM = 1
  end

  # アクション変更種別
  class ActionEventChangeType
    # @property [Int] DRAW 描画(新規作成 etc.)
    DRAW = 0
    # @property [Int] ANIMATION アニメーション(移動、サイズ変更 etc.)
    ANIMATION = 1
    # @property [Int] CHANGE_OPTION オプション(デザイン)変更
    CHANGE_OPTION = 2
    # @property [Int] DELETE 削除
    DELETE = 3
  end

  # キーコード
  class KeyboardKeyCode
    # @property [Int] z zボタン
    Z = 90
  end

  class ElementAttribute
    TE_VALUES_DIV = 'timeline_event_value_@itemid_@methodname'
  end
end