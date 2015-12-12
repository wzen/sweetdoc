# CSSアイテム
# @abstract
# @extend ItemBase
class CssItemBase extends ItemBase

  if window.loadedItemToken?
    # @property [String] ITEM_ACCESS_TOKEN アイテム種別
    @ITEM_ACCESS_TOKEN = window.loadedItemToken

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null) ->
    super(cood)
    @_cssRoot = null
    @_cssCache = null
    @_cssCode = null
    @_cssStyle = null
    if cood != null
      @_moveLoc = {x:cood.x, y:cood.y}
    @_cssStypeReflectTimer = null

  # initEvent前の処理
  initEventPrepare: ->
    # デザインCSS & アニメーションCSS作成
    @makeCss()
    @appendAnimationCssIfNeeded()

 # アイテム用のテンプレートHTMLを読み込み
  # @return [String] HTML
  createItemElement: (callback) ->
    contents = """
          <div type="button" class="css_item_base context_base"><div></div></div>
        """
    callback(Common.wrapCreateItemElement(@, $(contents)))

  # JSファイル読み込み時処理
  @jsLoaded: (option) ->
    # ワークテーブルの初期化処理

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  # @param [Function] callback コールバック
  reDraw: (show = true, callback = null) ->
    super(show, =>
      @clearDraw()
      @createItemElement((createdElement) =>
        $(createdElement).appendTo(window.scrollInside)
        if !show
          @getJQueryElement().css('opacity', 0)

        if @setupDragAndResizeEvents?
          # ドラッグ & リサイズイベント設定
          @setupDragAndResizeEvents()

        if callback?
          callback()
      )
    )

  # CSSのルートのIDを取得
  # @return [String] CSSルートID
  getCssRootElementId: ->
    return "css_" + @id

  # CSSアニメーションルートID取得
  # @return [String] CSSアニメーションID
  getCssAnimElementId: ->
    return "css_anim_style"

  #CSSを設定
  makeCss: (fromTemp = false) ->
    _applyCss = (designs) ->
      if !designs?
        return
      temp = $('.cssdesign_temp:first').clone(true).attr('class', '')
      temp.attr('id', @getCssRootElementId())
      if designs.values?
        for k,v of designs.values
          #console.log("k: #{k}  v: #{v}")
          temp.find(".#{k}").html("#{v}")
      if designs.flags?
        for k,v of designs.flags
          if !v
            temp.find(".#{k}").empty()
      temp.find('.design_item_obj_id').html(@id)
      temp.appendTo(window.cssCode)

    # 上書きするため一旦削除
    $("#{@getCssRootElementId()}").remove()
    if !fromTemp && @designs?
      # 保存しているデザインで初期化
      _applyCss.call(@, @designs)
    else
      # デフォルトのデザインで初期化
      _applyCss.call(@, @constructor.actionProperties.designConfigDefaultValues)

    @_cssRoot = $('#' + @getCssRootElementId())
    @_cssCache = $(".css_cache", @_cssRoot)
    @_cssCode = $(".css_code", @_cssRoot)
    @_cssStyle = $(".css_style", @_cssRoot)
    @applyDesignChange(false)

  # デザイン反映
  applyDesignChange: (doStyleSave) ->
    @reDraw()
    @_cssStyle.text(@_cssCode.text())
    if doStyleSave
      @saveDesign()

  # アニメーションKeyframe
  # @abstract
  cssAnimationKeyframe: ->
    return null

  # アニメーションCSS追加処理
  appendAnimationCssIfNeeded : ->
    keyframe = @cssAnimationKeyframe()
    if keyframe?
      methodName = @getEventMethodName()
      # CSSが存在する場合は削除して入れ替え
      @removeAnimationCss()
      funcName = "#{methodName}_#{@id}"
      keyFrameName = "#{@id}_frame"
      webkitKeyframe = "@-webkit-keyframes #{keyframe}"
      mozKeyframe = "@-moz-keyframes #{keyframe}"
      duration = @eventDuration()

      # CSSに設定
      css = """
      .#{funcName}
      {
      -webkit-animation-name: #{keyFrameName};
      -moz-animation-name: #{keyFrameName};
      -webkit-animation-duration: #{duration}s;
      -moz-animation-duration: #{duration}s;
      }
      """

      window.cssCode.append("<div class='#{funcName}'><style type='text/css'> #{webkitKeyframe} #{mozKeyframe} #{css} </style></div>")

  # アニメーションCSS削除処理
  removeAnimationCss: ->
    methodName = @getEventMethodName()
    funcName = "#{methodName}_#{@id}"
    window.cssCode.find(".#{funcName}").remove()


  if window.isWorkTable
    @include({

      # 描画終了
      # @param [Int] zindex z-index
      # @param [boolean] show 要素作成後に描画を表示するか
      endDraw: (zindex, show = true, callback = null) ->
        @zindex = zindex
        # スクロールビュー分のxとyを追加
        @itemSize.x += scrollContents.scrollLeft()
        @itemSize.y += scrollContents.scrollTop()
        @applyDefaultDesign()
        @makeCss(true)
        @drawAndMakeConfigsAndWritePageValue(show, callback)

      # デザインツールメニュー設定
      setupDesignToolOptionMenu: ->
        self = @
        designConfigRoot = $('#' + @getDesignConfigId())

        # スライダー
        self.settingGradientSlider('design_slider_gradient', null)
        self.settingGradientDegSlider('design_slider_gradient_deg', 0, 315)
        self.settingDesignSlider('design_slider_border_radius', 0, 100)
        self.settingDesignSlider('design_slider_border_width', 0, 10)
        self.settingDesignSlider('design_slider_font_size', 0, 30)
        self.settingDesignSlider('design_slider_shadow_left', -100, 100)
        self.settingDesignSlider('design_slider_shadow_opacity', 0.0, 1.0, 0.1)
        self.settingDesignSlider('design_slider_shadow_size', 0, 100)
        self.settingDesignSlider('design_slider_shadow_top', -100, 100)
        self.settingDesignSlider('design_slider_shadowinset_left', -100, 100)
        self.settingDesignSlider('design_slider_shadowinset_opacity', 0.0, 1.0, 0.1)
        self.settingDesignSlider('design_slider_shadowinset_size', 0, 100)
        self.settingDesignSlider('design_slider_shadowinset_top', -100, 100)
        self.settingDesignSlider('design_slider_text_shadow1_left', -100, 100)
        self.settingDesignSlider('design_slider_text_shadow1_opacity', 0.0, 1.0, 0.1)
        self.settingDesignSlider('design_slider_text_shadow1_size', 0, 100)
        self.settingDesignSlider('design_slider_text_shadow1_top', -100, 100)
        self.settingDesignSlider('design_slider_text_shadow2_left', -100, 100)
        self.settingDesignSlider('design_slider_text_shadow2_opacity', 0.0, 1.0, 0.1)
        self.settingDesignSlider('design_slider_text_shadow2_size', 0, 100)
        self.settingDesignSlider('design_slider_text_shadow2_top', -100, 100)

        # 背景色
        btnBgColor = $(".design_bg_color1,.design_bg_color2,.design_bg_color3,.design_bg_color4,.design_bg_color5,.design_border_color,.design_font_color", designConfigRoot)
        btnBgColor.each((idx, e) =>
          className = e.classList[0]
          colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(@id, "#{className}_value"))
          ColorPickerUtil.initColorPicker(
            $(e),
            colorValue,
            (a, b, d, e) =>
              @designs.values["#{className}_value"] = b
              self.applyColorChangeByPicker(className, b)
          )
        )

        # 背景影
        btnShadowColor = $(".design_shadow_color,.design_shadowinset_color,.design_text_shadow1_color,.design_text_shadow2_color", designConfigRoot);
        btnShadowColor.each((idx, e) =>
          className = e.classList[0]
          colorValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(@id, "#{className}_value"))
          ColorPickerUtil.initColorPicker(
            $(e),
            colorValue,
            (a, b, d) =>
              value = "#{d.r},#{d.g},#{d.b}"
              @designs.values["#{className}_value"] = value
              self.applyColorChangeByPicker(className, value)
          )
        )

        # グラデーションStep
        btnGradientStep = $(".design_gradient_step", designConfigRoot)
        btnGradientStep.off('keyup mouseup')
        btnGradientStep.on('keyup mouseup', (e) =>
          stepValue = parseInt($(e.currentTarget).val())
          for i in [2 .. 4]
            @designs.flags["design_bg_color#{i}_moz_flag"] = i <= stepValue - 1
            @designs.flags["design_bg_color#{i}_webkit_flag"] = i <= stepValue - 1
          self.applyGradientStepChange(e.currentTarget)
        ).each((idx, e) =>
          stepValue = 2
          for i in [2 .. 4]
            if !@designs.flags["design_bg_color#{i}_moz_flag"]
              stepValue = i
              break
          $(e).val(stepValue)
          for i in [2 .. 4]
            @designs.flags["design_bg_color#{i}_moz_flag"] = i <= stepValue - 1
            @designs.flags["design_bg_color#{i}_webkit_flag"] = i <= stepValue - 1
          @_cssStyle.text(@_cssCode.text())
          @saveDesign()
        )

      # デザイン変更を反映
      applyDesignStyleChange: (designKeyName, value, doStyleSave = true) ->
        cssCodeElement = $('.' + designKeyName + '_value', @_cssCode)
        cssCodeElement.html(value)
        @applyDesignChange(doStyleSave)

      # グラデーションデザイン変更を反映
      applyGradientStyleChange: (index, designKeyName, value, doStyleSave = true) ->
        position = $('.design_bg_color' + (index + 2) + '_position_value', @_cssCode)
        position.html(("0" + value).slice(-2))
        @applyDesignStyleChange(designKeyName, value, doStyleSave)

      # グラデーション方向変更を反映
      applyGradientDegChange: (designKeyName, value, doStyleSave = true) ->
        webkitDeg = {
          0: 'left top, left bottom',
          45: 'right top, left bottom',
          90: 'right top, left top',
          135: 'right bottom, left top',
          180: 'left bottom, left top',
          225: 'left bottom, right top',
          270: 'left top, right top',
          315: 'left top, right bottom'
        }
        @designs.values["#{designKeyName}_value_webkit_value"] = webkitDeg[value]
        webkitValueElement = $('.' + designKeyName + '_value_webkit_value', @_cssCode)
        webkitValueElement.html(webkitDeg[value])
        @applyDesignStyleChange(designKeyName, value, doStyleSave)

      applyGradientStepChange: (target, doStyleSave = true) ->
        @changeGradientShow(target)
        stepValue = parseInt($(target).val())
        for i in [2 .. 4]
          className = 'design_bg_color' + i
          mozFlag = $("." + className + "_moz_flag", @_cssRoot)
          mozCache = $("." + className + "_moz_cache", @_cssRoot)
          webkitFlag = $("." + className + "_webkit_flag", @_cssRoot)
          webkitCache = $("." + className + "_webkit_cache", @_cssRoot)
          if i > stepValue - 1
            mh = mozFlag.html()
            if mh.length > 0
              mozCache.html(mh)
            wh = webkitFlag.html()
            if wh.length > 0
              webkitCache.html(wh)
            $(mozFlag).empty()
            $(webkitFlag).empty()
          else
            mozFlag.html(mozCache.html());
            webkitFlag.html(webkitCache.html())
        @applyDesignChange(doStyleSave)

      applyColorChangeByPicker: (designKeyName, value, doStyleSave = true) ->
        codeEmt = $(".#{designKeyName}_value", @_cssCode)
        codeEmt.text(value)
        @applyDesignChange(doStyleSave)
    })

