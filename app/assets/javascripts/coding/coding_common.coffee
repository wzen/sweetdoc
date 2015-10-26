class CodingCommon

  if gon?
    constant = gon.const
    class @Key


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

  @initTreeView = ->
    $('#tree').jstree({

    })

  @initEditor = ->
    ace.require("ace/ext/language_tools");
    editor = ace.edit("editor");
    editor.getSession().setMode("ace/mode/javascript")
    editor.setTheme("ace/theme/tomorrow")
    # enable autocompletion and snippets
    editor.setOptions({
      enableBasicAutocompletion: true
      enableSnippets: true
      enableLiveAutocompletion: false
    })