class Run

  # 閲覧ページ読み込みフラグ
  window.runPage = true

$ ->
  # 変数初期化
  CommonVar.initVarWhenLoadedView()
  CommonVar.initCommonVar()
  window.eventAction = null
  # デフォルト1ページ目から
  PageValue.setPageNum(1)

  # キャッシュ読み込み
  is_reload = PageValue.getInstancePageValue(PageValue.Key.IS_RUNWINDOW_RELOAD)
  if is_reload?
    LocalStorage.loadValueForRun()
  else
    LocalStorage.saveValueForRun()

  # Mainコンテナ作成
  Common.createdMainContainerIfNeeded(PageValue.getPageNum())
  # コンテナ初期化
  RunCommon.initMainContainer()
  RunCommon.updateMainViewHeight()
  # 共通設定
  Setting.initConfig()
  # イベント初期化
  RunCommon.initEventAction()