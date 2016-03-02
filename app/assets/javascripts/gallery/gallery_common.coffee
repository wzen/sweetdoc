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

  @showWithFullScreen = ->
    e = event
    e.preventDefault()
    e.stopPropagation()
    root = $(e.target)
    # 実行確認ページを新規ウィンドウで表示
    size = {
      width: root.find(".#{constant.Gallery.Key.SCREEN_SIZE_WIDTH}").val()
      height: root.find(".#{constant.Gallery.Key.SCREEN_SIZE_HEIGHT}").val()
    }
    left = Number((window.screen.width - size.width)/2)
    top = Number((window.screen.height - (size.height))/2)
    target = "_runwindow"
    window.open("about:blank", target, "top=#{top},left=#{left},width=#{size.width},height=#{size.height},menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no")
    document.send_form.action = '/gallery/detail/w/' + root.find(".#{constant.Gallery.Key.GALLERY_ACCESS_TOKEN}").val()
    document.send_form.target = target
    setTimeout( ->
      document.send_form.submit()
    , 200)

