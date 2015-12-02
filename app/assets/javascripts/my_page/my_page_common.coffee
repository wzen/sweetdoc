class MyPageCommon
  # 中央コンテンツのサイズ調整
  @adjustContentsSize = ->
    $('#myTabContent').height($('.tabview_wrapper:first').height() - $('.nav-tabs:first').height())

  # リサイズイベント設定
  @initResize = ->
    $(window).resize( =>
      @adjustContentsSize()
    )
