class Navbar
  # @property [String] NAVBAR_ROOT ナビヘッダーRoot
  @NAVBAR_ROOT = constant.ElementAttribute.NAVBAR_ROOT
  # @property [String] ITEM_MENU_PREFIX アイテムメニュープレフィックス
  @ITEM_MENU_PREFIX = 'menu-item-'

  # Worktableナビバー初期化
  @initWorktableNavbar = ->
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
    $('.menu-newcreate', fileMenuEmt).off('click')
    $('.menu-newcreate', fileMenuEmt).on('click', ->
      if Object.keys(window.instanceMap).length > 0 || PageValue.getPageCount() >= 2
        if window.confirm(I18n.t('message.dialog.new_project'))
          WorktableCommon.recreateMainContainer()
          # 初期モーダル表示
          Common.showModalView(Constant.ModalViewType.INIT_PROJECT, Project.initProjectModal, false)
      else
        WorktableCommon.recreateMainContainer()
        # 初期モーダル表示
        Common.showModalView(Constant.ModalViewType.INIT_PROJECT, Project.initProjectModal, false)
    )

    menuSave = $('.menu-save', fileMenuEmt)
    menuSave.off('click')
    menuSave.on('click', ->
      ServerStorage.save()
    )
    menuSave.off('mouseenter')
    menuSave.on('mouseenter', (e) ->
      lastSaveTime = PageValue.getGeneralPageValue(PageValue.Key.LAST_SAVE_TIME)
      if lastSaveTime?
        n = $.now()
        d = new Date(lastSaveTime)
        li = @closest('li')
        $(li).append($("<div class='pop' style='display:none'><p>Last Save #{Common.displayDiffAlmostTime(n, d.getTime())}</p></div>"))
        $('.pop', li).css({top: $(li).height() + 30, left: $(li).width()})
        $('.pop', li).show()
    )
    menuSave.off('mouseleave')
    menuSave.on('mouseleave', (e) ->
      ul = @closest('ul')
      $('.pop', ul).remove()
    )

    $('.menu-setting', fileMenuEmt).off('click')
    $('.menu-setting', fileMenuEmt).on('click', ->
      Sidebar.switchSidebarConfig(Sidebar.Type.SETTING)
      WorktableSetting.initConfig()
      Sidebar.openConfigSidebar()
    )

    etcMenuEmt = $('#header_etc_select_menu .dropdown-menu > li')
    $('.menu-about', etcMenuEmt).off('click')
    $('.menu-about', etcMenuEmt).on('click', ->
      Common.showModalView(Constant.ModalViewType.ABOUT)
    )
    $('.menu-backtomainpage', etcMenuEmt).off('click')
    $('.menu-backtomainpage', etcMenuEmt).on('click', ->
      window.location.href = '/'
    )

    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
    $('.menu-item', itemsSelectMenuEmt).click( ->
      # プレビューを停止して再描画
      WorktableCommon.reDrawAllInstanceItemIfChanging()
      # 選択枠削除
      WorktableCommon.clearSelectedBorder()
      emtId = $(this).attr('id')
      if emtId.indexOf(Navbar.ITEM_MENU_PREFIX) >= 0
        itemId = parseInt(emtId.replace(Navbar.ITEM_MENU_PREFIX, ''))
        Navbar.setModeDraw(itemId)
        WorktableCommon.changeMode(Constant.Mode.DRAW)
    )

    $('#header_items_select_menu .menu-item').click( ->
      selected = $(@).html()
      $('#header_items_selected_menu_span').html(selected)
    )

    $('#menu-action-edit').click( ->
      Navbar.setModeEdit()
      WorktableCommon.changeMode(Constant.Mode.EDIT)
    )

    $('#menu_sidebar_toggle').off('click')
    $('#menu_sidebar_toggle').on('click', ->
      Sidebar.switchSidebarConfig(Sidebar.Type.STATE)
      StateConfig.initConfig()
      Sidebar.openConfigSidebar()
    )

  # Runナビバー初期化
  @initRunNavbar = ->
    navEmt = $('#nav')

    $('.menu-showguide', navEmt).off('click')
    $('.menu-showguide', navEmt).on('click', ->
      RunSetting.toggleShowGuide()
    )
    $('.menu-control-rewind-page', navEmt).off('click')
    $('.menu-control-rewind-page', navEmt).on('click', ->
      if window.eventAction?
        window.eventAction.thisPage().rewindAllChapters()
    )
    $('.menu-control-rewind-chapter', navEmt).off('click')
    $('.menu-control-rewind-chapter', navEmt).on('click', ->
      if window.eventAction?
        window.eventAction.thisPage().rewindChapter()
    )
    $('.menu-upload-gallery', navEmt).off('click')
    $('.menu-upload-gallery', navEmt).on('click', ->
      RunCommon.showUploadGalleryConfirm()
    )

  # Drawモードに設定
  @setModeDraw = (itemId, callback = null) ->
    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
    itemsSelectMenuEmt.removeClass('active')
    emtId = "menu-item-" + itemId
    $("##{emtId}").parent('li').addClass('active')
    window.selectItemMenu = itemId
    Common.loadItemJs(itemId, callback)

  # Editモードに設定
  @setModeEdit = ->
    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
    itemsSelectMenuEmt.removeClass('active')
    $('#menu-action-edit').parent('li').addClass('active')

  # ヘッダーにタイトルを設定
  @setTitle = (title_name) ->
    if !window.isWorkTable
      title_name += '(Preview)'
    $("##{Navbar.NAVBAR_ROOT}").find('.nav_title').html(title_name)
    if title_name? && title_name.length > 0
      document.title = title_name
    else
      document.title = window.appName

  # ヘッダーにページ番号を設定
  # @param [Integer] value 設定値
  @setPageNum = (value) ->
    navEmt = $('#nav')
    e = $('.nav_page_num', navEmt)
    if e?
      e.html(value)
    else
      e.html('')

  # ヘッダーにチャプター番号を設定
  # @param [Integer] value 設定値
  @setChapterNum = (value) ->
    navEmt = $('#nav')
    e = $('.nav_chapter_num', navEmt)
    if e?
      e.html(value)
    else
      e.html('')

  # ヘッダーにページ総数を設定
  # @param [Integer] page_max 設定値
  @setPageMax = (page_max) ->
    navEmt = $('#nav')
    e = $('.nav_page_max', navEmt)
    if e?
      e.html(page_max)
    else
      e.html('')

  # ヘッダーにチャプター総数を設定
  # @param [Integer] chapter_max 設定値
  @setChapterMax = (chapter_max) ->
    navEmt = $('#nav')
    e = $('.nav_chapter_max', navEmt)
    if e?
      e.html(chapter_max)
    else
      e.html('')

  # フォーク番号を設定
  # @param [Integer] num 設定値
  @setForkNum = (num) ->
    navEmt = $('#nav')
    e = $('.nav_fork_num', navEmt)
    if e?
      e.html(num)
      e.closest('li').css('display', if num > 0 then 'block' else 'none')
    else
      e.html('')
      e.closest('li').hide()

