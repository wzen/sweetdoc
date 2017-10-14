/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS202: Simplify dynamic range loops
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// アプリ内の共通メソッドクラス
{
  const Common = class Common {
    static initClass() {
      constant = gon.const;
      // @property [String] MAIN_TEMP_ID mainコンテンツテンプレート
      this.MAIN_TEMP_ID = constant.ElementAttribute.MAIN_TEMP_ID;

      _showModalFlashMessage = function(message, isModalFlush = false, immediately = true, enableOverlayClose = false) {
        const type = constant.ModalViewType.FLASH_MESSAGE;
        _showModalView.call(this, type, null, isModalFlush, {}, function() {
          $("body").append('<div id="modal-overlay"></div>');
          $("#modal-overlay").show();
          // センタリング
          Common.modalCentering.call(this, type);
          const emt = $('body').children(`.modal-content.${type}`);
          emt.find('.message_contents').html(message);
          // ビューの高さ
          emt.css('max-height', $(window).height() * Constant.ModalView.HEIGHT_RATE);
          if(immediately) {
            emt.show();
            window.modalRun = false;
          } else {
            emt.fadeIn('fast', () => window.modalRun = false);
          }
          $("#modal-overlay,#modal-close").unbind().click(function() {
            if(enableOverlayClose) {
              Common.hideModalView();
            }
          });
        });
      };

      // モーダルビュー表示
      // @param [Integer] type モーダルビュータイプ
      // @param [Function] prepareShowFunc 表示前処理
      _showModalView = function(type, prepareShowFunc, prepareShowFuncParams, isModalFlush, showFunc = null) {
        if(!isModalFlush && (window.modalRun !== null) && window.modalRun) {
          // 処理中は反応なし
          return;
        }

        window.modalRun = true;
        setTimeout(() => window.modalRun = false
          , 3000);

        let emt = $('body').children(`.modal-content.${type}`);
        const allEmt = $('body').children(".modal-content");

        if(emt.length !== allEmt.length) {
          // 表示中のモーダルを非表示
          this.hideModalView(true);
          emt = $('body').children(`.modal-content.${type}`);
        }

        $(this).blur();
        if($("#modal-overlay")[0] !== null) {
          return false;
        }

        // 表示
        const _show = function() {
          if(showFunc !== null) {
            return showFunc();
          }
        };

        // 表示内容読み込み済みの場合はサーバアクセスなし
        if((emt === null) || (emt.length === 0)) {
          // サーバから表示内容読み込み
          // ローディング表示
          _showModalFlashMessage.call(this, 'Please Wait', true);
          $.ajax(
            {
              url: "/modal_view/show",
              type: "GET",
              data: {
                type
              },
              dataType: "json",
              success: data => {
                if(data.resultSuccess) {
                  Common.hideModalView(true);
                  $('body').append(data.modalHtml);
                  emt = $('body').children(`.modal-content.${type}`);
                  emt.hide();
                  if(prepareShowFunc !== null) {
                    return prepareShowFunc(emt, prepareShowFuncParams, () => {
                      return _show.call(this);
                    });
                  } else {
                    console.log('/modal_view/show server error');
                    Common.hideModalView(true);
                    _show.call(this);
                    Common.ajaxError(data);
                    return window.modalRun = false;
                  }
                }
              },
              error(data) {
                Common.hideModalView(true);
                console.log('/modal_view/show ajax error');
                Common.ajaxError(data);
                return window.modalRun = false;
              }
            }
          );
        } else {
          if(prepareShowFunc !== null) {
            return prepareShowFunc(emt, prepareShowFuncParams, () => {
              return _show.call(this);
            });
          } else {
            return _show.call(this);
          }
        }
      };
    }

    // ブラウザ対応のチェック
    // @return [Boolean] 処理結果
    static checkBlowserEnvironment() {
      if(!localStorage) {
        return false;
      } else {
        try {
          localStorage.setItem('test', 'test');
          const c = localStorage.getItem('test');
          localStorage.removeItem('test');
        } catch(e) {
          return false;
        }
      }
      // ⇣ 現在使用していないためコメントアウト 後に対応させる
      //    if !File
      //      return false
      //    if !window.URL
      //      return false
      return true;
    }

    // イベントのIDを作成
    // @return [Int] 生成したID
    static generateId() {
      const numb = 10; //10文字
      let RandomString = '';
      const BaseString = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      const n = 62;
      for(let i = 0, end = numb, asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
        RandomString += BaseString.charAt(Math.floor(Math.random() * n));
      }
      return RandomString;
    }

    // オブジェクトの比較
    static isEqualObject(obj1, obj2) {
      var _func = function(o1, o2) {
        if(typeof o1 !== typeof o2) {
          return false;
        } else if(typeof o1 !== 'object') {
          return o1 === o2;
        } else {
          if(Object.keys(o1).length !== Object.keys(o2).length) {
            return false;
          }
          let ret = true;
          for(let k in o1) {
            const v = o1[k];
            if(_func(v, o2[k]) === false) {
              ret = false;
              break;
            }
          }
          return ret;
        }
      };
      return _func(obj1, obj2);
    }

    // オブジェクトがHTML要素か判定
    static isElement(obj) {
      return (typeof obj === "object") && (obj.length === 1) && (obj.get !== null) && (obj.get(0).nodeType === 1) && (typeof obj.get(0).style === "object") && (typeof obj.get(0).ownerDocument === "object");
    }

    static ajaxError(responseData) {
      if(responseData.status === '422') {
        // 再表示
        return location.reload(false);
      }
    }

    // requestAnimationFrameラッパー
    static requestAnimationFrame() {
      let originalWebkitRequestAnimationFrame = undefined;
      let wrapper = undefined;
      const callback = undefined;
      let geckoVersion = 0;
      const {userAgent} = navigator;
      let index = 0;

      if(window.webkitRequestAnimationFrame) {
        wrapper = time => {
          if((time === null)) {
            time = +new Date();
          }
          return this.callback(time);
        };

        originalWebkitRequestAnimationFrame = window.webkitRequestAnimationFrame;
        window.webkitRequestAnimationFrame = (callback, element) => {
          this.callback = callback;
          return originalWebkitRequestAnimationFrame(wrapper, element);
        };
      }

      if(window.mozRequestAnimationFrame) {
        index = userAgent.indexOf('rv:');

        if(userAgent.indexOf('Gecko') !== -1) {
          geckoVersion = userAgent.substr(index + 3, 3);
          if(geckoVersion === '2.0') {
            window.mozRequestAnimationFrame = undefined;
          }
        }
      }

      return window.requestAnimationFrame ||
        window.webkitRequestAnimationFrame ||
        window.mozRequestAnimationFrame ||
        window.oRequestAnimationFrame ||
        window.msRequestAnimationFrame;
    }

    // Pagevalueから環境を反映
    static applyEnvironmentFromPagevalue() {
      // タイトル名設定
      Common.setTitle(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_NAME));
      // 画面サイズ設定
      this.initScreenSize();
      // スケール設定
      this.applyViewScale();
      // スクロール位置設定
      return this.initScrollContentsPosition();
    }

    // 環境の反映をリセット
    static resetEnvironment() {
      Common.setTitle('');
      return this.initScreenSize(true);
    }

    // タイトルを設定
    static setTitle(title_name) {
      if(title_name !== null) {
        Navbar.setTitle(title_name);
        if(!window.isWorkTable) {
          return RunCommon.setTitle(title_name);
        }
      }
    }

    // スクリーンサイズを取得
    static getScreenSize() {
      if(this.isFixedScreenSize()) {
        return PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
      } else {
        // 画面を指定していない場合はMainWrapperビューの画面サイズを返す
        //      scale = @getViewScale()
        //      return {width: window.mainWrapper.width() / scale, height: window.mainWrapper.height() / scale}
        const width = $('#main').width();
        const height = $('#main').height();
        return {width, height};
      }
    }


    // プロジェクト表示サイズ設定
    static initScreenSize(reset) {
      if(reset === null) {
        reset = false;
      }
      if(reset) {
        // プロジェクトビュー & タイムラインを閉じる
        $('#project_wrapper').hide();
        $('#timeline').hide();
        PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {});
      } else {
        if(!window.isWorkTable && this.isFixedScreenSize()) {
          // 画面サイズ指定
          const size = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
          const css = {
            width: size.width,
            height: size.height
          };
          $('#project_wrapper').css(css);
        } else {
          // 画面サイズは親ビューに合わせる
          $('#project_wrapper').removeAttr('style');
        }
        // プロジェクトビュー & タイムラインを表示
        $('#project_wrapper').show();
        $('#timeline').show();
      }
      // サイズを保存
      this.saveMainWrapperSize();
      // Canvasサイズ更新
      return this.updateCanvasSize();
    }

    // 画面サイズが指定されているか
    static isFixedScreenSize() {
      // ScreenSizeデータが存在すれば指定
      const size = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
      return (size !== null) && size.width && size.height;
    }

    static saveMainWrapperSize() {
      if(window.mainWrapper !== null) {
        return window.mainWrapperSize = {
          width: window.mainWrapper.width(),
          height: window.mainWrapper.height()
        };
      }
    }

    // スクロール位置初期化
    static initScrollContentsPosition() {
      const updateByInitConfig = false;
      if(!window.isWorkTable && ScreenEvent.hasInstanceCache()) {
        // Run & ScreenEventインスタンス有り
        let size;
        const se = new ScreenEvent();
        if(se.hasInitConfig()) {
          se.setEventBaseXAndY(se.initConfigX, se.initConfigY);
          size = this.convertCenterCoodToSize(se.initConfigX, se.initConfigY, se.initConfigScale);
        } else {
          // initConfigが無い場合は画面中央に設定
          size = this.convertCenterCoodToSize(0, 0, 1.0);
        }
        const scrollContentsSize = Common.scrollContentsSizeUnderViewScale();
        return this.updateScrollContentsPosition(size.top + (scrollContentsSize.height * 0.5), size.left + (scrollContentsSize.width * 0.5), true, false);
      } else {
        // ワークテーブルの倍率を設定
        return this.initScrollContentsPositionByWorktableConfig();
      }
    }

    // Worktableの設定を使用してスクロール位置初期化
    static initScrollContentsPositionByWorktableConfig() {
      const position = PageValue.getWorktableScrollContentsPosition();
      if(position !== null) {
        // Worktableの画面状態にセット
        return this.updateScrollContentsPosition(position.top, position.left);
      } else {
        // デフォルトの画面中央にセット
        return this.resetScrollContentsPositionToCenter();
      }
    }

    // 左上座標から中心座標を計算(例 15000 -> 0)
    static calcScrollCenterPosition(top, left) {
      const screenSize = this.getScreenSize();
      const t = top - ((window.scrollInsideWrapper.height() + screenSize.height) * 0.5);
      const l = left - ((window.scrollInsideWrapper.width() + screenSize.width) * 0.5);
      return {top: t, left: l};
    }

    // 中心座標から左上座標を計算(例 0 -> 15000)
    static calcScrollTopLeftPosition(top, left) {
      const screenSize = this.getScreenSize();
      const t = top + ((window.scrollInsideWrapper.height() + screenSize.height) * 0.5);
      const l = left + ((window.scrollInsideWrapper.width() + screenSize.width) * 0.5);
      return {top: t, left: l};
    }

    // アイテムの中心座標(Worktable中心が0の場合)を計算
    static calcItemCenterPositionInWorktable(itemSize) {
      const p = PageValue.getWorktableScrollContentsPosition();
      const cp = this.calcScrollCenterPosition(p.top, p.left);
      const itemCenterPosition = {x: itemSize.x + (itemSize.w * 0.5), y: itemSize.y + (itemSize.h * 0.5)};
      const diff = {x: p.left - itemCenterPosition.x, y: p.top - itemCenterPosition.y};
      return {top: cp.top - diff.y, left: cp.left - diff.x};
    }

    // アイテムの中心座標から実座標を計算(calcItemCenterPositionInWorktableの逆)
    static calcItemScrollContentsPosition(centerPosition, itemWidth, itemHeight) {
      const p = PageValue.getWorktableScrollContentsPosition();
      const cp = this.calcScrollCenterPosition(p.top, p.left);
      const diff = {x: cp.left - centerPosition.x, y: cp.top - centerPosition.y};
      const itemCenterPosition = {x: p.left - diff.x, y: p.top - diff.y};
      return {left: itemCenterPosition.x - (itemWidth * 0.5), top: itemCenterPosition.y - (itemHeight * 0.5)};
    }

    static convertCenterCoodToSize(x, y, scale) {
      const screenSize = Common.getScreenSize();
      const width = screenSize.width / scale;
      const height = screenSize.height / scale;
      const top = y - (height * 0.5);
      const left = x - (width * 0.5);
      return {top, left, width, height};
    }

    // 画面スケールの取得
    static getViewScale() {
      if((window.isItemPreview !== null) && window.isItemPreview) {
        return 1.0;
      } else if(window.isWorkTable && !window.previewRunning) {
        // ワークテーブルの倍率
        return WorktableCommon.getWorktableViewScale();
      } else {
        let scaleFromViewRate = window.runScaleFromViewRate;
        if(window.isWorkTable && window.previewRunning) {
          // プレビューではプロジェクトのビューは縮めないため、倍率は1.0固定
          scaleFromViewRate = 1.0;
        }
        let seScale = 1.0;
        if(ScreenEvent.hasInstanceCache()) {
          const se = new ScreenEvent();
          seScale = se.getNowScreenEventScale();
        }
        // プロジェクトビューの倍率 x 画面内の倍率
        return scaleFromViewRate * seScale;
      }
    }

    // 画面スケール適用
    static applyViewScale() {
      let updateMainWrapperPercent;
      let scale = this.getViewScale();
      if(scale === 0.0) {
        return;
      }
      scale = Math.round((scale * 100)) / 100;
      if(window.isWorkTable || (scale <= 1.0)) {
        updateMainWrapperPercent = 100 / scale;
      } else {
        updateMainWrapperPercent = 100;
      }
      // キャンパスサイズ更新
      this.updateCanvasSize();
      return window.mainWrapper.css({
        transform: `scale(${scale}, ${scale})`,
        width: `${updateMainWrapperPercent}%`,
        height: `${updateMainWrapperPercent}%`
      });
    }

    static scrollContentsSizeUnderViewScale() {
      let w = window.scrollContents.width();
      const h = window.scrollContents.height();
      if(!window.isWorkTable && (w <= 0)) {
        // 幅0 (ページ遷移前のビューが閉じている状態)の時はScreenから取得
        const screen = this.getScreenSize();
        if(screen !== null) {
          const borderPadding = 5 * 2;
          const scaleFromViewRate = window.runScaleFromViewRate;
          w = (screen.width * scaleFromViewRate) - borderPadding;
        }
      }
      let scale = this.getViewScale();
      if(window.isWorkTable) {
        // FIXME: 上のgetViewScaleを使用する場合、諸々の計算修正が必要になるため現状1.0で固定する
        scale = 1.0;
      }
      return {
        width: w / scale,
        height: h / scale
      };
    }

    // Canvasサイズ更新
    static updateCanvasSize() {
      if(window.drawingCanvas !== null) {
        const scale = this.getViewScale();
        $(window.drawingCanvas).attr('width', $('#pages').width() / scale);
        return $(window.drawingCanvas).attr('height', $('#pages').height() / scale);
      }
    }

    // リサイズイベント設定
    static initResize(resizeEvent = null) {
      return $(window).resize(function() {
        // モーダル中央寄せ
        Common.modalCentering();
        if(resizeEvent !== null) {
          return resizeEvent();
        }
      });
    }

    // オブジェクトの複製
    // @param [Object] obj 複製対象オブジェクト
    // @return [Object] 複製後オブジェクト
    static makeClone(obj) {
      if((obj === null) || (typeof obj !== 'object')) {
        return obj;
      }
      if(obj instanceof Date) {
        return new Date(obj.getTime());
      }
      if(obj instanceof RegExp) {
        let flags = '';
        if(obj.global !== null) {
          flags += 'g';
        }
        if(obj.ignoreCase !== null) {
          flags += 'i';
        }
        if(obj.multiline !== null) {
          flags += 'm';
        }
        if(obj.sticky !== null) {
          flags += 'y';
        }
        return new RegExp(obj.source, flags);
      }
      const newInstance = new obj.constructor();
      for(let key in obj) {
        newInstance[key] = clone(obj[key]);
      }
      return newInstance;
    }

    // Mainコンテナを作成
    // @param [Integer] pageNum ページ番号
    // @param [Boolean] collapsed 初期表示でページを閉じた状態にするか
    // @return [Boolean] ページを作成したか
    static createdMainContainerIfNeeded(pageNum, collapsed) {
      if(collapsed === null) {
        collapsed = false;
      }
      const root = $(`#${constant.Paging.ROOT_ID}`);
      const sectionClass = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
      const pageSection = $(`.${sectionClass}`, root);
      if((pageSection === null) || (pageSection.length === 0)) {
        // Tempからコピー
        let temp = $(`#${Common.MAIN_TEMP_ID}`).children(':first').clone(true);
        let style = '';
        style += `z-index:${Common.plusPagingZindex(0, pageNum)};`;
        // TODO: pageflipを変更したら修正すること
        const width = collapsed ? 'width: 0px;' : '';
        style += width;
        temp = $(temp).wrap(`<div class='${sectionClass} section' style='${style}'></div>`).parent();
        root.append(temp);
        return true;
      } else {
        return false;
      }
    }

    // Mainコンテナを削除
    // @param [Integer] pageNum ページ番号
    static removeMainContainer(pageNum) {
      const root = $(`#${constant.Paging.ROOT_ID}`);
      const sectionClass = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum);
      return $(`.${sectionClass}`, root).remove();
    }

    // ページ内のインスタンスを取得
    static instancesInPage(pn, withCreateInstance, withInitFromPageValue) {
      if(pn === null) {
        pn = PageValue.getPageNum();
      }
      if(withCreateInstance === null) {
        withCreateInstance = false;
      }
      if(withInitFromPageValue === null) {
        withInitFromPageValue = false;
      }
      const ret = [];
      const instances = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pn));
      for(let key in instances) {
        var obj;
        const instance = instances[key];
        const {value} = instance;
        if(withCreateInstance) {
          obj = Common.getInstanceFromMap(value.id, value.classDistToken, withInitFromPageValue);
        } else {
          obj = window.instanceMap[value.id];
        }
        ret.push(obj);
      }
      return ret;
    }

    // ページ内のアイテムインスタンスを取得
    static itemInstancesInPage(pn, withCreateInstance, withInitFromPageValue) {
      if(pn === null) {
        pn = PageValue.getPageNum();
      }
      if(withCreateInstance === null) {
        withCreateInstance = false;
      }
      if(withInitFromPageValue === null) {
        withInitFromPageValue = false;
      }
      return $.grep(this.instancesInPage(pn, withCreateInstance, withInitFromPageValue), n => n instanceof ItemBase);
    }

    // 最初にフォーカスするアイテムオブジェクトを取得
    static firstFocusItemObj(pn) {
      // 暫定でアイテムはデフォルトでフォーカスしない
      if(pn === null) {
        pn = PageValue.getPageNum();
      }
      return true;
    }

    // NOTE: ⇣処理は残しておく
    //    objs = @itemInstancesInPage(pn)
    //    obj = null
    //    for o in objs
    //      if o.visible && o.firstFocus
    //        obj = o
    //        return obj
    //    return obj

    // アイテム用のテンプレートHTMLをwrap
    static wrapCreateItemElement(item, contents) {
      const w = `\
<div id="${item.id}" class="item draggable resizable" style="position: absolute;top:${item.itemSize.y}px;left:${item.itemSize.x}px;width:${item.itemSize.w }px;height:${item.itemSize.h}px;z-index:${Common.plusPagingZindex(item.zindex)}"><div class="item_wrapper"><div class='item_contents'></div></div></div>\
`;
      return $(contents).wrap(w).closest('.item');
    }

    // アイテムに対してフォーカスする
    // @param [Object] target 対象アイテム
    // @param [Fucntion] callback コールバック
    static focusToTarget(target, callback = null, immediate) {
      if(immediate === null) {
        immediate = false;
      }
      if((target === null) || (target.length === 0)) {
        // ターゲット無し
        return;
      }
      const focusDiff = this.focusDiff();
      if($(target).get(0).offsetParent !== null) {
        //        if window.runDebug
        //          console.log('window.runScaleFromViewRate:' + window.runScaleFromViewRate)
        //          console.log('original scrollContents.scrollTop():' + scrollContents.scrollTop())
        //          console.log('original scrollContents.scrollLeft():' + scrollContents.scrollLeft())
        //          console.log('original scrollContents.width():' + scrollContents.width())
        //          console.log('original scrollContents.height():' + scrollContents.height())
        //          console.log('$(target).get(0).offsetTop:' + $(target).get(0).offsetTop)
        //          console.log('$(target).get(0).offsetLeft:' + $(target).get(0).offsetLeft)
        //          console.log('$(target).width():' + $(target).width())
        //          console.log('$(target).height():' + $(target).height())
        const top = ($(target).height() * 0.5) + $(target).get(0).offsetTop + focusDiff.top;
        const left = ($(target).width() * 0.5) + $(target).get(0).offsetLeft + focusDiff.left;
        return this.updateScrollContentsPosition(top, left, immediate, true, callback);
      } else {
        // offsetが取得できない場合は処理なし
        if(callback !== null) {
          return callback();
        }
      }
    }

    static focusDiff() {
      let diff = {top: 0, left: 0};
      if(!window.isWorkTable && ScreenEvent.hasInstanceCache()) {
        const se = new ScreenEvent();
        if(se.getNowScreenEventScale() <= 1.0) {
          // 倍率1.0以下の場合にスクロール値に調整が必要
          const scale = this.getViewScale();
          const scrollContentsSize = this.scrollContentsSizeUnderViewScale();
          if(scrollContentsSize !== null) {
            diff = {
              top: scrollContentsSize.height * 0.5 * (1 - scale),
              left: scrollContentsSize.width * 0.5 * (1 - scale)
            };
          }
        }
      }
      //    if window.runDebug
      //      console.log('focusDiff')
      //      console.log(diff)
      return diff;
    }

    // スクロール位置の更新
    // @param [Float] top Y中央値
    // @param [Float] left X中央値
    static updateScrollContentsPosition(top, left, immediate, withUpdateScreenEventVar, callback = null) {
      if(immediate === null) {
        immediate = true;
      }
      if(withUpdateScreenEventVar === null) {
        withUpdateScreenEventVar = true;
      }
      if(isNaN(top) || isNaN(left)) {
        if(window.debug) {
          console.log('updateScrollContentsPosition isNaN');
        }
        this.resetScrollContentsPositionToCenter();
        return;
      }
      if(withUpdateScreenEventVar) {
        const focusDiff = this.focusDiff();
        this.saveDisplayPosition(top - focusDiff.top, left - focusDiff.left, true);
      }

      const scrollContentsSize = this.scrollContentsSizeUnderViewScale();
      top -= scrollContentsSize.height * 0.5;
      left -= scrollContentsSize.width * 0.5;
      if((top <= 0) && (left <= 0)) {
        // 不正なスクロールを防止
        if(window.runDebug) {
          console.log('Invalid ScrollValue');
        }
        return;
      }

      if(immediate) {
        window.skipScrollEvent = true;
        window.scrollContents.scrollTop(parseInt(top));
        window.scrollContents.scrollLeft(parseInt(left));
        if(callback !== null) {
          return callback();
        }
      } else {
        window.skipScrollEventByAnimation = true;
        const nowTop = window.scrollContents.scrollTop();
        const nowLeft = window.scrollContents.scrollLeft();
        let per = 20;
        if(isMobileAccess) {
          per = 15;
        }
        const perTop = (parseInt(top) - nowTop) / per;
        const perLeft = (parseInt(left) - nowLeft) / per;
        let count = 1;
        var _loop = function() {
          window.scrollContents.scrollTop(parseInt(nowTop + (perTop * count)));
          window.scrollContents.scrollLeft(parseInt(nowLeft + (perLeft * count)));
          count += 1;
          if(count > per) {
            window.scrollContents.scrollTop(parseInt(top));
            window.scrollContents.scrollLeft(parseInt(left));
            window.skipScrollEventByAnimation = false;
            if(callback !== null) {
              return callback();
            }
          } else {
            return requestAnimationFrame(() => {
              return _loop.call(this);
            });
          }
        };
        return requestAnimationFrame(() => {
          return _loop.call(this);
        });
      }
    }

    // スクロール位置を中心に初期化
    static resetScrollContentsPositionToCenter(withUpdateScreenEventVar) {
      if(withUpdateScreenEventVar === null) {
        withUpdateScreenEventVar = true;
      }
      const scrollContentsSize = this.scrollContentsSizeUnderViewScale();
      const top = (window.scrollInsideWrapper.height() + scrollContentsSize.height) * 0.5;
      const left = (window.scrollInsideWrapper.width() + scrollContentsSize.width) * 0.5;
      return this.updateScrollContentsPosition(top, left, true, withUpdateScreenEventVar);
    }

    // ワークテーブルの画面倍率を取得
    static getWorktableViewScale(pn) {
      if(pn === null) {
        pn = PageValue.getPageNum();
      }
      let scale = PageValue.getGeneralPageValue(PageValue.Key.worktableScale(pn));
      if((scale === null)) {
        scale = 1.0;
        if(window.isWorkTable) {
          WorktableCommon.setWorktableViewScale(scale);
        }
      }
      return parseFloat(scale);
    }

    static saveDisplayPosition(top, left, immediate, callback = null) {
      if(immediate === null) {
        immediate = true;
      }
      const _save = function() {
        if(ScreenEvent.hasInstanceCache()) {
          const se = new ScreenEvent();
          se.setEventBaseXAndY(left, top);
        }
        if(window.isWorkTable && !window.previewRunning) {
          PageValue.setWorktableScrollContentsPosition(top, left);
        }
        window.lStorage.saveAllPageValues();
        if(callback !== null) {
          return callback();
        }
      };

      if(immediate) {
        return _save.call(this);
      } else {
        if(window.scrollContentsScrollTimer !== null) {
          clearTimeout(window.scrollContentsScrollTimer);
        }
        return window.scrollContentsScrollTimer = setTimeout(function() {
            return setTimeout(() => {
                _save.call(this);
                return window.scrollContentsScrollTimer = null;
              }
              , 0);
          }
          , 500);
      }
    }

    // 画面位置をScreenEvent変数から初期化
    static updateScrollContentsFromScreenEventVar() {
      if(ScreenEvent.hasInstanceCache()) {
        const se = new ScreenEvent();
        if((se.eventBaseX !== null) && (se.eventBaseY !== null)) {
          return this.updateScrollContentsPosition(se.eventBaseY, se.eventBaseX);
        }
      }
    }

    // サニタイズ エンコード
    // @property [String] str 対象文字列
    // @return [String] 変換後文字列
    static sanitaizeEncode(str) {
      if((str !== null) && (typeof str === "string")) {
        return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
      } else {
        return str;
      }
    }

    // サニタイズ デコード
    // @property [String] str 対象文字列
    // @return [String] 変換後文字列
    static sanitaizeDecode(str) {
      if((str !== null) && (typeof str === "string")) {
        return str.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, '\'').replace(/&amp;/g, '&');
      } else {
        return str;
      }
    }

    // クラスハッシュ配列からクラスを取り出し
    // @param [Integer] dist ClassDistToken
    // @return [Object] 対象クラス
    static getClassFromMap(dist) {
      if((window.classMap === null)) {
        window.classMap = {};
      }
      let d = dist;
      if(typeof d !== "string") {
        d = String(dist);
      }
      return window.classMap[d];
    }

    // クラスをハッシュ配列に保存
    // @param [Integer] id EventIdまたはClassDistToken
    // @param [Class] value クラス
    static setClassToMap(dist, value) {
      let d = dist;
      if(typeof d !== "string") {
        d = String(dist);
      }

      if((window.classMap === null)) {
        window.classMap = {};
      }
      return window.classMap[d] = value;
    }

    // 実体のクラスを取得(共通イベントの場合はPrivateClassを参照する)
    static getContentClass(classDistToken) {
      const cls = this.getClassFromMap(classDistToken);
      if(cls.prototype instanceof CommonEvent) {
        return cls.PrivateClass;
      } else {
        return cls;
      }
    }

    // インスタンス取得
    // @param [Integer] id イベントID
    // @param [Integer] classDistToken
    // @return [Object] インスタンス
    static getInstanceFromMap(id, classDistToken, withInitFromPagevalue) {
      if(withInitFromPagevalue === null) {
        withInitFromPagevalue = true;
      }
      if(typeof id !== "string") {
        id = String(id);
      }
      Common.setInstanceFromMap(id, classDistToken, withInitFromPagevalue);
      return window.instanceMap[id];
    }

    // インスタンス設定(既に存在する場合は上書きはしない)
    // @param [Integer] id イベントID
    // @param [Integer] classDistToken
    static setInstanceFromMap(id, classDistToken, withInitFromPagevalue) {
      if(withInitFromPagevalue === null) {
        withInitFromPagevalue = true;
      }
      if(typeof id !== "string") {
        id = String(id);
      }

      if((window.instanceMap === null)) {
        window.instanceMap = {};
      }
      if((window.instanceMap[id] === null)) {
        // インスタンスを保存する
        const instance = new (Common.getClassFromMap(classDistToken))();
        instance.id = id;
        if(withInitFromPagevalue) {
          // インスタンス値が存在する場合、初期化
          const obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(id));
          if(obj) {
            instance.setMiniumObject(obj);
          }
        }
        return window.instanceMap[id] = instance;
      }
    }

    // 生成したインスタンスの中からアイテムのみ取得
    // @return [Array] アイテムインスタンス配列
    static allItemInstances() {
      const ret = {};
      for(let k in instanceMap) {
        const v = instanceMap[k];
        if(v instanceof CommonEventBase === false) {
          ret[k] = v;
        }
      }
      return ret;
    }

    // アクションタイプからアクションタイプクラス名を取得
    // @param [Integer] actionType アクションタイプID
    // @return [String] アクションタイプクラス名
    static getActionTypeClassNameByActionType(actionType) {
      if(parseInt(actionType) === constant.ActionType.CLICK) {
        return constant.TimelineActionTypeClassName.CLICK;
      } else if(parseInt(actionType) === constant.ActionType.SCROLL) {
        return constant.TimelineActionTypeClassName.SCROLL;
      }
      return null;
    }

    // コードのアクションタイプからアクションタイプを取得
    // @param [Integer] actionType アクションタイプID
    // @return [String] アクションタイプクラス名
    static getActionTypeByCodingActionType(actionType) {
      if(actionType === 'click') {
        return constant.ActionType.CLICK;
      } else if(actionType === 'scroll') {
        return constant.ActionType.SCROLL;
      }
      return null;
    }

    // 日付をフォーマットで変換
    // @param [Date] date 対象日付
    // @param [String] format 変換フォーマット
    // @return [String] フォーマット後日付
    static formatDate(date, format) {
      if(format === null) {
        format = 'YYYY-MM-DD hh:mm:ss';
      }
      format = format.replace(/YYYY/g, date.getFullYear());
      format = format.replace(/MM/g, (`0${date.getMonth() + 1}`).slice(-2));
      format = format.replace(/DD/g, (`0${date.getDate()}`).slice(-2));
      format = format.replace(/hh/g, (`0${date.getHours()}`).slice(-2));
      format = format.replace(/mm/g, (`0${date.getMinutes()}`).slice(-2));
      format = format.replace(/ss/g, (`0${date.getSeconds()}`).slice(-2));
      if(format.match(/S/g)) {
        const milliSeconds = (`00${date.getMilliseconds()}`).slice(-3);
        const {length} = format.match(/S/g);
        for(let i = 0, end = length, asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
          format = format.replace(/S/, milliSeconds.substring(i, i + 1));
        }
      }
      return format;
    }

    // 時間差を計算
    // @param [Integer] future 未来日ミリ秒
    // @param [Integer] past 過去日ミリ秒
    // @return [Object] 差分オブジェクト
    static calculateDiffTime(future, past) {
      const diff = future - past;
      const ret = {};
      ret.seconds = parseInt(diff / 1000);
      ret.minutes = parseInt(ret.seconds / 60);
      ret.hours = parseInt(ret.minutes / 60);
      ret.day = parseInt(ret.hours / 24);
      ret.week = parseInt(ret.day / 7);
      ret.month = parseInt(ret.day / 30);
      ret.year = parseInt(ret.day / 365);
      return ret;
    }

    // 時間差を表示
    // @param [Integer] future 未来日ミリ秒
    // @param [Integer] past 過去日ミリ秒
    // @return [String] 表示
    static displayDiffAlmostTime(future, past) {
      const diffTime = this.calculateDiffTime(future, past);
      let span = null;
      let ret = null;
      const {seconds} = diffTime;
      if(seconds > 0) {
        span = seconds === 1 ? 'second' : 'seconds';
        ret = `${seconds} ${span} ago`;
      }
      const {minutes} = diffTime;
      if(minutes > 0) {
        span = minutes === 1 ? 'minute' : 'minutes';
        ret = `${minutes} ${span} ago`;
      }
      const {hours} = diffTime;
      if(hours > 0) {
        span = hours === 1 ? 'hour' : 'hours';
        ret = `${hours} ${span} ago`;
      }
      const {day} = diffTime;
      if(day > 0) {
        span = day === 1 ? 'day' : 'days';
        ret = `${day} ${span} ago`;
      }
      const {week} = diffTime;
      if(week > 0) {
        span = week === 1 ? 'week' : 'weeks';
        ret = `${week} ${span} ago`;
      }
      const {month} = diffTime;
      if(month > 0) {
        span = month === 1 ? 'month' : 'months';
        ret = `${month} ${span} ago`;
      }
      const {year} = diffTime;
      if(year > 0) {
        span = year === 1 ? 'year' : 'years';
        ret = `${year} ${span} ago`;
      }
      if((ret === null)) {
        ret = '';
      }
      return ret;
    }

    // 最終更新日時の時間差を取得
    static displayLastUpdateDiffAlmostTime(update_at = null) {
      const lastSaveTime = (update_at !== null) ? update_at : PageValue.getGeneralPageValue(PageValue.Key.LAST_SAVE_TIME);
      if(lastSaveTime !== null) {
        const n = $.now();
        const d = new Date(lastSaveTime);
        return Common.displayDiffAlmostTime(n, d.getTime());
      } else {
        return null;
      }
    }

    // 最新更新日時
    static displayLastUpdateTime(update_at) {
      const date = new Date(update_at);
      const diff = Common.calculateDiffTime($.now(), date);
      if(diff.day > 0) {
        // 日で表示
        return this.formatDate(date, 'YYYY/MM/DD');
      } else {
        // 時間で表示
        return this.formatDate(date, 'hh:mm:ss');
      }
    }

    // モーダルビュー表示
    // @param [Integer] type モーダルビュータイプ
    // @param [Function] prepareShowFunc 表示前処理
    static showModalView(type, enableOverlayClose, prepareShowFunc = null, prepareShowFuncParams) {
      if(enableOverlayClose === null) {
        enableOverlayClose = true;
      }
      if(prepareShowFuncParams === null) {
        prepareShowFuncParams = {};
      }
      return _showModalView.call(this, type, prepareShowFunc, prepareShowFuncParams, false, function() {
        $("body").append('<div id="modal-overlay"></div>');
        $("#modal-overlay").show();
        // センタリング
        Common.modalCentering.call(this, type);
        const emt = $('body').children(`.modal-content.${type}`);
        // ビューの高さ
        emt.css('max-height', $(window).height() * Constant.ModalView.HEIGHT_RATE);
        emt.fadeIn('fast', () => window.modalRun = false);
        return $("#modal-overlay,#modal-close").unbind().click(function() {
          if(enableOverlayClose) {
            return Common.hideModalView();
          }
        });
      });
    }

    // メッセージモーダル表示
    static showModalWithMessage(message, enableOverlayClose, immediately) {
      if(enableOverlayClose === null) {
        enableOverlayClose = true;
      }
      if(immediately === null) {
        immediately = true;
      }
      const type = constant.ModalViewType.MESSAGE;
      return _showModalView.call(this, type, null, {}, false, function() {
        $("body").append('<div id="modal-overlay"></div>');
        $("#modal-overlay").show();
        // センタリング
        Common.modalCentering.call(this, type);
        const emt = $('body').children(`.modal-content.${type}`);
        // ビューの高さ
        emt.css('max-height', $(window).height() * Constant.ModalView.HEIGHT_RATE);
        // メッセージ
        emt.find('.message_contents').text(message);
        if(immediately) {
          emt.show();
          window.modalRun = false;
        } else {
          emt.fadeIn('fast', () => window.modalRun = false);
        }
        return $("#modal-overlay,#modal-close").unbind().click(function() {
          if(enableOverlayClose) {
            return Common.hideModalView();
          }
        });
      });
    }

    // フラッシュメッセージモーダル表示
    static showModalFlashMessage(message) {
      return _showModalFlashMessage.call(this, message, false, true, false);
    }

    // 中央センタリング
    static modalCentering(type = null, animation, b = null, c = null) {
      let emt;
      if(animation === null) {
        animation = false;
      }
      if((type === null)) {
        // 表示しているモーダルを対象にする
        emt = $('body').children(".modal-content:visible");
      } else {
        emt = $('body').children(`.modal-content.${type}`);
      }
      if(emt !== null) {
        let h, w;
        if($('#main').length > 0) {
          w = $('#main').width();
          h = $('#main').height();
        } else {
          w = $('body').width();
          h = $('body').height();
        }

        let callback = null;
        let width = emt.outerWidth();
        let height = emt.outerHeight();
        if(b !== null) {
          if($.type(b) === 'function') {
            callback = b;
          } else if($.type(b) === 'object') {
            ({width} = b);
            ({height} = b);
          }
        }
        if(c !== null) {
          callback = c;
        }
        const cw = width;
        let ch = height;
        if(ch > (h * Constant.ModalView.HEIGHT_RATE)) {
          ch = h * Constant.ModalView.HEIGHT_RATE;
        }

        if(animation) {
          return emt.animate({
            "left": ((w - cw) / 2) + "px",
            "top": (((h - ch) / 2) - 80) + "px"
          }, 300, 'linear', callback);
        } else {
          return emt.css({"left": ((w - cw) / 2) + "px", "top": (((h - ch) / 2) - 80) + "px"});
        }
      }
    }

    // モーダル非表示
    static hideModalView(immediately) {
      if(immediately === null) {
        immediately = false;
      }
      if(immediately) {
        $(".modal-content,#modal-overlay").stop().hide();
      } else {
        $(".modal-content,#modal-overlay").fadeOut('fast');
      }
      return $('#modal-overlay').remove();
    }

    // Zindexにページ分のZindexを加算
    // @param [Integer] zindex 対象zindex
    // @param [Integer] pn ページ番号
    // @return [Integer] 計算後zidnex
    static plusPagingZindex(zindex, pn) {
      if(pn === null) {
        pn = PageValue.getPageNum();
      }
      return ((window.pageNumMax - pn) * (constant.Zindex.EVENTFLOAT + 1)) + zindex;
    }

    // Zindexにページ分のZindexを減算
    // @param [Integer] zindex 対象zindex
    // @param [Integer] pn ページ番号
    // @return [Integer] 計算後zidnex
    static minusPagingZindex(zindex, pn) {
      if(pn === null) {
        pn = PageValue.getPageNum();
      }
      return zindex - ((window.pageNumMax - pn) * (constant.Zindex.EVENTFLOAT + 1));
    }

    // アイテムを削除
    // @param [Integer] pageNum ページ番号
    static removeAllItem(pageNum = null, withDeleteInstanceMap) {
      let cls, clsToken;
      if(withDeleteInstanceMap === null) {
        withDeleteInstanceMap = true;
      }
      if(pageNum !== null) {
        const items = this.instancesInPage(pageNum);
        return (() => {
          const result = [];
          for(let item of Array.from(items)) {
            if(item !== null) {
              if(item instanceof CommonEventBase === false) {
                // アイテム表示削除
                item.removeItemElement();
              } else {
                if(withDeleteInstanceMap) {
                  for(clsToken in window.classMap) {
                    cls = window.classMap[clsToken];
                    if(cls.prototype instanceof CommonEvent && item instanceof cls.PrivateClass) {
                      // Singletonのキャッシュを削除
                      cls.deleteInstance(item.id);
                    }
                  }
                }
              }
              if(withDeleteInstanceMap) {
                result.push(delete window.instanceMap[item.id]);
              } else {
                result.push(undefined);
              }
            } else {
              result.push(undefined);
            }
          }
          return result;
        })();
      } else {
        const object = Common.allItemInstances();
        for(let k in object) {
          const v = object[k];
          if(v !== null) {
            // アイテム表示削除
            v.removeItemElement();
          }
        }
        if(withDeleteInstanceMap) {
          window.instanceMap = {};
          return (() => {
            const result1 = [];
            for(clsToken in window.classMap) {
              cls = window.classMap[clsToken];
              if(cls.prototype instanceof CommonEvent) {
                // Singletonのキャッシュを削除
                result1.push(cls.deleteAllInstance());
              } else {
                result1.push(undefined);
              }
            }
            return result1;
          })();
        }
      }
    }

    // JSファイルをサーバから読み込む
    // @param [Int] classDistToken アイテム種別
    // @param [Function] callback コールバック関数
    static loadItemJs(classDistTokens, callback = null) {
      if(jQuery.type(classDistTokens) !== "array") {
        classDistTokens = [classDistTokens];
      }

      classDistTokens = $.grep(classDistTokens, n =>
        // 読み込み済みのものは除外
        window.itemInitFuncList[n] === null
      );
      // 読み込むIDがない場合はコールバック実行して終了
      if(classDistTokens.length === 0) {
        if(callback !== null) {
          callback();
        }
        return;
      }

      let callbackCount = 0;
      const needReadclassDistTokens = [];
      for(let classDistToken of Array.from(classDistTokens)) {
        if(classDistToken !== null) {
          if(window.itemInitFuncList[classDistToken] !== null) {
            // 読み込み済みなアイテムIDの場合
            window.itemInitFuncList[classDistToken]();
            callbackCount += 1;
            if(callbackCount >= classDistTokens.length) {
              if(callback !== null) {
                // 既に全て読み込まれている場合はコールバック実行して終了
                callback();
              }
              return;
            }
          } else {
            // Ajaxでjs読み込みが必要なアイテムID
            needReadclassDistTokens.push(classDistToken);
          }
        } else {
          callbackCount += 1;
        }
      }

      // js読み込み
      const data = {};
      data[constant.ItemGallery.Key.ITEM_GALLERY_ACCESS_TOKEN] = needReadclassDistTokens;
      return $.ajax(
        {
          url: "/item_js/index",
          type: "POST",
          dataType: "json",
          data,
          success(data) {
            if(data.resultSuccess) {
              if((data.indexes === null) || (data.indexes.length === 0)) {
                if(callback !== null) {
                  return callback();
                }
              } else {
                callbackCount = 0;
                let dataIdx = 0;
                var _cb = function(d) {
                  const option = {};
                  return Common.availJs(d.class_dist_token, d.js_src, option, () => {
                    PageValue.addItemInfo(d.class_dist_token);
                    dataIdx += 1;
                    if(dataIdx >= data.indexes.length) {
                      if(callback !== null) {
                        return callback();
                      }
                    } else {
                      return _cb.call(this, data.indexes[dataIdx]);
                    }
                  });
                };
                return _cb.call(this, data.indexes[dataIdx]);
              }
            } else {
              console.log('/item_js/index server error');
              return Common.ajaxError(data);
            }
          },

          error(data) {
            console.log('/item_js/index ajax error');
            return Common.ajaxError(data);
          }
        }
      );
    }

    // インスタンスPageValueから全てのJSを取得
    static loadJsFromInstancePageValue(callback = null, pageNum) {
      if(pageNum === null) {
        pageNum = PageValue.getPageNum();
      }
      const pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum));
      const needclassDistTokens = [];
      for(let k in pageValues) {
        const obj = pageValues[k];
        if(obj.value.id.indexOf(ItemBase.ID_PREFIX) === 0) {
          // アイテムの場合
          if($.inArray(obj.value.classDistToken, needclassDistTokens) < 0) {
            needclassDistTokens.push(obj.value.classDistToken);
          }
        }
      }

      return this.loadItemJs(needclassDistTokens, function() {
        // コールバック
        if(callback !== null) {
          return callback();
        }
      });
    }

    // JSファイルを設定
    // @param [String] classDistToken アイテムID
    // @param [String] jsSrc jsファイル名
    // @param [Function] callback 設定後のコールバック
    static availJs(classDistToken, jsSrc, option, callback = null) {
      let t;
      if(option === null) {
        option = {};
      }
      window.loadedClassDistToken = classDistToken;
      const s = document.createElement('script');
      s.type = 'text/javascript';
      // TODO: 認証コードの比較
      s.src = jsSrc;
      const firstScript = document.getElementsByTagName('script')[0];
      firstScript.parentNode.insertBefore(s, firstScript);
      return t = setInterval(function() {
          if(window.itemInitFuncList[classDistToken] !== null) {
            clearInterval(t);
            window.itemInitFuncList[classDistToken](option);
            window.loadedClassDistToken = null;
            if(callback !== null) {
              return callback();
            }
          }
        }
        , 500);
    }

    // CanvasをBlobに変換
    static canvasToBlob(canvas) {
      const type = 'image/jpeg';
      const dataurl = canvas.toDataURL(type);
      const bin = atob(dataurl.split(',')[1]);
      const buffer = new Uint8Array(bin.length);
      for(let i = 0, end = bin.length - 1, asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
        buffer[i] = bin.charCodeAt(i);
      }
      return new Blob([buffer.buffer], {type});
    }

    // JSファイルを適用する
    static setupJsByList(itemJsList, callback = null) {

      const _addItem = function(class_dist_token = null) {
        if(class_dist_token !== null) {
          return PageValue.addItemInfo(class_dist_token);
        }
      };

      if(itemJsList.length === 0) {
        if(callback !== null) {
          callback();
        }
        return;
      }

      let loadedIndex = 0;
      let d = itemJsList[loadedIndex];
      var _func = function() {
        const classDistToken = d.class_dist_token;
        if(window.itemInitFuncList[classDistToken] !== null) {
          // 既に読み込まれている場合
          window.itemInitFuncList[classDistToken]();
          //_addItem.call(@, classDistToken)
          loadedIndex += 1;
          if(loadedIndex >= itemJsList.length) {
            // 全て読み込んだ後
            if(callback !== null) {
              callback();
            }
          } else {
            d = itemJsList[loadedIndex];
            _func.call();
          }
          return;
        }

        const option = {};
        return Common.availJs(classDistToken, d.js_src, option, function() {
          _addItem.call(this, classDistToken);
          loadedIndex += 1;
          if(loadedIndex >= itemJsList.length) {
            // 全て読み込んだ後
            if(callback !== null) {
              return callback();
            }
          } else {
            d = itemJsList[loadedIndex];
            return _func.call();
          }
        });
      };
      return _func.call();
    }

    // コンテキストメニュー初期化
    // @param [String] elementID HTML要素ID
    // @param [String] contextSelector
    // @param [Object] option オプション
    static setupContextMenu(element, contextSelector, option) {
      const data = {
        preventContextMenuForPopup: true,
        preventSelect: true
      };
      $.extend(data, option);
      return element.contextmenu(data);
    }

    static colorFormatChangeRgbToHex(data) {
      let cColors;
      if(typeof data === 'string') {
        // 'rgb(r, g, b)'または'rgba(r, g, b, a)'のフォーマットを分解
        cColors = data.replace('rgba', '').replace('rgb', '').replace('(', '').replace(')', '').split(',');
      } else {
        cColors = [data.r, data.g.data.b];
      }
      for(let index = 0; index < cColors.length; index++) {
        const val = cColors[index];
        cColors[index] = parseInt(val);
      }
      return `#${cColors[0].toString(16)}${cColors[1].toString(16)}${cColors[2].toString(16)}`;
    }

    static colorFormatChangeHexToRgb(data) {
      // 'xxxxxxのフォーマットを分解'
      data = data.replace('#', '');
      const cColors = new Array(3);
      cColors[0] = data.substring(0, 2);
      cColors[1] = data.substring(2, 4);
      cColors[2] = data.substring(4, 6);
      for(let index = 0; index < cColors.length; index++) {
        const val = cColors[index];
        cColors[index] = parseInt(val, 16);
      }
      return {
        r: cColors[0],
        g: cColors[1],
        b: cColors[2]
      };
    }

    // 色変更差分のキャッシュを取得
    static colorChangeCacheData(beforeColor, afterColor, length, colorType) {
      let i, index, val;
      if(colorType === null) {
        colorType = 'hex';
      }
      const ret = [];

      let cColors = new Array(3);
      if(afterColor.indexOf('rgb') >= 0) {
        // 'rgb(r, g, b)'または'rgba(r, g, b, a)'のフォーマットを分解
        cColors = afterColor.replace('rgba', '').replace('rgb', '').replace('(', '').replace(')', '').split(',');
        for(index = 0; index < cColors.length; index++) {
          val = cColors[index];
          cColors[index] = parseInt(val);
        }
      }
      if((afterColor.length === 6) || ((afterColor.length === 7) && (afterColor.indexOf('#') === 0))) {
        // 'xxxxxxのフォーマットを分解'
        afterColor = afterColor.replace('#', '');
        cColors[0] = afterColor.substring(0, 2);
        cColors[1] = afterColor.substring(2, 4);
        cColors[2] = afterColor.substring(4, 6);
        for(index = 0; index < cColors.length; index++) {
          val = cColors[index];
          cColors[index] = parseInt(val, 16);
        }
      }

      if(beforeColor === 'transparent') {
        // 透明から変更する場合は rgbaで出力
        let asc, end;
        for(i = 0, end = length, asc = 0 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
          ret[i] = `rgba(${cColors[0]},${cColors[1]},${cColors[2]}, ${i / length})`;
        }
      } else {
        let asc1, end1;
        let bColors = new Array(3);
        if(beforeColor.indexOf('rgb') >= 0) {
          // 'rgb(r, g, b)'または'rgba(r, g, b, a)'のフォーマットを分解
          bColors = beforeColor.replace('rgba', '').replace('rgb', '').replace('(', '').replace(')', '').split(',');
          for(index = 0; index < bColors.length; index++) {
            val = bColors[index];
            bColors[index] = parseInt(val);
          }
        }
        if((beforeColor.length === 6) || ((beforeColor.length === 7) && (beforeColor.indexOf('#') === 0))) {
          // 'xxxxxxのフォーマットを分解'
          beforeColor = beforeColor.replace('#', '');
          bColors[0] = beforeColor.substring(0, 2);
          bColors[1] = beforeColor.substring(2, 4);
          bColors[2] = beforeColor.substring(4, 6);
          for(index = 0; index < bColors.length; index++) {
            val = bColors[index];
            bColors[index] = parseInt(val, 16);
          }
        }

        const rPer = (cColors[0] - bColors[0]) / length;
        const gPer = (cColors[1] - bColors[1]) / length;
        const bPer = (cColors[2] - bColors[2]) / length;
        let rp = rPer;
        let gp = gPer;
        let bp = bPer;
        for(i = 0, end1 = length, asc1 = 0 <= end1; asc1 ? i <= end1 : i >= end1; asc1 ? i++ : i--) {
          var o;
          const r = parseInt(bColors[0] + rp);
          const g = parseInt(bColors[1] + gp);
          const b = parseInt(bColors[2] + bp);
          if(colorType === 'hex') {
            o = `#${r.toString(16)}${g.toString(16)}${b.toString(16)}`;
          } else if(colorType === 'rgb') {
            o = `rgb(${r},${g},${b})`;
          }
          ret[i] = o;
          rp += rPer;
          gp += gPer;
          bp += bPer;
        }
      }

      return ret;
    }

    // 現在の表示URLからアクセストークンを取得
    static getContentsAccessTokenFromUrl() {
      const locationPaths = window.location.pathname.split('/');
      return locationPaths[locationPaths.length - 1].split('?')[0];
    }

    // スクロール位置が初期化されているか
    static isinitedScrollContentsPosition() {
      return window.scrollContents.scrollTop() > 0;
    }

    // MarkdownをHTMLに変換
    static markdownToHtml() {
      const md = $('.markdown');
      return md.each(function(m) {
        const v = $(this).html();
        return $(this).html(markdown.toHTML(v));
      });
    }
  };
  Common.initClass();
}

// 画面共通の初期化処理 ajaxでサーバから読み込む等
window.classMap = {}
