class UploadItem extends UploadBase
  # アップロード
  upload: (root, callback = null) ->
    # 入力値バリデーションチェック
    title = $("input[name='#{Constant.ItemGallery.Key.TITLE}']", root).val()
    if title.length == 0
      return

    # 保存処理
    _saveGallery = ->
      fd = new FormData(document.getElementById('upload_form'))
      tags = $.map($('.select_tag a', root), (n) -> $(n).html())
      if tags?
        fd.append(Constant.ItemGallery.Key.TAGS, tags)
      else
        fd.append(Constant.ItemGallery.Key.TAGS, null)

      $.ajax({
        url: 'item_gallery/save_state'
        data: fd
        processData: false
        contentType: false
        type: 'POST'
        success: (data) ->
          if data.resultSuccess
            # Gallery Detail
            window.location.href = "/gallery/detail/#{data.access_token}"
          else
            console.log('gallery/save_state server error')
            alert(data.message)
        error: (data) ->
          console.log('gallery/save_state ajax error')
          # Error
          alert(data.message)
      })

    # 確認ダイアログ
    if window.confirm(I18n.t('message.dialog.update_gallery'))
      _saveGallery.call(@)
