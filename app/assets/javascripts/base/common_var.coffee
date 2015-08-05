# 共有変数定義
_commonVar = ->
  window.sidebarWrapper = $("#sidebar-wrapper")
  window.scrollContents = $('#scroll_contents')
  window.scrollInside = $('#scroll_inside')
  window.cssCode = $("#cssCode")
  window.lstorage = localStorage
  window.scrollViewMag = 500

# 作業テーブル共通変数
worktableCommonVar = ->
  _commonVar()

  window.messageTimer = null
  window.flushMessageTimer = null
  window.mode = Constant.Mode.DRAW
  window.itemObject = {}
  window.itemInitFuncList = []
  window.operationHistory = []
  window.operationHistoryIndex = 0

# 実行テーブル共通変数
runCommonVar = ->
  _commonVar()

  window.mainWrapper = $('#main-wrapper')
  window.scrollWrapper = $("#scroll_wrapper")
  window.scrollHandleWrapper = $("#scroll_handle_wrapper")
  window.scrollHandle = $("#scroll_handle")
  window.scrollInsideCover = $('#scroll_inside_cover')
  window.distX = 0
  window.distY = 0
  window.resizeTimer = false
  window.timeLine = null
  window.scrollViewSwitchZindex = {'on': 100, 'off': 0}
  window.scrollInsideCoverZindex = 1
  window.lstorage = localStorage
  window.disabledEventHandler = false
  window.firstItemFocused = false
  window.instanceMap = {}