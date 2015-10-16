// Generated by CoffeeScript 1.9.2
var Upload;

Upload = (function() {
  function Upload() {}

  Upload.initEvent = function() {
    var mark, root;
    root = $('#upload_wrapper');
    mark = $('.markItUp', root);
    if ((mark != null) && mark.length > 0) {
      $('.caption_markup', root).markItUpRemove();
    }
    $('.caption_markup', root).markItUp(mySettings);
    this.prepareUploadGalleryTagEvent(root);
    $('.select_tag_input', root).off('keypress');
    $('.select_tag_input', root).on('keypress', function(e) {
      if (e.keyCode === Constant.KeyboardKeyCode.ENTER) {
        Upload.addUploadGallerySelectTag(root, $(this).val());
        return $(this).val('');
      }
    });
    $('.upload_button').off('click');
    return $('.upload_button').on('click', function() {
      return Upload.uploadToGallery(root);
    });
  };

  Upload.prepareUploadGalleryTagEvent = function(root) {
    var tags;
    tags = $('.popular_tag a, .recommend_tag a', root);
    tags.off('click');
    tags.on('click', function() {
      return Upload.addUploadGallerySelectTag(root, $(this).html());
    });
    tags.off('mouseenter');
    tags.on('mouseenter', function(e) {
      var li;
      li = this.closest('li');
      $(li).append($("<div class='add_pop pop' style='display:none'><p>Add tag(click)</p></div>"));
      $('.add_pop', li).css({
        top: $(li).height(),
        left: $(li).width()
      });
      return $('.add_pop', li).show();
    });
    tags.off('mouseleave');
    return tags.on('mouseleave', function(e) {
      var ul;
      ul = this.closest('ul');
      return $('.add_pop', ul).remove();
    });
  };

  Upload.addUploadGallerySelectTag = function(root, tagname) {
    var tags, ul;
    ul = $('.select_tag ul', root);
    tags = $.map(ul.children(), function(n) {
      return $('a', n).html();
    });
    if (tags.length >= Constant.Gallery.TAG_MAX || $.inArray(tagname, tags) >= 0) {
      return;
    }
    ul.append($("<li><a href='#'>" + tagname + "</a></li>"));
    $('a', ul).off('click');
    $('a', ul).on('click', function(e) {
      this.closest('li').remove();
      if ($('.select_tag ul li', root).length < Constant.Gallery.TAG_MAX) {
        return $('.select_tag_input', root).show();
      }
    });
    $('a', ul).off('mouseenter');
    $('a', ul).on('mouseenter', function(e) {
      var li;
      li = this.closest('li');
      $(li).append($("<div class='delete_pop pop' style='display:none'><p>Delete tag(click)</p></div>"));
      $('.delete_pop', li).css({
        top: $(li).height(),
        left: $(li).width()
      });
      return $('.delete_pop', li).show();
    });
    $('a', ul).off('mouseleave');
    $('a', ul).on('mouseleave', function(e) {
      return $('li .delete_pop', ul).remove();
    });
    if ($('.select_tag ul li', root).length >= Constant.Gallery.TAG_MAX) {
      return $('.select_tag_input', root).hide();
    }
  };

  Upload.uploadToGallery = function(root, callback) {
    var _saveGallery, title;
    if (callback == null) {
      callback = null;
    }
    title = $("input[name='" + Constant.Gallery.Key.TITLE + "']", root).val();
    if (title.length === 0) {
      return;
    }
    _saveGallery = function() {
      var fd, tags;
      fd = new FormData(document.getElementById('upload_form'));
      tags = $('.select_tag a', root).html();
      if (tags != null) {
        fd.append(Constant.Gallery.Key.TAGS, $('.select_tag a', root).html());
      } else {
        fd.append(Constant.Gallery.Key.TAGS, null);
      }
      return $.ajax({
        url: 'gallery/save_state',
        data: fd,
        processData: false,
        contentType: false,
        type: 'POST',
        success: function(data) {
          return window.location.href = "/gallery/detail?" + Constant.Gallery.Key.GALLERY_ACCESS_TOKEN + "=" + data.access_token;
        },
        error: function(data) {
          return alert(data.message);
        }
      });
    };
    if (window.confirm(I18n.t('message.dialog.update_gallery'))) {
      return _saveGallery.call(this);
    }
  };

  Upload.makeCapture = function(canvas) {
    var height, png, root, width;
    root = $('#upload_wrapper');
    png = canvas.toDataURL('image/png');
    $(".capture", root).attr('src', png);
    $("input[name='" + Constant.Gallery.Key.THUMBNAIL_IMG + "']", root).val(png);
    width = parseInt($(canvas).attr('width'));
    height = parseInt($(canvas).attr('height'));
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

  return Upload;

})();

$(function() {
  Upload.initEvent();
  if (window.opener != null) {
    return setTimeout(function() {
      var body;
      body = $(window.opener.document.getElementById('project_contents'));
      return html2canvas(body, {
        onrendered: function(canvas) {
          return Upload.makeCapture(canvas);
        }
      });
    });
  }
});

//# sourceMappingURL=upload.js.js.map
