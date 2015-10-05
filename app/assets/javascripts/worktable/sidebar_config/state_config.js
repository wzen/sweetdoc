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
    var createdItemList, items, k, limit, position, rootEmt, temp, v;
    rootEmt = $("#" + this.ROOT_ID_NAME);
    position = PageValue.getGeneralPageValue(PageValue.Key.displayPosition());
    $('.display_position_x', rootEmt).val(parseInt(position.left));
    $('.display_position_y', rootEmt).val(parseInt(position.top));
    $('.display_position_x, .display_position_y', rootEmt).off('keypress');
    $('.display_position_x, .display_position_y', rootEmt).on('keypress', function(e) {
      var left, top;
      if (e.keyCode === Constant.KeyboardKeyCode.ENTER) {
        left = $('.display_position_x', rootEmt).val();
        top = $('.display_position_y', rootEmt).val();
        PageValue.setGeneralPageValue(PageValue.Key.displayPosition(), {
          top: top,
          left: left
        });
        return Common.updateScrollContentsFromPagevalue();
      }
    });
    limit = "(" + (-window.scrollViewSize * 0.5) + " 〜 " + (window.scrollViewSize * 0.5) + ")";
    $('.display_position_limit', rootEmt).html(limit);
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
      $('.focus_enabled > a').off('click');
      $('.focus_enabled > a').on('click', function(e) {
        var objId;
        objId = $(this).closest('.wrapper').find('.item_obj_id').val();
        return Common.focusToTarget($("#" + objId), function() {
          rootEmt = $("#" + StateConfig.ROOT_ID_NAME);
          position = PageValue.getGeneralPageValue(PageValue.Key.displayPosition());
          $('.display_position_x', rootEmt).val(parseInt(position.left));
          return $('.display_position_y', rootEmt).val(parseInt(position.top));
        });
      });
      $('a.item_edit', rootEmt).off('click');
      $('a.item_edit', rootEmt).on('click', function(e) {
        var objId;
        e.preventDefault();
        objId = $(this).closest('.wrapper').find('.item_obj_id').val();
        return Sidebar.openItemEditConfig($("#" + objId));
      });
      $('.item_visible > a, .item_invisible > a', rootEmt).off('click');
      return $('.item_visible > a, .item_invisible > a', rootEmt).on('click', function(e) {
        e.preventDefault();
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

  return StateConfig;

})();

//# sourceMappingURL=state_config.js.map
