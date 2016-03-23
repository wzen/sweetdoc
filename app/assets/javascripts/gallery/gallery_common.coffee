class GalleryCommon

  # ビュー初期化
  @initView: ->
    # 変数初期化
    @initCommonVar()
    # リサイズ
    @initResize()

  @initCommonVar: ->
    window.mainGalleryWrapper = $('#main_gallery_wrapper')
    window.galleryContentsWrapper = $('#gallery_contents_wrapper')
    window.gridWrapper = $('#grid_wrapper')

  # グリッド初期化
  @initGridView: (callback = null) ->
    # Masonry初期化
    @addGridContentsStyle($('.grid_contents_wrapper'))
    grid = new Masonry('#grid_wrapper', {
      itemSelector: '.grid_contents_wrapper'
      columnWidth: 180
      isAnimated: true
      animationOptions: {
        duration: 400
      }
      isFitWidth: true
    })
    # 描画後イベント
    grid.on('layoutComplete', =>
      # 描画実行
      @showAllGrid()
    )
    # 描画実行
    grid.layout()

  # リサイズ初期化
  @initResize: ->
    $(window).resize( ->
      GalleryCommon.resizeMainContainerEvent()
    )

  # 画面サイズ設定
  @resizeMainContainerEvent = ->

  # グリッド表示
  @showAllGrid = ->
    $('#grid_wrapper').find('.grid_contents_wrapper').css('opacity', '')

  @showWithFullScreen = (e) ->
    e = e || window.event
    rootTarget = e.target || e.srcElement
    e.preventDefault()
    e.stopPropagation()
    root = $(rootTarget)
    target = "_runwindow"
    # 実行確認ページを新規ウィンドウで表示
    width = root.find(".#{constant.Gallery.Key.SCREEN_SIZE_WIDTH}").val()
    height = root.find(".#{constant.Gallery.Key.SCREEN_SIZE_HEIGHT}").val()
    if width? && height?
      # スクリーンサイズが指定されている場合
      size = {
        width: width
        height: height
      }
      left = Number((window.screen.width - size.width)/2)
      top = Number((window.screen.height - (size.height))/2)
      window.open("about:blank", target, "top=#{top},left=#{left},width=#{size.width},height=#{size.height},menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no")
    else
      window.open("about:blank", target, "menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no")
    document.send_form.action = '/gallery/detail/w/' + root.find(".#{constant.Gallery.Key.GALLERY_ACCESS_TOKEN}").val()
    document.send_form.target = target
    setTimeout( ->
      document.send_form.submit()
    , 200)

  @addBookmark = (note, callback = null) ->
    data = {}
    data[constant.Gallery.Key.GALLERY_ACCESS_TOKEN] = Common.getContentsAccessTokenFromUrl()
    data[constant.Gallery.Key.NOTE] = note
    $.ajax(
      {
        url: "/gallery/add_bookmark"
        type: "POST"
        dataType: "json"
        data: data
        success: (data)->
          if data.resultSuccess
            if callback?
              callback(true)
          else
            console.log('/project/remove server error')
            Common.ajaxError(data)
            if callback?
              callback(false)
        error: (data)->
          console.log('/project/remove ajax error')
          Common.ajaxError(data)
          if callback?
            callback(false)
      }
    )

  @removeBookmark = (callback = null) ->
    data = {}
    data[constant.Gallery.Key.GALLERY_ACCESS_TOKEN] = Common.getContentsAccessTokenFromUrl()
    $.ajax(
      {
        url: "/gallery/remove_bookmark"
        type: "POST"
        dataType: "json"
        data: data
        success: (data)->
          if data.resultSuccess
            if callback?
              callback(true)
          else
            console.log('/project/remove server error')
            Common.ajaxError(data)
            if callback?
              callback(false)
        error: (data)->
          console.log('/project/remove ajax error')
          Common.ajaxError(data)
          if callback?
            callback(false)
      }
    )

  @calcGridContentsSizeAndStyle = (imgWidth, imgHeight) ->
    r = parseInt(Math.random() * 15)
    className = ''
    style = null
    w = 180 - (3 * 2)
    h = 180 - 20 - (3 * 2)
    if r == 0
      className = 'grid-item-width2 grid-item-height2'
      w *= 2
      h *= 2
    else if r == 1 || r == 2
      className = 'grid-item-width2'
      w *= 2
    else if r == 3 || r == 4
      className = 'grid-item-height2'
      h *= 2

    if imgHeight / imgWidth > h / w
      style = 'width:100%;height:auto;'
    else
      style = 'width:auto;height:100%;'
    if imgWidth / imgHeight > 1.5 && className == 'grid-item-height2'
      ret = @calcGridContentsSizeAndStyle(imgWidth, imgHeight)
      className = ret.className
      style = ret.style
    else  if imgHeight / imgWidth > 1.5 && className == 'grid-item-width2'
      className = ret.className
      style = ret.style
    return {className: className, style: style}

  @addGridContentsStyle = (contents) ->
    contents.each((idx, content) =>
      if $(content).attr('class').split(' ').length <= 2
        w = $(content).find(".#{constant.Gallery.Key.THUMBNAIL_IMG_WIDTH}:first").val()
        h = $(content).find(".#{constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT}:first").val()
        calcStyle = @calcGridContentsSizeAndStyle(w, h)
        $(content).addClass(calcStyle.className)
        $(content).find('.thumbnail_img:first').attr('style', calcStyle.style)
    )

