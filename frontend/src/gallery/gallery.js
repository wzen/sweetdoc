import GalleryCommon from './gallery_common';

export default class GalleryGrid {
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
    GalleryGrid.initEvent();
  });

  $('.gallery.detail').ready(function() {
    import('../run/common/run_common').then(loaded => {
      const RunCommon = loaded.default;
      // 作成者情報を表示
      RunCommon.showCreatorInfo();
      RunCommon.start();
    });
  });

  $('.gallery.full_window').ready(function() {
    Promise.all([
      import('../run/common/run_common'),
      import('../run/common/run_fullscreen')
    ]).then(([loaded, loaded2]) => {
      const RunCommon = loaded.default;
      const RunFullScreen = loaded2.default;
      // 作成者情報を表示
      RunFullScreen.showCreatorInfo();
      //if window.isMobileAccess
//      $('body').css({width: window.screen.width + 'px', height: window.screen.height + 'px'})
      RunCommon.start();
    });
  });

  $('.gallery.embed').ready(function() {
    let accessToken;
    $('.powered_thumbnail:first').off('click').on('click', e => {
      e.preventDefault();
      window.open("/", "_newwindow");
    });
    $('.play_in_embed:first').off('click').on('click', e => {
      e.preventDefault();
      accessToken = $(`#main_wrapper .${constant.Gallery.Key.GALLERY_ACCESS_TOKEN}:first`).val();
      window.location.href = `/gallery/embed_with_run?${constant.Gallery.Key.GALLERY_ACCESS_TOKEN}=${accessToken}`;
    });
    $('.play_in_site_link:first').off('click').on('click', e => {
      e.preventDefault();
      accessToken = $(`#main_wrapper .${constant.Gallery.Key.GALLERY_ACCESS_TOKEN}:first`).val();
      window.open(`/gallery/detail/${accessToken}`, "_newwindow");
    });
  });

  $('.gallery.embed_with_run').ready(function() {
    Promise.all([
      import('../run/common/run_common'),
      import('../run/common/run_fullscreen')
    ]).then(([loaded, loaded2]) => {
      const RunCommon = loaded.default;
      const RunFullScreen = loaded2.default;
      // 作成者情報を表示
      RunFullScreen.showCreatorInfo();
      RunCommon.start();
    });
  });
});


