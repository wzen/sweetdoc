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
      @LOADED_CLASS_DIST_TOKENS = constant.Run.Key.LOADED_CLASS_DIST_TOKENS
      @PROJECT_ID = constant.Run.Key.PROJECT_ID
      @ACCESS_TOKEN = constant.Run.Key.ACCESS_TOKEN
      @RUNNING_USER_PAGEVALUE_ID = constant.Run.Key.RUNNING_USER_PAGEVALUE_ID
      @FOOTPRINT_PAGE_VALUE = constant.Run.Key.FOOTPRINT_PAGE_VALUE
      @LOAD_FOOTPRINT = constant.Run.Key.LOAD_FOOTPRINT

  # 画面初期化
  @initView = ->
    # Canvasサイズ設定
    $(window.drawingCanvas).attr('width', window.canvasWrapper.width())
    $(window.drawingCanvas).attr('height', window.canvasWrapper.height())
    # 暫定でスクロールを上に持ってくる
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)
    # スクロールビューの大きさ
    scrollInsideWrapper.width(window.scrollViewSize)
    scrollInsideWrapper.height(window.scrollViewSize)
    scrollInsideCover.width(window.scrollViewSize)
    scrollInsideCover.height(window.scrollViewSize)
    scrollHandle.width(window.scrollViewSize)
    scrollHandle.height(window.scrollViewSize)
    scrollHandleWrapper.scrollLeft(scrollHandle.width() * 0.5)
    scrollHandleWrapper.scrollTop(scrollHandle.height() * 0.5)
    Common.initScrollContentsPosition()

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

    # FIXME: 拡大縮小で正確に動作しないため使用しない
    # 今は対応しないが残しておく
    # Zoom 修正
#    widthRate = updatedProjectScreenSize.width / projectScreenSize.width
#    heightRate = updatedProjectScreenSize.height / projectScreenSize.height
#    if widthRate < heightRate
#      zoom = widthRate
#    else
#      zoom = heightRate
#    if zoom == 0.0
#      zoom = 0.01
#    updatedProjectScreenSize.width = projectScreenSize.width * zoom
#    updatedProjectScreenSize.height = projectScreenSize.height * zoom
#    $('#main').height(updateMainHeight)
#    $('#project_wrapper').css({width: updatedProjectScreenSize.width, height: updatedProjectScreenSize.height})
#    updateMainWrapperPercent = 100
#    window.mainWrapper.css({transform: "scale(#{zoom}, #{zoom})", width: "#{updateMainWrapperPercent}%", height: "#{updateMainWrapperPercent}%"})

  # ウィンドウの高さ設定
  @resizeMainContainerEvent = ->
    @updateMainViewSize()
    Common.updateCanvasSize()
    Common.updateScrollContentsFromPagevalue()

  # ウィンドウリサイズイベント
  @resizeEvent = ->
    RunCommon.resizeMainContainerEvent()

  # 詳細情報を表示
  @showCreatorInfo = ->
    info = $('#contents').find('.contents_info:first')
    info.fadeIn('500')
    setTimeout( ->
      info.fadeOut('500')
    , 3000)
    # iボタンで情報表示
    $('#contents .contents_info_show_button:first').off('click').on('click', (e)=>
      if !info.is(':visible')
        info.fadeIn('200')
    )
    # 情報ビュークリックで非表示
    info.off('click').on('click', (e) =>
      if info.is(':visible')
        info.fadeOut('200')
    )

  # イベント作成
  @initEventAction = ->
    # アクションのイベントを取得
    pageCount = PageValue.getPageCount()
    pageNum = PageValue.getPageNum()
    pageList = new Array(pageCount)
    for i in [1..pageCount]
      if i == parseInt(pageNum)
        # 初期表示ページのみ作成。ページング時に追加作成する。
        forkEventPageValueList = {}
        for j in [0..PageValue.getForkCount()]
          forkEventPageValueList[j] = PageValue.getEventPageValueSortedListByNum(j, i)
        page = new Page({
          forks: forkEventPageValueList
        })
        pageList[i - 1] = page
      else
        pageList[i - 1] = null

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

  # 対象ページのPageValueデータを読み込み
  # @param [Integer] loadPageNum 読み込むページ番号
  # @param [Function] callback コールバック
  # @param [Boolean] forceUpdate 既存データを上書きするか
  @loadPagingPageValue = (loadPageNum, doLoadFootprint = false, callback = null, forceUpdate = false) ->
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
    data[RunCommon.Key.LOADED_CLASS_DIST_TOKENS] = JSON.stringify(PageValue.getLoadedclassDistTokens())
    locationPaths = window.location.pathname.split('/')
    data[RunCommon.Key.ACCESS_TOKEN] = locationPaths[locationPaths.length - 1].split('?')[0]
    data[RunCommon.Key.RUNNING_USER_PAGEVALUE_ID] = PageValue.getGeneralPageValue(PageValue.Key.RUNNING_USER_PAGEVALUE_ID)
    if window.isMotionCheck && doLoadFootprint
      # 動作確認の場合はLocalStorageから操作履歴を取得
      data[RunCommon.Key.LOAD_FOOTPRINT] = false
      LocalStorage.loadPagingFootprintPageValue(loadPageNum)
    else
      data[RunCommon.Key.LOAD_FOOTPRINT] = doLoadFootprint
    $.ajax(
      {
        url: "/run/paging"
        type: "POST"
        dataType: "json"
        data: data
        success: (data)->
          if data.resultSuccess
            # JSを適用
            Common.setupJsByList(data.itemJsList, ->
              if data.pagevalues?
                if data.pagevalues.general_pagevalue?
                  PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, data.pagevalues.general_pagevalue, true)
                if data.pagevalues.instance_pagevalue?
                  PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, data.pagevalues.instance_pagevalue, true)
                if data.pagevalues.event_pagevalue?
                  PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT, data.pagevalues.event_pagevalue, true)
                if data.pagevalues.footprint?
                  PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, data.pagevalues.footprint, true)

              # コールバック
              if callback?
                callback()
            )
          else
            console.log('/run/paging server error')
        error: (data) ->
          console.log('/run/paging ajax error')
      }
    )

  @getForkStack = (pn) ->
    PageValue.getFootprintPageValue(PageValue.Key.forkStack(pn))

  @setForkStack = (obj, pn) ->
    PageValue.setFootprintPageValue(PageValue.Key.forkStack(pn), [obj])

  # フォーク番号スタック初期化
  # @return [Boolean] 処理正常終了か
  @initForkStack = (forkNum, pn) ->
    # PageValueに書き込み
    @setForkStack({
      changedChapterIndex: 0
      forkNum: forkNum
    }, pn)
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
      PageValue.setFootprintPageValue(PageValue.Key.forkStack(pn), stack)
      return true
    else
      return false

  # スタックから最新フォークオブジェクトを取得
  # @return [Integer] 取得値
  @getLastObjestFromStack = (pn) ->
    stack = @getForkStack(pn)
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
    stack = @getForkStack(pn)
    if stack? && stack.length > 1
      return stack[stack.length - 2]
    else
      return null

  # スタックから最新フォーク番号を削除
  # @return [Boolean] 処理正常終了か
  @popLastForkNumInStack = (pn) ->
    stack = @getForkStack(pn)
    stack[pn].pop()
    # PageValueに書き込み
    PageValue.setFootprintPageValue(PageValue.Key.forkStack(pn), stack)
    return true

  # ギャラリーアップロードビュー表示処理
  @showUploadGalleryConfirm = ->
    target = '_uploadgallery'
    window.open("about:blank", target)
    root = $('#nav')
    $("input[name='#{Constant.Gallery.Key.PROJECT_ID}']", root).val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID))
    $("input[name='#{Constant.Gallery.Key.PAGE_MAX}']", root).val(PageValue.getPageCount())
    document.upload_gallery_form.target = target
    document.upload_gallery_form.submit()

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
    if title_name?
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

  # 操作履歴を保存
  @saveFootprint = (callback = null) ->
    if window.isMotionCheck? && window.isMotionCheck
      # LocalStorageに保存
      LocalStorage.saveFootprintPageValue()
      if callback?
        callback()
    else
      # Serverに保存
      data = {}
      locationPaths = window.location.pathname.split('/')
      data[RunCommon.Key.ACCESS_TOKEN] = locationPaths[locationPaths.length - 1].split('?')[0]
      data[RunCommon.Key.FOOTPRINT_PAGE_VALUE] = JSON.stringify(PageValue.getFootprintPageValue(PageValue.Key.F_PREFIX))
      $.ajax(
        {
          url: "/run/save_gallery_footprint"
          type: "POST"
          data: data
          dataType: "json"
          success: (data)->
            if data.resultSuccess
              if callback?
                callback()
            else
              console.log('/run/save_gallery_footprint server error')
          error: (data) ->
            console.log('/run/save_gallery_footprint ajax error')
        }
      )

  # 操作履歴を読み込み
  @loadCommonFootprint = (callback = null) ->
    if window.isMotionCheck? && window.isMotionCheck
      # LocalStorageから読み込み
      LocalStorage.loadCommonFootprintPageValue()
      if callback?
        callback()
    else
      # Serverから読み込み
      data = {}
      locationPaths = window.location.pathname.split('/')
      data[RunCommon.Key.ACCESS_TOKEN] = locationPaths[locationPaths.length - 1].split('?')[0]
      $.ajax(
        {
          url: "/run/load_common_gallery_footprint"
          type: "POST"
          data: data
          dataType: "json"
          success: (data)->
            if data.resultSuccess
              PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, data.pagevalue_data)
              if callback?
                callback()
            else
              console.log('/run/load_common_gallery_footprint server error')
          error: (data) ->
            console.log('/run/load_common_gallery_footprint ajax error')
        }
      )

  @start = (useLocalStorate = false) ->
    window.eventAction = null
    window.runPage = true
    window.initDone = false

    # 変数初期化
    CommonVar.initVarWhenLoadedView()
    CommonVar.initCommonVar()

    if useLocalStorate
      # キャッシュ読み込み
      is_reload = PageValue.getInstancePageValue(PageValue.Key.IS_RUNWINDOW_RELOAD)
      if is_reload?
        LocalStorage.loadAllPageValues()
      else
        # 1ページから開始
        PageValue.setPageNum(1)
        # footprintを初期化
        PageValue.removeAllFootprint()
        LocalStorage.saveAllPageValues()

    # Mainコンテナ作成
    Common.createdMainContainerIfNeeded(PageValue.getPageNum())
    # コンテナ初期化
    RunCommon.initMainContainer()

    # 必要JS読み込み
    Common.loadJsFromInstancePageValue(->
      # イベント初期化
      RunCommon.initEventAction()
      # 初期化終了
      window.initDone = true
    )

  @shutdown = ->
    if window.eventAction?
      window.eventAction.shutdown()



