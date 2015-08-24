# ヘッダーメニュー初期化
initHeaderMenu = ->
  itemsMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
  $('.menu-newcreate', itemsMenuEmt).on('click', ->
    if Object.keys(window.instanceMap).length > 0
      if window.confirm('テーブルに存在するアイテムは全て削除されます。')
        WorktableCommon.removeAllItemAndEvent()
  )
  $('.menu-load', itemsMenuEmt).off('mouseenter')
  $('.menu-load', itemsMenuEmt).on('mouseenter', ->
    ServerStorage.get_load_list()
  )
  $('.menu-save', itemsMenuEmt).off('click')
  $('.menu-save', itemsMenuEmt).on('click', ->
    ServerStorage.save()
  )
  $('.menu-setting', itemsMenuEmt).off('click')
  $('.menu-setting', itemsMenuEmt).on('click', ->
    Sidebar.switchSidebarConfig('setting')
    Setting.initConfig()
    Sidebar.openConfigSidebar()
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
