$ ->
  window.isItemPreview = true
  # 初期タイプはWS
  window.isWorkTable = true
  window.isMotionCheck = false
  #window.initDone = false
  # ブラウザ対応チェック
  if !Common.checkBlowserEnvironment()
    alert('ブラウザ非対応です。')
    return

  # 変数初期化
  CommonVar.initVarWhenLoadedView()
  CommonVar.initCommonVar()
  ItemPreviewCommon.initMainContainerAsWorktable()

  $('.coding.item_preview').ready ->
    # コーディングデバッグ
    # 初期化終了
    window.initDone = true

    count = 0
    timer = setInterval( =>
      if ItemPreviewTemp?
        window.selectItemMenu = ItemPreviewTemp.ITEM_ID
        WorktableCommon.changeMode(Constant.Mode.DRAW)
        clearInterval(timer)
      count += 1
      if count >= 100
        clearInterval(timer)
    , 50)

  $('.item_gallery.preview').ready ->
    # アイテムギャラリー動作確認
    # 初期化終了
    window.initDone = true