// Generated by CoffeeScript 1.10.0
var UploadCommon;

UploadCommon = (function() {
  function UploadCommon() {}

  UploadCommon.initEvent = function(upload) {
    var _getThumbnailBlob, _readImage, _removeImage, _setImage, root;
    root = $('#upload_wrapper');
    _setImage = function(path) {
      var FR;
      FR = new FileReader();
      FR.onload = function(e) {
        var image, src;
        src = e.target.result;
        $('.capture', root).attr("src", src).show();
        $('.default_thumbnail', root).hide();
        $('.error_message', root).hide();
        $('.file_select_delete', root).show();
        image = new Image();
        image.src = src;
        return image.onload = function() {
          var contentType, imageData;
          imageData = src.split('base64,')[1];
          contentType = src.split(';base64')[0].replace('data:', '');
          $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_WIDTH + "']", root).val(image.width);
          return $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT + "']", root).val(image.height);
        };
      };
      return FR.readAsDataURL(path);
    };
    _readImage = function(input) {
      if (input.files && input.files[0]) {
        return _setImage.call(this, input.files[0]);
      } else {
        return _removeImage.call(this);
      }
    };
    _removeImage = function() {
      var selectFile;
      selectFile = $("." + constant.PreloadItemImage.Key.SELECT_FILE, root).val();
      if ((selectFile != null) && selectFile.length > 0) {
        $("." + constant.PreloadItemImage.Key.SELECT_FILE, root).val('').trigger('change');
      }
      $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_WIDTH + "']", root).val('');
      $("input[name='" + constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT + "']", root).val('');
      $('.file_select_delete', root).hide();
      $('.capture', root).attr("src", "").hide();
      $('.error_message', root).hide();
      return $('.default_thumbnail', root).show();
    };
    _getThumbnailBlob = function(src) {
      var xhr;
      xhr = new XMLHttpRequest();
      xhr.open("GET", src, true);
      xhr.responseType = "arraybuffer";
      xhr.onload = function(e) {
        var arrayBufferView, blob;
        arrayBufferView = new Uint8Array(this.response);
        blob = new Blob([arrayBufferView], {
          type: "image/jpeg"
        });
        return _setImage(blob);
      };
      return xhr.send();
    };
    $('#remove_image').click(function() {
      return _removeImage.call(this);
    });
    $("." + constant.PreloadItemImage.Key.SELECT_FILE, root).off('change').on('change', (function(_this) {
      return function(e) {
        var f, size;
        window.uploadContents = upload;
        f = $("." + constant.PreloadItemImage.Key.SELECT_FILE, root).val();
        if ((f != null) && f.length > 0) {
          size = e.target.files[0].size;
          if (size <= constant.THUMBNAIL_FILESIZE_MAX_KB * 1000) {
            return _readImage.call(_this, e.target);
          } else {
            $('.error_message', root).text(I18n.t('upload_confirm.thumbnail_size_error', {
              size: constant.THUMBNAIL_FILESIZE_MAX_KB
            }));
            return $('.error_message', root).show();
          }
        } else {
          return _removeImage.call(_this);
        }
      };
    })(this));
    $("." + constant.PreloadItemImage.Key.SELECT_FILE_DELETE, root).off('click').on('click', (function(_this) {
      return function(e) {
        return _removeImage.call(_this);
      };
    })(this));
    $("." + constant.Gallery.Key.OVERWRITE_CONTENTS_SELECT, root).off('change').on('change', (function(_this) {
      return function(e) {
        var _cbk, data, src, token;
        token = $(e.target).val();
        if (token.length === 0) {
          $("." + constant.Gallery.Key.TITLE, root).val('');
          $("." + constant.Gallery.Key.MARKDOWN_CAPTION, root).val('');
          $("." + constant.Gallery.Key.SHOW_GUIDE, root).prop('checked', true);
          $("." + constant.Gallery.Key.SHOW_PAGE_NUM, root).prop('checked', false);
          $("." + constant.Gallery.Key.SHOW_CHAPTER_NUM, root).prop('checked', false);
          _removeImage.call(_this);
          upload.removeAllUploadSelectTag(root);
          return;
        }
        src = "/gallery/" + token + "/thumbnail";
        _cbk = function(dataList) {
          var i, len, name, names;
          $("." + constant.Gallery.Key.TITLE, root).val(dataList[constant.Gallery.Key.TITLE]);
          $("." + constant.Gallery.Key.MARKDOWN_CAPTION, root).val(dataList[constant.Gallery.Key.CAPTION]);
          $("." + constant.Gallery.Key.SHOW_GUIDE, root).prop('checked', dataList[constant.Gallery.Key.SHOW_GUIDE]);
          $("." + constant.Gallery.Key.SHOW_PAGE_NUM, root).prop('checked', dataList[constant.Gallery.Key.SHOW_PAGE_NUM]);
          $("." + constant.Gallery.Key.SHOW_CHAPTER_NUM, root).prop('checked', dataList[constant.Gallery.Key.SHOW_CHAPTER_NUM]);
          if (dataList[constant.Gallery.Key.THUMBNAIL_EXISTED]) {
            _getThumbnailBlob.call(this, src);
          } else {
            _removeImage.call(this);
          }
          if (dataList[constant.Gallery.Key.TAG_ID] != null) {
            names = dataList[constant.Gallery.Key.TAG_NAME].split(',');
            for (i = 0, len = names.length; i < len; i++) {
              name = names[i];
              upload.addUploadSelectTag(root, name);
            }
          }
          return upload.prepareUploadTagEvent(root);
        };
        if (window.galleryDataList == null) {
          window.galleryDataList = {};
        }
        if (window.galleryDataList[token] != null) {
          return _cbk.call(_this, window.galleryDataList[token]);
        } else {
          Common.showModalFlashMessage('Loading...');
          data = {};
          data[constant.Gallery.Key.GALLERY_ACCESS_TOKEN] = token;
          return $.ajax({
            url: "/gallery/get_info",
            type: "GET",
            dataType: "json",
            data: data,
            success: function(data) {
              if (data != null) {
                window.galleryDataList[token] = data;
                _cbk.call(this, window.galleryDataList[token]);
              }
              return Common.hideModalView();
            },
            error: function(data) {
              return console.log('/gallery/get_info ajax error');
            }
          });
        }
      };
    })(this));
    upload.prepareUploadTagEvent(root);
    $('.select_tag_input', root).off('keypress').on('keypress', function(e) {
      if (e.keyCode === constant.KeyboardKeyCode.ENTER) {
        upload.addUploadSelectTag(root, $(this).val());
        return $(this).val('');
      }
    });
    return root.find('.upload_button').off('click').on('click', function() {
      upload.upload(root);
      return false;
    });
  };

  return UploadCommon;

})();

//# sourceMappingURL=upload_common.js.map
