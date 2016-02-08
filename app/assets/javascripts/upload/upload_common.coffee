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
    $('.select_tag_input', root).off('keypress')
    $('.select_tag_input', root).on('keypress', (e) ->
      if e.keyCode == Constant.KeyboardKeyCode.ENTER
        # Enterキーを押した場合、選択タグに追加
        upload.addUploadSelectTag(root, $(@).val())
        $(@).val('')
    )

    # Updateイベント
    $('.upload_button').off('click').on('click', ->
      Common.showModalFlashMessage('Updating...')
      upload.upload(root)
      return false
    )

  # 前画面のキャプチャ作成
  @makeCapture = (canvas) ->
    root = $('#upload_wrapper')
    png = canvas.toDataURL('image/png')
    $(".capture", root).attr('src', png)
    $("input[name='#{Constant.Gallery.Key.THUMBNAIL_IMG}']", root).val(png.replace(/^.*,/, ''))
    $("input[name='#{Constant.Gallery.Key.THUMBNAIL_IMG_CONTENTSTYPE}']", root).val('image/png')
    width = parseInt($(canvas).attr('width'))
    height = parseInt($(canvas).attr('height'))
    $("input[name='#{Constant.Gallery.Key.THUMBNAIL_IMG_WIDTH}']", root).val(width)
    $("input[name='#{Constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT}']", root).val(height)
    if width > height
      $(".capture", root).css({width: '100%', height: 'auto'})
    else
      $(".capture", root).css({width: 'auto', height: '100%'})