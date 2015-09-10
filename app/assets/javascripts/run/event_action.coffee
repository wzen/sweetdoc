# イベント実行クラス
class EventAction
  # コンストラクタ
  constructor: (@pageList, @pageIndex) ->
    @finishedAllPages = false

  # 現在のページを取得
  thisPage: ->
    return @pageList[@pageIndex]

  # 開始イベント
  start: ->
    pageNum = @pageIndex + 1
    # ページ数設定
    Navbar.setPageNum(pageNum)
    # CSS作成
    RunCommon.createCssElement(pageNum)

    @thisPage().willPage()
    @thisPage().start()

  # 全てのチャプターが終了している場合、ページを進める
  nextPageIfFinishedAllChapter: ->
    if @thisPage().finishedAllChapters
      @nextPage()

  # ページを進める
  nextPage: ->
    # ページ後処理
    @thisPage().didPage()
    beforePageIndex = @pageIndex
    # indexを更新

    if @pageList.length <= @pageIndex + 1
      @finishAllPages()
    else
      @pageIndex += 1
      pageNum = @pageIndex + 1
      Navbar.setPageNum(pageNum)
      PageValue.setPageNum(pageNum)
      RunCommon.loadPagingPageValue(pageNum, pageNum, =>
        Common.loadJsFromInstancePageValue( =>
          if @thisPage() == null
            # Pageインスタンス作成
            eventPageValueList = PageValue.getEventPageValueSortedListByNum(pageNum)
            @pageList[@pageIndex] = new Page(eventPageValueList)
            if window.debug
              console.log('[nextPage] created page instance')
          @changePaging(beforePageIndex, @pageIndex)
        )
      )

  # ページを戻す
  rewindPage: ->
    beforePageIndex = @pageIndex
    if @pageIndex > 0
      # 動作させていない場合は前のページに戻す
      @pageIndex -= 1
      pageNum = @pageIndex + 1
      Navbar.setPageNum(pageNum)
      PageValue.setPageNum(pageNum)
      RunCommon.loadPagingPageValue(pageNum, pageNum, =>
        Common.loadJsFromInstancePageValue( =>
          if @thisPage() == null
            # Pageインスタンス作成
            eventPageValueList = PageValue.getEventPageValueSortedListByNum(pageNum)
            @pageList[@pageIndex] = new Page(eventPageValueList)
            if window.debug
              console.log('[rewindPage] created page instance')
          @changePaging(beforePageIndex, @pageIndex)
        )

      )
    else
      # 動作させている場合はページのアクションを元に戻す
      # ページ前処理
      @thisPage().willPage()
      @thisPage().start()

  # ページ変更処理
  changePaging: (beforePageIndex, afterPageIndex, callback = null) ->
    beforePageNum = beforePageIndex + 1
    afterPageNum = afterPageIndex + 1
    if window.debug
      console.log('[changePaging] beforePageNum:' + beforePageNum)
      console.log('[changePaging] afterPageNum:' + afterPageNum)

    # Mainコンテナ作成
    Common.createdMainContainerIfNeeded(afterPageNum, beforePageNum > afterPageNum)

    # ページングクラス作成
    pageFlip = new PageFlip(beforePageNum, afterPageNum)
    # 新規コンテナ初期化
    RunCommon.initMainContainer()
    PageValue.adjustInstanceAndEventOnPage()
    # ページ前処理
    if beforePageNum > afterPageNum
      @thisPage().willPageFromRewind()
    else
      @thisPage().willPage()
    @thisPage().start()
    # CSS作成
    RunCommon.createCssElement(afterPageNum)
    # ページング
    pageFlip.startRender( ->
      # 隠したビューを非表示にする
      className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
      section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
      section.css('display', 'none')
      # 隠したビューのアイテムを削除
      Common.removeAllItem(beforePageNum)
      # CSS削除
      $("##{RunCommon.RUN_CSS.replace('@pagenum', beforePageNum)}").remove()
      # コールバック
      if callback?
        callback()
    )

  # 全てのページを戻す
  rewindAllPages: ->
    for i in [(@pageList.length - 1)..0] by -1
      page = @pageList[i]
      page.resetAllChapters()
    @pageIndex = 0
    Navbar.setPageNum(@pageIndex + 1)
    @finishedAllPages = false
    @start()

  # 全ページ終了イベント
  finishAllPages: ->
    @finishedAllPages = true
    console.log('Finish All Pages!!!')
