$ ->
  $('.coding.item_by_javascript').ready ->
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

  $('.coding.itme_by_coffeescript').ready ->
    ace.require("ace/ext/language_tools");
    editor = ace.edit("editor");
    editor.getSession().setMode("ace/mode/coffeescript")
    editor.setTheme("ace/theme/tomorrow")
    # enable autocompletion and snippets
    editor.setOptions({
      enableBasicAutocompletion: true
      enableSnippets: true
      enableLiveAutocompletion: false
    })