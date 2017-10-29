import Common from '../../base/common';

export default class UploadCommon {

  // ギャラリーアップロードビュー表示前処理
  static initEvent(upload) {
    const root = $('#upload_wrapper');

    const _setImage = function(path) {
      const FR = new FileReader();
      FR.onload = function(e) {
        const src = e.target.result;
        $('.capture', root).attr("src", src).show();
        $('.default_thumbnail', root).hide();
        $('.error_message', root).hide();
        $('.file_select_delete', root).show();
        const image = new Image();
        image.src = src;
        return image.onload = function() {
          const imageData = src.split('base64,')[1];
          const contentType = src.split(';base64')[0].replace('data:', '');
          $(`input[name='${constant.Gallery.Key.THUMBNAIL_IMG_WIDTH}']`, root).val(image.width);
          return $(`input[name='${constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT}']`, root).val(image.height);
        };
      };
      return FR.readAsDataURL(path);
    };

    const _readImage = function(input) {
      if(input.files && input.files[0]) {
        return _setImage.call(this, input.files[0]);
      } else {
        return _removeImage.call(this);
      }
    };
    var _removeImage = function() {
      // 画像をデフォルトに戻す
      const selectFile = $(`.${constant.PreloadItemImage.Key.SELECT_FILE}`, root).val();
      if((selectFile !== null) && (selectFile.length > 0)) {
        $(`.${constant.PreloadItemImage.Key.SELECT_FILE}`, root).val('').trigger('change');
      }
      $(`input[name='${constant.Gallery.Key.THUMBNAIL_IMG_WIDTH}']`, root).val('');
      $(`input[name='${constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT}']`, root).val('');
      $('.file_select_delete', root).hide();
      $('.capture', root).attr("src", "").hide();
      $('.error_message', root).hide();
      return $('.default_thumbnail', root).show();
    };

    const _getThumbnailBlob = function(src) {
      const xhr = new XMLHttpRequest();
      xhr.open("GET", src, true);
      xhr.responseType = "arraybuffer";
      xhr.onload = function(e) {
        const arrayBufferView = new Uint8Array(this.response);
        const blob = new Blob([arrayBufferView], {type: "image/jpeg"});
        return _setImage(blob);
      };
      return xhr.send();
    };

    $('#remove_image').click(function() {
      return _removeImage.call(this);
    });
    // サムネイル選択時に画像変更
    $(`.${constant.PreloadItemImage.Key.SELECT_FILE}`, root).off('change').on('change', e => {
      window.uploadContents = upload;
      const f = $(`.${constant.PreloadItemImage.Key.SELECT_FILE}`, root).val();
      if((f !== null) && (f.length > 0)) {
        const {size} = e.target.files[0];
        if(size <= (constant.THUMBNAIL_FILESIZE_MAX_KB * 1000)) {
          return _readImage.call(this, e.target);
        } else {
          $('.error_message', root).text(I18n.t('upload_confirm.thumbnail_size_error', {size: constant.THUMBNAIL_FILESIZE_MAX_KB}));
          return $('.error_message', root).show();
        }
      } else {
        return _removeImage.call(this);
      }
    });
    // サムネイル削除ボタン
    $(`.${constant.PreloadItemImage.Key.SELECT_FILE_DELETE}`, root).off('click').on('click', e => {
      return _removeImage.call(this);
    });
    // 上書きリスト選択イベント
    $(`.${constant.Gallery.Key.OVERWRITE_CONTENTS_SELECT}`, root).off('change').on('change', e => {
      const token = $(e.target).val();
      if(token.length === 0) {
        // デフォルト値の選択は全て空に
        $(`.${constant.Gallery.Key.TITLE}`, root).val('');
        $(`.${constant.Gallery.Key.MARKDOWN_CAPTION}`, root).val('');
        $(`.${constant.Gallery.Key.SHOW_GUIDE}`, root).prop('checked', true);
        $(`.${constant.Gallery.Key.SHOW_PAGE_NUM}`, root).prop('checked', false);
        $(`.${constant.Gallery.Key.SHOW_CHAPTER_NUM}`, root).prop('checked', false);
        _removeImage.call(this);
        upload.removeAllUploadSelectTag(root);
        return;
      }

      const _cbk = function(dataList) {
        // 画面に設定
        $(`.${constant.Gallery.Key.TITLE}`, root).val(dataList[constant.Gallery.Key.TITLE]);
        $(`.${constant.Gallery.Key.MARKDOWN_CAPTION}`, root).val(dataList[constant.Gallery.Key.CAPTION]);
        $(`.${constant.Gallery.Key.SHOW_GUIDE}`, root).prop('checked', dataList[constant.Gallery.Key.SHOW_GUIDE]);
        $(`.${constant.Gallery.Key.SHOW_PAGE_NUM}`, root).prop('checked', dataList[constant.Gallery.Key.SHOW_PAGE_NUM]);
        $(`.${constant.Gallery.Key.SHOW_CHAPTER_NUM}`, root).prop('checked', dataList[constant.Gallery.Key.SHOW_CHAPTER_NUM]);
        if(dataList[constant.Gallery.Key.THUMBNAIL] !== null) {
          // サムネイルを設定
          _getThumbnailBlob.call(this, dataList[constant.Gallery.Key.THUMBNAIL]);
        } else {
          // サムネイル無し
          _removeImage.call(this);
        }
        if(dataList[constant.Gallery.Key.TAG_ID] !== null) {
          // タグ設定
          const names = dataList[constant.Gallery.Key.TAG_NAME].split(',');
          for(let name of Array.from(names)) {
            upload.addUploadSelectTag(root, name);
          }
        }
        // タグクリックイベント設定
        return upload.prepareUploadTagEvent(root);
      };

      if((window.galleryDataList === null)) {
        window.galleryDataList = {};
      }
      if(window.galleryDataList[token] !== null) {
        return _cbk.call(this, window.galleryDataList[token]);
      } else {
        Common.showModalFlashMessage('Loading...');
        const data = {};
        data[constant.Gallery.Key.GALLERY_ACCESS_TOKEN] = token;
        return $.ajax(
          {
            url: "/gallery/get_info",
            type: "GET",
            dataType: "json",
            data,
            success(data) {
              if(data !== null) {
                window.galleryDataList[token] = data;
                _cbk.call(this, window.galleryDataList[token]);
              }
              return Common.hideModalView();
            },
            error(data) {
              return console.log('/gallery/get_info ajax error');
            }
          }
        );
      }
    });
    // タグクリックイベント設定
    upload.prepareUploadTagEvent(root);
    // Inputイベント
    $('.select_tag_input', root).off('keypress').on('keypress', function(e) {
      if(e.keyCode === constant.KeyboardKeyCode.ENTER) {
        // Enterキーを押した場合、選択タグに追加
        upload.addUploadSelectTag(root, $(this).val());
        return $(this).val('');
      }
    });
    // Updateイベント
    return root.find('.upload_button').off('click').on('click', function() {
      upload.upload(root);
      return false;
    });
  }
}
