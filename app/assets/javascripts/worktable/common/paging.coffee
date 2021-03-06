class Paging

  # 初期化処理
  @initPaging: ->
    @createPageSelectMenu()

  # 選択メニュー作成
  @createPageSelectMenu: ->
    pageCount = PageValue.getPageCount()
    root = $("##{constant.Paging.NAV_ROOT_ID}")
    selectRoot = $(".#{constant.Paging.NAV_SELECT_ROOT_CLASS}", root)

    # ページ選択メニュー
    divider = "<li class='divider'></li>"
    newPageMenu = "<li><a class='#{Constant.Paging.NAV_MENU_ADDPAGE_CLASS} menu-item'>#{I18n.t('header_menu.page.add_page')}</a></li>"
    newForkMenu = "<li><a class='#{Constant.Paging.NAV_MENU_ADDFORK_CLASS} menu-item'>#{I18n.t('header_menu.page.add_fork')}</a></li>"
    pageMenu = ''
    for i in [1..pageCount]
      navPageClass = Constant.Paging.NAV_MENU_PAGE_CLASS.replace('@pagenum', i)
      navPageName = "#{I18n.t('header_menu.page.page')} #{i}"
      deletePageMenu = "<li><a class='#{navPageClass} #{Constant.Paging.NAV_MENU_DELETEPAGE_CLASS} menu-item'>#{I18n.t('header_menu.page.delete_page')}</a></li>"

      # サブ選択メニュー
      forkCount = PageValue.getForkCount(i)
      forkNum = PageValue.getForkNum(i)
      active = if forkNum == PageValue.Key.EF_MASTER_FORKNUM then 'class="active"' else ''
      subMenu = "<li #{active}><a class='#{navPageClass} menu-item '>#{I18n.t('header_menu.page.master')}</a></li>"
      if forkCount > 0
        for j in [1..forkCount]
          navForkClass = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', j)
          navForkName = "#{I18n.t('header_menu.page.fork')} #{j}"
          subActive = if j == forkNum then 'class="active"' else ''
          subMenu += """
            <li #{subActive}><a class='#{navPageClass} #{navForkClass} menu-item '>#{navForkName}</a></li>
          """
      if i == PageValue.getPageNum()
        subMenu += divider + newForkMenu
      if i > 1
        # ページ１以外は削除メニュー追加
        subMenu += divider + deletePageMenu
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
    nowMenuName = "#{I18n.t('header_menu.page.page')} #{PageValue.getPageNum()}"
    if PageValue.getForkNum() > 0
      name = "#{I18n.t('header_menu.page.fork')} #{PageValue.getForkNum()}"
      nowMenuName += " - (#{name})"
    $(".#{constant.Paging.NAV_SELECTED_CLASS}", root).html(nowMenuName)

    # イベント設定
    selectRoot.find(".menu-item").off('click').on('click', (e) =>
      Common.hideModalView(true)
      Common.showModalFlashMessage('Changing...')
      pagePrefix = Constant.Paging.NAV_MENU_PAGE_CLASS.replace('@pagenum', '')
      forkPrefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '')
      pageNum = null
      forkNum = PageValue.Key.EF_MASTER_FORKNUM
      classList = $(e.target).attr('class').split(' ')
      classList.forEach((c) ->
        if c.indexOf(pagePrefix) >= 0
          pageNum = parseInt(c.replace(pagePrefix, ''))
        else if c.indexOf(forkPrefix) >= 0
          forkNum = parseInt(c.replace(forkPrefix, ''))
      )
      if pageNum?
        @selectPage(pageNum, forkNum)
      else
        Common.hideModalView()
    )

    selectRoot.find(".#{Constant.Paging.NAV_MENU_ADDPAGE_CLASS}", root).off('click').on('click', =>
      @createNewPage()
    )
    selectRoot.find(".#{Constant.Paging.NAV_MENU_ADDFORK_CLASS}", root).off('click').on('click', =>
      @createNewFork()
    )
    selectRoot.find(".#{Constant.Paging.NAV_MENU_DELETEPAGE_CLASS}", root).off('click').on('click', (e) =>
      if window.confirm(I18n.t('message.dialog.delete_page'))
        pagePrefix = Constant.Paging.NAV_MENU_PAGE_CLASS.replace('@pagenum', '')
        page = $.grep($(e.target).attr('class').split(' '), (n)->
          n.indexOf(pagePrefix) >= 0
        )[0]
        pageNum = parseInt(page.replace(pagePrefix, ''))
        @removePage(pageNum)
    )

  # 表示ページ切り替え
  # @param [Integer] pageNum 変更ページ番号
  @switchSectionDisplay: (pageNum) ->
    $("##{constant.Paging.ROOT_ID}").find(".section").hide()
    className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    section = $("##{constant.Paging.ROOT_ID}").find(".#{className}:first")
    section.show()

  # ページ追加作成
  @createNewPage: ->
    Common.hideModalView(true)
    Common.showModalFlashMessage('Creating...')
    beforePageNum = PageValue.getPageNum()
    if window.debug
      console.log('[createNewPage] beforePageNum:' + beforePageNum)

    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    window.lStorage.clearWorktableWithoutSetting()
    EventConfig.removeAllConfig()
    # Mainコンテナ作成
    created = Common.createdMainContainerIfNeeded(PageValue.getPageCount() + 1)
    # ページ番号更新
    PageValue.setPageNum(PageValue.getPageCount() + 1)
    # 新規コンテナ初期化
    WorktableCommon.initMainContainer()
    PageValue.adjustInstanceAndEventOnPage()
    WorktableCommon.createAllInstanceAndDrawFromInstancePageValue( =>
      # 共通イベントのインスタンス作成
      WorktableCommon.createCommonEventInstancesOnThisPageIfNeeded()
      # 作成ページのモード設定
      WorktableCommon.changeMode(window.mode)
      # タイムライン更新
      Timeline.refreshAllTimeline()
      # ページ表示変更
      className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
      newSection = $("##{constant.Paging.ROOT_ID}").find(".#{className}:first")
      newSection.show()
      className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
      oldSection = $("##{constant.Paging.ROOT_ID}").find(".#{className}:first")
      oldSection.hide()
      Common.removeAllItem(beforePageNum)
      # ページ総数 & フォーク総数の更新
      PageValue.setEventPageValue(PageValue.Key.eventCount(), 0)
      PageValue.updatePageCount()
      # 画面倍率は作成前ページと同じにする
      WorktableCommon.setWorktableViewScale(WorktableCommon.getWorktableViewScale(beforePageNum), true)
      # 表示位置を戻す
      WorktableCommon.initScrollContentsPosition()
      if created
        # 履歴に画面初期時状態を保存
        OperationHistory.add(true)
      # キャッシュ保存
      window.lStorage.saveAllPageValues()
      # 選択メニューの更新
      @createPageSelectMenu()
      # モーダルを削除
      Common.hideModalView()
    )

  # ページ選択
  # @param [Integer] selectedNum 選択ページ番号
  # @param [Integer] selectedNum 選択フォーク番号
  @selectPage: (selectedPageNum, selectedForkNum = PageValue.Key.EF_MASTER_FORKNUM, callback = null) ->
    if selectedPageNum == PageValue.getPageNum()
      if selectedForkNum == PageValue.getForkNum()
        # 同じページ & 同じフォークの場合は変更しない
        Common.hideModalView()
        if callback?
          callback()
        return
      else
        @selectFork(selectedForkNum, =>
          # タイムライン更新
          Timeline.refreshAllTimeline()
          # キャッシュ保存
          window.lStorage.saveAllPageValues()
          # 選択メニューの更新
          @createPageSelectMenu()
          # モーダルを削除
          Common.hideModalView()
          if callback?
            callback()
        )
        return
    if window.debug
      console.log('[selectPage] selectedNum:' + selectedPageNum)
    if selectedPageNum <= 0
      if callback?
        callback()
      return
    pageCount = PageValue.getPageCount()
    if selectedPageNum < 0 || selectedPageNum > pageCount
      if callback?
        callback()
      return
    beforePageNum = PageValue.getPageNum()
    if window.debug
      console.log('[selectPage] beforePageNum:' + beforePageNum)
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    window.lStorage.clearWorktableWithoutSetting()
    EventConfig.removeAllConfig()
    # Mainコンテナ作成
    created = Common.createdMainContainerIfNeeded(selectedPageNum, false)
    # ページ番号更新
    PageValue.setPageNum(selectedPageNum)
    # 新規コンテナ初期化
    WorktableCommon.initMainContainer()
    PageValue.adjustInstanceAndEventOnPage()
    WorktableCommon.createAllInstanceAndDrawFromInstancePageValue( =>
      # フォーク内容反映
      Paging.selectFork(selectedForkNum, =>
        # ページ変更後のモード設定
        WorktableCommon.changeMode(window.mode, selectedPageNum)
        # タイムライン更新
        Timeline.refreshAllTimeline()
        className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', selectedPageNum)
        newSection = $("##{constant.Paging.ROOT_ID}").find(".#{className}:first")
        newSection.show()
        # 隠したビューを非表示にする
        className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
        oldSection = $("##{constant.Paging.ROOT_ID}").find(".#{className}:first")
        oldSection.hide()
        if window.debug
          console.log('[selectPage] deleted pageNum:' + beforePageNum)
        # 隠したビューのアイテムを削除(インスタンスは消さない)
        Common.removeAllItem(beforePageNum, false)
        if created
          # 履歴に画面初期時状態を保存
          OperationHistory.add(true)
        # キャッシュ保存
        window.lStorage.saveAllPageValues()
        # 選択メニューの更新
        @createPageSelectMenu()
        # モーダルを削除
        Common.hideModalView()
        if callback?
          callback()
      )
    )

  # フォーク追加作成
  @createNewFork: ->
    # フォーク番号更新
    PageValue.setForkNum(PageValue.getForkCount() + 1)
    # フォーク総数更新
    PageValue.setEventPageValue(PageValue.Key.eventCount(), 0)
    PageValue.updateForkCount()
    # 履歴に画面初期時状態を保存
    OperationHistory.add(true)
    # キャッシュ保存
    window.lStorage.saveAllPageValues()
    # 選択メニューの更新
    @createPageSelectMenu()
    # タイムライン更新
    Timeline.refreshAllTimeline()

  # フォーク選択
  # @param [Integer] selectedForkNum 選択フォーク番号
  # @param [Function] コールバック
  @selectFork: (selectedForkNum, callback = null) ->
    if !selectedForkNum? || selectedForkNum == PageValue.getForkNum()
      # フォーク番号が同じ場合は処理なし
      if callback?
        callback()
      return

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

  @removePage: (pageNum, callback = null) ->
    if pageNum <= 1
      # 1ページ目は消去しない
      if callback?
        callback()
      return

    _removePage = (pageNum) ->
      # ページを削除
      WorktableCommon.removePage(pageNum, =>
        window.lStorage.saveAllPageValues()
        # 選択メニューの更新
        @createPageSelectMenu()
        if callback?
          callback()
      )

    if pageNum == PageValue.getPageNum()
      # 現在のページの場合は前ページに変更
      @selectPage(pageNum - 1, PageValue.Key.EF_MASTER_FORKNUM, =>
        _removePage.call(@, pageNum)
      )
    else
      _removePage.call(@, pageNum)

  @removeFork: (forkNum, callback = null) ->
    # TODO: 実装する
#    _removeFork = ->
#
#    if forkNum == PageValue.getForkNum()
#      @selectFork(selectedForkNum, callback = null) ->

