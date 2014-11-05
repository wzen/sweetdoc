# スタイルシート操作
class StylesheetHandle
  instance = null
  @get: ->
    instance ?= new Temp()
    return instance

  # テンプレート
  # @private
  class Temp
    constructor : ->
      # スタイルシートを作成
      styleEl = document.createElement('style')
      document.head.appendChild(styleEl)
      styleEl.appendChild(document.createTextNode(''));
      #@property [Object] sheet スタイルシート
      @handleSheet = styleEl.sheet

      # @property [Array] styleStack スタイル保存配列{key, index}
      @historyStack = []

    # スタイルシートに追加
    # @param [String] objId CSSを追加するHTML要素のID
    # @param [String] cssCode CSSコード内容
    insert: (objId, cssCode) ->
      # 末尾に追加する
      insertIndex = @handleSheet.cssRules.length
      @handleSheet.insertRule(cssCode, insertIndex)
      @historyStack[insertIndex] = objId

    # スタイルシートから削除
    # @param [String] objId CSSを追加したHTML要素のID
    remove: (objId) ->
      insertIndex = null
      for h, index in @historyStack
        if h == objId
          insertIndex = index
          break
      if insertIndex == null
        return
      @handleSheet.deleteRule(insertIndex)
      for  i in [insertIndex .. @historyStack.length - 2]
        @historyStack[i] = @historyStack[i + 1]
      @historyStack.pop()







