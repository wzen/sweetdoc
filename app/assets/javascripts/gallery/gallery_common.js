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
    var grid;
    if (callback == null) {
      callback = null;
    }
    grid = new Masonry('#grid_wrapper', {
      itemSelector: '.grid_contents_wrapper',
      columnWidth: 180,
      isAnimated: true,
      animationOptions: {
        duration: 400
      },
      isFitWidth: true
    });
    grid.on('layoutComplete', (function(_this) {
      return function() {
        return _this.showAllGrid();
      };
    })(this));
    return grid.layout();
  };

  GalleryCommon.initResize = function() {
    return $(window).resize(function() {
      return GalleryCommon.resizeMainContainerEvent();
    });
  };

  GalleryCommon.resizeMainContainerEvent = function() {};

  GalleryCommon.showAllGrid = function() {
    return $('#grid_wrapper').find('.grid_contents_wrapper:hidden').show();
  };

  return GalleryCommon;

})();

//# sourceMappingURL=gallery_common.js.map
