$ ->
  $('.worktable.index').ready ->
    window.isItemPreview = false
    window.initDone = false

    # ブラウザ対応チェック
    if !Common.checkBlowserEnvironment()
      Common.showModalView(constant.ModalViewType.ENVIRONMENT_NOT_SUPPORT, false)
      return

    $.ajaxSetup({
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      }
    )

    # キャッシュチェック
    loadWorktableFromCache = WorktableCommon.checkLoadWorktableFromCache()
    if loadWorktableFromCache
      # キャッシュが存在する場合PageValueに読み込み
      window.lStorage.loadAllPageValues()
    # 変数初期化
    CommonVar.initVarWhenLoadedView()
    CommonVar.initCommonVar()
    # ナビバーイベント
    Navbar.initWorktableNavbar()
    if loadWorktableFromCache
      # メッセージ表示
      Common.showModalFlashMessage('Loading cache')
      # キャッシュが存在する場合
      # Mainコンテナ作成
      Common.createdMainContainerIfNeeded(PageValue.getPageNum())
      # コンテナ初期化
      WorktableCommon.initMainContainer()
      # リサイズイベント
      Common.initResize(WorktableCommon.resizeEvent)
      PageValue.adjustInstanceAndEventOnPage()
      WorktableCommon.createAllInstanceAndDrawFromInstancePageValue( ->
        # 共通イベントのインスタンス作成
        WorktableCommon.createCommonEventInstancesOnThisPageIfNeeded()
        # スクロール位置更新
        WorktableCommon.initScrollContentsPosition()
        # 履歴に画面初期時を状態を保存
        OperationHistory.add(true)
        # ナビバーをプロジェクト作成後状態に
        Navbar.switchWorktableNavbarWhenProjectCreated(true)
        # モーダルを削除
        Common.hideModalView()
        # 初期化終了
        window.initDone = true
      )
      # タイムライン更新
      Timeline.refreshAllTimeline()
    else
      window.lStorage.clearWorktable()
      # タイムライン更新
      Timeline.refreshAllTimeline()
      # 履歴に画面初期時を状態を保存
      OperationHistory.add(true)
      # プロジェクトモーダル表示
      Common.showModalView(constant.ModalViewType.INIT_PROJECT, true, Project.initProjectModal)
      # モーダル用にリサイズイベントを設定
      Common.initResize()
