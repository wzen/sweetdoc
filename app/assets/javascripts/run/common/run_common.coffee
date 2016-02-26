class RunCommon
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
    @initHandleScrollView()
    Common.initScrollContentsPosition()

  # Mainビューのサイズ更新
  @updateMainViewSize = ->
    # mainビュー高さ修正
    contentsWidth = $('#contents').width()
    contentsHeight = $('#contents').height()

    # スクリーンサイズ修正
    projectScreenSize = Common.getScreenSize()
    updatedProjectScreenSize = $.extend(true, {}, projectScreenSize);
    # Paddingを考慮して比較
    if contentsWidth < projectScreenSize.width + 30
      # 縮小
      updatedProjectScreenSize.width = contentsWidth - 30
    if contentsHeight < projectScreenSize.height + 10
      # 縮小
      updatedProjectScreenSize.height = contentsHeight - 10

    # BaseScale 修正
    widthRate = updatedProjectScreenSize.width / projectScreenSize.width
    heightRate = updatedProjectScreenSize.height / projectScreenSize.height
    if widthRate < heightRate
      scaleFromViewRate = widthRate
    else
      scaleFromViewRate = heightRate
    if scaleFromViewRate == 0.0
      scaleFromViewRate = 0.01
    window.runScaleFromViewRate = scaleFromViewRate
    updatedProjectScreenSize.width = projectScreenSize.width * scaleFromViewRate
    updatedProjectScreenSize.height = projectScreenSize.height * scaleFromViewRate
    $('#project_wrapper').css({width: updatedProjectScreenSize.width, height: updatedProjectScreenSize.height})
    # FIXME: 表示位置もScaleに合わせて直す
    Common.applyViewScale()

  # 画面リサイズイベント
  @resizeMainContainerEvent = ->
    @updateMainViewSize()
    Common.updateCanvasSize()
    # FIXME: ⇣ フォーカス後にリサイズするとずれるため一旦コメントアウト
    #Common.updateScrollContentsFromScreenEventVar()

  # ウィンドウリサイズイベント
  @resizeEvent = ->
    RunCommon.resizeMainContainerEvent()

  # 詳細情報を表示
  @showCreatorInfo = ->
    info = $('#contents').find('.contents_info:first')

    _setClose = (info) ->
      # ビュークリックで非表示
      $('#contents').off('click.contents_info').on('click.contents_info', (e) ->
        if info.is(':visible')
          info.fadeOut('200')
          $('#contents').off('click.contents_info')
      )

    info.fadeIn('500', ->
      # ビュークリックで非表示
      _setClose.call(@, info)
      setTimeout( ->
        info.fadeOut('500')
      , 3000)
    )
    # iボタンで情報表示
    $('#contents .contents_info_show_button:first').off('click').on('click', (e) =>
      if !info.is(':visible')
        info.fadeIn('200', =>
          # ビュークリックで非表示
          _setClose.call(@, info)
        )
    )

    # Share情報表示
    share = $('#contents').find('.share_info:first')
    $('#contents .contents_share_show_button:first').off('click').on('click', (e)=>
      if !share.is(':visible')
        share.fadeIn('200')
    )
    # Share情報クリックで非表示
    share.off('click').on('click', (e) =>
      if share.is(':visible')
        share.fadeOut('200')
    )
    share.find('textarea, input').off('click.close').on('click', (e) ->
      e.preventDefault()
      e.stopPropagation()
      $(@).select()
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

  # 操作ボタンイベント初期化
  @initOperationEvent = ->
    operationWrapper = $('.operation_wrapper')
    operationWrapper.find('.rewind_all_capter').off('click').on('click', ->
      if window.eventAction?
        window.eventAction.thisPage().rewindAllChapters()
    )
    operationWrapper.find('.rewind_capter').off('click').on('click', ->
      if window.eventAction?
        window.eventAction.thisPage().rewindChapter()
    )

  # Handleスクロールビューの初期化
  @initHandleScrollView = ->
    # スクロール位置初期化
    window.skipScrollEvent = true
    window.scrollHandleWrapper.scrollLeft(window.scrollHandle.width() * 0.5)
    window.scrollHandleWrapper.scrollTop(window.scrollHandle.height() * 0.5)
    # スクロールイベント設定
    @setupScrollEvent()

  # スクロールイベントの初期化
  @setupScrollEvent = ->
    lastLeft = window.scrollHandleWrapper.scrollLeft()
    lastTop = window.scrollHandleWrapper.scrollTop()
    stopTimer = null
    scrollStack = []

    window.scrollHandleWrapper.off('scroll').on('scroll', (e) =>
      _scroll = (target, x, y) ->
        if stopTimer != null
          clearTimeout(stopTimer)
        stopTimer = setTimeout( =>
          RunCommon.initHandleScrollView()
          lastLeft = target.scrollLeft()
          lastTop = target.scrollTop()
          clearTimeout(stopTimer)
          stopTimer = null
        , 100)

        distX = x - lastLeft
        distY = y - lastTop
        #console.log('distX:' + distX + ' distY:' + distY)
        window.scrollRunning = true
        if window.scrollRunningTimer?
          clearTimeout(window.scrollRunningTimer)
          window.scrollRunningTimer = null
        window.scrollRunningTimer = setTimeout( =>
          window.scrollRunning = false
        , 100)
        requestAnimationFrame( =>
          window.eventAction.thisPage().handleScrollEvent(distX, distY)
          lastLeft = x
          lastTop = y
          if scrollStack.length > 0
            # スタックから取り出し
            s = $.extend({}, scrollStack[0])
            scrollStack.shift()
            _scroll.call(@, target, s.x, s.y)
          else
            window.scrollRunning = false
        )

      target = $(e.target)
      x = target.scrollLeft()
      y = target.scrollTop()
      if window.scrollRunning? && window.scrollRunning
        # スタックに登録
        scrollStack.push({x: x, y: y})
        return
      if window.skipScrollEvent? && window.skipScrollEvent
        window.skipScrollEvent = false
        return
      e.preventDefault()
      e.stopPropagation()
      if !RunCommon.enabledScroll()
        return
      _scroll.call(@, target, x, y)
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
            Common.ajaxError(data)
        error: (data) ->
          console.log('/run/paging ajax error')
          Common.ajaxError(data)
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
    @initHandleScrollView()
    Common.initResize(@resizeEvent)
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
              Common.ajaxError(data)
          error: (data) ->
            console.log('/run/save_gallery_footprint ajax error')
            Common.ajaxError(data)
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
              Common.ajaxError(data)
          error: (data) ->
            console.log('/run/load_common_gallery_footprint ajax error')
            Common.ajaxError(data)
        }
      )

  @start = (useLocalStorate = false) ->
    window.eventAction = null
    window.runPage = true
    window.initDone = false
    window.runScaleFromViewRate = 1.0

    # メッセージ
    Common.showModalFlashMessage('Getting ready')

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
      # 操作ボタン初期化
      RunCommon.initOperationEvent()
      # メッセージ非表示
      Common.hideModalView()
      # 初期化終了
      window.initDone = true
    )

  @shutdown = ->
    if window.eventAction?
      window.eventAction.shutdown()



