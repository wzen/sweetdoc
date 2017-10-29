import PageValue from '../../../base/page_value';
let constant = undefined;
export default class EventPageValueBase {
  static initClass() {
    // 定数
    constant = gon.const;

    this.NO_METHOD = constant.EventPageValue.NO_METHOD;
    this.NO_JUMPPAGE = constant.EventPageValue.NO_JUMPPAGE;

    const Cls = (this.PageValueKey = class PageValueKey {
      static initClass() {
        // @property [String] DIST_ID 一意のイベント識別ID
        this.DIST_ID = constant.EventPageValueKey.DIST_ID;
        // @property [String] ID オブジェクトID
        this.ID = constant.EventPageValueKey.ID;
        // @property [String] CLASS_DIST_TOKEN クラス識別TOKEN
        this.CLASS_DIST_TOKEN = constant.EventPageValueKey.CLASS_DIST_TOKEN;
        // @property [String] ITEM_SIZE_DIFF アイテムサイズ
        this.ITEM_SIZE_DIFF = constant.EventPageValueKey.ITEM_SIZE_DIFF;
        // @property [String] DO_FOCUS フォーカス
        this.DO_FOCUS = constant.EventPageValueKey.DO_FOCUS;
        // @property [String] DO_FOCUS チャプター開始時に表示
        this.SHOW_WILL_CHAPTER = constant.EventPageValueKey.SHOW_WILL_CHAPTER;
        // @property [String] DO_FOCUS チャプター開始時の表示実行時間
        this.SHOW_WILL_CHAPTER_DURATION = constant.EventPageValueKey.SHOW_WILL_CHAPTER_DURATION;
        // @property [String] DO_FOCUS チャプター終了時に非表示
        this.HIDE_DID_CHAPTER = constant.EventPageValueKey.HIDE_DID_CHAPTER;
        // @property [String] DO_FOCUS チャプター終了時に非表示実行時間
        this.HIDE_DID_CHAPTER_DURATION = constant.EventPageValueKey.HIDE_DID_CHAPTER_DURATION;
        // @property [String] SPECIFIC_METHOD_VALUES メソッド固有値
        this.SPECIFIC_METHOD_VALUES = constant.EventPageValueKey.SPECIFIC_METHOD_VALUES;
        // @property [String] IS_COMMON_EVENT 共通イベント判定
        this.IS_COMMON_EVENT = constant.EventPageValueKey.IS_COMMON_EVENT;
        // @property [String] ORDER ソート番号
        this.ORDER = constant.EventPageValueKey.ORDER;
        // @property [String] METHODNAME イベント名
        this.METHODNAME = constant.EventPageValueKey.METHODNAME;
        // @property [String] ACTIONTYPE アクションタイプ名
        this.ACTIONTYPE = constant.EventPageValueKey.ACTIONTYPE;
        // @property [String] FINISH_PAGE ページ終了フラグ
        this.FINISH_PAGE = constant.EventPageValueKey.FINISH_PAGE;
        // @property [String] JUMPPAGE_NUM ページ遷移先番号
        this.JUMPPAGE_NUM = constant.EventPageValueKey.JUMPPAGE_NUM;
        // @property [String] IS_SYNC 同時実行
        this.IS_SYNC = constant.EventPageValueKey.IS_SYNC;
        // @property [String] SCROLL_TIME スクロール実行開始位置
        this.SCROLL_POINT_START = constant.EventPageValueKey.SCROLL_POINT_START;
        // @property [String] SCROLL_TIME スクロール実行終了位置
        this.SCROLL_POINT_END = constant.EventPageValueKey.SCROLL_POINT_END;
        // @property [String] SCROLL_ENABLED_DIRECTIONS スクロール可能方向
        this.SCROLL_ENABLED_DIRECTIONS = constant.EventPageValueKey.SCROLL_ENABLED_DIRECTIONS;
        // @property [String] SCROLL_FORWARD_DIRECTIONS スクロール進行方向
        this.SCROLL_FORWARD_DIRECTIONS = constant.EventPageValueKey.SCROLL_FORWARD_DIRECTIONS;
        // @property [String] CHANGE_FORKNUM フォーク番号
        this.CHANGE_FORKNUM = constant.EventPageValueKey.CHANGE_FORKNUM;
        // @property [String] MODIFIABLE_VARS 変更するインスタンス変数
        this.MODIFIABLE_VARS = constant.EventPageValueKey.MODIFIABLE_VARS;
        // @property [String] EVENT_DURATION クリック実行時間
        this.EVENT_DURATION = constant.EventPageValueKey.EVENT_DURATION;
      }
    });
    Cls.initClass();
  }

  // コンフィグ初期設定
  // @param [Object] eventConfig イベントコンフィグオブジェクト
  static initConfigValue(eventConfig) {
    const _scrollLength = function(eventConfig) {
      const writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum));
      if(writeValue !== null) {
        const start = writeValue[this.PageValueKey.SCROLL_POINT_START];
        const end = writeValue[this.PageValueKey.SCROLL_POINT_END];
        if((start !== null) && $.isNumeric(start) && (end !== null) && $.isNumeric(end)) {
          return parseInt(end) - parseInt(start);
        }
      }

      return 0;
    };

    const handlerDiv = $(".handler_div", eventConfig.emt);
    if(eventConfig[this.PageValueKey.ACTIONTYPE] === constant.ActionType.SCROLL) {
      const startDiv = handlerDiv.find('.scroll_point_start:first');
      const start = startDiv.val();
      let s = null;
      if(start.length === 0) {
        s = EventPageValueBase.getAllScrollLength();
        startDiv.val(s);
        if(s === 0) {
          startDiv.prop("disabled", true);
        }
      }
      const endDiv = handlerDiv.find('.scroll_point_end:first');
      const end = endDiv.val();
      if(end.length === 0) {
        return endDiv.val(parseInt(s) + _scrollLength.call(this, eventConfig));
      }
    } else if(eventConfig[this.PageValueKey.ACTIONTYPE] === constant.ActionType.CLICK) {
      const eventDuration = handlerDiv.find('.click_duration:first');
      const item = window.instanceMap[eventConfig[this.PageValueKey.ID]];
      if(item !== null) {
        let duration = item.constructor.actionProperties.methods[eventConfig[this.PageValueKey.METHODNAME]][item.constructor.ActionPropertiesKey.EVENT_DURATION];
        if((duration === null)) {
          duration = 0;
        }
        return eventDuration.val(duration);
      }
    }
  }

  // PageValueに書き込みデータを取得
  // @param [Object] eventConfig イベントコンフィグオブジェクト
  // @return [Object] 書き込むデータ
  static writeToPageValue(eventConfig) {
    const errorMes = '';
    const writeValue = {};
    for(let k in this.PageValueKey) {
      const v = this.PageValueKey[k];
      if(eventConfig[v] !== null) {
        writeValue[v] = eventConfig[v];
      }
    }

    if(errorMes.length === 0) {
      PageValue.setEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum), writeValue);
      if(parseInt(PageValue.getEventPageValue(PageValue.Key.eventCount())) < eventConfig.teNum) {
        PageValue.setEventPageValue(PageValue.Key.eventCount(), eventConfig.teNum);
      }
    }

    return errorMes;
  }

  // PageValueからConfigにデータを読み込み
  // @param [Object] eventConfig イベントコンフィグオブジェクト
  // @return [Boolean] 読み込み成功したか
  static readFromPageValue(eventConfig) {
    const writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum));
    if(writeValue !== null) {
      for(let k in this.PageValueKey) {
        const v = this.PageValueKey[k];
        if(writeValue[v] !== null) {
          eventConfig[v] = writeValue[v];
        }
      }

      // コンフィグ作成
      eventConfig.constructor.addEventConfigContents(eventConfig[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]);

      // 選択イベントタイプ
      const selectItemValue = `${eventConfig[this.PageValueKey.ID]}${EventConfig.EVENT_ITEM_SEPERATOR}${eventConfig[this.PageValueKey.CLASS_DIST_TOKEN]}`;
      eventConfig.constructor.setSelectItemValue($('.dropdown:first', eventConfig.emt), selectItemValue);

      // 選択メソッドタイプ
      const actionFormName = EventConfig.ITEM_ACTION_CLASS.replace('@classdisttoken', eventConfig[this.PageValueKey.CLASS_DIST_TOKEN]);
      $(`.${actionFormName} .radio`, eventConfig.emt).each(function(e) {
        const methodName = $(this).find('input.method_name').val();
        if(methodName === eventConfig[EventPageValueBase.PageValueKey.METHODNAME]) {
          return $(this).find('input[type=radio]').prop('checked', true);
        }
      });

      // 共通情報
      // ページ終了フラグ & ページ遷移
      if((eventConfig[this.PageValueKey.FINISH_PAGE] !== null) && eventConfig[this.PageValueKey.FINISH_PAGE]) {
        $('.finish_page', eventConfig.emt).attr('checked', true);
      } else {
        $('.finish_page', eventConfig.emt).removeAttr('checked');
      }
      if(eventConfig[this.PageValueKey.JUMPPAGE_NUM] !== null) {
        $('.finish_page_select', eventConfig.emt).val(eventConfig[this.PageValueKey.JUMPPAGE_NUM]);
      } else {
        $('.finish_page_select', eventConfig.emt).val(EventPageValueBase.NO_JUMPPAGE);
      }

      if(!eventConfig[this.PageValueKey.IS_COMMON_EVENT]) {
        // 画面位置&サイズ
        if(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF] && eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].x) {
          $('.item_position_diff_x', eventConfig.emt).val(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].x);
        }
        if(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF] && eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].y) {
          $('.item_position_diff_y', eventConfig.emt).val(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].y);
        }
        if(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF] && eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].w) {
          $('.item_diff_width', eventConfig.emt).val(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].w);
        }
        if(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF] && eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].h) {
          $('.item_diff_height', eventConfig.emt).val(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].h);
        }
        if(eventConfig[this.PageValueKey.DO_FOCUS]) {
          $('.do_focus', eventConfig.emt).prop('checked', true);
        } else {
          $('.do_focus', eventConfig.emt).removeAttr('checked');
        }

        // 画面表示
        const showWillEnabled = (eventConfig[this.PageValueKey.SHOW_WILL_CHAPTER] === null) || eventConfig[this.PageValueKey.SHOW_WILL_CHAPTER];
        $('.show_will_chapter', eventConfig.emt).prop('checked', showWillEnabled);
        let showWillDuration = eventConfig[this.PageValueKey.SHOW_WILL_CHAPTER_DURATION];
        if((showWillDuration === null)) {
          showWillDuration = 0;
        }
        $('.show_will_chapter_duration', eventConfig.emt).val(showWillDuration);
        const hideDidEnabled = (eventConfig[this.PageValueKey.HIDE_DID_CHAPTER] !== null) && eventConfig[this.PageValueKey.HIDE_DID_CHAPTER];
        $('.hide_did_chapter', eventConfig.emt).prop('checked', hideDidEnabled);
        const hideDidDuration = eventConfig[this.PageValueKey.HIDE_DID_CHAPTER_DURATION];
        if(hideDidDuration !== null) {
          $('.hide_did_chapter_duration', eventConfig.emt).val(hideDidDuration);
        }
      }

      // Sync
      const parallel = $(".parallel_div .parallel", eventConfig.emt);
      if((parallel !== null) && eventConfig[this.PageValueKey.IS_SYNC]) {
        parallel.prop("checked", true);
      }

      // 操作
      const handlerDiv = $(".handler_div", eventConfig.emt);
      if(eventConfig[this.PageValueKey.ACTIONTYPE] === constant.ActionType.SCROLL) {
        handlerDiv.find('input[type=radio][value=scroll]').prop('checked', true);
        if((eventConfig[this.PageValueKey.SCROLL_POINT_START] !== null) && (eventConfig[this.PageValueKey.SCROLL_POINT_END] !== null)) {
          handlerDiv.find('.scroll_point_start:first').val(eventConfig[this.PageValueKey.SCROLL_POINT_START]);
          handlerDiv.find('.scroll_point_end:first').val(eventConfig[this.PageValueKey.SCROLL_POINT_END]);
        }

        const topEmt = handlerDiv.find('.scroll_enabled_top:first');
        if(topEmt !== null) {
          topEmt.children('.scroll_enabled:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].top);
          if(eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].top) {
            topEmt.children('.scroll_forward:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS].top);
          } else {
            topEmt.children('.scroll_forward:first').prop("checked", false);
            topEmt.children('.scroll_forward:first').parent('label').hide();
          }
        }
        const bottomEmt = handlerDiv.find('scroll_enabled_bottom:first');
        if(bottomEmt !== null) {
          bottomEmt.children('.scroll_enabled:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].bottom);
          if(eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].bottom) {
            bottomEmt.children('.scroll_forward:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS].bottom);
          } else {
            bottomEmt.children('.scroll_forward:first').prop("checked", false);
            bottomEmt.children('.scroll_forward:first').parent('label').hide();
          }
        }
        const leftEmt = handlerDiv.find('scroll_enabled_left:first');
        if(leftEmt !== null) {
          leftEmt.children('.scroll_enabled:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].left);
          if(eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].left) {
            leftEmt.children('.scroll_forward:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS].left);
          } else {
            leftEmt.children('.scroll_forward:first').prop("checked", false);
            leftEmt.children('.scroll_forward:first').parent('label').hide();
          }
        }
        const rightEmt = handlerDiv.find('scroll_enabled_right:first');
        if(rightEmt !== null) {
          rightEmt.children('.scroll_enabled:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].right);
          if(eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].right) {
            rightEmt.children('.scroll_forward:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS].right);
          } else {
            rightEmt.children('.scroll_forward:first').prop("checked", false);
            rightEmt.children('.scroll_forward:first').parent('label').hide();
          }
        }

      } else if(eventConfig[this.PageValueKey.ACTIONTYPE] === constant.ActionType.CLICK) {
        handlerDiv.find('input[type=radio][value=click]').prop('checked', true);
        const eventDuration = handlerDiv.find('.click_duration:first');
        if(eventConfig[this.PageValueKey.EVENT_DURATION] !== null) {
          eventDuration.val(eventConfig[this.PageValueKey.EVENT_DURATION]);
        } else {
          const item = window.instanceMap[eventConfig[this.PageValueKey.ID]];
          if(item !== null) {
            //duration = item.constructor.actionProperties.methods[eventConfig[@PageValueKey.METHODNAME]][item.constructor.ActionPropertiesKey.EVENT_DURATION]
            let duration = eventConfig[this.PageValueKey.EVENT_DURATION];
            if((duration === null)) {
              duration = 0;
            }
            eventDuration.val(duration);
          }
        }
        const enabled = (eventConfig[this.PageValueKey.CHANGE_FORKNUM] !== null) && (eventConfig[this.PageValueKey.CHANGE_FORKNUM] > 0);
        $('.enable_fork:first', handlerDiv).prop('checked', enabled);
      }

      const specificValues = eventConfig[this.PageValueKey.SPECIFIC_METHOD_VALUES];
      const specificRoot = $(eventConfig.emt).find(`.${eventConfig.methodClassName()} .${eventConfig.constructor.METHOD_VALUE_SPECIFIC_ROOT}`);
      if(specificValues !== null) {
        for(let className in specificValues) {
          const value = specificValues[className];
          specificRoot.find(`.${className}:first`).val(value);
        }
      }

      return true;
    } else {
      return false;
    }
  }

  // スクロールの合計の長さを取得
  // @return [Integer] 取得値
  static getAllScrollLength() {
    let maxTeNum = 0;
    let ret = null;
    $(`#${PageValue.Key.E_ROOT} .${PageValue.Key.E_SUB_ROOT} .${PageValue.Key.pageRoot()}`).children('div').each((i, e) => {
      const teNum = parseInt($(e).attr('class'));
      if(teNum > maxTeNum) {
        const start = $(e).find(`.${this.PageValueKey.SCROLL_POINT_START}:first`).val();
        const end = $(e).find(`.${this.PageValueKey.SCROLL_POINT_END}:first`).val();
        if((start !== null) && (start !== "null") && (end !== null) && (end !== "null")) {
          maxTeNum = teNum;
          return ret = end;
        }
      }
    });
    if((ret === null)) {
      return 0;
    }

    return parseInt(ret);
  }
};
EventPageValueBase.initClass();

