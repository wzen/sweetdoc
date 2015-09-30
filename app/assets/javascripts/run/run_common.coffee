class RunCommon
  if gon?
    # 定数
    constant = gon.const
    # @property [String] RUN_CSS CSSスタイルRoot
    @RUN_CSS = constant.ElementAttribute.RUN_CSS

  # 画面初期化
  @initView = ->
    # Canvasサイズ設定
    $(window.drawingCanvas).attr('width', window.canvasWrapper.width())
    $(window.drawingCanvas).attr('height', window.canvasWrapper.height())
    # 暫定でスクロールを上に持ってくる
    scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on)

    # スクロールビューの大きさ
    scrollInside.width(window.scrollViewSize)
    scrollInside.height(window.scrollViewSize)
    scrollInsideCover.width(window.scrollViewSize)
    scrollInsideCover.height(window.scrollViewSize)
    scrollHandle.width(window.scrollViewSize)
    scrollHandle.height(window.scrollViewSize)

    # スクロール位置初期化
    scrollContents.scrollLeft(scrollInside.width() * 0.5)
    scrollContents.scrollTop(scrollInside.height() * 0.5)
    scrollHandleWrapper.scrollLeft(scrollHandle.width() * 0.5)
    scrollHandleWrapper.scrollTop(scrollHandle.height() * 0.5)

  # Mainビューの高さ更新
  @updateMainViewSize = ->
    padding = 5 * 2
    $('#main').height($('#contents').height() - $("##{Navbar.NAVBAR_ROOT}").height() - padding)
    window.scrollContentsSize = {width: window.scrollContents.width(), height: window.scrollContents.height()}

  # ウィンドウの高さ設定
  @resizeMainContainerEvent = ->
    @updateMainViewSize()
    $(window.drawingCanvas).attr('width', window.canvasWrapper.width())
    $(window.drawingCanvas).attr('height', window.canvasWrapper.height())

  # ウィンドウリサイズイベント
  @initResize = ->
    $(window).resize( ->
      RunCommon.resizeMainContainerEvent()
    )

  # イベント作成
  @initEventAction = ->
    # アクションのイベントを取得
    pageCount = PageValue.getPageCount()
    pageList = new Array(pageCount)
    for i in [1..pageCount]
      forkEventPageValueList = {}
      for j in [0..PageValue.getForkCount()]
        forkEventPageValueList[j] = PageValue.getEventPageValueSortedListByNum(j, i)
      page = null
      if forkEventPageValueList[PageValue.Key.EF_MASTER_FORKNUM].length > 0
        # Masterデータが存在する場合ページを作成
        page = new Page({
          forks: forkEventPageValueList
        })
      pageList[i - 1] = page

    # ナビバーのページ数 & チャプター数設定
    Navbar.setPageMax(pageCount)
    # アクション作成
    window.eventAction = new EventAction(pageList, PageValue.getPageNum() - 1)
    window.eventAction.start()

  # Handleスクロール位置の初期化
  @initHandleScrollPoint = ->
    scrollHandleWrapper.scrollLeft(scrollHandleWrapper.width() * 0.5)
    scrollHandleWrapper.scrollTop(scrollHandleWrapper.height() * 0.5)

  # スクロールイベントの初期化
  @setupScrollEvent = ->
    lastLeft = scrollHandleWrapper.scrollLeft()
    lastTop = scrollHandleWrapper.scrollTop()
    stopTimer = null

    scrollHandleWrapper.scroll( (e) ->
      e.preventDefault()

      if !RunCommon.enabledScroll()
        return

      x = $(@).scrollLeft()
      y = $(@).scrollTop()

      if stopTimer != null
        clearTimeout(stopTimer)
      stopTimer = setTimeout( =>
        RunCommon.initHandleScrollPoint()
        lastLeft = $(@).scrollLeft()
        lastTop = $(@).scrollTop()
        clearTimeout(stopTimer)
        stopTimer = null
      , 100)

      distX = x - lastLeft
      distY = y - lastTop
      lastLeft = x
      lastTop = y

      #console.log('distX:' + distX + ' distY:' + distY)
      window.eventAction.thisPage().handleScrollEvent(distX, distY)
    )

  # スクロールが有効の状態か判定
  # @return [Boolena] 判定結果
  @enabledScroll = ->
    ret = false
    if window.eventAction? &&
      window.eventAction.thisPage()? &&
      (window.eventAction.thisPage().finishedAllChapters || (window.eventAction.thisPage().thisChapter()? && window.eventAction.thisPage().isScrollChapter()))
        ret = true
    return ret

  # CSS要素作成
  # @param [Integer] pageNum ページ番号
  @createCssElement = (pageNum) ->
    # CSS作成
    cssId = @RUN_CSS.replace('@pagenum', pageNum)
    cssEmt = $("##{cssId}")
    if !cssEmt? || cssEmt.length == 0
      $("<div id='#{cssId}'></div>").appendTo(window.cssCode)
      cssEmt = $("##{cssId}")
    cssEmt.html(PageValue.itemCssOnPage(pageNum))

  # 対象ページのPageValueデータを読み込み
  # @param [Integer] loadPageNum 読み込むページ番号
  # @param [Function] callback コールバック
  # @param [Boolean] forceUpdate 既存データを上書きするか
  @loadPagingPageValue = (loadPageNum, callback = null, forceUpdate = false) ->
    lastPageNum = loadPageNum + Constant.Paging.PRELOAD_PAGEVALUE_NUM
    targetPages = []
    for i in [loadPageNum..lastPageNum]
      if forceUpdate
        targetPages.push(i)
      else
        className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', i)
        section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
        if !section? || section.length == 0
          targetPages.push(i)

    if targetPages.length == 0
      if callback?
        callback()
      return

    $.ajax(
      {
        url: "/run/paging"
        type: "POST"
        dataType: "json"
        data: {
          targetPages: targetPages
        }
        success: (data)->
          if data.instance_pagevalue_hash != null
            for k, v of data.instance_pagevalue_hash
              PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)
          if data.event_pagevalue_hash != null
            for k, v of data.event_pagevalue_hash
              PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v)

          # コールバック
          if callback?
            callback()
        error: (data) ->
      }
    )

  @getForkStack = (pn) ->
    if !window.forkNumStacks?
      window.forkNumStacks = {}
    return window.forkNumStacks[pn]

  @setForkStack = (obj, pn) ->
    if !window.forkNumStacks?
      window.forkNumStacks = {}
    window.forkNumStacks[pn] = [obj]

  # フォーク番号スタック初期化
  # @return [Boolean] 処理正常終了か
  @initForkStack = (forkNum, pn) ->
    @setForkStack({
      changedChapterIndex: 0
      forkNum: forkNum
    }, pn)
    # PageValueに書き込み
    PageValue.setGeneralPageValue(PageValue.Key.FORK_STACK, window.forkNumStacks)
    return true

  # フォーク番号をスタックに追加
  # @return [Boolean] 処理正常終了か
  @addForkNumToStack = (forkNum, cIndex, pn) ->
    lastForkNum = @getLastForkNumFromStack(pn)
    if lastForkNum? && lastForkNum != forkNum
      # フォーク番号追加
      stack = @getForkStack(pn)
      stack.push(
        {
          changedChapterIndex: cIndex
          forkNum: forkNum
        }
      )
      # PageValueに書き込み
      PageValue.setGeneralPageValue(PageValue.Key.FORK_STACK, window.forkNumStacks)
      return true
    else
      return false

  # スタックから最新フォークオブジェクトを取得
  # @return [Integer] 取得値
  @getLastObjestFromStack = (pn) ->
    if !window.forkNumStacks?
      # PageValueから読み込み
      window.forkNumStacks = PageValue.getGeneralPageValue(PageValue.Key.FORK_STACK)
      if !window.forkNumStacks?
        return null
    stack = window.forkNumStacks[pn]
    if stack? && stack.length > 0
      return stack[stack.length - 1]
    else
      return null

  # スタックから最新フォーク番号を取得
  # @return [Integer] 取得値
  @getLastForkNumFromStack = (pn) ->
    obj = @getLastObjestFromStack(pn)
    if obj?
      return obj.forkNum
    else
      return null

  # スタックから以前のフォークオブジェクトを取得
  # @return [Integer] 取得値
  @getOneBeforeObjestFromStack = (pn) ->
    if !window.forkNumStacks?
      # PageValueから読み込み
      window.forkNumStacks = PageValue.getGeneralPageValue(PageValue.Key.FORK_STACK)
      if !window.forkNumStacks?
        return null
    stack = window.forkNumStacks[pn]
    if stack? && stack.length > 1
      return stack[stack.length - 2]
    else
      return null

  # スタックから最新フォーク番号を削除
  # @return [Boolean] 処理正常終了か
  @popLastForkNumInStack = (pn) ->
    if !window.forkNumStacks?
      # PageValueから読み込み
      window.forkNumStacks = PageValue.getGeneralPageValue(PageValue.Key.FORK_STACK)
      if !window.forkNumStacks?
        return false
    window.forkNumStacks[pn].pop()
    return true

  # ギャラリーアップロードビュー表示処理
  @showUploadGalleryConfirm = ->
    # オーバーレイ前の画面をキャプチャ
    html2canvas(document.body, {
      onrendered: (canvas) ->
        window.captureCanvas = canvas
        Common.showModalView(Constant.ModalViewType.UPLOAD_GALLERY_CONFIRM, RunCommon.prepareUploadGalleryConfirm)
    })

  # ギャラリーアップロードビュー表示前処理
  @prepareUploadGalleryConfirm = (modalEmt) ->
    # マークアップ入力フォーム初期化
    mark = $('.markItUp', modalEmt)
    if mark? && mark.length > 0
      $('.caption_markup', modalEmt).markItUpRemove()
    $('.caption_markup', modalEmt).markItUp(mySettings)

    # タグクリックイベント設定
    RunCommon.prepareUploadGalleryTagEvent(modalEmt)

    # Inputイベント
    $('.select_tag_input', modalEmt).off('keypress')
    $('.select_tag_input', modalEmt).on('keypress', (e) ->
      if e.keyCode == 13
        # Enterキーを押した場合、選択タグに追加
        RunCommon.addUploadGallerySelectTag(modalEmt, $(@).val())
        $(@).val('')
    )

    # Updateイベント
    $('.upload_button', modalEmt).off('click')
    $('.upload_button', modalEmt).on('click', ->
      RunCommon.uploadGallery(modalEmt)
    )

  # タグクリックイベント
  @prepareUploadGalleryTagEvent = (modalEmt) ->
    tags = $('.popular_tag a, .recommend_tag a', modalEmt)
    tags.off('click')
    tags.on('click', ->
      # 選択タグに追加
      RunCommon.addUploadGallerySelectTag(modalEmt, $(@).html())
    )

    # マウスオーバーイベント
    tags.off('mouseenter')
    tags.on('mouseenter', (e) ->
      li = @closest('li')
      $(li).append($("<div class='add_pop' style='display:none'><p>Add tag(click)</p></div>"))
      $('.add_pop', li).css({top: $(li).height(), left: $(li).width()})
      $('.add_pop', li).css('display', 'block')
    )
    tags.off('mouseleave')
    tags.on('mouseleave', (e) ->
      ul = @closest('ul')
      $('.add_pop', ul).remove()
    )

  @addUploadGallerySelectTag = (modalEmt, tagname) ->
    ul = $('.select_tag ul', modalEmt)
    tags = $.map(ul.children(), (n) ->
      return $('a', n).html()
    )

    if tags.length >= Constant.Gallery.TAG_MAX || $.inArray(tagname, tags) >= 0
      return
    ul.append($("<li><a href='#'>#{tagname}</a></li>"))

    # タグ クリックイベント
    $('a', ul).off('click')
    $('a', ul).on('click', (e) ->
      # タグ削除
      @closest('li').remove()
      if $('.select_tag ul li', modalEmt).length < Constant.Gallery.TAG_MAX
        $('.select_tag_input', modalEmt).css('display', 'block')
    )

    # タグ マウスオーバーイベント
    $('a', ul).off('mouseenter')
    $('a', ul).on('mouseenter', (e) ->
      li = @closest('li')
      $(li).append($("<div class='delete_pop' style='display:none'><p>Delete tag(click)</p></div>"))
      $('.delete_pop', li).css({top: $(li).height(), left: $(li).width()})
      $('.delete_pop', li).css('display', 'block')
    )
    $('a', ul).off('mouseleave')
    $('a', ul).on('mouseleave', (e) ->
      $('li .delete_pop', ul).remove()
    )

    if $('.select_tag ul li', modalEmt).length >= Constant.Gallery.TAG_MAX
      # タグ数が最大数になった場合, Inputを非表示
      $('.select_tag_input', modalEmt).css('display', 'none')

  # ギャラリーアップロード
  @uploadGallery = (modalEmt, callback = null) ->

    # 入力値バリデーションチェック
    title = $('.title:first', modalEmt).val()
    if title.length == 0
      return

    # 確認ダイアログ
    if window.confirm(I18n.t('message.dialog.update_gallery'))
      _saveGallery.call(@)

    # ギャラリー保存処理
    _saveGallery = ->
      _callback = (blob = null) ->
        data = {}
        data[Constant.Gallery.Key.PROJECT_ID] = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)
        data[Constant.Gallery.Key.TITLE] = title
        data[Constant.Gallery.Key.CAPTION] = $('.caption_markup:first', modalEmt).val()
        data[Constant.Gallery.Key.THUMBNAIL_IMG] = blob
        data[Constant.Gallery.Key.TAGS] = $('.select_tag a', modalEmt).html()
        data[Constant.Gallery.Key.INSTANCE_PAGE_VALUE] = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX)
        data[Constant.Gallery.Key.EVENT_PAGE_VALUE] = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT)
        $.ajax(
          {
            url: "/gallery/save_state"
            type: "POST"
            dataType: "json"
            data: data
            success: (data)->
              # 正常完了処理

              # コールバック
              if callback?
                callback()

              # 詳細画面に遷移

            error: (data) ->
          }
        )

      if window.captureCanvas?
        # Blob作成
        window.captureCanvas.toBlob(_callback)
      else
        _callback.call(@)

  # Mainコンテナ初期化
  @initMainContainer = ->
    CommonVar.runCommonVar()
    @initView()
    @initHandleScrollPoint()
    @initResize()
    @setupScrollEvent()
    Navbar.initRunNavbar()