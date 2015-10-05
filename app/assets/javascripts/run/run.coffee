$ ->
  window.isWorkTable = false
  window.eventAction = null
  window.runPage = true

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

  # 環境設定
  Common.applyEnvironmentFromPagevalue()
  # Mainコンテナ作成
  Common.createdMainContainerIfNeeded(PageValue.getPageNum())
  # コンテナ初期化
  RunCommon.initMainContainer()

  # 共通設定
  Setting.initConfig()
  # 必要JS読み込み
  Common.loadJsFromInstancePageValue(->
    # イベント初期化
    RunCommon.initEventAction()
  )
