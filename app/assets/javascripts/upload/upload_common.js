// Generated by CoffeeScript 1.9.2
var UploadCommon;

UploadCommon = (function() {
  function UploadCommon() {}

  UploadCommon.initEvent = function(upload) {
    var mark, root;
    root = $('#upload_wrapper');
    $("." + constant.PreloadItemImage.Key.SELECT_FILE, root).off('change').on('change', (function(_this) {
      return function() {
        var f;
        window.uploadContents = upload;
        f = $("." + constant.PreloadItemImage.Key.SELECT_FILE, root).val();
        if ((f != null) && f.length > 0) {
          Common.showModalFlashMessage('Thumbnail changing');
          return $('.thumbnail_upload_form', root).submit();
        } else {
          $('.capture', root).hide();
          return $('.default_thumbnail', root).show();
        }
      };
    })(this));
    $('.thumbnail_upload_form', root).off().on('ajax:complete', (function(_this) {
      return function(e, data, status, error) {
        var contentType, d, image, imageData;
        d = JSON.parse(data.responseText);
        if (d != null) {
          if (d.resultSuccess) {
            $('.error_message', root).hide();
            $('.capture', root).attr('src', d.image_url).show();
            $('.default_thumbnail', root).hide();
            imageData = d.image_url.split('base64,')[1];
            contentType = d.image_url.split(';base64')[0].replace('data:', '');
            $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG + "']", root).val(imageData.replace(/^.*,/, ''));
            $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_CONTENTSTYPE + "']", root).val(contentType);
            image = new Image();
            image.src = d.image_url;
            image.onload = function() {
              $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_WIDTH + "']", root).val(image.width);
              return $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT + "']", root).val(image.height);
            };
            $("." + constant.PreloadItemImage.Key.SELECT_FILE_DELETE, root).off('click').on('click', function(e) {
              $("." + constant.PreloadItemImage.Key.SELECT_FILE, root).val('').trigger('change');
              $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG + "']", root).val('');
              $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_CONTENTSTYPE + "']", root).val('');
              $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_WIDTH + "']", root).val('');
              $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT + "']", root).val('');
              return $('.file_select_delete', root).hide();
            });
            $('.file_select_delete', root).show();
          } else {
            $('.error_message', root).text(d.message);
            $('.error_message', root).show();
          }
        }
        _this.initEvent(window.uploadContents);
        Common.hideModalView(true);
        return window.uploadContents = null;
      };
    })(this));
    mark = $('.markItUp', root);
    if ((mark != null) && mark.length > 0) {
      $('.caption_markup', root).markItUpRemove();
    }
    $('.caption_markup', root).markItUp(mySettings);
    upload.prepareUploadTagEvent(root);
    $('.select_tag_input', root).off('keypress').on('keypress', function(e) {
      if (e.keyCode === constant.KeyboardKeyCode.ENTER) {
        upload.addUploadSelectTag(root, $(this).val());
        return $(this).val('');
      }
    });
    return root.next('.button_wrapper').find('.upload_button').off('click').on('click', function() {
      upload.upload(root);
      return false;
    });
  };

  UploadCommon.makeCapture = function(canvas) {
    var height, png, root, width;
    root = $('#upload_wrapper');
    try {
      png = canvas.toDataURL('image/png');
      $(".capture", root).attr('src', png);
      $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG + "']", root).val(png.replace(/^.*,/, ''));
    } catch (_error) {
      $(".capture", root).attr('src', '');
    }
    $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_CONTENTSTYPE + "']", root).val('image/png');
    width = parseInt($(canvas).attr('width'));
    height = parseInt($(canvas).attr('height'));
    $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_WIDTH + "']", root).val(width);
    $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT + "']", root).val(height);
    if (width > height) {
      return $(".capture", root).css({
        width: '100%',
        height: 'auto'
      });
    } else {
      return $(".capture", root).css({
        width: 'auto',
        height: '100%'
      });
    }
  };

  return UploadCommon;

})();

//# sourceMappingURL=upload_common.js.map
