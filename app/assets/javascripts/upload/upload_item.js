// Generated by CoffeeScript 1.9.2
var UploadItem,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

UploadItem = (function(superClass) {
  extend(UploadItem, superClass);

  function UploadItem() {
    return UploadItem.__super__.constructor.apply(this, arguments);
  }

  UploadItem.prototype.upload = function(root, callback) {
    var _saveGallery, title;
    if (callback == null) {
      callback = null;
    }
    title = $("input[name='" + constant.ItemGallery.Key.TITLE + "']", root).val();
    if (title.length === 0) {
      $('.title_error', root).show();
      return;
    }
    _saveGallery = function() {
      var fd, tags;
      Common.showModalFlashMessage('Updating...');
      fd = new FormData(document.getElementById('upload_form'));
      tags = $.map($('.select_tag a', root), function(n) {
        return $(n).html();
      });
      if (tags != null) {
        fd.append(constant.ItemGallery.Key.TAGS, tags);
      } else {
        fd.append(constant.ItemGallery.Key.TAGS, null);
      }
      return $.ajax({
        url: '/item_gallery/save_state',
        data: fd,
        processData: false,
        contentType: false,
        type: 'POST',
        success: function(data) {
          if (data.resultSuccess) {
            return window.location.href = "/my_page/created_items";
          } else {
            console.log('gallery/save_state server error');
            return Common.ajaxError(data);
          }
        },
        error: function(data) {
          console.log('gallery/save_state ajax error');
          return Common.ajaxError(data);
        }
      });
    };
    if (window.confirm(I18n.t('message.dialog.update_gallery'))) {
      return _saveGallery.call(this);
    }
  };

  return UploadItem;

})(UploadBase);

//# sourceMappingURL=upload_item.js.map
