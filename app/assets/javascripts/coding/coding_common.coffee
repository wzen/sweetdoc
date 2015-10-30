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
      @TREE_DATA = constant.Coding.Key.TREE_DATA
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

    $('a[data-toggle="tab"]').on('shown.bs.tab', (e) ->
      # タブ切り替え
      CodingCommon.saveEditorState()
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
    root.on('open_node.jstree close_node.jstree', (node) ->
      # ツリー開閉
      CodingCommon.saveEditorState()
    )
    root.on('dblclick.jstree', (event) ->
      node = $(event.target).closest("li")
      if node.hasClass('tip')
        # エディタ表示
        CodingCommon.activeTabEditor(parseInt(node.find('.user_coding_id:first').val()))
    )
    @setupContextMenu()

  @setupContextMenu = ->
    @setupContextMenuByType('root')
    @setupContextMenuByType('dir')
    @setupContextMenuByType('tip')

  @setupContextMenuByType = (type) ->
    if type == 'root'
      element = $('#tree .jstree-anchor:first')
    else if type == 'dir'
      element = $('#tree .jstree-anchor:not(:first) .jstree-icon:not(.jstree-file)').closest('.jstree-anchor')
    else if type == 'tip'
      element = $('#tree .jstree-anchor .jstree-icon.jstree-file').closest('.jstree-anchor')

    Common.setupContextMenu(element, '#tree', {
      menu: CodingCommon.getContextMenuArray(type)
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
        ref = $('#tree').jstree(true)
        ref.deselect_all(true)
        ref.select_node(t)
    })


  @getContextMenuArray = (type) ->

    makeFile = {title: I18n.t('context_menu.new_file'), children: [
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
    ]}

    makeFolder = {title: I18n.t('context_menu.new_folder'), cmd: "new_folder", func: (event, ui) ->
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
    }

    deleteNode = {title: I18n.t('context_menu.delete'), cmd: "delete", func: (event, ui) ->
      # 削除
      if window.confirm(I18n.t('message.dialog.delete_node'))
        CodingCommon.deleteNode(event.target, ->
          # 表示削除
          ref = $('#tree').jstree(true)
          sel = ref.get_selected()
          if !sel.length
            return false
          sel = sel[0]
          ref.delete_node(sel)
        )
    }

    menu = []
    if type == 'root'
      menu = [makeFile, makeFolder]
    else if type == 'dir'
      menu = [makeFile, makeFolder, deleteNode]
    else if type == 'tip'
      menu = [deleteNode]
    return menu

  @closeTabView = (e) ->
    tab_li = $(e).closest('.tab_li')
    contentsId = tab_li.find('.tab_button:first').attr('href').replace('#', '')
    tab_li.remove()
    $("#{contentsId}").closest('.editor_wrapper').remove()
    if $('#my_tab').find('.tab_li.active').length == 0
      $('#my_tab').find('.tab_li:first').addClass('active')
    @saveEditorState()

  @saveAll = (successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.CODES] = _codes()
    data[@Key.TREE_DATA] = _treeState()
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
    data[@Key.TREE_DATA] = _treeState()
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

  @loadCodeData = (userCodingId, successCallback = null, errorCallback = null) ->
    data = {}
    data[CodingCommon.Key.USER_CODING_ID] = userCodingId
    $.ajax(
      {
        url: "/coding/load_code"
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

  @deleteNode =(selectNode, successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.NODE_PATH] = _parentNodePath(selectNode) + '/' + $('.jstree-anchor:first', selectNode).text()
    $.ajax(
      {
        url: "/coding/delete_node"
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

  @activeTabEditor = (user_coding_id) ->
    tab = $('#my_tab')
    if !tab? || tab.length == 0
      # タブビュー作成
      $('#editor_tab_wrapper').append('<ul id="my_tab" class="nav nav-tabs"></ul><div id="my_tab_content" class="tab-content"></div>')
      tab = $('#my_tab')
    tab_content = $('#my_tab_content')
    # 全てDeactive
    _deactiveEditor()

    editorWrapperId = "uc_#{user_coding_id}_wrapper"
    editorWrapper = $("##{editorWrapperId}")
    if !editorWrapper? || editorWrapper.length == 0
      # エディタ作成
      CodingCommon.loadCodeData(user_coding_id, (data) ->
        loaded = data.load_data[0]
        code = loaded.code
        title = loaded.name
        lang_type = loaded.lang_type

        tab.append("<li class='tab_li active'><a class='tab_button' href='uc_#{user_coding_id}_wrapper' data-toggle='tab'>#{title}</a><a class='close_tab_button'></a></li>")
        tab_content.append("<div class='editor_wrapper #{lang_type}'><div class='tab-pane fade in active' id='uc_#{user_coding_id}_wrapper'><div id='uc_#{user_coding_id}' class='editor'></div></div></div>")
        CodingCommon.setupEditor("uc_#{user_coding_id}", lang_type)
      )

    else
      # 対象エディタをActiveに
      editorWrapper.addClass('active')
      tab.find("a[href='##{editorWrapperId}']").closest('tab_li').addClass('active')

    @saveEditorState()

  @saveEditorState = ->
    if window.saveEditorStateNowSaving? && window.saveEditorStateNowSaving
      return

    idleSeconds = 5
    if saveEditorStateTimer?
      clearTimeout(saveEditorStateTimer)
    saveEditorStateTimer = setTimeout( ->
      window.saveEditorStateNowSaving = true
      data = {}
      data[CodingCommon.Key.CODES] = _codes()
      data[CodingCommon.Key.TREE_DATA] = _treeState()
      $.ajax(
        {
          url: "/coding/save_state"
          type: "POST"
          dataType: "json"
          data: data
          success: (data)->
            window.saveEditorStateNowSaving = false
          error: (data) ->
            window.saveEditorStateNowSaving = false
        }
      )
    , idleSeconds * 1000)

  _parentNodePath = (select_node) ->
    path = $(select_node).parents('li.dir').map((n) -> $(@).text()).get()
    path.unshift($('.jstree-anchor:first', select_node).text())
    reversePath = path.reverse()
    joinPath = reversePath.join('/')
    return joinPath

  _treeState = ->
    ret = []
    root = $('#tree')
    jt = root.jstree(true)
    $('.dir, .tip', root).each((i) ->
      node_path = _parentNodePath(@)
      user_coding_id = $(@).find('.id')
      if user_coding_id?
        user_coding_id = parseInt(user_coding_id)
      is_opened = jt.is_open(@)
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
      editorWrapperId = t.find('a:first').attr('href').replace('#', '')
      lang_type = $("##{editorWrapperId}").closest('.editor_wrapper').attr('class').split(' ').filter((item, idx) -> item != 'editor_wrapper')
      lang_type = lang_type[0]
      editor = ace.edit(editorWrapperId.replace('_wrapper', ''))
      code = editor.getValue()
      is_active = $("##{editorWrapperId}").find('.tab-pane:first').hasClass('active')
      user_coding_id = parseInt(editorWrapperId.replace('uc_', '').replace('_wrapper', ''))
      ret.push({
        user_coding_id: user_coding_id
        name: name
        lang_type: lang_type
        code: code
        is_opened: true
        is_active: is_active
      })
    )
    return ret

  _deactiveEditor = ->
    $('#my_tab').children('li').removeClass('active')
    $('#my_tab_content').children('div').removeClass('active')

