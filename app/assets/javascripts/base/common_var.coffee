# アプリ内共通変数
class CommonVar

  # 変数初期化(トップ画面読み込み時に一度だけ実行)
  @initVarWhenLoadedView = ->
    window.instanceMap = {}
    window.copiedInstance = null
    window.operationHistories = {}
    window.operationHistoryTailIndexes = {}
    window.operationHistoryIndexes = {}
    window.mode = constant.Mode.NOT_SELECT

  # 変数初期化(全メニュー共通)
  @initCommonVar = ->
    window.appName = 'Sweetdoc'
    window.scrollViewSize = 30000
    window.pageNumMax = 100

  # 作業テーブルのJQueryオブジェクト保存
  # @param [Integer] pageNum ページ番号
  @updateWorktableBaseElement = (pageNum) ->
    page = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
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
    page = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    window.mainWrapper = $("#pages .#{page} .main-wrapper:first")
    window.mainWrapperSize = {width: window.mainWrapper.width(), height: window.mainWrapper.height()}
    window.scrollContents = $("#pages .#{page} .scroll_contents:first")
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
    window.selectedObjId = null
    window.worktableItemsChangedState = false
    @updateWorktableBaseElement(PageValue.getPageNum())
    window.eventPointingMode = constant.EventInputPointingMode.NOT_SELECT
    window.previewRunning = false

  # 実行画面共通変数
  @runCommonVar = ->
    @initCommonVar()
    window.distX = 0
    window.distY = 0
    window.resizeTimer = false
    window.disabledEventHandler = false
    window.firstItemFocused = false
    window.scrollHandleWrapper = $("#main .scroll_handle_wrapper:first")
    window.scrollHandle = $("#main .scroll_handle:first")
    @updateRunBaseElement(PageValue.getPageNum())

do ->
  window.itemInitFuncList = {}

  window.debug = false
  constant = gon.const
  window.debug = constant.DEBUG_JS

  window.runDebug = false
