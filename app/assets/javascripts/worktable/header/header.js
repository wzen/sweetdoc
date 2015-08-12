// Generated by CoffeeScript 1.9.2
var initHeaderMenu;

initHeaderMenu = function() {
  var itemsMenuEmt, itemsSelectMenuEmt;
  itemsMenuEmt = $('#header_items_file_menu .dropdown-menu > li');
  $('.menu-load', itemsMenuEmt).on('click', function() {
    return loadFromServer();
  });
  $('.menu-save', itemsMenuEmt).on('click', function() {
    return saveToServer();
  });
  $('.menu-setting', itemsMenuEmt).on('click', function() {
    switchSidebarConfig('setting');
    Setting.initConfig();
    return openConfigSidebar();
  });
  itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li');
  return $('.menu-item', itemsSelectMenuEmt).on('click', function() {
    var itemId;
    itemId = parseInt($(this).attr('id').replace('menu-item-', ''));
    itemsSelectMenuEmt.removeClass('active');
    $(this).parent('li').addClass('active');
    window.selectItemMenu = itemId;
    changeMode(Constant.Mode.DRAW);
    return loadItemJs(itemId);
  });
};

//# sourceMappingURL=header.js.map