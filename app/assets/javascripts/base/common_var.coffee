class CommonVar

  # 初期画面読み込み時に一度だけ実行
  @initVarWhenLoadedView = ->
    window.instanceMap = {}
    window.itemInitFuncList = []

  # 共有変数初期化
  @initCommonVar = ->
    window.scrollViewSize = 30000
    window.pageNumMax = 10000

  # 操作履歴変数初期化
  @initHistoryVar = ->
    window.operationHistories = []
    window.operationHistories[window.pageNum] = []
    window.operationHistoryLimit = 30
    window.operationHistoryTailIndex = null
    window.operationHistoryIndexes = []
    window.operationHistoryIndexes[window.pageNum] = null

  @updateWorktableBaseElement = (pageNum) ->
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    window.sidebarWrapper = $("#sidebar-wrapper")
    window.scrollContents = $("#pages .#{page} .scroll_contents:first")
    window.scrollInside = $("#pages .#{page} .scroll_inside:first")
    window.mainWrapper = $("#pages .#{page} .main-wrapper:first")
    window.drawingCanvas = $("#pages .#{page} .canvas_container:first")[0]
    window.drawingContext = drawingCanvas.getContext('2d')
    window.cssCode = $("#cssCode")

  @updateRunBaseElement = (pageNum) ->
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    window.scrollWrapper = $("#sidebar-wrapper")
    window.mainWrapper = $("#pages .#{page} .main-wrapper:first")
    window.scrollContents = $("#pages .#{page} .scroll_contents:first")
    window.scrollHandleWrapper = $("#pages .#{page} .scroll_handle_wrapper:first")
    window.scrollHandle = $("#pages .#{page} .scroll_handle:first")
    window.scrollInsideCover = $("#pages .#{page} .scroll_inside_cover:first")
    window.scrollInside = $("#pages .#{page} .scroll_inside:first")
    window.canvasWrapper = $("#pages .#{page} .canvas_wrapper:first")
    window.drawingCanvas = $("#pages .#{page} .canvas_container:first")[0]
    window.drawingContext = drawingCanvas.getContext('2d')
    window.cssCode = $("#cssCode")

  # 作業テーブル共通変数
  @worktableCommonVar = ->
    @initCommonVar()
    window.messageTimer = null
    window.flushMessageTimer = null
    window.mode = Constant.Mode.DRAW
    @initHistoryVar()
    @updateWorktableBaseElement(window.pageNum)

  # 実行テーブル共通変数
  @runCommonVar = ->
    @initCommonVar()
    window.distX = 0
    window.distY = 0
    window.resizeTimer = false
    window.eventAction = null
    window.scrollViewSwitchZindex = {'on': Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT), 'off': Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM)}
    window.disabledEventHandler = false
    window.firstItemFocused = false
    @updateRunBaseElement(window.pageNum)
