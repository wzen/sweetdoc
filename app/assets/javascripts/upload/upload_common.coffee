class UploadCommon

  # ギャラリーアップロードビュー表示前処理
  @initEvent = (upload) ->
    root = $('#upload_wrapper')

    _setThumbnailChangeEvent = ->
      # サムネイル選択時にアップロード
      $(".#{constant.PreloadItemImage.Key.SELECT_FILE}", root).off('change').on('change', =>
        f = $(".#{constant.PreloadItemImage.Key.SELECT_FILE}", root).val().split('.')
        if f? && f.length > 0
          window.uploadFileExt = f[f.length - 1]
          if window.uploadFileExt == 'gif' || window.uploadFileExt == 'png' || window.uploadFileExt = 'jpg'
            $('.thumbnail_upload_form', root).submit()
      )
    _setThumbnailChangeEvent.call(@)
    # サムネイルアップロード
    $('.thumbnail_upload_form', root).off().on('ajax:complete', (e, data, status, error) =>
      d = JSON.parse(data.responseText)
      if d?
        if d.resultSuccess
          ext = window.uploadFileExt
          if ext?
            if ext == 'gif'
              ext = 'png'
            else if ext == 'jpg'
              ext = 'jpeg'
            $('.error_message', root).hide()
            $('.capture', root).attr('src', "data:image/#{ext};base64,#{d.image_url}")
        else
          $('.error_message', root).text(d.message)
          $('.error_message', root).show()
      # アップロード後に設定したイベントが消えるため、ここで再設定
      _setThumbnailChangeEvent.call(@)
    )

    # マークアップ入力フォーム初期化
    mark = $('.markItUp', root)
    if mark? && mark.length > 0
      $('.caption_markup', root).markItUpRemove()
    $('.caption_markup', root).markItUp(mySettings)

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
    $('.upload_button', root).off('click').on('click', ->
      upload.upload(root)
      return false
    )

  # 前画面のキャプチャ作成
  @makeCapture = (canvas) ->
    root = $('#upload_wrapper')
    try
      png = canvas.toDataURL('image/png')
      $(".capture", root).attr('src', png)
      $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG}']", root).val(png.replace(/^.*,/, ''))
    catch
      $(".capture", root).attr('src', '')
    $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_CONTENTSTYPE}']", root).val('image/png')
    width = parseInt($(canvas).attr('width'))
    height = parseInt($(canvas).attr('height'))
    $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_WIDTH}']", root).val(width)
    $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT}']", root).val(height)
    if width > height
      $(".capture", root).css({width: '100%', height: 'auto'})
    else
      $(".capture", root).css({width: 'auto', height: '100%'})