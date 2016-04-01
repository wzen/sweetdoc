class GalleryGrid

  @initEvent = ->
    @initContentsHover()
    @initLoadMoreButtonEvent()

  @initContentsHover = ->
    $('.grid_contents_wrapper').off('mouseenter').on('mouseenter', (e) ->
      e.preventDefault()
      $(@).find('.hover_overlay').stop(true, true).fadeIn('100')
    )
    $('.grid_contents_wrapper').off('mouseleave').on('mouseleave', (e) ->
      e.preventDefault()
      $(@).find('.hover_overlay').stop(true, true).fadeOut('300')
    )

  @initLoadMoreButtonEvent = ->
    $(".footer_button > button").click( ->
      Common.showModalFlashMessage('Loading...')
      $.ajax(
        {
          url: "/gallery/grid_ajax"
          type: "GET"
          dataType: "html"
          success: (data)->
            if data?
              d = GalleryCommon.addGridContentsStyle($(data.trim()).filter('.grid_contents_wrapper'))
              $grid = $('#grid_wrapper')
              $grid.append(d).masonry('appended' ,d)
              Common.hideModalView(true)
            else
              console.log('/gallery/grid_ajax server error')
              Common.ajaxError(data)
          error: (data)->
            console.log('/gallery/grid_ajax ajax error')
            Common.ajaxError(data)
        }
      )
      return false
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


