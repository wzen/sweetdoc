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

  # 前のページインスタンスを取得
  beforePage: ->
    if @pageIndex > 0
      return @pageList[@pageIndex - 1]
    else
      return null

  # 現在のページ番号を取得
  # @return [Object] 現在のページ番号
  thisPageNum: ->
    return @pageIndex + 1

  # 開始イベント
  start: (callback = null) ->
    # ページングガイド作成
    @pagingOperationGuide = new ScrollOperationGuide(ScrollOperationGuide.Type.PAGING)
    @rewindOperationGuide = new ScrollOperationGuide(ScrollOperationGuide.Type.REWIND, ScrollOperationGuide.Direction.REVERSE)
    # ページ数設定
    RunCommon.setPageNum(@thisPageNum())
    # フォークをMasterに設定
    RunCommon.initForkStack(PageValue.Key.EF_MASTER_FORKNUM, window.eventAction.thisPageNum())
    RunCommon.setForkNum(PageValue.Key.EF_MASTER_FORKNUM)
    @thisPage().willPage( =>
      @thisPage().start()
      if callback?
        callback()
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
      if callback?
        callback()
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
    @pagingOperationGuide.clear()
    if @pageIndex > 0
      # 前ページが存在する場合は戻す
      @pageIndex -= 1
      RunCommon.setPageNum(@thisPageNum())
      PageValue.setPageNum(@thisPageNum())
      @changePaging(beforePageIndex, @pageIndex, callback)
      # チャプター動作済みに戻す
      @thisPage().thisChapter().doMoveChapter = true
    else
      # 前ページが無い場合は現在のページを再開
      # ページ前処理
      @thisPage().willPage( =>
        @thisPage().start()
        if callback?
          callback()
      )

  # ページ変更処理
  # @param [Integer] beforePageIndex 変更前ページIndex
  # @param [Integer] afterPageIndex 変更後ページIndex
  # @param [Function] コールバック
  changePaging: (beforePageIndex, afterPageIndex, callback = null) ->
    Common.hideModalView(true)
    Common.showModalFlashMessage('Page changing')

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
        # Mainコンテナ作成
        Common.createdMainContainerIfNeeded(afterPageNum, beforePageNum > afterPageNum)
        # ページングアニメーションクラス作成
        pageFlip = new PageFlip(beforePageNum, afterPageNum)
        # 新規コンテナ初期化
        RunCommon.initMainContainer()
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
        PageValue.adjustInstanceAndEventOnPage()
        _after = ->
          @thisPage().start()
          if @thisPage().thisChapter()?
            # イベント反応無効
            @thisPage().thisChapter().disableEventHandle()
          if beforePageNum < afterPageNum
            # スクロール位置初期化
            Common.initScrollContentsPosition()
          # ページングアニメーション
          pageFlip.startRender( =>
            # 次ページインデックスを初期化
            @nextPageIndex = null
            # 隠したビューを非表示にする
            className = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', beforePageNum)
            section = $("##{constant.Paging.ROOT_ID}").find(".#{className}:first")
            section.hide()
            # 隠したビューのアイテム表示を削除(インスタンスは残す)
            Common.removeAllItem(beforePageNum, false)
            # CSS削除
            $("##{RunCommon.RUN_CSS.replace('@pagenum', beforePageNum)}").remove()
            if @thisPage().thisChapter()?
              # イベント反応有効
              @thisPage().thisChapter().enableEventHandle()
            # モーダルを削除
            Common.hideModalView()
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
  rewindAllPages: (callback = null) ->
    count = 0
    for i in [(@pageList.length - 1)..0] by -1
      page = @pageList[i]
      page.resetAllChapters( =>
        count += 1
        if count >= @pageList.length
          @pageIndex = 0
          RunCommon.setPageNum(@thisPageNum())
          @finishedAllPages = false
          @start(callback)
      )

  # 次のページが存在するか
  hasNextPage: ->
    return @pageIndex < @pageList.length - 1

  # 全ページ終了イベント
  finishAllPages: ->
    @finishedAllPages = true
    if window.debug
      console.log('Finish All Pages!!!')
