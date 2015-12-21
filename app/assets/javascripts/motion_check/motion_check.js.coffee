$ ->
  window.isMotionCheck = true
  window.isItemPreview = false
  window.runDebug = true

  $('.motion_check.index').ready ->
    RunCommon.start(true)

  $('.motion_check.new_window').ready ->
    # 作成者情報を表示
    RunFullScreen.showCreatorInfo()
    RunCommon.start(true)
