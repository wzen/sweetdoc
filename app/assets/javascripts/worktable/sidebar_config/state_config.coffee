class StateConfig
  if gon?
    # 定数
    constant = gon.const
    @ROOT_ID_NAME = constant.StateConfig.ROOT_ID_NAME
    @ITEM_TEMP_CLASS_NAME = constant.StateConfig.ITEM_TEMP_CLASS_NAME

  # コンフィグ初期化
  @initConfig = ->
    rootEmt = $("##{@ROOT_ID_NAME}")

    # 画面座標
    position = PageValue.getGeneralPageValue(PageValue.Key.displayPosition())
    $('.display_position_x', rootEmt).val(parseInt(position.left))
    $('.display_position_y', rootEmt).val(parseInt(position.top))
    leftMin = -window.scrollInside.width() * 0.5
    leftMax = window.scrollInside.width() * 0.5
    topMin = -window.scrollInside.height() * 0.5
    topMax = window.scrollInside.height() * 0.5
    # Inputイベント
    $('.display_position_x, .display_position_y', rootEmt).off('keypress focusout')
    $('.display_position_x, .display_position_y', rootEmt).on('keypress focusout', (e) ->
      if (e.type == 'keypress' && e.keyCode == Constant.KeyboardKeyCode.ENTER) || e.type == 'focusout'
        # スクロール位置変更
        left = $('.display_position_x', rootEmt).val()
        top = $('.display_position_y', rootEmt).val()
        if left < leftMin
          left = leftMin
        else if left > leftMax
          left = leftMax
        if top < topMin
          top = topMin
        else if top > topMax
          top = topMax
        $('.display_position_x', rootEmt).val(left)
        $('.display_position_y', rootEmt).val(top)
        PageValue.setGeneralPageValue(PageValue.Key.displayPosition(), {top: top, left: left})
        Common.updateScrollContentsFromPagevalue()
        LocalStorage.saveGeneralPageValue()
    )

    # Zoom (1〜5)
    zoom = PageValue.getGeneralPageValue(PageValue.Key.zoom())
    $('.zoom', rootEmt).val(zoom)
    $('.zoom', rootEmt).off('keypress focusout')
    $('.zoom', rootEmt).on('keypress focusout', (e) ->
      if (e.type == 'keypress' && e.keyCode == Constant.KeyboardKeyCode.ENTER) || e.type == 'focusout'
        # Zoom実行
        zoom = $('.zoom', rootEmt).val()
        if zoom < 1
          zoom = 1
        else if zoom > 5
          zoom = 5

        $('.zoom', rootEmt).val(zoom)
        PageValue.setGeneralPageValue(PageValue.Key.zoom(), zoom)
        window.mainWrapper.css('transform', "scale(#{zoom}, #{zoom})")
        LocalStorage.saveGeneralPageValue()
    )

    # limit
    $('.display_position_left_limit', rootEmt).html("(#{leftMin} 〜 #{leftMax})")
    $('.display_position_top_limit', rootEmt).html("(#{topMin} 〜 #{topMax})")
    $('.display_position_zoom_limit', rootEmt).html("(1 〜 5)")
    # 作成アイテム一覧
    createdItemList = $('.created_item_list', rootEmt)
    createdItemList.children().remove()
    items = PageValue.getCreatedItems()
    if Object.keys(items).length > 0
      createdItemList.closest('.configBox').show()
      for k, v of items
        temp = $(".#{@ITEM_TEMP_CLASS_NAME}", rootEmt).children(':first').clone(true)
        temp.find('.item_obj_id').val(k)
        temp.find('.name').html(v.value.name)
        if !$("##{k}").is(':visible')
          temp.find('.item_visible').hide()
          temp.find('.item_invisible').show()
        createdItemList.append(temp)

      $('.focus_enabled > a').off('click')
      $('.focus_enabled > a').on('click', (e) ->
        objId = $(@).closest('.wrapper').find('.item_obj_id').val()
        # アイテムにフォーカス
        Common.focusToTarget($("##{objId}"), ->
          rootEmt = $("##{StateConfig.ROOT_ID_NAME}")
          position = PageValue.getGeneralPageValue(PageValue.Key.displayPosition())
          $('.display_position_x', rootEmt).val(parseInt(position.left))
          $('.display_position_y', rootEmt).val(parseInt(position.top))
        )
      )

      $('a.item_edit', rootEmt).off('click')
      $('a.item_edit', rootEmt).on('click', (e) ->
        e.preventDefault()
        objId = $(@).closest('.wrapper').find('.item_obj_id').val()
        Sidebar.openItemEditConfig($("##{objId}"))
      )

      $('.item_visible > a, .item_invisible > a', rootEmt).off('click')
      $('.item_visible > a, .item_invisible > a', rootEmt).on('click', (e) ->
        e.preventDefault()
        StateConfig.clickToggleVisible(@)
      )

  @clickToggleVisible = (target) ->
    objId = $(target).closest('.wrapper').find('.item_obj_id').val()
    emt = $("##{objId}")
    emt.toggle()
    parent = $(target.closest('.buttons'))
    if emt.is(':visible')
      parent.find('.item_visible').show()
      parent.find('.item_invisible').hide()
      parent.find('.focus_enabled').show()
      parent.find('.focus_disabled').hide()
    else
      parent.find('.item_visible').hide()
      parent.find('.item_invisible').show()
      parent.find('.focus_enabled').hide()
      parent.find('.focus_disabled').show()
