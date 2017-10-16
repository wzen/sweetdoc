import Common from '../base/common';
import UploadBase from './upload_base';

export default class UploadItem extends UploadBase {
  // アップロード
  upload(root, callback = null) {
    // 入力値バリデーションチェック
    const title = $(`input[name='${constant.ItemGallery.Key.TITLE}']`, root).val();
    if(title.length === 0) {
      $('.title_error', root).show();
      return;
    }

    // 保存処理
    const _saveGallery = function() {
      Common.showModalFlashMessage('Updating...');
      const fd = new FormData(document.getElementById('upload_form'));
      const tags = $.map($('.select_tag a', root), n => $(n).html());
      if(tags !== null) {
        fd.append(constant.ItemGallery.Key.TAGS, tags);
      } else {
        fd.append(constant.ItemGallery.Key.TAGS, null);
      }

      return $.ajax({
        url: '/item_gallery/save_state',
        data: fd,
        processData: false,
        contentType: false,
        type: 'POST',
        success(data) {
          if(data.resultSuccess) {
            // マイページ遷移
            return window.location.href = "/my_page/created_items";
          } else {
            console.log('gallery/save_state server error');
            return Common.ajaxError(data);
          }
        },
        error(data) {
          console.log('gallery/save_state ajax error');
          return Common.ajaxError(data);
        }
      });
    };

    // 確認ダイアログ
    if(window.confirm(I18n.t('message.dialog.update_gallery'))) {
      return _saveGallery.call(this);
    }
  }
}
