/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
$(function() {
  window.isItemPreview = true;
  // 初期タイプはWS
  window.isMotionCheck = false;

  // ブラウザ対応チェック
  if(!Common.checkBlowserEnvironment()) {
    Common.showModalView(constant.ModalViewType.ENVIRONMENT_NOT_SUPPORT, false);
    alert('This browser is not under support.');
    return;
  }

  // 変数初期化
  CommonVar.initVarWhenLoadedView();
  CommonVar.initCommonVar();
  ItemPreviewCommon.createdMainContainerIfNeeded();
  ItemPreviewCommon.initMainContainerAsWorktable();

  $('.coding.item_preview').ready(function() {
    // コーディングデバッグ
    let timer;
    window.isCodingDebug = true;
    // 初期化終了
    window.initDone = true;

    let count = 0;
    return timer = setInterval(() => {
        if(window[constant.ITEM_CODING_TEMP_CLASS_NAME] != null) {
          clearInterval(timer);
          ItemPreviewCommon.initAfterLoadItem();
        }
        count += 1;
        if(count >= 100) {
          return clearInterval(timer);
        }
      }
      , 50);
  });


  return $('.item_gallery.preview').ready(function() {
    // アイテムギャラリー動作確認
    let timer;
    window.isCodingDebug = false;
    // 初期化終了
    window.initDone = true;

    const itemClassName = $(`.${constant.ITEM_GALLERY_ITEM_CLASSNAME}:first`).val();
    let count = 0;
    return timer = setInterval(() => {
        if(window[itemClassName] != null) {
          clearInterval(timer);
          ItemPreviewCommon.initAfterLoadItem();
        }
        count += 1;
        if(count >= 100) {
          return clearInterval(timer);
        }
      }
      , 50);
  });
});
