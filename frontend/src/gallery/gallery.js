/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class GalleryGrid {

  static initEvent() {
    GalleryCommon.initContentsHover();
    return GalleryCommon.initLoadMoreButtonEvent();
  }
}

$(function() {
  window.isMotionCheck = false;
  window.isItemPreview = false;

  // ビュー初期化
  GalleryCommon.initView();

  $('.gallery.index').ready(function() {
  });

  $('.gallery.grid').ready(function() {
    // グリッドビュー初期化
    GalleryCommon.initGridView();
    // イベント設定
    return GalleryGrid.initEvent();
  });

  $('.gallery.detail').ready(function() {
    // 作成者情報を表示
    RunCommon.showCreatorInfo();
    return RunCommon.start();
  });

  $('.gallery.full_window').ready(function() {
    // 作成者情報を表示
    RunFullScreen.showCreatorInfo();
    //if window.isMobileAccess
//      $('body').css({width: window.screen.width + 'px', height: window.screen.height + 'px'})
    return RunCommon.start();
  });

  $('.gallery.embed').ready(function() {
    let accessToken;
    $('.powered_thumbnail:first').off('click').on('click', e => {
      e.preventDefault();
      return window.open("/", "_newwindow");
    });
    $('.play_in_embed:first').off('click').on('click', e => {
      e.preventDefault();
      accessToken = $(`#main_wrapper .${constant.Gallery.Key.GALLERY_ACCESS_TOKEN}:first`).val();
      return window.location.href = `/gallery/embed_with_run?${constant.Gallery.Key.GALLERY_ACCESS_TOKEN}=${accessToken}`;
    });
    return $('.play_in_site_link:first').off('click').on('click', e => {
      e.preventDefault();
      accessToken = $(`#main_wrapper .${constant.Gallery.Key.GALLERY_ACCESS_TOKEN}:first`).val();
      return window.open(`/gallery/detail/${accessToken}`, "_newwindow");
    });
  });

  return $('.gallery.embed_with_run').ready(function() {
    // 作成者情報を表示
    RunFullScreen.showCreatorInfo();
    return RunCommon.start();
  });
});


