$ ->
  # リサイズイベント
  MyPageCommon.initResize()
  # 中央サイズ調整
  MyPageCommon.adjustContentsSize()
  # タブビューの中身は高さが調節された後に表示する
  $('#myTabContent .border > *').css({opacity: 1})

  $('.user_icon .icon_wrapper, .user_icon .icon_change_cover').hover((e) =>
    e.preventDefault()
    $('.user_icon .icon_change_cover').stop(true, false).animate({opacity: 1}, 'fast')
  , (e) =>
    e.preventDefault()
    $('.user_icon .icon_change_cover').stop(true, false).animate({opacity: 0}, 'fast')
  )