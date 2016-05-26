class Const

  DEFAULT_BACKGROUNDCOLOR = '#FAFAFA'
  ITEM_CODING_TEMP_CLASS_NAME = 'ItemPreviewTemp'
  ITEM_GALLERY_ITEM_CLASSNAME = 'igtc'
  DEBUG_JS = ENV['RAILS_SERVE_DEBUG_JS'].present?
  BEFORE_MODIFY_VAR_SUFFIX = '__before'
  AFTER_MODIFY_VAR_SUFFIX = '__after'
  ADMIN_USER_ID = 1
  SAMPLE_PROJECT_USER_PROJECT_MAP_ID = 2147483647 # MySQL Int max
  GRID_CONTENTS_DISPLAY_MIN = 30
  THUMBNAIL_FILESIZE_MAX_KB = 500

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

  class EventInputPointingMode
    # @property [Int] NOT_SELECT 未選択
    NOT_SELECT = -1
    # @property [Int] DRAW 描画
    DRAW = 0
    # @property [Int] ITEM_TOUCH アイテム選択
    ITEM_TOUCH = 1
  end

  # ZIndex
  class Zindex
    # @porperty EVENTBOTTOM イベントz-idex最小値
    EVENTBOTTOM = 10
    # @porperty EVENTFLOAT イベントz-index最大値
    EVENTFLOAT = 999
  end

  # アイテム種別
  class ItemDrawType
    # @property [Int] CANVAS CANVAS
    CANVAS = 0
    # @property [Int] CSS CSS
    CSS = 1
  end

  # アイテムオプション種別
  class ItemDesignOptionType
    # @property [Int] BOOLEAN 真偽
    BOOLEAN = 'boolean'
    # @property [Int] NUMBER 数値
    NUMBER = 'number'
    # @property [Int] STRING 文字列
    STRING = 'string'
    # @property [Int] COLOR 色
    COLOR = 'color'
    # @property [Int] SELECT 選択
    SELECT = 'select'
    # @property [Int] SELECT_FILE ファイル選択
    SELECT_FILE = 'select_file'
    # @property [Int] SELECT_IMAGE_FILE 画像ファイル選択
    SELECT_IMAGE_FILE = 'select_image_file'
    # @property [Int] CSS_DESIGN_TOOL CSSデザインツール
    DESIGN_TOOL = 'design_tool'
  end

  # アイテムオプションテンプレート種別
  class ItemOptionTempType
    FONTFAMILY = 'fontFamily'
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
    # @property [Int] PLUS plusボタン
    PLUS = 186
    # @property [Int] SEMICOLON セミコロン
    SEMICOLON = 59
    # @property [Int] MINUS minusボタン
    MINUS = 189
    # @property [Int] F_MINUS minusボタン(Firefox)
    F_MINUS = 173
  end

  class ElementAttribute
    MAIN_TEMP_ID = 'main_temp'
    MAIN_TEMP_WORKTABLE_CLASS = 'main_temp_ws'
    MAIN_TEMP_RUN_CLASS = 'main_temp_run'
    NAVBAR_ROOT = 'nav'
    SIDEBAR_TAB_ROOT = 'tab-config'
    RUN_CSS = 'run_css_@pagenum'
    FILE_LOAD_CLASS = 'file_load'
    LAST_UPDATE_TIME_CLASS = 'last_update_time'
  end

  class ConfigType
    DESIGN = 1
    EVENT = 2
  end

  class DesignConfig
    ROOT_CLASSNAME = 'dc'
  end

  class EventConfig
    # @property EVENT_COMMON_PREFIX 共通イベント クラス名プレフィックス
    EVENT_COMMON_PREFIX = 'c_'
    # @property [String] ITEM_ACTION_CLASS イベントアイテムアクションクラス名
    ITEM_ACTION_CLASS = 'item_event_action_@classdisttoken'
    # @property [String] ITEM_VALUES_CLASS アイテムイベントクラス名
    ITEM_VALUES_CLASS = 'item_event_value_@classdisttoken_@methodname'
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
    # @property [String] H_ROOT 履歴情報ルート
    F_ROOT = 'footprint_page_values'
    # @property [String] H_ROOT 履歴情報ルート
    F_PREFIX = 'footprints'
    # @property [String] F_PREFIX 履歴情報イベント一意IDプレフィックス
    FED_PREFIX = 'event_dists'
    # @property [String] WORKTABLE_ITEM_HIDE_BY_SETTING Worktable設定によるアイテム非表示
    WORKTABLE_ITEM_HIDE_BY_SETTING = 'worktable_item_hide_by_setting'
  end

  class StateConfig
    ROOT_ID_NAME = 'state-config'
  end

  class ItemStateConfig
    ROOT_ID_NAME = 'item-state-config'
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
      IS_SAMPLE_PROJECT = 'is_sample_project'
      SCREEN_SIZE = 'screen_size'
      FIXED_SCREEN_SIZE = 'fixed_screen_size'
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
      SCREEN_SIZE = 'screen_size'
      SCREEN_SIZE_WIDTH = 'scrren_size_w'
      SCREEN_SIZE_HEIGHT = 'scrren_size_h'
      TAGS = 'tags'
      INSTANCE_PAGE_VALUE = 'i'
      EVENT_PAGE_VALUE = 'e'
      THUMBNAIL_IMG = 'tbimg'
      THUMBNAIL_URL = 'tburl'
      THUMBNAIL_IMG_WIDTH = 'tbimg_w'
      THUMBNAIL_IMG_HEIGHT = 'tbimg_h'
      THUMBNAIL_EXISTED = 'tbimg_existed'
      THUMBNAIL = 'thumbnail'
      PAGE_MAX = 'pagemax'
      TITLE = 'title'
      CAPTION = 'caption'
      MARKDOWN_CAPTION = 'markdown_caption'
      ITEM_JS_LIST = 'item_js_list'
      RECOMMEND_SOURCE_WORD = 'recommend_source_word'
      NOTE = 'note'
      SHOW_GUIDE = 'show_guide'
      SHOW_PAGE_NUM = 'show_page_num'
      SHOW_CHAPTER_NUM = 'show_chapter_num'
      PAGE_NUM = 'p_n'
      SEARCH_TYPE = 'search_type'
      USER_CODING_ID = 'user_coding_id'
      USER_ID = 'user_id'
      USER_NAME = 'user_name'
      USER_THUMBNAIL_IMG = 'user_thumbnail_img'
      BOOKMARK_COUNT = 'bookmark_count'
      VIEW_COUNT = 'view_count'
      TAG_ID = 'tag_id'
      TAG_NAME = 'tag_name'
      GENERAL_PAGEVALUE_DATA = 'general_pagevalue_data'
      INSTANCE_PAGEVALUE_DATA = 'instance_pagevalue_data'
      EVENT_PAGEVALUE_DATA = 'event_pagevalue_data'
      FOOTPRINT_PAGE_NUM = 'footprint_page_num'
      BOOKMARK_ID = 'bookmark_id'
      UPLOAD_OVERWRITE_GALLERY_TOKEN = 'upload_overwrite_gallery_token'
      FILTER_TYPE = 'ft'
      FILTER_DATE = 'fd'
      FILTER_TAGS = 'ftg'
      OVERWRITE_CONTENTS_SELECT =  'overwrite_contents_contents_select'
    end

    class SearchKey
      SHOW_HEAD = 'show_head'
      SHOW_LIMIT = 'show_limit'
      SEARCH_TYPE = 'search_type'
      TAG_ID = 'tag_id'
      DATE = 'date'
    end

    class SearchType
      ALL = 'all'
      VIEW_COUNT = 'vc'
      BOOKMARK_COUNT = 'bc'
      USER_BOOKMARK = 'ub'
      CREATED = 'cr'
      RECOMMEND = 'rc'
    end

    class Sidebar
      USER = 'user'
      WORKTABLE = 'worktable'
      VIEW = 'view'
      SEARCH = 'search'
      LOGO = 'logo'
    end
  end


  class ItemGallery
    TAG_MAX = 3
    POPULAR_TAG_MENU_SHOW_MAX = 15

    class Key
      MESSAGE = 'message'
      ITEM_GALLERY_ID = 'igid'
      ITEM_GALLERY_ACCESS_TOKEN = 'ig_at'
      TAGS = 'tags'
      TITLE = 'title'
      CAPTION = 'caption'
      SEARCH_TYPE = 'search_type'
      USER_CODING_ID = 'user_coding_id'
      TAG_ID = 'tag_id'
      TAG_NAME = 'tag_name'
      ITEM_GALLERY_COUNT = 'item_gallery_count'
      USER_ITEM_GALLERY_ID = 'user_item_gallery_id'
    end

    class PublicType
      PUBLIC = 1
      PRIVATE = 2
    end
  end

  class EventPageValue
    # @property [String] NO_METHOD メソッド無し名
    NO_METHOD = '__no_method'
    # @property [Integer] NO_JUMPPAGE ページ遷移先なし
    NO_JUMPPAGE = -1
  end

  class EventPageValueKey
    DIST_ID = 'dist_id'
    ID = 'id'
    CLASS_DIST_TOKEN = 'class_dist_token'
    ITEM_SIZE_DIFF = 'item_size_diff'
    DO_FOCUS = 'do_focus'
    SHOW_WILL_CHAPTER = 'show_will_chapter'
    SHOW_WILL_CHAPTER_DURATION = 'show_will_chapter_duration'
    HIDE_DID_CHAPTER = 'hide_will_chapter'
    HIDE_DID_CHAPTER_DURATION = 'hide_will_chapter_duration'
    COMMON_EVENT_ID = 'common_event_id'
    VALUE = 'value'
    IS_COMMON_EVENT = 'is_common_event'
    ORDER = 'order'
    FINISH_PAGE = 'finishpage'
    JUMPPAGE_NUM = 'jumppage_num'
    METHODNAME = 'methodname'
    ACTIONTYPE = 'actiontype'
    IS_SYNC = 'is_sync'
    SCROLL_POINT_START = 'scroll_point_start'
    SCROLL_POINT_END = 'scroll_point_end'
    SCROLL_ENABLED_DIRECTIONS = 'scroll_enabled_directions'
    SCROLL_FORWARD_DIRECTIONS = 'scroll_forward_directions'
    CHANGE_FORKNUM = 'change_forknum'
    MODIFIABLE_VARS = 'modifiable_vars'
    EVENT_DURATION = 'eventDuration'
    SPECIFIC_METHOD_VALUES = 'specificMethodValues'
  end

  class UserPageValue
    # @property [Integer] GET_LIMIT 取得件数(Loadメニューに表示)
    GET_LIMIT = 10
  end

  class ModalViewType
    INIT_PROJECT = 'init_project'
    ADMIN_PROJECTS = 'admin_projects'
    CREATE_USER_CODE = 'create_user_code'
    ITEM_IMAGE_UPLOAD = 'item_image_upload'
    ITEM_TEXT_EDITING = 'item_text_editing'
    NOTICE_LOGIN = 'notice_login'
    ABOUT = 'about'
    MESSAGE = 'message'
    FLASH_MESSAGE = 'flash_message'
    ENVIRONMENT_NOT_SUPPORT = 'environment_not_support'
    CHANGE_SCREEN_SIZE = 'change_screen_size'
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
    TYPE = 'type'
    METHODS = 'methods'
    TEMP = 'temp'
    DEFAULT_EVENT = 'defaultEvent'
    METHOD = 'method'
    DEFAULT_METHOD = 'defaultMethod'
    SPECIFIC_METHOD_VALUES = 'specificValues'
    ACTION_TYPE = 'actionType'
    COLOR_TYPE = 'colorType'
    SCROLL_ENABLED_DIRECTION = 'scrollEnabledDirection'
    SCROLL_FORWARD_DIRECTION = 'scrollForwardDirection'
    OPTIONS = 'options'
    EVENT_DURATION = 'eventDuration'
    MODIFIABLE_VARS = 'modifiables'
    MODIFIABLE_CHILDREN = 'children'
    MODIFIABLE_CHILDREN_OPENVALUE = 'openChildrenValue'
    FINISH_WITH_HAND = 'finishWithHand'
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
      LOADED_CLASS_DIST_TOKENS = 'liat'
      PROJECT_ID = 'pid'
      ACCESS_TOKEN = 'at'
      RUNNING_USER_PAGEVALUE_ID = 'urpi'
      FOOTPRINT_PAGE_VALUE = 'f'
      LOAD_FOOTPRINT = 'l_f'
    end
  end

  class Coding
    DEFAULT_FILENAME = 'untitled'
    class Key
      LANG = 'lang_type'
      PUBLIC = 'public'
      CODE = 'code'
      CODES = 'codes'
      USER_CODING_ID = 'user_coding_id'
      TREE_DATA = 'tree_data'
      SUB_TREE = 'sub_tree'
      NODE_PATH = 'node_path'
      DRAW_TYPE = 'draw_type'
      IS_OPENED = 'is_opened'
      IS_ACTIVE = 'is_active'
      PARENT_NODE_PATH = 'parent_node_path'
    end
    class Lang
      JAVASCRIPT = 'js'
      COFFEESCRIPT = 'coffee'
    end
    class CacheKey
      TREE_STATE_KEY = 'user_id:@user_id-treestatekey'
      CODE_STATE_KEY = 'user_id:@user_id-codestatekey'
    end
  end

  class User
    class Key
      USER_ACCESS_TOKEN = 'u'
      NAME = 'name'
      USER_COUNT = 'count'
      THUMBNAIL = 'thumbnail'
    end
  end

  class MyPage
    class Key
      HEAD = 'h'
      LIMIT = 'l'
    end
  end

  class ConfigMenu
    ROOT_ID = 'config_menu_temps'
    class Action
      PRELOAD_IMAGE_PATH_SELECT = 'preload_image_path_select_config'
    end
    class Modifiable
      CHILDREN_WRAPPER_CLASS = 'modifiable_children_wrapper_@parentvarname_@childrenkey'
    end
  end

  class PreloadItemImage
    class Key
      PROJECT_ID = 'pid'
      ITEM_OBJ_ID = 'iobjid'
      GALLERY_ID = 'glid'
      EVENT_DIST_ID = 'edistid'
      SELECT_FILE = 'sef'
      SELECT_FILE_DELETE = 'sef_del'
      URL = 'url'
    end
  end

  class PreloadItemText
    class BalloonType
      NONE = 0
      FREE = 999999
      ARC = 1
      RECT = 2
      BROKEN_ARC = 3
      BROKEN_RECT = 4
      FLASH = 5
      CLOUD = 6
    end
    class WriteDirectionType
      HORIZONTAL = 0
      VERTICAL = 1
    end
    class WordAlign
      LEFT = 1
      CENTER = 2
      RIGHT = 3
    end
    class ShowAnimationType
      POPUP = 1
      FADE = 2
    end
  end

end