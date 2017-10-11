/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
var PreloadItemImage = (function() {
  let UPLOAD_FORM_WIDTH = undefined;
  let UPLOAD_FORM_HEIGHT = undefined;
  let _makeImageObjectIfNeed = undefined;
  let _sizeOfKeepAspect = undefined;
  let _initModalEvent = undefined;
  PreloadItemImage = class PreloadItemImage extends ItemBase {
    static initClass() {
      UPLOAD_FORM_WIDTH = 350;
      UPLOAD_FORM_HEIGHT = 200;

      this.NAME_PREFIX = "image";
      this.CLASS_DIST_TOKEN = 'PreloadItemImage';

      this.actionProperties =
        {
          modifiables: {
            imagePath: {
              name: "Select image",
              type: 'select_image_file',
              ja: {
                name: "画像を選択"
              }
            }
          }
        };

      _makeImageObjectIfNeed = function(callback, show) {
        if(this._image !== null) {
          // 作成済みの場合
          callback(show);
          return;
        }

        if((this.imagePath == null)) {
          // 作成不可
          callback(show);
          return;
        }

        this._onloaded = false;
        this._image = new Image();
        this._image.src = this.imagePath;
        this._image.onload = () => {
          this._onloaded = true;
          return callback(show);
        };
        return this._image.onerror = () => {
          // 読み込み失敗 -> NoImageに変更
          this.imagePath = null;
          this._image = null;
          return this.refresh();
        };
      };

      _sizeOfKeepAspect = function() {
        if((this.itemSize.w / this.itemSize.h) > (this._image.naturalWidth / this._image.naturalHeight)) {
          // 高さに合わせる
          return {
            width: (this._image.naturalWidth * this.itemSize.h) / this._image.naturalHeight,
            height: this.itemSize.h
          };
        } else {
          // 幅に合わせる
          return {
            width: this.itemSize.w,
            height: (this._image.naturalHeight * this.itemSize.w) / this._image.naturalWidth
          };
        }
      };

      _initModalEvent = function(emt) {
        return this.initModifiableSelectFile(emt);
      };
    }

    // コンストラクタ
    // @param [Array] cood 座標
    constructor(cood = null) {
      super(cood);
      this.imagePath = null;
      this._image = null;
      this.isKeepAspect = true;
      if(cood !== null) {
        this._moveLoc = {x: cood.x, y: cood.y};
      }
      this.visible = true;
    }

    // アイテムサイズ更新
    updateItemSize(w, h) {
      let height, width;
      super.updateItemSize(w, h);
      if(this.isKeepAspect) {
        const size = _sizeOfKeepAspect.call(this);
        ({width} = size);
        ({height} = size);
      } else {
        width = this.itemSize.w;
        height = this.itemSize.h;
      }
      const imageCanvas = this.getJQueryElement().find('canvas').get(0);
      imageCanvas.width = this.itemSize.w;
      imageCanvas.height = this.itemSize.h;
      const imageContext = imageCanvas.getContext('2d');
      const left = (this.itemSize.w - width) * 0.5;
      const top = (this.itemSize.h - height) * 0.5;
      return imageContext.drawImage(this._image, left, top, width, height);
    }

    // 再描画処理
    // @param [boolean] show 要素作成後に描画を表示するか
    // @param [Function] callback コールバック
    refresh(show, callback = null) {
      if(show == null) {
        show = true;
      }
      this.removeItemElement();
      return this.createItemElement(_show => {
          this.itemDraw(_show);
          if(this.setupItemEvents !== null) {
            // アイテムのイベント設定
            this.setupItemEvents();
          }
          if(callback !== null) {
            return callback(this);
          }
        }
        , show, false);
    }

    // アイテム削除 ※コールバックは無くていい
    removeItemElement() {
      return super.removeItemElement();
    }

    // TODO: レコード削除


    // アイテム用のテンプレートHTMLを読み込み
    // @return [String] HTML
    createItemElement(callback, show, showModal) {
      if(showModal == null) {
        showModal = true;
      }
      return _makeImageObjectIfNeed.call(this, show => {
          if(this._image !== null) {
            if((this._onloaded !== null) && this._onloaded) {
              let height, width;
              if(this.isKeepAspect) {
                const size = _sizeOfKeepAspect.call(this);
                ({width} = size);
                ({height} = size);
              } else {
                width = this.itemSize.w;
                height = this.itemSize.h;
              }
              const imageCanvas = document.createElement('canvas');
              imageCanvas.width = this.itemSize.w;
              imageCanvas.height = this.itemSize.h;
              const imageContext = imageCanvas.getContext('2d');
              const left = (this.itemSize.w - width) * 0.5;
              const top = (this.itemSize.h - height) * 0.5;
              imageContext.drawImage(this._image, left, top, width, height);
              return this.addContentsToScrollInside(imageCanvas, function() {
                if(callback !== null) {
                  return callback(show);
                }
              });
            } else {
              // @_image有り & @_onloaded無し -> 別スレッドで描画中の場合はadd処理なし
              if(callback !== null) {
                return callback(show);
              }
            }
          } else {
            // 画像未設定時表示
            const contents = `\
<div class='no_image'><div class='center_image put_center'></div></div>\
`;
            this.addContentsToScrollInside(contents, function() {
              if(callback !== null) {
                return callback(show);
              }
            });
            if(showModal) {
              // 画像アップロードモーダル表示
              return Common.showModalView(constant.ModalViewType.ITEM_IMAGE_UPLOAD, true, (modalEmt, params, callback = null) => {
                $(modalEmt).find('form').off().on('ajax:complete', (e, data, status, error) => {
                  // モーダル非表示
                  Common.hideModalView();
                  const d = JSON.parse(data.responseText);
                  if(d.resultSuccess) {
                    this.imagePath = d.image_url;
                    this.saveObj();
                    return this.refresh();
                  } else {
                    WorktableCommon.removeSingleItem(this.getJQueryElement());
                    return FloatView.show('Upload error', FloatView.Type.ERROR, 3.0);
                  }
                });
                _initModalEvent.call(this, modalEmt);
                if(callback !== null) {
                  return callback(show);
                }
              });
            }
          }
        }
        , show);
    }
  };
  PreloadItemImage.initClass();
  return PreloadItemImage;
})();

Common.setClassToMap(PreloadItemImage.CLASS_DIST_TOKEN, PreloadItemImage);

if((window.itemInitFuncList !== null) && (window.itemInitFuncList[PreloadItemImage.CLASS_DIST_TOKEN] == null)) {
  if(window.debug) {
    console.log('PreloadImage loaded');
  }
  window.itemInitFuncList[PreloadItemImage.CLASS_DIST_TOKEN] = function(option) {
    if(option == null) {
      option = {};
    }
    if(window.isWorkTable && (PreloadItemImage.jsLoaded !== null)) {
      PreloadItemArrow.jsLoaded(option);
    }
    //JS読み込み完了後の処理
    if(window.debug) {
      return console.log('PreloadImage init Finish');
    }
  };
}