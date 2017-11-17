import RunCommon from '../run/common/run_common';
import RunFullScreen from '../run/common/run_fullscreen';

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
