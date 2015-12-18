// Generated by CoffeeScript 1.9.2
var GalleryGrid;

GalleryGrid = (function() {
  function GalleryGrid() {}

  GalleryGrid.initEvent = function() {
    return this.initContentsHover();
  };

  GalleryGrid.initContentsHover = function() {
    $('.grid_contents_wrapper').off('mouseenter');
    $('.grid_contents_wrapper').on('mouseenter', function(e) {
      e.preventDefault();
      return $(this).find('.hover_overlay').stop(true, true).fadeIn('100');
    });
    $('.grid_contents_wrapper').off('mouseleave');
    $('.grid_contents_wrapper').on('mouseleave', function(e) {
      e.preventDefault();
      return $(this).find('.hover_overlay').stop(true, true).fadeOut('300');
    });
    $('.new_window').off('click');
    return $('.new_window').on('click', function(e) {
      var left, root, size, target, top;
      e.preventDefault();
      e.stopPropagation();
      root = $(this).closest('.grid_contents_wrapper');
      size = {
        width: root.find("." + Constant.Gallery.Key.SCREEN_SIZE_WIDTH).val(),
        height: root.find("." + Constant.Gallery.Key.SCREEN_SIZE_HEIGHT).val()
      };
      left = Number((window.screen.width - size.width) / 2);
      top = Number((window.screen.height - size.height) / 2);
      target = "_runwindow";
      window.open("about:blank", target, "top=" + top + ",left=" + left + ",width=" + size.width + ",height=" + size.height + ",menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no");
      document.send_form.action = '/gallery/detail/w/' + root.find("." + Constant.Gallery.Key.GALLERY_ACCESS_TOKEN).val();
      document.send_form.target = target;
      return setTimeout(function() {
        return document.send_form.submit();
      }, 200);
    });
  };

  return GalleryGrid;

})();

$(function() {
  window.isMotionCheck = false;
  window.isItemPreview = false;
  GalleryCommon.initView();
  $('.gallery.index').ready(function() {
    return console.log('home#index');
  });
  $('.gallery.grid').ready(function() {
    GalleryCommon.initGridView();
    return GalleryGrid.initEvent();
  });
  return $('.gallery.detail, .gallery.run_window').ready(function() {
    RunFullScreen.showCreatorInfo();
    return RunCommon.start();
  });
});

//# sourceMappingURL=gallery.js.map
