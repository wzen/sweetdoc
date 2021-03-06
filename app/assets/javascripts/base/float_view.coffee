class FloatView

  @showTimer = null

  class @Type
    @PREVIEW = 'preview'
    @DISPLAY_POSITION = 'display_position'
    @INFO = 'info'
    @WARN = 'warn'
    @ERROR = 'error'
    @APPLY = 'apply'
    @POINTING_CLICK =  'pointing_click'
    @POINTING_DRAG =  'pointing_drag'
    @SCALE = 'scale'
    @REWIND_CHAPTER = 'rewind_chapter'
    @REWIND_ALL_CHAPTER = 'rewind_all_chapter'
    @NEXT_PAGE = 'next_page'
    @FINISH = 'finish'

  @show = (message, type, showSeconds = -1) ->
    if window.isWorkTable && !window.initDone
      # 初期化が終了していない場合は無視
      return

    main = $('#main')
    root = $(".float_view.#{type}:first", main)
    if root.length == 0
      $(".float_view", main).remove()
      $('.float_view_temp', main).clone(true).attr('class', 'float_view').appendTo(main)
      root = $('.float_view:first', main)
      root.removeClass((index, className) ->
        return className != 'float_view'
      ).addClass(type)
      $('.message', root).removeClass((index, className) ->
        return className != 'message'
      ).addClass(type)
      root.fadeIn('fast')
    else
      root.show()
    $('.message', root).html(message)

    if showSeconds >= 0
      # 非表示タイマーセット
      if @showTimer?
        clearTimeout(@showTimer)
        @showTimer = null
      @showTimer = setTimeout( =>
        @hide()
        clearTimeout(@showTimer)
        @showTimer = null
      , showSeconds * 1000)

  @hide = ->
    $(".float_view:not('.fixed')").fadeOut('fast')

  @showWithCloseButton = (message, type, closeFunc = null, withDisableOperation = false) ->
    if window.isWorkTable && !window.initDone
      return

    main = $('#main')
    root = $(".float_view.fixed.#{type}:first", main)
    if withDisableOperation
      # オーバーレイを被せる
      if $('#modal-overlay').length == 0
        $("body").append( '<div id="modal-overlay"></div>' )
      $("#modal-overlay").off('click').on('click', (e) =>
        e.preventDefault()
        e.stopPropagation()
        return false
      ).show()

    if root.length > 0
      # 既に表示されている場合はshow
      root.show()
      return

    $(".float_view", main).remove()
    $('.float_view_fixed_temp', main).clone(true).attr('class', 'float_view fixed').appendTo(main)
    root = $('.float_view.fixed:first', main)
    root.find('.close_button').off('click').on('click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      if closeFunc?
        closeFunc()
      FloatView.hideWithCloseButtonView()
    )
    root.removeClass((index, className) ->
      return className != 'float_view' && className != 'fixed'
    ).addClass(type)
    $('.message', root).removeClass((index, className) ->
      return className != 'message'
    ).addClass(type)
    root.show()

    $('.message', root).html(message)

  @hideWithCloseButtonView = ->
    $(".float_view.fixed").fadeOut('fast')
    $('#modal-overlay').remove()
    # コントローラも消去
    @hidePointingController()

  @showPointingController = (pointintObj) ->
    if window.isWorkTable && !window.initDone
      return
    main = $('#main')
    root = $(".float_view.fixed:visible", main)
    if root.length == 0
      # Fixedビューが表示されていない場合は無視
      return

    root = $(".float_view.pointing_controller:first", main)
    if root.length == 0
      # ビュー作成
      $('.float_view_pointing_controller_temp', main).clone(true).attr('class', 'float_view pointing_controller').appendTo(main)
      root = $('.float_view.pointing_controller:first', main)
    # イベント設定
    root.find('.clear_button').off('click').on('click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      # 描画を削除
      pointintObj.clearDraw()
      # コントローラー非表示
      FloatView.hidePointingController()
    )
    root.find('.apply_button').off('click').on('click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      # 描画を適用
      pointintObj.applyDraw()
      # 画面上のポイントアイテムを削除
      pointintObj.getJQueryElement().remove()
      # ビュー非表示
      FloatView.hideWithCloseButtonView()
    )
    root.show()

  @hidePointingController = ->
    $(".float_view.pointing_controller").fadeOut('fast')

  @scrollMessage = (top, left) ->
    if window.isWorkTable && !window.initDone
      return ''
    return "X: #{left}  Y:#{top}"

  @displayPositionMessage = ->
    return 'Preview'
