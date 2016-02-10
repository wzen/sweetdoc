# アプリ内の共通メソッドクラス
class Common
  @scaleFromViewRate = 1.0

  constant = gon.const
  # @property [String] MAIN_TEMP_ID mainコンテンツテンプレート
  @MAIN_TEMP_ID = constant.ElementAttribute.MAIN_TEMP_ID

  # ブラウザ対応のチェック
  # @return [Boolean] 処理結果
  @checkBlowserEnvironment = ->
    if !localStorage
      return false
    else
      try
        localStorage.setItem('test', 'test')
        c = localStorage.getItem('test')
        localStorage.removeItem('test')
      catch e
        return false
    if !File
      return false
    if !window.URL
      return false
    return true

  # 変数の型チェック
  # @return [string] 型
  @typeOfValue = do ->
    classToType = {}
    for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
      classToType["[object " + name + "]"] = name.toLowerCase()
    (obj) ->
      strType = Object::toString.call(obj)
      classToType[strType] or "object"

  # イベントのIDを作成
  # @return [Int] 生成したID
  @generateId = ->
    numb = 10 #10文字
    RandomString = '';
    BaseString ='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    n = 62
    for i in [0..numb]
      RandomString += BaseString.charAt( Math.floor( Math.random() * n))
    return RandomString

  # オブジェクトの比較
  @isEqualObject: (obj1, obj2) ->
    _func = (o1, o2) ->
      if typeof o1 != typeof o2
        return false
      else if typeof o1 != 'object'
        return o1 == o2
      else
        if Object.keys(o1).length != Object.keys(o2).length
          return false
        ret = true
        for k, v of o1
          if _func(v, o2[k]) == false
            ret = false
            break
        return ret
    return _func(obj1, obj2)

  @diffEventObject: (obj1, obj2) ->
    _func = (o1, o2) ->
      if !o1?
        return o2
      if typeof o1 != typeof o2
        return o2
      else if typeof o1 != 'object'
        if o1 != o2
          return o2
        else
          # 一致
          return null
      else
        ret = {}
        for k, v of o2
          f = _func(o1[k], v)
          if f?
            ret[k] = f
        return if Object.keys(ret).length > 0 then ret else null
    obj = _func(obj1, obj2)
    if window.debug
      console.log('diffEventObject')
      console.log(obj)
    return obj

  # オブジェクトがHTML要素か判定
  @isElement: (obj) ->
    return (typeof obj == "object") && (obj.length == 1) && obj.get? && (obj.get(0).nodeType ==1) && (typeof obj.get(0).style == "object") && (typeof obj.get(0).ownerDocument == "object")

  @ajaxError: (responseData) ->
    if responseData.status == '422'
      # 再表示
      location.reload(false)

  # requestAnimationFrameラッパー
  @requestAnimationFrame: ->
    originalWebkitRequestAnimationFrame = undefined
    wrapper = undefined
    callback = undefined
    geckoVersion = 0
    userAgent = navigator.userAgent
    index = 0
    self = @

    if window.webkitRequestAnimationFrame
      wrapper = (time) ->
        if !time?
          time = +new Date()
        self.callback(time);

      originalWebkitRequestAnimationFrame = window.webkitRequestAnimationFrame
      window.webkitRequestAnimationFrame = (callback, element) ->
        self.callback = callback
        originalWebkitRequestAnimationFrame(wrapper, element)

    if window.mozRequestAnimationFrame
      index = userAgent.indexOf('rv:')

      if userAgent.indexOf('Gecko') != -1
        geckoVersion = userAgent.substr(index + 3, 3);
        if geckoVersion == '2.0'
          window.mozRequestAnimationFrame = undefined;

    return window.requestAnimationFrame   ||
        window.webkitRequestAnimationFrame ||
        window.mozRequestAnimationFrame    ||
        window.oRequestAnimationFrame      ||
        window.msRequestAnimationFrame     ||
        (callback, element) ->
          window.setTimeout( ->
            start = +new Date()
            callback(start);
            finish = +new Date();
            self.timeout = 1000 / 60 - (finish - start)
          , self.timeout)

  # Pagevalueから環境を反映
  @applyEnvironmentFromPagevalue = ->
    # タイトル名設定
    Common.setTitle(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_NAME))
    # 画面サイズ設定
    @initScreenSize()
    # スクロール位置設定
    @initScrollContentsPosition()
    # スケール設定
    @applyViewScale()

  # 環境の反映をリセット
  @resetEnvironment = ->
    Common.setTitle('')
    @initScreenSize(true)

  # タイトルを設定
  @setTitle = (title_name) ->
    if title_name?
      Navbar.setTitle(title_name)
      if !window.isWorkTable
        RunCommon.setTitle(title_name)

  # スクリーンサイズを取得
  @getScreenSize = ->
    if $('body').hasClass('full_window')
      # 全画面の場合
      return {
        width: $(window).width()
        height: $(window).height()
      }
    else
      return PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)

  # プロジェクト表示サイズ設定
  @initScreenSize = (reset = false) ->
    size = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
    if !reset && size? && size.width? && size.height?
      css = {
        width: size.width
        height: size.height
      }
      $('#project_wrapper').css(css)
      # プロジェクトビュー & タイムラインを閉じる
      $('#project_wrapper').show()
      $('#timeline').show()
    else
      # プロジェクトビュー & タイムラインを閉じる
      $('#project_wrapper').hide()
      $('#timeline').hide()
      PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {})

    # Canvasサイズ更新
    @updateCanvasSize()

  # スクロール位置初期化
  @initScrollContentsPosition = ->
    if window.isWorkTable
      WorktableCommon.initScrollContentsPosition()
    else
      if ScreenEvent.hasInstanceCache()
        se = new ScreenEvent()
        @updateScrollContentsPosition(se.initConfigY, se.initConfigX)

  # 画面スケールの設定
  @applyViewScale = (isViewResize = false) ->
    if window.isWorkTable && !window.previewRunning
      # FIXME: Worktableの倍率にする
      window.mainWrapper.css({transform: '', width: "", height: ""})
      return

    worktableScale = 1.0
    if window.isWorkTable
      worktableScale = PageValue.getGeneralPageValue(PageValue.Key.worktableScale())
      if !worktableScale?
        worktableScale = 1.0
    seScale = 1.0
    if ScreenEvent.hasInstanceCache()
      se = new ScreenEvent()
      if isViewResize
        seScale = se.getNowProgressScale()
      else
        seScale = se.getNowScale()
    scale = worktableScale * Common.scaleFromViewRate * seScale
    updateMainWrapperPercent = 100 / Common.scaleFromViewRate
    window.mainWrapper.css({transform: "scale(#{scale}, #{scale})", width: "#{updateMainWrapperPercent}%", height: "#{updateMainWrapperPercent}%"})

  # Canvasサイズ更新
  @updateCanvasSize = ->
    if window.drawingCanvas?
      $(window.drawingCanvas).attr('width', $('#pages').width())
      $(window.drawingCanvas).attr('height', $('#pages').height())

  # リサイズイベント設定
  @initResize = (resizeEvent = null) ->
    $(window).resize( ->
      # モーダル中央寄せ
      Common.modalCentering()

      if resizeEvent?
        resizeEvent()
    )

  # オブジェクトの複製
  # @param [Object] obj 複製対象オブジェクト
  # @return [Object] 複製後オブジェクト
  @makeClone = (obj) ->
    if not obj? or typeof obj isnt 'object'
      return obj
    if obj instanceof Date
      return new Date(obj.getTime())
    if obj instanceof RegExp
      flags = ''
      flags += 'g' if obj.global?
      flags += 'i' if obj.ignoreCase?
      flags += 'm' if obj.multiline?
      flags += 'y' if obj.sticky?
      return new RegExp(obj.source, flags)
    newInstance = new obj.constructor()
    for key of obj
      newInstance[key] = clone obj[key]
    return newInstance

  # Mainコンテナを作成
  # @param [Integer] pageNum ページ番号
  # @param [Boolean] collapsed 初期表示でページを閉じた状態にするか
  # @return [Boolean] ページを作成したか
  @createdMainContainerIfNeeded: (pageNum, collapsed = false) ->
    root = $("##{Constant.Paging.ROOT_ID}")
    sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    pageSection = $(".#{sectionClass}", root)
    if !pageSection? || pageSection.length == 0
      # Tempからコピー
      temp = $("##{Common.MAIN_TEMP_ID}").children(':first').clone(true)
      style = ''
      style += "z-index:#{Common.plusPagingZindex(0, pageNum)};"
      # TODO: pageflipを変更したら修正すること
      width = if collapsed then 'width: 0px;' else ''
      style += width
      temp = $(temp).wrap("<div class='#{sectionClass} section' style='#{style}'></div>").parent()
      root.append(temp)
      return true
    else
      return false

  # Mainコンテナを削除
  # @param [Integer] pageNum ページ番号
  @removeMainContainer: (pageNum) ->
    root = $("##{Constant.Paging.ROOT_ID}")
    sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    $(".#{sectionClass}", root).remove()

  # ページ内のインスタンスを取得
  @instancesInPage = (pn = PageValue.getPageNum(), withCreateInstance = false, withInitFromPageValue = false) ->
    ret = []
    instances = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pn))
    for key, instance of instances
      value = instance.value
      if withCreateInstance
        obj = Common.getInstanceFromMap(value.id, value.classDistToken)
        if withInitFromPageValue
          obj.setMiniumObject(value)
      else
        obj = window.instanceMap[value.id]
      ret.push(obj)
    return ret

  # ページ内のアイテムインスタンスを取得
  @itemInstancesInPage = (pn = PageValue.getPageNum(), withCreateInstance = false, withInitFromPageValue = false) ->
    return $.grep(@instancesInPage(pn, withCreateInstance, withInitFromPageValue), (n) ->
      n instanceof ItemBase
    )

  # 最初にフォーカスするアイテムオブジェクトを取得
  @firstFocusItemObj = (pn = PageValue.getPageNum()) ->
    objs = @itemInstancesInPage(pn)
    obj = null
    for o in objs
      if o.visible && o.firstFocus
        obj = o
        return obj
    return obj

  # アイテム用のテンプレートHTMLをwrap
  @wrapCreateItemElement = (item, contents) ->
    w = """
      <div id="#{item.id}" class="item draggable resizable" style="position: absolute;top:#{item.itemSize.y}px;left:#{item.itemSize.x}px;width:#{item.itemSize.w }px;height:#{item.itemSize.h}px;z-index:#{Common.plusPagingZindex(item.zindex)}"><div class="item_wrapper"><div class='item_contents'></div></div></div>
    """
    return $(contents).wrap(w).closest('.item')

  # アイテムに対してフォーカスする
  # @param [Object] target 対象アイテム
  # @param [Fucntion] callback コールバック
  @focusToTarget = (target, callback = null, immediate = false, withUpdatePageValue = true) ->
    if !target? || target.length == 0
      # ターゲット無し
      return

    # col-xs-9 → 75% padding → 15px
    scrollContentsSize = @scrollContentsSizeUnderScreenEventScale()
    diff = {top: 0, left: 0}
    if $(target).get(0).offsetParent?
      diff =
        top: (scrollContents.scrollTop() + (scrollContentsSize.height - $(target).height()) * 0.5) - $(target).get(0).offsetTop
        left: (scrollContents.scrollLeft() + (scrollContentsSize.width - $(target).width()) * 0.5) - $(target).get(0).offsetLeft

    @updateScrollContentsPosition(scrollContents.scrollTop() + (scrollContentsSize.height * 0.5) - diff.top, scrollContents.scrollLeft() + (scrollContentsSize.width * 0.5) - diff.left, immediate, withUpdatePageValue, callback)

  # スクロール位置の更新
  # @param [Float] top Y中央値
  # @param [Float] left X中央値
  @updateScrollContentsPosition: (top, left, immediate = true, withUpdateScreenEventVar = true, callback = null) ->
    window.skipScrollEvent = true
    if withUpdateScreenEventVar
      Common.saveDisplayPosition(top, left, true)

    scrollContentsSize = @scrollContentsSizeUnderScreenEventScale()
    top -= scrollContentsSize.height * 0.5
    left -= scrollContentsSize.width * 0.5
    if immediate
      window.scrollContents.scrollTop(top)
      window.scrollContents.scrollLeft(left)
      window.skipScrollEvent = false
      if callback?
        callback()
    else
      window.scrollContents.animate(
        {
          scrollTop: top
          scrollLeft: left
        }
      , 500, ->
        window.skipScrollEvent = false
        if callback?
          callback()
      )

  # スクロール位置を中心に初期化
  @resetScrollContentsPositionToCenter: (withUpdateScreenEventVar = true) ->
    top = window.scrollInsideWrapper.height() * 0.5
    left = window.scrollInsideWrapper.width() * 0.5
    @updateScrollContentsPosition(top, left, true, withUpdateScreenEventVar)

  @saveDisplayPosition = (top, left, immediate = true, callback = null) ->
    _save = ->
      if ScreenEvent?
        ScreenEvent.PrivateClass.setNowXAndY(left, top)
      if window.isWorkTable
        PageValue.setWorktableDisplayPosition(top, left)
      LocalStorage.saveAllPageValues()
      if callback?
        callback()

    if immediate
      _save.call(@)
    else
      if window.scrollContentsScrollTimer?
        clearTimeout(window.scrollContentsScrollTimer)
      window.scrollContentsScrollTimer = setTimeout( ->
        setTimeout( =>
          _save.call(@)
          window.scrollContentsScrollTimer = null
        , 0)
      , 500)

  @scrollContentsSizeUnderScreenEventScale = ->
    scale = 1.0
    if ScreenEvent.hasInstanceCache()
      se = new ScreenEvent()
      scale = se.getNowScale()
      if se._keepDispMag? && se._keepDispMag
        scale = 1.0
    return {
      width: window.scrollContents.width() / scale
      height: window.scrollContents.height() / scale
    }

  # 画面位置をScreenEvent変数から初期化
  @updateScrollContentsFromScreenEventVar: ->
    se = new ScreenEvent()
    @updateScrollContentsPosition(se.nowY, se.nowX)

  # ワークテーブル画面位置をPageValueから初期化
  @updateWorktableScrollContentsFromPageValue: ->
    position = PageValue.getWorktableScrollContentsPosition()
    if !position?
      # 値が存在しない場合は中心で初期化
      @resetScrollContentsPositionToCenter()
    else
      @updateScrollContentsPosition(position.top, position.left)

  # サニタイズ エンコード
  # @property [String] str 対象文字列
  # @return [String] 変換後文字列
  @sanitaizeEncode =  (str) ->
    if str? && typeof str == "string"
      return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    else
      return str

  # サニタイズ デコード
  # @property [String] str 対象文字列
  # @return [String] 変換後文字列
  @sanitaizeDecode = (str) ->
    if str? && typeof str == "string"
      return str.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, '\'').replace(/&amp;/g, '&');
    else
      return str

  # クラスハッシュ配列からクラスを取り出し
  # @param [Integer] dist ClassDistToken
  # @return [Object] 対象クラス
  @getClassFromMap = (dist) ->
    if !window.classMap?
      window.classMap = {}
    d = dist
    if typeof d != "string"
      d = String(dist)
    return window.classMap[d]

  # クラスをハッシュ配列に保存
  # @param [Integer] id EventIdまたはClassDistToken
  # @param [Class] value クラス
  @setClassToMap = (dist, value) ->
    d = dist
    if typeof d != "string"
      d = String(dist)

    if !window.classMap?
      window.classMap = {}
    window.classMap[d] = value

  # 実体のクラスを取得(共通イベントの場合はPrivateClassを参照する)
  @getContentClass = (classDistToken) ->
    cls = @getClassFromMap(classDistToken)
    if cls.prototype instanceof CommonEvent
      return cls.PrivateClass
    else
      return cls

  # インスタンス取得
  # @param [Integer] id イベントID
  # @param [Integer] classDistToken
  # @return [Object] インスタンス
  @getInstanceFromMap = (id, classDistToken) ->
    if typeof id != "string"
      id = String(id)
    Common.setInstanceFromMap(id, classDistToken)
    return window.instanceMap[id]

  # インスタンス設定(上書きはしない)
  # @param [Integer] id イベントID
  # @param [Integer] classDistToken
  @setInstanceFromMap = (id, classDistToken) ->
    if typeof id != "string"
      id = String(id)

    if !window.instanceMap?
      window.instanceMap = {}
    if !window.instanceMap[id]?
      # インスタンスを保存する
      instance = new (Common.getClassFromMap(classDistToken))()
      instance.id = id
      # インスタンス値が存在する場合、初期化
      obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(id))
      if obj
        instance.setMiniumObject(obj)
      window.instanceMap[id] = instance

  # 生成したインスタンスの中からアイテムのみ取得
  # @return [Array] アイテムインスタンス配列
  @allItemInstances = ->
    ret = {}
    for k, v of instanceMap
      if v instanceof CommonEventBase == false
        ret[k] = v
    return ret

  # アクションタイプからアクションタイプクラス名を取得
  # @param [Integer] actionType アクションタイプID
  # @return [String] アクションタイプクラス名
  @getActionTypeClassNameByActionType = (actionType) ->
    if parseInt(actionType) == Constant.ActionType.CLICK
      return Constant.TimelineActionTypeClassName.CLICK
    else if parseInt(actionType) == Constant.ActionType.SCROLL
      return Constant.TimelineActionTypeClassName.SCROLL
    return null

  # コードのアクションタイプからアクションタイプを取得
  # @param [Integer] actionType アクションタイプID
  # @return [String] アクションタイプクラス名
  @getActionTypeByCodingActionType = (actionType) ->
    if actionType == 'click'
      return Constant.ActionType.CLICK
    else if actionType == 'scroll'
      return Constant.ActionType.SCROLL
    return null

  # 日付をフォーマットで変換
  # @param [Date] date 対象日付
  # @param [String] format 変換フォーマット
  # @return [String] フォーマット後日付
  @formatDate = (date, format = 'YYYY-MM-DD hh:mm:ss') ->
    format = format.replace(/YYYY/g, date.getFullYear())
    format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2))
    format = format.replace(/DD/g, ('0' + date.getDate()).slice(-2))
    format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2))
    format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2))
    format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2))
    if format.match(/S/g)
      milliSeconds = ('00' + date.getMilliseconds()).slice(-3)
      length = format.match(/S/g).length
      for i in [0..length]
        format = format.replace(/S/, milliSeconds.substring(i, i + 1))
    return format

  # 時間差を計算
  # @param [Integer] future 未来日ミリ秒
  # @param [Integer] past 過去日ミリ秒
  # @return [Object] 差分オブジェクト
  @calculateDiffTime = (future, past) ->
    diff = future - past
    ret = {}
    ret.seconds = parseInt(diff / 1000)
    ret.minutes = parseInt(ret.seconds / 60)
    ret.hours = parseInt(ret.minutes / 60)
    ret.day = parseInt(ret.hours / 24)
    ret.week = parseInt(ret.day / 7)
    ret.month = parseInt(ret.day / 30)
    ret.year = parseInt(ret.day / 365)
    return ret

  # 時間差を表示
  # @param [Integer] future 未来日ミリ秒
  # @param [Integer] past 過去日ミリ秒
  # @return [String] 表示
  @displayDiffAlmostTime = (future, past) ->
    diffTime = @calculateDiffTime(future, past)
    span = null
    ret = null
    seconds = diffTime.seconds
    if seconds > 0
      span = if seconds == 1 then 'second' else 'seconds'
      ret = "#{seconds} #{span} ago"
    minutes = diffTime.minutes
    if minutes > 0
      span = if minutes == 1 then 'minute' else 'minutes'
      ret = "#{minutes} #{span} ago"
    hours = diffTime.hours
    if hours > 0
      span = if hours == 1 then 'hour' else 'hours'
      ret = "#{hours} #{span} ago"
    day = diffTime.day
    if day > 0
      span = if day == 1 then 'day' else 'days'
      ret = "#{day} #{span} ago"
    week = diffTime.week
    if week > 0
      span = if week == 1 then 'week' else 'weeks'
      ret = "#{week} #{span} ago"
    month = diffTime.month
    if month > 0
      span = if month == 1 then 'month' else 'months'
      ret = "#{month} #{span} ago"
    year = diffTime.year
    if year > 0
      span = if year == 1 then 'year' else 'years'
      ret = "#{year} #{span} ago"
    if !ret?
      ret = ''
    return ret

  # 最終更新日時の時間差を取得
  @displayLastUpdateDiffAlmostTime = (update_at = null) ->
    lastSaveTime = if update_at? then update_at else PageValue.getGeneralPageValue(PageValue.Key.LAST_SAVE_TIME)
    if lastSaveTime?
      n = $.now()
      d = new Date(lastSaveTime)
      return Common.displayDiffAlmostTime(n, d.getTime())
    else
      return null

  # 最新更新日時
  @displayLastUpdateTime = (update_at) ->
    date = new Date(update_at)
    diff = Common.calculateDiffTime($.now(), date)
    if diff.day > 0
      # 日で表示
      return @formatDate(date, 'YYYY/MM/DD')
    else
      # 時間で表示
      return @formatDate(date, 'hh:mm:ss')

  # モーダルビュー表示
  # @param [Integer] type モーダルビュータイプ
  # @param [Function] prepareShowFunc 表示前処理
  @showModalView = (type, enableOverlayClose = true, prepareShowFunc = null, prepareShowFuncParams = {}) ->
    _showModalView.call(@, type, prepareShowFunc, prepareShowFuncParams, false, ->
      $("body").append( '<div id="modal-overlay"></div>' )
      $("#modal-overlay").show()
      # センタリング
      Common.modalCentering.call(@, type)
      emt = $('body').children(".modal-content.#{type}")
      # ビューの高さ
      emt.css('max-height', $(window).height() * Constant.ModalView.HEIGHT_RATE)
      emt.fadeIn('fast', ->
        window.modalRun = false
      )
      $("#modal-overlay,#modal-close").unbind().click( ->
        if enableOverlayClose
          Common.hideModalView()
      )
    )

  # メッセージモーダル表示
  @showModalFlashMessage = (message, isModalFlush = false, immediately = true, enableOverlayClose = false) ->
    type = Constant.ModalViewType.MESSAGE
    _showModalView.call(@, type, null, isModalFlush, {}, ->
      $("body").append( '<div id="modal-overlay"></div>' )
      $("#modal-overlay").show()
      # センタリング
      Common.modalCentering.call(@, type)
      emt = $('body').children(".modal-content.#{type}")
      emt.find('.message_contents').html(message)
      # ビューの高さ
      emt.css('max-height', $(window).height() * Constant.ModalView.HEIGHT_RATE)
      if immediately
        emt.show()
        window.modalRun = false
      else
        emt.fadeIn('fast', ->
          window.modalRun = false
        )
      $("#modal-overlay,#modal-close").unbind().click( ->
        if enableOverlayClose
          Common.hideModalView()
      )
    )

  # モーダルビュー表示
  # @param [Integer] type モーダルビュータイプ
  # @param [Function] prepareShowFunc 表示前処理
  _showModalView = (type, prepareShowFunc, prepareShowFuncParams, isModalFlush, showFunc = null) ->
    if !isModalFlush && window.modalRun? && window.modalRun
      # 処理中は反応なし
      return

    window.modalRun = true
    setTimeout(->
      window.modalRun = false
    , 3000)

    emt = $('body').children(".modal-content.#{type}")
    allEmt = $('body').children(".modal-content")

    if emt.length != allEmt.length
      # 表示中のモーダルを非表示
      @hideModalView(true)
      emt = $('body').children(".modal-content.#{type}")

    self = @
    $(@).blur()
    if $("#modal-overlay")[0]?
      return false

    # 表示
    _show = ->
      if showFunc?
        showFunc()

    # 表示内容読み込み済みの場合はサーバアクセスなし
    if !emt? || emt.length == 0
      # サーバから表示内容読み込み
      # ローディング表示
      @showModalFlashMessage('Please Wait', true)
      $.ajax(
        {
          url: "/modal_view/show"
          type: "GET"
          data: {
            type: type
          }
          dataType: "json"
          success: (data) ->
            if data.resultSuccess
              Common.hideModalView(true)
              $('body').append(data.modalHtml)
              emt = $('body').children(".modal-content.#{type}")
              emt.hide()
              if prepareShowFunc?
                prepareShowFunc(emt, prepareShowFuncParams, ->
                  _show.call(self)
                )
              else
                console.log('/modal_view/show server error')
                Common.hideModalView(true)
                _show.call(self)
                Common.ajaxError(data)
                window.modalRun = false
          error: (data) ->
            Common.hideModalView(true)
            console.log('/modal_view/show ajax error')
            Common.ajaxError(data)
            window.modalRun = false
        }
      )
    else
      if prepareShowFunc?
        prepareShowFunc(emt, prepareShowFuncParams, ->
          _show.call(self)
        )
      else
        _show.call(self)

  # 中央センタリング
  @modalCentering = (type = null, animation = false, b = null, c = null) ->
    if !type?
      # 表示しているモーダルを対象にする
      emt = $('body').children(".modal-content:visible")
    else
      emt = $('body').children(".modal-content.#{type}")
    if emt?
      w = $(window).width()
      h = $(window).height()

      callback = null
      width = emt.outerWidth()
      height = emt.outerHeight()
      if b?
        if $.type(b) == 'function'
          callback = b
        else if $.type(b) == 'object'
          width = b.width
          height = b.height
      if c?
        callback = c
      cw = width
      ch = height
      if ch > h * Constant.ModalView.HEIGHT_RATE
        ch = h * Constant.ModalView.HEIGHT_RATE

      if animation
        emt.animate({"left": ((w - cw)/2) + "px","top": ((h - ch)/2 - 80) + "px"}, 300, 'linear', callback)
      else
        emt.css({"left": ((w - cw)/2) + "px","top": ((h - ch)/2 - 80) + "px"})

  # モーダル非表示
  @hideModalView = (immediately = false) ->
    if immediately
      $(".modal-content,#modal-overlay").stop().hide()
    else
      $(".modal-content,#modal-overlay").fadeOut('fast')
    $('#modal-overlay').remove()

  # Zindexにページ分のZindexを加算
  # @param [Integer] zindex 対象zindex
  # @param [Integer] pn ページ番号
  # @return [Integer] 計算後zidnex
  @plusPagingZindex: (zindex, pn = PageValue.getPageNum()) ->
    return (window.pageNumMax - pn) * (Constant.Zindex.EVENTFLOAT + 1) + zindex

  # Zindexにページ分のZindexを減算
  # @param [Integer] zindex 対象zindex
  # @param [Integer] pn ページ番号
  # @return [Integer] 計算後zidnex
  @minusPagingZindex: (zindex, pn = PageValue.getPageNum()) ->
    return zindex - (window.pageNumMax - pn) * (Constant.Zindex.EVENTFLOAT + 1)

  # アイテムを削除
  # @param [Integer] pageNum ページ番号
  @removeAllItem = (pageNum = null) ->
    if pageNum?
      items = @instancesInPage(pageNum)
      for item in items
        if item?
          if item instanceof CommonEventBase
            # Singletonのキャッシュを削除
            CommonEvent.deleteInstance(item.id)
          else
            # アイテム削除
            item.removeItemElement()
          delete window.instanceMap[item.id]
    else
      for k, v of Common.allItemInstances()
        if v?
          v.removeItemElement()
      window.instanceMap = {}
      # Singletonのキャッシュを削除
      CommonEvent.deleteAllInstance()

  # JSファイルをサーバから読み込む
  # @param [Int] classDistToken アイテム種別
  # @param [Function] callback コールバック関数
  @loadItemJs = (classDistTokens, callback = null) ->
    if jQuery.type(classDistTokens) != "array"
      classDistTokens = [classDistTokens]

    classDistTokens = $.grep(classDistTokens, (n) ->
      # 読み込み済みのものは除外
      return !window.itemInitFuncList[n]?
    )
    # 読み込むIDがない場合はコールバック実行して終了
    if classDistTokens.length == 0
      if callback?
        callback()
      return

    callbackCount = 0
    needReadclassDistTokens = []
    for classDistToken in classDistTokens
      if classDistToken?
        if window.itemInitFuncList[classDistToken]?
          # 読み込み済みなアイテムIDの場合
          window.itemInitFuncList[classDistToken]()
          callbackCount += 1
          if callbackCount >= classDistTokens.length
            if callback?
              # 既に全て読み込まれている場合はコールバック実行して終了
              callback()
            return
        else
          # Ajaxでjs読み込みが必要なアイテムID
          needReadclassDistTokens.push(classDistToken)
      else
        callbackCount += 1

    # js読み込み
    data = {}
    data[Constant.ItemGallery.Key.ITEM_GALLERY_ACCESS_TOKEN] = needReadclassDistTokens
    $.ajax(
      {
        url: "/item_js/index"
        type: "POST"
        dataType: "json"
        data: data
        success: (data)->
          if data.resultSuccess
            callbackCount = 0
            dataIdx = 0
            _cb = (d) ->
              option = {}
              Common.availJs(d.class_dist_token, d.js_src, option, =>
                PageValue.addItemInfo(d.class_dist_token)
                dataIdx += 1
                if dataIdx >= data.indexes.length
                  if callback?
                    callback()
                else
                  _cb.call(@, data.indexes[dataIdx])
              )
            _cb.call(@, data.indexes[dataIdx])
          else
            console.log('/item_js/index server error')
            Common.ajaxError(data)

        error: (data) ->
          console.log('/item_js/index ajax error')
          Common.ajaxError(data)
      }
    )

  # インスタンスPageValueから全てのJSを取得
  @loadJsFromInstancePageValue: (callback = null, pageNum = PageValue.getPageNum()) ->
    pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum))
    needclassDistTokens = []
    for k, obj of pageValues
      if obj.value.id.indexOf(ItemBase.ID_PREFIX) == 0
        # アイテムの場合
        if $.inArray(obj.value.classDistToken, needclassDistTokens) < 0
          needclassDistTokens.push(obj.value.classDistToken)

    @loadItemJs(needclassDistTokens, ->
      # コールバック
      if callback?
        callback()
    )

  # JSファイルを設定
  # @param [String] classDistToken アイテムID
  # @param [String] jsSrc jsファイル名
  # @param [Function] callback 設定後のコールバック
  @availJs = (classDistToken, jsSrc, option = {}, callback = null) ->
    window.loadedClassDistToken = classDistToken
    s = document.createElement('script');
    s.type = 'text/javascript';
    # TODO: 認証コードの比較
    s.src = jsSrc;
    firstScript = document.getElementsByTagName('script')[0];
    firstScript.parentNode.insertBefore(s, firstScript);
    t = setInterval( ->
      if window.itemInitFuncList[classDistToken]?
        clearInterval(t)
        window.itemInitFuncList[classDistToken](option)
        window.loadedClassDistToken = null
        if callback?
          callback()
    , 500)

  # CanvasをBlobに変換
  @canvasToBlob = (canvas) ->
    type = 'image/jpeg'
    dataurl = canvas.toDataURL(type)
    bin = atob(dataurl.split(',')[1]);
    buffer = new Uint8Array(bin.length);
    for i in [0..(bin.length - 1)]
      buffer[i] = bin.charCodeAt(i)
    return new Blob([buffer.buffer], {type: type});

  # JSファイルを適用する
  @setupJsByList = (itemJsList, callback = null) ->

    _addItem = (class_dist_token = null) ->
      if class_dist_token?
        PageValue.addItemInfo(class_dist_token)

    if itemJsList.length == 0
      if callback?
        callback()
      return

    loadedIndex = 0
    d = itemJsList[loadedIndex]
    _func = ->
      classDistToken = d.class_dist_token
      if window.itemInitFuncList[classDistToken]?
          # 既に読み込まれている場合
        window.itemInitFuncList[classDistToken]()
        #_addItem.call(@, classDistToken)
        loadedIndex += 1
        if loadedIndex >= itemJsList.length
          # 全て読み込んだ後
          if callback?
            callback()
        else
          d = itemJsList[loadedIndex]
          _func.call()
        return

      option = {}
      Common.availJs(classDistToken, d.js_src, option, ->
        _addItem.call(@, classDistToken)
        loadedIndex += 1
        if loadedIndex >= itemJsList.length
          # 全て読み込んだ後
          if callback?
            callback()
        else
          d = itemJsList[loadedIndex]
          _func.call()
      )
    _func.call()

  # コンテキストメニュー初期化
  # @param [String] elementID HTML要素ID
  # @param [String] contextSelector
  # @param [Object] option オプション
  @setupContextMenu = (element, contextSelector, option) ->
    data = {
      preventContextMenuForPopup: true
      preventSelect: true
    }
    $.extend(data, option)
    element.contextmenu(data)

  @colorFormatChangeRgbToHex = (data) ->
    if typeof data == 'string'
      # 'rgb(r, g, b)'または'rgba(r, g, b, a)'のフォーマットを分解
      cColors = data.replace('rgba', '').replace('rgb', '').replace('(', '').replace(')', '').split(',')
    else
      cColors = [data.r, data.g. data.b]
    for val, index in cColors
      cColors[index] = parseInt(val)
    return "##{cColors[0].toString(16)}#{cColors[1].toString(16)}#{cColors[2].toString(16)}"

  @colorFormatChangeHexToRgb = (data) ->
    # 'xxxxxxのフォーマットを分解'
    data = data.replace('#', '')
    cColors = new Array(3)
    cColors[0] = data.substring(0, 2)
    cColors[1] = data.substring(2, 4)
    cColors[2] = data.substring(4, 6)
    for val, index in cColors
      cColors[index] = parseInt(val, 16)
    return {
      r: cColors[0]
      g: cColors[1]
      b: cColors[2]
    }

  # 色変更差分のキャッシュを取得
  @colorChangeCacheData = (beforeColor, afterColor, length, colorType = 'hex') ->
    ret = []

    cColors = new Array(3)
    if afterColor.indexOf('rgb') >= 0
      # 'rgb(r, g, b)'または'rgba(r, g, b, a)'のフォーマットを分解
      cColors = afterColor.replace('rgba', '').replace('rgb', '').replace('(', '').replace(')', '').split(',')
      for val, index in cColors
        cColors[index] = parseInt(val)
    if afterColor.length == 6 || (afterColor.length == 7 && afterColor.indexOf('#') == 0)
      # 'xxxxxxのフォーマットを分解'
      afterColor = afterColor.replace('#', '')
      cColors[0] = afterColor.substring(0, 2)
      cColors[1] = afterColor.substring(2, 4)
      cColors[2] = afterColor.substring(4, 6)
      for val, index in cColors
        cColors[index] = parseInt(val, 16)

    if beforeColor == 'transparent'
      # 透明から変更する場合は rgbaで出力
      for i in [0..length]
        ret[i] = "rgba(#{cColors[0]},#{cColors[1]},#{cColors[2]}, #{i / length})"
    else
      bColors = new Array(3)
      if beforeColor.indexOf('rgb') >= 0
        # 'rgb(r, g, b)'または'rgba(r, g, b, a)'のフォーマットを分解
        bColors = beforeColor.replace('rgba', '').replace('rgb', '').replace('(', '').replace(')', '').split(',')
        for val, index in bColors
          bColors[index] = parseInt(val)
      if beforeColor.length == 6 || (beforeColor.length == 7 && beforeColor.indexOf('#') == 0)
        # 'xxxxxxのフォーマットを分解'
        beforeColor = beforeColor.replace('#', '')
        bColors[0] = beforeColor.substring(0, 2)
        bColors[1] = beforeColor.substring(2, 4)
        bColors[2] = beforeColor.substring(4, 6)
        for val, index in bColors
          bColors[index] = parseInt(val, 16)

      rPer = (cColors[0] - bColors[0]) / length
      gPer = (cColors[1] - bColors[1]) / length
      bPer = (cColors[2] - bColors[2]) / length
      rp = rPer
      gp = gPer
      bp = bPer
      for i in [0..length]
        r = parseInt(bColors[0] + rp)
        g = parseInt(bColors[1] + gp)
        b = parseInt(bColors[2] + bp)
        if colorType == 'hex'
          o = "##{r.toString(16)}#{g.toString(16)}#{b.toString(16)}"
        else if colorType == 'rgb'
          o = "rgb(#{r},#{g},#{b})"
        ret[i] = o
        rp += rPer
        gp += gPer
        bp += bPer

    return ret

# 画面共通の初期化処理 ajaxでサーバから読み込む等
do ->
  window.classMap = {}
