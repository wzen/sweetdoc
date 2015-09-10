# PageValue
class PageValue

  if gon?
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
      # @property [return] 現在のページのページ番号プレフィックス
      @pagePrefix = (pn = PageValue.getPageNum()) -> @P_PREFIX + pn
      # @property [String] PAGE_COUNT ページ総数
      @PAGE_COUNT = constant.PageValueKey.PAGE_COUNT
      # @property [String] PAGE_NUM 現在のページ番号
      @PAGE_NUM = constant.PageValueKey.PAGE_NUM
      # @property [String] IS_ROOT ページ値ルート
      @IS_ROOT = constant.PageValueKey.IS_ROOT
      # @property [String] INSTANCE_PREFIX インスタンスプレフィックス
      @INSTANCE_PREFIX = constant.PageValueKey.INSTANCE_PREFIX
      # @property [return] インスタンスページプレフィックスを取得
      @instancePagePrefix = (pn = PageValue.getPageNum()) -> @INSTANCE_PREFIX + @PAGE_VALUES_SEPERATOR + @pagePrefix(pn)
      # @property [String] INSTANCE_VALUE_ROOT インスタンスROOT
      @INSTANCE_VALUE_ROOT = constant.PageValueKey.INSTANCE_VALUE_ROOT
      # @property [return] インスタンス値
      @instanceValue = (objId) -> @instancePagePrefix() + @PAGE_VALUES_SEPERATOR + objId + @PAGE_VALUES_SEPERATOR + @INSTANCE_VALUE_ROOT
      # @property [return] インスタンスキャッシュ値
      @instanceValueCache = (objId) -> @instancePagePrefix() + @PAGE_VALUES_SEPERATOR + 'cache' + @PAGE_VALUES_SEPERATOR + objId + @PAGE_VALUES_SEPERATOR + @INSTANCE_VALUE_ROOT
      # @property [String] ITEM_INFO_PREFIX アイテム情報プレフィックス
      @ITEM_INFO_PREFIX = 'iteminfo'
      # @property [String] ITEM_DEFAULT_METHODNAME デフォルトメソッド名
      @ITEM_DEFAULT_METHODNAME = @ITEM_INFO_PREFIX + ':@item_id:default:methodname'
      # @property [String] ITEM_DEFAULT_METHODACTIONTYPE デフォルトアクションタイプ
      @ITEM_DEFAULT_ACTIONTYPE = @ITEM_INFO_PREFIX + ':@item_id:default:actiontype'
      # @property [String] ITEM_DEFAULT_ANIMATIONTYPE デフォルトアニメーションタイプ
      @ITEM_DEFAULT_ANIMATIONTYPE = @ITEM_INFO_PREFIX + ':@item_id:default:animationtype'
      # @property [String] ITEM_DEFAULT_ANIMATIONTYPE デフォルトアニメーションタイプ
      @ITEM_DEFAULT_SCROLL_ENABLED_DIRECTION = @ITEM_INFO_PREFIX + ':@item_id:default:scroll_enabled_direction'
      # @property [String] ITEM_DEFAULT_ANIMATIONTYPE デフォルトアニメーションタイプ
      @ITEM_DEFAULT_SCROLL_FORWARD_DIRECTION = @ITEM_INFO_PREFIX + ':@item_id:default:scroll_forward_direction'
      # @property [String] E_ROOT イベント値ルート
      @E_ROOT = constant.PageValueKey.E_ROOT
      # @property [String] E_PREFIX イベントプレフィックス
      @E_PREFIX = constant.PageValueKey.E_PREFIX
      # @property [return] イベントページプレフィックス
      @eventPagePrefix = (pn = PageValue.getPageNum()) -> @E_PREFIX + @PAGE_VALUES_SEPERATOR + @pagePrefix(pn)
      # @property [return] イベント数
      @eventCount = (pn = PageValue.getPageNum()) -> "#{@E_PREFIX}#{@PAGE_VALUES_SEPERATOR}#{@pagePrefix(pn)}#{@PAGE_VALUES_SEPERATOR}count"
      # @property [String] E_NUM_PREFIX イベント番号プレフィックス
      @E_NUM_PREFIX = constant.PageValueKey.E_NUM_PREFIX
      # @property [String] IS_RUNWINDOW_RELOAD Runビューをリロードしたか
      @IS_RUNWINDOW_RELOAD = constant.PageValueKey.IS_RUNWINDOW_RELOAD
      # @property [String] UPDATED 更新フラグ
      @UPDATED = 'updated'

  # サーバから読み込んだアイテム情報を追加
  # @param [Integer] itemId アイテムID
  # @param [Array] itemInfos アイテム情報
  @addItemInfo = (itemId, itemInfos) ->
    if itemInfos? && itemInfos.length > 0
      isSet = false
      itemInfos.forEach( (itemInfo) =>
        if itemInfo.is_default? && itemInfo.is_default
          # デフォルトメソッド & デフォルトアクションタイプ
          @setInstancePageValue(@Key.ITEM_DEFAULT_METHODNAME.replace('@item_id', itemId), itemInfo.method_name)
          @setInstancePageValue(@Key.ITEM_DEFAULT_ACTIONTYPE.replace('@item_id', itemId), itemInfo.action_event_type_id)
          @setInstancePageValue(@Key.ITEM_DEFAULT_ANIMATIONTYPE.replace('@item_id', itemId), itemInfo.action_animation_type_id)
          @setInstancePageValue(@Key.ITEM_DEFAULT_SCROLL_ENABLED_DIRECTION.replace('@item_id', itemId), if itemInfo.scroll_enabled_direction? then JSON.parse(itemInfo.scroll_enabled_direction) else null)
          @setInstancePageValue(@Key.ITEM_DEFAULT_SCROLL_FORWARD_DIRECTION.replace('@item_id', itemId), if itemInfo.scroll_forward_direction? then JSON.parse(itemInfo.scroll_forward_direction) else null)
          isSet = true
      )
      if isSet
        LocalStorage.saveInstancePageValue()

  # 汎用値を取得
  # @param [String] key キー値
  # @param [Boolean] updateOnly updateクラス付与のみ取得するか
  @getGeneralPageValue = (key, updateOnly = false) ->
    _getPageValue.call(@, key, @Key.G_ROOT, updateOnly)

  # インスタンス値を取得
  # @param [String] key キー値
  # @param [Boolean] updateOnly updateクラス付与のみ取得するか
  @getInstancePageValue = (key, updateOnly = false) ->
    _getPageValue.call(@, key, @Key.IS_ROOT, updateOnly)

  # イベントの値を取得
  # @param [String] key キー値
  # @param [Boolean] updateOnly updateクラス付与のみ取得するか
  @getEventPageValue = (key, updateOnly = false) ->
    _getPageValue.call(@, key, @Key.E_ROOT, updateOnly)

  # 共通設定値を取得
  # @param [String] key キー値
  # @param [Boolean] updateOnly updateクラス付与のみ取得するか
  @getSettingPageValue = (key, updateOnly = false) ->
    _getPageValue.call(@, key, Setting.PageValueKey.ROOT, updateOnly)

  # ページが持つ値を取得
  # @param [String] key キー値
  # @param [String] rootId Root要素ID
  # @param [Boolean] updateOnly updateクラス付与のみ取得するか
  # @return [Object] ハッシュ配列または値で返す
  _getPageValue = (key, rootId, updateOnly) ->
    f = @
    # div以下の値をハッシュとしてまとめる
    takeValue = (element, hasUpdate) ->
      ret = null
      c = $(element).children()
      if c? && c.length > 0
        $(c).each((e) ->
          cList = @.classList
          hu = hasUpdate
          if $(@).hasClass(PageValue.Key.UPDATED)
            # updateフラグを持っている場合はフラグON & クラス一覧から除外
            hu = true
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
            # updateのみ取得 & updateフラグが無い場合はデータ取らない
            if (updateOnly && !hasUpdate) == false
              # サニタイズをデコード
              v = Common.sanitaizeDecode($(@).val())
              if jQuery.isNumeric(v)
                v = Number(v)
              else if v == "true" || v == "false"
                v = if v == "true" then true else false
          else
            v = takeValue.call(f, @, hu)

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
    hasUpdate = false
    root = $("##{rootId}")
    keys = key.split(@Key.PAGE_VALUES_SEPERATOR)
    keys.forEach((k, index) ->
      root = $(".#{k}", root)
      if $(root).hasClass(PageValue.Key.UPDATED)
        hasUpdate = true
      if !root? || root.length == 0
        value = null
        return
      if keys.length - 1 == index
        if root[0].tagName == "INPUT"
          # updateのみ取得 & updateフラグが無い場合はデータ取らない
          if (updateOnly && !hasUpdate) == false
            value = Common.sanitaizeDecode(root.val())
            if jQuery.isNumeric(value)
              value = Number(value)
          else
            return null
        else
          value = takeValue.call(f, root, hasUpdate)
    )
    return value

  # 汎用値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] giveUpdate update属性を付与するか
  @setGeneralPageValue = (key, value, giveUpdate = false) ->
    _setPageValue.call(@, key, value, false, @Key.G_ROOT, true, giveUpdate)

  # インスタンス値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] isCache このページでのみ保持させるか
  # @param [Boolean] giveUpdate update属性を付与するか
  @setInstancePageValue = (key, value, isCache = false, giveUpdate = false) ->
    _setPageValue.call(@, key, value, isCache, @Key.IS_ROOT, true, giveUpdate)

  # イベントの値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] giveUpdate update属性を付与するか
  @setEventPageValue = (key, value, giveUpdate = false) ->
    _setPageValue.call(@, key, value, false, @Key.E_ROOT, true, giveUpdate)

  # イベントの値をルート値から設定
  # @param [Object] value 設定値(E_PREFIXで取得したハッシュ配列または値)
  # @param [Boolean] refresh イベント要素を全て入れ替える
  # @param [Boolean] giveUpdate update属性を付与するか
  @setEventPageValueByRootHash = (value, refresh = true, giveUpdate = false) ->
    if refresh
      # 内容を一旦消去
      $("##{@Key.E_ROOT}").children(".#{@Key.E_PREFIX}").remove()
    for k, v of value
      @setEventPageValue(PageValue.Key.E_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v, giveUpdate)


  # イベントの値をページルート値から設定
  # @param [Object] value 設定値(E_PREFIXで取得したハッシュ配列または値)
  # @param [Boolean] refresh イベント要素を全て入れ替える
  # @param [Boolean] giveUpdate update属性を付与するか
  @setEventPageValueByPageRootHash = (value, refresh = true, giveUpdate = false) ->
    if refresh
      # 内容を一旦消去
      $("##{@Key.E_ROOT}").children(".#{@Key.E_PREFIX}").children(".#{@Key.pagePrefix()}").remove()
    for k, v of value
      @setEventPageValue(PageValue.Key.eventPagePrefix() + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v, giveUpdate)

  # 共通設定値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] giveName name属性を付与するか
  # @param [Boolean] giveUpdate update属性を付与するか
  @setSettingPageValue = (key, value, giveUpdate = false) ->
    _setPageValue.call(@, key, value, false, Setting.PageValueKey.ROOT, true, giveUpdate)

  # ページが持つ値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] isCache このページでのみ保持させるか
  # @param [String] rootId Root要素ID
  # @param [Boolean] giveName name属性を付与するか
  # @param [Boolean] giveUpdate update属性を付与するか
  _setPageValue = (key, value, isCache, rootId, giveName, giveUpdate) ->
    f = @
    # ハッシュを要素の文字列に変換
    makeElementStr = (ky, val, kyName) ->
      if val == null || val == "null"
        return ''

      kyName += "[#{ky}]"
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
        if giveUpdate
          # 親要素にupdateクラスを付与
          parent.addClass(PageValue.Key.UPDATED)
        root = jQuery(makeElementStr.call(f, k, value, parentClassName)).appendTo(parent)
        if isCache
          root.addClass(cacheClassName)
    )

  # インスタンス値を削除
  # @param [Integer] objId オブジェクトID
  @removeInstancePageValue = (objId) ->
    $("##{@Key.IS_ROOT} .#{objId}").remove()

  # updateが付与しているクラスからupdateクラスを除去する
  @clearAllUpdateFlg = ->
    $("##{@Key.IS_ROOT}").find(".#{PageValue.Key.UPDATED}").removeClass(PageValue.Key.UPDATED)
    $("##{@Key.E_ROOT}").find(".#{PageValue.Key.UPDATED}").removeClass(PageValue.Key.UPDATED)
    $("##{Setting.PageValueKey.ROOT}").find(".#{PageValue.Key.UPDATED}").removeClass(PageValue.Key.UPDATED)

  # イベント番号で昇順ソートした配列を取得
  # @param [Integer] pn ページ番号
  @getEventPageValueSortedListByNum = (pn = PageValue.getPageNum()) ->
    eventPageValues = PageValue.getEventPageValue(@Key.eventPagePrefix(pn))
    if !eventPageValues?
      return []

    count = PageValue.getEventPageValue(@Key.eventCount(pn))
    eventObjList = new Array(count)

    # 番号でソート
    for k, v of eventPageValues
      if k.indexOf(@Key.E_NUM_PREFIX) == 0
        index = parseInt(k.substring(@Key.E_NUM_PREFIX.length)) - 1
        eventObjList[index] = v

    return eventObjList

  # 読み込み済みItemId取得
  @getLoadedItemIds = ->
    ret = []
    # インスタンスPageValueを参照
    itemInfoPageValues = PageValue.getInstancePageValue(@Key.ITEM_INFO_PREFIX)
    for k, v of itemInfoPageValues
      if $.inArray(parseInt(k), ret) < 0
        ret.push(parseInt(k))
    return ret

  # アイテムとイベント情報を全削除
  @removeAllItemAndEventPageValue = ->
    # page_value消去
    $("##{@Key.G_ROOT}").children(".#{@Key.G_PREFIX}").remove()
    $("##{@Key.IS_ROOT}").children(".#{@Key.INSTANCE_PREFIX}").remove()
    $("##{@Key.E_ROOT}").children(".#{@Key.E_PREFIX}").remove()

  # ページ上のアイテムとイベント情報を全削除
  @removeAllItemAndEventPageValueOnThisPage = ->
    # ページ内のpage_value消去
    $("##{@Key.IS_ROOT}").children(".#{@Key.INSTANCE_PREFIX}").children(".#{@Key.pagePrefix()}").remove()
    $("##{@Key.E_ROOT}").children(".#{@Key.E_PREFIX}").children(".#{@Key.pagePrefix()}").remove()

  # InstancePageValueとEventPageValueを最適化
  @adjustInstanceAndEventOnThisPage = ->
    iPageValues = @getInstancePageValue(PageValue.Key.instancePagePrefix())
    instanceObjIds = []
    for k, v of iPageValues
      if $.inArray(v.value.id, instanceObjIds) < 0
        instanceObjIds.push(v.value.id)
    ePageValues = @getEventPageValue(PageValue.Key.eventPagePrefix())
    adjust = {}
    teCount = 0
    for k, v of ePageValues
      if k.indexOf(@Key.E_NUM_PREFIX) == 0
        if $.inArray(v[EventPageValueBase.PageValueKey.ID], instanceObjIds) >= 0
          teCount += 1
          adjust[@Key.E_NUM_PREFIX + teCount] = v
      else
        adjust[k] = v

    @setEventPageValueByPageRootHash(adjust)
    PageValue.setEventPageValue(@Key.eventCount(), teCount)

  # ページ総数更新
  @updatePageCount = ->
    page_count = 0
    ePageValues = @getEventPageValue(@Key.E_PREFIX)
    for k, v of ePageValues
      if k.indexOf(@Key.P_PREFIX) >= 0
        page_count += 1

    if page_count == 0
      # 初期表示時のページ総数は1
      page_count = 1
    @setGeneralPageValue("#{@Key.G_PREFIX}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.PAGE_COUNT}", page_count)

  # ページ総数を取得
  @getPageCount = ->
    ret = PageValue.getGeneralPageValue("#{@Key.G_PREFIX}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.PAGE_COUNT}")
    if ret?
      return parseInt(ret)
    else
      return 1

  # 現在のページ番号を取得
  @getPageNum = ->
    ret = PageValue.getGeneralPageValue("#{@Key.G_PREFIX}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.PAGE_NUM}")
    if ret?
      ret = parseInt(ret)
    else
      ret = 1
      @setPageNum(ret)
    return ret

  # 現在のページ番号を設定
  @setPageNum = (num) ->
    #window.pn = null
    PageValue.setGeneralPageValue("#{@Key.G_PREFIX}#{@Key.PAGE_VALUES_SEPERATOR}#{@Key.PAGE_NUM}", parseInt(num))

  # 現在のページ番号を追加
  @addPagenum = (addNum) ->
    @setPageNum(@getPageNum() + addNum)

  # アイテムのCSSを取得
  @itemCssOnPage = (pageNum) ->
    eventPageValues = PageValue.getEventPageValue(@Key.eventPagePrefix(pageNum))
    css = ''
    for k, v of eventPageValues
      if k.indexOf(@Key.E_NUM_PREFIX) == 0
        index = parseInt(k.substring(@Key.E_NUM_PREFIX.length)) - 1
        objId = v.id
        instance = PageValue.getInstancePageValue(@Key.instanceValue(objId))
        if instance.css?
          css += instance.css
    return css

  # 対象アイテムのSyncを解除する
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
          te[EventPageValueBase.PageValueKey.IS_PARALLEL] = false
          @setEventPageValue(@Key.eventPagePrefix() + @Key.PAGE_VALUES_SEPERATOR + @Key.E_NUM_PREFIX + (idx + 1), te)
          dFlg = false
          type = null
