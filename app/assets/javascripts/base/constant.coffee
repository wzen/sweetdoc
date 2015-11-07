if gon?

  constant = gon.const

  # アプリ共通定数
  class Constant
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
