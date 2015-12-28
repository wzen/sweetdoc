class Paging

  # 初期化処理
  @initPaging: ->
    @createPageSelectMenu()

  # 選択メニュー作成
  @createPageSelectMenu: ->
    self = @

    pageCount = PageValue.getPageCount()
    root = $("##{Constant.Paging.NAV_ROOT_ID}")
    selectRoot = $(".#{Constant.Paging.NAV_SELECT_ROOT_CLASS}", root)

    # ページ選択メニュー
    menu = "<li><a class='#{Constant.Paging.NAV_MENU_PAGE_CLASS} menu-item'>#{Constant.Paging.NAV_MENU_PAGE_NAME}</a></li>"
    divider = "<li class='divider'></li>"
    newPageMenu = "<li><a class='#{Constant.Paging.NAV_MENU_ADDPAGE_CLASS} menu-item'>Add page</a></li>"
    newForkMenu = "<li><a class='#{Constant.Paging.NAV_MENU_ADDFORK_CLASS} menu-item'>Add fork</a></li>"
    pageMenu = ''
    for i in [1..pageCount]
      navPageClass = Constant.Paging.NAV_MENU_PAGE_CLASS.replace('@pagenum', i)
      navPageName = Constant.Paging.NAV_MENU_PAGE_NAME.replace('@pagenum', i)

      # サブ選択メニュー
      forkCount = PageValue.getForkCount(i)
      forkNum = PageValue.getForkNum(i)
      active = if forkNum == PageValue.Key.EF_MASTER_FORKNUM then 'class="active"' else ''
      subMenu = "<li #{active}><a class='#{navPageClass} menu-item '>Master</a></li>"
      if forkCount > 0
        for j in [1..forkCount]
          navForkClass = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', j)
          navForkName = Constant.Paging.NAV_MENU_FORK_NAME.replace('@forknum', j)
          subActive = if j == forkNum then 'class="active"' else ''
          subMenu += """
            <li #{subActive}><a class='#{navPageClass} #{navForkClass} menu-item '>#{navForkName}</a></li>
          """
      subMenu += divider + newForkMenu

      pageMenu += """
            <li class="dropdown-submenu">
                <a>#{navPageName}</a>
                <ul class="dropdown-menu">
                    #{subMenu}
                </ul>
            </li>
        """
    pageMenu += divider + newPageMenu
    selectRoot.children().remove()
    $(pageMenu).appendTo(selectRoot)

    # 現在のページ
    nowMenuName = Constant.Paging.NAV_MENU_PAGE_NAME.replace('@pagenum', PageValue.getPageNum())
    if PageValue.getForkNum() > 0
      nowMenuName += " - (#{Constant.Paging.NAV_MENU_FORK_NAME.replace('@forknum', PageValue.getForkNum())})"
    $(".#{Constant.Paging.NAV_SELECTED_CLASS}", root).html(nowMenuName)

    # イベント設定
    selectRoot.find(".menu-item").off('click')
    selectRoot.find(".menu-item").on('click', ->
      pagePrefix = Constant.Paging.NAV_MENU_PAGE_CLASS.replace('@pagenum', '')
      forkPrefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '')
      pageNum = null
      forkNum = PageValue.Key.EF_MASTER_FORKNUM
      classList = @.classList
      classList.forEach((c) ->
        if c.indexOf(pagePrefix) >= 0
          pageNum = parseInt(c.replace(pagePrefix, ''))
        else if c.indexOf(forkPrefix) >= 0
          forkNum = parseInt(c.replace(forkPrefix, ''))
      )
      if pageNum?
        self.selectPage(pageNum, forkNum)
    )

    selectRoot.find(".#{Constant.Paging.NAV_MENU_ADDPAGE_CLASS}", root).off('click')
    selectRoot.find(".#{Constant.Paging.NAV_MENU_ADDPAGE_CLASS}", root).on('click', ->
      self.createNewPage()
    )
    selectRoot.find(".#{Constant.Paging.NAV_MENU_ADDFORK_CLASS}", root).off('click')
    selectRoot.find(".#{Constant.Paging.NAV_MENU_ADDFORK_CLASS}", root).on('click', ->
      self.createNewFork()
    )

  # 表示ページ切り替え
  # @param [Integer] pageNum 変更ページ番号
  @switchSectionDisplay: (pageNum) ->
    $("##{Constant.Paging.ROOT_ID}").find(".section").hide()
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
    section.show()

  # ページ追加作成
  @createNewPage: ->
    self = @

    # プレビュー停止
    WorktableCommon.stopAllEventPreview( ->
      beforePageNum = PageValue.getPageNum()
      if window.debug
        console.log('[createNewPage] beforePageNum:' + beforePageNum)

      Sidebar.closeSidebar()
      # WebStorageのアイテム&イベント情報を消去
      LocalStorage.clearWorktableWithoutSetting()
      EventConfig.removeAllConfig()

      # Mainコンテナ作成
      created = Common.createdMainContainerIfNeeded(PageValue.getPageCount() + 1)
      # ページ番号更新
      PageValue.setPageNum(PageValue.getPageCount() + 1)
      # 新規コンテナ初期化
      WorktableCommon.initMainContainer()
      PageValue.adjustInstanceAndEventOnPage()
      WorktableCommon.createAllInstanceAndDrawFromInstancePageValue( ->
        # 共通イベントのインスタンス作成
        WorktableCommon.createCommonEventInstancesIfNeeded()
        # 作成ページのモード設定
        WorktableCommon.changeMode(window.mode)
        # タイムライン更新
        Timeline.refreshAllTimeline()
        # ページ表示変更
        className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
        newSection = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
        newSection.show()
        className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
        oldSection = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
        oldSection.hide()
        Common.removeAllItem(beforePageNum)
        Timeline.refreshAllTimeline()
        # ページ総数 & フォーク総数の更新
        PageValue.setEventPageValue(PageValue.Key.eventCount(), 0)
        PageValue.updatePageCount()
        if created
          # 履歴に画面初期時状態を保存
          OperationHistory.add(true)
        # キャッシュ保存
        LocalStorage.saveAllPageValues()
        # 選択メニューの更新
        self.createPageSelectMenu()
      )
    )

  # ページ選択
  # @param [Integer] selectedNum 選択ページ番号
  # @param [Integer] selectedNum 選択フォーク番号
  @selectPage: (selectedPageNum, selectedForkNum = PageValue.Key.EF_MASTER_FORKNUM) ->
    self = @

    if selectedPageNum == PageValue.getPageNum()
      if selectedForkNum == PageValue.getForkNum()
        # 同じページ & 同じフォークの場合は変更しない
        return
      else
        @selectFork(selectedForkNum, ->
          # タイムライン更新
          Timeline.refreshAllTimeline()
          # キャッシュ保存
          LocalStorage.saveAllPageValues()
          # 選択メニューの更新
          self.createPageSelectMenu()
        )
        return

    # プレビュー停止
    WorktableCommon.stopAllEventPreview( ->
      if window.debug
        console.log('[selectPage] selectedNum:' + selectedPageNum)
      if selectedPageNum <= 0
        return
      pageCount = PageValue.getPageCount()
      if selectedPageNum < 0 || selectedPageNum > pageCount
        return
      beforePageNum = PageValue.getPageNum()
      if window.debug
        console.log('[selectPage] beforePageNum:' + beforePageNum)
      Sidebar.closeSidebar()
      # WebStorageのアイテム&イベント情報を消去
      LocalStorage.clearWorktableWithoutSetting()
      EventConfig.removeAllConfig()
      # Mainコンテナ作成
      created = Common.createdMainContainerIfNeeded(selectedPageNum, beforePageNum > selectedPageNum)
      # ページングクラス作成
      pageFlip = new PageFlip(beforePageNum, selectedPageNum)
      # ページ番号更新
      PageValue.setPageNum(selectedPageNum)
      # 新規コンテナ初期化
      WorktableCommon.initMainContainer()
      PageValue.adjustInstanceAndEventOnPage()
      WorktableCommon.createAllInstanceAndDrawFromInstancePageValue( ->
        # フォーク内容反映
        Paging.selectFork(selectedForkNum, ->
          # ページ変更後のモード設定
          WorktableCommon.changeMode(window.mode, selectedPageNum)
          # タイムライン更新
          Timeline.refreshAllTimeline()

          # ページめくりアニメーション
          pageFlip.startRender( ->
            # 隠したビューを非表示にする
            className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
            section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
            section.hide()
            if window.debug
              console.log('[selectPage] deleted pageNum:' + beforePageNum)
            # 隠したビューのアイテムを削除
            Common.removeAllItem(beforePageNum)
            #Timeline.refreshAllTimeline()
            if created
              # 履歴に画面初期時状態を保存
              OperationHistory.add(true)
            # キャッシュ保存
            LocalStorage.saveAllPageValues()
            # 選択メニューの更新
            self.createPageSelectMenu()
          )
        )
      )
    )

  # フォーク追加作成
  @createNewFork: ->
    self = @

    # プレビュー停止
    WorktableCommon.stopAllEventPreview( ->
      # フォーク番号更新
      PageValue.setForkNum(PageValue.getForkCount() + 1)
      # フォーク総数更新
      PageValue.setEventPageValue(PageValue.Key.eventCount(), 0)
      PageValue.updateForkCount()
      # 履歴に画面初期時状態を保存
      OperationHistory.add(true)
      # キャッシュ保存
      LocalStorage.saveAllPageValues()
      # 選択メニューの更新
      self.createPageSelectMenu()
      # タイムライン更新
      Timeline.refreshAllTimeline()
    )

  # フォーク選択
  # @param [Integer] selectedForkNum 選択フォーク番号
  # @param [Function] コールバック
  @selectFork: (selectedForkNum, callback = null) ->
    if !selectedForkNum? || selectedForkNum == PageValue.getForkNum()
      # フォーク番号が同じ場合は処理なし
      if callback?
        callback()

    # プレビュー停止
    WorktableCommon.stopAllEventPreview( ->
      # フォーク番号更新
      PageValue.setForkNum(selectedForkNum)
      if selectedForkNum == PageValue.Key.EF_MASTER_FORKNUM
        # Masterに変更する場合
        # とりあえず何もしない
        if callback?
          callback()
      else
        # Forkに変更

        # フォークのアイテムを描画
        WorktableCommon.createAllInstanceAndDrawFromInstancePageValue( ->
          if callback?
            callback()
        )
    )