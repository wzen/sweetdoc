// Generated by CoffeeScript 1.9.2
var StateConfig;

StateConfig = (function() {
  var constant;

  function StateConfig() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    StateConfig.ROOT_ID_NAME = constant.StateConfig.ROOT_ID_NAME;
    StateConfig.ITEM_TEMP_CLASS_NAME = constant.StateConfig.ITEM_TEMP_CLASS_NAME;
  }

  StateConfig.initConfig = function() {
    var createdItemList, items, k, rootEmt, temp, v;
    rootEmt = $("#" + this.ROOT_ID_NAME);
    createdItemList = $('.created_item_list', rootEmt);
    createdItemList.children().remove();
    items = PageValue.getCreatedItems();
    if (Object.keys(items).length > 0) {
      createdItemList.closest('.configBox').show();
      for (k in items) {
        v = items[k];
        temp = $("." + this.ITEM_TEMP_CLASS_NAME, rootEmt).children(':first').clone(true);
        temp.find('.item_obj_id').val(k);
        temp.find('.name').html(v.value.name);
        if (!$("#" + k).is(':visible')) {
          temp.find('.item_visible').hide();
          temp.find('.item_invisible').show();
        }
        createdItemList.append(temp);
      }
      $('a.item_edit', rootEmt).off('click');
      $('a.item_edit', rootEmt).on('click', function() {
        var objId;
        objId = $(this).closest('.wrapper').find('.item_obj_id').val();
        return Sidebar.openItemEditConfig($("#" + objId));
      });
      $('.item_visible > a, .item_invisible > a', rootEmt).off('click');
      return $('.item_visible > a, .item_invisible > a', rootEmt).on('click', function(e) {
        return StateConfig.clickToggleVisible(this);
      });
    }
  };

  StateConfig.clickToggleVisible = function(target) {
    var emt, objId, parent;
    objId = $(target).closest('.wrapper').find('.item_obj_id').val();
    emt = $("#" + objId);
    emt.toggle();
    parent = $(target.closest('.buttons'));
    if (emt.is(':visible')) {
      parent.find('.item_visible').show();
      return parent.find('.item_invisible').hide();
    } else {
      parent.find('.item_visible').hide();
      return parent.find('.item_invisible').show();
    }
  };

  return StateConfig;

})();

//# sourceMappingURL=state_config.js.map
