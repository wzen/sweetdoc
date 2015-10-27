class CodingCommon

  if gon?
    constant = gon.const
    class @Key
      NAME = constant.Coding.Key.NAME
      LANG = constant.Coding.Key.LANG
      PUBLIC = constant.Coding.Key.PUBLIC
      CODE = constant.Coding.Key.CODE
      CODES = constant.Coding.Key.CODES
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
    @setupTreeEvent()

  @initEditor = ->
#    ace.require("ace/ext/language_tools");
#    editor = ace.edit("editor");
#    EditSession = require("ace/edit_session").EditSession
#    js = new EditSession("some js code")
#    css = new EditSession(["some", "css", "code here"])
#    editor.setSession(js)
#    editor.getSession().setMode("ace/mode/javascript")
#    editor.setTheme("ace/theme/tomorrow")
#    # enable autocompletion and snippets
#    editor.setOptions({
#      enableBasicAutocompletion: true
#      enableSnippets: true
#      enableLiveAutocompletion: false
#    })

  @setupTreeEvent = ->
    root = $('#tree')
    $('.dir, .tip', root).off('click')
    $('.dir, .tip', root).on('click', (e) ->
      e.preventDefault()
    )
    @setupContextMenu()

  @setupContextMenu = ->
    menu = []
    menu.push({title: I18n.t('context_menu.new_file'), children: [
      {title: I18n.t('context_menu.js'), cmd: "js", func: (event, ui) ->
        # JavaScriptファイル作成
        # フォルダオープン
        console.log('select JavaScript')
      }
      {title: I18n.t('context_menu.coffee'), cmd: "coffee", func: (event, ui) ->
        # CoffeeScriptファイル作成
        # フォルダオープン
        console.log('select CoffeeScript')
      }
    ]})
    menu.push({title: I18n.t('context_menu.new_folder'), cmd: "new_folder", func: (event, ui) ->
      # フォルダ作成
      console.log('select CoffeeScript')
    })
    Common.setupContextMenu($('#tree .dir'), '#tree', {
      menu: menu
      select: (event, ui) ->
        for value in menu
          if value.cmd == ui.cmd
            if value.func?
              value.func(event, ui)
      beforeOpen: (event, ui) ->
        t = $(event.target)
        # 選択メニューを最前面に表示
        ui.menu.zIndex( $(event.target).zIndex() + 1)
    })


  @saveAll = (successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.CODES] = _codes()
    data[@Key.TREE_STATE] = _treeState()
    $.ajax(
      {
        url: "/coding/save_all"
        type: "POST"
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

  @saveTree = (successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.TREE_STATE] = _treeState()
    $.ajax(
      {
        url: "/coding/save_tree"
        type: "POST"
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


  @saveCode = (successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.CODES] = _codes()
    $.ajax(
      {
        url: "/coding/save_code"
        type: "POST"
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

  _treeState = ->


  _codes = ->
