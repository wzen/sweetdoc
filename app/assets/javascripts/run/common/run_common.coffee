class RunCommon
  if gon?
    # 定数
    constant = gon.const
    # @property [String] RUN_CSS CSSスタイルRoot
    @RUN_CSS = constant.ElementAttribute.RUN_CSS

    class @AttributeName
      @CONTENTS_CREATOR_CLASSNAME = constant.Run.AttributeName.CONTENTS_CREATOR_CLASSNAME
      @CONTENTS_TITLE_CLASSNAME = constant.Run.AttributeName.CONTENTS_TITLE_CLASSNAME
      @CONTENTS_CAPTION_CLASSNAME = constant.Run.AttributeName.CONTENTS_CAPTION_CLASSNAME
      @CONTENTS_PAGE_NUM_CLASSNAME = constant.Run.AttributeName.CONTENTS_PAGE_NUM_CLASSNAME
      @CONTENTS_PAGE_MAX_CLASSNAME = constant.Run.AttributeName.CONTENTS_PAGE_MAX_CLASSNAME
      @CONTENTS_CHAPTER_NUM_CLASSNAME = constant.Run.AttributeName.CONTENTS_CHAPTER_NUM_CLASSNAME
      @CONTENTS_CHAPTER_MAX_CLASSNAME = constant.Run.AttributeName.CONTENTS_CHAPTER_MAX_CLASSNAME
      @CONTENTS_FORK_NUM_CLASSNAME = constant.Run.AttributeName.CONTENTS_FORK_NUM_CLASSNAME
      @CONTENTS_TAGS_CLASSNAME = constant.Run.AttributeName.CONTENTS_TAGS_CLASSNAME

  # 画面初期化
  @initView = ->
    # Canvasサイズ設定
    $(window.drawingCanvas).attr('width', window.canvasWrapper.width())
    $(window.drawingCanvas).attr('height', window.canvasWrapper.height())
    # 暫定でスクロールを上に持ってくる
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)

    # スクロールビューの大きさ
    scrollInside.width(window.scrollViewSize)
    scrollInside.height(window.scrollViewSize)
    scrollInsideCover.width(window.scrollViewSize)
    scrollInsideCover.height(window.scrollViewSize)
    scrollHandle.width(window.scrollViewSize)
    scrollHandle.height(window.scrollViewSize)

    # スクロール位置初期化
    Common.updateScrollContentsPosition(scrollInside.width() * 0.5, scrollInside.height() * 0.5)

    scrollHandleWrapper.scrollLeft(scrollHandle.width() * 0.5)
    scrollHandleWrapper.scrollTop(scrollHandle.height() * 0.5)

  # Mainビューの高さ更新
  @updateMainViewSize = ->
    $('#main').height($('#contents').height() - $("##{Navbar.NAVBAR_ROOT}").outerHeight(true))

  # ウィンドウの高さ設定
  @resizeMainContainerEvent = ->
    @updateMainViewSize()
    Common.updateCanvasSize()
    Common.updateScrollContentsFromPagevalue()

  # ウィンドウリサイズイベント
  @resizeEvent = ->
    RunCommon.resizeMainContainerEvent()

  # イベント作成
  @initEventAction = ->
    # アクションのイベントを取得
    pageCount = PageValue.getPageCount()
    pageList = new Array(pageCount)
    for i in [1..pageCount]
      forkEventPageValueList = {}
      for j in [0..PageValue.getForkCount()]
        forkEventPageValueList[j] = PageValue.getEventPageValueSortedListByNum(j, i)
      page = null
      if forkEventPageValueList[PageValue.Key.EF_MASTER_FORKNUM].length > 0
        # Masterデータが存在する場合ページを作成
        page = new Page({
          forks: forkEventPageValueList
        })
      pageList[i - 1] = page

    # ナビバーのページ数 & チャプター数設定
    RunCommon.setPageMax(pageCount)
    # アクション作成
    window.eventAction = new EventAction(pageList, PageValue.getPageNum() - 1)
    window.eventAction.start()

  # Handleスクロール位置の初期化
  @initHandleScrollPoint = ->
    window.scrollHandleWrapper.scrollLeft(window.scrollHandleWrapper.width() * 0.5)
    window.scrollHandleWrapper.scrollTop(window.scrollHandleWrapper.height() * 0.5)

  # スクロールイベントの初期化
  @setupScrollEvent = ->
    lastLeft = window.scrollHandleWrapper.scrollLeft()
    lastTop = window.scrollHandleWrapper.scrollTop()
    stopTimer = null

    window.scrollHandleWrapper.off('scroll')
    window.scrollHandleWrapper.on('scroll', (e) ->
      e.preventDefault()

      if !RunCommon.enabledScroll()
        return

      x = $(@).scrollLeft()
      y = $(@).scrollTop()

      if stopTimer != null
        clearTimeout(stopTimer)
      stopTimer = setTimeout( =>
        RunCommon.initHandleScrollPoint()
        lastLeft = $(@).scrollLeft()
        lastTop = $(@).scrollTop()
        clearTimeout(stopTimer)
        stopTimer = null
      , 100)

      distX = x - lastLeft
      distY = y - lastTop
      lastLeft = x
      lastTop = y

      #console.log('distX:' + distX + ' distY:' + distY)
      window.eventAction.thisPage().handleScrollEvent(distX, distY)
    )

  # スクロールが有効の状態か判定
  # @return [Boolena] 判定結果
  @enabledScroll = ->
    ret = false
    if window.eventAction? &&
      window.eventAction.thisPage()? &&
      (window.eventAction.thisPage().finishedAllChapters || (window.eventAction.thisPage().thisChapter()? && window.eventAction.thisPage().isScrollChapter()))
        ret = true
    return ret

  # CSS要素作成
  # @param [Integer] pageNum ページ番号
  @createCssElement = (pageNum) ->
    # CSS作成
    cssId = @RUN_CSS.replace('@pagenum', pageNum)
    cssEmt = $("##{cssId}")
    if !cssEmt? || cssEmt.length == 0
      $("<div id='#{cssId}'></div>").appendTo(window.cssCode)
      cssEmt = $("##{cssId}")
    cssEmt.html(PageValue.itemCssOnPage(pageNum))

  # 対象ページのPageValueデータを読み込み
  # @param [Integer] loadPageNum 読み込むページ番号
  # @param [Function] callback コールバック
  # @param [Boolean] forceUpdate 既存データを上書きするか
  @loadPagingPageValue = (loadPageNum, callback = null, forceUpdate = false) ->
    lastPageNum = loadPageNum + Constant.Paging.PRELOAD_PAGEVALUE_NUM
    targetPages = []
    for i in [loadPageNum..lastPageNum]
      if forceUpdate
        targetPages.push(i)
      else
        className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', i)
        section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
        if !section? || section.length == 0
          targetPages.push(i)

    if targetPages.length == 0
      if callback?
        callback()
      return

    $.ajax(
      {
        url: "/run/paging"
        type: "POST"
        dataType: "json"
        data: {
          targetPages: targetPages
        }
        success: (data)->
          if data.instance_pagevalue_hash != null
            for k, v of data.instance_pagevalue_hash
              PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)
          if data.event_pagevalue_hash != null
            for k, v of data.event_pagevalue_hash
              PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)

          # コールバック
          if callback?
            callback()
        error: (data) ->
      }
    )

  @getForkStack = (pn) ->
    if !window.forkNumStacks?
      window.forkNumStacks = {}
    return window.forkNumStacks[pn]

  @setForkStack = (obj, pn) ->
    if !window.forkNumStacks?
      window.forkNumStacks = {}
    window.forkNumStacks[pn] = [obj]

  # フォーク番号スタック初期化
  # @return [Boolean] 処理正常終了か
  @initForkStack = (forkNum, pn) ->
    @setForkStack({
      changedChapterIndex: 0
      forkNum: forkNum
    }, pn)
    # PageValueに書き込み
    PageValue.setGeneralPageValue(PageValue.Key.FORK_STACK, window.forkNumStacks)
    return true

  # フォーク番号をスタックに追加
  # @return [Boolean] 処理正常終了か
  @addForkNumToStack = (forkNum, cIndex, pn) ->
    lastForkNum = @getLastForkNumFromStack(pn)
    if lastForkNum? && lastForkNum != forkNum
      # フォーク番号追加
      stack = @getForkStack(pn)
      stack.push(
        {
          changedChapterIndex: cIndex
          forkNum: forkNum
        }
      )
      # PageValueに書き込み
      PageValue.setGeneralPageValue(PageValue.Key.FORK_STACK, window.forkNumStacks)
      return true
    else
      return false

  # スタックから最新フォークオブジェクトを取得
  # @return [Integer] 取得値
  @getLastObjestFromStack = (pn) ->
    if !window.forkNumStacks?
      # PageValueから読み込み
      window.forkNumStacks = PageValue.getGeneralPageValue(PageValue.Key.FORK_STACK)
      if !window.forkNumStacks?
        return null
    stack = window.forkNumStacks[pn]
    if stack? && stack.length > 0
      return stack[stack.length - 1]
    else
      return null

  # スタックから最新フォーク番号を取得
  # @return [Integer] 取得値
  @getLastForkNumFromStack = (pn) ->
    obj = @getLastObjestFromStack(pn)
    if obj?
      return obj.forkNum
    else
      return null

  # スタックから以前のフォークオブジェクトを取得
  # @return [Integer] 取得値
  @getOneBeforeObjestFromStack = (pn) ->
    if !window.forkNumStacks?
      # PageValueから読み込み
      window.forkNumStacks = PageValue.getGeneralPageValue(PageValue.Key.FORK_STACK)
      if !window.forkNumStacks?
        return null
    stack = window.forkNumStacks[pn]
    if stack? && stack.length > 1
      return stack[stack.length - 2]
    else
      return null

  # スタックから最新フォーク番号を削除
  # @return [Boolean] 処理正常終了か
  @popLastForkNumInStack = (pn) ->
    if !window.forkNumStacks?
      # PageValueから読み込み
      window.forkNumStacks = PageValue.getGeneralPageValue(PageValue.Key.FORK_STACK)
      if !window.forkNumStacks?
        return false
    window.forkNumStacks[pn].pop()
    return true

  # ギャラリーアップロードビュー表示処理
  @showUploadGalleryConfirm = ->
    target = '_uploadgallery'
    window.open("about:blank", target)
    root = $('#nav')
    $(".#{Constant.Gallery.Key.PROJECT_ID}", root).val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID))
    document.upload_gallery_form.target = target
    setTimeout( ->
      document.upload_gallery_form.submit()
    , 200)

  # Mainコンテナ初期化
  @initMainContainer = ->
    CommonVar.runCommonVar()
    @initView()
    @initHandleScrollPoint()
    Common.initResize(@resizeEvent)
    @setupScrollEvent()
    Navbar.initRunNavbar()
    RunCommon.updateMainViewSize()
    Common.applyEnvironmentFromPagevalue()

  # 作成者を設定
  # @param [Integer] value 設定値
  @setCreator = (value) ->
    e = $(".#{@AttributeName.CONTENTS_CREATOR_CLASSNAME}")
    if e?
      e.html(value)
    else
      e.html('')

  # タイトルを設定
  @setTitle = (title_name) ->
    base = title_name
    if !window.isWorkTable
      title_name += '(Preview)'
    $("##{Navbar.NAVBAR_ROOT}").find('.nav_title').html(title_name)
    e = $(".#{@AttributeName.CONTENTS_TITLE_CLASSNAME}")
    if title_name? && title_name.length > 0
      document.title = title_name
    else
      document.title = window.appName

    e = $(".#{@AttributeName.CONTENTS_TITLE_CLASSNAME}")
    if e?
      e.html(base)
    else
      e.html('')

  # ページ番号を設定
  # @param [Integer] value 設定値
  @setPageNum = (value) ->
    e = $(".#{@AttributeName.CONTENTS_PAGE_NUM_CLASSNAME}")
    if e?
      e.html(value)
    else
      e.html('')

  # チャプター番号を設定
  # @param [Integer] value 設定値
  @setChapterNum = (value) ->
    e = $(".#{@AttributeName.CONTENTS_CHAPTER_NUM_CLASSNAME}")
    if e?
      e.html(value)
    else
      e.html('')

  # ページ総数を設定
  # @param [Integer] page_max 設定値
  @setPageMax = (page_max) ->
    e = $(".#{@AttributeName.CONTENTS_PAGE_MAX_CLASSNAME}")
    if e?
      e.html(page_max)
    else
      e.html('')

  # チャプター総数を設定
  # @param [Integer] chapter_max 設定値
  @setChapterMax = (chapter_max) ->
    e = $(".#{@AttributeName.CONTENTS_CHAPTER_MAX_CLASSNAME}")
    if e?
      e.html(chapter_max)
    else
      e.html('')

  # フォーク番号を設定
  # @param [Integer] num 設定値
  @setForkNum = (num) ->
    e = $(".#{@AttributeName.CONTENTS_FORK_NUM_CLASSNAME}")
    if e?
      e.html(num)
      e.closest('li').css('display', if num > 0 then 'block' else 'none')
    else
      e.html('')
      e.closest('li').hide()
