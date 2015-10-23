class GalleryGrid
  @initEvent = ->
    @initContentsHover()

  @initContentsHover = ->
#    $('.grid_contents_wrapper').off('mouseenter')
#    $('.grid_contents_wrapper').on('mouseenter', (e) ->
#      e.preventDefault()
#      $(@).find('.hover_overlay').stop(true, true).fadeIn('100')
#    )
#    $('.grid_contents_wrapper').off('mouseleave')
#    $('.grid_contents_wrapper').on('mouseleave', (e) ->
#      e.preventDefault()
#      $(@).find('.hover_overlay').stop(true, true).fadeOut('300')
#    )

    $('.grid_contents_link').off('click')
    $('.grid_contents_link').on('click', (e) ->
      e.preventDefault()
      window.location.href = '/gallery/' + $(@).find(".#{Constant.Gallery.Key.GALLERY_ACCESS_TOKEN}").val()
    )

    $('.new_window_link').off('click')
    $('.new_window_link').on('click', (e) ->
      e.preventDefault()
      # 実行確認ページを新規ウィンドウで表示
      size = {
        width: $(@).find('.#{Const.Gallery.Key.SCREEN_SIZE_WIDTH}').val()
        height: $(@).find('.#{Const.Gallery.Key.SCREEN_SIZE_HEIGHT}').val()
      }
      left = Number((window.screen.width - size.width)/2);
      top = Number((window.screen.height - (size.height))/2);
      target = "_runwindow"
      window.open("about:blank", target, "top=#{top},left=#{left},width=#{size.width},height=#{size.height},menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no")
      document.send_form.action = '/gallery/w/' + $(@).find(".#{Constant.Gallery.Key.GALLERY_ACCESS_TOKEN}").val()
      document.send_form.target = target
      setTimeout( ->
        document.send_form.submit()
      , 200)
    )

$ ->
  # ビュー初期化
  GalleryCommon.initView()
  # グリッドビュー初期化
  GalleryCommon.initGridView()
  # イベント設定
  GalleryGrid.initEvent()