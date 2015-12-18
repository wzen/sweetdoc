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
    $('#grid_wrapper').find('.grid_contents_wrapper:hidden').show()


