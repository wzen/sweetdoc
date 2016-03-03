# チャプターガイド基底
class GuideBase
  # ガイドのZindex
  @GUIDE_ZINDEX = 199999999
  # 表示用タイマー
  @timer = null
  # アイドル時間
  @IDLE_TIMER = 1500 # 1.5秒

  # ガイド表示
  # @abstract
  @showGuide: ->

  # ガイド非表示
  # @abstract
  @hideGuide: ->
