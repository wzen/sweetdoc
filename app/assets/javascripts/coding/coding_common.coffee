class CodingCommon

  if gon?
    constant = gon.const
    class @Lang
      JAVASCRIPT = constant.Coding.Lang.JAVASCRIPT
      COFFEESCRIPT = constant.Coding.Lang.COFFEESCRIPT

  @openItemCodingJs = ->
    # 実行確認ページを新規タブで表示
    target = "_coding"
    window.open("about:blank", target)
    document.run_form.action = '/coding/item/' + @Lang.JAVASCRIPT
    document.run_form.target = target
    setTimeout( ->
      document.run_form.submit()
    , 200)

  @openItemCodingCoffee = ->
    # 実行確認ページを新規タブで表示
    target = "_coding"
    window.open("about:blank", target)
    document.run_form.action = '/coding/item/' + @Lang.COFFEESCRIPT
    document.run_form.target = target
    setTimeout( ->
      document.run_form.submit()
    , 200)