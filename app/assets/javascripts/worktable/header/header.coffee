# ヘッダーメニュー初期化
initHeaderMenu = ->
  itemsMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
  $('.menu-load', itemsMenuEmt).on('click', ->
    loadFromServer()
  )
  $('.menu-save', itemsMenuEmt).on('click', ->
    saveToServer()
  )
  $('.menu-setting', itemsMenuEmt).on('click', ->
    switchSidebarConfig('setting')
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
