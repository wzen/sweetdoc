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
    menu = "<li><a class='#{Constant.Paging.NAV_MENU_CLASS} menu-item'>#{Constant.Paging.NAV_MENU_NAME}</a></li>"
    divider = "<li class='divider'></li>"
    newPageMenu = "<li><a class='#{Constant.Paging.NAV_MENU_ADDPAGE_CLASS} menu-item'>Add next page</a></li>"
    pageMenu = ''
    for i in [1..pageCount]
      navMenuClass = Constant.Paging.NAV_MENU_CLASS.replace('@pagenum', i)
      navMenuName = Constant.Paging.NAV_MENU_NAME.replace('@pagenum', i)
      active = if i == PageValue.getPageNum() then 'class="active"' else ''
      pageMenu += "<li #{active}><a class='#{navMenuClass} menu-item '>#{navMenuName}</a></li>"
    pageMenu += divider
    pageMenu += newPageMenu
    selectRoot.children().remove()
    $(pageMenu).appendTo(selectRoot)

    # 現在のページ
    nowMenuName = Constant.Paging.NAV_MENU_NAME.replace('@pagenum', PageValue.getPageNum())
    $(".#{Constant.Paging.NAV_SELECTED_CLASS}", root).html(nowMenuName)

    # イベント設定
    selectRoot.find(".menu-item").off('click')
    selectRoot.find(".menu-item").on('click', ->
      prefix = Constant.Paging.NAV_MENU_CLASS.replace('@pagenum', '')
      classList = @.classList
      classList.forEach((c) ->
        if c.indexOf(prefix) >= 0
          pageNum = parseInt(c.replace(prefix, ''))
          self.selectPage(pageNum)
          return false
      )
    )
    selectRoot.find(".#{Constant.Paging.NAV_MENU_ADDPAGE_CLASS}", root).off('click')
    selectRoot.find(".#{Constant.Paging.NAV_MENU_ADDPAGE_CLASS}", root).on('click', ->
      self.createNewPage()
    )

  # 表示ページ切り替え
  # @param [Integer] pageNum 変更ページ番号
  @switchSectionDisplay: (pageNum) ->
    $("##{Constant.Paging.ROOT_ID}").find(".section").css('display', 'none')
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
    section.css('display', '')

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
      created = Common.createdMainContainerIfNeeded(beforePageNum + 1)
      # ページングクラス作成
      pageFlip = new PageFlip(beforePageNum, beforePageNum + 1)
      # ページ番号更新
      PageValue.setPageNum(PageValue.getPageCount() + 1)
      # 新規コンテナ初期化
      WorktableCommon.initMainContainer()
      PageValue.adjustInstanceAndEventOnPage()
      WorktableCommon.drawAllItemFromInstancePageValue( ->
        # ページング
        pageFlip.startRender( ->
          className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
          section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
          section.css('display', 'none')
          Common.removeAllItem(beforePageNum)
          Timeline.refreshAllTimeline()
          # ページ総数の更新
          PageValue.setEventPageValue(PageValue.Key.eventCount(), 0)
          # フォーク総数の更新
          PageValue.setEventPageValue(PageValue.Key.eventFork(), 0)
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
    )

  # 選択
  # @param [Integer] selectedNum 選択ページ番号
  @selectPage: (selectedNum) ->
    self = @
    # プレビュー停止
    WorktableCommon.stopAllEventPreview( ->
      if window.debug
        console.log('[selectPage] selectedNum:' + selectedNum)
      if selectedNum <= 0
        return
      pageCount = PageValue.getPageCount()
      if selectedNum < 0 || selectedNum > pageCount
        return
      beforePageNum = PageValue.getPageNum()
      if window.debug
        console.log('[selectPage] beforePageNum:' + beforePageNum)
      Sidebar.closeSidebar()
      # WebStorageのアイテム&イベント情報を消去
      LocalStorage.clearWorktableWithoutSetting()
      EventConfig.removeAllConfig()
      # Mainコンテナ作成
      created = Common.createdMainContainerIfNeeded(selectedNum, beforePageNum > selectedNum)
      # ページングクラス作成
      pageFlip = new PageFlip(beforePageNum, selectedNum)
      # ページ番号更新
      PageValue.setPageNum(selectedNum)
      # 新規コンテナ初期化
      WorktableCommon.initMainContainer()
      PageValue.adjustInstanceAndEventOnPage()
      WorktableCommon.drawAllItemFromInstancePageValue( ->
        pageFlip.startRender( ->
          # 隠したビューを非表示にする
          className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
          section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
          section.css('display', 'none')
          if window.debug
            console.log('[selectPage] deleted pageNum:' + beforePageNum)
          # 隠したビューのアイテムを削除
          Common.removeAllItem(beforePageNum)
          Timeline.refreshAllTimeline()
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

