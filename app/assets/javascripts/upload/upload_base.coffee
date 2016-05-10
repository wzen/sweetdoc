class UploadBase
  # タグクリックイベント
  prepareUploadTagEvent: (root) ->
    tags = $('.popular_tag a, .recommend_tag a', root)
    tags.off('click').on('click', (e) =>
      # 選択タグに追加
      @addUploadSelectTag(root, $(e.target).html())
    )

    # マウスオーバーイベント
    tags.off('mouseenter').on('mouseenter', (e) =>
      li = $(e.target).closest('li')
      $(li).append($("<div class='add_pop pop' style='display:none'><p>#{I18n.t('upload_confirm.tag_add')}</p></div>"))
      $('.add_pop', li).css({top: $(li).height(), left: $(li).width()})
      $('.add_pop', li).show()
    )
    tags.off('mouseleave').on('mouseleave', (e) =>
      ul = $(e.target).closest('ul')
      $('.add_pop', ul).remove()
    )

  addUploadSelectTag: (root, tagname) ->
    ul = $('.select_tag ul', root)
    tags = $.map(ul.children(), (n) ->
      return $('a', n).html()
    )

    if tags.length >= constant.Gallery.TAG_MAX || $.inArray(tagname, tags) >= 0
      return
    ul.append($("<li><a href='#'>#{tagname}</a></li>"))

    # タグ クリックイベント
    $('a', ul).off('click')
    $('a', ul).on('click', (e) ->
      # タグ削除
      @closest('li').remove()
      if $('.select_tag ul li', root).length < constant.Gallery.TAG_MAX
        $('.select_tag_input', root).show()
    )

    # タグ マウスオーバーイベント
    $('a', ul).off('mouseenter')
    $('a', ul).on('mouseenter', (e) ->
      li = @closest('li')
      $(li).append($("<div class='delete_pop pop' style='display:none'><p>#{I18n.t('upload_confirm.tag_remove')}</p></div>"))
      $('.delete_pop', li).css({top: $(li).height(), left: $(li).width()})
      $('.delete_pop', li).show()
    )
    $('a', ul).off('mouseleave')
    $('a', ul).on('mouseleave', (e) ->
      $('li .delete_pop', ul).remove()
    )

    if $('.select_tag ul li', root).length >= constant.Gallery.TAG_MAX
      # タグ数が最大数になった場合, Inputを非表示
      $('.select_tag_input', root).hide()

  # アップロード
  # @abstract
  upload: (root, callback = null) ->
