class Navbar

  # Worktableナビバー初期化
  @initWorktableNavbar = ->
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
    $('.menu-newcreate', fileMenuEmt).on('click', ->
      if Object.keys(window.instanceMap).length > 0
        if window.confirm('ページ内に存在するアイテムは全て削除されます。')
          WorktableCommon.removeAllItemAndEventOnThisPage()
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
    $('.menu-item', itemsSelectMenuEmt).on('click', ->
      # TODO: 取り方見直す
      itemId = parseInt($(this).attr('id').replace('menu-item-', ''))
      itemsSelectMenuEmt.removeClass('active')
      $(@).parent('li').addClass('active')
      window.selectItemMenu = itemId
      changeMode(Constant.Mode.DRAW)
      WorktableCommon.loadItemJs(itemId)
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


