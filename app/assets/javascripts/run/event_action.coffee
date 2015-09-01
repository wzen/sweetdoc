# イベント実行クラス
class EventAction
  # コンストラクタ
  constructor: (@pageList, @pageIndex) ->
    @finishedAllChapters = false

  # 現在のページを取得
  thisPage: ->
    return @pageList[@pageIndex]

  # 開始イベント
  start: ->
    # ページ数設定
    Navbar.setPageNum(@pageIndex + 1)
    @thisPage().willForwardPage()
    @thisPage().start()

  # 全てのチャプターが終了している場合、ページを進める
  nextPageIfFinishedAllChapter: ->
    if @thisPage().finishedAllChapters()
      @nextPage()

  # ページを進める
  nextPage: ->
    # ページ後処理
    @thisPage().didPage()
    # indexを更新
    @pageIndex += 1
    if @pageList.length <= @pageIndex
      @finishedAllChapters()
    else
      # ページ数設定
      Navbar.setPageNum(@pageIndex + 1)
      # ページ前処理
      @thisPage().willForwardPage()

  # ページを戻す
  rewindPage: ->
    @resetPage(@pageIndex)
    if !@thisChapter().doMovePage && @pageIndex > 0
      @pageIndex -= 1
      @resetPage(@pageIndex)

    # ページ前処理
    @thisPage().willForwardPage()

  # ページの内容をリセット
  resetPage: (pageIndex) ->
    @pageList[pageIndex].reset()

  # 全てのページを戻す
  rewindAllPages: ->
    for i in [(@pageList.length - 1)..0] by -1
      page = @pageList[i]
      page.reset()
    @pageIndex = 0
    @finishedAllChapters = false
    @start()

  # 全チャプター終了イベント
  finishAllChapters: ->
    @finishedAllChapters = true
    console.log('Finish All Chapters!')
