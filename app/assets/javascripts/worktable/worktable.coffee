class Worktable

  # ワークテーブル読み込みフラグ
  window.worktablePage = true

$ ->
  # ブラウザ対応チェック
  if !Common.checkBlowserEnvironment()
    alert('ブラウザ非対応です。')
    return

  # キャッシュチェック
  existedCache = !LocalStorage.isOverWorktableSaveTimeLimit()
  if existedCache
    # キャッシュが存在する場合アイテム描画
    LocalStorage.loadValueForWorktable()

  # 変数初期化
  CommonVar.initVarWhenLoadedView()
  CommonVar.initCommonVar()
  # Mainコンテナ作成
  Common.createdMainContainerIfNeeded(PageValue.getPageNum())
  # コンテナ初期化
  WorktableCommon.initMainContainer()
  WorktableCommon.updateMainViewSize()
  # リサイズイベント
  WorktableCommon.initResize()

  _callback = ->
    # 履歴に画面初期時を状態を保存
    OperationHistory.add(true)
    # ページ総数更新
    PageValue.updatePageCount()
    # ページング
    Paging.initPaging()


  if existedCache
    # 描画
    PageValue.adjustInstanceAndEventOnThisPage()
    WorktableCommon.drawAllItemFromEventPageValue(_callback)
  else
    LocalStorage.clearWorktable()
    Timeline.refreshAllTimeline()
    _callback.call(@)

