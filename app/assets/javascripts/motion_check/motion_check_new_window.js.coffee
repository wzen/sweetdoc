class MotionCheckNewWindow



$ ->
  window.isWorkTable = false
  window.eventAction = null
  window.runPage = true
  window.initDone = false

  # 変数初期化
  CommonVar.initVarWhenLoadedView()
  CommonVar.initCommonVar()
  # デフォルト1ページ目から
  PageValue.setPageNum(1)

  # キャッシュ読み込み
  is_reload = PageValue.getInstancePageValue(PageValue.Key.IS_RUNWINDOW_RELOAD)
  if is_reload?
    LocalStorage.loadAllPageValues()
  else
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
