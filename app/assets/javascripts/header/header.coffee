# ヘッダーメニュー初期化
initHeaderMenu = ->
  fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
  $('.menu-newcreate', fileMenuEmt).on('click', ->
    if Object.keys(window.instanceMap).length > 0
      if window.confirm('テーブルに存在するアイテムは全て削除されます。')
        WorktableCommon.removeAllItemAndEvent()
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