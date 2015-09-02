class Paging

  # 初期化処理
  @initPaging: ->
    @createPageSelectMenu()

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
      active = if i == window.pageNum then 'class="active"' else ''
      pageMenu += "<li #{active}><a class='#{navMenuClass} menu-item '>#{navMenuName}</a></li>"
    pageMenu += divider
    pageMenu += newPageMenu
    selectRoot.children().remove()
    $(pageMenu).appendTo(selectRoot)

    # 現在のページ
    nowMenuName = Constant.Paging.NAV_MENU_NAME.replace('@pagenum', window.pageNum)
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

  # ページ追加作成
  @createNewPage: ->
    self = @

    beforePageNum = window.pageNum

    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    lstorage = localStorage
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_INSTANCE_PAGEVALUES)
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_EVENT_PAGEVALUES)
    #Common.clearAllEventChange( ->
    EventConfig.removeAllConfig()
    window.pageNum += 1
    # Mainコンテナ作成
    Common.createdMainContainerIfNeeded(window.pageNum)
    # 新規コンテナ初期化
    Worktable.initMainContainer()
    PageValue.adjustInstanceAndEventOnThisPage()
    WorktableCommon.drawAllItemFromEventPageValue( =>
      # ページング
      pageFlip = new PageFlip(beforePageNum)
      pageFlip.startRender(PageFlip.DIRECTION.FORWARD, ->
        className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
        section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
        section.css('display', 'none')
        WorktableCommon.removeAllItem(beforePageNum)

        Worktable.initMainContainer()
        Timeline.refreshAllTimeline()
        # ページ総数の更新
        PageValue.setEventPageValue(PageValue.Key.eventCount(), 0)
        PageValue.updatePageCount()
        # 選択メニューの更新
        self.createPageSelectMenu()
      )
    )
    #)

  # 選択
  @selectPage: (selectedNum) ->
    self = @

    if selectedNum <= 0
      return

    beforePageNum = window.pageNum

    pageCount = PageValue.getPageCount()
    if selectedNum < 0 || selectedNum > pageCount
      return

    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    lstorage = localStorage
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_INSTANCE_PAGEVALUES)
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_EVENT_PAGEVALUES)
    #Common.clearAllEventChange( ->
    #Common.removeMainContainer(beforePageNum)
    #WorktableCommon.removeAllItem()
    EventConfig.removeAllConfig()

    # Mainコンテナ作成
    Common.createdMainContainerIfNeeded(selectedNum, beforePageNum > selectedNum)

    # 新規表示するコンテナの初期化
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', selectedNum)
    section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
    section.css('display', '')
    window.pageNum = selectedNum
    Worktable.initMainContainer()
    PageValue.adjustInstanceAndEventOnThisPage()
    WorktableCommon.drawAllItemFromEventPageValue( =>
      # ページング
      direction = if beforePageNum < window.pageNum then PageFlip.DIRECTION.FORWARD else PageFlip.DIRECTION.BACK
      pn = if beforePageNum < window.pageNum then beforePageNum else window.pageNum
      pageFlip = new PageFlip(pn)
      pageFlip.startRender(direction, ->
        # 隠したビューを非表示にする
        className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
        section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
        section.css('display', 'none')
        # 隠したビューのアイテムを削除
        WorktableCommon.removeAllItem(beforePageNum)

        Worktable.initMainContainer()
        Timeline.refreshAllTimeline()
        # 選択メニューの更新
        self.createPageSelectMenu()
      )
    )

    #)
