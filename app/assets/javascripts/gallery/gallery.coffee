class GalleryGrid
  @initEvent = ->
    @initContentsHover()

  @initContentsHover = ->
    $('.grid_contents_wrapper').off('mouseenter')
    $('.grid_contents_wrapper').on('mouseenter', (e) ->
      e.preventDefault()
      $(@).find('.hover_overlay').stop(true, true).fadeIn('100')
    )
    $('.grid_contents_wrapper').off('mouseleave')
    $('.grid_contents_wrapper').on('mouseleave', (e) ->
      e.preventDefault()
      $(@).find('.hover_overlay').stop(true, true).fadeOut('300')
    )

    $('.new_window').off('click')
    $('.new_window').on('click', (e) ->
      e.preventDefault()
      e.stopPropagation()
      root = $(@).closest('.grid_contents_wrapper')
      # 実行確認ページを新規ウィンドウで表示
      size = {
        width: root.find(".#{Constant.Gallery.Key.SCREEN_SIZE_WIDTH}").val()
        height: root.find(".#{Constant.Gallery.Key.SCREEN_SIZE_HEIGHT}").val()
      }
      left = Number((window.screen.width - size.width)/2)
      top = Number((window.screen.height - (size.height))/2)
      target = "_runwindow"
      window.open("about:blank", target, "top=#{top},left=#{left},width=#{size.width},height=#{size.height},menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no")
      document.send_form.action = '/gallery/detail/w/' + root.find(".#{Constant.Gallery.Key.GALLERY_ACCESS_TOKEN}").val()
      document.send_form.target = target
      setTimeout( ->
        document.send_form.submit()
      , 200)
    )

$ ->
  # ビュー初期化
  GalleryCommon.initView()

  $('.gallery.index').ready ->
    console.log 'home#index'


  $('.gallery.grid').ready ->
    # グリッドビュー初期化
    GalleryCommon.initGridView()
    # イベント設定
    GalleryGrid.initEvent()

  $('.gallery.detail, .gallery.run_window').ready ->
    # 作成者情報を表示
    RunFullScreen.showCreatorInfo()
    RunCommon.start()


