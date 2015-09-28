class Gallery

  if gon?
    # 定数
    constant = gon.const

    @TAG_MAX = constant.Gallery.TAG_MAX

    class @Key
      @MESSAGE = constant.Gallery.Key.MESSAGE
      @GALLERY_ID = constant.Gallery.Key.GALLERY_ID
      @TAGS = constant.Gallery.Key.TAGS
      @INSTANCE_PAGE_VALUE = constant.Gallery.Key.INSTANCE_PAGE_VALUE
      @EVENT_PAGE_VALUE = constant.Gallery.Key.EVENT_PAGE_VALUE
      @THUMBNAIL_IMG = constant.Gallery.Key.THUMBNAIL_IMG
      @TITLE = constant.Gallery.Key.TITLE
      @CAPTION = constant.Gallery.Key.CAPTION
      @ITEM_JS_LIST = constant.Gallery.Key.ITEM_JS_LIST
      @VIEW_COUNT = constant.Gallery.Key.VIEW_COUNT
      @BOOKMARK_COUNT = constant.Gallery.Key.BOOKMARK_COUNT
      @RECOMMEND_SOURCE_WORD = constant.Gallery.Key.RECOMMEND_SOURCE_WORD

    class @SearchKey
      @SHOW_HEAD = constant.Gallery.SearchKey.SHOW_HEAD
      @SHOW_LIMIT = constant.Gallery.SearchKey.SHOW_LIMIT
      @SEARCH_TYPE = constant.Gallery.SearchKey.SEARCH_TYPE
      @TAG_ID = constant.Gallery.SearchKey.TAG_ID
      @DATE = constant.Gallery.SearchKey.DATE

    class @SearchType
      @VIEW_COUNT = constant.Gallery.SearchType.VIEW_COUNT
      @BOOKMARK_COUNT = constant.Gallery.SearchType.BOOKMARK_COUNT
      @CREATED = constant.Gallery.SearchType.CREATED

$ ->
  # ビュー初期化
  GalleryCommon.initView()

