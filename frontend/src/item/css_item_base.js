/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// CSSアイテム
// @abstract
// @extend ItemBase
class CssItemBase extends ItemBase {
  static initClass() {

    if(window.loadedClassDistToken !== null) {
      // @property [String] CLASS_DIST_TOKEN アイテム種別
      this.CLASS_DIST_TOKEN = window.loadedClassDistToken;
    }


    if(window.isWorkTable) {
      this.include(cssItemBaseWorktableExtend);
    }
  }

  // コンストラクタ
  // @param [Array] cood 座標
  constructor(cood = null) {
    super(cood);
    this._cssRoot = null;
    this._cssDesignToolCache = null;
    this._cssDesignToolCode = null;
    this._cssDesignToolStyle = null;
    if(cood !== null) {
      this._moveLoc = {x: cood.x, y: cood.y};
    }
    this._cssStypeReflectTimer = null;
  }

  // initEvent前の処理
  initEventPrepare() {
    // アニメーションCSS作成
    return this.appendAnimationCssIfNeeded();
  }

  // HTML要素
  // @abstract
  cssItemHtml() {
    return '';
  }

  // アイテム用のテンプレートHTMLを読み込み
  // @return [String] HTML
  createItemElement(callback) {
    const element = `<div class='css_item_base context_base put_center'>${this.cssItemHtml()}</div>`;
    return this.addContentsToScrollInside(element, callback);
  }

  // JSファイル読み込み時処理
  static jsLoaded(option) {
  }

  // ワークテーブルの初期化処理

  // CSSのルートのIDを取得
  // @return [String] CSSルートID
  getCssRootElementId() {
    return `css_${this.id}`;
  }

  // CSSアニメーションルートID取得
  // @return [String] CSSアニメーションID
  getCssAnimElementId() {
    return "css_anim_style";
  }

  //CSSを設定
  makeDesignConfigCss(forceUpdate) {
    if(forceUpdate === null) {
      forceUpdate = false;
    }
    const _applyCss = function(designs) {
      // CSS用のDiv作成
      let temp;
      if(designs !== null) {
        let k, v;
        temp = $('.cssdesign_tool_temp:first').clone(true).attr('class', '');
        temp.attr('id', this.getCssRootElementId());
        if(designs.values !== null) {
          for(k in designs.values) {
            //if window.debug
            //console.log("k: #{k}  v: #{v}")
            v = designs.values[k];
            temp.find(`.${k}`).html(`${v}`);
          }
        }
        if(designs.flags !== null) {
          for(k in designs.flags) {
            v = designs.flags[k];
            if(!v) {
              temp.find(`.${k}`).empty();
            }
          }
        }
      } else {
        temp = $('.cssdesign_temp:first').clone(true).attr('class', '');
        temp.attr('id', this.getCssRootElementId());
      }

      temp.find('.design_item_obj_id').html(this.id);
      return temp.appendTo(window.cssCode);
    };

    const rootEmt = $(`${this.getCssRootElementId()}`);
    if((rootEmt !== null) && (rootEmt.length > 0)) {
      if(forceUpdate) {
        // 上書きするため一旦削除
        $(`${this.getCssRootElementId()}`).remove();
      } else {
        return;
      }
    }

    if(this.designs !== null) {
      // 保存しているデザインで初期化
      _applyCss.call(this, this.designs);
    } else {
      // デフォルトのデザインで初期化
      _applyCss.call(this, this.constructor.actionProperties.designConfigDefaultValues);
    }

    this._cssRoot = $(`#${this.getCssRootElementId()}`);
    this._cssDesignToolCache = $(".css_design_tool_cache", this._cssRoot);
    this._cssDesignToolCode = $(".css_design_tool_code", this._cssRoot);
    return this._cssDesignToolStyle = $(".css_design_tool_style", this._cssRoot);
  }

  //@applyDesignChange(false)

  // 再描画処理
  // @param [boolean] show 要素作成後に描画を表示するか
  // @param [Function] callback コールバック
  refresh(show, callback = null, doApplyDesignChange) {
    if(show === null) {
      show = true;
    }
    if(doApplyDesignChange === null) {
      doApplyDesignChange = true;
    }
    if(doApplyDesignChange) {
      // デザインコンフィグのCSS作成
      this.applyDesignChange(false, false);
    }
    return super.refresh(show, () => {
      if(callback !== null) {
        return callback(this);
      }
    });
  }

  // デザイン反映
  applyDesignChange(doStyleSave, doRefresh) {
    // デザインコンフィグのCSS作成
    let addStyle;
    if(doStyleSave === null) {
      doStyleSave = true;
    }
    if(doRefresh === null) {
      doRefresh = true;
    }
    this.makeDesignConfigCss();
    this._cssDesignToolStyle.text(this._cssDesignToolCode.text());
    const styleId = `css_style_${this.id}`;
    $(`#${styleId}`).remove();
    if((addStyle = this.cssStyle()) !== null) {
      this._cssRoot.append($(`<style id='${styleId}' type='text/css'>${addStyle}</style>`));
    }
    if(doStyleSave) {
      this.saveDesign();
    }
    if(doRefresh) {
      return this.refresh(true, null, false);
    }
  }

  // CSSスタイル
  // @abstract
  cssStyle() {
  }

  // アニメーションKeyframe
  // @abstract
  cssAnimationKeyframe() {
    return null;
  }

  // アニメーションCSS追加処理
  appendAnimationCssIfNeeded() {
    const keyframe = this.cssAnimationKeyframe();
    if(keyframe !== null) {
      const methodName = this.getEventMethodName();
      // CSSが存在する場合は削除して入れ替え
      this.removeAnimationCss();
      const funcName = `${methodName}_${this.id}`;
      const keyFrameName = `${this.id}_frame`;
      const webkitKeyframe = `@-webkit-keyframes ${keyframe}`;
      const mozKeyframe = `@-moz-keyframes ${keyframe}`;
      const duration = this.eventDuration();

      // CSSに設定
      const css = `\
.${funcName}
{
-webkit-animation-name: ${keyFrameName};
-moz-animation-name: ${keyFrameName};
-webkit-animation-duration: ${duration}s;
-moz-animation-duration: ${duration}s;
}\
`;

      return window.cssCode.append(`<div class='${funcName}'><style type='text/css'> ${webkitKeyframe} ${mozKeyframe} ${css} </style></div>`);
    }
  }

  // アニメーションCSS削除処理
  removeAnimationCss() {
    const methodName = this.getEventMethodName();
    const funcName = `${methodName}_${this.id}`;
    return window.cssCode.find(`.${funcName}`).remove();
  }
}

CssItemBase.initClass();

