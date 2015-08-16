# ヘッダーメニュー初期化
initHeaderMenu = ->
  itemsMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
  $('.menu-newcreate', itemsMenuEmt).on('click', ->
    if Object.keys(Common.getCreatedItemObject()).length > 0
      if window.confirm('テーブルに存在するアイテムが全て削除されます。')
        Common.removeAllItemAndEvent()
  )
  $('.menu-load', itemsMenuEmt).on('click', ->
    ServerStorage.load()
  )
  $('.menu-save', itemsMenuEmt).on('click', ->
    ServerStorage.save()
  )
  $('.menu-setting', itemsMenuEmt).on('click', ->
    switchSidebarConfig('setting')
    Setting.initConfig()
    openConfigSidebar()
  )

  itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
  $('.menu-item', itemsSelectMenuEmt).on('click', ->
    # TODO: 取り方見直す
    itemId = parseInt($(this).attr('id').replace('menu-item-', ''))
    itemsSelectMenuEmt.removeClass('active')
    $(@).parent('li').addClass('active')
    window.selectItemMenu = itemId
    changeMode(Constant.Mode.DRAW)
    loadItemJs(itemId)
  )
