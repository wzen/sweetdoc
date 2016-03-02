class UploadCommon

  # ギャラリーアップロードビュー表示前処理
  @initEvent = (upload) ->
    root = $('#upload_wrapper')
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
    $('.upload_button').off('click').on('click', ->
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