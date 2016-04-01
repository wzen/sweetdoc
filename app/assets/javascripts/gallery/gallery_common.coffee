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
    @setupMasonry(@windowWidthType())

  @setupMasonry: (windowWidthType) ->
    columnWidth = if windowWidthType == 0 then 100 else 180
    #console.log('columnWidth:' + columnWidth)
    $grid = $('#grid_wrapper')
    if $grid.data('masonry')?
      $grid.masonry('destroy')
    $grid.masonry({
      itemSelector: '.grid_contents_wrapper'
      columnWidth: columnWidth
      isAnimated: true
      animationOptions: {
        duration: 400
      }
      isFitWidth: true
    })
    # 描画後イベント
    $grid.one('layoutComplete', =>
      # 描画実行
      @showAllGrid()
    )
    # 描画実行
    $grid.masonry('layout')

  # リサイズ初期化
  @initResize: ->
    $(window).resize( =>
      GalleryCommon.resizeMainContainerEvent()
      wt = @windowWidthType()
      if window.nowWindowWidthType != wt
        @setupMasonry(wt)
        window.nowWindowWidthType = wt
    )
    window.nowWindowWidthType = @windowWidthType()

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
    $(".footer_button > button").click( =>
      if !window.contentsTakeCount? || !window.contentsTotalCount?
        $('#footer_button_wrapper').hide()
        Common.hideModalView(true)
        return false
      if !window.gridPage?
        window.gridPage = 1
      Common.showModalFlashMessage('Loading...')
      data = {}
      data['page'] = window.gridPage
      data[constant.Gallery.Key.FILTER] = @getFilterType()
      $.ajax(
        {
          url: "/gallery/grid_ajax"
          type: "GET"
          dataType: "html"
          data: data
          success: (data) ->
            if data?
              d = GalleryCommon.addGridContentsStyle($(data.trim()).filter('.grid_contents_wrapper'))
              if d? && d.length > 0
                $grid = $('#grid_wrapper')
                $grid.append(d).masonry('appended' ,d)
                window.contentsTakeCount += d.length
                if window.contentsTakeCount >= window.contentsTotalCount
                  $('#footer_button_wrapper').hide()
                window.gridPage += 1
              else
                $('#footer_button_wrapper').hide()
              Common.hideModalView(true)
            else
              console.log('/gallery/grid_ajax server error')
              Common.ajaxError(data)
              Common.hideModalView(true)
          error: (data)->
            console.log('/gallery/grid_ajax ajax error')
            Common.ajaxError(data)
            Common.hideModalView(true)
        }
      )
      return false
    )

  @getFilterType = ->
    locationPaths = window.location.href.split('/')
    l = locationPaths[locationPaths.length - 1].split('?')
    if l.length < 2
      # フィルタ無し
      return null
    else
      params = l[1].split('&')
      ret = null
      for param in params
        p = param.split('=')
        if p[0] == constant.Gallery.Key.FILTER
          ret = p[1]
          break
      return ret

  # 画面サイズ設定
  @resizeMainContainerEvent = ->

  @windowWidthType = ->
    w = $(window).width()
    # SCSSのmediaMaxWidth1と合わせる
    mediaMaxWidth1 = 699
    if w <= mediaMaxWidth1
      return 0
    else
      return 1

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
            console.log('/gallery/add_bookmark server error')
            Common.ajaxError(data)
            if callback?
              callback(false)
        error: (data)->
          console.log('/gallery/add_bookmark ajax error')
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
    className = ''
    style = null
    w = 180 - (3 * 2)
    h = 180 - 20 - (3 * 2)
    r = parseInt(Math.random() * 15)
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

