class CodingCommon

  @openItemCoding = (e) ->
    e.stopPropagation()
    target = "_coding"
    window.open("about:blank", target)
    document.run_form.action = '/coding/item'
    document.run_form.target = target
    setTimeout( ->
      document.run_form.submit()
    , 200)
    return false
