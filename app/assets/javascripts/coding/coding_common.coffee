class CodingCommon

  if gon?
    constant = gon.const
    @DEFAULT_FILENAME = constant.Coding.DEFAULT_FILENAME
    @NOT_SAVED_PREFIX = '* '
    class @Key
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
    window.editing = {}

  @initTreeView = ->
    $('#tree').jstree(
      "core" : {
        "check_callback": true
      }
      "types": {
        "#" : {
          "max_children" : 1,
          "valid_children" : ["root"]
        }
        "default": {
        }
        "root": {
          "valid_children": ["folder", "js_file", "coffee_file"],
          'icon': '/assets/coding/tree/node_icon_root.png'
        },
        "folder": {
          "valid_children": ["folder", "js_file", "coffee_file"],
        }
        "js_file" : {
          'icon': '/assets/coding/tree/node_icon_js.png'
          "valid_children" : []
        }
        "coffee_file" : {
          'icon': '/assets/coding/tree/node_icon_coffee.png'
          "valid_children" : []
        }

      }
      "plugins": ['types']
    )
    @setupTreeEvent()

  @initEditor = ->
    $('.editor').each( (e) ->
      editorId = $(@).attr('id')
      lang_type = $(@).next(".#{CodingCommon.Key.LANG}").val()
      CodingCommon.setupEditor(editorId, lang_type)
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
      editor.getSession().setMode("ace/mode/coffee")
    editor.setTheme("ace/theme/tomorrow")
    # enable autocompletion and snippets
    editor.setOptions({
      enableBasicAutocompletion: true
      enableSnippets: true
      enableLiveAutocompletion: true
    })

    editor.getSession().off('change')
    editor.getSession().on('change', (e) ->
      if !window.editing[editorId]? || !window.editing[editorId]
        # 編集フラグ
        window.editing[editorId] = true
        tab = $('#my_tab').find("a[href=##{editorId}_wrapper]")
        name = tab.text().replace(/\*/g, '')
        tab.text("*#{name}")
    )

    editor.commands.addCommand(
      Name : "savefile"
      bindKey: {
        win : "Ctrl-S",
        mac : "Command-S"
      }
      exec: (editor) ->
        CodingCommon.saveActiveCode( ->
          editorId = $(editor.container).attr('id')
          # 編集フラグ消去
          window.editing[editorId] = false
          tab = $('#my_tab').find("a[href=##{editorId}_wrapper]")
          name = tab.text()
          tab.text(name.replace(/\*/g, ''))
        )
    )

    $('.close_tab_button').off('click')
    $('.close_tab_button').on('click', ->
      CodingCommon.closeTabView(@)
    )

  @setupTreeEvent = ->
    root = $('#tree')

    root.off('open_node.jstree close_node.jstree.my')
    root.on('open_node.jstree close_node.jstree.my', (node) ->
      # ツリー開閉
      CodingCommon.saveEditorState()
    )

    root.off('dblclick.jstree.my')
    root.on('dblclick.jstree.my', (event) ->
      node = $(event.target).closest("li")
      path = _userCodingClassNameByNodePath(_parentNodePath(node))
      if node.hasClass('js') || node.hasClass('coffee')
        # エディタ表示
        CodingCommon.activeTabEditor(parseInt($('#tree_wrapper').find(".user_coding_id.#{path}").val()))
    )
    @setupContextMenu()

  @setupContextMenu = ->
    @setupContextMenuByType('root')
    @setupContextMenuByType('dir')
    @setupContextMenuByType('tip')

  @setupContextMenuByType = (type) ->
    if type == 'root'
      element = $("#tree li.root").children('.jstree-anchor')
    else if type == 'dir'
      element = $("#tree li.folder").children('.jstree-anchor')
    else if type == 'tip'
      element = $("#tree li.js, #tree li.coffee").children('.jstree-anchor')

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
        _exec_func.call(@, CodingCommon.getContextMenuArray(type))

      beforeOpen: (event, ui) ->
        t = $(event.target)
        ref = $('#tree').jstree(true)
        ref.deselect_all(true)
        ref.select_node(t)
    })


  @getContextMenuArray = (type) ->

    _countSameFilename = (node, name, ext = '')->
      childrenText = $(node).next('.jstree-children').find('.jstree-node > .jstree-anchor').map(-> $(@).text())
      count = 1
      while count < 100
        num = if count <= 1 then '' else count
        if $.inArray("#{name}#{num}#{ext}", childrenText) < 0
          break
        count += 1
      return count

    makeFile = {title: I18n.t('context_menu.new_file'), children: [
      {title: I18n.t('context_menu.js'), cmd: "js", func: (event, ui) ->
        sameNameCount = _countSameFilename(event.target, CodingCommon.DEFAULT_FILENAME, '.js')
        num = if sameNameCount <= 1 then '' else sameNameCount
        # JavaScriptファイル作成
        filename = "#{CodingCommon.DEFAULT_FILENAME + num}.js"
        CodingCommon.addNewFile(event.target, filename, CodingCommon.Lang.JAVASCRIPT)
      }
      {title: I18n.t('context_menu.coffee'), cmd: "coffee", func: (event, ui) ->
        sameNameCount = _countSameFilename(event.target, CodingCommon.DEFAULT_FILENAME, '.coffee')
        num = if sameNameCount <= 1 then '' else sameNameCount
        # CoffeeScriptファイル作成
        filename = "#{CodingCommon.DEFAULT_FILENAME + num}.coffee"
        CodingCommon.addNewFile(event.target, filename, CodingCommon.Lang.COFFEESCRIPT)
      }
    ]}

    makeFolder = {title: I18n.t('context_menu.new_folder'), cmd: "new_folder", func: (event, ui) ->
      sameNameCount = _countSameFilename(event.target, CodingCommon.DEFAULT_FILENAME)
      num = if sameNameCount <= 1 then '' else sameNameCount
      # フォルダ作成
      folderName = CodingCommon.DEFAULT_FILENAME + num
      CodingCommon.addNewFolder(event.target, folderName)
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
          # ノード削除
          ref.delete_node(sel)
          # コンテキストメニュー再設定
          CodingCommon.setupContextMenu()
          # 状態保存
          CodingCommon.saveEditorState(true)
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
    $("##{contentsId}").closest('.tab-pane').remove()
    if $('#my_tab').find('.tab_li.active').length == 0
      $('#my_tab').find('.tab_li:first').addClass('active')
      cid = $('#my_tab').find('.tab_li:first .tab_button').attr('href').replace('#', '')
      $("##{cid}").addClass('active')

    @saveEditorState()

  @saveAll = (successCallback = null, errorCallback = null) ->
    if $.map(window.editing, (value) -> if value then '' else null ).length > 0

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
            # 編集フラグ消去
            for k, v of window.editing
              window.editing[k] = false
            tabs = $('#my_tab').find(".tab_button")
            tabs.each( ->
              name = $(@).text()
              $(@).text(name.replace(/\*/g, ''))
            )

            if data.resultSuccess
              if successCallback?
                successCallback(data)
            else
              if errorCallback?
                errorCallback(data)
              console.log('/coding/save_all server error')
          error: (data) ->
            if errorCallback?
              errorCallback(data)
            console.log('/coding/save_all ajax error')
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
          if data.resultSuccess
            if successCallback?
              successCallback(data)
          else
            console.log('/coding/save_tree server error')
            if errorCallback?
              errorCallback(data)
        error: (data) ->
          console.log('/coding/save_tree ajax error')
          if errorCallback?
            errorCallback(data)
      }
    )

  @saveAllCode = (successCallback = null, errorCallback = null) ->
    if $.map(window.editing, (value) -> if value then '' else null ).length > 0

      data = {}
      data[@Key.CODES] = _codes()
      $.ajax(
        {
          url: "/coding/update_code"
          type: "POST"
          dataType: "json"
          data: data
          success: (data)->
            # 編集フラグ消去
            for k, v of window.editing
              window.editing[k] = false
            tabs = $('#my_tab').find(".tab_button")
            tabs.each( ->
              name = $(@).text()
              $(@).text(name.replace(/\*/g, ''))
            )

            if data.resultSuccess
              if successCallback?
                successCallback(data)
            else
              console.log('/coding/save_code server error')
              if errorCallback?
                errorCallback(data)
          error: (data) ->
            console.log('/coding/save_code ajax error')
            if errorCallback?
              errorCallback(data)
        }
      )

  @saveActiveCode = (successCallback = null, errorCallback = null) ->
    editorId = _activeEditorId()
    if window.editing[editorId]? && window.editing[editorId]
      data = {}
      data[@Key.CODES] = _codes(editorId)
      $.ajax(
        {
          url: "/coding/update_code"
          type: "POST"
          dataType: "json"
          data: data
          success: (data)->
            if data.resultSuccess
              if successCallback?
                successCallback(data)
            else
              console.log('/coding/save_code server error')
              if errorCallback?
                errorCallback(data)
          error: (data) ->
            console.log('/coding/save_code ajax error')
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
          if data.resultSuccess
            if successCallback?
              successCallback(data)
          else
            console.log('coding/load_code server error')
            if errorCallback?
              errorCallback(data)
        error: (data) ->
          console.log('coding/load_code ajax error')
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
          if data.resultSuccess
            if successCallback?
              successCallback(data)
          else
            console.log('/coding/load_tree server error')
            if errorCallback?
              errorCallback(data)
        error: (data) ->
          console.log('/coding/load_tree ajax error')
          if errorCallback?
            errorCallback(data)
      }
    )

  @addNewFile = (parentNode, name, lang_type, successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.LANG] = lang_type
    node_path = _parentNodePath(parentNode) + '/' + name
    data[@Key.NODE_PATH] = node_path
    $.ajax(
      {
        url: "/coding/add_new_file"
        type: "POST"
        dataType: "json"
        data: data
        success: (data)->
          if data.resultSuccess
            type = ''
            if lang_type == CodingCommon.Lang.JAVASCRIPT
              type = 'js_file'
            else if lang_type == CodingCommon.Lang.COFFEESCRIPT
              type = 'coffee_file'
            ref = $('#tree').jstree(true)
            sel = ref.get_selected()
            if !sel.length
              return false
            sel = sel[0]
            ref.create_node(sel, {"type" : type, text: name}, 'last', (e) ->
              # クラス名設定
              if lang_type == CodingCommon.Lang.JAVASCRIPT
                className = 'js'
              else if lang_type == CodingCommon.Lang.COFFEESCRIPT
                className = 'coffee'
              $("##{e.id}").addClass(className)
              # フォルダオープン
              ref.open_node(sel, ->
                # user_coding_id追加
                $('#tree_wrapper').append("<input type='hidden' class='user_coding_id #{_userCodingClassNameByNodePath(node_path)}' value='#{data.add_user_coding_id}' />")
                # イベント再設定
                CodingCommon.setupTreeEvent()
                # 状態保存
                CodingCommon.saveEditorState(true)
                # エディタ表示
                CodingCommon.activeTabEditor(parseInt($('#tree_wrapper').find(".user_coding_id.#{_userCodingClassNameByNodePath(node_path)}").val()))
              )
            )
            if successCallback?
              successCallback(data)
          else
            console.log('/coding/add_new_file server error')
            if errorCallback?
              errorCallback(data)
        error: (data) ->
          console.log('/coding/add_new_file ajax error')
          if errorCallback?
            errorCallback(data)
      }
    )

  @addNewFolder =(parentNode, name, successCallback = null, errorCallback = null) ->
    data = {}
    nodePath = _parentNodePath(parentNode) + '/' + name
    data[@Key.NODE_PATH] = nodePath
    $.ajax(
      {
        url: "/coding/add_new_folder"
        type: "POST"
        dataType: "json"
        data: data
        success: (data)->
          if data.resultSuccess
            ref = $('#tree').jstree(true)
            sel = ref.get_selected()
            if !sel.length
              return false
            sel = sel[0]
            sel = ref.create_node(sel, {type:"folder", text: name}, 'last', (e) ->
              # クラス名設定
              $("##{e.id}").addClass('folder')
              # フォルダオープン
              ref.open_node(sel, ->
                # イベント再設定
                CodingCommon.setupTreeEvent()
                # 状態保存
                CodingCommon.saveEditorState(true)
               )
            )
            if successCallback?
              successCallback(data)
          else
            console.log('/coding/add_new_folder server error')
            if errorCallback?
              errorCallback(data)
        error: (data) ->
          console.log('/coding/add_new_folder ajax error')
          if errorCallback?
            errorCallback(data)
      }
    )

  @deleteNode =(selectNode, successCallback = null, errorCallback = null) ->
    data = {}
    data[@Key.NODE_PATH] = _parentNodePath(selectNode) + '/' + $(selectNode).text()
    $.ajax(
      {
        url: "/coding/delete_node"
        type: "POST"
        dataType: "json"
        data: data
        success: (data)->
          if data.resultSuccess
            if successCallback?
              successCallback(data)
          else
            console.log('/coding/delete_node server error')
            if errorCallback?
              errorCallback(data)
        error: (data) ->
          console.log('/coding/delete_node ajax error')
          if errorCallback?
            errorCallback(data)
      }
    )

  @activeTabEditor = (user_coding_id) ->
    tab = $('#my_tab')
    if !tab? || tab.length == 0
      # タブビュー作成
      $('#editor_tab_wrapper').append('<div id="editor_header_menu"><div><div><a class="btn preview">Preview</a></div></div></div><div id="editor_contents_wrapper"><div><ul id="my_tab" class="nav nav-tabs" role="tablist"></ul><div id="my_tab_content" class="tab-content"></div></div></div>')
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
        nodes = loaded.node_path.split('/')
        title = nodes[nodes.length - 1]
        lang_type = loaded.lang_type

        tab.append("<li role='presentation' class='tab_li active'><a class='tab_button' aria-controls='uc_#{user_coding_id}_wrapper' href='#uc_#{user_coding_id}_wrapper' role='tab' data-toggle='tab'>#{title}</a><a class='close_tab_button'></a></li>")
        tab_content.append("<div role='tabpanel' class='tab-pane active' id='uc_#{user_coding_id}_wrapper'><div id='uc_#{user_coding_id}' class='editor'>#{code}</div></div>")
        CodingCommon.setupEditor("uc_#{user_coding_id}", lang_type)
        CodingCommon.saveEditorState()
      )

    else
      # 対象エディタをActiveに
      editorWrapper.addClass('active')
      tab.find("a[href='##{editorWrapperId}']").closest('tab_li').addClass('active')
      CodingCommon.saveEditorState()

  @saveEditorState = (immediate = false) ->
    if window.saveEditorStateNowSaving? && window.saveEditorStateNowSaving
      return

    idleSeconds = if immediate then 0 else 5
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
            if data.resultSuccess
              window.saveEditorStateNowSaving = false
            else
              console.log('/coding/save_state server error')
          error: (data) ->
            console.log('/coding/save_state ajax error')
            window.saveEditorStateNowSaving = false
        }
      )
    , idleSeconds * 1000)

  _parentNodePath = (select_node) ->
    path = $(select_node).parents('.jstree-children').prev('.jstree-anchor').map((n) -> $(@).text()).get()
    path.unshift($(select_node).text())
    reversePath = path.reverse()
    joinPath = reversePath.join('/')
    return joinPath

  _treeState = ->
    ret = []
    root = $('#tree')
    jt = root.jstree(true)
    $('.jstree-node', root).each((i) ->
      node_path = _parentNodePath($(@).children('.jstree-anchor:first'))
      user_coding_id = $('#tree_wrapper').find(".user_coding_id.#{_userCodingClassNameByNodePath(node_path)}").val()
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

  _codes = (targetEditorId = null) ->
    ret = []
    tab = $('#my_tab')
    tab.children('li').each((i) ->
      t = $(@)
      editorWrapperId = t.find('a:first').attr('href').replace('#', '')
      editorId = editorWrapperId.replace('_wrapper', '')

      if targetEditorId? && editorId != targetEditorId
        # 対象外のEditorはパス
        return true

      editor = ace.edit(editorId)
      code = editor.getValue()
      is_active = $("##{editorWrapperId}").hasClass('active')
      user_coding_id = parseInt(editorWrapperId.replace('uc_', '').replace('_wrapper', ''))
      ret.push({
        user_coding_id: user_coding_id
        code: code
        is_opened: true
        is_active: is_active
      })
    )
    return ret

  _deactiveEditor = ->
    $('#my_tab').children('li').removeClass('active')
    $('#my_tab_content').children('div').removeClass('active')

  _activeEditorId = ->
    $('#my_tab').children('.active:first').find('.tab_button:first').attr('href').replace('#', '').replace('_wrapper', '')

  _userCodingClassNameByNodePath = (nodePath) ->
    return nodePath.replace(/\//g, '_').replace('.', '_')