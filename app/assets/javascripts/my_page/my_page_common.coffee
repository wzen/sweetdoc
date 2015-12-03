class MyPageCommon
  # 中央コンテンツのサイズ調整
  @adjustContentsSize = ->
    height = $('.tabview_wrapper:first').height() - $('.nav-tabs:first').height()
    $('#myTabContent').height(height)
    $('#user_wrapper').height(height - 2)

  # リサイズイベント設定
  @initResize = ->
    $(window).resize( =>
      @adjustContentsSize()
    )
