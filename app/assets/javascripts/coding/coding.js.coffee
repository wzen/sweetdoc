$ ->
  $('.coding.item').ready ->

    # TODO: 保存データ読み込み

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