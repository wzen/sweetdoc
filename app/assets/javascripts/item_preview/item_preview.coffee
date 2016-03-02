$ ->
  window.isItemPreview = true
  # 初期タイプはWS
  window.isMotionCheck = false

  # ブラウザ対応チェック
  if !Common.checkBlowserEnvironment()
    Common.showModalView(constant.ModalViewType.ENVIRONMENT_NOT_SUPPORT, false)
    alert('This browser is not under support.')
    return

  # 変数初期化
  CommonVar.initVarWhenLoadedView()
  CommonVar.initCommonVar()
  ItemPreviewCommon.createdMainContainerIfNeeded()
  ItemPreviewCommon.initMainContainerAsWorktable()

  $('.coding.item_preview').ready ->
    # コーディングデバッグ
    window.isCodingDebug = true
    # 初期化終了
    window.initDone = true

    count = 0
    timer = setInterval( =>
      if window[constant.ITEM_CODING_TEMP_CLASS_NAME]?
        clearInterval(timer)
        ItemPreviewCommon.initAfterLoadItem()
      count += 1
      if count >= 100
        clearInterval(timer)
    , 50)


  $('.item_gallery.preview').ready ->
    # アイテムギャラリー動作確認
    window.isCodingDebug = false
    # 初期化終了
    window.initDone = true

    itemClassName = $(".#{constant.ITEM_GALLERY_ITEM_CLASSNAME}:first").val()
    count = 0
    timer = setInterval( =>
      if window[itemClassName]?
        clearInterval(timer)
        ItemPreviewCommon.initAfterLoadItem()
      count += 1
      if count >= 100
        clearInterval(timer)
    , 50)
