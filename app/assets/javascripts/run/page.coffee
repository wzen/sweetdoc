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
            if obj[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionEventHandleType.CLICK
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

  # チャプターリスト取得
  # @return [Array] チャプターリスト
  getChapterList: ->
    stack = window.forkNumStacks[window.eventAction.thisPageNum()]
    if stack? && stack.length > 0
      lastForkNum = stack[stack.length - 1]
      return @forkChapterList[lastForkNum]
    else
      return []

  # チャプターインデックス取得
  # @return [Integer] チャプターインデックス
  getChapterIndex: ->
    stack = window.forkNumStacks[window.eventAction.thisPageNum()]
    if stack? && stack.length > 0
      lastForkNum = stack[stack.length - 1]
      return @forkChapterIndex[lastForkNum]
    else
      return 0

  # チャプターインデックス設定
  # @param [Integer] num 設定値
  setChapterIndex: (num) ->
    stack = window.forkNumStacks[window.eventAction.thisPageNum()]
    if stack? && stack.length > 0
      lastForkNum = stack[stack.length - 1]
      @forkChapterIndex[lastForkNum] = num

  # チャプターインデックス追加
  # @param [Integer] addNum 追加値
  addChapterIndex: (addNum) ->
    stack = window.forkNumStacks[window.eventAction.thisPageNum()]
    if stack? && stack.length > 0
      lastForkNum = stack[stack.length - 1]
      @forkChapterIndex[lastForkNum] = @forkChapterIndex[lastForkNum] + addNum

  # 現在のチャプターインスタンスを取得
  # @return [Object] 現在のチャプターインスタンス
  thisChapter: ->
    return @getChapterList()[@getChapterIndex()]

  # 現在のチャプター番号を取得
  # @return [Integer] 現在のチャプター番号
  thisChapterNum: ->
    return @getChapterIndex() + 1

  # 開始イベント
  start: ->
    # ページングガイド作成
    @pagingGuide = new ArrowPagingGuide()
    # チャプター数設定
    Navbar.setChapterNum(@thisChapterNum())
    # チャプター前処理
    @floatPageScrollHandleCanvas()
    @thisChapter().willChapter()

  # 全てのイベントが終了している場合、チャプターを進める
  nextChapterIfFinishedAllEvent: ->
    if @thisChapter().finishedAllEvent()
      @nextChapter()

  # チャプターを進める
  nextChapter: ->
    # 全ガイド非表示
    @hideAllGuide()

    # チャプター後処理
    @thisChapter().didChapter()
    # indexを更新
    if @getChapterList().length <= @getChapterIndex() + 1
      @finishAllChapters()
    else
      @addChapterIndex(1)
      # チャプター数設定
      Navbar.setChapterNum(@thisChapterNum())
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
        Navbar.setChapterNum(@thisChapterNum())
      else
        stack = window.forkNumStacks[window.eventAction.thisPageNum()]
        if stack.length > 0
          if stack[stack.length - 1] != PageValue.Key.EF_MASTER_FORKNUM
            # フォーク戻し & チャプター開始
            stack.pop()
            @resetChapter(@getChapterIndex())
            Navbar.setChapterNum(@thisChapterNum())
          else
            # ページ戻し
            window.eventAction.rewindPage()

    # チャプター前処理
    @thisChapter().willChapter()

  # チャプターの内容をリセット
  resetChapter: (chapterIndex = @getChapterIndex()) ->
    @finishedAllChapters = false
    @finishedScrollDistSum = 0
    @getChapterList()[chapterIndex].resetAllEvents()

  # 全てのチャプターを戻す
  rewindAllChapters: ->
    for i in [(@getChapterList().length - 1)..0] by -1
      chapter = @getChapterList()[i]
      chapter.resetAllEvents()
    @setChapterIndex(0)
    Navbar.setChapterNum(@thisChapterNum())
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
    @getChapterList().forEach((chapter) ->
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
    # チャプター最大値設定
    Navbar.setChapterMax(@getChapterList().length)
    # キャッシュ保存
    LocalStorage.saveAllPageValues()

  # ページ戻し前処理
  willPageFromRewind: (beforeScrollWindowSize) ->
    # ページ状態初期化のため、ここで全チャプターのイベントを初期化
    @initChapterEvent()
    # フォーカス
    @initFocus(false)
    # 最後のイベント以外リセット
    @forwardAllChapters()
    @getChapterList()[@getChapterList().length - 1].resetAllEvents()
    # チャプター最大値設定
    Navbar.setChapterMax(@getChapterList().length)
    # インデックスを最後のチャプターに
    @setChapterIndex(@getChapterList().length - 1)
    # チャプター初期化
    @resetChapter()
    # キャッシュ保存
    LocalStorage.saveAllPageValues()

  # ページ後処理
  didPage: ->

  # チャプターのイベントを初期化
  initChapterEvent: ->
    for chapter in @getChapterList()
      for i in [0..(chapter.eventObjList.length - 1)]
        event = chapter.eventObjList[i]
        event.initEvent(chapter.eventList[i])

  # チャプターのフォーカス初期化
  initFocus: (focusToFirst = true) ->
    flg = false
    if focusToFirst
      for chapter in @getChapterList()
        if flg
          return false
        for event in chapter.eventList
          if flg
            return false
          if !event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
            chapter.focusToActorIfNeed(true)
            flg = true
    else
      for i in [(@getChapterList().length - 1)..0] by -1
        chapter = @getChapterList()[i]
        if flg
          return false
        for event in chapter.eventList
          if flg
            return false
          if !event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]
            chapter.focusToActorIfNeed(true)
            flg = true

  # 全てのチャプター内容をリセット
  resetAllChapters: ->
    @getChapterList().forEach((chapter) ->
      chapter.resetAllEvents()
    )

  # 全てのチャプター内容を進行
  forwardAllChapters: ->
    @getChapterList().forEach((chapter) ->
      chapter.forwardAllEvents()
    )

  # 全てのチャプターのガイドを非表示
  hideAllGuide: ->
    @getChapterList().forEach((chapter) ->
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
