# イベント実行クラス
class EventAction
  # コンストラクタ
  # @param [Array] @pageList ページオブジェクト
  # @param [Integer] @pageIndex ページ番号
  constructor: (@pageList, @pageIndex) ->
    @finishedAllPages = false
    @nextPageIndex = null

  # 現在のページインスタンスを取得
  # @return [Object] 現在のページインスタンス
  thisPage: ->
    return @pageList[@pageIndex]

  # 現在のページ番号を取得
  # @return [Object] 現在のページ番号
  thisPageNum: ->
    return @pageIndex + 1

  # 開始イベント
  start: ->
    # ページ数設定
    RunCommon.setPageNum(@thisPageNum())
    # フォークをMasterに設定
    RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, window.eventAction.thisPageNum())
    RunCommon.setForkNum(PageValue.Key.EF_MASTER_FORKNUM)
    @thisPage().willPage( =>
      @thisPage().start()
    )

  # 中断
  shutdown: ->
    if @thisPage()?
      @thisPage().shutdown()

  # 全てのチャプターが終了している場合、ページを進める
  # @param [Function] callback コールバック
  nextPageIfFinishedAllChapter: (callback = null) ->
    if @thisPage().finishedAllChapters
      @nextPage(callback)

  # ページを進める
  # @param [Function] callback コールバック
  nextPage: (callback = null) ->
    # ページ後処理
    @thisPage().didPage()

    beforePageIndex = @pageIndex
    if @pageList.length <= @pageIndex + 1
      # 全ページ終了の場合
      @finishAllPages()
    else
      if @nextPageIndex?
        @pageIndex = @nextPageIndex
      else
        @pageIndex += 1
      # ページ番号更新
      RunCommon.setPageNum(@thisPageNum())
      PageValue.setPageNum(@thisPageNum())
      @changePaging(beforePageIndex, @pageIndex, callback)

  # ページを戻す
  # @param [Function] callback コールバック
  rewindPage: (callback = null) ->
    beforePageIndex = @pageIndex
    if @pageIndex > 0
      # 動作させていない場合は前のページに戻す
      @pageIndex -= 1
      RunCommon.setPageNum(@thisPageNum())
      PageValue.setPageNum(@thisPageNum())
      @changePaging(beforePageIndex, @pageIndex, callback)
    else
      # 動作させている場合はページのイベントを元に戻して初めから
      # ページ前処理
      @thisPage().willPage( =>
        @thisPage().start()
      )

  # ページ変更処理
  # @param [Integer] beforePageIndex 変更前ページIndex
  # @param [Integer] afterPageIndex 変更後ページIndex
  # @param [Function] コールバック
  changePaging: (beforePageIndex, afterPageIndex, callback = null) ->
    beforePageNum = beforePageIndex + 1
    afterPageNum = afterPageIndex + 1
    if window.debug
      console.log('[changePaging] beforePageNum:' + beforePageNum)
      console.log('[changePaging] afterPageNum:' + afterPageNum)

    # 次ページのPageValue読み込み
    # 前ページに戻る場合は操作履歴も取得する
    doLoadFootprint = beforePageNum > afterPageNum
    RunCommon.loadPagingPageValue(afterPageNum, doLoadFootprint, =>
      # 必要JSファイル読み込み
      Common.loadJsFromInstancePageValue( =>
        if @thisPage() == null
          # 次のページオブジェクトがない場合は作成
          forkEventPageValueList = {}
          for i in [0..PageValue.getForkCount()]
            forkEventPageValueList[i] = PageValue.getEventPageValueSortedListByNum(i, afterPageNum)
          @pageList[afterPageIndex] = new Page({
            forks: forkEventPageValueList
          })
          if window.debug
            console.log('[nextPage] created page instance')
        # Mainコンテナ作成
        Common.createdMainContainerIfNeeded(afterPageNum, beforePageNum > afterPageNum)
        # ページングアニメーションクラス作成
        pageFlip = new PageFlip(beforePageNum, afterPageNum)
        # 新規コンテナ初期化
        RunCommon.initMainContainer()
        PageValue.adjustInstanceAndEventOnPage()

        _after = ->
          @thisPage().start()
          # イベント反応無効
          @thisPage().thisChapter().disableEventHandle()
          # ページングアニメーション
          pageFlip.startRender( =>
            # 次ページインデックスを初期化
            @nextPageIndex = null
            # 隠したビューを非表示にする
            className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
            section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
            section.hide()
            # 隠したビューのアイテムを削除
            Common.removeAllItem(beforePageNum)
            # CSS削除
            $("##{RunCommon.RUN_CSS.replace('@pagenum', beforePageNum)}").remove()
            # イベント反応有効
            @thisPage().thisChapter().enableEventHandle()
            # コールバック
            if callback?
              callback()
          )

        # ページ前処理
        if beforePageNum > afterPageNum
          # 前ページ移動 前処理
          @thisPage().willPageFromRewind( =>
            _after.call(@)
          )
        else
          # フォークをMasterに設定
          RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, afterPageNum)
          RunCommon.setForkNum(PageValue.Key.EF_MASTER_FORKNUM)
          # 後ページ移動 前処理
          @thisPage().willPage( =>
            _after.call(@)
          )
      )
    )

  # 全てのページを戻す
  rewindAllPages: ->
    for i in [(@pageList.length - 1)..0] by -1
      page = @pageList[i]
      page.resetAllChapters()
    @pageIndex = 0
    RunCommon.setPageNum(@thisPageNum())
    @finishedAllPages = false
    @start()

  # 次のページが存在するか
  hasNextPage: ->
    return @pageIndex < @pageList.length - 1

  # 全ページ終了イベント
  finishAllPages: ->
    @finishedAllPages = true
    if window.debug
      console.log('Finish All Pages!!!')
