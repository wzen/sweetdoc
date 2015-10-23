class GalleryGrid
  @initEvent = ->
    @initContentsHover()

  @initContentsHover = ->
    $('.grid_contents_wrapper').off('mouseenter')
    $('.grid_contents_wrapper').on('mouseenter', ->
      $(@).find('.hover_overlay').stop(true, true).fadeIn('100')
    )
    $('.grid_contents_wrapper').off('mouseleave')
    $('.grid_contents_wrapper').on('mouseleave', ->
      $(@).find('.hover_overlay').stop(true, true).fadeOut('300')
    )

$ ->
  # ビュー初期化
  GalleryCommon.initView()
  # イベント設定
  GalleryGrid.initEvent()