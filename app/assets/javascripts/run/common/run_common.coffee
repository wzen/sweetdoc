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
    class @Key
      @TARGET_PAGES = constant.Run.Key.TARGET_PAGES
      @LOADED_ITEM_IDS = constant.Run.Key.LOADED_ITEM_IDS
      @PROJECT_ID = constant.Run.Key.PROJECT_ID
      @ACCESS_TOKEN = constant.Run.Key.ACCESS_TOKEN

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

  # Mainビューのサイズ更新
  @updateMainViewSize = ->
    # mainビュー高さ修正
    updateMainWidth = $('#contents').width()
    infoHeight = 0
    padding = 0
    i = $('.contents_info:first')
    if i?
      infoHeight = i.height()
      padding = 9
    updateMainHeight = $('#contents').height() - $("##{Navbar.NAVBAR_ROOT}").height() - infoHeight - padding

    # スクリーンサイズ修正
    projectScreenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
    updatedProjectScreenSize = $.extend(true, {}, projectScreenSize);
    # Paddingを考慮して比較
    if updateMainWidth < projectScreenSize.width + 30
      # 縮小
      updatedProjectScreenSize.width = updateMainWidth - 30
    if updateMainHeight < projectScreenSize.height + 10
      # 縮小
      updatedProjectScreenSize.height = updateMainHeight - 10

    # Zoom 修正
    widthRate = updatedProjectScreenSize.width / projectScreenSize.width
    heightRate = updatedProjectScreenSize.height / projectScreenSize.height
    if widthRate < heightRate
      zoom = widthRate
    else
      zoom = heightRate
    if zoom == 0.0
      zoom = 0.01
    updatedProjectScreenSize.width = projectScreenSize.width * zoom
    updatedProjectScreenSize.height = projectScreenSize.height * zoom
    updateMainWrapperPercent = 100 / zoom

    $('#main').height(updateMainHeight)
    $('#project_wrapper').css({width: updatedProjectScreenSize.width, height: updatedProjectScreenSize.height})
    window.mainWrapper.css({transform: "scale(#{zoom}, #{zoom})", width: "#{updateMainWrapperPercent}%", height: "#{updateMainWrapperPercent}%"})

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

    data = {}
    data[RunCommon.Key.TARGET_PAGES] = targetPages
    data[RunCommon.Key.LOADED_ITEM_IDS] = JSON.stringify(PageValue.getLoadedItemIds())
    data[RunCommon.Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)
    data[RunCommon.Key.ACCESS_TOKEN] = window.location.pathname.split('/')[3]
    $.ajax(
      {
        url: "/run/paging"
        type: "POST"
        dataType: "json"
        data: data
        success: (data)->
          # JSを適用
          Common.setupJsByList(data.itemJsList, ->
            if data.pagevalues?
              if data.pagevalues.general_pagevalue?
                for k, v of data.pagevalues.general_pagevalue
                  PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, JSON.parse(v))
              if data.pagevalues.instance_pagevalue?
                for k, v of data.pagevalues.instance_pagevalue
                  PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, JSON.parse(v))
              if data.pagevalues.event_pagevalue?
                for k, v of data.pagevalues.event_pagevalue
                  PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT + PageValue.Key.PAGE_VALUES_SEPERATOR + k, JSON.parse(v))
            # コールバック
            if callback?
              callback()
          )
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
    $("input[name='#{Constant.Gallery.Key.PROJECT_ID}']", root).val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID))
    $("input[name='#{Constant.Gallery.Key.PAGE_MAX}']", root).val(PageValue.getPageCount())
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
    Common.applyEnvironmentFromPagevalue()
    RunCommon.updateMainViewSize()

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
