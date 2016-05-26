$ ->
  # リサイズイベント
  MyPageCommon.initResize()
  # 中央サイズ調整
  MyPageCommon.adjustContentsSize()
  # タブビューの中身は高さが調節された後に表示する
  $('#myTabContent .border > *').css({opacity: 1})
  # ユーザアイコンイベント
  MyPageCommon.userIconEvent()
  