class UploadCommon

  # ギャラリーアップロードビュー表示前処理
  @initEvent = (upload) ->
    root = $('#upload_wrapper')

    readImage = (input) ->
      if input.files && input.files[0]
        FR = new FileReader()
        FR.onload = (e) ->
          $('.capture', root).attr( "src", e.target.result).show()
          $('.default_thumbnail', root).hide()
          $('.file_select_delete', root).show()
          image = new Image()
          image.src = e.target.result
          image.onload = ->
            imageData = e.target.result.split('base64,')[1]
            contentType = e.target.result.split(';base64')[0].replace('data:', '')
            $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG}']", root).val(imageData.replace(/^.*,/, ''))
            $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_CONTENTSTYPE}']", root).val(contentType)
            $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_WIDTH}']", root).val(image.width)
            $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT}']", root).val(image.height)
        FR.readAsDataURL(input.files[0])
      else
        removeImage.call(@)
    removeImage = ->
      # 画像をデフォルトに戻す
      $('.capture', root).attr("src", "").hide()
      $('.default_thumbnail', root).show()
      $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG}']", root).val('')
    $('#remove_image').click( ->
      removeImage.call(@)
    )
    # サムネイル選択時にアップロード
    $(".#{constant.PreloadItemImage.Key.SELECT_FILE}", root).off('change').on('change', (e) =>
      window.uploadContents = upload
      f = $(".#{constant.PreloadItemImage.Key.SELECT_FILE}", root).val()
      if f? && f.length > 0
        #Common.showModalFlashMessage('Thumbnail changing')
        #$('.thumbnail_upload_form', root).submit()
        readImage.call(@, e.target)
      else
        removeImage.call(@)
    )
    # サムネイル削除ボタン
    $(".#{constant.PreloadItemImage.Key.SELECT_FILE_DELETE}", root).off('click').on('click', (e) =>
      $(".#{constant.PreloadItemImage.Key.SELECT_FILE}", root).val('').trigger('change')
      $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG}']", root).val('')
      $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_CONTENTSTYPE}']", root).val('')
      $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_WIDTH}']", root).val('')
      $("input[name='#{constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT}']", root).val('')
      $('.file_select_delete', root).hide()
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
    root.next('.button_wrapper').find('.upload_button').off('click').on('click', ->
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