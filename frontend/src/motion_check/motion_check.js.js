/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
$(function() {
  window.isMotionCheck = true;
  window.isItemPreview = false;
  window.runDebug = window.debug;

  $('.motion_check.index').ready(() => RunCommon.start(true));

  return $('.motion_check.new_window').ready(function() {
    // 作成者情報を表示
    RunFullScreen.showCreatorInfo();
    return RunCommon.start(true);
  });
});
