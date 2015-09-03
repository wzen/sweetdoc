class Const

  # @property OPERATION_STORE_MAX 操作履歴保存最大数
  OPERATION_STORE_MAX = 30
  # @property EVENT_COMMON_PREFIX 共通イベント クラス名プレフィックス
  EVENT_COMMON_PREFIX = 'c_'

  # 操作モード
  class Mode
    # @property [Int] DRAW 描画
    DRAW = 0
    # @property [Int] EDIT 画面編集
    EDIT = 1
    # @property [Int] OPTION アイテムオプション
    OPTION = 2
  end

  # ZIndex
  class Zindex
    # @porperty EVENTBOTTOM イベントz-idex最小値
    EVENTBOTTOM = 10
    # @porperty EVENTFLOAT イベントz-index最大値
    EVENTFLOAT = 9999
  end

  # アイテム種別
  class ItemId
    # @property [Int] BUTTON ボタン
    BUTTON = 1
    # @property [Int] ARROW 矢印
    ARROW = 2
  end
  ITEM_PATH_LIST = {ItemId::ARROW.to_s.to_sym => 'arrow', ItemId::BUTTON.to_s.to_sym => 'button'}

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
  class ActionEventHandleType
    # @property [Int] SCROLL スクロール
    SCROLL = 0
    # @property [Int] CLICK クリック
    CLICK = 1
  end

  # アクションイベントクラス名
  class ActionEventTypeClassName
    # @property [Int] BLANK ブランク
    BLANK = 'blank'
    # @property [Int] SCROLL スクロール
    SCROLL = 'scroll'
    # @property [Int] CLICK クリック
    CLICK = 'click'
  end

  # 共通アクションイベント対象
  class CommonActionEventChangeType
    # @property [Int] BACKGROUND 背景
    BACKGROUND = 1
    # @property [Int] SCREEN 画面表示
    SCREEN = 2
  end

  # アクション変更種別
  class ActionAnimationType
    # @property [Int] JQUERY_ANIMATION JQeury描画
    JQUERY_ANIMATION = 0
    # @property [Int] CSS3_ANIMATION CSS3アニメーション
    CSS3_ANIMATION = 1
  end

  # キーコード
  class KeyboardKeyCode
    # @property [Int] z zボタン
    Z = 90
  end

  class ElementAttribute
    MAIN_TEMP_ID = 'main_temp'
    NAVBAR_ROOT = 'nav'
    COMMON_ACTION_CLASS = "#{Const::EVENT_COMMON_PREFIX}@commoneventid"
    ITEM_ACTION_CLASS = 'item_event_action_@itemid'
    COMMON_VALUES_CLASS = 'common_event_value_@commoneventid_@methodname'
    ITEM_VALUES_CLASS = 'item_event_value_@itemid_@methodname'
    FILE_LOAD_CLASS = 'file_load'
    RUN_CSS = 'run_css_@pagenum'
  end

  class PageValueKey
    # @property [String] U_ROOT ユーザ情報ルート
    G_ROOT = 'general_page_values'
    # @property [String] G_ROOT 汎用情報プレフィックス
    G_PREFIX = 'generals'
    # @property [String] IS_ROOT ページ値ルート
    IS_ROOT = 'instance_page_values'
    # @property [String] INSTANCE_PREFIX インスタンスプレフィックス
    INSTANCE_PREFIX = 'instance'
    # @property [String] INSTANCE_VALUE_ROOT インスタンスROOT
    INSTANCE_VALUE_ROOT = 'value'
    # @property [String] ST_ROOT 共通設定値ルート
    ST_ROOT = 'setting_page_values'
    # @property [String] ST_PREFIX 共通設定プレフィックス
    ST_PREFIX = 'settings'
    # @property [String] E_ROOT イベント値ルート
    E_ROOT = 'event_page_values'
    # @property [String] E_PREFIX イベントプレフィックス
    E_PREFIX = 'events'
    # @property [String] E_NUM_PREFIX イベント番号プレフィックス
    E_NUM_PREFIX = 'te_'
    # @property [String] PAGE_PREFIX ページ番号プレフィックス
    P_PREFIX = 'p_'
    # @property [String] PAGE_VALUES_SEPERATOR ページ値のセパレータ
    PAGE_VALUES_SEPERATOR = ':'
    # @property [String] IS_RUNWINDOW_RELOAD Runビューをリロードしたか
    IS_RUNWINDOW_RELOAD = 'is_runwindow_reload'
    # @property [String] PAGE_COUNT ページ総数
    PAGE_COUNT = 'page_count'
    # @property [String] PAGE_NUM 現在のページ番号
    PAGE_NUM = 'page_num'
  end

  class Setting
    ROOT_ID_NAME = 'setting-config'
    GRID_CLASS_NAME = 'grid'
    GRID_STEP_CLASS_NAME = 'grid_step'
    GRID_STEP_DIV_CLASS_NAME = 'grid_div_step'
  end

  class ServerStorage
    class Key
      USER_ID = 'user_id'
      INSTANCE_PAGE_VALUE = 'i'
      EVENT_PAGE_VALUE = 'e'
      SETTING_PAGE_VALUE = 's'
    end
  end

  class EventPageValueKey
    ID = 'id'
    ITEM_ID = 'item_id'
    COMMON_EVENT_ID = 'common_event_id'
    VALUE = 'value'
    CHAPTER = 'chapter'
    SCREEN = 'screen'
    IS_COMMON_EVENT = 'is_common_event'
    ORDER = 'order'
    METHODNAME = 'methodname'
    ACTIONTYPE = 'actiontype'
    ANIAMTIONTYPE = 'animationtype'
    IS_PARALLEL = 'is_parallel'
    SCROLL_POINT_START = 'scroll_point_start'
    SCROLL_POINT_END = 'scroll_point_end'
  end

  class UserPageValue
    # @property [Integer] GET_LIMIT 取得件数(Loadメニューに表示)
    GET_LIMIT = 10
  end

  class ModalViewType
    ABOUT = 'about'
  end

  class Paging
    ROOT_ID = 'pages'
    MAIN_PAGING_SECTION_CLASS = 'pagesection-@pagenum'
    NAV_ROOT_ID = 'header-pageing-menu'
    NAV_SELECTED_CLASS = 'header-pageing-menu-selected'
    NAV_SELECT_ROOT_CLASS = 'header-pageing-menu-root'
  end
end