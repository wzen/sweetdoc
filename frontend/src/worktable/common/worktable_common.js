import Common from '../../base/common';
import CommonVar from '../../base/common_var';
import PageValue from '../../base/page_value';
import Navbar from '../../navbar/navbar';
import EventPageValueBase from '../../event_page_value/base/base';
import ItemBase from '../../item/item_base';
import EventConfig from '../../sidebar_config/event_config';
import Sidebar from '../../sidebar_config/sidebar_ui';
import FloatView from '../../base/float_view';
import StateConfig from '../../sidebar_config/state_config';
import Timeline from '../event/timeline';
import Handwrite from '../handwrite/handwrite';
import OperationHistory from './history';
import WorktableSetting from './worktable_setting';

let _updatePrevEventsToAfterAndRunPreview = undefined;
export default class WorktableCommon {
  static initClass() {

    _updatePrevEventsToAfterAndRunPreview = function(teNum, keepDispMag, fromBlankEventConfig, doRunPreview, callback = null) {
      if(doRunPreview && (window.previewRunning !== null) && window.previewRunning) {
        // プレビュー二重実行は無視
        return;
      }
      const epr = this.eventProgressRoute(teNum);
      if(!epr.result) {
        // 設定が繋がっていない場合は無視
        return;
      }
      const tes = epr.routes;
      // 状態変更フラグON
      window.worktableItemsChangedState = true;
      // 操作履歴削除
      PageValue.removeAllFootprint();
      teNum = parseInt(teNum);
      const focusTargetItem = null;
      // プレビュー実行フラグON
      if(doRunPreview) {
        window.previewRunning = true;
      }
      for(let idx = 0; idx < tes.length; idx++) {
        const te = tes[idx];
        var item = window.instanceMap[te.id];
        if(item !== null) {
          item.initEvent(te, keepDispMag);
          if(item instanceof ItemBase && te[EventPageValueBase.PageValueKey.DO_FOCUS]) {
            // アイテムにフォーカス
            Common.focusToTarget(item.getJQueryElement(), null, true);
          }
          if((idx < (tes.length - 1)) || fromBlankEventConfig) {
            item.willChapter(function() {
              // イベント後の状態に変更
              item.updateEventAfter();
              // 最終ステップでメソッドを実行
              item.execLastStep();
              return item.didChapter();
            });
          } else if(doRunPreview) {
            // プレビュー実行
            item.preview(() => {
              return this.stopPreview(keepDispMag);
            });
            // 状態変更フラグON
            window.worktableItemsChangedState = true;
            // ボタン変更「Preview」->「StopPreview」
            EventConfig.switchPreviewButton(false);
          }
        }
      }
      if(callback !== null) {
        return callback();
      }
    };
  }

  // 選択枠を付ける
  // @param [Object] target 対象のオブジェクト
  // @param [String] selectedBorderType 選択タイプ
  static setSelectedBorder(target, selectedBorderType) {
    if(selectedBorderType === null) {
      selectedBorderType = "edit";
    }
    if(selectedBorderType === 'edit') {
      this.setEditSelectedBorder(target);
      return;
    }
    let className = null;
    if(selectedBorderType === "timeline") {
      className = 'timelineSelected';
    }
    // 選択枠を取る
    $(target).find(`.${className}`).remove();
    const append = `<div class=${className} />`;
    // 設定
    return $(target).append(append).find('.editButtonOnEditSelected:first').off('mousedown.edit').on('mousedown.edit', e => {
      e.preventDefault();
      e.stopPropagation();
      target = $(e.target).closest('.item');
      if((target !== null) && (target.length > 0)) {
        return WorktableCommon.editItem(target.attr('id'));
      }
    });
  }

  static setEditSelectedBorder(target) {
    const className = 'editSelected';
    // 選択枠を取る
    window.scrollInside.find(`.${className}`).remove();
    let targetZindex = parseInt($(target).css('z-index'));
    if((targetZindex === null)) {
      targetZindex = 0;
    }
    targetZindex += 99;
    const {top} = $(target).position();
    const {left} = $(target).position();
    const width = $(target).width();
    const height = $(target).height();
    const append = `<div class=${className} style='top:${top}px;left:${left}px;width:${width}px;height:${height}px;'><div class='editButtonOnEditSelected' style='z-index:${targetZindex}'></div></div>`;
    // 設定
    window.scrollInside.append(append).find('.editButtonOnEditSelected:first').off('mousedown.edit').on('mousedown.edit', e => {
      e.preventDefault();
      e.stopPropagation();
      return WorktableCommon.editItem($(target).attr('id'));
    });
    return window.selectedObjId = $(target).attr('id');
  }

  static updateEditSelectBorderSize(target) {
    const {top} = $(target).position();
    const {left} = $(target).position();
    const width = $(target).width();
    const height = $(target).height();
    console.log(`width:${width}`);
    console.log(`height:${height}`);
    const border = window.scrollInside.find(".editSelected:first");
    if(border.length > 0) {
      return border.attr('style', `top:${top}px;left:${left}px;width:${width}px;height:${height}px;`);
    }
  }

  // 全ての選択枠を外す
  static clearSelectedBorder() {
    $('.editSelected, .timelineSelected').remove();
    // 選択アイテムID解除
    return window.selectedObjId = null;
  }

  static clearTimelineSelectedBorderInMainWrapper() {
    $('.timelineSelected', window.mainWrapper).remove();
    // 選択アイテムID解除
    return window.selectedObjId = null;
  }

  // キャッシュからWorktableを作成するか判定
  static checkLoadWorktableFromCache() {
    if(window.lStorage.isOverWorktableSaveTimeLimit()) {
      // キャッシュ期限切れ
      return false;
    }
    if((window.changeUser !== null) && window.changeUser) {
      // ユーザが変更された場合
      return false;
    }
    const generals = window.lStorage.loadGeneralValue();
    if((generals[constant.Project.Key.PROJECT_ID] === null)) {
      // プロジェクトが存在しない場合
      return false;
    }

    return true;
  }

  // 選択アイテムの複製処理 (Ctrl + c)
  // @param [Integer] objId コピーするアイテムのオブジェクトID
  // @param [Boolean] isCopyOperation コピー = true, 切り取り = false
  static copyItem(objId, isCopyOperation) {
    if(objId === null) {
      objId = window.selectedObjId;
    }
    if(isCopyOperation === null) {
      isCopyOperation = true;
    }
    if(objId !== null) {
      const pageValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(objId));
      if(pageValue !== null) {
        const instance = window.instanceMap[objId];
        if(instance instanceof ItemBase) {
          window.copiedInstance = Common.makeClone(instance.getMinimumObject());
          if(isCopyOperation) {
            return window.copiedInstance.isCopy = true;
          }
        }
      }
    }
  }

  // 選択アイテムの切り取り (Ctrl + x)
  // @param [Integer] objId コピーするアイテムのオブジェクトID
  static cutItem(objId) {
    if(objId === null) {
      objId = window.selectedObjId;
    }
    this.copyItem(objId, false);
    return this.removeSingleItem($(`#${objId}`));
  }

  // アイテムの貼り付け (Ctrl + v)
  static pasteItem() {
    if(window.copiedInstance !== null) {
      const instance = new (Common.getClassFromMap(window.copiedInstance.classDistToken))();
      window.instanceMap[instance.id] = instance;
      const obj = Common.makeClone(window.copiedInstance);
      obj.id = instance.id;
      instance.setMiniumObject(obj);
      if((obj.isCopy !== null) && obj.isCopy) {
        instance.name = instance.name + ' (Copy)';
      }
      // 画面中央に貼り付け
      const scrollContentsSize = Common.scrollContentsSizeUnderViewScale();
      instance.itemSize.x = parseInt(window.scrollContents.scrollLeft() + ((scrollContentsSize.width - instance.itemSize.w) * 0.5));
      instance.itemSize.y = parseInt(window.scrollContents.scrollTop() + ((scrollContentsSize.height - instance.itemSize.h) * 0.5));
      if(instance.drawAndMakeConfigs !== null) {
        instance.drawAndMakeConfigs();
      }
      instance.setItemAllPropToPageValue();
      return window.lStorage.saveAllPageValues();
    }
  }

  // アイテムを最前面に移動
  // @param [Integer] objId 対象オブジェクトID
  static floatItem(objId) {
    const drawedItems = window.scrollInside.find('.item');
    const sorted = [];
    drawedItems.each(function() {
      return sorted.push($(this));
    });
    let i = 0;
    while(i <= (drawedItems.length - 2)) {
      let j = i + 1;
      while(j <= (drawedItems.length - 1)) {
        const a = parseInt(sorted[i].css('z-index'));
        const b = parseInt(sorted[j].css('z-index'));
        if(a > b) {
          const w = sorted[i];
          sorted[i] = sorted[j];
          sorted[j] = w;
        }
        j += 1;
      }
      i += 1;
    }

    const targetZIndex = parseInt($(`#${objId}`).css('z-index'));
    i = parseInt(window.scrollInsideWrapper.css('z-index'));
    for(let item of Array.from(sorted)) {
      const itemObjId = $(item).attr('id');
      if(objId !== itemObjId) {
        item.css('z-index', i);
        PageValue.setInstancePageValue(PageValue.Key.instanceValue(itemObjId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(i));
        i += 1;
      }
    }
    const maxZIndex = i;
    $(`#${objId}`).css('z-index', maxZIndex);
    return PageValue.setInstancePageValue(PageValue.Key.instanceValue(objId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(maxZIndex));
  }

  // アイテムを再背面に移動
  // @param [Integer] objId 対象オブジェクトID
  static rearItem(objId) {
    const drawedItems = window.scrollInside.find('.item');
    const sorted = [];
    drawedItems.each(function() {
      return sorted.push($(this));
    });
    let i = 0;
    while(i <= (drawedItems.length - 2)) {
      let j = i + 1;
      while(j <= (drawedItems.length - 1)) {
        const a = parseInt(sorted[i].css('z-index'));
        const b = parseInt(sorted[j].css('z-index'));
        if(a > b) {
          const w = sorted[i];
          sorted[i] = sorted[j];
          sorted[j] = w;
        }
        j += 1;
      }
      i += 1;
    }

    const targetZIndex = parseInt($(`#${objId}`).css('z-index'));
    i = parseInt(window.scrollInsideWrapper.css('z-index')) + 1;
    for(let item of Array.from(sorted)) {
      const itemObjId = $(item).attr('id');
      if(objId !== itemObjId) {
        item.css('z-index', i);
        PageValue.setInstancePageValue(PageValue.Key.instanceValue(itemObjId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(i));
        i += 1;
      }
    }
    const minZIndex = parseInt(window.scrollInsideWrapper.css('z-index'));
    $(`#${objId}`).css('z-index', minZIndex);
    return PageValue.setInstancePageValue(PageValue.Key.instanceValue(objId) + PageValue.Key.PAGE_VALUES_SEPERATOR + 'zindex', Common.minusPagingZindex(minZIndex));
  }

  // アイテム編集
  static editItem(objId) {
    const item = window.instanceMap[objId];
    if((item !== null) && (item.launchEdit !== null)) {
      // launchEditメソッドが宣言されている場合は呼ぶ
      return item.launchEdit();
    } else {
      // それ以外はアイテム編集サイドメニューを開く
      return Sidebar.openItemEditConfig($(`#${objId}`));
    }
  }

  // モードチェンジ
  // @param [Mode] afterMode 変更後画面モード
  static changeMode(afterMode, pn) {
    // 画面Zindex変更
    if(pn === null) {
      pn = PageValue.getPageNum();
    }
    if(afterMode === constant.Mode.NOT_SELECT) {
      //$(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT, pn))
      $(window.drawingCanvas).css('pointer-events', '');
      window.scrollInsideWrapper.removeClass('edit_mode');
    } else if(afterMode === constant.Mode.DRAW) {
      //$(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT, pn))
      $(window.drawingCanvas).css('pointer-events', '');
      window.scrollContents.find('.item.draggable').removeClass('edit_mode');
      window.scrollInsideWrapper.removeClass('edit_mode');
    } else if(afterMode === constant.Mode.EDIT) {
      //$(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM, pn))
      $(window.drawingCanvas).css('pointer-events', 'none');
      window.scrollContents.find('.item.draggable').addClass('edit_mode');
      window.scrollInsideWrapper.addClass('edit_mode');
      // ヘッダーをEditに
      Navbar.setModeEdit();
    } else if(afterMode === constant.Mode.OPTION) {
      //$(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT, pn))
      $(window.drawingCanvas).css('pointer-events', '');
      window.scrollContents.find('.item.draggable').removeClass('edit_mode');
      window.scrollInsideWrapper.removeClass('edit_mode');
    }

    this.setModeClassToMainDiv(afterMode);

    if(window.mode !== afterMode) {
      // 変更前のモードを保存
      window.beforeMode = window.mode;
      window.mode = afterMode;

      // アイテムのイベント呼び出し
      const items = Common.itemInstancesInPage();
      return (() => {
        const result = [];
        for(let item of Array.from(items)) {
          if(item.changeMode !== null) {
            result.push(item.changeMode(afterMode));
          } else {
            result.push(undefined);
          }
        }
        return result;
      })();
    }
  }

  // 画面Pointingモードに変更
  static changeEventPointingMode(afterMode) {
    if(afterMode === constant.EventInputPointingMode.NOT_SELECT) {
      // 全入力を有効
      Timeline.disabledOperation(false);
      Sidebar.disabledOperation(false);
      Navbar.disabledOperation(false);
    } else if((afterMode === constant.EventInputPointingMode.DRAW) || (afterMode === constant.EventInputPointingMode.ITEM_TOUCH)) {
      // 全入力を無効に
      Timeline.disabledOperation(true);
      Sidebar.disabledOperation(true);
      Navbar.disabledOperation(true);
    }

    this.setModeClassToMainDiv(afterMode);
    return window.eventPointingMode = afterMode;
  }

  // イベントポインタ表示削除
  static clearEventPointer() {
    if((typeof EventDragPointingDraw !== 'undefined' && EventDragPointingDraw !== null) && (EventDragPointingDraw.clear !== null)) {
      EventDragPointingDraw.clear();
    }
    if((typeof EventDragPointingRect !== 'undefined' && EventDragPointingRect !== null) && (EventDragPointingRect.clear !== null)) {
      return EventDragPointingRect.clear();
    }
  }

  // ID=MainのDivにクラス名を設定
  static setModeClassToMainDiv(mode) {
    const classes = [
      'draw_mode',
      'draw_pointing',
      'click_pointing'
    ];
    $('#main').removeClass(classes.join(' '));
    if(mode === constant.Mode.DRAW) {
      return $('#main').addClass('draw_mode');
    } else if(mode === constant.EventInputPointingMode.DRAW) {
      return $('#main').addClass('draw_pointing');
    } else if(mode === constant.EventInputPointingMode.ITEM_TOUCH) {
      return $('#main').addClass('click_pointing');
    }
  }

  // モードを一つ前に戻す
  static putbackMode() {
    if(window.beforeMode !== null) {
      this.changeMode(window.beforeMode);
      return window.beforeMode = null;
    }
  }

  // アイテム描画が変更されている場合にインスタンスから全アイテム再描画
  // @param [Integer] pn ページ番号
  static stopPreviewAndRefreshAllItemsFromInstancePageValue(pn, callback = null) {
    // イベント停止
    if(pn === null) {
      pn = PageValue.getPageNum();
    }
    return this.stopAllEventPreview(function(noRunningPreview) {
      if(window.worktableItemsChangedState || !noRunningPreview) {
        // アイテムの状態に変更がある場合は再描画処理
        const items = Common.instancesInPage(pn);
        if(items.length > 0) {
          let callbackCount = 0;
          for(let item of Array.from(items)) {
            item.refreshFromInstancePageValue(true, function() {
              callbackCount += 1;
              if(callbackCount >= items.length) {
                // アイテム状態変更フラグOFF
                window.worktableItemsChangedState = false;
                if(callback !== null) {
                  return callback();
                }
              }
            });
          }
        }

        // アイテムフォーカスしてる場合があるので表示位置を戻す
        WorktableCommon.initScrollContentsPosition();
        // イベントで変更された倍率を戻す
        const se = new ScreenEvent();
        se.resetNowScaleToWorktableScale();
        // Footprint履歴削除
        PageValue.removeAllFootprint();
        if(items.length === 0) {
          if(callback !== null) {
            return callback();
          }
        }
      } else {
        if(callback !== null) {
          return callback();
        }
      }
    });
  }

  // 非表示をクリア
  static clearAllItemStyle() {
    const object = Common.allItemInstances();
    for(let k in object) {
      const v = object[k];
      v.clearAllEventStyle();
    }

    // 選択枠を取る
    this.clearSelectedBorder();
    // 全てのカラーピッカーを閉じる
    return $('.colorPicker').ColorPickerHide();
  }

  // 対象アイテムに対してフォーカスする(サイドバーオープン時)
  // @param [Object] target 対象アイテム
  // @param [String] selectedBorderType 選択枠タイプ
  static focusToTargetWhenSidebarOpen(target, selectedBorderType, immediate) {
    // 選択枠設定
    if(selectedBorderType === null) {
      selectedBorderType = "edit";
    }
    if(immediate === null) {
      immediate = false;
    }
    this.setSelectedBorder(target, selectedBorderType);
    return Common.focusToTarget(target, null, immediate);
  }

  // キーイベント初期化
  static initKeyEvent() {
    return $(window).off('keydown').on('keydown', function(e) {
      const target = $(e.target);
      if((target.prop('tagName') === 'INPUT') || (target.prop('tagName') === 'TEXTAREA')) {
        return;
      }
      const isMac = navigator.platform.toUpperCase().indexOf('MAC') >= 0;
      if((isMac && e.metaKey) || (!isMac && e.ctrlKey)) {
        let step, updatedScale;
        if(window.debug) {
          console.log(e);
        }
        if(e.keyCode === constant.KeyboardKeyCode.Z) {
          e.preventDefault();
          if(e.shiftKey) {
            // Shift + Ctrl + z → Redo
            return OperationHistory.redo();
          } else {
            // Ctrl + z → Undo
            return OperationHistory.undo();
          }
        } else if(e.keyCode === constant.KeyboardKeyCode.C) {
          e.preventDefault();
          // Ctrl + c -> Copy
          WorktableCommon.copyItem();
          return WorktableCommon.setMainContainerContext();
        } else if(e.keyCode === constant.KeyboardKeyCode.X) {
          e.preventDefault();
          // Ctrl + x -> Cut
          WorktableCommon.cutItem();
          return WorktableCommon.setMainContainerContext();
        } else if(e.keyCode === constant.KeyboardKeyCode.V) {
          e.preventDefault();
          // 貼り付け
          WorktableCommon.pasteItem();
          // 履歴保存
          return OperationHistory.add();
        } else if(e.shiftKey && ((e.keyCode === constant.KeyboardKeyCode.PLUS) || (e.keyCode === constant.KeyboardKeyCode.SEMICOLON))) {
          e.preventDefault();
          // ズームイン
          step = 0.1;
          updatedScale = WorktableCommon.getWorktableViewScale() + step;
          WorktableCommon.setWorktableViewScale(updatedScale, true);
          if(Sidebar.isOpenedConfigSidebar()) {
            return WorktableSetting.PositionAndScale.initConfig();
          }
        } else if((e.keyCode === constant.KeyboardKeyCode.MINUS) || (e.keyCode === constant.KeyboardKeyCode.F_MINUS)) {
          e.preventDefault();
          // ズームアウト
          step = 0.1;
          updatedScale = WorktableCommon.getWorktableViewScale() - step;
          WorktableCommon.setWorktableViewScale(updatedScale, true);
          if(Sidebar.isOpenedConfigSidebar()) {
            return WorktableSetting.PositionAndScale.initConfig();
          }
        }
      }
    });
  }

  // Mainビューの高さ更新
  static updateMainViewSize() {
    const borderWidth = 5;
    const timelineTopPadding = 5;
    $('#main').height($('#contents').height() - $('#timeline').height() - timelineTopPadding - (borderWidth * 2));
    return $('#sidebar').height($('#contents').height() - (borderWidth * 2));
  }

  // スクロール位置初期化
  static initScrollContentsPosition() {
    return Common.initScrollContentsPositionByWorktableConfig();
  }

  // 画面サイズ設定
  static resizeMainContainerEvent() {
    this.updateMainViewSize();
    Common.updateCanvasSize();
    Common.initScrollContentsPositionByWorktableConfig();
    return Sidebar.resizeConfigHeight();
  }

  // ウィンドウリサイズイベント
  static resizeEvent() {
    if((window.skipResizeEvent !== null) && window.skipResizeEvent) {
      return window.skipResizeEvent = false;
    } else {
      return WorktableCommon.resizeMainContainerEvent();
    }
  }

  // アイテムを削除
  static removeSingleItem(itemElement) {
    const targetId = $(itemElement).attr('id');
    PageValue.removeInstancePageValue(targetId);
    PageValue.removeEventPageValueSync(targetId);
    if(window.instanceMap[targetId] !== null) {
      window.instanceMap[targetId].getJQueryElement().remove();
    }
    PageValue.adjustInstanceAndEventOnPage();
    Timeline.refreshAllTimeline();
    window.lStorage.saveAllPageValues();
    return OperationHistory.add();
  }

  // ページ削除
  static removePage(pageNum, callback = null) {
    // ページHTMLを削除
    const root = $(`#${constant.Paging.ROOT_ID}`);
    const afterSectionClass = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageCount());
    let afterSection = $(`.${afterSectionClass}:first`, root);
    for(let p = PageValue.getPageCount() - 1, end = pageNum; p >= end; p--) {
      // ページをずらす
      const beforeSectionClass = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', p);
      const beforeSection = $(`.${beforeSectionClass}:first`, root);
      afterSection.removeClass(afterSectionClass).addClass(beforeSectionClass);
      afterSection.css('z-index', Common.plusPagingZindex(0, p));
      afterSection = beforeSection;
    }
    afterSection.remove();
    // 共通イベントのデータを削除
    this.removeCommonEventInstances(pageNum);
    // PageValueを削除
    PageValue.removeAndShiftGeneralPageValueOnPage(pageNum);
    PageValue.removeAndShiftInstancePageValueOnPage(pageNum);
    PageValue.removeAndShiftEventPageValueOnPage(pageNum);
    PageValue.removeAndShiftFootprintPageValueOnPage(pageNum);
    // ページ総数を減らす
    PageValue.updatePageCount();
    // PageValue調整
    PageValue.adjustInstanceAndEventOnPage();
    if(callback !== null) {
      return callback();
    }
  }

  /* デバッグ */
  static runDebug() {
  }

  // Mainコンテナ初期化
  static initMainContainer() {
    // 定数 & レイアウト & イベント系変数の初期化
    CommonVar.worktableCommonVar();
    Common.updateCanvasSize();
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT));
    // スクロールサイズ
    window.scrollInsideWrapper.width(window.scrollViewSize);
    window.scrollInsideWrapper.height(window.scrollViewSize);
    window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM + 1));
    // スクロールイベント設定
    window.scrollContents.off('scroll').on('scroll', function(e) {
      if((window.skipScrollEvent !== null) && window.skipScrollEvent) {
        window.skipScrollEvent = false;
        return;
      }
      if((window.skipScrollEventByAnimation !== null) && window.skipScrollEventByAnimation) {
        return;
      }
      e.preventDefault();
      e.stopPropagation();
      const scrollContentsSize = Common.scrollContentsSizeUnderViewScale();
      const top = window.scrollContents.scrollTop() + (scrollContentsSize.height * 0.5);
      const left = window.scrollContents.scrollLeft() + (scrollContentsSize.width * 0.5);
      const centerPosition = Common.calcScrollCenterPosition(top, left);
      if(centerPosition !== null) {
        FloatView.show(FloatView.scrollMessage(centerPosition.top.toFixed(1), centerPosition.left.toFixed(1)), FloatView.Type.DISPLAY_POSITION);
      }
      return Common.saveDisplayPosition(top, left, false, function() {
        FloatView.hide();
        if(Sidebar.isOpenedConfigSidebar()) {
          return WorktableSetting.PositionAndScale.initConfig();
        }
      });
    });
    // ドロップダウン
    $('.dropdown-toggle').dropdown();
    // ナビバー
    Navbar.initWorktableNavbar();
    // キーイベント
    this.initKeyEvent();
    // ドラッグ描画イベント
    Handwrite.initHandwrite();
    // コンテキストメニュー
    this.setMainContainerContext();
    $('#project_contents').off("mousedown");
    $('#project_contents').on("mousedown", () => {
      return this.clearAllItemStyle();
    });
    // 環境設定
    Common.applyEnvironmentFromPagevalue();
    // コンフィグ設定初期化
    StateConfig.clearScreenConfig();
    // Mainビュー高さ設定
    this.updateMainViewSize();
    // コンフィグ高さ設定
    Sidebar.resizeConfigHeight();
    // 共通設定
    WorktableSetting.clear();
    WorktableSetting.initConfig();
    // 選択アイテム初期化
    WorktableCommon.changeEventPointingMode(constant.EventInputPointingMode.NOT_SELECT);
    // ページ総数更新
    PageValue.updatePageCount();
    // フォーク総数更新
    PageValue.updateForkCount();
    // ページング初期化
    return Paging.initPaging();
  }

  // スクロール位置を再設定
  static adjustScrollContentsPosition() {
    Common.applyViewScale();
    const p = PageValue.getWorktableScrollContentsPosition();
    if(window.debug) {
      console.log('adjustScrollContentsPosition');
      console.log(p);
    }
    return Common.updateScrollContentsPosition(p.top, p.left);
  }

  // Mainコンテナのコンテキストメニューを設定
  static setMainContainerContext() {
    // コンテキストメニュー
    const menu = [];
    if(window.copiedInstance !== null) {
      menu.push({
        title: I18n.t('context_menu.paste'), cmd: "paste", uiIcon: "ui-icon-scissors", func(event, ui) {
          // 貼り付け
          WorktableCommon.pasteItem();
          // キャッシュ保存
          window.lStorage.saveAllPageValues();
          // 履歴保存
          return OperationHistory.add();
        }
      });
    }
    const page = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum());
    return WorktableCommon.setupContextMenu($(`#pages .${page} .scroll_inside:first`), `#pages .${page} .main-wrapper:first`, menu);
  }

  // ワークテーブル初期化
  static resetWorktable() {
    // アイテムを全消去
    return this.removeAllItemAndEvent(() => {
      // ページを全消去
      $('#pages .section').remove();
      // 環境をリセット
      Common.resetEnvironment();
      // アイテム選択をデフォルトに戻す
      Navbar.setDefaultItemSelect();
      // 変数初期化
      CommonVar.initVarWhenLoadedView();
      CommonVar.initCommonVar();
      // Mainコンテナ作成
      Common.createdMainContainerIfNeeded(PageValue.getPageNum());
      // コンテナ初期化
      this.initMainContainer();
      // Mainビューの高さを初期化
      $('#main').css('height', '');
      // キャッシュ削除
      window.lStorage.clearWorktableWithoutSetting();
      // ページ数初期化
      PageValue.setPageNum(1);
      // 履歴に画面初期時を状態を保存
      OperationHistory.add(true);
      // ページ総数更新
      PageValue.updatePageCount();
      // フォーク総数更新
      PageValue.updateForkCount();
      // プロジェクトビュー & タイムラインを閉じる
      $('#project_wrapper').hide();
      return $('#timeline').hide();
    });
  }

  // ワークテーブルの画面倍率を取得
  static getWorktableViewScale(pn) {
    if(pn === null) {
      pn = PageValue.getPageNum();
    }
    return Common.getWorktableViewScale(pn);
  }

  // ワークテーブルの画面倍率を設定
  static setWorktableViewScale(scale, withViewStateUpdate) {
    if(withViewStateUpdate === null) {
      withViewStateUpdate = false;
    }
    PageValue.setGeneralPageValue(PageValue.Key.worktableScale(), scale);
    if(withViewStateUpdate) {
      FloatView.show(`View scale : ${parseInt(scale * 100)}%`, FloatView.Type.SCALE, 1.0);
      // スクロール位置修正
      this.adjustScrollContentsPosition();
      // キャッシュ保存
      return window.lStorage.saveGeneralPageValue();
    }
  }

  // コンテキストメニュー初期化
  // @param [String] elementID HTML要素ID
  // @param [String] contextSelector
  // @param [Array] menu 表示メニュー
  static setupContextMenu(element, contextSelector, menu) {
    return Common.setupContextMenu(element, contextSelector, {
      menu,
      select(event, ui) {
        return (() => {
          const result = [];
          for(let value of Array.from(menu)) {
            if(value.cmd === ui.cmd) {
              result.push(value.func(event, ui));
            } else {
              result.push(undefined);
            }
          }
          return result;
        })();
      },
      beforeOpen(event, ui) {
        const t = $(event.target);
        // 選択メニューを最前面に表示
        ui.menu.zIndex($(event.target).zIndex() + 1);
        if((window.mode === constant.Mode.EDIT) && $(t).hasClass('item')) {
          // 選択状態にする
          return WorktableCommon.setSelectedBorder(t);
        }
      }
    });
  }

  // 全てのアイテムとイベントを削除
  static removeAllItemAndEvent(callback = null) {
    Sidebar.closeSidebar();
    // WebStorageのアイテム&イベント情報を消去
    window.lStorage.clearWorktableWithoutSetting();
    Common.removeAllItem();
    EventConfig.removeAllConfig();
    PageValue.removeAllGeneralAndInstanceAndEventPageValue();
    Timeline.refreshAllTimeline();
    if(callback !== null) {
      return callback();
    }
  }

  // ページ内の全てのアイテムとイベントを削除
  static removeAllItemAndEventOnThisPage(callback = null) {
    Sidebar.closeSidebar();
    // WebStorageのアイテム&イベント情報を消去
    window.lStorage.clearWorktableWithoutGeneralAndSetting();
    Common.removeAllItem(PageValue.getPageNum());
    EventConfig.removeAllConfig();
    PageValue.removeAllInstanceAndEventPageValueOnPage();
    Timeline.refreshAllTimeline();
    if(callback !== null) {
      return callback();
    }
  }

  // 共通イベントインスタンス作成
  static createCommonEventInstancesOnThisPageIfNeeded() {
    return (() => {
      const result = [];
      for(let clsToken in window.classMap) {
        const cls = window.classMap[clsToken];
        if(cls.prototype instanceof CommonEvent) {
          const instance = new (Common.getClassFromMap(cls.CLASS_DIST_TOKEN))();
          if((window.instanceMap[instance.id] === null)) {
            Common.setInstanceFromMap(instance.id, instance.constructor.CLASS_DIST_TOKEN);
            result.push(instance.setItemAllPropToPageValue());
          } else {
            result.push(undefined);
          }
        } else {
          result.push(undefined);
        }
      }
      return result;
    })();
  }

  // 共通イベントのページインスタンス削除
  static removeCommonEventInstances(pn) {
    if(pn === null) {
      pn = PageValue.getPageNum();
    }
    return (() => {
      const result = [];
      for(let clsToken in window.classMap) {
        const cls = window.classMap[clsToken];
        if(cls.prototype instanceof CommonEvent) {
          result.push(cls.deleteInstanceOnPage(pn));
        } else {
          result.push(undefined);
        }
      }
      return result;
    })();
  }

  // PageValueから全てのインスタンスを作成
  // @param [Function] callback コールバック
  // @param [Integer] pageNum 描画するPageValueのページ番号
  static createAllInstanceAndDrawFromInstancePageValue(callback = null, pageNum) {
    if(pageNum === null) {
      pageNum = PageValue.getPageNum();
    }
    let count = 0;
    return Common.loadJsFromInstancePageValue(function() {
        // インスタンス取得 & PageValueの値で初期化
        const items = Common.itemInstancesInPage(pageNum, true, true);
        // Worktable設定によるアイテム表示状態取得
        const itemHideState = PageValue.getWorktableItemHide();

        const _cbk = function(i) {
          if((itemHideState[i.id] !== null) && itemHideState[i.id]) {
            // 非表示にする
            i.getJQueryElement().hide();
          }
          count += 1;
          if(count >= items.length) {
            // コールバック
            if(callback !== null) {
              return callback();
            }
          }
        };

        return Array.from(items).map((item) =>
          (item.drawAndMakeConfigs !== null) ?
            item.drawAndMakeConfigs(true, i => {
              return _cbk.call(this, i);
            })
            :
            _cbk.call(this, item));
      }
      , pageNum);
  }

  // イベント進行ルートを取得
  // @param [Integer] finishTeNum 終了イベント番号
  // @param [Integer] finishFn 終了フォーク番号
  // @return [Array] EventPageValue配列 無い場合は空配列
  static eventProgressRoute(finishTeNum, finishFn) {
    if(finishFn === null) {
      finishFn = PageValue.getForkNum();
    }
    finishTeNum = parseInt(finishTeNum);
    finishFn = parseInt(finishFn);
    var _trace = function(forkNum) {
      let result;
      const routes = [];
      const tes = PageValue.getEventPageValueSortedListByNum(forkNum);
      if(tes.length === 0) {
        return {result: true, routes: []};
      }
      for(let idx = 0; idx < tes.length; idx++) {
        const te = tes[idx];
        const changeForkNum = te[EventPageValueBase.PageValueKey.CHANGE_FORKNUM];
        if((changeForkNum !== null) && (changeForkNum !== forkNum)) {
          const ret = _trace.call(this, changeForkNum);
          ({result} = ret);
          if(result) {
            routes.push(te);
            $.merge(routes, ret.routes);
            return {result: true, routes};
          }
        } else {
          routes.push(te);
          if(((idx + 1) === finishTeNum) && (forkNum === finishFn)) {
            // 発見
            return {result: true, routes};
          }
        }
      }

      if(((tes.length + 1) === finishTeNum) && (forkNum === finishFn)) {
        return {result: true, routes};
      } else {
        return {result: false, routes: []};
      }
    };

    return _trace.call(this, PageValue.Key.EF_MASTER_FORKNUM);
  }

  // イベント進行ルートが繋がっているか
  static isConnectedEventProgressRoute(finishTeNum, finishFn) {
    if(finishFn === null) {
      finishFn = PageValue.getForkNum();
    }
    const ret = this.eventProgressRoute(finishTeNum, finishFn);
    return ret.result;
  }

  // 指定イベント以前をイベント適用後の状態に変更
  static updatePrevEventsToAfter(teNum, keepDispMag, fromBlankEventConfig, callback = null) {
    if(keepDispMag === null) {
      keepDispMag = false;
    }
    if(fromBlankEventConfig === null) {
      fromBlankEventConfig = false;
    }
    return _updatePrevEventsToAfterAndRunPreview.call(this, teNum, keepDispMag, fromBlankEventConfig, false, callback);
  }

  // プレビュー実行
  // @param [Integer] te_num 実行するイベント番号
  static runPreview(teNum, keepDispMag, callback = null) {
    if(keepDispMag === null) {
      keepDispMag = false;
    }
    return _updatePrevEventsToAfterAndRunPreview.call(this, teNum, keepDispMag, false, true, callback);
  }

  static stopPreview(keepDispMag, callback = null) {
    // プレビューの実行回数超過
    // ボタン変更「StopPreview」->「Preview」
    EventConfig.switchPreviewButton(true);
    // 全てのアイテム状態をイベント前にする
    this.updateAllItemsToBeforePreview(keepDispMag);
    // アイテム再描画
    return this.stopPreviewAndRefreshAllItemsFromInstancePageValue(PageValue.getPageNum(), () => {
      FloatView.hideWithCloseButtonView();
      if(callback !== null) {
        return callback();
      }
    });
  }

  // 全てのアイテム状態をイベント前に戻す(プレビュー停止前に動作させること)
  // @param [Function] callback コールバック
  static updateAllItemsToBeforePreview(keepDispMag) {
    // EventPageValueを読み込み、全てイベント実行前(updateEventBefore)にする
    const tesArray = [];
    tesArray.push(PageValue.getEventPageValueSortedListByNum(PageValue.Key.EF_MASTER_FORKNUM));
    const forkNum = PageValue.getForkNum();
    if(forkNum > 0) {
      for(let i = 1, end = forkNum, asc = 1 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
        // フォークデータを含める
        tesArray.push(PageValue.getEventPageValueSortedListByNum(i));
      }
    }
    return Array.from(tesArray).map((tes) =>
      (() => {
        const result = [];
        for(let idx = tes.length - 1; idx >= 0; idx--) {
          const te = tes[idx];
          const item = window.instanceMap[te.id];
          if(item !== null) {
            item.initEvent(te, keepDispMag);
            result.push(item.updateEventBefore());
          } else {
            result.push(undefined);
          }
        }
        return result;
      })());
  }

  // 全イベントのプレビューを停止
  // @param [Function] callback コールバック
  static stopAllEventPreview(callback = null) {
    if((window.previewRunning === null) || !window.previewRunning) {
      // プレビューが動作していない場合は処理無し
      if(callback !== null) {
        callback(true);
      }
      return;
    }

    // EventPageValueの退避がある場合戻す
    return this.reverseStashEventPageValueForPreviewIfNeeded(() => {
      let count = 0;
      const {length} = Object.keys(window.instanceMap);
      let noRunningPreview = true;
      if(length === 0) {
        if(callback !== null) {
          return callback(noRunningPreview);
        }
      } else {
        for(let k in window.instanceMap) {
          const v = window.instanceMap[k];
          if(v.stopPreview !== null) {
            v.stopPreview(function(wasRunningPreview) {
              count += 1;
              if(wasRunningPreview) {
                noRunningPreview = false;
              }
              if(length <= count) {
                window.previewRunning = false;
                // ボタン変更「StopPreview」->「Preview」
                EventConfig.switchPreviewButton(true);
                if(callback !== null) {
                  callback(noRunningPreview);
                }
                return;
              }
            });
          } else {
            count += 1;
            if(length <= count) {
              window.previewRunning = false;
              // ボタン変更「StopPreview」->「Preview」
              EventConfig.switchPreviewButton(true);
              if(callback !== null) {
                callback(noRunningPreview);
              }
              return;
            }
          }
        }
      }
    });
  }

  static stashEventPageValueForPreview(teNum, callback = null) {
    const _callback = function() {
      window.stashedEventPageValueForPreview = {
        pageNum: PageValue.getPageNum(),
        forkNum: PageValue.getForkNum(),
        teNum,
        value: PageValue.getEventPageValue(PageValue.Key.eventNumber(teNum))
      };
      if(callback !== null) {
        return callback();
      }
    };

    if(window.stashedEventPageValueForPreview !== null) {
      // 既ににある場合は一度戻す
      return this.reverseStashEventPageValueForPreviewIfNeeded(() => {
        return _callback.call(this);
      });
    } else {
      return _callback.call(this);
    }
  }

  static reverseStashEventPageValueForPreviewIfNeeded(callback = null) {
    if((window.stashedEventPageValueForPreview === null)) {
      // 無い場合は終了
      if(callback !== null) {
        callback();
      }
      return;
    }

    const {pageNum} = window.stashedEventPageValueForPreview;
    const {forkNum} = window.stashedEventPageValueForPreview;
    const {teNum} = window.stashedEventPageValueForPreview;
    const {value} = window.stashedEventPageValueForPreview;
    PageValue.setEventPageValue(PageValue.Key.eventNumber(teNum, forkNum, pageNum), value);
    window.stashedEventPageValueForPreview = null;
    if(callback !== null) {
      return callback();
    }
  }
};
WorktableCommon.initClass();

