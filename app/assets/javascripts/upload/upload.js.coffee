class Upload

  @init = ->



  # ギャラリーアップロード
  @showUploadPage = (modalEmt, callback = null) ->
    # 入力値バリデーションチェック
    title = $('.title:first', modalEmt).val()
    if title.length == 0
      return

    # ギャラリー保存処理
    _saveGallery = ->

      _toBlob = (canvas) ->
        base64 = canvas.toDataURL('image/png')
        # Base64からバイナリへ変換
        bin = atob(base64.replace(/^.*,/, ''))
        buffer = new Uint8Array(bin.length)
        for i in [0..(bin.length - 1)]
          buffer[i] = bin.charCodeAt(i)
        # Blobを作成
        blob = new Blob([buffer.buffer], {
          type: 'text/plain'
        })
        return blob

      _callback = (outputBlob = null) ->
        fd = new FormData()
        fd.append(Constant.Gallery.Key.PROJECT_ID, PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID))
        fd.append(Constant.Gallery.Key.TITLE, title)
        fd.append(Constant.Gallery.Key.CAPTION, $('.caption_markup:first', modalEmt).val())
        fd.append(Constant.Gallery.Key.THUMBNAIL_IMG, outputBlob);
        tags = $('.select_tag a', modalEmt).html()
        if tags?
          fd.append(Constant.Gallery.Key.TAGS, $('.select_tag a', modalEmt).html())
        else
          fd.append(Constant.Gallery.Key.TAGS, null)
        $.ajax(
          {
            url: "/gallery/save_state"
            type: "POST"
            data: fd
            processData: false
            contentType: false
            success: (data)->
              # 正常完了処理

              # コールバック
              if callback?
                callback()

                # 詳細画面に遷移

            error: (data) ->
          }
        )

      if window.captureCanvas?
        # Blob作成
        ua = window.navigator.userAgent.toLowerCase()
        if ua.indexOf('firefox') >= 0
          window.captureCanvas.toBlob(_callback)
        else
          blob = _toBlob(window.captureCanvas)
          _callback.call(@, blob)
      else
        _callback.call(@)

    # 確認ダイアログ
    if window.confirm(I18n.t('message.dialog.update_gallery'))
      _saveGallery.call(@)

$ ->
  Upload.init()