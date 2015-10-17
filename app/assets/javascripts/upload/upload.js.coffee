class Upload

  # ギャラリーアップロードビュー表示前処理
  @initEvent = ->
    root = $('#upload_wrapper')
    # マークアップ入力フォーム初期化
    mark = $('.markItUp', root)
    if mark? && mark.length > 0
      $('.caption_markup', root).markItUpRemove()
    $('.caption_markup', root).markItUp(mySettings)

    # タグクリックイベント設定
    @prepareUploadGalleryTagEvent(root)

    # Inputイベント
    $('.select_tag_input', root).off('keypress')
    $('.select_tag_input', root).on('keypress', (e) ->
      if e.keyCode == Constant.KeyboardKeyCode.ENTER
        # Enterキーを押した場合、選択タグに追加
        Upload.addUploadGallerySelectTag(root, $(@).val())
        $(@).val('')
    )

    # Updateイベント
    $('.upload_button').off('click')
    $('.upload_button').on('click', ->
      Upload.uploadToGallery(root)
    )

  # タグクリックイベント
  @prepareUploadGalleryTagEvent = (root) ->
    tags = $('.popular_tag a, .recommend_tag a', root)
    tags.off('click')
    tags.on('click', ->
      # 選択タグに追加
      Upload.addUploadGallerySelectTag(root, $(@).html())
    )

    # マウスオーバーイベント
    tags.off('mouseenter')
    tags.on('mouseenter', (e) ->
      li = @closest('li')
      $(li).append($("<div class='add_pop pop' style='display:none'><p>Add tag(click)</p></div>"))
      $('.add_pop', li).css({top: $(li).height(), left: $(li).width()})
      $('.add_pop', li).show()
    )
    tags.off('mouseleave')
    tags.on('mouseleave', (e) ->
      ul = @closest('ul')
      $('.add_pop', ul).remove()
    )

  @addUploadGallerySelectTag = (root, tagname) ->
    ul = $('.select_tag ul', root)
    tags = $.map(ul.children(), (n) ->
      return $('a', n).html()
    )

    if tags.length >= Constant.Gallery.TAG_MAX || $.inArray(tagname, tags) >= 0
      return
    ul.append($("<li><a href='#'>#{tagname}</a></li>"))

    # タグ クリックイベント
    $('a', ul).off('click')
    $('a', ul).on('click', (e) ->
      # タグ削除
      @closest('li').remove()
      if $('.select_tag ul li', root).length < Constant.Gallery.TAG_MAX
        $('.select_tag_input', root).show()
    )

    # タグ マウスオーバーイベント
    $('a', ul).off('mouseenter')
    $('a', ul).on('mouseenter', (e) ->
      li = @closest('li')
      $(li).append($("<div class='delete_pop pop' style='display:none'><p>Delete tag(click)</p></div>"))
      $('.delete_pop', li).css({top: $(li).height(), left: $(li).width()})
      $('.delete_pop', li).show()
    )
    $('a', ul).off('mouseleave')
    $('a', ul).on('mouseleave', (e) ->
      $('li .delete_pop', ul).remove()
    )

    if $('.select_tag ul li', root).length >= Constant.Gallery.TAG_MAX
      # タグ数が最大数になった場合, Inputを非表示
      $('.select_tag_input', root).hide()

  # ギャラリーアップロード
  @uploadToGallery = (root, callback = null) ->
    # 入力値バリデーションチェック
    title = $("input[name='#{Constant.Gallery.Key.TITLE}']", root).val()
    if title.length == 0
      return

    # ギャラリー保存処理
    _saveGallery = ->
      fd = new FormData(document.getElementById('upload_form'))
      tags = $('.select_tag a', root).html()
      if tags?
        fd.append(Constant.Gallery.Key.TAGS, $('.select_tag a', root).html())
      else
        fd.append(Constant.Gallery.Key.TAGS, null)

      $.ajax({
        url: 'gallery/save_state'
        data: fd
        processData: false
        contentType: false
        type: 'POST'
        success: (data) ->
          # Gallery Detail
          window.location.href = "/gallery/detail/#{data.access_token}"
        error: (data) ->
          # Error
          alert(data.message)
      })

    # 確認ダイアログ
    if window.confirm(I18n.t('message.dialog.update_gallery'))
      _saveGallery.call(@)

  # 前画面のキャプチャ作成
  @makeCapture = (canvas) ->
    root = $('#upload_wrapper')
    png = canvas.toDataURL('image/png')
    $(".capture", root).attr('src', png)
    $("input[name='#{Constant.Gallery.Key.THUMBNAIL_IMG}']", root).val(png.replace(/^.*,/, ''))
    width = parseInt($(canvas).attr('width'))
    height = parseInt($(canvas).attr('height'))
    if width > height
      $(".capture", root).css({width: '100%', height: 'auto'})
    else
      $(".capture", root).css({width: 'auto', height: '100%'})

$ ->
  Upload.initEvent()

  if window.opener?
    setTimeout( ->
      # オーバーレイ前の画面をキャプチャ
      body = $(window.opener.document.getElementById('project_contents'))
      html2canvas(body, {
        onrendered: (canvas) ->
          Upload.makeCapture(canvas)
      })
    )

