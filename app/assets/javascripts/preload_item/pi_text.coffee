class PreloadItemText extends CanvasItemBase
  @NAME_PREFIX = "text"
  @CLASS_DIST_TOKEN = 'PreloadItemText'
  @NO_TEXT = 'Blank text'
  @WRITE_TEXT_BLUR_LENGTH = 5
  constant = gon.const
  class @BalloonType
    @FREE = constant.PreloadItemText.BalloonType.FREE
    @ARC = constant.PreloadItemText.BalloonType.ARC
    @RECT = constant.PreloadItemText.BalloonType.RECT
    @BROKEN_ARC = constant.PreloadItemText.BalloonType.BROKEN_ARC
    @BROKEN_RECT = constant.PreloadItemText.BalloonType.BROKEN_RECT
    @FLASH = constant.PreloadItemText.BalloonType.FLASH
    @CLOUD = constant.PreloadItemText.BalloonType.CLOUD
  class @WriteDirectionType
    @HORIZONTAL = constant.PreloadItemText.WriteDirectionType.HORIZONTAL
    @VERTICAL = constant.PreloadItemText.WriteDirectionType.VERTICAL
  class @WordAlign
    @LEFT = constant.PreloadItemText.WordAlign.LEFT
    @CENTER = constant.PreloadItemText.WordAlign.CENTER
    @RIGHT = constant.PreloadItemText.WordAlign.RIGHT
  class @ShowAnimationType
    @POPUP = constant.PreloadItemText.ShowAnimationType.POPUP
    @FADE = constant.PreloadItemText.ShowAnimationType.FADE

  @actionProperties =
  {
    modifiables: {
      textColor: {
        name: 'TextColor'
        default: {r:0, g:0, b:0}
        colorType: 'rgb'
        type: 'color'
        ja: {
          name: '文字色'
        }
      }
      drawHorizontal: {
        name: 'Horizontal / Vertical'
        type: 'select'
        options: [
          {
            name: 'Horizontal'
            value: @WriteDirectionType.HORIZONTAL
            ja: {
              name: '横書き'
            }
          }
          {
            name: 'Vertical'
            value: @WriteDirectionType.VERTICAL
            ja: {
              name: '縦書き'
            }
          }
        ]
        ja: {
          name: '横書き / 縦書き'
        }
      }
      showBalloon: {
        name: 'Show Balloon'
        default: false
        type: 'boolean'
        openChildrenValue: { one: true}
        ja: {
          name: '吹き出し表示'
        }
        children: {
          one: {
            balloonColor: {
              name: 'BalloonColor'
              default: {r:255, g:255, b:255}
              type: 'color'
              colorType: 'rgb'
              ja: {
                name: '吹き出しの色'
              }
            }
            balloonBorderColor: {
              name: 'BalloonBorderColor'
              default: {r:0, g:0, b:0}
              type: 'color'
              colorType: 'rgb'
              ja: {
                name: '吹き出し枠の色'
              }
            }
            balloonBorderWidth: {
              name: 'BalloonBorderWidth'
              default: 1
              type: 'number'
              min: 1
              max: 30
              ja: {
                name: '吹き出し枠の幅'
              }
            }
            balloonType: {
              name: 'BalloonType'
              type: 'select'
              options: [
                {name: 'Arc', value: @BalloonType.ARC}
                {name: 'Broken Arc', value: @BalloonType.BROKEN_ARC}
                {name: 'Rect', value: @BalloonType.RECT}
                {name: 'Broken Rect', value: @BalloonType.BROKEN_RECT}
                {name: 'Flash', value: @BalloonType.FLASH}
                {name: 'Cloud', value: @BalloonType.CLOUD}
                {name: 'FreeHand', value: @BalloonType.FREE}
              ]
              ja: {
                name: '吹き出しのタイプ'
              }
              openChildrenValue: {
                one: @BalloonType.RECT
              }
              children: {
                one: {
                  balloonRadius: {
                    name: 'BalloonRadius'
                    default: 30
                    type: 'number'
                    min: 1
                    max: 100
                    ja: {
                      name: '吹き出しの角丸'
                    }
                  }
                }
              }
            }
          }
        }
      }
      fontFamily: {
        name: "Select Font"
        type: 'select'
        temp: 'fontFamily'
        ja: {
          name: 'フォント選択'
        }
      }
      isFixedFontSize: {
        name: "Font Size Fixed"
        type: 'boolean'
        default: false
        openChildrenValue: {one: true}
        ja: {
          name: 'フォントサイズ指定'
        }
        children: {
          one: {
            fixedFontSize: {
              type: 'number'
              name: "Font Size"
              min: 1
              max: 100
              default: 14
            }
          }
        }
      }
      wordAlign: {
        name: "Word Align"
        type: 'select'
        options: [
          {name: 'left', value: @WordAlign.LEFT}
          {name: 'center', value: @WordAlign.CENTER}
          {name: 'right', value: @WordAlign.RIGHT}
        ]
        ja: {
          name: '文字寄せ'
        }
      }
    }
    methods : {
      changeText: {
        finishWithHand: true
        modifiables: {
          inputText: {
            name: "Text"
            type: 'string'
            ja: {
              name: "文字"
            }
          }
          showWithAnimation: {
            name: 'Show with animation'
            default: false
            type: 'boolean'
            openChildrenValue: {one: true}
            ja: {
              name: 'アニメーション表示'
            }
            children: {
              one: {
                showAnimationType: {
                  name: 'AnimationType'
                  type: 'select'
                  default: @ShowAnimationType.POPUP
                  options: [
                    {name: 'Popup', value: @ShowAnimationType.POPUP}
                    {name: 'Fade', value: @ShowAnimationType.FADE}
                  ]
                }
              }
            }
          }
        }
        options: {
          id: 'changeText'
          name: 'changeText'
          desc: "changeText"
          ja: {
            name: 'テキスト'
            desc: 'テキスト変更'
          }
        }
      }
      writeText: {
        finishWithHand: true
        modifiables: {
          showWithAnimation: {
            name: 'Show with animation'
            default: false
            type: 'boolean'
            openChildrenValue: {one: true}
            ja: {
              name: 'アニメーション表示'
            }
            children: {
              one: {
                showAnimationType: {
                  name: 'AnimationType'
                  type: 'select'
                  default: @ShowAnimationType.POPUP
                  options: [
                    {name: 'Popup', value: @ShowAnimationType.POPUP}
                    {name: 'Fade', value: @ShowAnimationType.FADE}
                  ]
                }
              }
            }
          }
        }
        options: {
          id: 'writeText'
          name: 'writeText'
          desc: "writeText"
          ja: {
            name: 'テキスト'
            desc: 'テキスト描画'
          }
        }
      }
    }
  }

  @getCircumPos =
    {
      x: (d, r, cx) ->
        return Math.cos(Math.PI / 180 * d) * r + cx
      y: (d, r, cy) ->
        return Math.sin(Math.PI / 180 * d) * r + cy
    }

  # コンストラクタ
  # @param [Array] cood 座標
  constructor: (cood = null)->
    super(cood)
    if cood != null
      @_moveLoc = {x:cood.x, y:cood.y}
    @inputText = null
    @drawHorizontal =  @constructor.WriteDirectionType.HORIZONTAL
    #@fontFamily = 'Times New Roman'
    @fontFamily = 'HGP行書体'
    @fontSize = null
    @isFixedFontSize = false
    @rowWordLength = null
    @showBalloon = false
    @balloonValue = {}
    @balloonType = null
    @balloonRandomIntValue = null
    @textPositions = null
    @wordAlign = @constructor.WordAlign.LEFT
    @originalItemSize = null
    @freeHandItemSize = null
    @freeHandDrawPaths = null
    @freeHandTextOffset = {top: 0, left: 0}
    @_freeHandDrawPadding = 5
    @_fixedTextAlpha = null
    @_defaultWorkWidth = {}

  # アイテム描画
  # @param [Boolean] show 要素作成後に表示するか
  itemDraw: (show = true) ->
    super(show)
    if show
      # スタイル設定
      if @inputText?
        _setTextStyle.call(@)
      else
        _setNoTextStyle.call(@)
      # 文字配置 & フォント設定
      if @inputText?
        _drawTextAndBalloonToCanvas.call(@ , @inputText)
      else
        _drawTextAndBalloonToCanvas.call(@ , @constructor.NO_TEXT)

  # メソッド実行(ItemEventBaseのオーバーライド)
  # FIXME: アニメーション処理などで各メソッドの終了が遅れる場合があるため、全メソッドでcallbackを呼ばせるように変更するか考える
  execMethod: (opt, callback = null) ->
    EventBase.prototype.execMethod.call(@, opt, =>
      methodName = @getEventMethodName()
      if methodName != EventPageValueBase.NO_METHOD
        if methodName == 'writeText'
          (@constructor.prototype[methodName]).call(@, opt, callback)
        else
          (@constructor.prototype[methodName]).call(@, opt)
          if callback?
            callback()
      else
        # アイテム状態の表示反映
        @updatePositionAndItemSize(@itemSize, false, false)
        if callback?
          callback()
    )

  # 再描画処理
  # @param [boolean] show 要素作成後に描画を表示するか
  # @param [Function] callback コールバック
  refresh: (show = true, callback = null) ->
    super(show, =>
      _settingTextDbclickEvent.call(@)
      if callback?
        callback(@)
    )

  changeInstanceVarByConfig: (varName, value)->
    if varName == 'drawHorizontal' && @drawHorizontal != value
      # Canvas縦横変更
      canvas = document.getElementById(@canvasElementId())
      width = canvas.width
      height = canvas.height
      #$(canvas).css({width: "#{height}px", height: "#{width}px"})
      $(canvas).attr({width: height, height: width})
      w = @itemSize.w
      h = @itemSize.h
      @itemSize.w = h
      @itemSize.h = w
    else if varName == 'showBalloon' && @showBalloon != value && !@isFixedFontSize
      # FontSizeを撮り直す
      canvas = document.getElementById(@canvasElementId())
      @showBalloon = value
      @fontSize = _calcFontSizeAbout.call(@, @inputText, canvas.width, canvas.height, @isFixedFontSize, @drawHorizontal)
    else if varName == 'isFixedFontSize' || varName == 'fixedFontSize'
      # FontSizeを撮り直す
      canvas = document.getElementById(@canvasElementId())
      @[varName] = value
      @fontSize = _calcFontSizeAbout.call(@, @inputText, canvas.width, canvas.height, @isFixedFontSize, @drawHorizontal)
    else if varName == 'balloonType' && @balloonType? && @balloonType != value
      if value == @constructor.BalloonType.FREE
        # パスを消去して新規作成する
        @freeHandDrawPaths = null
        opt = {
          multiDraw: true
          applyDrawCallback: (drawPaths) =>
            # 配列調整
            drawPaths = _adjustFreeHandPath.call(@, drawPaths)
            if !drawPaths?
              # 調整失敗
              return false

            # キャンパスサイズ拡張
            @originalItemSize = $.extend({}, @itemSize)
            minX = 999999
            maxX = -1
            minY = 999999
            maxY = -1
            for dp in drawPaths
              for d in dp
                if minX > d.x
                  minX = d.x
                if minY > d.y
                  minY = d.y
                if maxX < d.x
                  maxX = d.x
                if maxY < d.y
                  maxY = d.y
            # drawPaths値更新
            for dp, idx1 in drawPaths
              for d, idx2 in dp
                drawPaths[idx1][idx2] = {
                  x: Math.round(d.x - minX + @_freeHandDrawPadding)
                  y: Math.round(d.y - minY + @_freeHandDrawPadding)
                }

            @itemSize.x = window.scrollContents.scrollLeft() + minX - @_freeHandDrawPadding
            @itemSize.y = window.scrollContents.scrollTop()  + minY - @_freeHandDrawPadding
            @itemSize.w = maxX - minX + @_freeHandDrawPadding * 2
            @itemSize.h = maxY - minY + @_freeHandDrawPadding * 2
            @freeHandTextOffset.left = (@originalItemSize.x + @originalItemSize.w * 0.5) - (@itemSize.x + @itemSize.w * 0.5)
            @freeHandTextOffset.top = (@originalItemSize.y + @originalItemSize.h * 0.5) - (@itemSize.y + @itemSize.h * 0.5)
            @getJQueryElement().remove()
            @createItemElement( =>
              @freeHandItemSize = $.extend({}, @itemSize)
              @freeHandDrawPaths = drawPaths
              @saveObj()
              @itemDraw(true)
              if @setupItemEvents?
                # アイテムのイベント設定
                @setupItemEvents()

            )
            return true
        }
        EventDragPointingDraw.run(opt)
      else
        # アイテムのサイズを戻す
        if @originalItemSize?
          @itemSize = $.extend({}, @originalItemSize)
          @getJQueryElement().remove()
          @createItemElement( =>
            @saveObj()
            if @setupItemEvents?
              # アイテムのイベント設定
              @setupItemEvents()
          )
        @freeHandTextOffset = {top: 0, left: 0}

    super(varName, value)

  # テキストはCanvasの伸縮をさせないため、メソッド上書き
  updateItemSize: (w, h) ->
    element = $('#' + @id)
    element.css({width: w, height: h})
    canvas = $('#' + @canvasElementId())
    scaleW = element.width() / @itemSize.w
    scaleH = element.height() / @itemSize.h
    canvas.attr('width',  element.width())
    canvas.attr('height', element.height())
    @itemSize.w = w
    @itemSize.h = h

  # アニメーション変更前のアイテムサイズ
  # テキストはCanvasの伸縮をさせないため、メソッド上書き
  originalItemElementSize: ->
    obj = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceBefore(@_event[EventPageValueBase.PageValueKey.DIST_ID], @id))
    return obj.itemSize

  # マウスアップ時の描画イベント
  mouseUpDrawing: (zindex, callback = null) ->
    @restoreAllDrawingSurface()
    # テキストModal表示
    _showInputModal.call(@)
    # 編集状態で描画
    @endDraw(zindex, true, =>
      @setupItemEvents()
      @saveObj(true)
      # フォーカス設定
      @firstFocus = Common.firstFocusItemObj() == null
      # 編集モード
      Navbar.setModeEdit()
      WorktableCommon.changeMode(constant.Mode.EDIT)
      if callback?
        callback()
    )

  # イベント前の表示状態にする
  updateEventBefore: ->
    super()
    @_animationFlg = {}
    @_animationFlg['isOpen'] = false
    
  # イベント後の表示状態にする
  updateEventAfter: ->
    super()
    @_animationFlg = {}
    @_animationFlg['isOpen'] = false

  # 最終ステップでメソッドを実行(オーバーライド)
  execLastStep: (callback = null) ->
    # イベント終了を呼ぶだけ(開始と終了で表示が変わらないため)
    @finishEvent()
    if callback?
      callback()

  startOpenAnimation: (callback = null) ->
    if @_runningBallonAnimation? && @_runningBallonAnimation
      return
    @_runningBallonAnimation = true
    @_time = 0
    @_pertime = 1
    @disableHandleResponse()
    requestAnimationFrame( =>
      _startOpenAnimation.call(@, callback)
    )
  _startOpenAnimation = (callback = null) ->
    if !@_canvas?
      @_canvas = document.getElementById(@canvasElementId())
      @_context = @_canvas.getContext('2d')
      @_context.save()

    emt = @getJQueryElement()
    x = null
    y = null
    width = null
    height = null
    if @showAnimationType == @constructor.ShowAnimationType.POPUP
      timemax = 8
      step1 = 0.6
      step2 = 0.8
      step3 = 1
      if @_time / timemax <= step1
        progressPercent = @_time / (timemax * step1)
        x = (@itemSize.w * 0.5) + (((@itemSize.w - @itemSize.w * 0.9) * 0.5) - (@itemSize.w * 0.5)) * progressPercent
        y = (@itemSize.h * 0.5) + (((@itemSize.h - @itemSize.h * 0.9) * 0.5) - (@itemSize.h * 0.5)) * progressPercent
        width = (@itemSize.w * 0.9) * progressPercent
        height = (@itemSize.h * 0.9) * progressPercent
        @_step1 = {x: x, y: y, w: width, h: height}
        @_time1 = @_time
      else if  @_time / timemax <= step2
        progressPercent = (@_time - @_time1) / (timemax * (step2 - step1))
        x = @_step1.x + (((@itemSize.w - @itemSize.w * 0.6) * 0.5) - @_step1.x) * progressPercent
        y = @_step1.y + (((@itemSize.h - @itemSize.h * 0.6) * 0.5) - @_step1.y) * progressPercent
        width = @_step1.w + (@itemSize.w * 0.6 - @_step1.w) * progressPercent
        height = @_step1.h + (@itemSize.h * 0.6 - @_step1.h) * progressPercent
        @_step2 = {x: x, y: y, w: width, h: height}
        @_time2 = @_time
      else if  @_time / timemax <= step3
        progressPercent = (@_time - @_time2) / (timemax * (step3 - step2))
        if progressPercent > 1
          progressPercent = 1
        x = @_step2.x - @_step2.x * progressPercent
        y = @_step2.y - @_step2.y * progressPercent
        width = @_step2.w + (@itemSize.w - @_step2.w) * progressPercent
        height = @_step2.h + (@itemSize.h - @_step2.h) * progressPercent
    else if @showAnimationType == @constructor.ShowAnimationType.FADE
      timemax = 30
      step1 = 1
      x = 0
      y = 0
      width = @_canvas.width
      height = @_canvas.height
      if @_time / timemax <= step1
        progressPercent = @_time / (timemax * step1)
        @_fixedBalloonAlpha = progressPercent

    @_context.clearRect(0, 0, @_canvas.width, @_canvas.height)
    _drawBalloon.call(@, @_context, x, y, width, height,  @_canvas.width, @_canvas.height)
    @_time += @_pertime
    if @_time <= timemax
      requestAnimationFrame( =>
        _startOpenAnimation.call(@, callback)
      )
    else
      @_context.restore()
      if callback?
        callback()
      @enableHandleResponse()
      @_runningBallonAnimation = false

  startCloseAnimation: (callback = null) ->
    if @_runningBallonAnimation? && @_runningBallonAnimation
      return
    @_runningBallonAnimation = true
    @_time = 0
    @_pertime = 1
    @disableHandleResponse()
    requestAnimationFrame( =>
      _startCloseAnimation.call(@, callback)
    )
  _startCloseAnimation = (callback = null) ->
    emt = @getJQueryElement()
    x = null
    y = null
    width = null
    height = null
    if @showAnimationType == @constructor.ShowAnimationType.POPUP
      timemax = 8
      step1 = 0.2
      step2 = 0.5
      step3 = 1
      if @_time / timemax <= step1
        progressPercent = @_time / (timemax * step1)
        x = (@itemSize.w - @itemSize.w * 0.5) * 0.5 * progressPercent
        y = (@itemSize.h - @itemSize.h * 0.5) * 0.5  * progressPercent
        width = @itemSize.w + (@itemSize.w * 0.5 - @itemSize.w) * progressPercent
        height = @itemSize.h + (@itemSize.h * 0.5 - @itemSize.h) * progressPercent
        @_step1 = {x: x, y: y, w: width, h: height}
        @_time1 = @_time
      else if  @_time / timemax <= step2
        progressPercent = (@_time - @_time1) / (timemax * (step2 - step1))
        x = @_step1.x + (((@itemSize.w - @itemSize.w * 0.9) * 0.5) - @_step1.x) * progressPercent
        y = @_step1.y + (((@itemSize.h - @itemSize.h * 0.9) * 0.5) - @_step1.y) * progressPercent
        width = @_step1.w + (@itemSize.w * 0.9 - @_step1.w) * progressPercent
        height = @_step1.h + (@itemSize.h * 0.9 - @_step1.h) * progressPercent
        @_step2 = {x: x, y: y, w: width, h: height}
        @_time2 = @_time
      else if  @_time / timemax <= step3
        progressPercent = (@_time - @_time2) / (timemax * (step3 - step2))
        if progressPercent > 1
          progressPercent = 1
        x = @_step2.x + (@itemSize.w * 0.5 - @_step2.x) * progressPercent
        y = @_step2.y + (@itemSize.h * 0.5 - @_step2.y) * progressPercent
        width = @_step2.w - @_step2.w * progressPercent
        height = @_step2.h - @_step2.h * progressPercent
    else if @showAnimationType == @constructor.ShowAnimationType.FADE
      timemax = 30
      step1 = 1
      x = 0
      y = 0
      width = @_canvas.width
      height = @_canvas.height
      if @_time / timemax <= step1
        progressPercent = 1 - (@_time / (timemax * step1))
        @_fixedBalloonAlpha = progressPercent
        @_fixedTextAlpha = progressPercent

    @_context.clearRect(0, 0, @_canvas.width, @_canvas.height)
    _drawBalloon.call(@, @_context, x, y, width, height, @_canvas.width, @_canvas.height)
    @_time += @_pertime
    if @_time <= timemax
      requestAnimationFrame( =>
        _startCloseAnimation.call(@, callback)
      )
    else
      @_context.clearRect(0, 0, @_canvas.width, @_canvas.height)
      if callback?
        callback()
      @enableHandleResponse()
      @_runningBallonAnimation = false

  willChapter: (callback = null) ->
    @_animationFlg = {}
    @_animationFlg['isOpen'] = false
    super(callback)

  @isJapanease = (c) ->
    return c.charCodeAt(0) >= 256

  changeText: (opt) ->
    @showWithAnimation = @showWithAnimation__after
    @showAnimationType = @showAnimationType__after
    @showAnimationType
    if @showWithAnimation && !@_animationFlg['isOpen']?
      @startOpenAnimation( =>
        @changeText(opt)
      )
      @_animationFlg['isOpen'] = true
    else
      opa = opt.progress / opt.progressMax
      canvas = document.getElementById(@canvasElementId())
      context = canvas.getContext('2d')
      context.clearRect(0, 0, canvas.width, canvas.height)
      context.fillStyle = "rgb(#{@textColor.r},#{@textColor.g},#{@textColor.b})"
      @_fixedTextAlpha = 1 - opa
      _drawTextAndBalloonToCanvas.call(@ , @inputText__before)
      @_fixedTextAlpha = opa
      _drawTextAndBalloonToCanvas.call(@ , @inputText__after)

    if opt.progress == opt.progressMax && @showWithAnimation && @_animationFlg['isOpen']? && @_animationFlg['isOpen']
      @startCloseAnimation()
      @_animationFlg['isOpen'] = false

  writeText: (opt, callback = null) ->
    @showWithAnimation = @showWithAnimation__after
    @showAnimationType = @showAnimationType__after
    @_forward = opt.forward
    if @_forward && (!@_animationFlg['isOpen']? || !@_animationFlg['isOpen'])
      if @showWithAnimation
        @startOpenAnimation( =>
          _openCbk.call(@)
        )
      else
        _openCbk.call(@)
    else
      if !@_forward && opt.progress <= 0 && @_animationFlg['isOpen']
        if @showWithAnimation
          @startCloseAnimation( =>
            _oCbk.call(@)
          )
        else
          _oCbk.call(@)
      else if opt.progress <= opt.progressMax && @inputText? && @inputText.length > 0
        if !@_writeTextRunning? || !@_writeTextRunning
          @_fixedTextAlpha = null
          adjustProgress = opt.progressMax / @inputText.length
          writeLength =  @inputText.length * (opt.progress + adjustProgress * 0.5) / opt.progressMax
          writeBlurLength = parseInt(writeLength) - parseInt(@_beforeWriteLength)
          if Math.abs(writeBlurLength) > 0
            @_animationFlg['isOpen'] = true
            if parseInt(writeLength) < @inputText.length
              @_finishedWrite = false
            @_writeTextRunning = true
            @_beforeWriteLength = writeLength
            @_writeBlurLength = Math.abs(writeBlurLength)
            cache = @loadCache('writeTextBlurCache')
            if cache?
              @_context.putImageData(cache, 0, 0)
            else
              @_context.clearRect(0, 0, @_canvas.width, @_canvas.height)
              _drawBalloon.call(@, @_context, 0, 0, @_canvas.width, @_canvas.height)
              @saveCache('writeTextBlurCache', @_context.getImageData(0, 0, @_canvas.width, @_canvas.height))
              cache = @loadCache('writeTextBlurCache')
            @_alphaDiff = 0
            _write = ->
              @_context.putImageData(cache, 0, 0)
              _drawText.call(@, @_context, @inputText, 0, 0, @_canvas.width, @_canvas.height, @fontSize, writeLength)
              @_alphaDiff += 0.25
              if @_alphaDiff <= 1
                _write.call(@)
              else
                @_writeTextRunning = false
                @_finishedWrite = parseInt(writeLength) >= @inputText.length
            _write.call(@)

    if opt.progress >= opt.progressMax && @_finishedWrite? && @_finishedWrite && (@_animationFlg['isOpen']? && @_animationFlg['isOpen'])
      @_writeTextRunning = false
      if @showWithAnimation
        @startCloseAnimation( =>
          _closeCbk.call(@)
        )
      else
        _closeCbk.call(@)
    else
      if callback?
        callback()

  _openCbk = ->
    if !@_canvas?
      @_canvas = document.getElementById(@canvasElementId())
      @_context = @_canvas.getContext('2d')
    @_animationFlg['isOpen'] = true
    @resetProgress()
    @fontSize = _calcFontSizeAbout.call(@, @inputText, @_canvas.width, @_canvas.height, @isFixedFontSize, @drawHorizontal)
    _setTextStyle.call(@)
    @_beforeWriteLength = 0
    @_writeTextRunning = false
    @_isScrollHeader = false

  _oCbk = ->
    @_animationFlg['isOpen'] = false
    @resetProgress()
    @_beforeWriteLength = 0
    @_writeTextRunning = false

  _closeCbk = ->
    @_animationFlg['isOpen'] = false
    if !@_isFinishedEvent
      # 終了イベント
      @finishEvent()
      if ScrollGuide?
        ScrollGuide.hideGuide()
      if callback?
        callback()

  _setTextStyle = ->
    canvas = document.getElementById(@canvasElementId())
    context = canvas.getContext('2d')
    context.fillStyle = "rgb(#{@textColor.r},#{@textColor.g},#{@textColor.b})"

  _setNoTextStyle = ->
    canvas = document.getElementById(@canvasElementId())
    context = canvas.getContext('2d')
    context.fillStyle = "rgba(#{@textColor.r},#{@textColor.g},#{@textColor.b}, 0.3)"

  _drawTextAndBalloonToCanvas = (text, writingLength = text.length) ->
    if !text?
      return
    canvas = document.getElementById(@canvasElementId())
    context = canvas.getContext('2d')
    context.clearRect(0, 0, canvas.width, canvas.height)
    _drawBalloon.call(@, context, 0, 0, canvas.width, canvas.height)
    if !@fontSize?
      @fontSize = _calcFontSizeAbout.call(@, text, canvas.width, canvas.height, @isFixedFontSize, @drawHorizontal)
    _drawText.call(@, context, text, 0, 0, canvas.width, canvas.height, @fontSize, writingLength)

  _getRandomInt = (max, min) ->
    return Math.floor(Math.random() * (max - min)) + min

  _balloonStyle = (context) ->
    context.fillStyle = "rgba(#{@balloonColor.r},#{@balloonColor.g},#{@balloonColor.b}, 0.95)"
    context.strokeStyle = "rgba(#{@balloonBorderColor.r},#{@balloonBorderColor.g},#{@balloonBorderColor.b}, 0.95)"
    context.lineWidth = @balloonBorderWidth
    # 影
    context.shadowColor = 'rgba(0,0,0,0.3)'
    context.shadowOffsetX = 3
    context.shadowOffsetY = 3
    context.shadowBlur = 4

  _drawBalloon = (context, x, y, width, height, canvasWidth = width, canvasHeight = height) ->
    if !@showBalloon
      return
    if width <= 0 || height <= 0
      # サイズが無い場合は描画無し
      return

    # キャッシュ参照
    fba = if @_fixedBalloonAlpha? then @_fixedBalloonAlpha else 1
    cache = @loadCache(['drawBalloonPathCacle', x, y, width, height, @balloonType, fba])
    if cache?
      context.putImageData(cache, 0, 0)
      return

    _drawArc = ->
      # 円
      context.beginPath()
      context.translate(canvasWidth * 0.5, canvasHeight * 0.5)
      # 調整
      diff = 10.0
      if width > height
        context.scale(canvasWidth / canvasHeight, 1)
        r = height * 0.5 - diff
        if r < 0
          r = 0
        context.arc(0, 0, Math.round(r), 0, Math.PI * 2)
      else
        context.scale(1, canvasHeight / canvasWidth)
        r = width * 0.5 - diff
        if r < 0
          r = 0
        context.arc(0, 0, Math.round(r), 0, Math.PI * 2)
      context.fill()
      context.stroke()

    _drawRect = ->
      # 四角
      context.beginPath()
      # FIXME: 描画オプション追加
      context.fillRect(x, y, width, height);

    _drawBArc = ->
      # 円 破線
      # 調整値
      diff = 10.0
      context.translate(canvasWidth * 0.5, canvasHeight * 0.5)
      per = Math.PI * 2 / 100
      if width > height
        context.scale(canvasWidth / canvasHeight, 1)
        sum = 0
        x = 0
        while sum < Math.PI * 2
          context.beginPath()
          l = ((2 * Math.abs(Math.cos(x))) + 1) * per
          y = x + l
          r = height * 0.5 - diff
          if r < 0
            r = 0
          context.arc(0, 0, Math.round(r), x, y)
          context.fill()
          context.stroke()
          sum += l
          x = y
          # 空白
          l = ((1 * Math.abs(Math.cos(x))) + 1) * per
          y = x + l
          sum += l
          x = y

      else
        context.scale(1, canvasHeight / canvasWidth)
        sum = 0
        x = 0
        while sum < Math.PI * 2
          context.beginPath()
          l = ((2 * Math.abs(Math.sin(x))) + 1) * per
          y = x + l
          r = width * 0.5 - diff
          if r < 0
            r = 0
          context.arc(0, 0, r, x, y)
          context.fill()
          context.stroke()
          sum += l
          x = y
          # 空白
          l = ((1 * Math.abs(Math.sin(x))) + 1) * per
          y = x + l
          sum += l
          x = y

    _drawBRect = ->
      # 四角 破線
      dashLength = 5
      context.beginPath()
      _draw = (sx, sy, ex, ey) ->
        deltaX = ex - sx
        deltaY = ey - sy
        numDashes = Math.floor(Math.sqrt(deltaX * deltaX + deltaY * deltaY) / dashLength)
        for i in [0..(numDashes - 1)]
          if i % 2 == 0
            context.moveTo(sx + (deltaX / numDashes) * i, sy + (deltaY / numDashes) * i)
          else
            context.lineTo(sx + (deltaX / numDashes) * i, sy + (deltaY / numDashes) * i)

      _draw.call(@, x, y, width, y)
      _draw.call(@, width, y, width, height)
      _draw.call(@, width, height, x, height)
      _draw.call(@, x, height, x, y)
      context.fillRect(x, y, width, height);
      context.stroke();

    _drawShout = =>
      # 叫び
      num = 18
      radiusX = width / 2
      radiusY = height / 2
      cx = x + width / 2
      cy = y + height / 2
      if @drawHorizontal
        s = @itemSize.h
      else
        s = @itemSize.w
      punkLineMax = s * 0.2
      punkLineMin = s * 0.1
      deg = 0
      addDeg = 360 / num
      # 共通設定
      context.beginPath()
      context.lineJoin = 'round'
      context.lineCap = 'round'
      if !@balloonRandomIntValue?
        @balloonRandomIntValue = _getRandomInt.call(@, punkLineMax, punkLineMin)
      for i in [0..(num - 1)]
        deg += addDeg
        random = @balloonRandomIntValue
        # 始点・終点
        beginX = PreloadItemText.getCircumPos.x(deg, radiusX, cx)
        beginY = PreloadItemText.getCircumPos.y(deg, radiusY, cy)
        endX   = PreloadItemText.getCircumPos.x(deg + addDeg, radiusX, cx)
        endY   = PreloadItemText.getCircumPos.y(deg + addDeg, radiusY, cy)
        # 制御値
        cp1x = PreloadItemText.getCircumPos.x(deg, radiusX - random * 0.6, cx)
        cp1y = PreloadItemText.getCircumPos.y(deg, radiusY - random * 0.6, cy)
        cp2x = PreloadItemText.getCircumPos.x(deg + addDeg, radiusX - random * 0.6, cx)
        cp2y = PreloadItemText.getCircumPos.y(deg + addDeg, radiusY - random * 0.6, cy)

        # 開始点と最終点のズレを調整する
        bex = Math.round(beginX)
        bey = Math.round(beginY)
        ex = Math.round(endX)
        ey = Math.round(endY)
        c1x = Math.round(cp1x)
        c1y = Math.round(cp1y)
        c2x = Math.round(cp2x)
        c2y = Math.round(cp2y)
        if i == 0
          context.moveTo(bex, bey)
          context.arcTo(bex, bey, ex, ey, punkLineMax)
        context.bezierCurveTo(c1x, c1y, c2x, c2y, ex, ey)

      context.fill()
      context.stroke()

    _drawThink = =>
      # 考え中
      num = 8
      cx = x + (width) / 2
      cy = y + (height) / 2
      if @drawHorizontal
        s = @itemSize.h
      else
        s = @itemSize.w
      punkLineMax = s * 0.3
      punkLineMin = s * 0.1
      diff = punkLineMin + (punkLineMax - punkLineMin) * 0.6
      radiusX = (width - diff) / 2
      radiusY = (height - diff) / 2
      deg = 0
      addDeg = 360 / num
      # 共通設定
      context.beginPath()
      context.lineJoin = 'round'
      context.lineCap = 'round'
      if !@balloonRandomIntValue?
        @balloonRandomIntValue = _getRandomInt.call(@, punkLineMax, punkLineMin)
      for i in [0..(num - 1)]
        deg += addDeg
        random = @balloonRandomIntValue
        # 始点・終点
        beginX = PreloadItemText.getCircumPos.x(deg, radiusX, cx)
        beginY = PreloadItemText.getCircumPos.y(deg, radiusY, cy)
        endX   = PreloadItemText.getCircumPos.x(deg + addDeg, radiusX, cx)
        endY   = PreloadItemText.getCircumPos.y(deg + addDeg, radiusY, cy)
        # 制御値
        cp1x = PreloadItemText.getCircumPos.x(deg, radiusX + random * 0.7, cx)
        cp1y = PreloadItemText.getCircumPos.y(deg, radiusY + random * 0.7, cy)
        cp2x = PreloadItemText.getCircumPos.x(deg + addDeg, radiusX + random * 0.7, cx)
        cp2y = PreloadItemText.getCircumPos.y(deg + addDeg, radiusY + random * 0.7, cy)

        bex = Math.round(beginX)
        bey = Math.round(beginY)
        ex = Math.round(endX)
        ey = Math.round(endY)
        c1x = Math.round(cp1x)
        c1y = Math.round(cp1y)
        c2x = Math.round(cp2x)
        c2y = Math.round(cp2y)
        # 開始点と最終点のズレを調整する
        if i == 0
          context.moveTo(bex, bey)
          context.arcTo(bex, bey, ex, ey, punkLineMax)
        context.bezierCurveTo(c1x, c1y, c2x, c2y, ex, ey)

      context.fill()
      context.stroke()

    _drawFreeHand = =>
      if @freeHandDrawPaths?
        _freeHandBalloonDraw.call(@, context, x, y, width, height, canvasWidth, canvasHeight, @freeHandDrawPaths)

    context.save()
    context.globalAlpha = fba
    _balloonStyle.call(@, context)
    if @balloonType == @constructor.BalloonType.ARC
      _drawArc.call(@)
    else if @balloonType == @constructor.BalloonType.RECT
      _drawRect.call(@)
    else if @balloonType == @constructor.BalloonType.BROKEN_ARC
      _drawBArc.call(@)
    else if @balloonType == @constructor.BalloonType.BROKEN_RECT
      _drawBRect.call(@)
    else if @balloonType == @constructor.BalloonType.FLASH
      _drawShout.call(@)
    else if @balloonType == @constructor.BalloonType.CLOUD
      _drawThink.call(@)
    else if @balloonType == @constructor.BalloonType.FREE
      _drawFreeHand.call(@)
    # キャッシュ保存
    @saveCache(['drawBalloonPathCacle', x, y, width, height, @balloonType], context.getImageData(0, 0, width, height))
    context.restore()

  _adjustFreeHandPath = (drawPaths) ->
    i = drawPaths.length - 1
    while i >= 0
      # 不要なパスの削除
      if drawPaths[i].length == 0
        drawPaths.splice(i, 1)
      i -= 1

    # サブパス間のパスを追加
    retArray = [drawPaths[0]]
    searchedIndex = [0]
    _search = (targetIndex, isTail) ->
      searchTarget = drawPaths[targetIndex]
      targetCood = if isTail then searchTarget[searchTarget.length - 1] else searchTarget[0]
      mLen = 999999
      m = null
      i = null
      it = null
      for dp, idx in drawPaths
        for j in [0, dp.length - 1]
          # 一番距離が近いサブパスを検索
          if searchedIndex.indexOf(idx) < 0
            sq = Math.pow(dp[j].x - targetCood.x, 2) + Math.pow(dp[j].y - targetCood.y, 2)
            if sq < mLen
              mLen = sq
              m = {x: dp[j].x, y: dp[j].y}
              it = j != 0
              i = idx
      if m?
        a = drawPaths[i].concat()
        if it
          # 配列を反転させる
          a = a.reverse()
        searchedIndex.push(i)
        retArray.push([targetCood, m])
        retArray.push(a)
        _search.call(@, i, !it)

    _search(0, true)

    return retArray

  _freeHandBalloonDraw = (context, x, y, width, height, canvasWidth, canvasHeight, drawPaths) ->
    cx = canvasWidth * 0.5
    cy = canvasHeight * 0.5
    # 座標修正
    percent = width / canvasWidth
    modDP = []
    for dp, i1 in drawPaths
      modDP[i1] = []
      for d, i2 in dp
        modDP[i1][i2] = {
          x: cx - (cx - d.x) * percent
          y: cy - (cy - d.y) * percent
        }

    # 描画
    context.beginPath()
    for dp, idx1 in modDP
      for d, idx2 in dp
        dx = d.x
        dy = d.y
        if idx1 == 0 && idx2 == 0
          context.moveTo(dx, dy)
        else
          context.lineTo(dx, dy)
    context.closePath()
    context.lineJoin = 'round'
    context.lineCap = 'round'
    context.fill()
    context.stroke()

  _calcHorizontalColumnWidth = (context, columnText) ->
    sum = 0
    for char in columnText.split('')
      sum += context.measureText(char).width
    return sum

  _calcHorizontalColumnWidthMax = (context, columns) ->
    ret = 0
    for c in columns
      r = _calcHorizontalColumnWidth.call(@, context, c)
      if ret < r
        ret = r
    return ret

  _calcVerticalColumnHeight = (columnText, fontSize) ->
    ret = 0
    for c in columnText.split('')
      measure = _calcWordMeasure.call(@, c, fontSize, @fontFamily)
      if PreloadItemText.isJapanease(c)
        ret += _defaultWorkWidth.call(@, fontSize, @fontFamily)
      else
        ret += measure.height
    return ret

  _calcHorizontalColumnHeightMax = (columnText, fontSize) ->
    ret = 0
    for c in columnText.split('')
      measure = _calcWordMeasure.call(@, c, fontSize, @fontFamily)
      r = measure.height
      if ret < r
        ret = r
    return ret

  _calcHorizontalColumnHeightSum = (columns, fontSize) ->
    sum = 0
    for c in columns
      sum += _calcHorizontalColumnHeightMax.call(@, c, fontSize)
    return sum

  _calcVerticalColumnHeightMax = (columns, fontSize) ->
    ret = 0
    for c in columns
      r = _calcVerticalColumnHeight.call(@, c, fontSize)
      if ret < r
        ret = r
    return ret

  _setTextAlpha = (context, idx, writingLength) ->
    #writingLength = parseInt(writingLength)
    methodName = @getEventMethodName()
    if methodName == 'changeText'
      if @_fixedTextAlpha?
        context.globalAlpha = @_fixedTextAlpha
    else if methodName == 'writeText'
      if @_forward
        ga = 1
        if writingLength == 0 || idx > writingLength
          ga = 0
        else if idx <= writingLength - @_writeBlurLength
          ga = 1
        else
          ga = @_alphaDiff
          if ga < 0
            ga = 0
          if ga > 1
            ga = 1
        #console.log('ga:' + ga + ' _alphaDiff:' + @_alphaDiff + ' _writeBlurLength:' + @_writeBlurLength + ' idx:' + idx)
        context.globalAlpha = ga
      else
        ga = 1
        if writingLength == 0 || idx > writingLength + @_writeBlurLength
          ga = 0
        else if idx <= writingLength
          ga = 1
        else
          ga = @_alphaDiff
          if ga < 0
            ga = 0
          if ga > 1
            ga = 1
        context.globalAlpha = ga

  _writeLength = (column, writingLength, wordSum) ->
    v = parseInt(writingLength - wordSum)
    if v > column.length
      v = column.length
    else if v < 0
      v = 0
    return v

  _drawText = (context, text, x, y, width, height, fontSize, writingLength = text.length) ->
    context.save()
    context.font = "#{fontSize}px #{@fontFamily}"
    wordWidth = _defaultWorkWidth.call(@, fontSize, @fontFamily)
    column = ['']
    line = 0
    text = text.replace("{br}", "\n", "gm")
    for i in [0..(text.length - 1)]
      char = text.charAt(i)
      if (@rowWordLength? && @rowWordLength <= column[line].length) || char == "\n"
        line += 1
        column[line] = ''
        if char == "\n"
          char = ''
      column[line] += char
    sizeSum = 0
    wordSum = 0
    if @drawHorizontal == @constructor.WriteDirectionType.HORIZONTAL
      heightLine = y + (height - _calcHorizontalColumnHeightSum.call(@, column, fontSize)) * 0.5
      widthMax = _calcHorizontalColumnWidthMax.call(@, context, column)
      if @balloonType == @constructor.BalloonType.FREE
        x += @freeHandTextOffset.left
        heightLine += @freeHandTextOffset.top
      for j in [0..(column.length - 1)]
        heightLine += _calcHorizontalColumnHeightMax.call(@, column[j], fontSize)
        w = x
        if @wordAlign == @constructor.WordAlign.LEFT
          w += (width - widthMax) * 0.5
        else if @wordAlign == @constructor.WordAlign.CENTER
          w += (width - _calcHorizontalColumnWidth.call(@, context, column[j])) * 0.5
        else
          # RIGHT
          w += (width + widthMax) * 0.5 - _calcHorizontalColumnWidth.call(@, context, column[j])
        context.beginPath()
        wl = 0
        for c, idx in column[j].split('')
          _setTextAlpha.call(@, context, idx + wordSum + 1, writingLength)
          context.fillText(c, Math.round(w + wl), Math.round(heightLine))
          wl += context.measureText(c).width
        wordSum += column[j].length
    else
      widthLine = x + (width + wordWidth * column.length) * 0.5
      heightMax = _calcVerticalColumnHeightMax.call(@, column, fontSize)
      if @balloonType == @constructor.BalloonType.FREE
        widthLine += @freeHandTextOffset.left
        y += @freeHandTextOffset.top
      for j in [0..(column.length - 1)]
        widthLine -= wordWidth
        h = y
        if @wordAlign == @constructor.WordAlign.LEFT
          h += (height - heightMax) * 0.5
        else if @wordAlign == @constructor.WordAlign.CENTER
          h += (height - _calcVerticalColumnHeight.call(@, column[j], fontSize)) * 0.5
        else
          # RIGHT
          h += (height + heightMax) * 0.5 - _calcVerticalColumnHeight.call(@, column[j], fontSize)
        context.beginPath()
        hl = 0
        for c, idx in column[j].split('')
          measure = _calcWordMeasure.call(@, c, fontSize, @fontFamily)
          _setTextAlpha.call(@, context, idx + wordSum + 1, writingLength)
          if PreloadItemText.isJapanease(c)
            hl += wordWidth
          else
            hl += measure.height
          if _isWordSmallJapanease.call(@, c)
            # 小文字は右上に寄せる
            heightDiff = wordWidth * 0.1
            context.fillText(c, Math.round(widthLine + (wordWidth - measure.width) * 0.5), Math.round(h + hl - heightDiff))
          else if _isWordNeedRotate.call(@, c)
            # 90°回転
            context.save()
            context.beginPath()
            if PreloadItemText.isJapanease(c)
              ww = wordWidth
            else
              ww = measure.height
            context.translate(widthLine + wordWidth * 0.5, h + hl - ww * 0.5)
            # デバッグ用の円
            #context.arc(0, 0, 20, 0, Math.PI*2, false)
            #context.stroke()
            context.rotate(Math.PI / 2)
            # 「wordWidth * 0.75」は調整用の値
            # engDiffは英字の調整
            engDiff = wordWidth - ww
            context.fillText(c, Math.round(-measure.width * 0.5), Math.round(wordWidth * 0.75 * 0.5 - engDiff * 0.5))
            context.restore()
          else
            context.fillText(c, Math.round(widthLine), Math.round(h + hl))
        wordSum += column[j].length
    context.restore()

  _calcWordMeasure = (char, fontSize, fontFamily) ->
    fontSizeKey = "#{fontSize}"
    cache = @loadCache(['fontMeatureCache', fontSizeKey, fontFamily.replace(' ', '_'), char])
    if cache?
      return cache

    nCanvas = document.createElement('canvas')
    nCanvas.width = 500
    nCanvas.height = 500
    nContext = nCanvas.getContext('2d')
    nContext.font = "#{fontSize}px #{fontFamily}"
    nContext.textBaseline = 'top'
    nContext.fillStyle = nCanvas.strokeStyle = '#ff0000'
    nContext.fillText(char, 0, 0)
    writedImage = nContext.getImageData(0, 0, nCanvas.width, nCanvas.height)
    mi = _measureImage.call(@, writedImage)

#    if window.debug
#      console.log('char: ' + char + ' textWidth:' + mi.width + ' textHeight:' + mi.height)

    @saveCache(['fontMeatureCache', fontSizeKey, fontFamily.replace(' ', '_'), char], mi)
    return mi

  _measureImage = (_writedImage) ->
    w = _writedImage.width
    x = 0
    y = 0
    minX = 9999
    maxX = 0
    minY = 9999
    maxY = 0
    for i in [0..(_writedImage.data.length - 1)] by 4
      if _writedImage.data[i + 0] > 128
        if x < minX
          minX = x
        if x > maxX
          maxX = x
        if y < minY
          minY = y
        if y > maxY
          maxY = y
      x += 1
      if x >= w
        x = 0
        y += 1
    return {
      width : maxX - minX + 1
      height: maxY - minY + 1
    }

  _isWordSmallJapanease = (char) ->
    list = '、。ぁぃぅぇぉっゃゅょゎァィゥェォッャュョヮヵヶ'.split('')
    list = list.concat([',', '\\.'])
    regex = new RegExp(list.join('|'))
    return char.match(regex)

  _isWordNeedRotate = (char) ->
    if !PreloadItemText.isJapanease(char)
      # 英字は回転
      return true

    list = 'ー＝〜・'
    regex = new RegExp(list.split('').join('|'))
    return char.match(regex)

  # 描画枠から大体のフォントサイズを計算
  _calcFontSizeAbout = (text, width, height, isFixedFontSize, drawHorizontal) ->
    if width <= 0 || height <= 0
      return

    if !@inputText?
      # Blankの場合は小さめのフォントで表示
      return 12

    # 文字数計算
    a = text.length
    # 文末の改行を削除
    text = text.replace(/\n+$/g,'')
    if !isFixedFontSize
      # フォントサイズを計算
      newLineCount = text.split('\n').length - 1
      # キャッシュ確認
      cache = @loadCache(['calcFontSizeAboutCache', newLineCount, width, height, drawHorizontal, @showBalloon])
      if cache?
        return cache

      if drawHorizontal == @constructor.WriteDirectionType.HORIZONTAL
        w = height
        h = width
      else
        w = width
        h = height
      fontSize = (Math.sqrt(Math.pow(newLineCount, 2) + (w * 4 * (a + 1)) / h) - newLineCount) * h / ((a + 1) * 2)
#      if debug
#        console.log('fontSize:' + fontSize)

      # FontSizeは暫定
      fontSize = parseInt(fontSize / 1.8)
      if fontSize < 1
        fontSize = 1
      if @showBalloon && fontSize >= 6
        fontSize -= 5
      # キャッシュ保存
      @saveCache(['calcFontSizeAboutCache', newLineCount, width, height, drawHorizontal, @showBalloon], fontSize)
      return fontSize
    else
      return @fixedFontSize

  _showInputModal = ->
    Common.showModalView(constant.ModalViewType.ITEM_TEXT_EDITING, false, (modalEmt, params, callback = null) =>
      _prepareEditModal.call(@ ,modalEmt)
      if callback?
        callback()
    )

  _settingTextDbclickEvent = ->
    # ダブルクリックでEditに変更
    @getJQueryElement().off('dblclick').on('dblclick', (e) =>
      e.preventDefault()
      # Modal表示
      _showInputModal.call(@)
    )

  _prepareEditModal = (modalEmt) ->
    if @inputText?
      $('.textarea:first', modalEmt).val(@inputText)
    else
      $('.textarea:first', modalEmt).val('')
    directionSelect = $('.drawHorizontal_select:first', modalEmt)
    if directionSelect.children().length == 0
      for o in @constructor.actionProperties.modifiables.drawHorizontal.options
        $.extend(o, o[window.locale])
        directionSelect.append("<option value='#{o.value}'>#{o.name}</option>")
    directionSelect.val('')

    $('.create_button', modalEmt).off('click').on('click', (e) =>
      # Inputを反映して再表示
      emt = $(e.target).closest('.modal-content')
      @inputText = $('.textarea:first', emt).val()
      @drawHorizontal = parseInt($('.drawHorizontal_select:first', emt).val())
      # 吹き出し無し状態のfontSizeと行数を撮り直す
      canvas = document.getElementById(@canvasElementId())
      sb = @showBalloon
      @showBalloon = false
      fontSize = _calcFontSizeAbout.call(@, @inputText, canvas.width, canvas.height, @isFixedFontSize, @drawHorizontal)
      @rowWordLength = _calcRowWordLength.call(@, @inputText, canvas.width, canvas.height, fontSize, @fontFamily)
      @showBalloon = sb
      @fontSize = _calcFontSizeAbout.call(@, @inputText, canvas.width, canvas.height, @isFixedFontSize, @drawHorizontal)
      # データ保存
      @saveObj()
      # モードを描画モードに
      Navbar.setModeDraw(@classDistToken, =>
        WorktableCommon.changeMode(constant.Mode.DRAW)
        @refresh(true, =>
          Common.hideModalView()
        )
      )
    )
    $('.back_button', modalEmt).off('click').on('click', (e) =>
      Common.hideModalView()
    )

  _calcRowWordLength = (text, width, height, fontSize, fontFamily) ->
    canvas = document.getElementById(@canvasElementId())
    nCanvas = document.createElement('canvas')
    nCanvas.width = width
    nCanvas.height = height
    nContext = nCanvas.getContext('2d')
    nContext.font = "#{fontSize}px #{fontFamily}"
    column = ['']
    line = 0
    text = text.replace("{br}", "\n", "gm")
    for i in [0..(text.length - 1)]
      char = text.charAt(i)
      if char == "\n" || (@drawHorizontal == @constructor.WriteDirectionType.HORIZONTAL && nContext.measureText(column[line] + char).width > width) || (@drawHorizontal == @constructor.WriteDirectionType.VERTICAL && _calcVerticalColumnHeight.call(@, column[line] + char, fontSize) > height)
        if char != "\n" && !@showBalloon
          return column[line].length
        line += 1
        column[line] = ''
        if char == "\n"
          char = ''
      column[line] += char
    return null

  _defaultWorkWidth = (fontSize, fontFamily) ->
    fontSizeKey = "#{fontSize}"
    if @_defaultWorkWidth[fontSizeKey]? && @_defaultWorkWidth[fontSizeKey][fontFamily]?
      return @_defaultWorkWidth[fontSizeKey][fontFamily]

    nCanvas = document.createElement('canvas')
    nCanvas.width = 500
    nCanvas.height = 500
    context = nCanvas.getContext('2d')
    context.font = "#{fontSize}px #{fontFamily}"
    wordWidth = context.measureText('あ').width
    if !@_defaultWorkWidth[fontSizeKey]?
      @_defaultWorkWidth[fontSizeKey] = {}
    @_defaultWorkWidth[fontSizeKey][fontFamily] = wordWidth

Common.setClassToMap(PreloadItemText.CLASS_DIST_TOKEN, PreloadItemText)

if window.itemInitFuncList? && !window.itemInitFuncList[PreloadItemText.CLASS_DIST_TOKEN]?
  if window.debug
    console.log('PreloadItemText loaded')
  window.itemInitFuncList[PreloadItemText.CLASS_DIST_TOKEN] = (option = {}) ->
    if window.isWorkTable && PreloadItemText.jsLoaded?
      PreloadItemArrow.jsLoaded(option)
    #JS読み込み完了後の処理
    if window.debug
      console.log('PreloadItemText init Finish')