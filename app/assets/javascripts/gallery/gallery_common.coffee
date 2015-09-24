class GalleryCommon

  # ビュー初期化
  @initView: ->
    # リサイズ
    @initResize()
    # グリッドビュー
    @initGridView()

  # グリッド初期化
  @initGridView: ->

    mas = new Masonry('#grid_wrapper', {
      itemSelector: '.grid_contents_wrapper'
      columnWidth: 380
      isFitWidth: true
    })
    mas.layout()

  # グリッドビューサイズ設定
  @updateGridViewSize: ->
    contentsWrapper = $('#contents_wrapper')
    sidebarCollapseWidth = 50
    $('#grid_wrapper').width(contentsWrapper.width() - sidebarCollapseWidth)

  # リサイズ初期化
  @initResize: ->
    $(window).resize( ->
      GalleryCommon.resizeMainContainerEvent()
    )

  # 画面サイズ設定
  @resizeMainContainerEvent = ->
    @updateGridViewSize()


