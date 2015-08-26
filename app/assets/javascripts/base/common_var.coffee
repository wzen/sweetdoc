# 共有変数定義
_commonVar = ->
  window.sidebarWrapper = $("#sidebar-wrapper")
  window.scrollContents = $('#scroll_contents')
  window.scrollInside = $('#scroll_inside')
  window.mainWrapper = $('#main-wrapper')
  window.cssCode = $("#cssCode")
  window.scrollViewSize = 30000
  window.instanceMap = {}

# 作業テーブル共通変数
worktableCommonVar = ->
  _commonVar()

  window.messageTimer = null
  window.flushMessageTimer = null
  window.mode = Constant.Mode.DRAW
  window.itemInitFuncList = []
  window.operationHistory = []
  window.operationHistoryLimit = 30
  window.operationHistoryIndex = null
  window.operationHistoryTailIndex = null

# 実行テーブル共通変数
runCommonVar = ->
  _commonVar()
  window.scrollWrapper = $("#scroll_wrapper")
  window.scrollHandleWrapper = $("#scroll_handle_wrapper")
  window.scrollHandle = $("#scroll_handle")
  window.scrollInsideCover = $('#scroll_inside_cover')
  window.distX = 0
  window.distY = 0
  window.resizeTimer = false
  window.eventAction = null
  window.scrollViewSwitchZindex = {'on': Constant.Zindex.EVENTFLOAT, 'off': Constant.Zindex.EVENTBOTTOM}
  window.scrollInsideCoverZindex = 1
  window.disabledEventHandler = false
  window.firstItemFocused = false
