$ ->
  window.isWorkTable = false
  window.isMotionCheck = false
  #window.initDone = false
  # ブラウザ対応チェック
  if !Common.checkBlowserEnvironment()
    alert('ブラウザ非対応です。')
    return

  # 変数初期化
  CommonVar.initVarWhenLoadedView()
  CommonVar.initCommonVar()

  $('.coding.item_preview').ready ->
    # コーディングデバッグ
    # 初期化終了
    window.initDone = true


  $('.item_gallery.preview').ready ->
    # アイテムギャラリー動作確認
    # 初期化終了
    window.initDone = true