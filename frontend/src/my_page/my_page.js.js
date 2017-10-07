/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
$(function() {
  // リサイズイベント
  MyPageCommon.initResize();
  // 中央サイズ調整
  MyPageCommon.adjustContentsSize();
  // タブビューの中身は高さが調節された後に表示する
  $('#myTabContent .border > *').css({opacity: 1});
  // ユーザアイコンイベント
  return MyPageCommon.userIconEvent();
});
  