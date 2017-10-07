/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class GalleryCommon {
  // ビュー初期化
  static initView() {
    // 変数初期化
    this.initCommonVar();
    // リサイズ
    return this.initResize();
  }

  static initCommonVar() {
    window.mainGalleryWrapper = $('#main_gallery_wrapper');
    window.galleryContentsWrapper = $('#gallery_contents_wrapper');
    return window.gridWrapper = $('#grid_wrapper');
  }

  // グリッド初期化
  static initGridView(callback = null) {
    // Masonry初期化
    this.addGridContentsStyle($('.grid_contents_wrapper'));
    return this.setupMasonry(this.windowWidthType());
  }

  static setupMasonry(windowWidthType) {
    const columnWidth = windowWidthType === 0 ? 100 : 180;
    //console.log('columnWidth:' + columnWidth)
    const $grid = $('#grid_wrapper');
    if($grid.data('masonry') != null) {
      $grid.masonry('destroy');
    }
    $grid.masonry({
      itemSelector: '.grid_contents_wrapper',
      columnWidth,
      isAnimated: true,
      animationOptions: {
        duration: 400
      },
      isFitWidth: true
    });
    // 描画後イベント
    $grid.one('layoutComplete', () => {
      // 描画実行
      return this.showAllGrid();
    });
    // 描画実行
    return $grid.masonry('layout');
  }

  // リサイズ初期化
  static initResize() {
    $(window).resize(() => {
      GalleryCommon.resizeMainContainerEvent();
      const wt = this.windowWidthType();
      if(window.nowWindowWidthType !== wt) {
        this.setupMasonry(wt);
        return window.nowWindowWidthType = wt;
      }
    });
    return window.nowWindowWidthType = this.windowWidthType();
  }

  static initContentsHover() {
    $('.grid_contents_wrapper').off('mouseenter').on('mouseenter', function(e) {
      e.preventDefault();
      return $(this).find('.hover_overlay').stop(true, true).fadeIn('100');
    });
    return $('.grid_contents_wrapper').off('mouseleave').on('mouseleave', function(e) {
      e.preventDefault();
      return $(this).find('.hover_overlay').stop(true, true).fadeOut('300');
    });
  }

  static initLoadMoreButtonEvent() {
    return $(".footer_button > button").click(() => {
      if((window.contentsTakeCount == null) || (window.contentsTotalCount == null)) {
        $('#footer_button_wrapper').hide();
        Common.hideModalView(true);
        return false;
      }
      if((window.gridPage == null)) {
        window.gridPage = 1;
      }
      Common.showModalFlashMessage('Loading...');
      const data = {};
      data['page'] = window.gridPage;
      data[constant.Gallery.Key.FILTER] = this.getFilterType();
      $.ajax(
        {
          url: "/gallery/grid_ajax",
          type: "GET",
          dataType: "html",
          data,
          success(data) {
            if(data != null) {
              const d = GalleryCommon.addGridContentsStyle($(data.trim()).filter('.grid_contents_wrapper'));
              if((d != null) && (d.length > 0)) {
                const $grid = $('#grid_wrapper');
                $grid.append(d).masonry('appended', d);
                window.contentsTakeCount += d.length;
                if(window.contentsTakeCount >= window.contentsTotalCount) {
                  $('#footer_button_wrapper').hide();
                }
                window.gridPage += 1;
              } else {
                $('#footer_button_wrapper').hide();
              }
              return Common.hideModalView(true);
            } else {
              console.log('/gallery/grid_ajax server error');
              Common.ajaxError(data);
              return Common.hideModalView(true);
            }
          },
          error(data) {
            console.log('/gallery/grid_ajax ajax error');
            Common.ajaxError(data);
            return Common.hideModalView(true);
          }
        }
      );
      return false;
    });
  }

  static getFilterType() {
    const locationPaths = window.location.href.split('/');
    const l = locationPaths[locationPaths.length - 1].split('?');
    if(l.length < 2) {
      // フィルタ無し
      return null;
    } else {
      const params = l[1].split('&');
      let ret = null;
      for(let param of Array.from(params)) {
        const p = param.split('=');
        if(p[0] === constant.Gallery.Key.FILTER) {
          ret = p[1];
          break;
        }
      }
      return ret;
    }
  }

  // 画面サイズ設定
  static resizeMainContainerEvent() {
  }

  static windowWidthType() {
    const w = $(window).width();
    // SCSSのmediaMaxWidth1と合わせる
    const mediaMaxWidth1 = 699;
    if(w <= mediaMaxWidth1) {
      return 0;
    } else {
      return 1;
    }
  }

  // グリッド表示
  static showAllGrid() {
    return $('#grid_wrapper').find('.grid_contents_wrapper').css('opacity', '');
  }

  static showWithFullScreen(e) {
    e = e || window.event;
    const rootTarget = e.target || e.srcElement;
    e.preventDefault();
    e.stopPropagation();
    const root = $(rootTarget);
    const target = "_runwindow";
    // 実行確認ページを新規ウィンドウで表示
    const width = root.find(`.${constant.Gallery.Key.SCREEN_SIZE_WIDTH}`).val();
    const height = root.find(`.${constant.Gallery.Key.SCREEN_SIZE_HEIGHT}`).val();
    if((width != null) && (height != null)) {
      // スクリーンサイズが指定されている場合
      const size = {
        width,
        height
      };
      const left = Number((window.screen.width - size.width) / 2);
      const top = Number((window.screen.height - (size.height)) / 2);
      window.open("about:blank", target, `top=${top},left=${left},width=${size.width},height=${size.height},menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no`);
    } else {
      window.open("about:blank", target, "menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no");
    }
    document.send_form.action = `/gallery/detail/w/${root.find(`.${constant.Gallery.Key.GALLERY_ACCESS_TOKEN}`).val()}`;
    document.send_form.target = target;
    return setTimeout(() => document.send_form.submit()
      , 200);
  }

  static addBookmark(note, callback = null) {
    const data = {};
    data[constant.Gallery.Key.GALLERY_ACCESS_TOKEN] = Common.getContentsAccessTokenFromUrl();
    data[constant.Gallery.Key.NOTE] = note;
    return $.ajax(
      {
        url: "/gallery/add_bookmark",
        type: "POST",
        dataType: "json",
        data,
        success(data) {
          if(data.resultSuccess) {
            if(callback != null) {
              return callback(true);
            }
          } else {
            console.log('/gallery/add_bookmark server error');
            Common.ajaxError(data);
            if(callback != null) {
              return callback(false);
            }
          }
        },
        error(data) {
          console.log('/gallery/add_bookmark ajax error');
          Common.ajaxError(data);
          if(callback != null) {
            return callback(false);
          }
        }
      }
    );
  }

  static removeBookmark(callback = null) {
    const data = {};
    data[constant.Gallery.Key.GALLERY_ACCESS_TOKEN] = Common.getContentsAccessTokenFromUrl();
    return $.ajax(
      {
        url: "/gallery/remove_bookmark",
        type: "POST",
        dataType: "json",
        data,
        success(data) {
          if(data.resultSuccess) {
            if(callback != null) {
              return callback(true);
            }
          } else {
            console.log('/project/remove server error');
            Common.ajaxError(data);
            if(callback != null) {
              return callback(false);
            }
          }
        },
        error(data) {
          console.log('/project/remove ajax error');
          Common.ajaxError(data);
          if(callback != null) {
            return callback(false);
          }
        }
      }
    );
  }

  static calcGridContentsSizeAndStyle(imgWidth, imgHeight) {
    let ret;
    let className = '';
    let style = null;
    let w = 180 - (3 * 2);
    let h = 180 - 20 - (3 * 2);
    const r = parseInt(Math.random() * 15);
    if(r === 0) {
      className = 'grid-item-width2 grid-item-height2';
      w *= 2;
      h *= 2;
    } else if((r === 1) || (r === 2)) {
      className = 'grid-item-width2';
      w *= 2;
    } else if((r === 3) || (r === 4)) {
      className = 'grid-item-height2';
      h *= 2;
    }

    if((imgHeight / imgWidth) > (h / w)) {
      style = 'width:100%;height:auto;';
    } else {
      style = 'width:auto;height:100%;';
    }
    if(((imgWidth / imgHeight) > 1.5) && (className === 'grid-item-height2')) {
      ret = this.calcGridContentsSizeAndStyle(imgWidth, imgHeight);
      ({className} = ret);
      ({style} = ret);
    } else if(((imgHeight / imgWidth) > 1.5) && (className === 'grid-item-width2')) {
      ({className} = ret);
      ({style} = ret);
    }
    return {className, style};
  }

  static addGridContentsStyle(contents) {
    return contents.each((idx, content) => {
      if($(content).attr('class').split(' ').length <= 2) {
        const w = $(content).find(`.${constant.Gallery.Key.THUMBNAIL_IMG_WIDTH}:first`).val();
        const h = $(content).find(`.${constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT}:first`).val();
        const calcStyle = this.calcGridContentsSizeAndStyle(w, h);
        $(content).addClass(calcStyle.className);
        return $(content).find('.thumbnail_img:first').attr('style', calcStyle.style);
      }
    });
  }
}

