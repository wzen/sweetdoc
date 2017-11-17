import PageValue from '../../base/page_value';
import ConfigMenu from '../../base/config_menu';
import EventPageValueBase from '../event_page_value/base/base';
import WorktableCommon from '../worktable/common/worktable_common';

let constant = undefined;
let _setItemCommonEvent = undefined;
let _setMethodActionEvent = undefined;
let _setCommonStateEvent = undefined;
let _setHandlerRadioEvent = undefined;
let _setScrollDirectionEvent = undefined;
let _setForkSelect = undefined;
let _setApplyClickEvent = undefined;
let _setupFromPageValues = undefined;
let _clearInput = undefined;
export default class EventConfig {
  static initClass() {
    // 定数
    constant = gon.const;
    // @property [String] TE_ITEM_ROOT_ID イベントRoot
    this.ITEM_ROOT_ID = 'event_@distId';
    // @property [String] EVENT_ITEM_SEPERATOR イベント(アイテム)値のセパレータ
    this.EVENT_ITEM_SEPERATOR = "&";
    // @property [String] ITEM_ACTION_CLASS イベントアイテムアクションクラス名
    this.ITEM_ACTION_CLASS = constant.EventConfig.ITEM_ACTION_CLASS;
    // @property [String] ITEM_VALUES_CLASS アイテムイベントクラス名
    this.ITEM_VALUES_CLASS = constant.EventConfig.ITEM_VALUES_CLASS;
    // @property [String] EVENT_COMMON_PREFIX 共通イベントプレフィックス
    this.EVENT_COMMON_PREFIX = constant.EventConfig.EVENT_COMMON_PREFIX;

    this.METHOD_VALUE_MODIFY_ROOT = 'modify';
    this.METHOD_VALUE_SPECIFIC_ROOT = 'specific';

    _setItemCommonEvent = function() {
      $('.show_will_chapter', this.emt).off('change').on('change', function(e) {
        return $('.show_will_chapter_duration', this.emt).parent('div').css('display', $(this).is(':checked') ? 'block' : 'none');
      }).trigger('change');
      return $('.hide_did_chapter', this.emt).off('change').on('change', function(e) {
        return $('.hide_did_chapter_duration', this.emt).parent('div').css('display', $(this).is(':checked') ? 'block' : 'none');
      }).trigger('change');
    };

    _setMethodActionEvent = function() {
      const actionClassName = this.actionClassName();
      const em = $(`.action_forms .${actionClassName} input[type=radio]`, this.emt);
      em.off('click').on('click', e => {
        this.clearError();
        const parent = $(e.target).closest('.radio');
        this[EventPageValueBase.PageValueKey.METHODNAME] = parent.find('input.method_name:first').val();
        this.clickMethod(e.target);
        if(this[EventPageValueBase.PageValueKey.ACTIONTYPE] !== null) {
          // Buttonフォーム表示
          return $('.button_div', this.emt).show();
        }
      });
      return $(`.action_forms .${actionClassName} input[type=radio]:checked`, this.emt).trigger('click');
    };

    _setCommonStateEvent = function() {
      return $('.finish_page', this.emt).off('change').on('change', e => {
        if($(e.target).is(':checked')) {
          // Selectメニュー更新
          const select = $('.finish_page_select', this.emt);
          select.empty();
          let options = `<option value=${EventPageValueBase.NO_JUMPPAGE}>${I18n.t('config.state.page_select_option_none')}</option>`;
          const pageCount = PageValue.getPageCount();
          for(let i = 1, end = pageCount, asc = 1 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
            if(i !== PageValue.getPageNum(9)) {
              options += `<option value=${i}>${I18n.t('config.state.page_select_option') + ' ' + i}</option>`;
            }
          }
          select.append(options);
          return $('.finish_page_wrappper', this.emt).show();
        } else {
          // 選択なし
          $('.finish_page_select', this.emt).val(EventPageValueBase.NO_JUMPPAGE);
          return $('.finish_page_wrappper', this.emt).hide();
        }
      }).trigger('change');
    };

    _setHandlerRadioEvent = function() {
      $('.handler_div input[type=radio]', this.emt).off('click').on('click', e => {
        if($(`.action_forms .${this.actionClassName()} input[type=radio]:checked`, this.emt).length > 0) {
          // Buttonフォーム表示
          $('.button_div', this.emt).show();
        }

        $('.handler_form', this.emt).hide();
        if($(e.target).val() === 'scroll') {
          this[EventPageValueBase.PageValueKey.ACTIONTYPE] = constant.ActionType.SCROLL;
          $('.scroll_form', this.emt).show();
        } else if($(e.target).val() === 'click') {
          this[EventPageValueBase.PageValueKey.ACTIONTYPE] = constant.ActionType.CLICK;
          $('.click_form', this.emt).show();
        }

        if(this.teNum > 1) {
          const beforeActionType = PageValue.getEventPageValue(PageValue.Key.eventNumber(this.teNum - 1))[EventPageValueBase.PageValueKey.ACTIONTYPE];
          if(this[EventPageValueBase.PageValueKey.ACTIONTYPE] === beforeActionType) {
            // 前のイベントと同じアクションタイプの場合は同時実行を表示
            return $(".config.parallel_div", this.emt).show();
          } else {
            return $(".config.parallel_div", this.emt).hide();
          }
        }
      });
      return $('.handler_div input[type=radio]:checked', this.emt).trigger('click');
    };

    _setScrollDirectionEvent = function() {
      const handler = $('.handler_div', this.emt);
      return $('.scroll_enabled', handler).off('click').on('click', function(e) {
        if($(this).is(':checked')) {
          return $(this).closest('.scroll_enabled_wrapper').find('.scroll_forward:first').parent('label').show();
        } else {
          const emt = $(this).closest('.scroll_enabled_wrapper').find('.scroll_forward:first');
          emt.parent('label').hide();
          return emt.prop('checked', false);
        }
      });
    };

    _setForkSelect = function() {
      const handler = $('.handler_div', this.emt);
      $('.enable_fork', handler).off('click').on('click', function(e) {
        return $('.fork_select', handler).parent('div').css('display', $(this).is(':checked') ? 'block' : 'none');
      });

      // Forkコンフィグ作成
      const forkCount = PageValue.getForkCount();
      if(forkCount > 0) {
        const forkNum = PageValue.getForkNum();
        // Fork選択作成
        let selectOptions = '';
        for(let i = 1, end = forkCount, asc = 1 <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
          if(i !== forkNum) { // 現在のフォークは選択肢に含めない
            const name = `${I18n.t('header_menu.page.fork')} ${i}`;
            const value = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', i);
            selectOptions += `<option value='${value}'>${name}</option>`;
          }
        }

        if(selectOptions.length > 0) {
          const select = $('.fork_select', handler);
          select.children().remove();
          select.append($(selectOptions));
          const enabled = (this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] !== null) && (this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] > 0);
          const fn = enabled ? this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] : 1;
          select.val(Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', fn));
          select.parent('div').css('display', enabled ? 'block' : 'none');
          // Fork表示
          return $('.fork_handler_wrapper', handler).show();
        } else {
          // 選択肢が無い場合、Fork非表示
          return $('.fork_handler_wrapper', handler).hide();
        }
      } else {
        // Fork非表示
        return $('.fork_handler_wrapper', handler).hide();
      }
    };

    _setApplyClickEvent = function() {
      if(WorktableCommon.isConnectedEventProgressRoute(this.teNum)) {
        $('.push.button.preview', this.emt).removeAttr('disabled');
        $('.push.button.preview', this.emt).off('click').on('click', e => {
          this.clearError();
          return this.preview(e);
        });
      } else {
        // イベントの設定が接続されていない場合はdisabled
        $('.push.button.preview', this.emt).attr('disabled', true);
      }
      $('.push.button.apply', this.emt).off('click').on('click', e => {
        this.clearError();
        return this.applyAction();
      });
      return $('.push.button.preview_stop', this.emt).off('click').on('click', e => {
        this.clearError();
        return this.stopPreview(e);
      });
    };

    _setupFromPageValues = function() {
      if(EventPageValueBase.readFromPageValue(this)) {
        return this.selectItem();
      } else {
        // 表示初期化
        return _clearInput.call(this);
      }
    };

    _clearInput = function() {
      $('.update_event_after', this.emt).prop('checked', false);
      const itemSelect = $('.te_item_select', this.emt);
      itemSelect.prev('.btn').text(I18n.t('config.event.target_select.default'));
      itemSelect.next('input[type=hidden]').val('');
      return $(".config.te_div", this.emt).hide();
    };
  }

  // コンストラクタ
  // @param [Object] @emt コンフィグRoot
  // @param [Integer] @teNum イベント番号
  constructor(emt, teNum, distId) {
    this.emt = emt;
    this.teNum = teNum;
    this.distId = distId;
    _setupFromPageValues.call(this);
  }

  // イベントコンフィグ表示前初期化
  static initEventConfig(distId, teNum) {
    // 選択枠削除
    if(teNum === null) {
      teNum = 1;
    }
    WorktableCommon.clearTimelineSelectedBorderInMainWrapper();
    // イベントポインタ削除
    WorktableCommon.clearEventPointer();
    // アイテム選択メニュー更新
    this.updateSelectItemMenu();
    // イベントハンドラの設定
    return this.setupTimelineEventHandler(distId, teNum);
  }

  // イベントタイプ選択
  // @param [Object] e 選択オブジェクト
  selectItem(e = null) {
    if(e !== null) {
      const value = $(e).children('input:first').val();
      // デフォルト選択時
      if(value === "") {
        // 非表示にする
        $(".config.te_div", this.emt).hide();
        return;
      }
      const dropdown = $(e).closest('.dropdown');
      // マウスオーバーイベントを無効にする
      dropdown.find('li').off('mouseleave.dropdown');
      EventConfig.setSelectItemValue(dropdown, value);
      const splitValues = value.split(EventConfig.EVENT_ITEM_SEPERATOR);
      const objId = splitValues[0];
      this[EventPageValueBase.PageValueKey.ID] = objId;
      this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN] = splitValues[1];
      this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] = window.instanceMap[objId] instanceof CommonEventBase;
      // コンフィグ作成
      this.constructor.addEventConfigContents(this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]);
    }

    if(window.isWorkTable) {
      // 選択枠消去
      WorktableCommon.clearTimelineSelectedBorderInMainWrapper();
    }

    if(!this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      const vEmt = $(`#${this[EventPageValueBase.PageValueKey.ID]}`);
      if(window.isWorkTable) {
        // 選択枠設定
        WorktableCommon.setSelectedBorder(vEmt, 'timeline');
      }
    }
    // フォーカス
    //Common.focusToTarget(vEmt, null, true)

    // 一度全て非表示にする
    $(".config.te_div", this.emt).hide();

    // 共通情報表示
    $('.common_state_div', this.emt).show();
    if(!this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      // アイテム共通情報表示
      $('.item_common_div, .item_state_div', this.emt).show();
    }

    // Handler表示
    $(".config.handler_div", this.emt).show();
    // Action表示
    $('.action_div .action_forms > div').hide();
    $(".action_div", this.emt).show();
    const actionClassName = this.actionClassName();
    $(`.action_div .${actionClassName}`, this.emt).show();

    // イベント設定
    _setCommonStateEvent.call(this);
    _setItemCommonEvent.call(this);
    _setHandlerRadioEvent.call(this);
    _setScrollDirectionEvent.call(this);
    _setForkSelect.call(this);
    return _setMethodActionEvent.call(this);
  }

  // メソッド選択
  // @param [Object] e 選択オブジェクト
  clickMethod(e = null) {
    const _callback = function() {
      $(".value_forms", this.emt).children("div").hide();
      if(this[EventPageValueBase.PageValueKey.METHODNAME] !== null) {
        // 変更値表示
        const valueClassName = this.methodClassName();
        $(`.value_forms .${valueClassName}`, this.emt).show();
        $(".config.values_div", this.emt).show();
      }

      return _setApplyClickEvent.call(this);
    };

    if(!this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      // アイテム選択時
      const item = window.instanceMap[this[EventPageValueBase.PageValueKey.ID]];
      if((item !== null) && (this[EventPageValueBase.PageValueKey.METHODNAME] !== null)) {
        // 変数変更コンフィグ読み込み
        return ConfigMenu.loadEventMethodValueConfig(this, item.constructor, () => {
          return _callback.call(this);
        });
      } else {
        return _callback.call(this);
      }
    } else {
      // 共通イベント選択時
      const objClass = Common.getContentClass(this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]);
      if(objClass) {
        return ConfigMenu.loadEventMethodValueConfig(this, objClass, () => {
          return _callback.call(this);
        });
      } else {
        return _callback.call(this);
      }
    }
  }

  // 入力値を適用する
  writeToEventPageValue() {
    if((this[EventPageValueBase.PageValueKey.ACTIONTYPE] === null)) {
      if(window.debug) {
        console.log('validation error');
      }
      return false;
    }

    // 入力値を保存
    if((this[EventPageValueBase.PageValueKey.DIST_ID] === null)) {
      this[EventPageValueBase.PageValueKey.DIST_ID] = Common.generateId();
    }

    this[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF] = {
      x: parseInt($('.item_position_diff_x:first', this.emt).val()),
      y: parseInt($('.item_position_diff_y:first', this.emt).val()),
      w: parseInt($('.item_diff_width:first', this.emt).val()),
      h: parseInt($('.item_diff_height:first', this.emt).val())
    };

    let checked = $('.show_will_chapter:first', this.emt).is(':checked');
    this[EventPageValueBase.PageValueKey.SHOW_WILL_CHAPTER] = (checked !== null) && checked;
    this[EventPageValueBase.PageValueKey.SHOW_WILL_CHAPTER_DURATION] = $('.show_will_chapter_duration:first', this.emt).val();
    checked = $('.hide_did_chapter:first', this.emt).is(':checked');
    this[EventPageValueBase.PageValueKey.HIDE_DID_CHAPTER] = (checked !== null) && checked;
    this[EventPageValueBase.PageValueKey.HIDE_DID_CHAPTER_DURATION] = $('.hide_did_chapter_duration:first', this.emt).val();

    this[EventPageValueBase.PageValueKey.FINISH_PAGE] = $('.finish_page', this.emt).is(":checked");
    this[EventPageValueBase.PageValueKey.JUMPPAGE_NUM] = $('.finish_page_select', this.emt).val();
    this[EventPageValueBase.PageValueKey.DO_FOCUS] = $('.do_focus', this.emt).prop('checked');
    this[EventPageValueBase.PageValueKey.IS_SYNC] = false;
    const parallel = $(".parallel_div .parallel", this.emt);
    if(parallel !== null) {
      this[EventPageValueBase.PageValueKey.IS_SYNC] = parallel.is(":checked");
    }

    const handlerDiv = $(".handler_div", this.emt);
    if(this[EventPageValueBase.PageValueKey.ACTIONTYPE] === constant.ActionType.SCROLL) {
      this[EventPageValueBase.PageValueKey.SCROLL_POINT_START] = '';
      this[EventPageValueBase.PageValueKey.SCROLL_POINT_END] = "";
      this[EventPageValueBase.PageValueKey.SCROLL_POINT_START] = handlerDiv.find('.scroll_point_start:first').val();
      this[EventPageValueBase.PageValueKey.SCROLL_POINT_END] = handlerDiv.find('.scroll_point_end:first').val();

      const topEmt = handlerDiv.find('.scroll_enabled_top:first');
      const bottomEmt = handlerDiv.find('.scroll_enabled_bottom:first');
      const leftEmt = handlerDiv.find('.scroll_enabled_left:first');
      const rightEmt = handlerDiv.find('.scroll_enabled_right:first');
      this[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS] = {
        top: topEmt.find('.scroll_enabled:first').is(":checked"),
        bottom: bottomEmt.find('.scroll_enabled:first').is(":checked"),
        left: leftEmt.find('.scroll_enabled:first').is(":checked"),
        right: rightEmt.find('.scroll_enabled:first').is(":checked")
      };
      this[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS] = {
        top: topEmt.find('.scroll_forward:first').is(":checked"),
        bottom: bottomEmt.find('.scroll_forward:first').is(":checked"),
        left: leftEmt.find('.scroll_forward:first').is(":checked"),
        right: rightEmt.find('.scroll_forward:first').is(":checked")
      };

    } else if(this[EventPageValueBase.PageValueKey.ACTIONTYPE] === constant.ActionType.CLICK) {
      this[EventPageValueBase.PageValueKey.EVENT_DURATION] = handlerDiv.find('.click_duration:first').val();
      this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = 0;
      checked = handlerDiv.find('.enable_fork:first').is(':checked');
      if((checked !== null) && checked) {
        const prefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '');
        this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = parseInt(handlerDiv.find('.fork_select:first').val().replace(prefix, ''));
      }
    }

    const specificValues = {};
    const specificRoot = this.emt.find(`.${this.methodClassName()} .${EventConfig.METHOD_VALUE_SPECIFIC_ROOT}`);
    specificRoot.find('input').each(function() {
      if(!$(this).hasClass('fixed_value')) {
        const classNames = $(this).get(0).className.split(' ');
        const className = $.grep(classNames, n => n !== 'fixed_value')[0];
        return specificValues[className] = $(this).val();
      }
    });
    this[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES] = specificValues;

    const errorMes = EventPageValueBase.writeToPageValue(this);
    if((errorMes !== null) && (errorMes.length > 0)) {
      // エラー発生時
      this.showError(errorMes);
      return false;
    }

    return true;
  }

  applyAction() {
    // ※プレビューは停止している状態
    Common.showModalFlashMessage('Please Wait');
    // 入力値書き込み
    if(this.writeToEventPageValue()) {
      // イベントの色を変更
      //Timeline.changeTimelineColor(@teNum, @[EventPageValueBase.PageValueKey.ACTIONTYPE])
      // キャッシュに保存
      window.lStorage.saveAllPageValues();
      // 通知
      FloatView.show('Applied', FloatView.Type.APPLY, 3.0);
      // イベントを更新
      Timeline.updateEvent(this.teNum);
      // タイムライン幅更新
      Timeline.addTimelineContainerWidth();
      return Common.hideModalView(true);
    }
  }

  // プレビュー開始
  preview(e) {
    const keepDispMag = $(e.target).closest('div').find('.keep_disp_mag').is(':checked');
    if(WorktableCommon.isConnectedEventProgressRoute(this.teNum)) {
      // 対象のEventPageValueを一時的に退避
      return WorktableCommon.stashEventPageValueForPreview(this.teNum, () => {
        // 入力値を書き込み
        this.writeToEventPageValue();
        return WorktableCommon.runPreview(this.teNum, keepDispMag);
      });
    }
  }

  // プレビュー停止
  stopPreview(e, callback = null) {
    const keepDispMag = $(e.target).closest('div').find('.keep_disp_mag').is(':checked');
    return WorktableCommon.stopAllEventPreview(() =>
      WorktableCommon.stopPreview(keepDispMag, function() {
        if(callback !== null) {
          return callback();
        }
      })
    );
  }

  // アクションメソッドクラス名を取得
  actionClassName() {
    return this.constructor.ITEM_ACTION_CLASS.replace('@classdisttoken', this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]);
  }

  // アクションメソッド & メソッド毎の値のクラス名を取得
  methodClassName() {
    return this.constructor.ITEM_VALUES_CLASS.replace('@classdisttoken', this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]).replace('@methodname', this[EventPageValueBase.PageValueKey.METHODNAME]);
  }

  // エラー表示
  // @param [String] message メッセージ内容
  showError(message) {
    const eventConfigError = $('.event_config_error', this.emt);
    eventConfigError.find('p').html(message);
    return eventConfigError.show();
  }

  // エラー非表示
  clearError() {
    const eventConfigError = $('.event_config_error', this.emt);
    eventConfigError.find('p').html('');
    return eventConfigError.hide();
  }

  // 「Preview」ボタンの切り替え
  static switchPreviewButton(enabled) {
    if(enabled) {
      $("#event-config").find('.event .button_div .button_preview_wrapper').show();
      $("#event-config").find('.event .button_div .apply_wrapper').show();
      return $("#event-config").find('.event .button_div .button_stop_preview_wrapper').hide();
    } else {
      $("#event-config").find('.event .button_div .button_preview_wrapper').hide();
      $("#event-config").find('.event .button_div .apply_wrapper').hide();
      return $("#event-config").find('.event .button_div .button_stop_preview_wrapper').show();
    }
  }

  // 追加されたコンフィグを全て消去
  static removeAllConfig() {
    return $('#event-config').children('.event').remove();
  }

  // アクションイベント情報をコンフィグに追加
  // @param [Integer] distToken アイテム識別ID
  static addEventConfigContents(distToken) {
    const itemClass = Common.getContentClass(distToken);
    if((itemClass !== null) && (itemClass.actionProperties !== null)) {
      const className = EventConfig.ITEM_ACTION_CLASS.replace('@classdisttoken', distToken);
      const action_forms = $('#event-config .action_forms');
      if(action_forms.find(`.${className}`).length === 0) {
        let methodClone;
        const actionParent = $(`<div class='${className}' style='display:none'></div>`);
        const props = itemClass.actionProperties;
        if((props === null)) {
          if(window.debug) {
            console.log('Not declaration actionProperties');
          }
          return;
        }

        // アクションメソッドConfig追加
        if(itemClass.prototype instanceof ItemBase) {
          // 'none'が選択できるのはアイテムのみ
          methodClone = $('#event-config .method_none_temp').children(':first').clone(true);
          methodClone.find('input[type=radio]').attr('name', className);
          actionParent.append(methodClone);
        }
        const methods = props[EventBase.ActionPropertiesKey.METHODS];
        if(methods !== null) {
          for(let methodName in methods) {
            const prop = methods[methodName];
            methodClone = $('#event-config .method_temp').children(':first').clone(true);
            const span = methodClone.find('label:first').children('span:first');
            span.html(prop[EventBase.ActionPropertiesKey.OPTIONS]['name']);
            methodClone.find('input.method_name:first').val(methodName);
            const valueClassName = EventConfig.ITEM_VALUES_CLASS.replace('@classdisttoken', distToken).replace('@methodname', methodName);
            methodClone.find('input[type=radio]').attr('name', className);
            methodClone.find('input.value_class_name:first').val(valueClassName);
            actionParent.append(methodClone);
          }
        }

        return actionParent.appendTo(action_forms);
      }
    }
  }

  // 変数編集コンフィグの初期化
  initEventVarModifyConfig(objClass) {
    if((objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]] === null) ||
      (objClass.actionPropertiesModifiableVars(this[EventPageValueBase.PageValueKey.METHODNAME]) === null)) {
      // メソッド or 変数編集無し
      return;
    }

    const mod = objClass.actionPropertiesModifiableVars(this[EventPageValueBase.PageValueKey.METHODNAME]);
    if(mod !== null) {
      return (() => {
        const result = [];
        for(let varName in mod) {
          const v = mod[varName];
          let defaultValue = null;
          if(this.hasModifiableVar(varName)) {
            defaultValue = this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
          } else {
            objClass = null;
            if(this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN] !== null) {
              objClass = Common.getContentClass(this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]);
            }
            if(objClass.actionPropertiesModifiableVars()[varName] !== null) {
              defaultValue = objClass.actionPropertiesModifiableVars()[varName].default;
            }
          }

          if(v[objClass.ActionPropertiesKey.TYPE] === constant.ItemDesignOptionType.NUMBER) {
            result.push(this.settingModifiableVarSlider(varName, defaultValue, v[objClass.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE], v.min, v.max, v.stepValue));
          } else if(v[objClass.ActionPropertiesKey.TYPE] === constant.ItemDesignOptionType.STRING) {
            result.push(this.settingModifiableString(varName, defaultValue, v[objClass.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE]));
          } else if(v[objClass.ActionPropertiesKey.TYPE] === constant.ItemDesignOptionType.BOOLEAN) {
            result.push(this.settingModifiableCheckbox(varName, defaultValue, v[objClass.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE]));
          } else if(v[objClass.ActionPropertiesKey.TYPE] === constant.ItemDesignOptionType.COLOR) {
            result.push(this.settingModifiableColor(varName, defaultValue, v[objClass.ActionPropertiesKey.COLOR_TYPE], v[objClass.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE]));
          } else if(v[objClass.ActionPropertiesKey.TYPE] === constant.ItemDesignOptionType.SELECT) {
            result.push(this.settingModifiableSelect(varName, defaultValue, v[objClass.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE], v['options[]']));
          } else {
            result.push(undefined);
          }
        }
        return result;
      })();
    }
  }

  // 独自変数コンフィグの初期化
  initEventSpecificConfig(objClass) {
    let v;
    if((objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]] === null) ||
      (objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]][objClass.ActionPropertiesKey.SPECIFIC_METHOD_VALUES] === null)) {
      // メソッド or 独自コンフィグ無し
      return;
    }

    const sp = objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]][objClass.ActionPropertiesKey.SPECIFIC_METHOD_VALUES];
    // 変数と同じクラス名のInputに設定(現状textのみ)
    // 'fixed_value'は除外
    for(let varName in sp) {
      v = sp[varName];
      const e = this.emt.find(`.${this.methodClassName()} .${EventConfig.METHOD_VALUE_SPECIFIC_ROOT} .${varName}:not('.fixed_value')`);
      if(e.length > 0) {
        if(this.hasSpecificVar(varName)) {
          e.val(this[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES][varName]);
        } else {
          e.val(v);
        }
      }
    }

    // イベント初期化呼び出し
    const initSpecificConfigParam = {};
    for(let methodName in objClass.actionProperties.methods) {
      v = objClass.actionProperties.methods[methodName];
      const methodClassName = this.constructor.ITEM_VALUES_CLASS.replace('@classdisttoken', this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]).replace('@methodname', methodName);
      initSpecificConfigParam[methodName] = this.emt.find(`.${methodClassName} .${EventConfig.METHOD_VALUE_SPECIFIC_ROOT}:first`);
    }
    return objClass.initSpecificConfig(initSpecificConfigParam);
  }

  // 変数変更値が存在するか
  hasModifiableVar(varName = null) {
    const ret = (this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] !== null) && ((this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] !== null) !== 'undefined');
    if(varName !== null) {
      return ret && (this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] !== null);
    } else {
      return ret;
    }
  }

  // 変数変更値が存在するか
  hasSpecificVar(varName = null) {
    const ret = (this[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES] !== null) && ((this[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES] !== null) !== 'undefined');
    if(varName !== null) {
      return ret && (this[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES][varName] !== null);
    } else {
      return ret;
    }
  }

  // 変数編集スライダーの作成
  // @param [Int] varName 変数名
  // @param [Int] min 最小値
  // @param [Int] max 最大値
  // @param [Int] stepValue 進捗数
  settingModifiableVarSlider(varName, defaultValue, openChildrenValue, min, max, stepValue) {
    if(min === null) {
      min = 0;
    }
    if(max === null) {
      max = 100;
    }
    if(stepValue === null) {
      stepValue = 1;
    }
    const meterClassName = `${varName}_meter`;
    const meterElement = $(`.${this.methodClassName()} .${EventConfig.METHOD_VALUE_MODIFY_ROOT} .${meterClassName}`, this.emt);
    const valueElement = meterElement.prev('input:first');
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
        if(!this.hasModifiableVar()) {
          this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
        }
        const {value} = ui;
        this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = value;
        return this.constructor.switchChildrenConfig(event.target, varName, openChildrenValue, value);
      }
    }).trigger('slide');
  }

  // 変数編集テキストボックスの作成
  // @param [String] varName 変数名
  settingModifiableString(varName, defaultValue, openChildrenValue) {
    $(`.${this.methodClassName()} .${EventConfig.METHOD_VALUE_MODIFY_ROOT} .${varName}_text`, this.emt).val(defaultValue);
    return $(`.${this.methodClassName()} .${EventConfig.METHOD_VALUE_MODIFY_ROOT} .${varName}_text`, this.emt).off('change').on('change', e => {
      if(!this.hasModifiableVar()) {
        this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
      }
      const value = $(e.target).val();
      this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = value;
      return this.constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value);
    }).trigger('change');
  }

  // 変数編集チェックボックスの作成
  // @param [String] varName 変数名
  settingModifiableCheckbox(varName, defaultValue, openChildrenValue) {
    if(defaultValue) {
      $(`.${this.methodClassName()} .${EventConfig.METHOD_VALUE_MODIFY_ROOT} .${varName}_checkbox`, this.emt).attr('checked', true);
    } else {
      $(`.${this.methodClassName()} .${EventConfig.METHOD_VALUE_MODIFY_ROOT} .${varName}_checkbox`, this.emt).removeAttr('checked');
    }
    return $(`.${this.methodClassName()} .${EventConfig.METHOD_VALUE_MODIFY_ROOT} .${varName}_checkbox`, this.emt).off('change').on('change', e => {
      if(!this.hasModifiableVar()) {
        this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
      }
      const value = $(e.target).is(':checked');
      this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = value;
      return this.constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value);
    }).trigger('change');
  }

  // 変数編集カラーピッカーの作成
  // @param [Object] configRoot コンフィグルート
  // @param [String] varName 変数名
  settingModifiableColor(varName, defaultValue, colorType, openChildrenValue) {
    const emt = $(`.${this.methodClassName()} .${EventConfig.METHOD_VALUE_MODIFY_ROOT} .${varName}_color`, this.emt);
    ColorPickerUtil.initColorPicker(
      $(emt),
      defaultValue,
      (a, b, d, e) => {
        if(!this.hasModifiableVar()) {
          this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
        }
        let value = `#${b}`;
        if((colorType !== null) && (colorType === 'rgb')) {
          value = Common.colorFormatChangeHexToRgb(value);
        }
        this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = value;
        return this.constructor.switchChildrenConfig(emt, varName, openChildrenValue, value);
      });
    return this.constructor.switchChildrenConfig(emt, varName, openChildrenValue, defaultValue);
  }

  // 変数編集選択メニューの作成
  settingModifiableSelect(varName, defaultValue, openChildrenValue, selectOptions) {
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

    const selectEmt = $(`.${this.methodClassName()} .${EventConfig.METHOD_VALUE_MODIFY_ROOT} .${varName}_select`, this.emt);
    selectEmt.val(_joinArray.call(this, defaultValue));
    return selectEmt.off('change').on('change', e => {
      if(!this.hasModifiableVar()) {
        this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
      }
      let value = _splitArray.call(this, $(e.target).val());
      if(value.match(/^-?[0-9]+\.[0-9]+$/)) {
        // 小数
        value = parseFloat(value);
      } else if(value.match(/^-?[0-9]+$/)) {
        // 整数
        value = parseInt(value);
      }
      this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = value;
      return this.constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value);
    }).trigger('change');
  }

  // アイテム選択メニューを更新
  static updateSelectItemMenu() {
    // 作成されたアイテムの一覧を取得
    let id;
    let itemSelectOptions = '';
    let commonSelectOptions = '';
    const items = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix());
    for(let k in items) {
      var option;
      const item = items[k];
      ({id} = item.value);
      const {name} = item.value;
      const {classDistToken} = item.value;
      if(window.instanceMap[id] instanceof ItemBase) {
        // アイテム
        option = `\
<li class='item'><a href='#'>${name}</a><input type='hidden' value='${id}${EventConfig.EVENT_ITEM_SEPERATOR}${classDistToken}' /></li>\
`;
        itemSelectOptions += option;
      } else {
        // 共通イベント
        option = `\
<li><a href='#'>${name}</a><input type='hidden' value='${id}${EventConfig.EVENT_ITEM_SEPERATOR}${classDistToken}' /></li>\
`;
        commonSelectOptions += option;
      }
    }

    if(commonSelectOptions.length > 0) {
      commonSelectOptions = `<li class='dropdown-header'>${I18n.t("config.select_opt_group.common")}</li>` + commonSelectOptions;
    }
    if(itemSelectOptions.length > 0) {
      itemSelectOptions = `<li class='dropdown-header'>${I18n.t("config.select_opt_group.item")}</li>` + itemSelectOptions;
    }
    // メニューを入れ替え
    const teItemSelects = $('#event-config .te_item_select');
    teItemSelects.each(function() {
      $(this).empty();
      $(this).append($(commonSelectOptions));
      return $(this).append($(itemSelectOptions));
    });
    // リスト表示時イベント
    teItemSelects.closest('.dropdown').off('show.bs.dropdown.my').on('show.bs.dropdown.my', function(e) {
      // アイテムリスト マウスオーバー
      return $(this).find('li').off('mouseenter.dropdown').on('mouseenter.dropdown', function(e) {
        WorktableCommon.clearTimelineSelectedBorderInMainWrapper();
        if($(this).hasClass('item')) {
          id = $(this).children('input:first').val().split(EventConfig.EVENT_ITEM_SEPERATOR)[0];
          return WorktableCommon.setSelectedBorder($(`#${id}`), 'timeline');
        }
      }).off('mouseleave.dropdown').on('mouseleave.dropdown', function(e) {
        e.preventDefault();
        return WorktableCommon.clearTimelineSelectedBorderInMainWrapper();
      });
    });
    // リスト非表示時イベント
    teItemSelects.closest('.dropdown').off('hide.bs.dropdown.my').on('hide.bs.dropdown.my', function() {
      return EventConfig.setSelectedItemBorder($(this));
    });
    return teItemSelects.find('.te_item_select:first').height($('#event-config').height());
  }

  // イベントハンドラー設定
  // @param [Integer] distId イベント番号
  static setupTimelineEventHandler(distId, teNum) {
    const eId = EventConfig.ITEM_ROOT_ID.replace('@distId', distId);
    const emt = $(`#${eId}`);
    // Configクラス作成 & イベントハンドラの設定
    const config = new (this)(emt, teNum, distId);
    // コンフィグ表示初期化
    $('.update_event_after', emt).removeAttr('checked');
    $('.button_preview_wrapper', emt).show();
    $('.apply_wrapper', emt).show();
    $('.button_stop_preview_wrapper', emt).hide();
    if(WorktableCommon.isConnectedEventProgressRoute(teNum)) {
      $('.update_event_after', emt).removeAttr('disabled');
      $('.update_event_after', emt).off('change').on('change', e => {
        if($(e.target).is(':checked')) {
          // イベント後に変更 ※表示倍率はキープする
          $(e.target).attr('disabled', true);
          // Blankのコンフィグか判定
          const blankDistId = $('#timeline_events > .timeline_event.blank:first').find('.dist_id:first').val();
          const configDistId = $(e.target).closest('.event').attr('id').replace(EventConfig.ITEM_ROOT_ID.replace('@distId', ''), '');
          const fromBlankEventConfig = blankDistId === configDistId;
          return WorktableCommon.updatePrevEventsToAfter(teNum, true, fromBlankEventConfig, () => {
            return $(e.target).removeAttr('disabled');
          });
        } else {
          // 全アイテム再描画
          $(e.target).attr('disabled', true);
          return WorktableCommon.stopPreviewAndRefreshAllItemsFromInstancePageValue(PageValue.getPageNum(), () => {
            return $(e.target).removeAttr('disabled');
          });
        }
      });
    } else {
      // イベントの設定が繋がっていない場合はdisabled
      $('.update_event_after', emt).attr('disabled', true);
    }

    // 選択メニューイベント
    return $('.te_item_select', emt).find('li:not(".dropdown-header")').off('click').on('click', function(e) {
      e.preventDefault();
      config.clearError();
      return config.selectItem(this);
    });
  }

  static switchChildrenConfig(e, varName, openValue, targetValue) {
    for(let cKey in openValue) {
      let cValue = openValue[cKey];
      if((cValue === null)) {
        // 判定値無し
        return;
      }
      if(typeof targetValue === 'object') {
        // オブジェクトの場合は判定しない
        return;
      }

      if(typeof cValue !== 'array') {
        cValue = [cValue];
      }

      for(let idx = 0; idx < cValue.length; idx++) {
        const o = cValue[idx];
        if((typeof o === 'string') && ((o === 'true') || (o === 'false'))) {
          cValue[idx] = o === 'true';
        }
      }
      if((typeof targetValue === 'string') && ((targetValue === 'true') || (targetValue === 'false'))) {
        targetValue = targetValue === 'true';
      }

      const root = e.closest('.event');
      const openClassName = ConfigMenu.Modifiable.CHILDREN_WRAPPER_CLASS.replace('@parentvarname', varName).replace('@childrenkey', cKey);
      if($.inArray(targetValue, cValue) >= 0) {
        $(root).find(`.${openClassName}`).show();
      } else {
        $(root).find(`.${openClassName}`).hide();
      }
    }
  }

  static setSelectItemValue(dropDownRoot, value) {
    const li = $.grep(dropDownRoot.find('.te_item_select li'), (n, i) => $(n).children('input:first').val() === value);
    const name = $(li).children('a:first').html();
    dropDownRoot.find('.btn-primary:first').text(name);
    dropDownRoot.children('input:first').val(value);
    return this.setSelectedItemBorder(dropDownRoot);
  }

  static setSelectedItemBorder(dropDownRoot) {
    // 選択枠
    const value = $(dropDownRoot).children('input:first').val();
    const id = value.split(EventConfig.EVENT_ITEM_SEPERATOR)[0];
    WorktableCommon.clearTimelineSelectedBorderInMainWrapper();
    return WorktableCommon.setSelectedBorder($(`#${id}`), "timeline");
  }
};
EventConfig.initClass();
