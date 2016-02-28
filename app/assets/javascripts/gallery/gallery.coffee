class GalleryGrid

  @initEvent = ->
    @initContentsHover()

  @initContentsHover = ->
    $('.grid_contents_wrapper').off('mouseenter').on('mouseenter', (e) ->
      e.preventDefault()
      $(@).find('.hover_overlay').stop(true, true).fadeIn('100')
    )
    $('.grid_contents_wrapper').off('mouseleave').on('mouseleave', (e) ->
      e.preventDefault()
      $(@).find('.hover_overlay').stop(true, true).fadeOut('300')
    )

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
    if window.isMobileAccess
      $('body').css({width: window.screen.width + 'px', height: window.screen.height + 'px'})
    RunCommon.start()


  $('.gallery.embed').ready ->
    # 作成者情報を表示
    RunFullScreen.showCreatorInfo()
    RunCommon.start()


