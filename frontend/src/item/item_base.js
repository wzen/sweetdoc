/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// アイテム基底
// @abstract
var ItemBase = (function() {
  let constant = undefined;
  ItemBase = class ItemBase extends ItemEventBase {
    static initClass() {
      // @property [String] ID_PREFIX IDプレフィックス
      this.ID_PREFIX = "i";
      // @abstract
      // @property [String] NAME_PREFIX 名前プレフィックス
      this.NAME_PREFIX = "";
      // @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
      this.DESIGN_CONFIG_ROOT_ID = 'design_config_@id';
      // @property [String] DESIGN_CONFIG_ROOT_ID デザインコンフィグRoot
      this.DESIGN_PAGEVALUE_ROOT = 'designs';

      constant = gon.const;
      const Cls = (this.ImageKey = class ImageKey {
        static initClass() {
          this.PROJECT_ID = constant.PreloadItemImage.Key.PROJECT_ID;
          this.ITEM_OBJ_ID = constant.PreloadItemImage.Key.ITEM_OBJ_ID;
          this.EVENT_DIST_ID = constant.PreloadItemImage.Key.EVENT_DIST_ID;
          this.SELECT_FILE = constant.PreloadItemImage.Key.SELECT_FILE;
          this.URL = constant.PreloadItemImage.Key.URL;
          this.SELECT_FILE_DELETE = constant.PreloadItemImage.Key.SELECT_FILE_DELETE;
        }
      });
      Cls.initClass();

      if(window.isWorkTable) {
        this.include(itemBaseWorktableExtend);
      }
    }

    // コンストラクタ
    // @param [Array] cood 座標
    constructor(cood = null) {
      super();
      // @property [Int] id ID
      this.id = this.constructor.ID_PREFIX + '_' + this.constructor.NAME_PREFIX + '_' + Common.generateId();
      // @property [ItemType] CLASS_DIST_TOKEN アイテム種別
      this.classDistToken = this.constructor.CLASS_DIST_TOKEN;
      // @property [String] name 名前
      this.name = null;
      // @property [String] visible 表示状態
      this.visible = false;
      // @property [String] firstFocus 初期フォーカス
      this.firstFocus = false;
      // @property [Object] _drawingSurfaceImageData 画面を保存する変数
      this._drawingSurfaceImageData = null;
      if(cood !== null) {
        // @property [Array] _mousedownCood 初期座標
        this._mousedownCood = {x: cood.x, y: cood.y};
      }
      // @property [Array] itemSize サイズ
      this.itemSize = null;
      // @property [Int] zIndex z-index
      this.zindex = constant.Zindex.EVENTBOTTOM + 1;
      // @property [Array] _ohiRegist 操作履歴Index保存配列
      this._ohiRegist = [];
      // @property [Int] _ohiRegistIndex 操作履歴Index保存配列のインデックス
      this._ohiRegistIndex = 0;
      // @property [Array] registCoord ドラッグ座標
      this.registCoord = [];
    }

    // アイテムのJQuery要素を取得
    // @return [Object] JQuery要素
    getJQueryElement() {
      return $(`#${this.id}`);
    }

    // アイテム用のテンプレートHTMLを読み込み
    // @abstract
    // @return [String] HTML
    createItemElement(callback) {
      return callback();
    }

    // アイテム削除
    removeItemElement() {
      return this.getJQueryElement().remove();
    }

    // ScrollInsideに要素追加
    addContentsToScrollInside(contents, callback = null) {
      if((this.getJQueryElement() != null) && (this.getJQueryElement().length > 0)) {
        // 既に存在する場合は追加しない
        if(callback != null) {
          callback();
        }
        return;
      }

      const createdElement = Common.wrapCreateItemElement(this, $(contents));
      $(createdElement).appendTo(window.scrollInside);
      if(callback != null) {
        return callback();
      }
    }

    // 画面を保存(全画面)
    saveDrawingSurface() {
      return this._drawingSurfaceImageData = drawingContext.getImageData(0, 0, drawingCanvas.width, drawingCanvas.height);
    }

    // 保存した画面を全画面に再設定
    restoreAllDrawingSurface() {
      return window.drawingContext.putImageData(this._drawingSurfaceImageData, 0, 0);
    }

    // 保存した画面を指定したサイズで再設定
    // @param [Array] size サイズ
    restoreRefreshingSurface(size) {
      // ボタンのLadderBand用にpaddingを付ける
      const padding = 5;
      return window.drawingContext.putImageData(this._drawingSurfaceImageData, 0, 0, size.x - padding, size.y - padding, size.w + (padding * 2), size.h + (padding * 2));
    }

    // アイテム表示
    showItem(callback = null, immediate, duration) {
      if(immediate == null) {
        immediate = true;
      }
      if(duration == null) {
        duration = 0;
      }
      if(immediate || (window.isWorkTable && window.previewRunning)) {
        // ※プレビュー実行時は即時変更
        this.getJQueryElement().css({'opacity': 1, 'z-index': Common.plusPagingZindex(this.zindex)});
        if(callback != null) {
          return callback();
        }
      } else {
        this._skipEvent = true;
        return this.getJQueryElement().css('z-index', Common.plusPagingZindex(this.zindex)).animate({'opacity': 1}, duration, function() {
          this._skipEvent = false;
          if(callback != null) {
            return callback();
          }
        });
      }
    }

    // アイテム非表示
    hideItem(callback = null, immediate, duration) {
      if(immediate == null) {
        immediate = true;
      }
      if(duration == null) {
        duration = 0;
      }
      if(immediate || (window.isWorkTable && window.previewRunning)) {
        // ※プレビュー実行時は即時変更
        this.getJQueryElement().css({'opacity': 0, 'z-index': Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM)});
        if(callback != null) {
          return callback();
        }
      } else {
        this._skipEvent = true;
        return this.getJQueryElement().css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM)).animate({'opacity': 0}, duration, function() {
          this._skipEvent = false;
          if(callback != null) {
            return callback();
          }
        });
      }
    }

    // アイテム描画
    // @abstract
    // @param [Boolean] show 要素作成後に表示するか
    itemDraw(show) {
      if(show == null) {
        show = true;
      }
      if(show) {
        return this.showItem();
      } else {
        return this.hideItem();
      }
    }

    willChapter(callback = null) {
      // nullの場合もデフォルトで表示
      if((this._event[EventPageValueBase.PageValueKey.SHOW_WILL_CHAPTER] == null) || this._event[EventPageValueBase.PageValueKey.SHOW_WILL_CHAPTER]) {
        // 表示
        let d = this._event[EventPageValueBase.PageValueKey.SHOW_WILL_CHAPTER_DURATION];
        if((d == null)) {
          d = 0;
        }
        return this.showItem(() => {
            return ItemBase.prototype.__proto__.willChapter.call(this, callback);
          }
          , d <= 0, d * 1000);
      } else {
        return super.willChapter(callback);
      }
    }

    didChapter(callback = null) {
      return super.didChapter(() => {
        if((this._event[EventPageValueBase.PageValueKey.HIDE_DID_CHAPTER] != null) && this._event[EventPageValueBase.PageValueKey.HIDE_DID_CHAPTER]) {
          // 非表示
          const d = this._event[EventPageValueBase.PageValueKey.HIDE_DID_CHAPTER_DURATION];
          return this.hideItem(() => {
              return ItemBase.prototype.__proto__.didChapter.call(this, callback);
            }
            , d <= 0, d * 1000);
        } else {
          if(callback != null) {
            return callback();
          }
        }
      });
    }

    // 再描画処理
    // @param [boolean] show 要素作成後に描画を表示するか
    // @param [Function] callback コールバック
    refresh(show, callback = null) {
      if(show == null) {
        show = true;
      }
      return requestAnimationFrame(() => {
        if(window.runDebug) {
          console.log(`ItemBase refresh id:${this.id}`);
        }
        this.removeItemElement();
        return this.createItemElement(() => {
          this.itemDraw(show);
          if(this.setupItemEvents != null) {
            // アイテムのイベント設定
            this.setupItemEvents();
          }
          if(callback != null) {
            return callback(this);
          }
        });
      });
    }

    // 画面表示がない場合描画処理
    // @param [boolean] show 要素作成後に描画を表示するか
    // @param [Function] callback コールバック
    refreshIfItemNotExist(show, callback = null) {
      if(show == null) {
        show = true;
      }
      if(window.runDebug) {
        console.log(`ItemBase refreshIfItemNotExist id:${this.id}`);
      }
      if(this.getJQueryElement().length === 0) {
        return this.refresh(show, callback);
      } else {
        if(callback != null) {
          return callback(this);
        }
      }
    }

    // CSSに反映
    applyDesignChange(doStyleSave) {
      if(doStyleSave == null) {
        doStyleSave = true;
      }
      this.refresh();
      if(doStyleSave) {
        return this.saveDesign();
      }
    }

    // アイテムの情報をアイテムリストと操作履歴に保存
    // @param [Boolean] newCreated 新規作成か
    saveObj(newCreated) {
      if(newCreated == null) {
        newCreated = false;
      }
      if(newCreated) {
        // 名前を付与
        let num = 0;
        const object = Common.allItemInstances();
        for(let k in object) {
          const v = object[k];
          if(this.constructor.NAME_PREFIX === v.constructor.NAME_PREFIX) {
            num += 1;
          }
        }
        this.name = this.constructor.NAME_PREFIX + ` ${num}`;
      }

      // ページに状態を保存
      this.setItemAllPropToPageValue();
      // キャッシュに保存
      window.lStorage.saveAllPageValues();
      // 操作履歴に保存
      OperationHistory.add();
      if(window.debug) {
        console.log('save obj');
      }

      // イベントの選択項目更新
      // fixme: 実行場所について再考
      return EventConfig.updateSelectItemMenu();
    }

    // アイテムの情報をページ値から取得
    // @property [String] prop 変数名
    // @property [Boolean] isCache キャッシュとして保存するか
    getItemPropFromPageValue(prop, isCache) {
      if(isCache == null) {
        isCache = false;
      }
      const prefix_key = isCache ? PageValue.Key.instanceValueCache(this.id) : PageValue.Key.instanceValue(this.id);
      return PageValue.getInstancePageValue(prefix_key + `:${prop}`);
    }

    // アイテムの情報をページ値に設定
    // @property [String] prop 変数名
    // @property [Object] value 値
    // @property [Boolean] isCache キャッシュとして保存するか
    setItemPropToPageValue(prop, value, isCache) {
      if(isCache == null) {
        isCache = false;
      }
      const prefix_key = isCache ? PageValue.Key.instanceValueCache(this.id) : PageValue.Key.instanceValue(this.id);
      PageValue.setInstancePageValue(prefix_key + `:${prop}`, value);
      return window.lStorage.saveInstancePageValue();
    }

    // アニメーション変更前のアイテムサイズ
    originalItemElementSize() {
      const obj = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceBefore(this._event[EventPageValueBase.PageValueKey.DIST_ID], this.id));
      return obj.itemSize;
    }

    // アイテムサイズ更新
    updateItemSize(w, h) {
      this.getJQueryElement().css({width: w, height: h});
      this.itemSize.w = parseInt(w);
      return this.itemSize.h = parseInt(h);
    }

    // イベントによって設定したスタイルをクリアする
    clearAllEventStyle() {
    }

    // アイテム作成時に設定されるデフォルトメソッド名
    static defaultMethodName() {
      if((this.actionProperties != null) &&
        (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
        return this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.METHOD];
      } else {
        return null;
      }
    }

    // アイテム作成時に設定されるデフォルトアクションタイプ
    static defaultActionType() {
      return Common.getActionTypeByCodingActionType(this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.ACTION_TYPE]);
    }

    // 独自コンフィグのデフォルト
    static defaultSpecificMethodValue() {
      if((this.actionProperties != null) &&
        (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
        const ret = this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.SPECIFIC_METHOD_VALUES];
        if(ret != null) {
          return ret;
        } else {
          return {};
        }
      } else {
        return {};
      }
    }

    // 変数編集コンフィグのデフォルト
    static defaultModifiableVars() {
      if((this.actionProperties != null) &&
        (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
        const mod = this.actionPropertiesModifiableVars(this.ActionPropertiesKey.DEFAULT_EVENT, true);
        if(mod != null) {
          return mod;
        } else {
          return {};
        }
      } else {
        return {};
      }
    }

    // スクロールのデフォルト有効方向
    static defaultScrollEnabledDirection() {
      if((this.actionProperties != null) &&
        (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
        return this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.SCROLL_ENABLED_DIRECTION];
      } else {
        return null;
      }
    }

    // スクロールのデフォルト進行方向
    static defaultScrollForwardDirection() {
      if((this.actionProperties != null) &&
        (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
        return this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.SCROLL_FORWARD_DIRECTION];
      } else {
        return null;
      }
    }

    // クリックのデフォルト時間
    static defaultClickDuration() {
      if((this.actionProperties != null) &&
        (this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT] != null)) {
        return this.actionProperties[this.ActionPropertiesKey.DEFAULT_EVENT][this.ActionPropertiesKey.EVENT_DURATION];
      } else {
        return null;
      }
    }

    // デフォルトデザインをPageValue & 変数に適用
    applyDefaultDesign() {
      // デザイン用のPageValue作成
      if(this.constructor.actionProperties.designConfigDefaultValues != null) {
        PageValue.setInstancePageValue(PageValue.Key.instanceDesignRoot(this.id), this.constructor.actionProperties.designConfigDefaultValues);
      }
      return this.designs = PageValue.getInstancePageValue(PageValue.Key.instanceDesignRoot(this.id));
    }

    // アイテム位置&サイズを更新
    updatePositionAndItemSize(itemSize, withSaveObj, withRefresh) {
      if(withSaveObj == null) {
        withSaveObj = true;
      }
      if(withRefresh == null) {
        withRefresh = false;
      }
      this.updateItemPosition(itemSize.x, itemSize.y);
      this.updateItemSize(itemSize.w, itemSize.h);
      if(withSaveObj) {
        this.saveObj();
      }
      if(withRefresh) {
        return refresh(this.isItemVisible());
      }
    }

    updateItemPosition(x, y) {
      this.getJQueryElement().css({top: y, left: x});
      this.itemSize.x = parseInt(x);
      return this.itemSize.y = parseInt(y);
    }

    // スクロールによるアイテム状態更新
    updateInstanceParamByStep(stepValue, immediate) {
      if(immediate == null) {
        immediate = false;
      }
      super.updateInstanceParamByStep(stepValue, immediate);
      return this.updateItemSizeByStep(stepValue, immediate);
    }

    // クリックによるアイテム状態更新
    updateInstanceParamByAnimation(immediate) {
      if(immediate == null) {
        immediate = false;
      }
      super.updateInstanceParamByAnimation(immediate);
      return this.updateItemSizeByAnimation();
    }

    // スクロールイベントでアイテム位置&サイズ更新
    updateItemSizeByStep(scrollValue, immediate) {
      let itemSize;
      if(immediate == null) {
        immediate = false;
      }
      const itemDiff = this._event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
      if((itemDiff == null) || (itemDiff === 'undefined')) {
        // 変更なしの場合
        return;
      }
      if((itemDiff.x === 0) && (itemDiff.y === 0) && (itemDiff.w === 0) && (itemDiff.h === 0)) {
        // 変更なしの場合
        return;
      }

      const originalItemElementSize = this.originalItemElementSize();
      if(immediate) {
        itemSize = {
          x: originalItemElementSize.x + itemDiff.x,
          y: originalItemElementSize.y + itemDiff.y,
          w: originalItemElementSize.w + itemDiff.w,
          h: originalItemElementSize.h + itemDiff.h
        };
        this.updatePositionAndItemSize(itemSize, false, true);
        return;
      }

      const scrollEnd = parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]);
      const scrollStart = parseInt(this._event[EventPageValueBase.PageValueKey.SCROLL_POINT_START]);
      const progressPercentage = scrollValue / (scrollEnd - scrollStart);
      itemSize = {
        x: originalItemElementSize.x + (itemDiff.x * progressPercentage),
        y: originalItemElementSize.y + (itemDiff.y * progressPercentage),
        w: originalItemElementSize.w + (itemDiff.w * progressPercentage),
        h: originalItemElementSize.h + (itemDiff.h * progressPercentage)
      };
      return this.updatePositionAndItemSize(itemSize, false, true);
    }

    // クリックイベントでアイテム位置&サイズ更新
    updateItemSizeByAnimation(immediate) {
      let itemSize, timer;
      if(immediate == null) {
        immediate = false;
      }
      const itemDiff = this._event[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF];
      if((itemDiff == null) || (itemDiff === 'undefined')) {
        // 変更なしの場合
        return;
      }
      if((itemDiff.x === 0) && (itemDiff.y === 0) && (itemDiff.w === 0) && (itemDiff.h === 0)) {
        // 変更なしの場合
        return;
      }

      const originalItemElementSize = this.originalItemElementSize();
      if(immediate) {
        itemSize = {
          x: originalItemElementSize.x + itemDiff.x,
          y: originalItemElementSize.y + itemDiff.y,
          w: originalItemElementSize.w + itemDiff.w,
          h: originalItemElementSize.h + itemDiff.h
        };
        this.updatePositionAndItemSize(itemSize, false, true);
        return;
      }

      const eventDuration = this._event[EventPageValueBase.PageValueKey.EVENT_DURATION];
      const duration = 0.01;
      const perX = itemDiff.x * (duration / eventDuration);
      const perY = itemDiff.y * (duration / eventDuration);
      const perW = itemDiff.w * (duration / eventDuration);
      const perH = itemDiff.h * (duration / eventDuration);
      const loopMax = Math.ceil(eventDuration / duration);
      let count = 1;
      return timer = setInterval(() => {
          itemSize = {
            x: originalItemElementSize.x + (perX * count),
            y: originalItemElementSize.y + (perY * count),
            w: originalItemElementSize.w + (perW * count),
            h: originalItemElementSize.h + (perH * count)
          };
          this.updatePositionAndItemSize(itemSize, false, true);
          if(count >= loopMax) {
            clearInterval(timer);
            itemSize = {
              x: originalItemElementSize.x + itemDiff.x,
              y: originalItemElementSize.y + itemDiff.y,
              w: originalItemElementSize.w + itemDiff.w,
              h: originalItemElementSize.h + itemDiff.h
            };
            this.updatePositionAndItemSize(itemSize, false, true);
          }
          return count += 1;
        }
        , duration * 1000);
    }

    static switchChildrenConfig(e, varName, openValue, targetValue) {
      for(let cKey in openValue) {
        let cValue = openValue[cKey];
        if((cValue == null)) {
          // 判定値無し
          return;
        }
        if(typeof targetValue === 'object') {
          // オブジェクトの場合は判定しない
          return;
        }

        if((typeof cValue === 'string') && ((cValue === 'true') || (cValue === 'false'))) {
          cValue = cValue === 'true';
        }
        if((typeof targetValue === 'string') && ((targetValue === 'true') || (targetValue === 'false'))) {
          targetValue = targetValue === 'true';
        }

        const root = e.closest(`.${constant.DesignConfig.ROOT_CLASSNAME}`);
        const openClassName = ConfigMenu.Modifiable.CHILDREN_WRAPPER_CLASS.replace('@parentvarname', varName).replace('@childrenkey', cKey);
        if(cValue === targetValue) {
          $(root).find(`.${openClassName}`).show();
        } else {
          $(root).find(`.${openClassName}`).hide();
        }
      }
    }
  };
  ItemBase.initClass();
  return ItemBase;
})();
