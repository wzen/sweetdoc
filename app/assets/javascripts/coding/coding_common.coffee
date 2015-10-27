class CodingCommon

  if gon?
    constant = gon.const
    @DEFAULT_FILENAME = constant.Coding.DEFAULT_FILENAME
    class @Key
      @NAME = constant.Coding.Key.NAME
      @LANG = constant.Coding.Key.LANG
      @PUBLIC = constant.Coding.Key.PUBLIC
      @CODE = constant.Coding.Key.CODE
      @CODES = constant.Coding.Key.CODES
      @USER_CODING_ID = constant.Coding.Key.USER_CODING_ID
      @TREE_STATE = constant.Coding.Key.TREE_STATE
      @SUB_TREE = constant.Coding.Key.SUB_TREE
      @NODE_PATH = constant.Coding.Key.NODE_PATH
      @IS_OPENED = constant.Coding.Key.IS_OPENED
      @PARENT_NODE_PATH = constant.Coding.Key.PARENT_NODE_PATH
    class @Lang
      @JAVASCRIPT = constant.Coding.Lang.JAVASCRIPT
      @COFFEESCRIPT = constant.Coding.Lang.COFFEESCRIPT

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
    $('.editor').each( (e) =>
      editorId = $(@).attr('id')
      lang_type = $(@).attr('class').split(' ').filter((item, idx) -> item != 'editor')
      if lang_type.length > 0
        @setupEditor(editorId, lang_type[0])
    )

  @setupEditor = (editorId, lang_type) ->
    ace.require("ace/ext/language_tools");
    editor = ace.edit(editorId);
    EditSession = require("ace/edit_session").EditSession
    if lang_type == @Lang.JAVASCRIPT
      editor.getSession().setMode("ace/mode/javascript")
    else
      editor.getSession().setMode("ace/mode/coffeescript")
    editor.setTheme("ace/theme/tomorrow")
    # enable autocompletion and snippets
    editor.setOptions({
      enableBasicAutocompletion: true
      enableSnippets: true
      enableLiveAutocompletion: false
    })

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
        CodingCommon.addNewFile(@Lang.JAVASCRIPT, (data) ->

          ref = $('#tree').jstree(true)
          sel = ref.get_selected()
          if !sel.length
            return false
          sel = sel[0]
          sel = ref.create_node(sel, {"type":"file", text: "#{CodingCommon.DEFAULT_FILENAME}.js"}, 'last', ->
            # エディタ作成

          )
        , (data)->
        )
      }
      {title: I18n.t('context_menu.coffee'), cmd: "coffee", func: (event, ui) ->
        # CoffeeScriptファイル作成
        CodingCommon.addNewFile(@Lang.COFFEESCRIPT, (data) ->
          ref = $('#tree').jstree(true)
          sel = ref.get_selected()
          if !sel.length
            return false
          sel = sel[0]
          sel = ref.create_node(sel, {"type":"file", text: "#{CodingCommon.DEFAULT_FILENAME}.coffee"}, 'last', ->
            # エディタ作成


          )
        , (data)->
        )
      }
    ]})
    menu.push({title: I18n.t('context_menu.new_folder'), cmd: "new_folder", func: (event, ui) ->
      CodingCommon.addNewFolder((data) ->
        # フォルダ作成
        ref = $('#tree').jstree(true)
        sel = ref.get_selected()
        if !sel.length
          return false
        sel = sel[0]
        sel = ref.create_node(sel, {type:"folder", text: "#{CodingCommon.DEFAULT_FILENAME}.coffee"})
      , (data) ->
      )
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

  @addNewFile = (lang_type, successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.LANG] = lang_type
    data[@Key.PARENT_NODE_PATH] = _parentNodePath()
    $.ajax(
      {
        url: "/coding/add_new_file"
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


  @addNewFolder =(successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.PARENT_NODE_PATH] = _parentNodePath()
    $.ajax(
      {
        url: "/coding/add_new_folder"
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

  @createTabEditor = (editorData) ->
    tab = $('#my_tab')
    if !tab?
      # タブビュー作成
      $('#editor_wrapper').append('<ul id="my_tab" class="nav nav-tabs"></ul><div id="my_tab_content" class="tab-content"></div>')
      tab = $('#my_tab')
    tab_content = $('#my_tab_content')

    user_coding_id = editorData.user_coding_id
    code = editorData.code
    title = editorData.title
    lang_type = editorData.lang_type
    tab.append("<li class='active'><a href='uc_#{user_coding_id}_wrapper' data-toggle='tab'>#{title}</a></li>")
    tab_content.append("<div class='tab-pane fade in active' id='uc_#{user_coding_id}_wrapper'><div id='uc_#{user_coding_id}' class='editor #{lang_type}'></div></div>")
    @setupEditor("uc_#{user_coding_id}", lang_type)

  _parentNodePath = ->


  _treeState = ->


  _codes = ->
