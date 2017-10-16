let constant = undefined;
export default class GallerySidebar {
  static initClass() {
    // 定数
    constant = gon.const;
    this.USER = constant.Gallery.Sidebar.USER;
    this.WORKTABLE = constant.Gallery.Sidebar.WORKTABLE;
    this.VIEW = constant.Gallery.Sidebar.VIEW;
    this.SEARCH = constant.Gallery.Sidebar.SEARCH;
    this.LOGO = constant.Gallery.Sidebar.LOGO;
  }

  static initMenu() {
    const root = $('#sidebar_wrapper');

    const _type = function() {
      let type = '';
      if($(this).hasClass(GallerySidebar.USER)) {
        type = GallerySidebar.USER;
      } else if($(this).hasClass(GallerySidebar.WORKTABLE)) {
        type = GallerySidebar.WORKTABLE;
      } else if($(this).hasClass(GallerySidebar.VIEW)) {
        type = GallerySidebar.VIEW;
      } else if($(this).hasClass(GallerySidebar.SEARCH)) {
        type = GallerySidebar.SEARCH;
      } else if($(this).hasClass(GallerySidebar.LOGO)) {
        type = GallerySidebar.LOGO;
      }
      return `.${type}`;
    };

    $('.wrapper .circle', root).hover(function(e) {
        const type = _type.call(this);
        if(!$(`#sidebar_wrapper .sidebar_popup${type}`).is(':visible')) {
          return $(this).stop().animate({opacity: 1}, 200, 'linear');
        }
      }
      , function(e) {
        const type = _type.call(this);
        if(!$(`#sidebar_wrapper .sidebar_popup${type}`).is(':visible')) {
          return $(this).stop().animate({opacity: 0.7}, 100, 'linear');
        }
      });

    return $(`.wrapper .circle.${GallerySidebar.SEARCH}`, root).click(function(e) {
      let type = _type.call(this);
      const popup = $(`#sidebar_wrapper .sidebar_popup${type}`);
      if(popup.is(':visible')) {
        type = _type.call(this);
        popup.stop(true, true).fadeOut(100, 'linear');
        $(this).stop().animate({opacity: 1}, 100, 'linear');
        return $('.overlay').remove();
      } else {
        $("#sidebar_wrapper .sidebar_popup").hide();
        $('.wrapper .circle', root).filter(function(s) {
          return $(this).attr('class') !== $(this).attr('class');
        }).css('opacity', 0.7);
        popup.stop(true, true).fadeIn(200, 'linear');
        $(this).stop().animate({opacity: 1}, 200, 'linear');
        $('.sidebar_overlay_parent').append('<div class="overlay"></div>');
        return $('.overlay').click(function() {
          $('.wrapper .circle', root).css('opacity', 0.7);
          $("#sidebar_wrapper .sidebar_popup").fadeOut(100);
          return $('.overlay').remove();
        });
      }
    });
  }
};
GallerySidebar.initClass();

$(() => GallerySidebar.initMenu());
