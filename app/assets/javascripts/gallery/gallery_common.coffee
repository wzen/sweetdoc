class GalleryCommon

  # ビュー初期化
  @initView: ->
    # 変数初期化
    @initCommonVar()
    # リサイズ
    @initResize()
    # グリッドビュー
    @initGridView()

  @initCommonVar: ->
    window.mainWrapper = $('#main_wrapper')
    window.contentsWrapper = $('#contents_wrapper')
    window.gridWrapper = $('#grid_wrapper')

  # グリッド初期化
  @initGridView: ->
    window.gridWrapper.masonry({
      itemSelector: '.grid_contents_wrapper'
      columnWidth: 380
      isFitWidth: true
    })

  # リサイズ初期化
  @initResize: ->
    $(window).resize( ->
      GalleryCommon.resizeMainContainerEvent()
    )

  # 画面サイズ設定
  @resizeMainContainerEvent = ->



