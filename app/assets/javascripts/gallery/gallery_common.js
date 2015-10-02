// Generated by CoffeeScript 1.9.2
var GalleryCommon;

GalleryCommon = (function() {
  function GalleryCommon() {}

  GalleryCommon.initView = function() {
    this.initCommonVar();
    this.initResize();
    return this.initGridView();
  };

  GalleryCommon.initCommonVar = function() {
    window.mainGalleryWrapper = $('#main_gallery_wrapper');
    window.galleryContentsWrapper = $('#gallery_contents_wrapper');
    return window.gridWrapper = $('#grid_wrapper');
  };

  GalleryCommon.initGridView = function() {
    return window.gridWrapper.masonry({
      itemSelector: '.grid_contents_wrapper',
      columnWidth: 380,
      isFitWidth: true
    });
  };

  GalleryCommon.initResize = function() {
    return $(window).resize(function() {
      return GalleryCommon.resizeMainContainerEvent();
    });
  };

  GalleryCommon.resizeMainContainerEvent = function() {};

  return GalleryCommon;

})();

//# sourceMappingURL=gallery_common.js.map