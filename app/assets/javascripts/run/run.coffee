class Run

  # 閲覧ページ読み込みフラグ
  window.runPage = true

$ ->
  window.isWorkTable = false

  # 変数初期化
  CommonVar.initVarWhenLoadedView()
  CommonVar.initCommonVar()
  window.eventAction = null
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
  RunCommon.updateMainViewSize()
  # 共通設定
  Setting.initConfig()
  # 必要JS読み込み
  Common.loadJsFromInstancePageValue(->
    # イベント初期化
    RunCommon.initEventAction()
  )
