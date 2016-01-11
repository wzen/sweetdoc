if gon?

  constant = gon.const

  # アプリ共通定数
  class Constant

    @DEFAULT_BACKGROUNDCOLOR = constant.DEFAULT_BACKGROUNDCOLOR
    @ITEM_CODING_TEMP_CLASS_NAME = constant.ITEM_CODING_TEMP_CLASS_NAME
    @ITEM_GALLERY_ITEM_CLASSNAME = constant.ITEM_GALLERY_ITEM_CLASSNAME
    @ITEM_PREVIEW_CLASS_DIST_TOKEN = 'dummy'
    @CANVAS_ITEM_COORDINATE_VAR_SURFIX = 'Coord'

    # ZIndex
    class @Zindex
      # @property GRID グリッド線
      @GRID = 5
      # @property EVENTBOTTOM イベント最底面
      @EVENTBOTTOM = constant.Zindex.EVENTBOTTOM
      # @property EVENTFLOAT イベント最高面
      @EVENTFLOAT = constant.Zindex.EVENTFLOAT

    # 操作モード
    class @Mode
      # @property [Int] NOT_SELECT 未選択
      @NOT_SELECT = constant.Mode.NOT_SELECT
      # @property [Int] DRAW 描画
      @DRAW = constant.Mode.DRAW
      # @property [Int] EDIT 画面編集
      @EDIT = constant.Mode.EDIT
      # @property [Int] OPTION アイテムオプション
      @OPTION = constant.Mode.OPTION

    # イベントコンフィグ入力用操作モード
    class @EventInputPointingMode
      # @property [Int] NOT_SELECT 未選択
      @NOT_SELECT = constant.EventInputPointingMode.NOT_SELECT
      # @property [Int] DRAW 描画
      @DRAW = constant.EventInputPointingMode.DRAW
      # @property [Int] ITEM_TOUCH アイテム選択
      @ITEM_TOUCH = constant.EventInputPointingMode.ITEM_TOUCH

    # アイテム種別
    class @ItemDrawType
      # @property [Int] CANVAS CANVAS
      @CANVAS = constant.ItemDrawType.CANVAS
      # @property [Int] CSS CSS
      @CSS = constant.ItemDrawType.CSS

    # アクションイベント種別
    class @ActionType
      # @property [Int] SCROLL スクロール
      @SCROLL = constant.ActionType.SCROLL
      # @property [Int] CLICK クリック
      @CLICK = constant.ActionType.CLICK

    class @DesignConfig
      @DESIGN_ROOT_CLASSNAME = constant.DesignConfig.ROOT_CLASSNAME

    class @ItemDesignOptionType
      # @property [Int] BOOLEAN 真偽
      @BOOLEAN = constant.ItemDesignOptionType.BOOLEAN
      # @property [Int] INTEGER 数値
      @NUMBER = constant.ItemDesignOptionType.NUMBER
      # @property [Int] STRING 文字列
      @STRING = constant.ItemDesignOptionType.STRING
      # @property [Int] COLOR 色
      @COLOR = constant.ItemDesignOptionType.COLOR
      # @property [Int] SELECT 選択
      @SELECT = constant.ItemDesignOptionType.SELECT
      # @property [Int] CSS_DESIGN_TOOL CSSデザインツール
      @DESIGN_TOOL = constant.ItemDesignOptionType.DESIGN_TOOL
      # @property [Int] SELECT_FILE ファイル選択
      @SELECT_FILE = constant.ItemDesignOptionType.SELECT_FILE

    # アクションイベントクラス名
    class @TimelineActionTypeClassName
      # @property [Int] BLANK ブランク
      @BLANK = constant.TimelineActionTypeClassName.BLANK
      # @property [Int] SCROLL スクロール
      @SCROLL = constant.TimelineActionTypeClassName.SCROLL
      # @property [Int] CLICK クリック
      @CLICK = constant.TimelineActionTypeClassName.CLICK

    # キーコード
    class @KeyboardKeyCode
      # @property [Int] ENTER エンターキー
      @ENTER = constant.KeyboardKeyCode.ENTER
      # @property [Int] Z zボタン
      @Z = constant.KeyboardKeyCode.Z
      # @property [Int] C cボタン
      @C = constant.KeyboardKeyCode.C
      # @property [Int] X xボタン
      @X = constant.KeyboardKeyCode.X
      # @property [Int] V vボタン
      @V = constant.KeyboardKeyCode.V

    # 共通イベントタイプ
    class @CommonActionEventChangeType
      # @property [Int] BACKGROUND 背景
      @BACKGROUND = constant.CommonActionEventChangeType.BACKGROUND
      # @property [Int] SCREEN 画面表示
      @SCREEN = constant.CommonActionEventChangeType.SCREEN

    # モーダルビュー
    class @ModalView
      @HEIGHT_RATE = 0.7

    # モーダルビュータイプ
    class @ModalViewType
      # @property [Int] INIT 画面初期表示
      @INIT_PROJECT = constant.ModalViewType.INIT_PROJECT
      # @property [Int] ABOUT 概要
      @ABOUT = constant.ModalViewType.ABOUT
      @ADMIN_PROJECTS = constant.ModalViewType.ADMIN_PROJECTS
      @CREATE_USER_CODE = constant.ModalViewType.CREATE_USER_CODE
      @ITEM_IMAGE_UPLOAD = constant.ModalViewType.ITEM_IMAGE_UPLOAD
      @ITEM_TEXT_EDITING = constant.ModalViewType.ITEM_TEXT_EDITING
      @NOTICE_LOGIN = constant.ModalViewType.NOTICE_LOGIN

    # ページング
    class @Paging
      @ROOT_ID = constant.Paging.ROOT_ID
      @MAIN_PAGING_SECTION_CLASS = constant.Paging.MAIN_PAGING_SECTION_CLASS
      @NAV_ROOT_ID = constant.Paging.NAV_ROOT_ID
      @NAV_SELECTED_CLASS = constant.Paging.NAV_SELECTED_CLASS
      @NAV_SELECT_ROOT_CLASS = constant.Paging.NAV_SELECT_ROOT_CLASS
      @NAV_MENU_PAGE_NAME = 'Page @pagenum'
      @NAV_MENU_FORK_NAME = 'Fork @forknum'
      @NAV_MENU_PAGE_CLASS = 'paging-@pagenum'
      @NAV_MENU_FORK_CLASS = 'fork-@forknum'
      @NAV_MENU_ADDPAGE_CLASS = 'paging-new'
      @NAV_MENU_ADDFORK_CLASS = 'fork-new'
      @PRELOAD_PAGEVALUE_NUM = 0

    class @Project
      class @Key
        @PROJECT_ID = constant.Project.Key.PROJECT_ID
        @TITLE = constant.Project.Key.TITLE
        @SCREEN_SIZE = constant.Project.Key.SCREEN_SIZE
        @USER_PAGEVALUE_ID = constant.Project.Key.USER_PAGEVALUE_ID
        @USER_PAGEVALUE_UPDATED_AT = constant.Project.Key.USER_PAGEVALUE_UPDATED_AT

    class @Gallery
      @TAG_MAX = constant.Gallery.TAG_MAX

      class @Key
        @MESSAGE = constant.Gallery.Key.MESSAGE
        @GALLERY_ID = constant.Gallery.Key.GALLERY_ID
        @GALLERY_ACCESS_TOKEN = constant.Gallery.Key.GALLERY_ACCESS_TOKEN
        @PROJECT_ID = constant.Gallery.Key.PROJECT_ID
        @SCREEN_SIZE_WIDTH = constant.Gallery.Key.SCREEN_SIZE_WIDTH
        @SCREEN_SIZE_HEIGHT = constant.Gallery.Key.SCREEN_SIZE_HEIGHT
        @TAGS = constant.Gallery.Key.TAGS
        @INSTANCE_PAGE_VALUE = constant.Gallery.Key.INSTANCE_PAGE_VALUE
        @EVENT_PAGE_VALUE = constant.Gallery.Key.EVENT_PAGE_VALUE
        @THUMBNAIL_IMG = constant.Gallery.Key.THUMBNAIL_IMG
        @THUMBNAIL_IMG_CONTENTSTYPE = constant.Gallery.Key.THUMBNAIL_IMG_CONTENTSTYPE
        @THUMBNAIL_IMG_WIDTH = constant.Gallery.Key.THUMBNAIL_IMG_WIDTH
        @THUMBNAIL_IMG_HEIGHT = constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT
        @TITLE = constant.Gallery.Key.TITLE
        @CAPTION = constant.Gallery.Key.CAPTION
        @ITEM_JS_LIST = constant.Gallery.Key.ITEM_JS_LIST
        @VIEW_COUNT = constant.Gallery.Key.VIEW_COUNT
        @BOOKMARK_COUNT = constant.Gallery.Key.BOOKMARK_COUNT
        @RECOMMEND_SOURCE_WORD = constant.Gallery.Key.RECOMMEND_SOURCE_WORD
        @PAGE_MAX = constant.Gallery.Key.PAGE_MAX
        @SHOW_GUIDE = constant.Gallery.Key.SHOW_GUIDE
        @SHOW_PAGE_NUM = constant.Gallery.Key.SHOW_PAGE_NUM
        @SHOW_CHAPTER_NUM = constant.Gallery.Key.SHOW_CHAPTER_NUM
        @USER_CODING_ID = constant.Gallery.Key.USER_CODING_ID

      class @SearchKey
        @SHOW_HEAD = constant.Gallery.SearchKey.SHOW_HEAD
        @SHOW_LIMIT = constant.Gallery.SearchKey.SHOW_LIMIT
        @SEARCH_TYPE = constant.Gallery.SearchKey.SEARCH_TYPE
        @TAG_ID = constant.Gallery.SearchKey.TAG_ID
        @DATE = constant.Gallery.SearchKey.DATE

      class @SearchType
        @VIEW_COUNT = constant.Gallery.SearchType.VIEW_COUNT
        @BOOKMARK_COUNT = constant.Gallery.SearchType.BOOKMARK_COUNT
        @USER_BOOKMARK = constant.Gallery.SearchType.USER_BOOKMARK
        @CREATED = constant.Gallery.SearchType.CREATED

    class @ItemGallery
      @TAG_MAX = constant.ItemGallery.TAG_MAX

      class @Key
        @ITEM_GALLERY_ID = constant.ItemGallery.Key.GALLERY_ID
        @ITEM_GALLERY_ACCESS_TOKEN = constant.ItemGallery.Key.ITEM_GALLERY_ACCESS_TOKEN
        @TAGS = constant.ItemGallery.Key.TAGS
        @TITLE = constant.ItemGallery.Key.TITLE
        @CAPTION = constant.ItemGallery.Key.CAPTION
        @SEARCH_TYPE = constant.ItemGallery.Key.SEARCH_TYPE
        @USER_CODING_ID = constant.ItemGallery.Key.USER_CODING_ID
