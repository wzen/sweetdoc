class PageValue

  # ページが持つ値を取得
  # @param [String] key キー値
  # @param [Boolean] withRemove 取得後に値を消去するか
  @getPageValue = (key, withRemove = false) ->
    _getPageValue.call(@, key, withRemove, Constant.PageValueKey.PV_ROOT)

  # タイムラインの値を取得
  # @param [String] key キー値
  @getTimelinePageValue = (key) ->
    _getPageValue.call(@, key, false, Constant.PageValueKey.TE_ROOT)

  # 共通設定値を取得
  # @param [String] key キー値
  @getSettingPageValue = (key) ->
    _getPageValue.call(@, key, false, Setting.PageValueKey.ROOT)

  # ページが持つ値を取得
  # @param [String] key キー値
  # @param [Boolean] withRemove 取得後に値を消去するか
  # @param [String] rootId Root要素ID
  # @return [Object] ハッシュ配列または値で返す
  _getPageValue = (key, withRemove, rootId) ->
    f = @
    # div以下の値をハッシュとしてまとめる
    takeValue = (element) ->
      ret = null
      c = $(element).children()
      if c? && c.length > 0
        $(c).each((e) ->
          k = @.classList[0]
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

          if jQuery.type(ret) == "array" && jQuery.isNumeric(k)
            k = Number(k)
          ret[k] = v
          return true
        )
        return ret
      else
        return null

    value = null
    root = $("##{rootId}")
    keys = key.split(Constant.PageValueKey.PAGE_VALUES_SEPERATOR)
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
          value = takeValue.call(f,root)
        if withRemove
          root.remove()
    )
    return value

  # ページが持つ値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] isCache このページでのみ保持させるか
  @setPageValue = (key, value, isCache = false) ->
    _setPageValue.call(@, key, value, isCache, Constant.PageValueKey.PV_ROOT, false)

  # タイムラインの値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  @setTimelinePageValue = (key, value) ->
    _setPageValue.call(@, key, value, false, Constant.PageValueKey.TE_ROOT, true)

  # 共通設定値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] giveName name属性を付与するか
  @setSettingPageValue = (key, value, giveName = false) ->
    _setPageValue.call(@, key, value, false, Setting.PageValueKey.ROOT, giveName)

  # ページが持つ値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  # @param [Boolean] isCache このページでのみ保持させるか
  # @param [String] rootId Root要素ID
  # @param [Boolean] giveName name属性を付与するか
  _setPageValue = (key, value, isCache, rootId, giveName) ->
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

        if ky == 'w'
          console.log(val)

        return "<input type='hidden' class='#{ky}' value='#{val}' #{name} />"

      ret = ""
      for k, v of val
        ret += makeElementStr.call(f, k, v, kyName)

      return "<div class=#{ky}>#{ret}</div>"

    cacheClassName = 'cache'
    root = $("##{rootId}")
    parentClassName = null
    keys = key.split(Constant.PageValueKey.PAGE_VALUES_SEPERATOR)
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

  # ソートしたタイムラインリストを取得
  @getTimelinePageValueSortedListByNum = ->
    timelinePageValues = PageValue.getTimelinePageValue(Constant.PageValueKey.TE_PREFIX)
    if !timelinePageValues?
      return []

    count = PageValue.getTimelinePageValue(Constant.PageValueKey.TE_COUNT)
    timelineList = new Array(count)

    # ソート
    for k, v of timelinePageValues
      if k.indexOf(Constant.PageValueKey.TE_NUM_PREFIX) == 0
        index = parseInt(k.substring(Constant.PageValueKey.TE_NUM_PREFIX.length)) - 1
        timelineList[index] = v

    return timelineList

  # ページが持つ値を削除
  # @param [String] key キー値
  @removePageValue = (key) ->
    # 削除ありで取得
    @getPageValue(key, true)

  # アイテムとイベント情報を削除
  @removeAllItemAndTimelineEventPageValue = ->
    $("##{Constant.PageValueKey.PV_ROOT}").each((e) ->
      $(@).remove()
    )
    $("##{Constant.PageValueKey.TE_ROOT}").each((e) ->
      $(@).remove()
    )
