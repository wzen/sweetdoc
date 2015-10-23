class Const

  # 操作モード
  class Mode
    # @property [Int] NOT_SELECT 未選択
    NOT_SELECT = -1
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
  class ItemDrawType
    # @property [Int] CANVAS CANVAS
    CANVAS = 0
    # @property [Int] CSS CSS
    CSS = 1
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
  class ActionType
    # @property [Int] SCROLL スクロール
    SCROLL = 0
    # @property [Int] CLICK クリック
    CLICK = 1
  end

  # タイムラインアクションクラス名
  class TimelineActionTypeClassName
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
    # @property [Int] ENTER エンターキー
    ENTER = 13
    # @property [Int] Z zボタン
    Z = 90
    # @property [Int] C cボタン
    C = 67
    # @property [Int] X xボタン
    X = 88
    # @property [Int] V vボタン
    V = 86
  end

  class ElementAttribute
    MAIN_TEMP_ID = 'main_temp'
    NAVBAR_ROOT = 'nav'
    SIDEBAR_TAB_ROOT = 'tab-config'
    RUN_CSS = 'run_css_@pagenum'
    FILE_LOAD_CLASS = 'file_load'
    LAST_UPDATE_TIME_CLASS = 'last_update_time'
  end

  class DesignConfig
    ROOT_CLASSNAME = 'dc'
  end

  class EventConfig
    # @property EVENT_COMMON_PREFIX 共通イベント クラス名プレフィックス
    EVENT_COMMON_PREFIX = 'c_'
    # @property [String] COMMON_ACTION_CLASS イベント共通アクションクラス名
    COMMON_ACTION_CLASS = "#{EVENT_COMMON_PREFIX}@commoneventid"
    # @property [String] ITEM_ACTION_CLASS イベントアイテムアクションクラス名
    ITEM_ACTION_CLASS = 'item_event_action_@itemid'
    # @property [String] COMMON_VALUES_CLASS 共通イベントクラス名
    COMMON_VALUES_CLASS = 'common_event_value_@commoneventid_@methodname'
    # @property [String] ITEM_VALUES_CLASS アイテムイベントクラス名
    ITEM_VALUES_CLASS = 'item_event_value_@itemid_@methodname'
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
    # @property [String] E_ROOT イベントルート
    E_ROOT = 'event_page_values'
    # @property [String] E_SUB_ROOT イベントサブルート
    E_SUB_ROOT = 'events'
    # @property [String] E_MASTER_ROOT イベントメインルート
    E_MASTER_ROOT = 'master'
    # @property [String] E_FORK_ROOT イベントフォークルート
    E_FORK_ROOT = 'forks'
    # @property [String] E_NUM_PREFIX イベント番号プレフィックス
    E_NUM_PREFIX = 'te_'
    # @property [String] PAGE_PREFIX ページ番号プレフィックス
    P_PREFIX = 'p_'
    # @property [String] EF_PREFIX イベントフォークプレフィックス
    EF_PREFIX = 'ef_'
    # @property [String] PAGE_VALUES_SEPERATOR ページ値のセパレータ
    PAGE_VALUES_SEPERATOR = ':'
    # @property [String] IS_RUNWINDOW_RELOAD Runビューをリロードしたか
    IS_RUNWINDOW_RELOAD = 'is_runwindow_reload'
    # @property [String] PAGE_COUNT ページ総数
    PAGE_COUNT = 'page_count'
    # @property [String] PAGE_NUM 現在のページ番号
    PAGE_NUM = 'page_num'
    # @property [String] FORK_COUNT フォーク総数
    FORK_COUNT = 'fork_count'
    # @property [String] FORK_NUM 現在のフォーク番号
    FORK_NUM = 'fork_num'
    # @property [String] EF_MASTER_FORKNUM Masterのフォーク番号
    EF_MASTER_FORKNUM = 0
  end

  class StateConfig
    ROOT_ID_NAME = 'state-config'
    ITEM_TEMP_CLASS_NAME = 'item_temp'
  end

  class Setting
    ROOT_ID_NAME = 'setting-config'
    GRID_CLASS_NAME = 'grid'
    GRID_STEP_CLASS_NAME = 'grid_step'
    GRID_STEP_DIV_CLASS_NAME = 'grid_div_step'
    AUTOSAVE_CLASS_NAME = 'autosave'
    AUTOSAVE_TIME_CLASS_NAME = 'autosave_time'
    AUTOSAVE_TIME_DIV_CLASS_NAME = 'autosave_time_div'
    class Key
      GRID_ENABLE = 'grid_enable'
      GRID_STEP = 'grid_step'
      AUTOSAVE = 'autosave'
      AUTOSAVE_TIME = 'autosave_time'
    end
  end

  class ServerStorage
    # FIXME:
    DIVIDE_INTERVAL_MINUTES = 15

    class Key
      PROJECT_ID = 'project_id'
      PAGE_COUNT = 'page_count'
      GENERAL_COMMON_PAGE_VALUE = 'cg'
      GENERAL_PAGE_VALUE = 'g'
      INSTANCE_PAGE_VALUE = 'i'
      EVENT_PAGE_VALUE = 'e'
      SETTING_PAGE_VALUE = 's'
      NEW_RECORD = 'nr'
    end
  end

  class Project
    # FIXME:
    USER_CREATE_MAX = 50

    class Key
      PROJECT_ID = 'project_id'
      TITLE = 'title'
      SCREEN_SIZE = 'screen_size'
      USER_PAGEVALUE_ID = 'user_pagevalue_id'
      USER_PAGEVALUE_UPDATED_AT = 'user_pagevalue_updated_at'
    end
  end

  class Gallery
    TAG_MAX = 5

    class Key
      MESSAGE = 'message'
      GALLERY_ID = 'gid'
      GALLERY_ACCESS_TOKEN = 'g_at'
      PROJECT_ID = 'pid'
      SCREEN_SIZE_WIDTH = 'scrren_size_w'
      SCREEN_SIZE_HEIGHT = 'scrren_size_h'
      TAGS = 'tags'
      INSTANCE_PAGE_VALUE = 'i'
      EVENT_PAGE_VALUE = 'e'
      THUMBNAIL_IMG = 'tbimg'
      THUMBNAIL_IMG_CONTENTSTYPE = 'tbimgcnt'
      THUMBNAIL_IMG_WIDTH = 'tbimg_w'
      THUMBNAIL_IMG_HEIGHT = 'tbimg_h'
      PAGE_MAX = 'pagemax'
      TITLE = 'title'
      CAPTION = 'caption'
      ITEM_JS_LIST = 'item_js_list'
      VIEW_COUNT = 'view_count'
      BOOKMARK_COUNT = 'bookmark_count'
      RECOMMEND_SOURCE_WORD = 'recommend_source_word'
      NOTE = 'note'
      SHOW_GUIDE = 'show_guide'
      SHOW_PAGE_NUM = 'show_page_num'
      SHOW_CHAPTER_NUM = 'show_chapter_num'
      PAGE_NUM = 'p_n'
      SEARCH_TYPE = 'search_type'
    end

    class SearchKey
      SHOW_HEAD = 'show_head'
      SHOW_LIMIT = 'show_limit'
      SEARCH_TYPE = 'search_type'
      TAG_ID = 'tag_id'
      DATE = 'date'
    end

    class SearchType
      VIEW_COUNT = 'view_count'
      BOOKMARK_COUNT = 'bookmark_count'
      USER_BOOKMARK = 'user_bookmark'
      CREATED = 'created'
    end

    class Sidebar
      USER = 'user'
      WORKTABLE = 'worktable'
      VIEW = 'view'
      SEARCH = 'search'
      LOGO = 'logo'
    end
  end

  class EventPageValueKey
    ID = 'id'
    ITEM_ID = 'item_id'
    COMMON_EVENT_ID = 'common_event_id'
    VALUE = 'value'
    IS_COMMON_EVENT = 'is_common_event'
    ORDER = 'order'
    METHODNAME = 'methodname'
    ACTIONTYPE = 'actiontype'
    ANIAMTIONTYPE = 'animationtype'
    IS_SYNC = 'is_sync'
    SCROLL_POINT_START = 'scroll_point_start'
    SCROLL_POINT_END = 'scroll_point_end'
    SCROLL_ENABLED_DIRECTIONS = 'scroll_enabled_directions'
    SCROLL_FORWARD_DIRECTIONS = 'scroll_forward_directions'
    CHANGE_FORKNUM = 'change_forknum'
  end

  class UserPageValue
    # @property [Integer] GET_LIMIT 取得件数(Loadメニューに表示)
    GET_LIMIT = 10
  end

  class ModalViewType
    INIT_PROJECT = 'init_project'
    ADMIN_PROJECTS = 'admin_projects'
    ABOUT = 'about'
    UPLOAD_GALLERY_CONFIRM = 'upload_gallery_confirm'
  end

  class Paging
    ROOT_ID = 'pages'
    MAIN_PAGING_SECTION_CLASS = 'pagesection-@pagenum'
    NAV_ROOT_ID = 'header-pageing-menu'
    NAV_SELECTED_CLASS = 'header-pageing-menu-selected'
    NAV_SELECT_ROOT_CLASS = 'header-pageing-menu-root'
  end

  class RunGuide
    TOP_ROOT_ID = 'guide_top'
    BOTTOM_ROOT_ID = 'guide_bottom'
    LEFT_ROOT_ID = 'guide_left'
    RIGHT_ROOT_ID = 'guide_right'
  end

  class ItemActionPropertiesKey
    METHODS = 'methods'
    DEFAULT_METHOD = 'defaultMethod'
    ACTION_TYPE = 'actionType'
    ANIMATION_TYPE = 'actionAnimationType'
    SCROLL_ENABLED_DIRECTION = 'scrollEnabledDirection'
    SCROLL_FORWARD_DIRECTION = 'scrollForwardDirection'
    OPTIONS = 'options'
  end

  class Run
    class AttributeName
      CONTENTS_CREATOR_CLASSNAME = 'con_creator_cn'
      CONTENTS_TITLE_CLASSNAME = 'con_title_cn'
      CONTENTS_CAPTION_CLASSNAME = 'con_caption_cn'
      CONTENTS_PAGE_NUM_CLASSNAME = 'con_page_num_cn'
      CONTENTS_PAGE_MAX_CLASSNAME = 'con_page_max_cn'
      CONTENTS_CHAPTER_NUM_CLASSNAME = 'con_chapter_num_cn'
      CONTENTS_CHAPTER_MAX_CLASSNAME = 'con_chapter_max_cn'
      CONTENTS_FORK_NUM_CLASSNAME = 'con_fork_num_cn'
      CONTENTS_TAGS_CLASSNAME = 'con_tag_cn'
    end

    class Key
      TARGET_PAGES = 'targetpages'
      LOADED_ITEM_IDS = 'lii'
      PROJECT_ID = 'pid'
      ACCESS_TOKEN = 'at'
    end
  end
end