class LocalStorage

  class @Key
    # @property [Int] WORKTABLE_TIMELINE_PAGEVALUES タイムラインページ値
    @WORKTABLE_TIMELINE_PAGEVALUES = 'worktable_timeline_pagevalues'
    # @property [Int] RUN_TIMELINE_PAGEVALUES タイムラインページ値
    @RUN_TIMELINE_PAGEVALUES = 'run_timeline_pagevalues'

  constructor: (key) ->
    @lstorage = localStorage
    @storageKey = key

  # ストレージにページ値を保存
  saveTimelinePageValueToStorage: ->
    h = getTimelinePageValue(Constant.PageValueKey.TE_PREFIX)
    @lstorage.setItem(@storageKey, JSON.stringify(h))

  # ストレージからページ値を読み込み
  loadTimelinePageValueFromStorage: ->
    h = JSON.parse(@lstorage.getItem(@storageKey))
    setTimelinePageValue(Constant.PageValueKey.TE_PREFIX, h)

  get: ->
    @lstorage.getItem(@storageKey)

  set: (value) ->
    @lstorage.setItem(@storageKey, value)

  # WebStorageから全てのアイテムを描画
  @drawItemFromStorage = (key) ->