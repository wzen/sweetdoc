# クリックチャプター
class ClickChapter extends Chapter

  # コンストラクタ
  # @param [Array] list イベント情報
  constructor: (list) ->
    super(list)
    @changeForkNum = null

  # チャプターの前処理
  willChapter: ->
    super()

    # イベント設定
    @eventObjList.forEach((event) =>
      event.getJQueryElement().off('click')
      event.getJQueryElement().on('click', (e) =>
        @clickEvent(e)
      )
    )
    @floatAllChapterEvents()
    @showGuide()

  # チャプターの後処理
  didChapter: ->
    super()
    @floatScrollHandleCanvas()
    @hideGuide()

  # クリックイベント
  # @param [Object] e クリックオブジェクト
  clickEvent: (e) ->
    self = @

    @hideGuide()
    if window.disabledEventHandler
      return

    @eventObjList.forEach((event) ->
      if event.id == $(e.currentTarget).attr('id')
        event.clickEvent(e, ->
          # クリックしたイベントのフォーク番号を保存
          self.changeForkNum = event.getChangeForkNum()
          if window.eventAction?
            # 次のチャプターへ
            window.eventAction.thisPage().nextChapter()
        )
    )

  # ガイド表示
  showGuide: ->
    if !super()
      return false
    @hideGuide()
    @constructor.guideTimer = setTimeout( =>
      # ガイド表示
      items = []
      @eventObjList.forEach((event) ->
        if event instanceof ItemBase
          items.push(event)
      )
      ClickGuide.showGuide(items)
    , ClickGuide.IDLE_TIMER)

  # ガイド非表示
  hideGuide: ->
    if @constructor.guideTimer?
      clearTimeout(@constructor.guideTimer)
      @constructor.guideTimer = null
    ClickGuide.hideGuide()