class TestMove
  constructor: (str, callFunc) ->
    @str = str
    @callFunc = eval('(' +  callFunc + ')')

  call: ->
    @callFunc()
