# アプリ内共通変数
class CommonVar

  # 変数初期化(トップ画面読み込み時に一度だけ実行)
  @initVarWhenLoadedView = ->
    window.instanceMap = {}
    window.itemInitFuncList = []
    window.debug = true
    window.copiedInstance = null
    window.operationHistories = {}
    window.operationHistoryTailIndexes = {}
    window.operationHistoryIndexes = {}

  # 変数初期化(全メニュー共通)
  @initCommonVar = ->
    window.appName = 'DDesk'
    window.scrollViewSize = 30000
    window.pageNumMax = 10000

  # 作業テーブルのJQueryオブジェクト保存
  # @param [Integer] pageNum ページ番号
  @updateWorktableBaseElement = (pageNum) ->
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    window.sidebarWrapper = $("#sidebar-wrapper")
    window.scrollContents = $("#pages .#{page} .scroll_contents:first")
    window.scrollInsideWrapper = $("#pages .#{page} .scroll_inside_wrapper:first")
    window.scrollInside = $("#pages .#{page} .scroll_inside:first")
    window.mainWrapper = $("#pages .#{page} .main-wrapper:first")
    window.drawingCanvas = $("#pages .#{page} .canvas_container:first")[0]
    window.drawingContext = drawingCanvas.getContext('2d')
    window.cssCode = $("#cssCode")

  # 実行画面のJQueryオブジェクト保存
  # @param [Integer] pageNum ページ番号
  @updateRunBaseElement = (pageNum) ->
    page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    window.mainWrapper = $("#pages .#{page} .main-wrapper:first")
    window.scrollContents = $("#pages .#{page} .scroll_contents:first")
    window.scrollHandleWrapper = $("#pages .#{page} .scroll_handle_wrapper:first")
    window.scrollHandle = $("#pages .#{page} .scroll_handle:first")
    window.scrollInsideCover = $("#pages .#{page} .scroll_inside_cover:first")
    window.scrollInsideWrapper = $("#pages .#{page} .scroll_inside_wrapper:first")
    window.scrollInside = $("#pages .#{page} .scroll_inside:first")
    window.canvasWrapper = $("#pages .#{page} .canvas_wrapper:first")
    window.drawingCanvas = $("#pages .#{page} .canvas_container:first")[0]
    window.drawingContext = drawingCanvas.getContext('2d')
    window.cssCode = $("#cssCode")

  # アイテムプレビューのJQueryオブジェクト保存
  @updateItemPreviewBaseElement = ->
    window.sidebarWrapper = $("#sidebar-wrapper")
    window.mainWrapper = $("#main .main-wrapper:first")
    window.scrollContents = $("#main .scroll_contents:first")
    window.scrollHandleWrapper = $("#main .scroll_handle_wrapper:first")
    window.scrollHandle = $("#main .scroll_handle:first")
    window.scrollInsideCover = $("#main .scroll_inside_cover:first")
    window.scrollInsideWrapper = $("#main .scroll_inside_wrapper:first")
    window.scrollInside = $("#main .scroll_inside:first")
    window.canvasWrapper = $("#main .canvas_wrapper:first")
    window.drawingCanvas = $("#main .canvas_container:first")[0]
    window.drawingContext = drawingCanvas.getContext('2d')
    window.cssCode = $("#cssCode")

  # 作業テーブル共通変数
  @worktableCommonVar = ->
    @initCommonVar()
    window.messageTimer = null
    window.flushMessageTimer = null
    window.mode = Constant.Mode.NOT_SELECT
    window.selectedObjId = null
    window.runningPreview = false
    @updateWorktableBaseElement(PageValue.getPageNum())

  # 実行画面共通変数
  @runCommonVar = ->
    @initCommonVar()
    window.distX = 0
    window.distY = 0
    window.resizeTimer = false
    window.scrollViewSwitchZindex = {'on': Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT), 'off': Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM)}
    window.disabledEventHandler = false
    window.firstItemFocused = false
    @updateRunBaseElement(PageValue.getPageNum())

  # アイテムプレビュー共通変数
  @itemPreviewVar = ->
    @initCommonVar()
    if window.isWorkTable
      window.messageTimer = null
      window.flushMessageTimer = null
      window.mode = Constant.Mode.NOT_SELECT
      window.selectedObjId = null
      window.runningPreview = false
    else
      window.distX = 0
      window.distY = 0
      window.resizeTimer = false
      window.scrollViewSwitchZindex = {'on': Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT), 'off': Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM)}
      window.disabledEventHandler = false
      window.firstItemFocused = false
    @updateItemPreviewBaseElement()
