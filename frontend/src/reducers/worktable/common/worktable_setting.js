import Common from '../../../base/common';
import PageValue from '../../../base/page_value';
import WorktableCommon from './worktable_common';
import {Constant} from "../../../base/constant";

let constant = undefined;
export default class WorktableSetting {

  static get ROOT_ID_NAME() {
    return Constant.SETTING.ROOT_ID_NAME;
  }

  static get GRID() {
    return class {
      static get GRID_CLASS_NAME() { return  Constant.SETTING.GRID_CLASS_NAME }
      static get GRID_STEP_CLASS_NAME() { return Constant.SETTING.GRID_STEP_CLASS_NAME }
      static get GRID_STEP_DIV_CLASS_NAME() { return Constant.SETTING.GRID_STEP_DIV_CLASS_NAME }
      static get SETTING_GRID_ELEMENT_CLASS() { return  'setting_grid_element' }
      static get SETTING_GRID_CANVAS_CLASS() { return 'setting_grid' }
      static get GRIDVIEW_SIZE() { return  10000 }
      static get STEP_DEFAULT_VALUE() { return 12 }
      static get PAGE_VALUE_KEY() {
        return {
          GRID: `${PageValue.Key.ST_PREFIX}${PageValue.Key.PAGE_VALUES_SEPERATOR}${constant.Setting.Key.GRID_ENABLE}`,
          GRID_STEP: `${PageValue.Key.ST_PREFIX}${PageValue.Key.PAGE_VALUES_SEPERATOR}${constant.Setting.Key.GRID_STEP}`
        }
      }

      // グリッド初期化
      static initConfig() {
        const root = $(`#${WorktableSetting.ROOT_ID_NAME}`);
        // グリッド線表示
        const grid = $(`.${this.GRID_CLASS_NAME}`, root);
        let gridValue = PageValue.getSettingPageValue(this.PageValueKey.GRID);
        gridValue = (gridValue !== null) && (gridValue === 'true');
        const gridStepDiv = $(`.${this.GRID_STEP_DIV_CLASS_NAME}`, root);
        grid.prop('checked', gridValue ? 'checked' : false);
        grid.off('click').on('click', () => {
          gridValue = PageValue.getSettingPageValue(this.PageValueKey.GRID);
          if(gridValue !== null) {
            gridValue = gridValue === 'true';
          }
          // グリッド間隔の有効無効を切り替え
          if(!gridValue) {
            gridStepDiv.show();
          } else {
            gridStepDiv.hide();
          }
          this.drawGrid(!gridValue);
          gridValue = PageValue.getSettingPageValue(this.PageValueKey.GRID);
          return grid.prop("checked", gridValue === 'true');
        });

        // グリッド間隔の有効無効を切り替え
        if(gridValue) {
          gridStepDiv.show();
        } else {
          gridStepDiv.hide();
        }

        // グリッド間隔
        let gridStepValue = PageValue.getSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID_STEP);
        if((gridStepValue === null)) {
          gridStepValue = this.STEP_DEFAULT_VALUE;
        }
        const gridStep = $(`.${this.GRID_STEP_CLASS_NAME}`, root);
        gridStep.val(gridStepValue);
        gridStep.change(e => {
          let value = PageValue.getSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID);
          if(value !== null) {
            value = value === 'true';
          }
          if(value) {
            let step = $(e.target).val();
            if(step !== null) {
              step = parseInt(step);
              PageValue.setSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID_STEP, step);
              return this.drawGrid(true);
            }
          }
        });
        // 描画
        return this.drawGrid(gridValue);
      }

      // 初期化
      static clear() {
        const root = $(`#${WorktableSetting.ROOT_ID_NAME}`);
        const grid = $(`.${this.GRID_CLASS_NAME}`, root);
        grid.prop('checked', false);
        const gridStepValue = this.STEP_DEFAULT_VALUE;
        const gridStep = $(`.${this.GRID_STEP_CLASS_NAME}`, root);
        gridStep.val(gridStepValue);
        return this.drawGrid(false);
      }

      // グリッド線描画
      // @param [Boolean] doDraw 描画するか
      static drawGrid(doDraw) {
        const page = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum());
        let canvas = $(`#pages .${page} .${this.SETTING_GRID_CANVAS_CLASS}:first`)[0];
        let context = null;
        if(canvas !== null) {
          context = canvas.getContext('2d');
        }
        if((context !== null) && (doDraw === false)) {
          // 削除
          $(`.${this.SETTING_GRID_ELEMENT_CLASS}`).remove();
          PageValue.setSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID, false);
          return window.lStorage.saveSettingPageValue();
        } else if(doDraw) {
          let i;
          let asc, end, step1;
          let asc1, end1, step2;
          const root = $(`#${WorktableSetting.ROOT_ID_NAME}`);
          const stepInput = $(`.${this.GRID_STEP_CLASS_NAME}`, root);
          let step = stepInput.val();
          if((step === null) || (step.length === 0)) {
            stepInput.val(this.STEP_DEFAULT_VALUE);
            step = this.STEP_DEFAULT_VALUE;
          }
          step = parseInt(step);
          const min = parseInt(stepInput.attr('min'));
          const max = parseInt(stepInput.attr('max'));
          if((step < min) || (step > max)) {
            return;
          }
          const stepx = step;
          const stepy = step;
          let top = window.scrollContents.scrollTop() - (this.GRIDVIEW_SIZE * 0.5);
          top -= top % stepy;
          if(top < 0) {
            top = 0;
          }
          let left = window.scrollContents.scrollLeft() - (this.GRIDVIEW_SIZE * 0.5);
          left -= left % stepx;
          if(left < 0) {
            left = 0;
          }
          if((context === null)) {
            // キャンパスを作成
            $(this.createGridElement(top, left)).appendTo(window.scrollInside);
            canvas = $(`#pages .${page} .${this.SETTING_GRID_CANVAS_CLASS}:first`)[0];
            context = canvas.getContext('2d');
          } else {
            const emt = $(`#pages .${page} .${this.SETTING_GRID_ELEMENT_CLASS}:first`);
            emt.css({top: `${top}px`, left: `${left}px`});
            // 描画をクリア
            context.clearRect(0, 0, canvas.width, canvas.height);
          }

          // 描画
          context.strokeStyle = 'black';
          context.lineWidth = 0.5;
          for(i = stepx + 0.5, end = context.canvas.width, step1 = stepx, asc = step1 > 0; asc ? i <= end : i >= end; i += step1) {
            context.beginPath();
            context.moveTo(i, 0);
            context.lineTo(i, context.canvas.height);
            context.stroke();
          }
          for(i = stepy + 0.5, end1 = context.canvas.height, step2 = stepy, asc1 = step2 > 0; asc1 ? i <= end1 : i >= end1; i += step2) {
            context.beginPath();
            context.moveTo(0, i);
            context.lineTo(context.canvas.width, i);
            context.stroke();
          }

          PageValue.setSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID, true);
          return window.lStorage.saveSettingPageValue();
        }
      }

      // グリッド線のテンプレートHTMLを読み込み
      // @param [Integer] top HTMLを設置するY位置
      // @param [Integer] left HTMLを設置するX位置
      // @return [String] HTML
      static createGridElement(top, left) {
        return `\
<div class="${this.SETTING_GRID_ELEMENT_CLASS}" style="position: absolute;top:${top}px;left:${left}px;width:${this.GRIDVIEW_SIZE}px;height:${this.GRIDVIEW_SIZE}px;z-index:${Common.plusPagingZindex(Constant.Zindex.GRID)}"><canvas class="${this.SETTING_GRID_CANVAS_CLASS}" class="canvas" width="${this.GRIDVIEW_SIZE}" height="${this.GRIDVIEW_SIZE}"></canvas></div>\
`;
      }
    }
  }

  static get IDLE_SAVE_TIMER() {
    return class {

      static get AUTOSAVE_CLASS_NAME() { return Constant.SETTING.AUTOSAVE_CLASS_NAME; }
      static get AUTOSAVE_TIME_CLASS_NAME() { return Constant.SETTING.AUTOSAVE_TIME_CLASS_NAME }
      static get AUTOSAVE_TIME_DIV_CLASS_NAME() { return Constant.SETTING.AUTOSAVE_TIME_DIV_CLASS_NAME }
      static get AUTOSAVE_TIME_DEFAULT() { return 10 }
      static get PAGE_VALUE_KEY() {
        return {
          AUTOSAVE: `${PageValue.Key.ST_PREFIX}${PageValue.Key.PAGE_VALUES_SEPERATOR}${constant.Setting.Key.AUTOSAVE}`,
          AUTOSAVE_TIME: `${PageValue.Key.ST_PREFIX}${PageValue.Key.PAGE_VALUES_SEPERATOR}${constant.Setting.Key.AUTOSAVE_TIME}`
        }
      }

      static initConfig() {
        const root = $(`#${WorktableSetting.ROOT_ID_NAME}`);
        // Autosave表示
        const enable = $(`.${this.AUTOSAVE_CLASS_NAME}`, root);
        let enableValue = PageValue.getSettingPageValue(this.PageValueKey.AUTOSAVE);
        if((enableValue === null)) {
          enableValue = 'true';
          PageValue.setSettingPageValue(this.PageValueKey.AUTOSAVE, enableValue);
        }
        enableValue = (enableValue !== null) && (enableValue === 'true');
        const autosaveTimeDiv = $(`.${this.AUTOSAVE_TIME_DIV_CLASS_NAME}`, root);
        enable.prop('checked', enableValue ? 'checked' : false);
        enable.off('click').on('click', () => {
          enableValue = PageValue.getSettingPageValue(this.PageValueKey.AUTOSAVE);
          if(enableValue !== null) {
            enableValue = enableValue === 'true';
          }
          // グリッド間隔の有効無効を切り替え
          if(!enableValue) {
            autosaveTimeDiv.show();
          } else {
            autosaveTimeDiv.hide();
          }
          return PageValue.setSettingPageValue(this.PageValueKey.AUTOSAVE, !enableValue);
        });

        // Autosaveの有効無効を切り替え
        if(enableValue) {
          autosaveTimeDiv.show();
        } else {
          autosaveTimeDiv.hide();
        }

        // Autosave間隔
        let autosaveTimeValue = PageValue.getSettingPageValue(this.PageValueKey.AUTOSAVE_TIME);
        if((autosaveTimeValue === null)) {
          autosaveTimeValue = this.AUTOSAVE_TIME_DEFAULT;
          PageValue.setSettingPageValue(this.PageValueKey.AUTOSAVE_TIME, autosaveTimeValue);
        }
        const autosaveTime = $(`.${this.AUTOSAVE_TIME_CLASS_NAME}`, root);
        autosaveTime.val(autosaveTimeValue);
        return autosaveTime.change(e => {
          let value = PageValue.getSettingPageValue(WorktableSetting.IdleSaveTimer.PageValueKey.AUTOSAVE);
          if(value !== null) {
            value = value === 'true';
          }
          if(value) {
            let step = $(e.target).val();
            if(step !== null) {
              step = parseInt(step);
              return PageValue.setSettingPageValue(WorktableSetting.IdleSaveTimer.PageValueKey.AUTOSAVE_TIME, step);
            }
          }
        });
      }

      // 初期化
      static clear() {
        const root = $(`#${WorktableSetting.ROOT_ID_NAME}`);
        // Autosave表示
        const enable = $(`.${this.AUTOSAVE_CLASS_NAME}`, root);
        enable.prop('checked', true);
        return PageValue.setSettingPageValue(this.PageValueKey.AUTOSAVE, true);
      }

      static isEnabled() {
        const enableValue = PageValue.getSettingPageValue(this.PageValueKey.AUTOSAVE);
        if(enableValue !== null) {
          return enableValue === 'true';
        } else {
          return false;
        }
      }

      static idleTime() {
        return PageValue.getSettingPageValue(this.PageValueKey.AUTOSAVE_TIME);
      }
    }
  }

  static get POSITION_AND_SCALE() {
    return class {
      // コンフィグ初期化
      static initConfig() {
        if((Common.getScreenSize() === null)) {
          return;
        }

        const rootEmt = $(`#${WorktableSetting.ROOT_ID_NAME}`);
        // 画面座標
        let position = PageValue.getWorktableScrollContentsPosition();
        let center = Common.calcScrollCenterPosition(position.top, position.left);
        $('.display_position_x', rootEmt).val(parseInt(center.left));
        $('.display_position_y', rootEmt).val(parseInt(center.top));
        const leftMin = -window.scrollInsideWrapper.width() * 0.5;
        const leftMax = window.scrollInsideWrapper.width() * 0.5;
        const topMin = -window.scrollInsideWrapper.height() * 0.5;
        const topMax = window.scrollInsideWrapper.height() * 0.5;
        // Inputイベント
        $('.display_position_x, .display_position_y', rootEmt).off('keypress focusout').on('keypress focusout', function(e) {
          if(((e.type === 'keypress') && (e.keyCode === constant.KeyboardKeyCode.ENTER)) || (e.type === 'focusout')) {
            // スクロール位置変更
            let left = $('.display_position_x', rootEmt).val();
            let top = $('.display_position_y', rootEmt).val();
            if(left < leftMin) {
              left = leftMin;
            } else if(left > leftMax) {
              left = leftMax;
            }
            if(top < topMin) {
              top = topMin;
            } else if(top > topMax) {
              top = topMax;
            }
            $('.display_position_x', rootEmt).val(left);
            $('.display_position_y', rootEmt).val(top);
            const p = Common.calcScrollTopLeftPosition(top, left);
            PageValue.setGeneralPageValue(PageValue.Key.worktableDisplayPosition(), {top: p.top, left: p.left});
            WorktableCommon.initScrollContentsPosition();
            return window.lStorage.saveGeneralPageValue();
          }
        });

        // Zoom (0.1 〜 2.0)
        const min = 0.1;
        const max = 2.0;
        const worktableScale = WorktableCommon.getWorktableViewScale();
        const meterElement = $(".scale_meter:first", rootEmt);
        const valueElement = meterElement.prev('input:first');
        let v = parseInt(worktableScale * 100) + '%';
        valueElement.val(v);
        valueElement.html(v);
        try {
          meterElement.slider('destroy');
        } catch(error) {
        } //例外は握りつぶす
        meterElement.slider({
          min,
          max,
          step: 0.1,
          value: worktableScale,
          slide: (event, ui) => {
            v = parseInt(ui.value * 100) + '%';
            valueElement.val(v);
            valueElement.html(v);
            if(window.scaleSliderTimer !== null) {
              clearTimeout(window.scaleSliderTimer);
              window.scaleSliderTimer = null;
            }
            return window.scaleSliderTimer = setTimeout(() => {
                WorktableCommon.setWorktableViewScale(ui.value, true);
                position = PageValue.getWorktableScrollContentsPosition();
                center = Common.calcScrollCenterPosition(position.top, position.left);
                $('.display_position_x', rootEmt).val(parseInt(center.left));
                return $('.display_position_y', rootEmt).val(parseInt(center.top));
              }
              , 100);
          }
        });
        // limit
        $('.display_position_left_limit', rootEmt).html(`(${leftMin} 〜 ${leftMax})`);
        $('.display_position_top_limit', rootEmt).html(`(${topMin} 〜 ${topMax})`);
        return $('.display_position_scale_limit', rootEmt).html("(10% 〜 200%)");
      }

      static clear() {
        const scale = WorktableCommon.getWorktableViewScale();
        if(scale !== null) {
          WorktableCommon.setWorktableViewScale(scale);
        }
        WorktableCommon.initScrollContentsPosition();
        return window.lStorage.saveGeneralPageValue();
      }
    }
  }

  // 設定値初期化
  static initConfig() {
    this.Grid.initConfig();
    this.IdleSaveTimer.initConfig();
    return this.PositionAndScale.initConfig();
  }

  static clear() {
    this.Grid.clear();
    this.IdleSaveTimer.clear();
    return this.PositionAndScale.clear();
  }
};
