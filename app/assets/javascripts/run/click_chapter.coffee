# クリックチャプター
class ClickChapter extends Chapter

  # コンストラクタ
  # @param [Array] list イベント情報
  constructor: (list) ->
    super(list)
    @changeForkNum = null

  # チャプターの前処理
  willChapter: (callback = null) ->
    super( =>
      @disableScrollHandleViewEvent()
      # イベント設定
      @eventObjList.forEach((event) =>
        event.clickTargetElement().off('click').on('click', (e) =>
          @clickEvent(e)
        )
      )
      @showGuide()
      if callback?
        callback()
    )

  # チャプターの後処理
  didChapter: (callback = null) ->
    super( =>
      @enableScrollHandleViewEvent()
      @hideGuide()
      if callback?
        callback()
    )

  # クリックイベント
  # @param [Object] e クリックオブジェクト
  clickEvent: (e) ->
    @hideGuide()
    if window.disabledEventHandler
      return
    @eventObjList.forEach((event) =>
      if event.clickTargetElement().get(0) == $(e.currentTarget).get(0)
        event.clickEvent(e, =>
          # クリックしたイベントのフォーク番号を保存
          @changeForkNum = event.getChangeForkNum()
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

    idleTime = ClickGuide.IDLE_TIMER
    if window.isItemPreview? && window.isItemPreview
      # アイテムプレビュー時は即表示
      idleTime = 0

    @constructor.guideTimer = setTimeout( =>
      # ガイド表示
      items = []
      @eventObjList.forEach((event) ->
        if event instanceof ItemBase
          items.push(event)
      )
      ClickGuide.showGuide(items)
    , idleTime)

  # ガイド非表示
  hideGuide: ->
    if @constructor.guideTimer?
      clearTimeout(@constructor.guideTimer)
      @constructor.guideTimer = null
    ScrollGuide.hideGuide()
    ClickGuide.hideGuide()