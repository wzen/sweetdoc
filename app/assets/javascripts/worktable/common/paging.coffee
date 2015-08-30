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
    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    lstorage = localStorage
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_INSTANCE_PAGEVALUES)
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_EVENT_PAGEVALUES)
    Common.clearAllEventChange( =>
      WorktableCommon.removeAllItem()
      EventConfig.removeAllConfig()
      window.pageNum += 1
      PageValue.adjustInstanceAndEventOnThisPage()
      WorktableCommon.drawAllItemFromEventPageValue()
      Timeline.refreshAllTimeline()
      # ページ総数の更新
      PageValue.setEventPageValue(PageValue.Key.eventCount(), 0)
      PageValue.updatePageCount()
      # 選択メニューの更新
      @createPageSelectMenu()
    )

  # 選択
  @selectPage: (selectedNum) ->
    pageCount = PageValue.getPageCount()
    if selectedNum < 0 || selectedNum > pageCount
      return

    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    lstorage = localStorage
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_INSTANCE_PAGEVALUES)
    lstorage.removeItem(LocalStorage.Key.WORKTABLE_EVENT_PAGEVALUES)
    Common.clearAllEventChange( =>
      WorktableCommon.removeAllItem()
      EventConfig.removeAllConfig()
      window.pageNum = selectedNum
      PageValue.adjustInstanceAndEventOnThisPage()
      WorktableCommon.drawAllItemFromEventPageValue()
      Timeline.refreshAllTimeline()
      # 選択メニューの更新
      @createPageSelectMenu()
    )
