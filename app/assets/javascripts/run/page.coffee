class Page
  # コンストラクタ
  # @param [Object] eventPageValeuList イベントPageValue
  constructor: (eventPageValueArray) ->

    _setupChapterList = (eventPageValueList, chapterList) ->
      if eventPageValueList?
        eventList = []
        $.each(eventPageValueList, (idx, obj) =>
          eventList.push(obj)

          sync = false
          if idx < eventPageValueList.length - 1
            beforeEvent = eventPageValueList[idx + 1]
            if beforeEvent[EventPageValueBase.PageValueKey.IS_SYNC]
              sync = true

          if !sync
            chapter = null
            if obj[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionType.CLICK
              chapter = new ClickChapter({eventList: eventList, num: idx})
            else
              chapter = new ScrollChapter({eventList: eventList, num: idx})
            chapterList.push(chapter)
            eventList = []

          return true
        )

    @forkChapterList = {}
    @forkChapterIndex = {}
    for k,  forkEventPageValueList of eventPageValueArray.forks
      @forkChapterList[k] = []
      @forkChapterIndex[k] = 0
      _setupChapterList.call(@, forkEventPageValueList, @forkChapterList[k])

    @finishedAllChapters = false
    @finishedScrollDistSum = 0

  # フォーク内のチャプターリスト取得
  # @return [Array] チャプターリスト
  getForkChapterList: ->
    lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum())
    if lastForkNum?
      return @forkChapterList[lastForkNum]
    else
      return []

  # 進行するチャプターリスト取得
  # @return [Array] チャプターリスト
  getProgressChapterList: ->
    # フォークスタックを参照してページ内のチャプターリストを取得
    ret = []
    stack = RunCommon.getForkStack(window.eventAction.thisPageNum())
    for s, sIndex in stack
      for chapter, cIndex in @forkChapterList[s.forkNum]
        if stack[sIndex + 1]? && cIndex > stack[sIndex + 1].changedChapterIndex
          break
        ret.push(chapter)
    return ret

  # 全チャプターリスト取得
  # @return [Array] チャプターリスト
  getAllChapterList: ->
    # フォークスタックを参照してページ内のチャプターリストを取得
    ret = []
    for k, forkList of @forkChapterList
      for chapter in forkList
        ret.push(chapter)
    return ret

  # チャプターインデックス取得
  # @return [Integer] チャプターインデックス
  getChapterIndex: ->
    lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum())
    if lastForkNum?
      return @forkChapterIndex[lastForkNum]
    else
      return 0

  # チャプターインデックス設定
  # @param [Integer] num 設定値
  setChapterIndex: (num) ->
    lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum())
    if lastForkNum?
      @forkChapterIndex[lastForkNum] = num

  # チャプターインデックス追加
  # @param [Integer] addNum 追加値
  addChapterIndex: (addNum) ->
    lastForkNum = RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum())
    if lastForkNum?
      @forkChapterIndex[lastForkNum] = @forkChapterIndex[lastForkNum] + addNum

  # 現在のチャプターインスタンスを取得
  # @return [Object] 現在のチャプターインスタンス
  thisChapter: ->
    return @getForkChapterList()[@getChapterIndex()]

  # 現在のチャプター番号を取得
  # @return [Integer] 現在のチャプター番号
  thisChapterNum: ->
    return @getChapterIndex() + 1

  # 開始イベント
  start: ->
    # ページングガイド作成
    @pagingGuide = new ArrowPagingGuide()
    # チャプター数設定
    RunCommon.setChapterNum(@thisChapterNum())
    # チャプター前処理
    @floatPageScrollHandleCanvas()
    @thisChapter().willChapter()

  # 全てのイベントが終了している場合、チャプターを進める
  nextChapterIfFinishedAllEvent: ->
    if !@thisChapter().finishedAllEvent? || @thisChapter().finishedAllEvent()
      # イベント終了判定メソッドが無い or 終了判定がTrueの場合に進行
      @nextChapter()

  # 次のチャプター処理
  nextChapter: ->
    if @thisChapter().changeForkNum? && @thisChapter().changeForkNum != RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum())
      # フォーク変更
      @switchFork()
    else
      # チャプターをすすめる
      @progressChapter()

  # 現在のフォークでチャプターを進める
  progressChapter: ->
    # 全ガイド非表示
    @hideAllGuide()

    # チャプター後処理
    @thisChapter().didChapter()
    # indexを更新
    if @getForkChapterList().length <= @getChapterIndex() + 1
      @finishAllChapters()
    else
      @addChapterIndex(1)
      # チャプター数設定
      RunCommon.setChapterNum(@thisChapterNum())
      # チャプター前処理
      @thisChapter().willChapter()

  # フォークを変更する
  switchFork: ->
    # 全ガイド非表示
    @hideAllGuide()
    # チャプター後処理
    @thisChapter().didChapter()
    # フォーク番号変更
    if @thisChapter().changeForkNum?
      nfn = @thisChapter().changeForkNum
      if RunCommon.addForkNumToStack(nfn, @getChapterIndex(), window.eventAction.thisPageNum())
        RunCommon.setForkNum(nfn)
    # チャプター数設定
    RunCommon.setChapterNum(@thisChapterNum())
    # チャプター最大値設定
    RunCommon.setChapterMax(@getForkChapterList().length)
    # チャプター前処理
    @thisChapter().willChapter()

  # チャプターを戻す
  rewindChapter: ->
    # 全ガイド非表示
    @hideAllGuide()

    @resetChapter(@getChapterIndex())
    if !@thisChapter().doMoveChapter
      if @getChapterIndex() > 0
        @addChapterIndex(-1)
        @resetChapter(@getChapterIndex())
        RunCommon.setChapterNum(@thisChapterNum())
      else
        oneBeforeForkObj = RunCommon.getOneBeforeObjestFromStack(window.eventAction.thisPageNum())
        lastForkObj = RunCommon.getLastObjestFromStack(window.eventAction.thisPageNum())
        if oneBeforeForkObj && oneBeforeForkObj.forkNum != lastForkObj.forkNum
          # 最後のフォークオブジェクトを削除
          RunCommon.popLastForkNumInStack(window.eventAction.thisPageNum())
          # フォーク番号変更
          nfn = oneBeforeForkObj.forkNum
          RunCommon.setForkNum(nfn)
          # チャプター番号をフォーク以前に変更
          @setChapterIndex(lastForkObj.changedChapterIndex)
          # チャプターリセット
          @resetChapter(@getChapterIndex(), true)
          # チャプター番号設定
          RunCommon.setChapterNum(@thisChapterNum())
          # チャプター最大値設定
          RunCommon.setChapterMax(@getForkChapterList().length)
        else
          # ページ戻し
          window.eventAction.rewindPage()
          return

    # チャプター前処理
    @thisChapter().willChapter()

  # チャプターの内容をリセット
  resetChapter: (chapterIndex = @getChapterIndex(), takeStateCapture = false) ->
    @finishedAllChapters = false
    @finishedScrollDistSum = 0
    @getForkChapterList()[chapterIndex].resetAllEvents(takeStateCapture)

  # 全てのチャプターを戻す
  rewindAllChapters: ->
    for i in [(@getForkChapterList().length - 1)..0] by -1
      chapter = @getForkChapterList()[i]
      chapter.resetAllEvents()
    @setChapterIndex(0)
    RunCommon.setChapterNum(@thisChapterNum())
    @finishedAllChapters = false
    @finishedScrollDistSum = 0
    @start()

  # スクロールイベントをハンドル
  # @param [Int] x X軸の動作値
  # @param [Int] y Y軸の動作値
  handleScrollEvent: (x, y) ->
    if !@finishedAllChapters
      if @isScrollChapter()
        @thisChapter().scrollEvent(x, y)
    else
      if window.eventAction.hasNextPage()
        # 次ページ移動ガイドを表示する
        if @pagingGuide?
          @pagingGuide.scrollEvent(x, y)

  # スクロールチャプターか判定
  isScrollChapter: ->
    return @thisChapter().scrollEvent?

  # 全てのイベントアイテムをFrontから落とす
  floatPageScrollHandleCanvas: ->
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    scrollContents.css('z-index', scrollViewSwitchZindex.off)
    @getForkChapterList().forEach((chapter) ->
      chapter.floatScrollHandleCanvas()
    )

  # ページ前処理
  willPage: ->
    # ページ状態初期化のため、ここで全チャプターのイベントを初期化
    @initChapterEvent()
    # フォーカス
    @initFocus()
    # リセット
    @resetAllChapters()
    # 固定アイテム描画
    @drawFixedItem()
    # チャプター最大値設定
    RunCommon.setChapterMax(@getForkChapterList().length)
    # キャッシュ保存
    LocalStorage.saveAllPageValues()

  # ページ戻し前処理
  willPageFromRewind: (beforeScrollWindowSize) ->
    # ページ状態初期化のため、ここで全チャプターのイベントを初期化
    @initChapterEvent()
    # フォーカス
    @initFocus(false)
    # 最後のイベント以外リセット
    @forwardProgressChapters()
    @getForkChapterList()[@getForkChapterList().length - 1].resetAllEvents()
    # チャプター最大値設定
    RunCommon.setChapterMax(@getForkChapterList().length)
    # インデックスを最後のチャプターに
    @setChapterIndex(@getForkChapterList().length - 1)
    # フォーク番号設定
    RunCommon.setForkNum(RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum()))
    # チャプター初期化
    @resetChapter()
    # 固定アイテム描画
    @drawFixedItem()
    # キャッシュ保存
    LocalStorage.saveAllPageValues()

  # ページ後処理
  didPage: ->
    # 操作履歴を保存
    RunCommon.saveFootprint()

  # チャプターのイベントを初期化
  initChapterEvent: ->
    for chapter in @getProgressChapterList()
      for i in [0..(chapter.eventObjList.length - 1)]
        event = chapter.eventObjList[i]
        event.initEvent(chapter.eventList[i])

  # チャプターのフォーカス初期化
  initFocus: (focusToFirst = true) ->
    flg = false
    if focusToFirst
      for chapter in @getForkChapterList()
        if flg
          return false
        for event in chapter.eventList
          if flg
            return false
          if !event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
            chapter.focusToActorIfNeed(true)
            flg = true
    else
      for i in [(@getForkChapterList().length - 1)..0] by -1
        chapter = @getForkChapterList()[i]
        if flg
          return false
        for event in chapter.eventList
          if flg
            return false
          if !event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
            chapter.focusToActorIfNeed(true)
            flg = true

  # 固定アイテムの描画
  drawFixedItem: ->
    instances = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix())
    for key, instance of instances
      value = instance.value
      ins = Common.getInstanceFromMap(false, value.id, value.itemToken)
      ap = ins.constructor.actionProperties
      if ap.isFixed? && ap.isFixed
        ins.reDraw()

  # 全てのチャプターをリセット
  resetAllChapters: ->
    @getAllChapterList().forEach((chapter) ->
      chapter.resetAllEvents()
    )

  # フォークを含んだ動作予定のチャプターを進行
  forwardProgressChapters: ->
    @getProgressChapterList().forEach((chapter) ->
      chapter.forwardAllEvents()
    )

  # 全てのチャプターのガイドを非表示
  hideAllGuide: ->
    @getForkChapterList().forEach((chapter) ->
      chapter.hideGuide()
    )

  # イベント終了イベント
  finishAllChapters: ->
    @finishedAllChapters = true
    if window.debug
      console.log('Finish All Chapters!')
    if window.eventAction.hasNextPage()
      # ページ移動のためのスクロールイベントを取るようにする
      @floatPageScrollHandleCanvas()
    else
      # 全ページ終了の場合
      window.eventAction.finishAllPages()

  # 中断
  shutdown: ->
    @hideAllGuide()
