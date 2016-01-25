# PageValue
class PageValue
  # 定数
  constant = gon.const
  # ページ内値保存キー
  class @Key
    # @property [String] PAGE_VALUES_SEPERATOR ページ値のセパレータ
    @PAGE_VALUES_SEPERATOR = constant.PageValueKey.PAGE_VALUES_SEPERATOR
    # @property [String] G_ROOT 汎用情報ルート
    @G_ROOT = constant.PageValueKey.G_ROOT
    # @property [String] G_ROOT 汎用情報プレフィックス
    @G_PREFIX = constant.PageValueKey.G_PREFIX
    # @property [String] P_PREFIX ページ番号プレフィックス
    @P_PREFIX = constant.PageValueKey.P_PREFIX
    # @property [return] 現在のページのページ番号ルート
    @pageRoot = (pn = PageValue.getPageNum()) -> @P_PREFIX + pn
    # @property [String] ST_ROOT 設定Root
    @ST_ROOT = constant.PageValueKey.ST_ROOT
    # @property [String] ST_PREFIX 設定プレフィックス
    @ST_PREFIX = constant.PageValueKey.ST_PREFIX
    # @property [String] PAGE_COUNT ページ総数
    @PAGE_COUNT = constant.PageValueKey.PAGE_COUNT
    # @property [String] PAGE_NUM 現在のページ番号
    @PAGE_NUM = constant.PageValueKey.PAGE_NUM
    # @property [String] FORK_NUM フォーク総数
    @FORK_COUNT = constant.PageValueKey.FORK_COUNT
    # @property [String] FORK_NUM 現在のフォーク番号
    @FORK_NUM = constant.PageValueKey.FORK_NUM
    # @property [String] IS_ROOT ページ値ルート
    @IS_ROOT = constant.PageValueKey.IS_ROOT
    # @property [String] PROJECT_NAME プロジェクトID
    @PROJECT_ID = "#{@G_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{Constant.Project.Key.PROJECT_ID}"
    # @property [String] PROJECT_NAME プロジェクト名
    @PROJECT_NAME = "#{@G_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{Constant.Project.Key.TITLE}"
    # @property [String] SCREEN_SIZE プロジェクトサイズ
    @SCREEN_SIZE = "#{@G_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{Constant.Project.Key.SCREEN_SIZE}"
    # @property [String] LAST_SAVE_TIME 最終保存時刻
    @LAST_SAVE_TIME = "#{@G_PREFIX}#{@PAGE_VALUES_SEPERATOR}last_save_time"
    # @property [String] LAST_SAVE_TIME 最終保存時刻
    @RUNNING_USER_PAGEVALUE_ID = "#{@G_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{Constant.Project.Key.USER_PAGEVALUE_ID}"
    # @property [String] INSTANCE_PREFIX インスタンスプレフィックス
    @INSTANCE_PREFIX = constant.PageValueKey.INSTANCE_PREFIX
    # @property [return] インスタンスページプレフィックスを取得
    @instancePagePrefix = (pn = PageValue.getPageNum()) -> @INSTANCE_PREFIX + @PAGE_VALUES_SEPERATOR + @pageRoot(pn)
    # @property [String] INSTANCE_VALUE_ROOT インスタンスROOT
    @INSTANCE_VALUE_ROOT = constant.PageValueKey.INSTANCE_VALUE_ROOT
    # @property [return] インスタンス値
    @instanceValue = (objId) -> @instancePagePrefix() + @PAGE_VALUES_SEPERATOR + objId + @PAGE_VALUES_SEPERATOR + @INSTANCE_VALUE_ROOT
    # @property [return] インスタンスキャッシュ値
    @instanceValueCache = (objId) -> @instancePagePrefix() + @PAGE_VALUES_SEPERATOR + 'cache' + @PAGE_VALUES_SEPERATOR + objId + @PAGE_VALUES_SEPERATOR + @INSTANCE_VALUE_ROOT
    # @property [return] インスタンスデザインRoot
    @instanceDesignRoot = (objId) -> @instanceValue(objId) + @PAGE_VALUES_SEPERATOR + 'designs'
    # @property [return] インスタンスデザイン
    @instanceDesign = (objId, designKey) -> @instanceDesignRoot(objId) + @PAGE_VALUES_SEPERATOR + designKey
    # @property [String] ITEM_LOADED_PREFIX アイテム読み込み済みプレフィックス
    @ITEM_LOADED_PREFIX = 'itemloaded'
    @itemLoaded = (classDistToken) -> "#{@ITEM_LOADED_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{classDistToken}"
    # @property [String] E_ROOT イベント値ルート
    @E_ROOT = constant.PageValueKey.E_ROOT
    # @property [String] E_SUB_ROOT イベントプレフィックス
    @E_SUB_ROOT = constant.PageValueKey.E_SUB_ROOT
    # @property [String] E_MASTER_ROOT イベントコンテンツルート
    @E_MASTER_ROOT = constant.PageValueKey.E_MASTER_ROOT
    # @property [String] E_FORK_ROOT イベントフォークルート
    @E_FORK_ROOT = constant.PageValueKey.E_FORK_ROOT
    # @property [return] イベントページルート
    @eventPageRoot = (pn = PageValue.getPageNum()) -> "#{@E_SUB_ROOT}#{@PAGE_VALUES_SEPERATOR}#{@pageRoot(pn)}"
    # @property [return] イベントページプレフィックス
    @eventPageMainRoot = (fn = PageValue.getForkNum(), pn = PageValue.getPageNum()) ->
      root = ''
      if fn > 0
        root = @EF_PREFIX + fn
      else
        root = @E_MASTER_ROOT
      return "#{@eventPageRoot(pn)}#{@PAGE_VALUES_SEPERATOR}#{root}"
    # @property [return] イベントページプレフィックス
    @eventNumber = (num, fn = PageValue.getForkNum(), pn = PageValue.getPageNum()) -> "#{@eventPageMainRoot(fn, pn)}#{@PAGE_VALUES_SEPERATOR}#{@E_NUM_PREFIX}#{num}"
    # @property [return] イベント数
    @eventCount = (fn = PageValue.getForkNum(), pn = PageValue.getPageNum()) -> "#{@eventPageMainRoot(fn, pn)}#{@PAGE_VALUES_SEPERATOR}count"
    # @property [String] E_NUM_PREFIX イベント番号プレフィックス
    @E_NUM_PREFIX = constant.PageValueKey.E_NUM_PREFIX
    # @property [String] EF_PREFIX イベントフォークプレフィックス
    @EF_PREFIX = constant.PageValueKey.EF_PREFIX
    # @property [String] IS_RUNWINDOW_RELOAD Runビューをリロードしたか
    @IS_RUNWINDOW_RELOAD = constant.PageValueKey.IS_RUNWINDOW_RELOAD
    # @property [String] EF_MASTER_FORKNUM Masterのフォーク番号
    @EF_MASTER_FORKNUM = constant.PageValueKey.EF_MASTER_FORKNUM
    # @property [String] UPDATED 更新フラグ
    @UPDATED = 'updated'
    # @property [return] 設定値ページプレフィックスを取得
    @generalPagePrefix = (pn = PageValue.getPageNum()) -> @G_PREFIX + @PAGE_VALUES_SEPERATOR + @pageRoot(pn)
    # @property [return] Worktableプロジェクト表示位置
    @worktableDisplayPosition = (pn = PageValue.getPageNum()) -> "#{@generalPagePrefix(pn)}#{@PAGE_VALUES_SEPERATOR}ws_display_position"
    # @property [return] Zoom
    @worktableScale = (pn = PageValue.getPageNum()) -> "#{@generalPagePrefix(pn)}#{@PAGE_VALUES_SEPERATOR}ws_scale"
    # @property [return] アイテム表示状態
    @itemVisible = (pn = PageValue.getPageNum()) -> "#{@generalPagePrefix(pn)}#{@PAGE_VALUES_SEPERATOR}item_visible"
    # @property [String] F_ROOT 履歴情報ルート
    @F_ROOT = constant.PageValueKey.F_ROOT
    # @property [String] F_PREFIX 履歴情報プレフィックス
    @F_PREFIX = constant.PageValueKey.F_PREFIX
    # @property [String] F_PREFIX 履歴情報イベント一意IDプレフィックス
    @FED_PREFIX = constant.PageValueKey.FED_PREFIX
    # @property [return] 履歴ページルート
    @footprintPageRoot = (pn = PageValue.getPageNum()) -> "#{@F_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{@pageRoot(pn)}"
    # @property [return] インスタンス履歴(変更前)
    @footprintInstanceBefore = (eventDistNum, objId, pn = PageValue.getPageNum()) -> "#{@footprintPageRoot(pn)}#{@PAGE_VALUES_SEPERATOR}#{@FED_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{eventDistNum}#{@PAGE_VALUES_SEPERATOR}#{objId}#{@PAGE_VALUES_SEPERATOR}instanceBefore"
    # @property [return] インスタンス履歴(変更後)
    @footprintInstanceAfter = (eventDistNum, objId, pn = PageValue.getPageNum()) -> "#{@footprintPageRoot(pn)}#{@PAGE_VALUES_SEPERATOR}#{@FED_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{eventDistNum}#{@PAGE_VALUES_SEPERATOR}#{objId}#{@PAGE_VALUES_SEPERATOR}instanceAfter"
    # @property [return] 共通インスタンス履歴(変更前)
    @footprintCommonBefore = (eventDistNum, pn = PageValue.getPageNum()) -> "#{@footprintPageRoot(pn)}#{@PAGE_VALUES_SEPERATOR}#{@FED_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{eventDistNum}#{@PAGE_VALUES_SEPERATOR}commonInstanceBefore"
    # @property [return] 共通インスタンス履歴(変更後)
    @footprintCommonAfter = (eventDistNum, pn = PageValue.getPageNum()) -> "#{@footprintPageRoot(pn)}#{@PAGE_VALUES_SEPERATOR}#{@FED_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{eventDistNum}#{@PAGE_VALUES_SEPERATOR}commonInstanceAfter"
    # @property [return] フォーク番号スタック
    @forkStack = (pn = PageValue.getPageNum()) -> "#{@footprintPageRoot(pn)}#{@PAGE_VALUES_SEPERATOR}fork_stack"

  # サーバから読み込んだアイテム情報を追加
  # @param [Integer] classDistToken アイテムID
  @addItemInfo = (classDistToken) ->
    @setInstancePageValue(@Key.itemLoaded(classDistToken), true)

  # 汎用値を取得
  # @param [String] key キー値
  # @param [Boolean] updateOnly updateクラス付与のみ取得するか
  @getGeneralPageValue = (key) ->
    _getPageValue.call(@, key, @Key.G_ROOT)

  # インスタンス値を取得
  # @param [String] key キー値
  # @param [Boolean] updateOnly updateクラス付与のみ取得するか
  @getInstancePageValue = (key) ->
    _getPageValue.call(@, key, @Key.IS_ROOT)

  # イベントの値を取得
  # @param [String] key キー値
  # @param [Boolean] updateOnly updateクラス付与のみ取得するか
  @getEventPageValue = (key) ->
    _getPageValue.call(@, key, @Key.E_ROOT)

  # 共通設定値を取得
  # @param [String] key キー値
  # @param [Boolean] updateOnly updateクラス付与のみ取得するか
  @getSettingPageValue = (key) ->
    _getPageValue.call(@, key, @Key.ST_ROOT)

  # 操作履歴値を取得
  # @param [String] key キー値
  # @param [Boolean] updateOnly updateクラス付与のみ取得するか
  @getFootprintPageValue = (key) ->
    _getPageValue.call(@, key, @Key.F_ROOT)

  # ページが持つ値を取得
  # @param [String] key キー値
  # @param [String] rootId Root要素ID
  # @return [Object] ハッシュ配列または値で返す
  _getPageValue = (key, rootId) ->
    f = @
    # div以下の値をハッシュとしてまとめる
    takeValue = (element) ->
      ret = null
      c = $(element).children()
      if c? && c.length > 0
        $(c).each((e) ->
          cList = @.classList
          if $(@).hasClass(PageValue.Key.UPDATED)
            cList = cList.filter((f) ->
              return f != PageValue.Key.UPDATED
            )
          k = cList[0]

          if !ret?
            if jQuery.isNumeric(k)
              ret = []
            else
              ret = {}

          v = null
          if @.tagName == "INPUT"
            # サニタイズをデコード
            v = Common.sanitaizeDecode($(@).val())
            if jQuery.isNumeric(v)
              v = Number(v)
            else if v == "true" || v == "false"
              v = if v == "true" then true else false
          else
            v = takeValue.call(f, @)

          # nullの場合は返却データに含めない
          if v != null
            if jQuery.type(ret) == "array" && jQuery.isNumeric(k)
              k = Number(k)
            ret[k] = v

          return true
        )

        # 空配列の場合はnullとする
        if (jQuery.type(ret) == "object" && !$.isEmptyObject(ret)) || (jQuery.type(ret) == "array" && ret.length > 0)
          return ret
        else
          return null
      else
        return null

    value = null
    root = $("##{rootId}")
    keys = key.split(@Key.PAGE_VALUES_SEPERATOR)
    keys.forEach((k, index) ->
      root = $(".#{k}", root)
      if !root? || root.length == 0
        value = null
        return
      if keys.length - 1 == index
        if root[0].tagName == "INPUT"
          value = Common.sanitaizeDecode(root.val())
          if jQuery.isNumeric(value)
            value = Number(value)
        else
          value = takeValue.call(f, root)
    )
    return value

  # 汎用値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] doAdded 上書きでなく追加する
  @setGeneralPageValue = (key, value, doAdd = false) ->
    _setPageValue.call(@, key, value, false, @Key.G_ROOT, true, doAdd)

  # インスタンス値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] doAdded 上書きでなく追加する
  @setInstancePageValue = (key, value, doAdd = false) ->
    _setPageValue.call(@, key, value, false, @Key.IS_ROOT, true, doAdd)

  # イベントの値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] doAdded 上書きでなく追加する
  @setEventPageValue = (key, value, doAdd = false) ->
    _setPageValue.call(@, key, value, false, @Key.E_ROOT, true, doAdd)

  # イベントの値をページルート値から設定
  # @param [Object] value 設定値(E_PREFIXで取得したハッシュ配列または値)
  # @param [Integer] fn フォーク番号
  # @param [Integer] pn ページ番号
  @setEventPageValueByPageRootHash = (value, fn = @getForkNum(), pn = @getPageNum()) ->
    # 内容を一旦消去
    contensRoot = if fn > 0 then @Key.EF_PREFIX + fn else @Key.E_MASTER_ROOT
    $("##{@Key.E_ROOT}").children(".#{@Key.E_SUB_ROOT}").children(".#{@Key.pageRoot()}").children(".#{contensRoot}").remove()
    @setEventPageValue(PageValue.Key.eventPageMainRoot(fn, pn), value)

  # 共通設定値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] doAdded 上書きでなく追加する
  @setSettingPageValue = (key, value, doAdd = false) ->
    _setPageValue.call(@, key, value, false, @Key.ST_ROOT, true, doAdd)

  # 操作履歴を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] doAdded 上書きでなく追加する
  @setFootprintPageValue = (key, value, doAdd = false) ->
    _setPageValue.call(@, key, value, false, @Key.F_ROOT, true, doAdd)

  # ページが持つ値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] isCache このページでのみ保持させるか
  # @param [String] rootId Root要素ID
  # @param [Boolean] giveName name属性を付与するか
  # @param [Boolean] doAdded 上書きでなく追加する
  _setPageValue = (key, value, isCache, rootId, giveName, doAdded) ->
    f = @

    if doAdded
      n = _getPageValue.call(@, key, rootId)
      $.extend(value, n)

    # ハッシュを要素の文字列に変換
    makeElementStr = (ky, val, kyName) ->
      if val == null || val == "null"
        return ''

      if kyName?
        kyName += "[#{ky}]"
      else
        kyName = ky
      if jQuery.type(val) != "object" && jQuery.type(val) != "array"
        # サニタイズする
        val = Common.sanitaizeEncode(val)
        name = ""
        if giveName
          name = "name = #{kyName}"

        return "<input type='hidden' class='#{ky}' value='#{val}' #{name} />"

      ret = ""
      for k, v of val
        ret += makeElementStr.call(f, k, v, kyName)

      return "<div class=#{ky}>#{ret}</div>"

    cacheClassName = 'cache'
    root = $("##{rootId}")
    parentClassName = null
    keys = key.split(@Key.PAGE_VALUES_SEPERATOR)
    keys.forEach((k, index) ->
      parent = root
      element = ''
      if keys.length - 1 > index
        element = 'div'
      else
        if jQuery.type(value) == "object"
          element = 'div'
        else
          element = 'input'
      root = $("#{element}.#{k}", parent)
      if keys.length - 1 > index
        if !root? || root.length == 0
          # 親要素のdiv作成
          root = jQuery("<div class=#{k}></div>").appendTo(parent)
        if parentClassName == null
          parentClassName = k
        else
          parentClassName += "[#{k}]"
      else
        if root? && root.length > 0
          # 要素が存在する場合は消去して上書き
          root.remove()
        # 要素作成
        root = jQuery(makeElementStr.call(f, k, value, parentClassName)).appendTo(parent)
        if isCache
          root.addClass(cacheClassName)
    )

    if window.isWorkTable
      # 自動保存実行
      ServerStorage.startSaveIdleTimer()

  # インスタンス値を削除
  # @param [Integer] objId オブジェクトID
  @removeInstancePageValue = (objId) ->
    $("##{@Key.IS_ROOT} .#{objId}").remove()

  # updateが付与しているクラスからupdateクラスを除去する
  @clearAllUpdateFlg = ->
    $("##{@Key.IS_ROOT}").find(".#{PageValue.Key.UPDATED}").removeClass(PageValue.Key.UPDATED)
    $("##{@Key.E_ROOT}").find(".#{PageValue.Key.UPDATED}").removeClass(PageValue.Key.UPDATED)
    $("##{@Key.ST_ROOT}").find(".#{PageValue.Key.UPDATED}").removeClass(PageValue.Key.UPDATED)

  # イベント番号で昇順ソートした配列を取得
  # @param [Integer] fn フォーク番号
  # @param [Integer] pn ページ番号
  @getEventPageValueSortedListByNum = (fn = PageValue.getForkNum(), pn = PageValue.getPageNum()) ->
    eventPageValues = PageValue.getEventPageValue(@Key.eventPageMainRoot(fn, pn))
    if !eventPageValues?
      return []

    count = PageValue.getEventPageValue(@Key.eventCount(fn, pn))
    eventObjList = new Array(count)

    # 番号でソート
    for k, v of eventPageValues
      if k.indexOf(@Key.E_NUM_PREFIX) == 0
        index = parseInt(k.substring(@Key.E_NUM_PREFIX.length)) - 1
        eventObjList[index] = v

    return eventObjList

  # 読み込み済みclassDistToken取得
  @getLoadedclassDistTokens = ->
    ret = []
    # インスタンスPageValueを参照
    itemInfoPageValues = PageValue.getInstancePageValue(@Key.ITEM_LOADED_PREFIX)
    for k, v of itemInfoPageValues
      if $.inArray(parseInt(k), ret) < 0
        ret.push(parseInt(k))
    return ret

  # 設定値以外の情報を全削除
  @removeAllGeneralAndInstanceAndEventPageValue = ->
    # page_value消去
    $("##{@Key.G_ROOT}").children(".#{@Key.G_PREFIX}").remove()
    $("##{@Key.IS_ROOT}").children(".#{@Key.INSTANCE_PREFIX}").remove()
    $("##{@Key.E_ROOT}").children(".#{@Key.E_SUB_ROOT}").remove()

  # ページ上のインスタンスとイベント情報を全削除
  @removeAllInstanceAndEventPageValueOnPage = ->
    # ページ内のpage_value消去
    $("##{@Key.IS_ROOT}").children(".#{@Key.INSTANCE_PREFIX}").children(".#{@Key.pageRoot()}").remove()
    $("##{@Key.E_ROOT}").children(".#{@Key.E_SUB_ROOT}").children(".#{@Key.pageRoot()}").remove()

  # InstancePageValueとEventPageValueを最適化
  @adjustInstanceAndEventOnPage = ->
    # Instanceに無いイベントを削除

    iPageValues = @getInstancePageValue(PageValue.Key.instancePagePrefix())
    instanceObjIds = []
    for k, v of iPageValues
      if $.inArray(v.value.id, instanceObjIds) < 0
        instanceObjIds.push(v.value.id)

    ePageValueRoot = @getEventPageValue(PageValue.Key.eventPageRoot())
    for kk, ePageValues of ePageValueRoot
      if @isContentsRoot(kk)
        adjust = {}
        min = 9999999
        max = 0
        for k, v of ePageValues
          if k.indexOf(@Key.E_NUM_PREFIX) == 0
            kNum = parseInt(k.replace(@Key.E_NUM_PREFIX, ''))
            if min > kNum
              min = kNum
            if max < kNum
              max = kNum
          else
            # イベント番号の付いていないキーはそのままにする
            adjust[k] = v

        teCount = 0
        if min <= max
          for i in [min..max]
            obj = ePageValues[@Key.E_NUM_PREFIX + i]
            if obj? &&
              $.inArray(obj[EventPageValueBase.PageValueKey.ID], instanceObjIds) >= 0
                teCount += 1
                # 番号を連番に振り直し
                adjust[@Key.E_NUM_PREFIX + teCount] = obj

        @setEventPageValueByPageRootHash(adjust, @getForkNumByRootKey(kk))
        PageValue.setEventPageValue(@Key.eventCount(@getForkNumByRootKey(kk)), teCount)

  # ページ総数更新
  @updatePageCount = ->
    # EventPageValueの「p_」を参照してカウント

    page_count = 0
    ePageValues = @getEventPageValue(@Key.E_SUB_ROOT)
    for k, v of ePageValues
      if k.indexOf(@Key.P_PREFIX) >= 0
        page_count += 1

    if page_count == 0
      # 初期表示時のページ総数は1
      page_count = 1
    @setGeneralPageValue("#{@Key.G_PREFIX}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.PAGE_COUNT}", page_count)

  # フォーク総数カウント
  @updateForkCount = (pn = PageValue.getPageNum()) ->
    # EventPageValueの「ef_」を参照してカウント

    fork_count = 0
    ePageValues = @getEventPageValue(@Key.eventPageRoot(pn))
    for k, v of ePageValues
      if k.indexOf(@Key.EF_PREFIX) >= 0
        fork_count += 1
    PageValue.setEventPageValue("#{@Key.eventPageRoot()}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.FORK_COUNT}", fork_count)

  # ページ総数を取得
  # @return [Integer] ページ総数
  @getPageCount = ->
    ret = PageValue.getGeneralPageValue("#{@Key.G_PREFIX}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.PAGE_COUNT}")
    if ret?
      return parseInt(ret)
    else
      return 1

  # 現在のページ番号を取得
  # @return [Integer] ページ番号
  @getPageNum = ->
    ret = PageValue.getFootprintPageValue("#{@Key.F_PREFIX}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.PAGE_NUM}")
    #ret = PageValue.getGeneralPageValue("#{@Key.G_PREFIX}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.PAGE_NUM}")
    if ret?
      ret = parseInt(ret)
    else
      ret = 1
      @setPageNum(ret)
    return ret

  # 現在のページ番号を設定
  # @param [Integer] num 設定値
  @setPageNum = (num) ->
    PageValue.setFootprintPageValue("#{@Key.F_PREFIX}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.PAGE_NUM}", parseInt(num))
    #PageValue.setGeneralPageValue("#{@Key.G_PREFIX}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.PAGE_NUM}", parseInt(num))

  # 現在のページ番号を追加
  # @param [Integer] addNum 追加値
  @addPagenum = (addNum) ->
    @setPageNum(@getPageNum() + addNum)

  # 現在のフォーク番号を取得
  @getForkNum = (pn = @getPageNum()) ->
    ret = PageValue.getEventPageValue("#{@Key.eventPageRoot(pn)}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.FORK_NUM}")
    if ret?
      return parseInt(ret)
    else
      return parseInt(@Key.EF_MASTER_FORKNUM)

  # 現在のフォーク番号を設定
  # @param [Integer] num 設定値
  @setForkNum = (num) ->
    PageValue.setEventPageValue("#{@Key.eventPageRoot()}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.FORK_NUM}", parseInt(num))

  # フォーク総数を取得
  # @return [Integer] フォーク総数
  @getForkCount = (pn = @getPageNum()) ->
    ret = PageValue.getEventPageValue("#{@Key.eventPageRoot(pn)}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.FORK_COUNT}")
    if ret?
      return parseInt(ret)
    else
      return 0

  # コンテンツルートのハッシュキーか判定
  # @param [String] key ハッシュキー
  # @return [Boolean] 判定結果
  @isContentsRoot = (key) ->
    return key == @Key.E_MASTER_ROOT || key.indexOf(@Key.EF_PREFIX) >= 0

  # コンテンツルートのハッシュキーからフォーク数を取得
  # @param [String] key ハッシュキー
  # @return [Integer] フォーク数 or null
  @getForkNumByRootKey = (key) ->
    if key.indexOf(@Key.EF_PREFIX) >= 0
      return parseInt(key.replace(@Key.EF_PREFIX, ''))
    return null

  # EventPageValueをソート
  # @param [Integer] beforeNum 移動前イベント番号
  # @param [Integer] afterNum 移動後イベント番号
  @sortEventPageValue = (beforeNum, afterNum) ->
    eventPageValues = PageValue.getEventPageValueSortedListByNum()
    w = eventPageValues[beforeNum - 1]
    # Syncを解除する
    w[EventPageValueBase.PageValueKey.IS_SYNC] = false
    if beforeNum < afterNum
      for num in [beforeNum..(afterNum - 1)]
        i = num - 1
        eventPageValues[i] = eventPageValues[i + 1]
    else
      for num in [beforeNum..(afterNum + 1)] by -1
        i = num - 1
        eventPageValues[i] = eventPageValues[i - 1]
    eventPageValues[afterNum - 1] = w
    for e, idx in eventPageValues
      @setEventPageValue(@Key.eventNumber(idx + 1), e)

  # 作成アイテム一覧を取得
  # @param [Integer] pn 取得するページ番号
  @getCreatedItems = (pn = null) ->
    instances = @getInstancePageValue(@Key.instancePagePrefix(pn))
    ret = {}
    for k, v of instances
      if window.instanceMap[k]? && window.instanceMap[k] instanceof ItemBase
        ret[k] = v

    return ret

  # ワークテーブル画面表示位置を取得する
  @getWorktableScrollContentsPosition = ->
    if window.scrollContents?
      key = @Key.worktableDisplayPosition()
      position = @getGeneralPageValue(key)
      if !position?
        position = {top: 0, left: 0}
      screenSize = @getGeneralPageValue(@Key.SCREEN_SIZE)
      if !screenSize?
        screenSize = {width: window.mainWrapper.width(), height: window.mainWrapper.height()}
      t = (window.scrollInsideWrapper.height() + screenSize.height) * 0.5 - position.top
      l = (window.scrollInsideWrapper.width() + screenSize.width) * 0.5 - position.left
      return {top: t, left: l}
    else
      return null

  # ワークテーブル画面表示位置を設定する
  # @param [Float] top ScrollViewのY座標
  # @param [Float] left ScrollViewのX座標
  @setWorktableDisplayPosition = (top, left) ->
    screenSize = @getGeneralPageValue(@Key.SCREEN_SIZE)
    if !screenSize?
      screenSize = {width: window.mainWrapper.width(), height: window.mainWrapper.height()}
    t = (window.scrollInsideWrapper.height() + screenSize.height) * 0.5 - top
    l = (window.scrollInsideWrapper.width() + screenSize.width) * 0.5 - left
    # 中央位置からの差を設定
    key = @Key.worktableDisplayPosition()
    @setGeneralPageValue(key, {top: t, left: l})

  # 対象イベントを削除する
  # @param [Integer] eNum 削除するイベント番号
  @removeEventPageValue = (eNum) ->
    eventPageValues = @getEventPageValueSortedListByNum()
    if eventPageValues.length >= 2
      for i in [0..(eventPageValues.length - 1)]
        if i >= eNum - 1
          eventPageValues[i] = eventPageValues[i + 1]

    @setEventPageValue(@Key.eventPageMainRoot(), {})
    if eventPageValues.length >= 2
      for idx in [0..(eventPageValues.length - 2)]
        @setEventPageValue(@Key.eventNumber(idx + 1), eventPageValues[idx])
    @setEventPageValue(@Key.eventCount(), eventPageValues.length - 1)

  # 対象イベントのSyncを解除する
  # @param [Integer] objId オブジェクトID
  @removeEventPageValueSync = (objId) ->
    tes = @getEventPageValueSortedListByNum()
    dFlg = false
    type = null
    for te, idx in tes
      if te.id == objId
        dFlg = true
        type = te.actiontype
      else
        if dFlg && type == te[EventPageValueBase.PageValueKey.ACTIONTYPE]
          te[EventPageValueBase.PageValueKey.IS_SYNC] = false
          @setEventPageValue(@Key.eventNumber(idx + 1), te)
          dFlg = false
          type = null

  # Footprintに保存
  @saveToFootprint: (targetObjId, isChangeBefore, eventDistNum, pageNum = PageValue.getPageNum()) ->
    @saveInstanceObjectToFootprint(targetObjId, isChangeBefore, eventDistNum, pageNum)
    #@saveCommonStateToFootprint(isChangeBefore, eventDistNum, pageNum)

  # インスタンスの変数値を保存
  @saveInstanceObjectToFootprint: (targetObjId, isChangeBefore, eventDistNum, pageNum = PageValue.getPageNum()) ->
    # オブジェクト
    obj = window.instanceMap[targetObjId]
    key = if isChangeBefore then @Key.footprintInstanceBefore(eventDistNum, targetObjId, pageNum) else @Key.footprintInstanceAfter(eventDistNum, targetObjId, pageNum)
    @setFootprintPageValue(key, obj.getMinimumObject())

  # 共通インスタンスの変数値を保存
  # FIXME: 未使用
  @saveCommonStateToFootprint: (isChangeBefore, eventDistNum, pageNum = PageValue.getPageNum()) ->
    # 画面State
    se = new ScreenEvent()
    footprint = {}
    footprint[se.id] = se.getMinimumObject()
    key = if isChangeBefore then @Key.footprintCommonBefore(eventDistNum, pageNum) else @Key.footprintCommonAfter(eventDistNum, pageNum)
    @setFootprintPageValue(key, footprint)

  # 全ての操作履歴を削除
  @removeAllFootprint: ->
    @setFootprintPageValue(@Key.F_PREFIX, {})