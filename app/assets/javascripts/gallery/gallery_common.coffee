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
  @initGridView: ->
    window.gridWrapper.masonry({
      itemSelector: '.grid_contents_wrapper'
      columnWidth: 180
      isAnimated: true
      animationOptions: {
        duration: 400
      }
      isFitWidth: true
    })

  # リサイズ初期化
  @initResize: ->
    $(window).resize( ->
      GalleryCommon.resizeMainContainerEvent()
    )

  # 画面サイズ設定
  @resizeMainContainerEvent = ->

