/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
var Sidebar = (function() {
  let constant = undefined;
  Sidebar = class Sidebar {
    static initClass() {
      // 定数
      constant = gon.const;
      this.SIDEBAR_TAB_ROOT = constant.ElementAttribute.SIDEBAR_TAB_ROOT;

      const Cls = (this.Type = class Type {
        static initClass() {
          this.STATE = 'state';
          this.EVENT = 'event';
          this.SETTING = 'setting';
        }
      });
      Cls.initClass();
    }

    // サイドバーをオープン
    // @param [Array] target フォーカス対象オブジェクト
    // @param [String] selectedBorderType 選択枠タイプ
    static openConfigSidebar(target = null, selectedBorderType) {
      if(selectedBorderType === null) {
        selectedBorderType = "edit";
      }
      if(window.isWorkTable) {
        if(!Sidebar.isOpenedConfigSidebar()) {
          // モードを変更
          WorktableCommon.changeMode(constant.Mode.OPTION);
          const main = $('#main');
          if(!Sidebar.isOpenedConfigSidebar()) {
            // リサイズイベントを発生させない
            window.skipResizeEvent = true;
            main.removeClass('col-xs-12');
            main.addClass('col-xs-9');
            $('#sidebar').fadeIn('100', function() {
              Common.updateCanvasSize();
              return window.sidebarOpen = true;
            });
          }
          //          if target !== null
          //            WorktableCommon.focusToTargetWhenSidebarOpen(target, selectedBorderType, true)

          // 閉じるイベント設定
          return $('#screen_wrapper').off('click.sidebar_close').on('click.sidebar_close', e => {
            if(Sidebar.isOpenedConfigSidebar()) {
              // イベント用選択モードの場合は閉じない
              if(window.eventPointingMode === constant.EventInputPointingMode.NOT_SELECT) {
                Sidebar.closeSidebar(() => {
                  return window.sidebarOpen = false;
                });
                // モードを変更以前に戻す
                return WorktableCommon.putbackMode();
              }
            }
          });
        }
      }
    }

    // サイドバーをクローズ
    // @param [Function] callback コールバック
    static closeSidebar(callback = null) {
      if(window.isWorkTable) {
        // 選択枠を削除
        WorktableCommon.clearSelectedBorder();
        // イベントポインタ削除
        WorktableCommon.clearEventPointer();
        // サイドビューのWidgetを全て非表示
        this.closeAllWidget();
        // イベントを消去
        $('#screen_wrapper').off('click.sidebar_close');
        if(!Sidebar.isClosedConfigSidebar()) {
          const main = $('#main');
          return $('#sidebar').fadeOut('100', function() {
            // リサイズイベントを発生させない
            window.skipResizeEvent = true;
            main.removeClass('col-xs-9');
            main.addClass('col-xs-12');
            Common.updateCanvasSize();
            // モード再設定
            if(window.mode === constant.Mode.OPTION) {
              WorktableCommon.changeMode(window.beforeMode);
            } else {
              WorktableCommon.changeMode(window.mode);
            }
            if(callback !== null) {
              callback();
            }
            return $('.sidebar-config').hide();
          });
        }
      }
    }

    // サイドバーがオープンしているか
    // @return [Boolean] 判定結果
    static isOpenedConfigSidebar() {
      return (window.sidebarOpen !== null) && window.sidebarOpen;
    }

    // サイドバーがクローズしているか
    // @return [Boolean] 判定結果
    static isClosedConfigSidebar() {
      return !this.isOpenedConfigSidebar();
    }

    // 全Widget非表示
    static closeAllWidget() {
      return $('.colorpicker:visible').hide();
    }

    // サイドバー内容のスイッチ
    // @param [String] configType コンフィグタイプ
    // @param [Object] item アイテムオブジェクト
    static switchSidebarConfig(configType, item = null) {
      const animation = this.isOpenedConfigSidebar();
      $('.sidebar-config').hide();

      if((configType === this.Type.STATE) || (configType === this.Type.SETTING)) {
        const sc = $(`#${this.SIDEBAR_TAB_ROOT}`);
        if(animation) {
          return sc.fadeIn('fast');
        } else {
          return sc.show();
        }
      } else if(configType === this.Type.EVENT) {
        if(animation) {
          return $('#event-config').fadeIn('fast');
        } else {
          return $('#event-config').show();
        }
      }
    }

    // アイテム編集メニュー表示
    static openItemEditConfig(target) {
      const emt = $(target);
      const obj = instanceMap[emt.attr('id')];
      // アイテム編集メニュー初期化
      return this.initItemEditConfig(obj, () => {
        if((obj !== null) && (obj.showOptionMenu !== null)) {
          // オプションメニュー表示処理
          obj.showOptionMenu();
        }
        // オプションメニューを表示
        return this.openConfigSidebar(target);
      });
    }

    // 状態メニュー表示
    static openStateConfig() {
      const root = $('#tab-config');
      const scrollBarWidths = 40;
      this.openConfigSidebar();

      const widthOfList = function() {
        let itemsWidth = 0;
        $('.nav-tabs li', root).each(function() {
          const itemWidth = $(this).outerWidth();
          return itemsWidth += itemWidth;
        });
        return itemsWidth;
      };

      const widthOfHidden = () => (($('.tab-nav-tabs-wrapper', root).outerWidth()) - widthOfList() - getLeftPosi()) - scrollBarWidths;

      var getLeftPosi = () => $('.nav-tabs', root).position().left;

      const reAdjust = function() {
        if(($('.tab-nav-tabs-wrapper', root).outerWidth()) < widthOfList()) {
          $('.scroller-right', root).show();
        } else {
          $('.scroller-right', root).hide();
        }

        if(getLeftPosi() < 0) {
          return $('.scroller-left', root).show();
        } else {
          $('.item', root).animate({left: `-=${getLeftPosi()}px`}, 'fast');
          return $('.scroller-left', root).hide();
        }
      };

      reAdjust();
      $('.scroller-right', root).off('click').on('click', function() {
        $('.scroller-left', root).fadeIn('fast');
        $('.scroller-right', root).fadeOut('fast');
        return $('.nav-tabs', root).animate({left: `+=${widthOfHidden()}px`}, 'fast');
      });
      return $('.scroller-left', root).off('click').on('click', function() {
        $('.scroller-right', root).fadeIn('fast');
        $('.scroller-left', root).fadeOut('fast');
        return $('.nav-tabs', root).animate({left: `-=${getLeftPosi()}px`}, 'fast');
      });
    }

    // アイテム編集メニュー初期化
    static initItemEditConfig(obj, callback = null) {
      // カラーピッカー値を初期化
      ColorPickerUtil.initColorPickerValue();
      // オプションメニューの値を初期化
      if((obj !== null) && (obj.setupOptionMenu !== null)) {
        // 初期化関数を呼び出す
        return obj.setupOptionMenu(callback);
      }
    }

    // イベントコンフィグ初期化
    static initEventConfig(distId, teNum) {
      if(teNum === null) {
        teNum = 1;
      }
      const eId = EventConfig.ITEM_ROOT_ID.replace('@distId', distId);
      let emt = $(`#${eId}`);
      if(emt.length === 0) {
        // イベントメニューの作成
        emt = $('#event-config .event_temp .event').clone(true).attr('id', eId);
        $('#event-config').append(emt);
      }
      // イベントコンフィグメニュー初期化
      return EventConfig.initEventConfig(distId, teNum);
    }

    // 操作不可にする
    static disabledOperation(flg) {
      if(flg) {
        if($('#sidebar .cover_touch_overlay').length === 0) {
          $('#sidebar').append("<div class='cover_touch_overlay'></div>");
          return $('.cover_touch_overlay').off('click').on('click', function(e) {
            e.preventDefault();
          });
        }
      } else {
        return $('#sidebar .cover_touch_overlay').remove();
      }
    }

    static resizeConfigHeight() {
      const contentsHeight = $('#contents').height();
      const tabHeight = 39;
      const padding = 5;
      return $('#myTabContent').height(contentsHeight - tabHeight - (padding * 2));
    }
  };
  Sidebar.initClass();
  return Sidebar;
})();
