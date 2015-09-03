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
    # ページ数設定
    Navbar.setPageNum(@pageIndex + 1)
    # CSS
    $('#sup_css').html(PageValue.itemCssOnPage())

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
      Navbar.setPageNum(@pageIndex + 1)
      @changePaging(beforePageIndex, @pageIndex, ->
        # ページ数設定
        Navbar.setPageNum(@pageIndex + 1)
      )

  # ページを戻す
  rewindPage: ->
    @resetPage(@pageIndex)
    beforePageIndex = @pageIndex
    if !@thisChapter().doMovePage && @pageIndex > 0
      # 動作させていない場合は前のページに戻す
      @pageIndex -= 1
      Navbar.setPageNum(@pageIndex + 1)
      @changePaging(beforePageIndex, @pageIndex, ->
        # ページ数設定
        Navbar.setPageNum(@pageIndex + 1)
      )
    else
      # 動作させている場合はページのアクションを元に戻す

      # ページ前処理
      @thisPage().willPage()

  # ページ変更処理
  changePaging: (beforePageIndex, afterPageIndex, callback = null) ->
    beforePageNum = beforePageIndex + 1
    afterPageNum = afterPageIndex + 1
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', afterPageNum)
    section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
    section.css('display', '')
    PageValue.setPageNum(afterPageNum)
    # Mainコンテナ作成
    Common.createdMainContainerIfNeeded(afterPageNum, beforePageNum > afterPageNum)
    Run.initMainContainer()
    PageValue.adjustInstanceAndEventOnThisPage()
    @resetPage(afterPageIndex)

    # CSS
    $('#sup_css').html(PageValue.itemCssOnPage())

    # ページ前処理
    @thisPage().willPage()

    # ページング
    direction = if beforePageNum < PageValue.getPageNum() then PageFlip.DIRECTION.FORWARD else PageFlip.DIRECTION.BACK
    pn = if beforePageNum < PageValue.getPageNum() then beforePageNum else PageValue.getPageNum()
    pageFlip = new PageFlip(pn)
    pageFlip.startRender(direction, ->
      # 隠したビューを非表示にする
      className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
      section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
      section.css('display', 'none')
      # 隠したビューのアイテムを削除
      Common.removeAllItem(beforePageNum)

      Run.initMainContainer()
      Timeline.refreshAllTimeline()

      # コールバック
      if callback?
        callback()
    )

  # ページの内容をリセット
  resetPage: (pageIndex) ->
    @pageList[pageIndex].resetAllChapters()

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
