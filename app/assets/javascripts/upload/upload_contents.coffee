class UploadContents extends UploadBase
  # アップロード
  upload: (root, callback = null) ->
    # 入力値バリデーションチェック
    title = $("input[name='#{constant.Gallery.Key.TITLE}']", root).val()
    if title.length == 0
      FloatView.show('Please input title', FloatView.Type.ERROR, 3.0)
      return

    # 保存処理
    _saveGallery = ->
      Common.showModalFlashMessage('Updating...')
      fd = new FormData(document.getElementById('upload_form'))
      tags = $.map($('.select_tag a', root), (n) -> $(n).html())
      if tags?
        fd.append(constant.Gallery.Key.TAGS, tags)
      else
        fd.append(constant.Gallery.Key.TAGS, null)

      $.ajax({
        url: 'gallery/save_state'
        data: fd
        processData: false
        contentType: false
        type: 'POST'
        success: (data) ->
          if data.resultSuccess
            # Gallery Detail
            window.location.href = "/gallery/detail/#{data.access_token}"
          else
            FloatView.show('UploadError', FloatView.Type.ERROR, 3.0)
            Common.hideModalView(true)
            console.log('gallery/save_state server error')
            Common.ajaxError(data)
        error: (data) ->
          console.log('gallery/save_state ajax error')
          Common.ajaxError(data)
      })

    # 確認ダイアログ
    if window.confirm(I18n.t('message.dialog.update_gallery'))
      _saveGallery.call(@)
