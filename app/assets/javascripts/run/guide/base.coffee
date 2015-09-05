class GuideBase
  @GUIDE_ZINDEX = 199999999
  @timer = null
  @IDLE_TIMER = 1000 # 1秒

  # ガイド表示
  # @abstract
  @showGuide: ->

  # ガイド非表示
  # @abstract
  @hideGuide: ->
