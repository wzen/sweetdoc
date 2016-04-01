// Generated by CoffeeScript 1.9.2
var GalleryCommon;

GalleryCommon = (function() {
  function GalleryCommon() {}

  GalleryCommon.initView = function() {
    this.initCommonVar();
    return this.initResize();
  };

  GalleryCommon.initCommonVar = function() {
    window.mainGalleryWrapper = $('#main_gallery_wrapper');
    window.galleryContentsWrapper = $('#gallery_contents_wrapper');
    return window.gridWrapper = $('#grid_wrapper');
  };

  GalleryCommon.initGridView = function(callback) {
    if (callback == null) {
      callback = null;
    }
    this.addGridContentsStyle($('.grid_contents_wrapper'));
    return this.setupMasonry(this.windowWidthType());
  };

  GalleryCommon.setupMasonry = function(windowWidthType) {
    var $grid, columnWidth;
    columnWidth = windowWidthType === 0 ? 100 : 180;
    $grid = $('#grid_wrapper');
    if ($grid.data('masonry') != null) {
      $grid.masonry('destroy');
    }
    $grid.masonry({
      itemSelector: '.grid_contents_wrapper',
      columnWidth: columnWidth,
      isAnimated: true,
      animationOptions: {
        duration: 400
      },
      isFitWidth: true
    });
    $grid.one('layoutComplete', (function(_this) {
      return function() {
        return _this.showAllGrid();
      };
    })(this));
    return $grid.masonry('layout');
  };

  GalleryCommon.initResize = function() {
    $(window).resize((function(_this) {
      return function() {
        var wt;
        GalleryCommon.resizeMainContainerEvent();
        wt = _this.windowWidthType();
        if (window.nowWindowWidthType !== wt) {
          _this.setupMasonry(wt);
          return window.nowWindowWidthType = wt;
        }
      };
    })(this));
    return window.nowWindowWidthType = this.windowWidthType();
  };

  GalleryCommon.resizeMainContainerEvent = function() {};

  GalleryCommon.windowWidthType = function() {
    var mediaMaxWidth1, w;
    w = $(window).width();
    mediaMaxWidth1 = 699;
    if (w <= mediaMaxWidth1) {
      return 0;
    } else {
      return 1;
    }
  };

  GalleryCommon.showAllGrid = function() {
    return $('#grid_wrapper').find('.grid_contents_wrapper').css('opacity', '');
  };

  GalleryCommon.showWithFullScreen = function(e) {
    var height, left, root, rootTarget, size, target, top, width;
    e = e || window.event;
    rootTarget = e.target || e.srcElement;
    e.preventDefault();
    e.stopPropagation();
    root = $(rootTarget);
    target = "_runwindow";
    width = root.find("." + constant.Gallery.Key.SCREEN_SIZE_WIDTH).val();
    height = root.find("." + constant.Gallery.Key.SCREEN_SIZE_HEIGHT).val();
    if ((width != null) && (height != null)) {
      size = {
        width: width,
        height: height
      };
      left = Number((window.screen.width - size.width) / 2);
      top = Number((window.screen.height - size.height) / 2);
      window.open("about:blank", target, "top=" + top + ",left=" + left + ",width=" + size.width + ",height=" + size.height + ",menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no");
    } else {
      window.open("about:blank", target, "menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no");
    }
    document.send_form.action = '/gallery/detail/w/' + root.find("." + constant.Gallery.Key.GALLERY_ACCESS_TOKEN).val();
    document.send_form.target = target;
    return setTimeout(function() {
      return document.send_form.submit();
    }, 200);
  };

  GalleryCommon.addBookmark = function(note, callback) {
    var data;
    if (callback == null) {
      callback = null;
    }
    data = {};
    data[constant.Gallery.Key.GALLERY_ACCESS_TOKEN] = Common.getContentsAccessTokenFromUrl();
    data[constant.Gallery.Key.NOTE] = note;
    return $.ajax({
      url: "/gallery/add_bookmark",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (data.resultSuccess) {
          if (callback != null) {
            return callback(true);
          }
        } else {
          console.log('/gallery/add_bookmark server error');
          Common.ajaxError(data);
          if (callback != null) {
            return callback(false);
          }
        }
      },
      error: function(data) {
        console.log('/gallery/add_bookmark ajax error');
        Common.ajaxError(data);
        if (callback != null) {
          return callback(false);
        }
      }
    });
  };

  GalleryCommon.removeBookmark = function(callback) {
    var data;
    if (callback == null) {
      callback = null;
    }
    data = {};
    data[constant.Gallery.Key.GALLERY_ACCESS_TOKEN] = Common.getContentsAccessTokenFromUrl();
    return $.ajax({
      url: "/gallery/remove_bookmark",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (data.resultSuccess) {
          if (callback != null) {
            return callback(true);
          }
        } else {
          console.log('/project/remove server error');
          Common.ajaxError(data);
          if (callback != null) {
            return callback(false);
          }
        }
      },
      error: function(data) {
        console.log('/project/remove ajax error');
        Common.ajaxError(data);
        if (callback != null) {
          return callback(false);
        }
      }
    });
  };

  GalleryCommon.calcGridContentsSizeAndStyle = function(imgWidth, imgHeight) {
    var className, h, r, ret, style, w;
    className = '';
    style = null;
    w = 180 - (3 * 2);
    h = 180 - 20 - (3 * 2);
    r = parseInt(Math.random() * 15);
    if (r === 0) {
      className = 'grid-item-width2 grid-item-height2';
      w *= 2;
      h *= 2;
    } else if (r === 1 || r === 2) {
      className = 'grid-item-width2';
      w *= 2;
    } else if (r === 3 || r === 4) {
      className = 'grid-item-height2';
      h *= 2;
    }
    if (imgHeight / imgWidth > h / w) {
      style = 'width:100%;height:auto;';
    } else {
      style = 'width:auto;height:100%;';
    }
    if (imgWidth / imgHeight > 1.5 && className === 'grid-item-height2') {
      ret = this.calcGridContentsSizeAndStyle(imgWidth, imgHeight);
      className = ret.className;
      style = ret.style;
    } else if (imgHeight / imgWidth > 1.5 && className === 'grid-item-width2') {
      className = ret.className;
      style = ret.style;
    }
    return {
      className: className,
      style: style
    };
  };

  GalleryCommon.addGridContentsStyle = function(contents) {
    return contents.each((function(_this) {
      return function(idx, content) {
        var calcStyle, h, w;
        if ($(content).attr('class').split(' ').length <= 2) {
          w = $(content).find("." + constant.Gallery.Key.THUMBNAIL_IMG_WIDTH + ":first").val();
          h = $(content).find("." + constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT + ":first").val();
          calcStyle = _this.calcGridContentsSizeAndStyle(w, h);
          $(content).addClass(calcStyle.className);
          return $(content).find('.thumbnail_img:first').attr('style', calcStyle.style);
        }
      };
    })(this));
  };

  return GalleryCommon;

})();

//# sourceMappingURL=gallery_common.js.map
