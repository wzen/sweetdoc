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
    SELECT_FILE = 'selectFile'
    # @property [Int] SELECT_IMAGE_FILE 画像ファイル選択
    SELECT_IMAGE_FILE = 'selectImageFile'
    # @property [Int] CSS_DESIGN_TOOL CSSデザインツール
    DESIGN_TOOL = 'designTool'
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
    MAIN_TEMP_ID = 'mainTemp'
    MAIN_TEMP_WORKTABLE_CLASS = 'mainTempWs'
    MAIN_TEMP_RUN_CLASS = 'mainTempRun'
    NAVBAR_ROOT = 'nav'
    SIDEBAR_TAB_ROOT = 'tabConfig'
    RUN_CSS = 'runCss-@pagenum'
    FILE_LOAD_CLASS = 'fileLoad'
    LAST_UPDATE_TIME_CLASS = 'lastUpdateTime'
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
    ITEM_ACTION_CLASS = 'itemEventAction-@classdisttoken'
    # @property [String] ITEM_VALUES_CLASS アイテムイベントクラス名
    ITEM_VALUES_CLASS = 'itemEventValue-@classdisttoken-@methodname'
  end

  class PageValueKey
    # @property [String] U_ROOT ユーザ情報ルート
    G_ROOT = 'generalPageValues'
    # @property [String] G_ROOT 汎用情報プレフィックス
    G_PREFIX = 'generals'
    # @property [String] IS_ROOT ページ値ルート
    IS_ROOT = 'instancePageValues'
    # @property [String] INSTANCE_PREFIX インスタンスプレフィックス
    INSTANCE_PREFIX = 'instance'
    # @property [String] INSTANCE_VALUE_ROOT インスタンスROOT
    INSTANCE_VALUE_ROOT = 'value'
    # @property [String] ST_ROOT 共通設定値ルート
    ST_ROOT = 'settingPageValues'
    # @property [String] ST_PREFIX 共通設定プレフィックス
    ST_PREFIX = 'settings'
    # @property [String] E_ROOT イベントルート
    E_ROOT = 'eventPageValues'
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
    IS_RUNWINDOW_RELOAD = 'isRunwindowReload'
    # @property [String] PAGE_COUNT ページ総数
    PAGE_COUNT = 'pageCount'
    # @property [String] PAGE_NUM 現在のページ番号
    PAGE_NUM = 'pageNum'
    # @property [String] FORK_COUNT フォーク総数
    FORK_COUNT = 'forkCount'
    # @property [String] FORK_NUM 現在のフォーク番号
    FORK_NUM = 'forkNum'
    # @property [String] EF_MASTER_FORKNUM Masterのフォーク番号
    EF_MASTER_FORKNUM = 0
    # @property [String] H_ROOT 履歴情報ルート
    F_ROOT = 'footprintPageValues'
    # @property [String] H_ROOT 履歴情報ルート
    F_PREFIX = 'footprints'
    # @property [String] F_PREFIX 履歴情報イベント一意IDプレフィックス
    FED_PREFIX = 'eventDists'
    # @property [String] WORKTABLE_ITEM_HIDE_BY_SETTING Worktable設定によるアイテム非表示
    WORKTABLE_ITEM_HIDE_BY_SETTING = 'worktableItemHideBySetting'
  end

  class StateConfig
    ROOT_ID_NAME = 'stateConfig'
  end

  class ItemStateConfig
    ROOT_ID_NAME = 'itemStateConfig'
    ITEM_TEMP_CLASS_NAME = 'itemTemp'
  end

  class Setting
    ROOT_ID_NAME = 'setting-config'
    GRID_CLASS_NAME = 'grid'
    GRID_STEP_CLASS_NAME = 'gridStep'
    GRID_STEP_DIV_CLASS_NAME = 'gridDivStep'
    AUTOSAVE_CLASS_NAME = 'autosave'
    AUTOSAVE_TIME_CLASS_NAME = 'autosaveTime'
    AUTOSAVE_TIME_DIV_CLASS_NAME = 'autosaveTimeDiv'
    class Key
      GRID_ENABLE = 'gridEnable'
      GRID_STEP = 'gridStep'
      AUTOSAVE = 'autosave'
      AUTOSAVE_TIME = 'autosaveTime'
    end
  end

  class ServerStorage
    # FIXME:
    DIVIDE_INTERVAL_MINUTES = 15

    class Key
      PROJECT_ID = 'projectId'
      PAGE_COUNT = 'pageCount'
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
      PROJECT_ID = 'projectId'
      TITLE = 'title'
      IS_SAMPLE_PROJECT = 'isSampleProject'
      SCREEN_SIZE = 'screenSize'
      FIXED_SCREEN_SIZE = 'fixedScreenSize'
      USER_PAGEVALUE_ID = 'userPagevalueId'
      USER_PAGEVALUE_UPDATED_AT = 'userPagevalueUpdatedAt'
    end
  end

  class Gallery
    TAG_MAX = 5

    class Key
      MESSAGE = 'message'
      GALLERY_ID = 'gid'
      GALLERY_ACCESS_TOKEN = 'gAt'
      PROJECT_ID = 'pid'
      SCREEN_SIZE = 'screenSize'
      SCREEN_SIZE_WIDTH = 'scrrenSizeW'
      SCREEN_SIZE_HEIGHT = 'scrrenSizeH'
      TAGS = 'tags'
      INSTANCE_PAGE_VALUE = 'i'
      EVENT_PAGE_VALUE = 'e'
      THUMBNAIL_IMG = 'tbimg'
      THUMBNAIL_URL = 'tburl'
      THUMBNAIL_IMG_WIDTH = 'tbimgW'
      THUMBNAIL_IMG_HEIGHT = 'tbimgH'
      THUMBNAIL = 'thumbnail'
      PAGE_MAX = 'pagemax'
      TITLE = 'title'
      CAPTION = 'caption'
      MARKDOWN_CAPTION = 'markdownCaption'
      ITEM_JS_LIST = 'itemJsList'
      RECOMMEND_SOURCE_WORD = 'recommendSourceWord'
      NOTE = 'note'
      SHOW_GUIDE = 'showGuide'
      SHOW_PAGE_NUM = 'showPageNum'
      SHOW_CHAPTER_NUM = 'showChapterNum'
      PAGE_NUM = 'p_n'
      SEARCH_TYPE = 'searchType'
      USER_CODING_ID = 'userCodingId'
      USER_ID = 'userId'
      USER_NAME = 'userName'
      USER_THUMBNAIL_IMG = 'userThumbnailImg'
      BOOKMARK_COUNT = 'bookmarkCount'
      VIEW_COUNT = 'viewCount'
      TAG_ID = 'tagId'
      TAG_NAME = 'tagName'
      GENERAL_PAGEVALUE_DATA = 'generalPagevalueData'
      INSTANCE_PAGEVALUE_DATA = 'instancePagevalueData'
      EVENT_PAGEVALUE_DATA = 'eventPagevalueData'
      FOOTPRINT_PAGE_NUM = 'footprintPageNum'
      BOOKMARK_ID = 'bookmarkId'
      UPLOAD_OVERWRITE_GALLERY_TOKEN = 'uploadOverwriteGalleryToken'
      FILTER_TYPE = 'ft'
      FILTER_DATE = 'fd'
      FILTER_TAGS = 'ftg'
      OVERWRITE_CONTENTS_SELECT =  'overwriteContentsContentsSelect'
      WORD = 'word'
    end

    class SearchKey
      SHOW_HEAD = 'showHead'
      SHOW_LIMIT = 'showLimit'
      SEARCH_TYPE = 'searchType'
      TAG_ID = 'tagId'
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
      ITEM_GALLERY_ACCESS_TOKEN = 'igAt'
      TAGS = 'tags'
      TITLE = 'title'
      CAPTION = 'caption'
      SEARCH_TYPE = 'searchType'
      USER_CODING_ID = 'userCodingId'
      TAG_ID = 'tagId'
      TAG_NAME = 'tagName'
      ITEM_GALLERY_COUNT = 'itemGalleryCount'
      USER_ITEM_GALLERY_ID = 'userItemGalleryId'
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
    DIST_ID = 'distId'
    ID = 'id'
    CLASS_DIST_TOKEN = 'classDistToken'
    ITEM_SIZE_DIFF = 'itemSizeDiff'
    DO_FOCUS = 'doFocus'
    SHOW_WILL_CHAPTER = 'showWillChapter'
    SHOW_WILL_CHAPTER_DURATION = 'showWillChapterDuration'
    HIDE_DID_CHAPTER = 'hideWillChapter'
    HIDE_DID_CHAPTER_DURATION = 'hideWillChapterDuration'
    COMMON_EVENT_ID = 'commonEventId'
    VALUE = 'value'
    IS_COMMON_EVENT = 'isCommonEvent'
    ORDER = 'order'
    FINISH_PAGE = 'finishpage'
    JUMPPAGE_NUM = 'jumppage_num'
    METHODNAME = 'methodname'
    ACTIONTYPE = 'actiontype'
    IS_SYNC = 'is_sync'
    SCROLL_POINT_START = 'scrollPointStart'
    SCROLL_POINT_END = 'scrollPointEnd'
    SCROLL_ENABLED_DIRECTIONS = 'scrollEnabledDirections'
    SCROLL_FORWARD_DIRECTIONS = 'scrollForwardDirections'
    CHANGE_FORKNUM = 'changeForknum'
    MODIFIABLE_VARS = 'modifiable_vars'
    EVENT_DURATION = 'eventDuration'
    SPECIFIC_METHOD_VALUES = 'specificMethodValues'
  end

  class UserPageValue
    # @property [Integer] GET_LIMIT 取得件数(Loadメニューに表示)
    GET_LIMIT = 10
  end

  class ModalViewType
    INIT_PROJECT = 'initProject'
    ADMIN_PROJECTS = 'adminProjects'
    CREATE_USER_CODE = 'createUserCode'
    ITEM_IMAGE_UPLOAD = 'itemImageUpload'
    ITEM_TEXT_EDITING = 'itemTextEditing'
    NOTICE_LOGIN = 'noticeLogin'
    ABOUT = 'about'
    MESSAGE = 'message'
    FLASH_MESSAGE = 'flashMessage'
    ENVIRONMENT_NOT_SUPPORT = 'environmentNotSupport'
    CHANGE_SCREEN_SIZE = 'changeScreenSize'
  end

  class Paging
    ROOT_ID = 'pages'
    MAIN_PAGING_SECTION_CLASS = 'pagesection-@pagenum'
    NAV_ROOT_ID = 'headerPageingMenu'
    NAV_SELECTED_CLASS = 'headerPageingMenuSelected'
    NAV_SELECT_ROOT_CLASS = 'headerPageingMenuRoot'
  end

  class RunGuide
    TOP_ROOT_ID = 'guideTop'
    BOTTOM_ROOT_ID = 'guideBottom'
    LEFT_ROOT_ID = 'guideLeft'
    RIGHT_ROOT_ID = 'guideRight'
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
      CONTENTS_CREATOR_CLASSNAME = 'conCreatorCn'
      CONTENTS_TITLE_CLASSNAME = 'conTitleCn'
      CONTENTS_CAPTION_CLASSNAME = 'conCaptionCn'
      CONTENTS_PAGE_NUM_CLASSNAME = 'conPageNumCn'
      CONTENTS_PAGE_MAX_CLASSNAME = 'conPageMaxCn'
      CONTENTS_CHAPTER_NUM_CLASSNAME = 'conChapterNumCn'
      CONTENTS_CHAPTER_MAX_CLASSNAME = 'conChapterMaxCn'
      CONTENTS_FORK_NUM_CLASSNAME = 'conForkNumCn'
      CONTENTS_TAGS_CLASSNAME = 'conTagCn'
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
      LANG = 'langType'
      PUBLIC = 'public'
      CODE = 'code'
      CODES = 'codes'
      USER_CODING_ID = 'userCodingId'
      TREE_DATA = 'treeData'
      SUB_TREE = 'subTree'
      NODE_PATH = 'nodePath'
      DRAW_TYPE = 'drawType'
      IS_OPENED = 'isOpened'
      IS_ACTIVE = 'isActive'
      PARENT_NODE_PATH = 'parentNodePath'
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
    ROOT_ID = 'configMenuTemps'
    class Action
      PRELOAD_IMAGE_PATH_SELECT = 'preloadImagePathSelectConfig'
    end
    class Modifiable
      CHILDREN_WRAPPER_CLASS = 'modifiableChildrenWrapper-@parentvarname-@childrenkey'
    end
  end

  class PreloadItemImage
    class Key
      PROJECT_ID = 'pid'
      ITEM_OBJ_ID = 'iobjid'
      GALLERY_ID = 'glid'
      EVENT_DIST_ID = 'edistid'
      SELECT_FILE = 'sef'
      SELECT_FILE_DELETE = 'sefDel'
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