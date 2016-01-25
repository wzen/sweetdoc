// Generated by CoffeeScript 1.9.2
var ItemStateConfig;

ItemStateConfig = (function() {
  var constant;

  function ItemStateConfig() {}

  constant = gon["const"];

  ItemStateConfig.ROOT_ID_NAME = constant.ItemStateConfig.ROOT_ID_NAME;

  ItemStateConfig.ITEM_TEMP_CLASS_NAME = constant.ItemStateConfig.ITEM_TEMP_CLASS_NAME;

  ItemStateConfig.initConfig = function() {
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
      $('.focus_enabled > a', rootEmt).off('click').on('click', function(e) {
        var objId;
        objId = $(this).closest('.wrapper').find('.item_obj_id').val();
        return Common.focusToTarget($("#" + objId), null, true);
      });
      $('a.item_edit', rootEmt).off('click').on('click', function(e) {
        var objId;
        e.preventDefault();
        objId = $(this).closest('.wrapper').find('.item_obj_id').val();
        return WorktableCommon.editItem(objId);
      });
      return $('.item_visible > a, .item_invisible > a', rootEmt).off('click').on('click', function(e) {
        e.preventDefault();
        return ItemStateConfig.clickToggleVisible(this);
      });
    }
  };

  ItemStateConfig.clickToggleVisible = function(target) {
    var emt, objId, parent;
    objId = $(target).closest('.wrapper').find('.item_obj_id').val();
    emt = $("#" + objId);
    emt.toggle();
    parent = $(target.closest('.buttons'));
    if (emt.is(':visible')) {
      parent.find('.item_visible').show();
      parent.find('.item_invisible').hide();
      parent.find('.focus_enabled').show();
      return parent.find('.focus_disabled').hide();
    } else {
      parent.find('.item_visible').hide();
      parent.find('.item_invisible').show();
      parent.find('.focus_enabled').hide();
      return parent.find('.focus_disabled').show();
    }
  };

  return ItemStateConfig;

})();

//# sourceMappingURL=item_state_config.js.map
