/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
var ItemStateConfig = (function() {
  let constant = undefined;
  ItemStateConfig = class ItemStateConfig {
    static initClass() {
      // 定数
      constant = gon.const;
      this.ROOT_ID_NAME = constant.ItemStateConfig.ROOT_ID_NAME;
      this.ITEM_TEMP_CLASS_NAME = constant.ItemStateConfig.ITEM_TEMP_CLASS_NAME;
    }

    // 設定値初期化
    static initConfig() {
      const rootEmt = $(`#${this.ROOT_ID_NAME}`);
      // 作成アイテム一覧
      const createdItemList = $('.created_item_list', rootEmt);
      createdItemList.children().remove();
      const items = PageValue.getCreatedItems();
      if(Object.keys(items).length > 0) {
        createdItemList.closest('.configBox').show();
        for(let k in items) {
          const v = items[k];
          const temp = $(`.${this.ITEM_TEMP_CLASS_NAME}`, rootEmt).children(':first').clone(true);
          temp.find('.item_obj_id').val(k);
          temp.find('.name').html(v.value.name);
          if(!$(`#${k}`).is(':visible')) {
            temp.find('.item_visible').hide();
            temp.find('.item_invisible').show();
            temp.find('.focus_enabled').hide();
            temp.find('.focus_disabled').show();
          } else {
            temp.find('.item_visible').show();
            temp.find('.item_invisible').hide();
            temp.find('.focus_enabled').show();
            temp.find('.focus_disabled').hide();
          }
          createdItemList.append(temp);
        }

        $('.focus_enabled > a', rootEmt).off('click').on('click', function(e) {
          const objId = $(this).closest('.wrapper').find('.item_obj_id').val();
          // アイテムにフォーカス
          return Common.focusToTarget($(`#${objId}`), null, true);
        });
        $('a.item_edit', rootEmt).off('click').on('click', function(e) {
          e.preventDefault();
          const objId = $(this).closest('.wrapper').find('.item_obj_id').val();
          return WorktableCommon.editItem(objId);
        });
        return $('.item_visible > a, .item_invisible > a', rootEmt).off('click').on('click', function(e) {
          e.preventDefault();
          return ItemStateConfig.clickToggleVisible(this);
        });
      }
    }

    static clickToggleVisible(target) {
      const objId = $(target).closest('.wrapper').find('.item_obj_id').val();
      const emt = $(`#${objId}`);
      emt.toggle();
      PageValue.setWorktableItemHide(objId, emt.is(':visible'));
      window.lStorage.saveGeneralPageValue();
      const parent = $(target.closest('.buttons'));
      if(emt.is(':visible')) {
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
    }
  };
  ItemStateConfig.initClass();
  return ItemStateConfig;
})();