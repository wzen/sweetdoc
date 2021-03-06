class UploadCommon

  # ギャラリーアップロードビュー表示前処理
  @initEvent = (upload) ->
    root = $('#upload_wrapper')

    _setImage = (path)->
      FR = new FileReader()
      FR.onload = (e) ->
        src = e.target.result
        $('.capture', root).attr( "src", src).show()
        $('.default_thumbnail', root).hide()
        $('.error_message', root).hide()
        $('.file_select_delete', root).show()
        image = new Image()
        image.src = src
        image.onload = ->
          imageData = src.split('base64,')[1]
          contentType = src.split(';base64')[0].replace('data:', '')
          $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_WIDTH}']", root).val(image.width)
          $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT}']", root).val(image.height)
      FR.readAsDataURL(path)

    _readImage = (input) ->
      if input.files && input.files[0]
        _setImage.call(@, input.files[0])
      else
        _removeImage.call(@)
    _removeImage = ->
      # 画像をデフォルトに戻す
      selectFile = $(".#{constant.PreloadItemImage.Key.SELECT_FILE}", root).val()
      if selectFile? && selectFile.length > 0
        $(".#{constant.PreloadItemImage.Key.SELECT_FILE}", root).val('').trigger('change')
      $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_WIDTH}']", root).val('')
      $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT}']", root).val('')
      $('.file_select_delete', root).hide()
      $('.capture', root).attr("src", "").hide()
      $('.error_message', root).hide()
      $('.default_thumbnail', root).show()

    _getThumbnailBlob = (src) ->
      xhr = new XMLHttpRequest()
      xhr.open( "GET", src, true )
      xhr.responseType = "arraybuffer"
      xhr.onload = (e) ->
        arrayBufferView = new Uint8Array( this.response );
        blob = new Blob( [ arrayBufferView ], { type: "image/jpeg" } );
        _setImage(blob)
      xhr.send();

    $('#remove_image').click( ->
      _removeImage.call(@)
    )
    # サムネイル選択時に画像変更
    $(".#{constant.PreloadItemImage.Key.SELECT_FILE}", root).off('change').on('change', (e) =>
      window.uploadContents = upload
      f = $(".#{constant.PreloadItemImage.Key.SELECT_FILE}", root).val()
      if f? && f.length > 0
        size = e.target.files[0].size
        if size <= constant.THUMBNAIL_FILESIZE_MAX_KB * 1000
          _readImage.call(@, e.target)
        else
          $('.error_message', root).text(I18n.t('upload_confirm.thumbnail_size_error', size: constant.THUMBNAIL_FILESIZE_MAX_KB))
          $('.error_message', root).show()
      else
        _removeImage.call(@)
    )
    # サムネイル削除ボタン
    $(".#{constant.PreloadItemImage.Key.SELECT_FILE_DELETE}", root).off('click').on('click', (e) =>
      _removeImage.call(@)
    )
    # 上書きリスト選択イベント
    $(".#{constant.Gallery.Key.OVERWRITE_CONTENTS_SELECT}", root).off('change').on('change', (e) =>
      token = $(e.target).val()
      if token.length == 0
        # デフォルト値の選択は全て空に
        $(".#{constant.Gallery.Key.TITLE}", root).val('')
        $(".#{constant.Gallery.Key.MARKDOWN_CAPTION}", root).val('')
        $(".#{constant.Gallery.Key.SHOW_GUIDE}",root).prop('checked', true)
        $(".#{constant.Gallery.Key.SHOW_PAGE_NUM}",root).prop('checked', false)
        $(".#{constant.Gallery.Key.SHOW_CHAPTER_NUM}",root).prop('checked', false)
        _removeImage.call(@)
        upload.removeAllUploadSelectTag(root)
        return

      _cbk = (dataList) ->
        # 画面に設定
        $(".#{constant.Gallery.Key.TITLE}", root).val(dataList[constant.Gallery.Key.TITLE])
        $(".#{constant.Gallery.Key.MARKDOWN_CAPTION}", root).val(dataList[constant.Gallery.Key.CAPTION])
        $(".#{constant.Gallery.Key.SHOW_GUIDE}",root).prop('checked', dataList[constant.Gallery.Key.SHOW_GUIDE])
        $(".#{constant.Gallery.Key.SHOW_PAGE_NUM}",root).prop('checked', dataList[constant.Gallery.Key.SHOW_PAGE_NUM])
        $(".#{constant.Gallery.Key.SHOW_CHAPTER_NUM}",root).prop('checked', dataList[constant.Gallery.Key.SHOW_CHAPTER_NUM])
        if dataList[constant.Gallery.Key.THUMBNAIL]?
          # サムネイルを設定
          _getThumbnailBlob.call(@, dataList[constant.Gallery.Key.THUMBNAIL])
        else
          # サムネイル無し
          _removeImage.call(@)
        if dataList[constant.Gallery.Key.TAG_ID]?
          # タグ設定
          names = dataList[constant.Gallery.Key.TAG_NAME].split(',')
          for name in names
            upload.addUploadSelectTag(root, name)
        # タグクリックイベント設定
        upload.prepareUploadTagEvent(root)

      if !window.galleryDataList?
        window.galleryDataList = {}
      if window.galleryDataList[token]?
        _cbk.call(@, window.galleryDataList[token])
      else
        Common.showModalFlashMessage('Loading...')
        data = {}
        data[constant.Gallery.Key.GALLERY_ACCESS_TOKEN] = token
        $.ajax(
          {
            url: "/gallery/get_info"
            type: "GET"
            dataType: "json"
            data: data
            success: (data) ->
              if data?
                window.galleryDataList[token] = data
                _cbk.call(@, window.galleryDataList[token])
              Common.hideModalView()
            error: (data)->
              console.log('/gallery/get_info ajax error')
          }
        )
    )
    # タグクリックイベント設定
    upload.prepareUploadTagEvent(root)
    # Inputイベント
    $('.select_tag_input', root).off('keypress').on('keypress', (e) ->
      if e.keyCode == constant.KeyboardKeyCode.ENTER
        # Enterキーを押した場合、選択タグに追加
        upload.addUploadSelectTag(root, $(@).val())
        $(@).val('')
    )
    # Updateイベント
    root.find('.upload_button').off('click').on('click', ->
      upload.upload(root)
      return false
    )
