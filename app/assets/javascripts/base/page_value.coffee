class PageValue

  if gon?
  # 定数
    constant = gon.const
    # ページ内値保存キー
    class @Key
      # @property [String] PV_ROOT ページ値ルート
      @PV_ROOT = constant.PageValueKey.PV_ROOT
      # @property [String] E_ROOT イベント値ルート
      @E_ROOT = constant.PageValueKey.E_ROOT
      # @property [String] E_PREFIX イベントプレフィックス
      @E_PREFIX = constant.PageValueKey.E_PREFIX
      # @property [String] E_COUNT イベント数
      @E_COUNT = constant.PageValueKey.E_COUNT
      # @property [String] E_CSS CSSデータ
      @E_CSS = constant.PageValueKey.E_CSS
      # @property [String] PAGE_VALUES_SEPERATOR ページ値のセパレータ
      @PAGE_VALUES_SEPERATOR = constant.PageValueKey.PAGE_VALUES_SEPERATOR
      # @property [String] E_NUM_PREFIX イベント番号プレフィックス
      @E_NUM_PREFIX = constant.PageValueKey.E_NUM_PREFIX
      # @property [String] ITEM_PREFIX アイテムプレフィックス
      @ITEM_PREFIX = 'item'
      # @property [String] ITEM アイテムRoot
      @ITEM_VALUE = @ITEM_PREFIX + ':@id:value'
      # @property [String] ITEM アイテムキャッシュRoot
      @ITEM_VALUE_CACHE = @ITEM_PREFIX + ':cache:@id:value'
      # @property [String] ITEM_INFO_PREFIX アイテム情報プレフィックス
      @ITEM_INFO_PREFIX = 'iteminfo'
      # @property [String] ITEM_DEFAULT_METHODNAME デフォルトメソッド名
      @ITEM_DEFAULT_METHODNAME = @ITEM_INFO_PREFIX + ':@item_id:default:methodname'
      # @property [String] ITEM_DEFAULT_METHODACTIONTYPE デフォルトアクションタイプ
      @ITEM_DEFAULT_ACTIONTYPE = @ITEM_INFO_PREFIX + ':@item_id:default:actiontype'
      # @property [String] ITEM_DEFAULT_ANIMATIONTYPE デフォルトアニメーションタイプ
      @ITEM_DEFAULT_ANIMATIONTYPE = @ITEM_INFO_PREFIX + ':@item_id:default:animationtype'
      # @property [String] CONFIG_OPENED_SCROLL コンフィグ表示時のスクロール位置保存
      @CONFIG_OPENED_SCROLL = 'config_opened_scroll'
      # @property [String] IS_RUNWINDOW_RELOAD Runビューをリロードしたか
      @IS_RUNWINDOW_RELOAD = constant.PageValueKey.IS_RUNWINDOW_RELOAD


# サーバから読み込んだアイテム情報を追加
  @addItemInfo = (item_id, te_actions) ->
    if te_actions? && te_actions.length > 0
      te_actions.forEach( (a) =>
        if a.is_default? && a.is_default
          # デフォルトメソッド & デフォルトアクションタイプ
          @setPageValue(@Key.ITEM_DEFAULT_METHODNAME.replace('@item_id', item_id), a.method_name)
          @setPageValue(@Key.ITEM_DEFAULT_ACTIONTYPE.replace('@item_id', item_id), a.action_event_type_id)
          @setPageValue(@Key.ITEM_DEFAULT_ANIMATIONTYPE.replace('@item_id', item_id), a.action_animation_type_id)
      )

  # ページが持つ値を取得
  # @param [String] key キー値
  # @param [Boolean] withRemove 取得後に値を消去するか
  @getPageValue = (key, withRemove = false) ->
    _getPageValue.call(@, key, withRemove, @Key.PV_ROOT)

  # イベントの値を取得
  # @param [String] key キー値
  @getEventPageValue = (key) ->
    _getPageValue.call(@, key, false, @Key.E_ROOT)

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
    _setPageValue.call(@, key, value, isCache, @Key.PV_ROOT, false)

  # イベントの値を設定
  # @param [String] key キー値
  # @param [Object] value 設定値(ハッシュ配列または値)
  @setEventPageValue = (key, value) ->
    _setPageValue.call(@, key, value, false, @Key.E_ROOT, true)

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

  # ソートしたイベントリストを取得
  @getEventPageValueSortedListByNum = ->
    eventPageValues = PageValue.getEventPageValue(@Key.E_PREFIX)
    if !eventPageValues?
      return []

    count = PageValue.getEventPageValue(@Key.E_COUNT)
    eventObjList = new Array(count)

    # ソート
    for k, v of eventPageValues
      if k.indexOf(@Key.E_NUM_PREFIX) == 0
        index = parseInt(k.substring(@Key.E_NUM_PREFIX.length)) - 1
        eventObjList[index] = v

    return eventObjList

  # ページが持つ値を削除
  # @param [String] key キー値
  @removePageValue = (key) ->
    # 削除ありで取得
    @getPageValue(key, true)

  # アイテムとイベント情報を削除
  @removeAllItemAndEventPageValue = ->
    # page_value消去
    $("##{@Key.PV_ROOT}").children(".#{@Key.ITEM_PREFIX}").remove()
    $("##{@Key.E_ROOT}").children().remove()
