class CodingCommon

  if gon?
    constant = gon.const
    @DEFAULT_FILENAME = constant.Coding.DEFAULT_FILENAME
    @NOT_SAVED_PREFIX = '* '
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

  @init = ->
    @initTreeView()
    @initEditor()

  @initTreeView = ->
    $('#tree').jstree()
    @setupTreeEvent()

  @initEditor = ->
    $('.editor').each( (e) ->
      editorId = $(@).attr('id')
      lang_type = $(@).attr('class').split(' ').filter((item, idx) -> item != 'editor')
      if lang_type.length > 0
        CodingCommon.setupEditor(editorId, lang_type[0])
    )

  @setupEditor = (editorId, lang_type) ->
    ace.require("ace/ext/language_tools");
    editor = ace.edit(editorId);
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
        CodingCommon.addNewFile(event.target, CodingCommon.Lang.JAVASCRIPT, (data) ->

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
        CodingCommon.addNewFile(event.target, CodingCommon.Lang.COFFEESCRIPT, (data) ->
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
      CodingCommon.addNewFolder(event.target, (data) ->
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
        _exec_func = (menuArray) ->
          for v in menuArray
            if v.children?
              _exec_func.call(@, v.children)
            if v.cmd == ui.cmd
              if v.func?
                v.func(event, ui)
        _exec_func.call(@, menu)

      beforeOpen: (event, ui) ->
        t = $(event.target)
        # 選択メニューを最前面に表示
        ui.menu.zIndex( $(event.target).zIndex() + 1)
        ref = $('#tree').jstree(true)
        ref.select_node(t)
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

  @addNewFile = (parentNode, lang_type, successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.LANG] = lang_type
    data[@Key.PARENT_NODE_PATH] = _parentNodePath(parentNode)
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


  @addNewFolder =(parentNode, successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.PARENT_NODE_PATH] = _parentNodePath(parentNode)
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
    _deactiveEditor()

    user_coding_id = editorData.user_coding_id
    code = editorData.code
    title = editorData.title
    lang_type = editorData.lang_type
    tab.append("<li class='active'><a href='uc_#{user_coding_id}_wrapper' data-toggle='tab'>#{title}</a></li>")
    tab_content.append("<div class='tab-pane fade in active' id='uc_#{user_coding_id}_wrapper'><div id='uc_#{user_coding_id}' class='editor #{lang_type}'></div></div>")
    @setupEditor("uc_#{user_coding_id}", lang_type)

  _parentNodePath = (select_node) ->
    path = $(select_node).parents('li.dir').map((n) -> $(@).text()).get()
    path.unshift($(select_node).text())
    reversePath = path.reverse()
    joinPath = reversePath.join('/')
    return joinPath

  _treeState = ->
    ret = []
    root = $('#tree')
    $('.dir, .tip', root).each((i) ->
      node_path = _parentNodePath(@)
      user_coding_id = $(@).find('.id')
      if user_coding_id?
        user_coding_id = parseInt(user_coding_id)
      is_opened = $(@).attr('aria-expanded') == 'true'
      ret.push({
        node_path: node_path
        user_coding_id: user_coding_id
        is_opened: is_opened
      })
    )
    return ret

  _codes = ->
    ret = []
    tab = $('#my_tab')
    tab.each((i) ->
      t = $(@)
      name = t.find('a:first').text().replace(CodingCommon.NOT_SAVED_PREFIX, '')
      tabContentId = t.find('a:first').attr('href').replace('#', '')
      lang_type = $("#{tabContentId}").find('.editor').attr('class').split(' ').filter((item, idx) -> item != 'editor')
      code = $("#{tabContentId}").find('.editor').text()
      ret.push({
        name: name
        lang_type: lang_type
        code: code
      })
    )
    return ret

  _deactiveEditor = ->
    $('#my_tab').children('li').removeClass('active')
    $('#my_tab_content').children('div').removeClass('active')
