$ ->
  $('.worktable.index').ready ->
    window.isItemPreview = false
    window.initDone = false

    # ブラウザ対応チェック
    if !Common.checkBlowserEnvironment()
      alert('ブラウザ非対応です。')
      return

    $.ajaxSetup({
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      }
    )

    # キャッシュチェック
    existedCache = !LocalStorage.isOverWorktableSaveTimeLimit()
    if existedCache
      # キャッシュが存在する場合アイテム描画
      LocalStorage.loadAllPageValues()

    # 変数初期化
    CommonVar.initVarWhenLoadedView()
    CommonVar.initCommonVar()

    _callback = ->
      # 履歴に画面初期時を状態を保存
      OperationHistory.add(true)
      # ページ総数更新
      PageValue.updatePageCount()
      # フォーク総数更新
      PageValue.updateForkCount()
      # ページング
      Paging.initPaging()

    if existedCache && PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)?
      # プロジェクト作成済みのキャッシュが存在する場合
      # Mainコンテナ作成
      Common.createdMainContainerIfNeeded(PageValue.getPageNum())
      # コンテナ初期化
      WorktableCommon.initMainContainer()
      # リサイズイベント
      Common.initResize(WorktableCommon.resizeEvent)
      PageValue.adjustInstanceAndEventOnPage()
      WorktableCommon.createAllInstanceAndDrawFromInstancePageValue( ->
        # 共通イベントのインスタンス作成
        WorktableCommon.createCommonEventInstancesIfNeeded()
        _callback.call(@)
        # 初期化終了
        window.initDone = true
      )
      # タイムライン更新
      Timeline.refreshAllTimeline()
    else
      LocalStorage.clearWorktable()
      Timeline.refreshAllTimeline()
      _callback.call(@)
      # プロジェクトモーダル表示
      Common.showModalView(Constant.ModalViewType.INIT_PROJECT, false, Project.initProjectModal)
      # モーダル用にリサイズイベントを設定
      Common.initResize()
