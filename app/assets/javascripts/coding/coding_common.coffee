class CodingCommon

  if gon?
    constant = gon.const
    class @Key
      NAME = constant.Coding.Key.NAME
      LANG = constant.Coding.Key.LANG
      PUBLIC = constant.Coding.Key.PUBLIC
      CODE = constant.Coding.Key.CODE
      USER_CODING_ID = constant.Coding.Key.USER_CODING_ID
      TREE_STATE = constant.Coding.Key.TREE_STATE
      SUB_TREE = constant.Coding.Key.SUB_TREE
      NODE_PATH = constant.Coding.Key.NODE_PATH
      IS_OPENED = constant.Coding.Key.IS_OPENED

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

  @init = ->
    @initTreeView()
    @initEditor()

  @initTreeView = ->
    $('#tree').jstree()

  @initEditor = ->
    ace.require("ace/ext/language_tools");
    editor = ace.edit("editor");
    EditSession = require("ace/edit_session").EditSession
    js = new EditSession("some js code")
    css = new EditSession(["some", "css", "code here"])
    editor.setSession(js)
    editor.getSession().setMode("ace/mode/javascript")
    editor.setTheme("ace/theme/tomorrow")
    # enable autocompletion and snippets
    editor.setOptions({
      enableBasicAutocompletion: true
      enableSnippets: true
      enableLiveAutocompletion: false
    })

  @saveData = (successCallback = null, errorCallback = null) ->
    _treeState = ->

    data = {}
    data[@Key.TREE_STATE] = _treeState.call(@)
    $.ajax(
      {
        url: "/coding/save"
        type: "GET"
        dataType: "json"
        data: data
        success: (data)->
          if successCallback?
            successCallback(data)
        error: (data) ->
          if errorCallback?
            errorCallback(data)
      }
    )

  @loadCodeData = (successCallback = null, errorCallback = null) ->
    $.ajax(
      {
        url: "/coding/load_code"
        type: "GET"
        dataType: "json"
        success: (data)->
          if successCallback?
            successCallback(data)
        error: (data) ->
          if errorCallback?
            errorCallback(data)
      }
    )

  @loadTreeData = (successCallback = null, errorCallback = null) ->
    $.ajax(
      {
        url: "/coding/load_tree"
        type: "GET"
        dataType: "json"
        success: (data)->
          if successCallback?
            successCallback(data)
        error: (data) ->
          if errorCallback?
            errorCallback(data)
      }
    )

  @createTabEditor = (editorData) ->
    code = editorData.code
    title = editorData.title
