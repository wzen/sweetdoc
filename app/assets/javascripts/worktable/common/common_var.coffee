# 共有変数定義
initCommonVar = ->
  window.sidebarWrapper = $("#sidebar-wrapper")
  window.scrollContents = $('#scroll_contents')
  window.scrollInside = $('#scroll_inside')
  window.cssCode = $("#cssCode")
  window.messageTimer = null
  window.flushMessageTimer = null
  window.mode = Constant.Mode.DRAW
  window.lstorage = localStorage
  window.itemObject = {}
  window.itemInitFuncList = []
  window.operationHistory = []
  window.operationHistoryIndex = 0
  window.scrollViewMag = 500

  # WebStorageを初期化する
  lstorage.clear()

  # 初期状態としてボタンを選択(暫定)
  window.selectItemMenu = Constant.ItemId.BUTTON
  loadItemJs(Constant.ItemId.BUTTON)

