class MyPageCommon
  # 中央コンテンツのサイズ調整
  @adjustContentsSize = ->
    height = $('.tabview_wrapper:first').height() - $('.nav-tabs:first').height()
    $('#myTabContent').height(height)
    #$('#user_wrapper').height(height - 2)

  # リサイズイベント設定
  @initResize = ->
    $(window).resize( =>
      @adjustContentsSize()
    )

  @userIconEvent = ->
    $('.user_icon .icon_wrapper, .user_icon .icon_change_cover').hover((e) =>
      e.preventDefault()
      $('.user_icon .icon_change_cover').stop(true, false).animate({opacity: 1}, 'fast')
    , (e) =>
      e.preventDefault()
      $('.user_icon .icon_change_cover').stop(true, false).animate({opacity: 0}, 'fast')
    )
    $('.user_icon .icon_change_cover').off('click').on('click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      $('#thumbnail_upload_form input[type="file"]').click()
      $('#thumbnail_upload_form input[type="file"]').off('change').on('change', (e) =>
        $('#thumbnail_upload_form').submit()
        return false
      )
    )
    $('#thumbnail_upload_form').on('ajax:complete', (event, data, status) =>
      if data.responseJSON?
        data = data.responseJSON
      else
        data = JSON.parse(data.responseText)
      if data.result_success
        $('img.user_thumbnail').attr('src', data.image_url)
        $('#sidebar_wrapper .user_wrapper img').attr('src', data.image_url)
    )

