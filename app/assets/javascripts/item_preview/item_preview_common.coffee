class ItemPreviewCommon
  if gon?
    constant = gon.const
    @MAIN_TEMP_WORKTABLE_CLASS = constant.ElementAttribute.MAIN_TEMP_WORKTABLE_CLASS
    @MAIN_TEMP_RUN_CLASS = constant.ElementAttribute.MAIN_TEMP_RUN_CLASS

  # Mainコンテナを作成
  # @return [Boolean] ページを作成したか
  @createdMainContainerIfNeeded: ->
    root = $("##{Constant.Paging.ROOT_ID}")
    markClass = ''
    if isWorkTable
      markClass = 'ws'
    else
      markClass = 'run'
    container = $(".#{markClass}", root)
    sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', 1)
    pageSection = $(".#{sectionClass}", root)
    if !container? || container.length == 0
      # 現在のContainerを削除
      root.children('.section').remove()
      # Tempからコピー
      if isWorkTable
        temp = $(".#{ItemPreviewCommon.MAIN_TEMP_WORKTABLE_CLASS}:first").children(':first').clone(true)
      else
        temp = $(".#{ItemPreviewCommon.MAIN_TEMP_RUN_CLASS}:first").children(':first').clone(true)
      temp = $(temp).wrap("<div class='#{sectionClass} #{markClass} section'></div>").parent()
      root.append(temp)
      return true
    else
      return false

  # Mainコンテナ初期化
  @initMainContainerAsWorktable = (callback = null) ->
    # 定数 & レイアウト & イベント系変数の初期化
    CommonVar.worktableCommonVar()
    Common.updateCanvasSize()
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
    # スクロールサイズ
    window.scrollInsideWrapper.width(window.scrollViewSize)
    window.scrollInsideWrapper.height(window.scrollViewSize)
    window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1))
    # スクロールイベント設定
    window.scrollContents.off('scroll').on('scroll', (e) ->
      e.preventDefault()
      top = window.scrollContents.scrollTop()
      left = window.scrollContents.scrollLeft()
      if jQuery(":hover")[jQuery(':hover').length - 1] == window.scrollInside.get(0)
        # 手動スクロールした場合のみメッセージ表示
        FloatView.show(FloatView.scrollMessage(top, left), FloatView.Type.DISPLAY_POSITION)
        Common.saveDisplayPosition(top, left, false, ->
          FloatView.hide()
        )
    )
    # ドラッグ描画イベント
    ItemPreviewHandwrite.initHandwrite()
    # 環境設定
    Common.applyEnvironmentFromPagevalue()
    # Mainビュー高さ設定
    WorktableCommon.updateMainViewSize()

    if callback?
      callback()

  @initMainContainerAsRun = (callback = null) ->
    CommonVar.runCommonVar()
    RunCommon.initView()
    RunCommon.initHandleScrollPoint()
    RunCommon.setupScrollEvent()
    Common.applyEnvironmentFromPagevalue()
    # ProjectWrapperの幅、高さは親に合わせる
    $('#project_wrapper').removeAttr('style')
    if callback?
      callback()

  # 初期化
  @initAfterLoadItem = ->
    # 描画モード
    if window.isCodingDebug
      window.selectItemMenu = window[Constant.ITEM_CODING_TEMP_CLASS_NAME].CLASS_DIST_TOKEN
    else
      itemClassName = $(".#{Constant.ITEM_GALLERY_ITEM_CLASSNAME}:first").val()
      window.selectItemMenu = window[itemClassName].CLASS_DIST_TOKEN
    WorktableCommon.changeMode(Constant.Mode.DRAW)
    @initEvent()
    Navbar.initItemPreviewNavbar()

  # イベント設定
  @initEvent = ->
    # ボタン
    $('#run_btn_wrapper .run_btn').off('click').on('click', (e) =>
      e.preventDefault()
      @switchRun()
    )
    $('#stop_btn_wrapper .stop_btn').off('click').on('click', (e) =>
      e.preventDefault()
      @switchWorktable()
    )

  # WS状態に変更
  @switchWorktable = (callback = null) ->
    if !window.isWorkTable
      window.isWorkTable = true
      window.initDone = false
      RunCommon.shutdown()
      @createdMainContainerIfNeeded()
      @initMainContainerAsWorktable( =>
        WorktableCommon.createAllInstanceAndDrawFromInstancePageValue( =>
          window.initDone = true
          # コンフィグのイベントを全て有効化
          $('#sidebar').find('.cover_touch_overlay').remove()
          WorktableCommon.changeMode(Constant.Mode.EDIT)
          $('#run_btn_wrapper').show()
          $('#stop_btn_wrapper').hide()
          if callback?
            callback()
        )
      )

  # Run状態に変更
  @switchRun = (callback = null) ->
    if window.isWorkTable
      window.isWorkTable = false
      window.initDone = false
      # プロジェクトサイズ設定
      width = $('#screen_wrapper').width()
      height = $('#screen_wrapper').height()
      Project.initProjectValue('ItemPreviewRun', width, height)
      @createdMainContainerIfNeeded()
      @initMainContainerAsRun( =>
        window.eventAction = null
        window.runPage = true
        # コンフィグのイベントを全て無効化
        @coverOverlayOnConfig()
        # イベント初期化
        RunCommon.initEventAction()
        # 初期化終了
        window.initDone = true
        $('#run_btn_wrapper').hide()
        $('#stop_btn_wrapper').show()
        if callback?
          callback()
      )

  @coverOverlayOnConfig = ->
    tabContent = $('#myTabContent')
    nav = $('#tab-config ul.nav')
    top = -(nav.height())
    style = "top:#{top}px;left:0;width:#{tabContent.width()}px;height:#{tabContent.height() + nav.height()}px;"
    tabContent.append("<div class='cover_touch_overlay' style='#{style}'></div>")
    $('.cover_touch_overlay').off('click').on('click', (e) ->
      e.preventDefault()
      return
    )

  @showUploadItemConfirm = ->
    target = '_uploaditem'
    window.open("about:blank", target)
    document.upload_item_form.target = target
    document.upload_item_form.submit()

  @showAddItemConfirm = ->
