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
  @switchSectionDisplay: (pageNum) ->
    $("##{Constant.Paging.ROOT_ID}").find(".section").css('display', 'none')
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
    section.css('display', '')

  # ページ追加作成
  @createNewPage: ->
    self = @
    beforePageNum = PageValue.getPageNum()
    if window.debug
      console.log('[createNewPage] beforePageNum:' + beforePageNum)

    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    LocalStorage.clearWorktableWithoutSetting()
    #Common.clearAllEventChange( ->
    EventConfig.removeAllConfig()
    PageValue.setPageNum(PageValue.getPageCount() + 1)
    if window.debug
      console.log('[createNewPage createdPageNum:' + PageValue.getPageCount() + 1)
    # Mainコンテナ作成
    Common.createdMainContainerIfNeeded(PageValue.getPageNum())
    # 新規コンテナ初期化
    WorktableCommon.initMainContainer()
    PageValue.adjustInstanceAndEventOnThisPage()
    WorktableCommon.drawAllItemFromEventPageValue( =>
      # ページング
      pageFlip = new PageFlip(beforePageNum)
      pageFlip.startRender(PageFlip.DIRECTION.FORWARD, ->
        className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
        section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
        section.css('display', 'none')
        Common.removeAllItem(beforePageNum)

        WorktableCommon.initMainContainer()
        Timeline.refreshAllTimeline()
        # ページ総数の更新
        PageValue.setEventPageValue(PageValue.Key.eventCount(), 0)
        PageValue.updatePageCount()
        # キャッシュ保存
        LocalStorage.saveValueForWorktable()

        # 選択メニューの更新
        self.createPageSelectMenu()
      )
    )
    #)

  # 選択
  @selectPage: (selectedNum) ->
    if window.debug
      console.log('[selectPage] selectedNum:' + selectedNum)

    self = @
    if selectedNum <= 0
      return

    pageCount = PageValue.getPageCount()
    if selectedNum < 0 || selectedNum > pageCount
      return

    beforePageNum = PageValue.getPageNum()
    if window.debug
      console.log('[selectPage] beforePageNum:' + beforePageNum)

    direction = if beforePageNum < selectedNum then PageFlip.DIRECTION.FORWARD else PageFlip.DIRECTION.BACK
    if window.debug
      console.log('[selectPage] direction:' + direction)

    Sidebar.closeSidebar()
    # WebStorageのアイテム&イベント情報を消去
    LocalStorage.clearWorktableWithoutSetting()
    EventConfig.removeAllConfig()

    # Mainコンテナ作成
    Common.createdMainContainerIfNeeded(selectedNum, beforePageNum > selectedNum)

    # 新規表示するコンテナの初期化
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', selectedNum)
    section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
    section.css('display', '')
    if direction == PageFlip.DIRECTION.FORWARD
      section.css('width', '')
    else if direction == PageFlip.DIRECTION.BACK
      section.css('width', '0')

    if window.debug
      console.log('[selectPage] show pageNum:' + selectedNum)

    PageValue.setPageNum(selectedNum)
    WorktableCommon.initMainContainer()
    PageValue.adjustInstanceAndEventOnThisPage()
    WorktableCommon.drawAllItemFromEventPageValue( =>
      # ページング

      pn = if beforePageNum < PageValue.getPageNum() then beforePageNum else PageValue.getPageNum()
      if window.debug
        console.log('[selectPage] pn:' + pn)
      pageFlip = new PageFlip(pn)
      pageFlip.startRender(direction, ->
        # 隠したビューを非表示にする
        className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
        section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
        section.css('display', 'none')
        if window.debug
          console.log('[selectPage] deleted pageNum:' + beforePageNum)
        # 隠したビューのアイテムを削除
        Common.removeAllItem(beforePageNum)
        Timeline.refreshAllTimeline()

        # キャッシュ保存
        LocalStorage.saveValueForWorktable()

        # 選択メニューの更新
        self.createPageSelectMenu()
      )
    )
