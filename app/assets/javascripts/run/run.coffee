class Run

  # 閲覧ページ読み込みフラグ
  window.runPage = true

$ ->
  # 変数初期化
  CommonVar.initVarWhenLoadedView()
  CommonVar.initCommonVar()
  window.eventAction = null
  # Mainコンテナ作成
  Common.createdMainContainerIfNeeded(PageValue.getPageNum())
  # コンテナ初期化
  RunCommon.initMainContainer()
  # イベント初期化
  RunCommon.initEventAction()