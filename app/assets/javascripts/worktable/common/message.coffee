class Message

  # 警告表示
  # @param [String] message メッセージ内容
  @showWarn = (message) ->
    warnFooter = $('.warn-message')
    errorFooter = $('.error-message')
    warnDisplay = $('.footer-message-display', warnFooter)
    isBeforeWarnDisplay = warnDisplay.val() == "1"
    isErrorDisplay = $('.footer-message-display', errorFooter).val() == "1"
    mes = $('> div > p', warnFooter)

    if message == undefined
      return

    warnDisplay.val("1")
    exist_mes = mes.html()
    if exist_mes == null || exist_mes == ""
      mes.html(message)
    else
      mes.html(exist_mes + '<br/>' + message)

    if messageTimer != null
      clearTimeout(messageTimer)

    if isBeforeWarnDisplay
      css = {}
    else
      if isErrorDisplay
        bottom = parseInt(errorFooter.css('bottom'), 10) + errorFooter.height() + 10
        css = {bottom: bottom + 'px'}
      else
        css = {bottom: '20px'}

    warnFooter.animate(css, 'fast', (e)->
      window.messageTimer = setTimeout((e)->
        footer = $('.footer-message')
        $('.footer-message-display', footer).val("0")
        footer.stop().animate({bottom: '-30px'}, 'fast', (e)->
          window.messageTimer = null
          $('> div > p', $(this)).html('')
        )
      , 3000)
    )

  # エラー表示
  # @param [String] message メッセージ内容
  @showError = (message) ->
    warnFooter = $('.warn-message')
    errorFooter = $('.error-message')
    errorDisplay = $('.footer-message-display', errorFooter)
    isBeforeErrorDisplay = errorDisplay.val() == "1"
    isWarnDisplay = $('.footer-message-display', warnFooter).val() == "1"
    mes = $('> div > p', errorFooter)

    if message == undefined
      return

    errorDisplay.val("1")
    exist_mes = mes.html()
    if exist_mes == null || exist_mes == ""
      mes.html(message)
    else
      mes.html(exist_mes + '<br/>' + message)

    if messageTimer != null
      clearTimeout(messageTimer)

    if isBeforeErrorDisplay
      css = {}
    else
      css = {bottom: '20px'}

    errorFooter.animate(css, 'fast', (e)->
      if isWarnDisplay
        bottom = parseInt(errorFooter.css('bottom'), 10) + errorFooter.height() + 10
        css = {bottom: bottom + 'px'}
        warnFooter.stop().animate(css, 'fast')

      window.messageTimer = setTimeout((e)->
        footer = $('.footer-message')
        $('.footer-message-display', footer).val("0")
        footer.stop().animate({bottom: '-30px'}, 'fast', (e)->
          window.messageTimer = null
          $('> div > p', $(this)).html('')
        )
      , 3000)
    )

  # 警告表示(フラッシュ)
  # @param [String] message メッセージ内容
  @flushWarn = (message) ->
    # 他のメッセージが表示されているときは表示しない
    if(window.messageTimer != null)
      return

    if(window.flushMessageTimer != null)
      clearTimeout(flushMessageTimer)

    fw = $('#flush_warn')
    mes = $('> div > p', fw)
    mes.html(message)
    fw.show()
    window.flushMessageTimer = setTimeout((e)->
      fw.hide()
    , 100)