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
    if window.runDebug
      console.log('Page Start')
    # ページングガイド作成
    @pagingGuide = new ArrowPagingGuide()
    # チャプター数設定
    RunCommon.setChapterNum(@thisChapterNum())
    # チャプター前処理
    @floatPageScrollHandleCanvas()
    if @thisChapter()?
      @thisChapter().willChapter()
    else
      # チャプター無し -> 終了
      @finishAllChapters()

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
    if window.runDebug
      console.log('Page rewindChapter')
    # 全ガイド非表示
    @hideAllGuide()
    @resetChapter(@getChapterIndex(), =>
      if !@thisChapter().doMoveChapter
        if @getChapterIndex() > 0
          @addChapterIndex(-1)
          @resetChapter(@getChapterIndex(), =>
            RunCommon.setChapterNum(@thisChapterNum())
            # チャプター前処理
            @thisChapter().willChapter()
            FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0)
          )
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
            @resetChapter(@getChapterIndex(), =>
              # チャプター番号設定
              RunCommon.setChapterNum(@thisChapterNum())
              # チャプター最大値設定
              RunCommon.setChapterMax(@getForkChapterList().length)
              # チャプター前処理
              @thisChapter().willChapter()
              FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0)
            )
          else
            # ページ戻し
            window.eventAction.rewindPage( =>
              FloatView.show('Rewind previous page', FloatView.Type.REWIND_CHAPTER, 1.0)
            )
            return
      else
        # チャプター前処理
        @thisChapter().willChapter()
        FloatView.show('Rewind event', FloatView.Type.REWIND_CHAPTER, 1.0)
    )

  # チャプターの内容をリセット
  resetChapter: (chapterIndex = @getChapterIndex(), callback = null) ->
    if window.runDebug
      console.log('Page resetChapter')
    @finishedAllChapters = false
    @finishedScrollDistSum = 0
    @getForkChapterList()[chapterIndex].resetAllEvents(callback)

  # 全てのチャプターを戻す
  rewindAllChapters: (rewindPageIfNeed = true, callback = null) ->
    if window.runDebug
      console.log('Page rewindAllChapters')

    # 全ガイド非表示
    @hideAllGuide()
    if !@thisChapter().doMoveChapter && rewindPageIfNeed
      # 前ページを先頭チャプターに戻す
      beforePage = window.eventAction.beforePage()
      if beforePage?
        window.eventAction.rewindPage( =>
          beforePage.rewindAllChapters(false, =>
            FloatView.show('Rewind previous page', FloatView.Type.REWIND_CHAPTER, 1.0)
          )
        )
      if callback?
        callback()
    else
      _callback = ->
        @setChapterIndex(0)
        RunCommon.setChapterNum(@thisChapterNum())
        @finishedAllChapters = false
        @finishedScrollDistSum = 0
        @start()
        if rewindPageIfNeed
          FloatView.show('Rewind all events', FloatView.Type.REWIND_ALL_CHAPTER, 1.0)
        if callback?
          callback()
      if @getForkChapterList().length == 0
        _callback.call(@)
      else
        count = 0
        for i in [(@getForkChapterList().length - 1)..0] by -1
          @setChapterIndex(i)
          @resetChapter(i, =>
            count += 1
            if count >= @getForkChapterList().length
              _callback.call(@)
          )

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
    if window.runDebug
      console.log('Page floatPageScrollHandleCanvas')

    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    scrollContents.css('z-index', scrollViewSwitchZindex.off)
    @getForkChapterList().forEach((chapter) ->
      chapter.enableScrollHandleViewEvent()
    )

  # ページ前処理
  willPage: (callback = null)->
    if window.runDebug
      console.log('Page willPage')
    # ページ状態初期化のため、ここで全チャプターのイベントを初期化
    @initChapterEvent()
    # リセット
    @resetAllChapters( =>
      # アイテム状態初期化
      @initItemDrawingInPage( =>
        # フォーカス
        @initFocus(true)
        # チャプター最大値設定
        RunCommon.setChapterMax(@getForkChapterList().length)
        # キャッシュ保存
        LocalStorage.saveAllPageValues()
        if callback?
          callback()
      )
    )

  # ページ戻し前処理
  willPageFromRewind: (callback = null) ->
    if window.runDebug
      console.log('Page willPageFromRewind')

    # ページ状態初期化のため、ここで全チャプターのイベントを初期化
    @initChapterEvent()
    # アイテム状態初期化
    @initItemDrawingInPage( =>
      # フォーカス
      @initFocus(false)
      # 最後のイベントのみリセット
      @forwardProgressChapters()
      @getForkChapterList()[@getForkChapterList().length - 1].resetAllEvents( =>
        # チャプター最大値設定
        RunCommon.setChapterMax(@getForkChapterList().length)
        # インデックスを最後のチャプターに
        @setChapterIndex(@getForkChapterList().length - 1)
        # フォーク番号設定
        RunCommon.setForkNum(RunCommon.getLastForkNumFromStack(window.eventAction.thisPageNum()))
        # チャプター初期化
        @resetChapter(@getChapterIndex(), =>
          # キャッシュ保存
          LocalStorage.saveAllPageValues()
          if callback?
            callback()
        )
      )
    )

  # ページ後処理
  didPage: ->
    if window.runDebug
      console.log('Page didPage')

    # 操作履歴を保存
    RunCommon.saveFootprint()

  # チャプターのイベントを初期化
  initChapterEvent: ->
    for chapter in @getAllChapterList()
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

  # アイテム表示の初期化
  initItemDrawingInPage: (callback = null) ->
    if window.runDebug
      console.log('Page initItemDrawingInPage')

    # アイテムインスタンス取得(無い場合は作成 & 初期化もする)
    objs = Common.itemInstancesInPage(PageValue.getPageNum(), true, true)
    if objs.length == 0
      if callback?
        callback()
      return
    finishCount = 0
    for obj in objs
      #if obj.visible
      # 初期表示
      obj.refreshIfItemNotExist(obj.visible, (obj) =>
        if obj.firstFocus
          # 初期フォーカス
          window.disabledEventHandler = true
          Common.focusToTarget(obj.getJQueryElement(), ->
            window.disabledEventHandler = false
          , true)
        finishCount += 1
        if finishCount >= objs.length
          if callback?
            callback()
      )

  # 全てのチャプターをリセット
  resetAllChapters: (callback = null) ->
    if window.runDebug
      console.log('Page resetAllChapters')
    count = 0
    max = @getAllChapterList().length
    if max == 0
      if callback?
        callback()
    else
      @getAllChapterList().forEach((chapter) ->
        chapter.resetAllEvents( =>
          count += 1
          if count >= max
            if callback?
              callback()
        )
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
  finishAllChapters: (nextPageIndex = null) ->
    if window.runDebug
      console.log('Page finishAllChapters')
      if nextPageIndex?
        console.log('nextPageIndex: ' + nextPageIndex)
    if nextPageIndex?
      window.eventAction.nextPageIndex = nextPageIndex
    @finishedAllChapters = true
    if nextPageIndex || window.eventAction.hasNextPage()
      # ページ移動のためのスクロールイベントを取るようにする
      @floatPageScrollHandleCanvas()
    else
      # 全ページ終了の場合
      window.eventAction.finishAllPages()
      FloatView.show('Finished all', FloatView.Type.FINISH, 3.0)

  # 中断
  shutdown: ->
    @hideAllGuide()
