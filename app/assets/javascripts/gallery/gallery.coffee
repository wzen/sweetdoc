class GalleryGrid

  @initEvent = ->
    GalleryCommon.initContentsHover()
    GalleryCommon.initLoadMoreButtonEvent()

$ ->
  window.isMotionCheck = false
  window.isItemPreview = false

  # ビュー初期化
  GalleryCommon.initView()

  $('.gallery.index').ready ->

  $('.gallery.grid').ready ->
    # グリッドビュー初期化
    GalleryCommon.initGridView()
    # イベント設定
    GalleryGrid.initEvent()

  $('.gallery.detail').ready ->
    # 作成者情報を表示
    RunCommon.showCreatorInfo()
    RunCommon.start()

  $('.gallery.full_window').ready ->
    # 作成者情報を表示
    RunFullScreen.showCreatorInfo()
    #if window.isMobileAccess
#      $('body').css({width: window.screen.width + 'px', height: window.screen.height + 'px'})
    RunCommon.start()

  $('.gallery.embed').ready ->
    $('.powered_thumbnail:first').off('click').on('click', (e) =>
      e.preventDefault()
      window.open( "/", "_newwindow" )
    )
    $('.play_in_embed:first').off('click').on('click', (e) =>
      e.preventDefault()
      accessToken = $("#main_wrapper .#{constant.Gallery.Key.GALLERY_ACCESS_TOKEN}:first").val()
      window.location.href = "/gallery/embed_with_run?#{constant.Gallery.Key.GALLERY_ACCESS_TOKEN}=#{accessToken}"
    )
    $('.play_in_site_link:first').off('click').on('click', (e) =>
      e.preventDefault()
      accessToken = $("#main_wrapper .#{constant.Gallery.Key.GALLERY_ACCESS_TOKEN}:first").val()
      window.open( "/gallery/detail/#{accessToken}", "_newwindow" )
    )

  $('.gallery.embed_with_run').ready ->
    # 作成者情報を表示
    RunFullScreen.showCreatorInfo()
    RunCommon.start()


