class Navbar
  # @property [String] NAVBAR_ROOT ナビヘッダーRoot
  @NAVBAR_ROOT = constant.ElementAttribute.NAVBAR_ROOT
  @ITEM_MENU_PREFIX = 'menu-item-'

  # Worktableナビバー初期化
  @initWorktableNavbar = ->
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
    $('.menu-newcreate', fileMenuEmt).off('click')
    $('.menu-newcreate', fileMenuEmt).on('click', ->
      if Object.keys(window.instanceMap).length > 0 || PageValue.getPageCount() >= 2
        if window.confirm(I18n.t('message.dialog.new_project'))
          WorktableCommon.recreateMainContainer()
    )
    $('.menu-load', fileMenuEmt).off('mouseenter')
    $('.menu-load', fileMenuEmt).on('mouseenter', ->
      ServerStorage.get_load_list()
    )
    $('.menu-save', fileMenuEmt).off('click')
    $('.menu-save', fileMenuEmt).on('click', ->
      ServerStorage.save()
    )
    $('.menu-setting', fileMenuEmt).off('click')
    $('.menu-setting', fileMenuEmt).on('click', ->
      Sidebar.switchSidebarConfig('setting')
      Setting.initConfig()
      Sidebar.openConfigSidebar()
    )

    etcMenuEmt = $('#header_etc_select_menu .dropdown-menu > li')
    $('.menu-about', etcMenuEmt).off('click')
    $('.menu-about', etcMenuEmt).on('click', ->
      Common.showModalView(Constant.ModalViewType.ABOUT)
    )

    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
    $('.menu-item', itemsSelectMenuEmt).click( ->
      emtId = $(this).attr('id')
      if emtId.indexOf(Navbar.ITEM_MENU_PREFIX) >= 0
        itemId = parseInt(emtId.replace(Navbar.ITEM_MENU_PREFIX, ''))
        itemsSelectMenuEmt.removeClass('active')
        $(@).parent('li').addClass('active')
        window.selectItemMenu = itemId
        WorktableCommon.changeMode(Constant.Mode.DRAW)
        Common.loadItemJs(itemId)
    )

    #$('#header_items_select_menu .menu-item').off('click')
    $('#header_items_select_menu .menu-item').click( ->
      selected = $(@).html()
      $('#header_items_selected_menu_span').html(selected)
    )

    $('#menu-action-edit').click( ->
      WorktableCommon.changeMode(Constant.Mode.EDIT)
    )

  # Runナビバー初期化
  @initRunNavbar = ->
    navEmt = $('#nav')
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

  @setPageNum = (value) ->
    navEmt = $('#nav')
    e = $('.nav_page_num', navEmt)
    if e?
      e.html(value)
    else
      e.html('')

  @setChapterNum = (value) ->
    navEmt = $('#nav')
    e = $('.nav_chapter_num', navEmt)
    if e?
      e.html(value)
    else
      e.html('')

  @setPageMax = (page_max) ->
    navEmt = $('#nav')
    e = $('.nav_page_max', navEmt)
    if e?
      e.html(page_max)
    else
      e.html('')

  @setChapterMax = (chapter_max) ->
    navEmt = $('#nav')
    e = $('.nav_chapter_max', navEmt)
    if e?
      e.html(chapter_max)
    else
      e.html('')


