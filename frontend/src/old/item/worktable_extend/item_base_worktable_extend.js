window.itemBaseWorktableExtend = {
  // デザインコンフィグメニューの要素IDを取得
  // @return [String] HTML要素ID
  getDesignConfigId() {
    return this.constructor.DESIGN_CONFIG_ROOT_ID.replace('@id', this.id);
  },

  // マウスダウン時の描画イベント
  // @param [Array] loc Canvas座標
  mouseDownDrawing(callback = null) {
    this.saveDrawingSurface();
    WorktableCommon.changeMode(constant.Mode.DRAW);
    this.startDraw();
    if(callback !== null) {
      return callback();
    }
  },

  // マウスアップ時の描画イベント
  mouseUpDrawing(zindex, callback = null) {
    this.restoreAllDrawingSurface();
    return this.endDraw(zindex, true, () => {
      this.setupItemEvents();
      WorktableCommon.changeMode(constant.Mode.DRAW);
      this.saveObj(true);
      // フォーカス設定
      this.firstFocus = Common.firstFocusItemObj() === null;
      if(callback !== null) {
        return callback();
      }
    });
  },

  // ドラッグ描画開始
  startDraw() {
  },

  // ドラッグ描画(枠)
  // @param [Array] cood 座標
  draw(cood) {
    if(this.itemSize !== null) {
      this.restoreRefreshingSurface(this.itemSize);
    }

    this.itemSize = {x: null, y: null, w: null, h: null};
    this.itemSize.w = Math.abs(cood.x - this._moveLoc.x);
    this.itemSize.h = Math.abs(cood.y - this._moveLoc.y);
    if(cood.x > this._moveLoc.x) {
      this.itemSize.x = this._moveLoc.x;
    } else {
      this.itemSize.x = cood.x;
    }
    if(cood.y > this._moveLoc.y) {
      this.itemSize.y = this._moveLoc.y;
    } else {
      this.itemSize.y = cood.y;
    }
    this.itemSize.x = Math.round(this.itemSize.x);
    this.itemSize.y = Math.round(this.itemSize.y);
    this.itemSize.w = Math.round(this.itemSize.w);
    this.itemSize.h = Math.round(this.itemSize.h);
    return drawingContext.strokeRect(this.itemSize.x, this.itemSize.y, this.itemSize.w, this.itemSize.h);
  },

  // 描画終了
  // @param [Int] zindex z-index
  // @param [boolean] show 要素作成後に描画を表示するか
  endDraw(zindex, show, callback = null) {
    if(show === null) {
      show = true;
    }
    this.zindex = zindex;
    // スクロールビュー分のxとyを追加
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    return this.createItemElement(createdElement => {
      this.itemDraw(show);
      if(this.setupItemEvents !== null) {
        // アイテムのイベント設定
        this.setupItemEvents();
      }
      if(callback !== null) {
        return callback();
      }
    });
  },

  // モード変更時処理
  // @abstract
  changeMode(changeMode) {
  },

  // 描画&コンフィグ作成
  // @param [Boolean] show 要素作成後に描画を表示するか
  drawAndMakeConfigsAndWritePageValue(show, callback = null) {
    if(show === null) {
      show = true;
    }
    if(window.runDebug) {
      console.log('ItemBase drawAndMakeConfigsAndWritePageValue');
    }

    return this.drawAndMakeConfigs(show, () => {
      if(this.constructor.defaultMethodName() !== null) {
        // デフォルトイベントがある場合はイベント作成
        // Blankのタイムラインを取得
        const blank = $('#timeline_events > .timeline_event.blank:first');
        const teNum = blank.find('.te_num').val();
        const distId = blank.find('.dist_id').val();
        EPVItem.writeDefaultToPageValue(this, teNum, distId);
        // タイムライン更新
        //Timeline.refreshAllTimeline()
        Timeline.updateEvent(teNum);
        Timeline.addTimelineContainerWidth();
      }
      if(callback !== null) {
        return callback();
      }
    });
  },

  // 描画&コンフィグ作成
  // @param [boolean] show 要素作成後に描画を表示するか
  // @return [Boolean] 処理結果
  drawAndMakeConfigs(show, callback = null) {
    if(show === null) {
      show = true;
    }
    if(window.runDebug) {
      console.log('ItemBase drawAndMakeConfigs');
    }
    // アイテム描画
    return this.refresh(show, () => {
      if(callback !== null) {
        return callback(this);
      }
    });
  },

  // オプションメニューを開く
  showOptionMenu() {
    // 全てのサイドバーを非表示
    const sc = $('.sidebar-config');
    sc.hide();
    $(`.${constant.DesignConfig.ROOT_CLASSNAME}`, sc).hide();
    $('#design-config').show();
    return $(`#${this.getDesignConfigId()}`).show();
  },

  // コンテキストメニュー設定
  setupContextMenu() {
    const menu = [];
    const contextSelector = ".context_base";
    menu.push({
      title: I18n.t('context_menu.edit'), cmd: "edit", uiIcon: "ui-icon-scissors", func(event, ui) {
        // アイテム編集
        return WorktableCommon.editItem(event.target.id);
      }
    });
    menu.push({
      title: I18n.t('context_menu.copy'), cmd: "copy", uiIcon: "ui-icon-scissors", func(event, ui) {
        // コピー
        WorktableCommon.copyItem();
        return WorktableCommon.setMainContainerContext();
      }
    });
    menu.push({
      title: I18n.t('context_menu.cut'), cmd: "cut", uiIcon: "ui-icon-scissors", func(event, ui) {
        // 切り取り
        WorktableCommon.cutItem();
        return WorktableCommon.setMainContainerContext();
      }
    });
    menu.push({
      title: I18n.t('context_menu.float'), cmd: "float", uiIcon: "ui-icon-scissors", func(event, ui) {
        // 最前面移動
        const objId = $(event.target).attr('id');
        WorktableCommon.floatItem(objId);
        // キャッシュ保存
        window.lStorage.saveAllPageValues();
        // 履歴保存
        return OperationHistory.add();
      }
    });
    menu.push({
      title: I18n.t('context_menu.rear'), cmd: "rear", uiIcon: "ui-icon-scissors", func(event, ui) {
        // 最背面移動
        const objId = $(event.target).attr('id');
        WorktableCommon.rearItem(objId);
        // キャッシュ保存
        window.lStorage.saveAllPageValues();
        // 履歴保存
        return OperationHistory.add();
      }
    });
    menu.push({
      title: I18n.t('context_menu.delete'), cmd: "delete", uiIcon: "ui-icon-scissors", func(event, ui) {
        // アイテム削除
        if(window.confirm(I18n.t('message.dialog.delete_item'))) {
          return WorktableCommon.removeSingleItem(event.target);
        }
      }
    });
    return WorktableCommon.setupContextMenu(this.getJQueryElement(), contextSelector, menu);
  },

  // アイテムに対してドラッグ&リサイズイベントを設定する
  setupDragAndResizeEvent() {
    this.getJQueryElement().draggable({
      containment: scrollInside,
      drag: (event, ui) => {
        if(this.drag !== null) {
          return this.drag(ui.position);
        }
      },
      stop: (event, ui) => {
        if(this.dragComplete !== null) {
          return this.dragComplete();
        }
      }
    });
    return this.getJQueryElement().resizable({
      containment: scrollInside,
      resize: (event, ui) => {
        if(this.resize !== null) {
          return this.resize(ui.size, ui.originalSize);
        }
      },
      stop: (event, ui) => {
        if(this.resizeComplete !== null) {
          return this.resizeComplete();
        }
      }
    });
  },

  // クリックイベント設定
  setupClickEvent() {
    return this.getJQueryElement().mousedown(function(e) {
      if(e.which === 1) { //左クリック
        e.stopPropagation();
        WorktableCommon.clearSelectedBorder();
        return WorktableCommon.setSelectedBorder(this, "edit");
      }
    });
  },

  // アイテムにイベントを設定する
  setupItemEvents() {
    this.setupContextMenu();
    this.setupClickEvent();
    return this.setupDragAndResizeEvent();
  },

  // ドラッグ中イベント
  drag(position) {
    const scale = WorktableCommon.getWorktableViewScale();
    position.left /= scale;
    position.top /= scale;
    this.updateItemPosition(position.left, position.top);
    WorktableCommon.updateEditSelectBorderSize(this.getJQueryElement());
    if(window.debug) {
      console.log("drag: position:");
      console.log(position);
      return console.log(`drag: itemSize: ${JSON.stringify(this.itemSize)}`);
    }
  },

  // リサイズ時のイベント
  resize(size, originalSize) {
    const scale = WorktableCommon.getWorktableViewScale();
    const diff = {
      width: (size.width - originalSize.width) / scale,
      height: (size.height - originalSize.height) / scale
    };
    size.width = originalSize.width + diff.width;
    size.height = originalSize.height + diff.height;
    this.updateItemSize(size.width, size.height);
    WorktableCommon.updateEditSelectBorderSize(this.getJQueryElement());
    if(window.debug) {
      console.log("resize: size:");
      console.log(size);
      return console.log(`resize: itemSize: ${JSON.stringify(this.itemSize)}`);
    }
  },

  // ドラッグ完了時イベント
  dragComplete() {
    return this.saveObj();
  },

  // リサイズ完了時イベント
  resizeComplete() {
    return this.saveObj();
  },


  // CSSボタンコントロール初期化
  setupOptionMenu(callback = null) {
    return ConfigMenu.getDesignConfig(this, designConfigRoot => {
      // アイテム名の変更
      const name = $('.item-name', designConfigRoot);
      name.val(this.name);
      name.off('change').on('change', e => {
        this.name = $(e.target).val();
        return this.setItemPropToPageValue('name', this.name);
      });

      const _existFocusSetItem = function() {
        const objs = Common.itemInstancesInPage();
        let focusExist = false;
        for(let obj of Array.from(objs)) {
          if((obj.firstFocus !== null) && obj.firstFocus) {
            focusExist = true;
          }
        }
        return focusExist;
      };

      const focusEmt = $('.focus_at_launch', designConfigRoot);
      // アイテム初期フォーカス
      if(this.firstFocus) {
        focusEmt.prop('checked', true);
      } else {
        focusEmt.removeAttr('checked');
      }
      // ページ内に初期フォーカス設定されているアイテムが存在する場合はdisabled
      if(!this.firstFocus && _existFocusSetItem.call(this)) {
        focusEmt.removeAttr('checked');
        focusEmt.attr('disabled', true);
      } else {
        focusEmt.removeAttr('disabled');
      }
      focusEmt.off('change').on('change', e => {
        this.firstFocus = $(e.target).prop('checked');
        return this.saveObj();
      });

      const visibleEmt = $('.visible_at_launch', designConfigRoot);
      // アイテム初期表示
      if(this.visible) {
        visibleEmt.prop('checked', true);
      } else {
        visibleEmt.removeAttr('checked');
        focusEmt.removeAttr('checked');
        focusEmt.attr('disabled', true);
      }
      visibleEmt.off('change').on('change', e => {
        this.visible = $(e.target).prop('checked');
        if(this.visible && !_existFocusSetItem.call(this)) {
          focusEmt.removeAttr('disabled');
        } else {
          focusEmt.removeAttr('checked');
          focusEmt.attr('disabled', true);
        }
        focusEmt.trigger('change');
        return this.saveObj();
      });

      // アイテム位置の変更
      let p = Common.calcItemCenterPositionInWorktable(this.itemSize);
      $('.item_position_x:first', designConfigRoot).val(p.left);
      $('.item_position_y:first', designConfigRoot).val(p.top);
      $('.item_width:first', designConfigRoot).val(this.itemSize.w);
      $('.item_height:first', designConfigRoot).val(this.itemSize.h);
      $('.item_position_x:first, .item_position_y:first, .item_width:first, .item_height:first', designConfigRoot).off('change').on('change', () => {
        const centerPosition = {
          x: $('.item_position_x:first', designConfigRoot).val(),
          y: $('.item_position_y:first', designConfigRoot).val()
        };
        const w = parseInt($('.item_width:first', designConfigRoot).val());
        const h = parseInt($('.item_height:first', designConfigRoot).val());
        p = Common.calcItemScrollContentsPosition(centerPosition, w, h);
        const itemSize = {
          x: parseInt(p.left),
          y: parseInt(p.top),
          w,
          h
        };
        return this.updatePositionAndItemSize(itemSize, true, true);
      });

      // デザインコンフィグ
      if((this.constructor.actionProperties.designConfig !== null) && this.constructor.actionProperties.designConfig) {
        this.setupDesignToolOptionMenu();
      }

      // 変数編集コンフィグ
      this.settingModifiableChangeEvent();

      if(callback !== null) {
        return callback();
      }
    });
  },

  // デザインスライダーの作成
  // @param [Int] id メーターのElementID
  // @param [Int] min 最小値
  // @param [Int] max 最大値
  // @param [Int] stepValue 進捗数
  settingDesignSlider(className, min, max, stepValue) {
    if(stepValue === null) {
      stepValue = 1;
    }
    const designConfigRoot = $(`#${this.getDesignConfigId()}`);
    const meterElement = $(`.${className}`, designConfigRoot);
    const valueElement = meterElement.prev('input:first');
    const defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(this.id, `${className}_value`));
    valueElement.val(defaultValue);
    valueElement.html(defaultValue);
    try {
      meterElement.slider('destroy');
    } catch(error) {
    } //例外は握りつぶす
    return meterElement.slider({
      min,
      max,
      step: stepValue,
      value: defaultValue,
      slide: (event, ui) => {
        valueElement.val(ui.value);
        valueElement.html(ui.value);
        const classNames = $(event.target).attr('class').split(' ');
        const n = $.grep(classNames, s => s.indexOf('design_') >= 0)[0];
        this.designs.values[`${n}_value`] = ui.value;
        return this.applyDesignStyleChange(n, ui.value);
      }
    });
  },

  // HTML要素からグラデーションスライダーの作成
  // @param [Object] element HTML要素
  // @param [Array] values 値の配列
  settingGradientSliderByElement(element, values) {
    try {
      element.slider('destroy');
    } catch(error) {
    } //例外は握りつぶす
    element.slider({
      // 0%と100%は含まない
      min: 1,
      max: 99,
      values,
      slide: (event, ui) => {
        const index = $(ui.handle).index();
        const classNames = $(event.target).attr('class').split(' ');
        const n = $.grep(classNames, s => s.indexOf('design_') >= 0)[0];
        this.designs.values[`design_bg_color${index + 2}_position_value`] = (`0${ui.value}`).slice(-2);
        return this.applyGradientStyleChange(index, n, ui.value);
      }
    });

    const handleElement = element.children('.ui-slider-handle');
    if(values === null) {
      return handleElement.hide();
    } else {
      return handleElement.show();
    }
  },

  // グラデーションスライダーの作成
  // @param [Int] id HTML要素のID
  // @param [Array] values 値の配列
  settingGradientSlider(className, values) {
    const designConfigRoot = $(`#${this.getDesignConfigId()}`);
    const meterElement = $(`.${className}`, designConfigRoot);
    return this.settingGradientSliderByElement(meterElement, values);
  },

  // グラデーション方向スライダーの作成
  // @param [Int] id メーターのElementID
  // @param [Int] min 最小値
  // @param [Int] max 最大値
  settingGradientDegSlider(className, min, max, each45Degrees) {
    if(each45Degrees === null) {
      each45Degrees = true;
    }
    const designConfigRoot = $(`#${this.getDesignConfigId()}`);
    const meterElement = $(`.${className}`, designConfigRoot);
    const valueElement = $(`.${className}_value`, designConfigRoot);
    const defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(this.id, `${className}_value`));
    valueElement.val(defaultValue);
    valueElement.html(defaultValue);
    let step = 1;
    if(each45Degrees) {
      step = 45;
    }

    try {
      meterElement.slider('destroy');
    } catch(error) {
    } //例外は握りつぶす
    return meterElement.slider({
      min,
      max,
      step,
      value: defaultValue,
      slide: (event, ui) => {
        valueElement.val(ui.value);
        valueElement.html(ui.value);
        const classNames = $(event.target).attr('class').split(' ');
        const n = $.grep(classNames, s => s.indexOf('design_') >= 0)[0];
        this.designs.values[`${n}_value`] = ui.value;
        return this.applyGradientDegChange(n, ui.value);
      }
    });
  },

  // グラデーションの表示変更(スライダーのハンドル&カラーピッカー)
  // @param [Object] element HTML要素
  changeGradientShow(targetElement) {
    const designConfigRoot = $(`#${this.getDesignConfigId()}`);
    const value = parseInt(targetElement.value);
    if((value >= 2) && (value <= 5)) {
      const meterElement = $(targetElement).siblings('.ui-slider:first');
      let values = null;
      if(value === 3) {
        values = [50];
      } else if(value === 4) {
        values = [30, 70];
      } else if(value === 5) {
        values = [25, 50, 75];
      }

      this.settingGradientSliderByElement(meterElement, values);
      return this.switchGradientColorSelectorVisible(value, designConfigRoot);
    }
  },

  // グラデーションのカラーピッカー表示切り替え
  // @param [Int] gradientStepValue 現在のグラデーション数
  switchGradientColorSelectorVisible(gradientStepValue) {
    const designConfigRoot = $(`#${this.getDesignConfigId()}`);
    return (() => {
      const result = [];
      for(let i = 2; i <= 4; i++) {
        const element = $(`.design_bg_color${i}`, designConfigRoot);
        if(i > (gradientStepValue - 1)) {
          result.push(element.hide());
        } else {
          result.push(element.show());
        }
      }
      return result;
    })();
  },

  // デザイン更新処理
  saveDesign() {
    if(this.saveDesignReflectTimer !== null) {
      clearTimeout(this.saveDesignReflectTimer);
      this.saveDesignReflectTimer = null;
    }
    return this.saveDesignReflectTimer = setTimeout(() => {
        // 0.5秒後に反映
        // ページに状態を保存
        this.setItemAllPropToPageValue();
        // キャッシュに保存
        window.lStorage.saveAllPageValues();
        return this.saveDesignReflectTimer = setTimeout(() =>
            // 1秒後に操作履歴に保存
            OperationHistory.add()

          , 1000);
      }
      , 500);
  },

  // 変数編集イベント設定
  settingModifiableChangeEvent() {
    const designConfigRoot = $(`#${this.getDesignConfigId()}`);
    if(this.constructor.actionPropertiesModifiableVars() !== null) {
      return (() => {
        const result = [];
        const object = this.constructor.actionPropertiesModifiableVars();
        for(let varName in object) {
          const value = object[varName];
          if(value.type === constant.ItemDesignOptionType.NUMBER) {
            result.push(this.settingModifiableVarSlider(designConfigRoot, varName, value[this.constructor.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE], value.min, value.max, value.stepValue));
          } else if(value.type === constant.ItemDesignOptionType.STRING) {
            result.push(this.settingModifiableString(designConfigRoot, varName, value[this.constructor.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE]));
          } else if(value.type === constant.ItemDesignOptionType.BOOLEAN) {
            result.push(this.settingModifiableCheckbox(designConfigRoot, varName, value[this.constructor.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE]));
          } else if(value.type === constant.ItemDesignOptionType.COLOR) {
            result.push(this.settingModifiableColor(designConfigRoot, varName, value[this.constructor.ActionPropertiesKey.COLOR_TYPE], value[this.constructor.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE]));
          } else if(value.type === constant.ItemDesignOptionType.SELECT_FILE) {
            result.push(this.settingModifiableSelectFile(designConfigRoot, varName));
          } else if(value.type === constant.ItemDesignOptionType.SELECT_IMAGE_FILE) {
            result.push(this.settingModifiableSelectImageFile(designConfigRoot, varName));
          } else if(value.type === constant.ItemDesignOptionType.SELECT) {
            result.push(this.settingModifiableSelect(designConfigRoot, varName, value[this.constructor.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE], value['options[]']));
          } else {
            result.push(undefined);
          }
        }
        return result;
      })();
    }
  },

  // 変数編集スライダーの作成
  // @param [Object] configRoot コンフィグルート
  // @param [String] varName 変数名
  // @param [Int] min 最小値
  // @param [Int] max 最大値
  // @param [Int] stepValue 進捗数
  settingModifiableVarSlider(configRoot, varName, openChildrenValue, min, max, stepValue) {
    if(min === null) {
      min = 0;
    }
    if(max === null) {
      max = 100;
    }
    if(stepValue === null) {
      stepValue = 1;
    }
    const meterElement = $(`.${varName}_meter`, configRoot);
    const valueElement = meterElement.prev('input:first');
    const defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id))[varName];
    valueElement.val(defaultValue);
    valueElement.html(defaultValue);
    try {
      meterElement.slider('destroy');
    } catch(error) {
    } //例外は握りつぶす
    return meterElement.slider({
      min,
      max,
      step: stepValue,
      value: defaultValue,
      slide: (event, ui) => {
        const {value} = ui;
        valueElement.val(value);
        valueElement.html(value);
        this.changeInstanceVarByConfig(varName, value);
        this.constructor.switchChildrenConfig(event.target, varName, openChildrenValue, value);
        return this.applyDesignChange();
      }
    }).trigger('slide');
  },

  // 変数編集テキストボックスの作成
  // @param [Object] configRoot コンフィグルート
  // @param [String] varName 変数名
  settingModifiableString(configRoot, varName, openChildrenValue) {
    const defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id))[varName];
    $(`.${varName}_text`, configRoot).val(defaultValue);
    return $(`.${varName}_text`, configRoot).off('change').on('change', e => {
      const value = $(e.target).val();
      this.changeInstanceVarByConfig(varName, value);
      this.constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value);
      return this.applyDesignChange();
    }).trigger('change');
  },

  // 変数編集テキストボックスの作成
  // @param [Object] configRoot コンフィグルート
  // @param [String] varName 変数名
  settingModifiableCheckbox(configRoot, varName, openChildrenValue) {
    const defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id))[varName];
    if(defaultValue) {
      $(`.${varName}_checkbox`, configRoot).attr('checked', true);
    } else {
      $(`.${varName}_checkbox`, configRoot).removeAttr('checked');
    }

    return $(`.${varName}_checkbox`, configRoot).off('change').on('change', e => {
      const value = $(e.target).is(':checked');
      this.changeInstanceVarByConfig(varName, value);
      this.constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value);
      return this.applyDesignChange();
    }).trigger('change');
  },

  // 変数編集カラーピッカーの作成
  // @param [Object] configRoot コンフィグルート
  // @param [String] varName 変数名
  settingModifiableColor(configRoot, varName, colorType, openChildrenValue) {
    const emt = $(`.${varName}_color`, configRoot);
    const defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id))[varName];
    ColorPickerUtil.initColorPicker(
      $(emt),
      defaultValue,
      (a, b, d, e) => {
        let value = `#${b}`;
        if((colorType !== null) && (colorType === 'rgb')) {
          value = Common.colorFormatChangeHexToRgb(value);
        }
        this.changeInstanceVarByConfig(varName, value);
        this.constructor.switchChildrenConfig(emt, varName, openChildrenValue, value);
        return this.applyDesignChange();
      });
    return this.constructor.switchChildrenConfig(emt, varName, openChildrenValue, defaultValue);
  },

  // 変数編集ファイルアップロードの作成 FIXME
  // @param [Object] configRoot コンフィグルート
  // @param [String] varName 変数名
  settingModifiableSelectFile(configRoot, varName) {
    const form = $(`form.item_image_form_${varName}`, configRoot);
    this.initModifiableSelectFile(form);
    return form.off().on('ajax:complete', (e, data, status, error) => {
      const d = JSON.parse(data.responseText);
      this.changeInstanceVarByConfig(varName, d.image_url);
      this.saveObj();
      return this.applyDesignChange();
    });
  },

  // 変数編集画像ファイルアップロードの作成
  // @param [Object] configRoot コンフィグルート
  // @param [String] varName 変数名
  settingModifiableSelectImageFile(configRoot, varName) {
    const form = $(`form.item_image_form_${varName}`, configRoot);
    this.initModifiableSelectImageFile(form);
    return form.off().on('ajax:complete', (e, data, status, error) => {
      const d = JSON.parse(data.responseText);
      this.changeInstanceVarByConfig(varName, d.image_url);
      this.initModifiableSelectImageFile(e.target);
      $(e.target).find(`.${this.constructor.ImageKey.SELECT_FILE}:first`).trigger('change');
      $(e.target).find(`.${this.constructor.ImageKey.URL}:first`).trigger('change');
      this.saveObj();
      return this.applyDesignChange();
    });
  },

  // 変数編集選択メニューの作成
  settingModifiableSelect(configRoot, varName, openChildrenValue, selectOptions) {
    const _joinArray = function(value) {
      if($.isArray(value)) {
        return value.join(',');
      } else {
        return value;
      }
    };

    const _splitArray = function(value) {
      if($.isArray(value)) {
        return value.split(',');
      } else {
        return value;
      }
    };

    const selectEmt = $(`.${varName}_select`, configRoot);
    const defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id))[varName];
    if(defaultValue !== null) {
      selectEmt.val(_joinArray.call(this, defaultValue));
    }
    return selectEmt.off('change').on('change', e => {
      let value = _splitArray.call(this, $(e.target).val());
      if(value.match(/^-?[0-9]+\.[0-9]+$/)) {
        // 小数
        value = parseFloat(value);
      } else if(value.match(/^-?[0-9]+$/)) {
        // 整数
        value = parseInt(value);
      }
      this.changeInstanceVarByConfig(varName, value);
      this.constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value);
      return this.applyDesignChange();
    }).trigger('change');
  },

  // 変数編集ファイルアップロードのイベント初期化
  initModifiableSelectFile(emt) {
    $(emt).find(`.${this.constructor.ImageKey.PROJECT_ID}`).val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID));
    $(emt).find(`.${this.constructor.ImageKey.ITEM_OBJ_ID}`).val(this.id);
    return $(emt).find(`.${this.constructor.ImageKey.SELECT_FILE}:first`).off().on('change', e => {
      const {target} = e;
      if(target.value && (target.value.length > 0)) {
        // 選択時
        // Deleteボタン表示
        const del = $(emt).find(`.${this.constructor.ImageKey.SELECT_FILE_DELETE}:first`);
        del.off('click').on('click', function() {
          $(target).val('');
          return $(target).trigger('change');
        });
        return del.show();
      } else {
        // 未選択
        // Deleteボタン表示
        return $(emt).find(`.${this.constructor.ImageKey.SELECT_FILE_DELETE}:first`).hide();
      }
    });
  },

  // 変数編集画像ファイルアップロードのイベント初期化
  initModifiableSelectImageFile(emt) {
    let target;
    $(emt).find(`.${this.constructor.ImageKey.PROJECT_ID}`).val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID));
    $(emt).find(`.${this.constructor.ImageKey.ITEM_OBJ_ID}`).val(this.id);
    $(emt).find(`.${this.constructor.ImageKey.SELECT_FILE}:first`).off('change').on('change', e => {
      let el;
      ({target} = e);
      if(target.value && (target.value.length > 0)) {
        // 選択時
        // URL入力を無効 & Deleteボタン表示
        el = $(emt).find(`.${this.constructor.ImageKey.URL}:first`);
        el.attr('disabled', true);
        el.css('backgroundColor', 'gray');
        const del = $(emt).find(`.${this.constructor.ImageKey.SELECT_FILE_DELETE}:first`);
        del.off('click').on('click', function() {
          $(target).val('');
          return $(target).trigger('change');
        });
        return del.parent('div').show();
      } else {
        // 未選択
        // URL入力を有効 & Deleteボタン非表示
        el = $(emt).find(`.${this.constructor.ImageKey.URL}:first`);
        el.removeAttr('disabled');
        el.css('backgroundColor', 'white');
        return $(emt).find(`.${this.constructor.ImageKey.SELECT_FILE_DELETE}:first`).parent('div').hide();
      }
    });
    return $(emt).find(`.${this.constructor.ImageKey.URL}:first`).off('change').on('change', e => {
      ({target} = e);
      if($(target).val().length > 0) {
        // 入力時
        // ファイル選択を無効
        return $(emt).find(`.${this.constructor.ImageKey.SELECT_FILE}:first`).attr('disabled', true);
      } else {
        // 未入力時
        // ファイル選択を有効
        return $(emt).find(`.${this.constructor.ImageKey.SELECT_FILE}:first`).removeAttr('disabled');
      }
    });
  }
};