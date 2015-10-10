// Generated by CoffeeScript 1.10.0
var GallerySidebar;

GallerySidebar = (function() {
  var constant;

  function GallerySidebar() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    GallerySidebar.USER = constant.Gallery.Sidebar.USER;
    GallerySidebar.VIEW = constant.Gallery.Sidebar.VIEW;
    GallerySidebar.SEARCH = constant.Gallery.Sidebar.SEARCH;
    GallerySidebar.LOGO = constant.Gallery.Sidebar.LOGO;
  }

  GallerySidebar.initMenu = function() {
    var _type, root;
    root = $('#sidebar_wrapper');
    _type = function() {
      var type;
      type = '';
      if ($(this).hasClass(GallerySidebar.USER)) {
        type = GallerySidebar.USER;
      } else if ($(this).hasClass(GallerySidebar.VIEW)) {
        type = GallerySidebar.VIEW;
      } else if ($(this).hasClass(GallerySidebar.SEARCH)) {
        type = GallerySidebar.SEARCH;
      } else if ($(this).hasClass(GallerySidebar.LOGO)) {
        type = GallerySidebar.LOGO;
      }
      return "." + type;
    };
    $('.wrapper .circle', root).hover(function(e) {
      var type;
      type = _type.call(this);
      if (!$("#gallery_contents_wrapper .sidebar_popup" + type).is(':visible')) {
        return $(this).stop().animate({
          opacity: 0.7
        }, 200, 'linear');
      }
    }, function(e) {
      var type;
      type = _type.call(this);
      if (!$("#gallery_contents_wrapper .sidebar_popup" + type).is(':visible')) {
        return $(this).stop().animate({
          opacity: 0.3
        }, 100, 'linear');
      }
    });
    return $('.wrapper .circle', root).click(function(e) {
      var popup, self, type;
      type = _type.call(this);
      popup = $("#gallery_contents_wrapper .sidebar_popup" + type);
      if (popup.is(':visible')) {
        type = _type.call(this);
        popup.stop(true, true).fadeOut(100, 'linear');
        return $(this).stop().animate({
          opacity: 0.7
        }, 100, 'linear');
      } else {
        $("#gallery_contents_wrapper .sidebar_popup").hide();
        self = $(this);
        $('.wrapper .circle', root).filter(function(s) {
          return $(this).attr('class') !== self.attr('class');
        }).css('opacity', 0.3);
        popup.stop(true, true).fadeIn(200, 'linear');
        return $(this).stop().animate({
          opacity: 1
        }, 200, 'linear');
      }
    });
  };

  GallerySidebar.addArrowClass = function(e, popup) {
    var wrapper;
    wrapper = popup.find('.wrapper');
    if (e.hasClass(this.USER)) {
      return wrapper.removeClass('arrow_middle arrow_bottom').addClass('arrow_top');
    } else if (e.hasClass(this.LOGO)) {
      return wrapper.removeClass('arrow_top arrow_middle').addClass('arrow_bottom');
    } else {
      return wrapper.removeClass('arrow_top arrow_bottom').addClass('arrow_middle');
    }
  };

  return GallerySidebar;

})();

$(function() {
  return GallerySidebar.initMenu();
});

//# sourceMappingURL=gallery_sidebar.js.map
