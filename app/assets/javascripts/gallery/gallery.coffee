class Gallery

  if gon?
    # 定数
    constant = gon.const
    class @Key
      @TAGS = constant.Gallery.Key.TAGS
      @INSTANCE_PAGE_VALUE = constant.Gallery.Key.INSTANCE_PAGE_VALUE
      @EVENT_PAGE_VALUE = constant.Gallery.Key.EVENT_PAGE_VALUE
      @THUMBNAIL_URL = constant.Gallery.Key.THUMBNAIL_URL
      @TITLE = constant.Gallery.Key.TITLE
      @CAPTION = constant.Gallery.Key.CAPTION

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

