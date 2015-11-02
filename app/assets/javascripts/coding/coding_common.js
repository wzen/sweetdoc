// Generated by CoffeeScript 1.9.2
var CodingCommon;

CodingCommon = (function() {
  var _activeEditorId, _codes, _deactiveEditor, _parentNodePath, _treeState, constant;

  function CodingCommon() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    CodingCommon.DEFAULT_FILENAME = constant.Coding.DEFAULT_FILENAME;
    CodingCommon.NOT_SAVED_PREFIX = '* ';
    CodingCommon.Key = (function() {
      function Key() {}

      Key.LANG = constant.Coding.Key.LANG;

      Key.PUBLIC = constant.Coding.Key.PUBLIC;

      Key.CODE = constant.Coding.Key.CODE;

      Key.CODES = constant.Coding.Key.CODES;

      Key.USER_CODING_ID = constant.Coding.Key.USER_CODING_ID;

      Key.TREE_DATA = constant.Coding.Key.TREE_DATA;

      Key.SUB_TREE = constant.Coding.Key.SUB_TREE;

      Key.NODE_PATH = constant.Coding.Key.NODE_PATH;

      Key.IS_OPENED = constant.Coding.Key.IS_OPENED;

      Key.PARENT_NODE_PATH = constant.Coding.Key.PARENT_NODE_PATH;

      return Key;

    })();
    CodingCommon.Lang = (function() {
      function Lang() {}

      Lang.JAVASCRIPT = constant.Coding.Lang.JAVASCRIPT;

      Lang.COFFEESCRIPT = constant.Coding.Lang.COFFEESCRIPT;

      return Lang;

    })();
  }

  CodingCommon.init = function() {
    this.initTreeView();
    this.initEditor();
    return window.editing = {};
  };

  CodingCommon.initTreeView = function() {
    $('#tree').jstree({
      "core": {
        "check_callback": true
      },
      "types": {
        "#": {
          "max_children": 1,
          "valid_children": ["root"]
        },
        "default": {},
        "root": {
          "valid_children": ["folder", "js_file", "coffee_file"],
          'icon': '/assets/coding/tree/node_icon_root.png'
        },
        "folder": {
          "valid_children": ["folder", "js_file", "coffee_file"]
        },
        "js_file": {
          'icon': '/assets/coding/tree/node_icon_js.png',
          "valid_children": []
        },
        "coffee_file": {
          'icon': '/assets/coding/tree/node_icon_coffee.png',
          "valid_children": []
        }
      },
      "plugins": ['types']
    });
    return this.setupTreeEvent();
  };

  CodingCommon.initEditor = function() {
    $('.editor').each(function(e) {
      var editorId, lang_type;
      editorId = $(this).attr('id');
      lang_type = $(this).next("." + CodingCommon.Key.LANG).val();
      return CodingCommon.setupEditor(editorId, lang_type);
    });
    return $('a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
      return CodingCommon.saveEditorState();
    });
  };

  CodingCommon.setupEditor = function(editorId, lang_type) {
    var editor;
    ace.require("ace/ext/language_tools");
    editor = ace.edit(editorId);
    if (lang_type === this.Lang.JAVASCRIPT) {
      editor.getSession().setMode("ace/mode/javascript");
    } else {
      editor.getSession().setMode("ace/mode/coffee");
    }
    editor.setTheme("ace/theme/tomorrow");
    editor.setOptions({
      enableBasicAutocompletion: true,
      enableSnippets: true,
      enableLiveAutocompletion: true
    });
    editor.getSession().off('change');
    editor.getSession().on('change', function(e) {
      var name, tab;
      if ((window.editing[editorId] == null) || !window.editing[editorId]) {
        window.editing[editorId] = true;
        tab = $('#my_tab').find("a[href=#" + editorId + "_wrapper]");
        name = tab.text().replace(/\*/g, '');
        return tab.text("*" + name);
      }
    });
    editor.commands.addCommand({
      Name: "savefile",
      bindKey: {
        win: "Ctrl-S",
        mac: "Command-S"
      },
      exec: function(editor) {
        return CodingCommon.saveActiveCode(function() {
          var name, tab;
          editorId = $(editor.container).attr('id');
          window.editing[editorId] = false;
          tab = $('#my_tab').find("a[href=#" + editorId + "_wrapper]");
          name = tab.text();
          return tab.text(name.replace(/\*/g, ''));
        });
      }
    });
    $('.close_tab_button').off('click');
    return $('.close_tab_button').on('click', function() {
      return CodingCommon.closeTabView(this);
    });
  };

  CodingCommon.setupTreeEvent = function() {
    var root;
    root = $('#tree');
    root.off('open_node.jstree close_node.jstree.my');
    root.on('open_node.jstree close_node.jstree.my', function(node) {
      return CodingCommon.saveEditorState();
    });
    root.off('dblclick.jstree.my');
    root.on('dblclick.jstree.my', function(event) {
      var node, path;
      node = $(event.target).closest("li");
      path = _parentNodePath(node).replace(/\//g, '_').replace('.', '_');
      if (node.hasClass('jstree-leaf')) {
        return CodingCommon.activeTabEditor(parseInt($('#tree_wrapper').find(".user_coding_id." + path).val()));
      }
    });
    return this.setupContextMenu();
  };

  CodingCommon.setupContextMenu = function() {
    this.setupContextMenuByType('root');
    this.setupContextMenuByType('dir');
    return this.setupContextMenuByType('tip');
  };

  CodingCommon.setupContextMenuByType = function(type) {
    var element;
    if (type === 'root') {
      element = $('#tree .jstree-anchor:first');
    } else if (type === 'dir') {
      element = $('#tree .jstree-anchor:not(:first) .jstree-icon:not(.jstree-file)').closest('.jstree-anchor');
    } else if (type === 'tip') {
      element = $('#tree .jstree-anchor .jstree-icon.jstree-file').closest('.jstree-anchor');
    }
    return Common.setupContextMenu(element, '#tree', {
      menu: CodingCommon.getContextMenuArray(type),
      select: function(event, ui) {
        var _exec_func;
        _exec_func = function(menuArray) {
          var j, len, results, v;
          results = [];
          for (j = 0, len = menuArray.length; j < len; j++) {
            v = menuArray[j];
            if (v.children != null) {
              _exec_func.call(this, v.children);
            }
            if (v.cmd === ui.cmd) {
              if (v.func != null) {
                results.push(v.func(event, ui));
              } else {
                results.push(void 0);
              }
            } else {
              results.push(void 0);
            }
          }
          return results;
        };
        return _exec_func.call(this, CodingCommon.getContextMenuArray(type));
      },
      beforeOpen: function(event, ui) {
        var ref, t;
        t = $(event.target);
        ref = $('#tree').jstree(true);
        ref.deselect_all(true);
        return ref.select_node(t);
      }
    });
  };

  CodingCommon.getContextMenuArray = function(type) {
    var _countSameFilename, deleteNode, makeFile, makeFolder, menu;
    _countSameFilename = function(node, name, ext) {
      var childrenText, count, num;
      if (ext == null) {
        ext = '';
      }
      childrenText = $(node).next('.jstree-children').find('.jstree-node > .jstree-anchor').map(function() {
        return $(this).text();
      });
      count = 1;
      while (count < 100) {
        num = count <= 1 ? '' : count;
        if ($.inArray("" + name + num + ext, childrenText) < 0) {
          break;
        }
        count += 1;
      }
      return count;
    };
    makeFile = {
      title: I18n.t('context_menu.new_file'),
      children: [
        {
          title: I18n.t('context_menu.js'),
          cmd: "js",
          func: function(event, ui) {
            var filename, num, sameNameCount;
            sameNameCount = _countSameFilename(event.target, CodingCommon.DEFAULT_FILENAME, '.js');
            num = sameNameCount <= 1 ? '' : sameNameCount;
            filename = (CodingCommon.DEFAULT_FILENAME + num) + ".js";
            return CodingCommon.addNewFile(event.target, filename, CodingCommon.Lang.JAVASCRIPT);
          }
        }, {
          title: I18n.t('context_menu.coffee'),
          cmd: "coffee",
          func: function(event, ui) {
            var filename, num, sameNameCount;
            sameNameCount = _countSameFilename(event.target, CodingCommon.DEFAULT_FILENAME, '.coffee');
            num = sameNameCount <= 1 ? '' : sameNameCount;
            filename = (CodingCommon.DEFAULT_FILENAME + num) + ".coffee";
            return CodingCommon.addNewFile(event.target, filename, CodingCommon.Lang.COFFEESCRIPT);
          }
        }
      ]
    };
    makeFolder = {
      title: I18n.t('context_menu.new_folder'),
      cmd: "new_folder",
      func: function(event, ui) {
        var folderName, num, sameNameCount;
        sameNameCount = _countSameFilename(event.target, CodingCommon.DEFAULT_FILENAME);
        num = sameNameCount <= 1 ? '' : sameNameCount;
        folderName = CodingCommon.DEFAULT_FILENAME + num;
        return CodingCommon.addNewFolder(event.target, folderName);
      }
    };
    deleteNode = {
      title: I18n.t('context_menu.delete'),
      cmd: "delete",
      func: function(event, ui) {
        if (window.confirm(I18n.t('message.dialog.delete_node'))) {
          return CodingCommon.deleteNode(event.target, function() {
            var ref, sel;
            ref = $('#tree').jstree(true);
            sel = ref.get_selected();
            if (!sel.length) {
              return false;
            }
            sel = sel[0];
            ref.delete_node(sel);
            CodingCommon.setupContextMenu();
            return CodingCommon.saveEditorState(true);
          });
        }
      }
    };
    menu = [];
    if (type === 'root') {
      menu = [makeFile, makeFolder];
    } else if (type === 'dir') {
      menu = [makeFile, makeFolder, deleteNode];
    } else if (type === 'tip') {
      menu = [deleteNode];
    }
    return menu;
  };

  CodingCommon.closeTabView = function(e) {
    var cid, contentsId, tab_li;
    tab_li = $(e).closest('.tab_li');
    contentsId = tab_li.find('.tab_button:first').attr('href').replace('#', '');
    tab_li.remove();
    $("#" + contentsId).closest('.tab-pane').remove();
    if ($('#my_tab').find('.tab_li.active').length === 0) {
      $('#my_tab').find('.tab_li:first').addClass('active');
      cid = $('#my_tab').find('.tab_li:first .tab_button').attr('href').replace('#', '');
      $("#" + cid).addClass('active');
    }
    return this.saveEditorState();
  };

  CodingCommon.saveAll = function(successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    if ($.map(window.editing, function(value) {
      if (value) {
        return '';
      } else {
        return null;
      }
    }).length > 0) {
      data = {};
      data[this.Key.CODES] = _codes();
      data[this.Key.TREE_DATA] = _treeState();
      return $.ajax({
        url: "/coding/save_all",
        type: "POST",
        dataType: "json",
        data: data,
        success: function(data) {
          var k, ref1, tabs, v;
          ref1 = window.editing;
          for (k in ref1) {
            v = ref1[k];
            window.editing[k] = false;
          }
          tabs = $('#my_tab').find(".tab_button");
          tabs.each(function() {
            var name;
            name = $(this).text();
            return $(this).text(name.replace(/\*/g, ''));
          });
          if (data.resultSuccess) {
            if (successCallback != null) {
              return successCallback(data);
            }
          } else {
            if (errorCallback != null) {
              errorCallback(data);
            }
            return console.log('/coding/save_all server error');
          }
        },
        error: function(data) {
          if (errorCallback != null) {
            errorCallback(data);
          }
          return console.log('/coding/save_all ajax error');
        }
      });
    }
  };

  CodingCommon.saveTree = function(successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    data = {};
    data[this.Key.TREE_DATA] = _treeState();
    return $.ajax({
      url: "/coding/save_tree",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (data.resultSuccess) {
          if (successCallback != null) {
            return successCallback(data);
          }
        } else {
          console.log('/coding/save_tree server error');
          if (errorCallback != null) {
            return errorCallback(data);
          }
        }
      },
      error: function(data) {
        console.log('/coding/save_tree ajax error');
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.saveAllCode = function(successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    if ($.map(window.editing, function(value) {
      if (value) {
        return '';
      } else {
        return null;
      }
    }).length > 0) {
      data = {};
      data[this.Key.CODES] = _codes();
      return $.ajax({
        url: "/coding/update_code",
        type: "POST",
        dataType: "json",
        data: data,
        success: function(data) {
          var k, ref1, tabs, v;
          ref1 = window.editing;
          for (k in ref1) {
            v = ref1[k];
            window.editing[k] = false;
          }
          tabs = $('#my_tab').find(".tab_button");
          tabs.each(function() {
            var name;
            name = $(this).text();
            return $(this).text(name.replace(/\*/g, ''));
          });
          if (data.resultSuccess) {
            if (successCallback != null) {
              return successCallback(data);
            }
          } else {
            console.log('/coding/save_code server error');
            if (errorCallback != null) {
              return errorCallback(data);
            }
          }
        },
        error: function(data) {
          console.log('/coding/save_code ajax error');
          if (errorCallback != null) {
            return errorCallback(data);
          }
        }
      });
    }
  };

  CodingCommon.saveActiveCode = function(successCallback, errorCallback) {
    var data, editorId;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    editorId = _activeEditorId();
    if ((window.editing[editorId] != null) && window.editing[editorId]) {
      data = {};
      data[this.Key.CODES] = _codes(editorId);
      return $.ajax({
        url: "/coding/update_code",
        type: "POST",
        dataType: "json",
        data: data,
        success: function(data) {
          if (data.resultSuccess) {
            if (successCallback != null) {
              return successCallback(data);
            }
          } else {
            console.log('/coding/save_code server error');
            if (errorCallback != null) {
              return errorCallback(data);
            }
          }
        },
        error: function(data) {
          console.log('/coding/save_code ajax error');
          if (errorCallback != null) {
            return errorCallback(data);
          }
        }
      });
    }
  };

  CodingCommon.loadCodeData = function(userCodingId, successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    data = {};
    data[CodingCommon.Key.USER_CODING_ID] = userCodingId;
    return $.ajax({
      url: "/coding/load_code",
      type: "GET",
      dataType: "json",
      data: data,
      success: function(data) {
        if (data.resultSuccess) {
          if (successCallback != null) {
            return successCallback(data);
          }
        } else {
          console.log('coding/load_code server error');
          if (errorCallback != null) {
            return errorCallback(data);
          }
        }
      },
      error: function(data) {
        console.log('coding/load_code ajax error');
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.loadTreeData = function(successCallback, errorCallback) {
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    return $.ajax({
      url: "/coding/load_tree",
      type: "GET",
      dataType: "json",
      success: function(data) {
        if (data.resultSuccess) {
          if (successCallback != null) {
            return successCallback(data);
          }
        } else {
          console.log('/coding/load_tree server error');
          if (errorCallback != null) {
            return errorCallback(data);
          }
        }
      },
      error: function(data) {
        console.log('/coding/load_tree ajax error');
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.addNewFile = function(parentNode, name, lang_type, successCallback, errorCallback) {
    var data, node_path;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    data = {};
    data[this.Key.LANG] = lang_type;
    node_path = _parentNodePath(parentNode) + '/' + name;
    data[this.Key.NODE_PATH] = node_path;
    return $.ajax({
      url: "/coding/add_new_file",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        var ref, sel, type;
        if (data.resultSuccess) {
          type = '';
          if (lang_type === CodingCommon.Lang.JAVASCRIPT) {
            type = 'js_file';
          } else if (lang_type === CodingCommon.Lang.COFFEESCRIPT) {
            type = 'coffee_file';
          }
          ref = $('#tree').jstree(true);
          sel = ref.get_selected();
          if (!sel.length) {
            return false;
          }
          sel = sel[0];
          sel = ref.create_node(sel, {
            "type": type,
            text: name
          }, 'last', function() {
            return ref.open_node(sel, function() {
              var path;
              path = node_path.replace(/\//g, '_').replace('.', '_');
              $('#tree_wrapper').append("<input type='hidden' class='user_coding_id " + path + "' value='" + data.add_user_coding_id + "' />");
              CodingCommon.setupTreeEvent();
              return CodingCommon.saveEditorState(true);
            });
          });
          if (successCallback != null) {
            return successCallback(data);
          }
        } else {
          console.log('/coding/add_new_file server error');
          if (errorCallback != null) {
            return errorCallback(data);
          }
        }
      },
      error: function(data) {
        console.log('/coding/add_new_file ajax error');
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.addNewFolder = function(parentNode, name, successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    data = {};
    data[this.Key.NODE_PATH] = _parentNodePath(parentNode) + '/' + name;
    return $.ajax({
      url: "/coding/add_new_folder",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        var ref, sel;
        if (data.resultSuccess) {
          ref = $('#tree').jstree(true);
          sel = ref.get_selected();
          if (!sel.length) {
            return false;
          }
          sel = sel[0];
          sel = ref.create_node(sel, {
            type: "folder",
            text: name
          }, 'last', function() {
            return ref.open_node(sel, function() {
              CodingCommon.setupTreeEvent();
              return CodingCommon.saveEditorState(true);
            });
          });
          if (successCallback != null) {
            return successCallback(data);
          }
        } else {
          console.log('/coding/add_new_folder server error');
          if (errorCallback != null) {
            return errorCallback(data);
          }
        }
      },
      error: function(data) {
        console.log('/coding/add_new_folder ajax error');
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.deleteNode = function(selectNode, successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    data = {};
    data[this.Key.NODE_PATH] = _parentNodePath(selectNode) + '/' + $(selectNode).text();
    return $.ajax({
      url: "/coding/delete_node",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (data.resultSuccess) {
          if (successCallback != null) {
            return successCallback(data);
          }
        } else {
          console.log('/coding/delete_node server error');
          if (errorCallback != null) {
            return errorCallback(data);
          }
        }
      },
      error: function(data) {
        console.log('/coding/delete_node ajax error');
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.activeTabEditor = function(user_coding_id) {
    var editorWrapper, editorWrapperId, tab, tab_content;
    tab = $('#my_tab');
    if ((tab == null) || tab.length === 0) {
      $('#editor_tab_wrapper').append('<ul id="my_tab" class="nav nav-tabs" role="tablist"></ul><div id="my_tab_content" class="tab-content"></div>');
      tab = $('#my_tab');
    }
    tab_content = $('#my_tab_content');
    _deactiveEditor();
    editorWrapperId = "uc_" + user_coding_id + "_wrapper";
    editorWrapper = $("#" + editorWrapperId);
    if ((editorWrapper == null) || editorWrapper.length === 0) {
      return CodingCommon.loadCodeData(user_coding_id, function(data) {
        var code, lang_type, loaded, nodes, title;
        loaded = data.load_data[0];
        code = loaded.code;
        nodes = loaded.node_path.split('/');
        title = nodes[nodes.length - 1];
        lang_type = loaded.lang_type;
        tab.append("<li role='presentation' class='tab_li active'><a class='tab_button' aria-controls='uc_" + user_coding_id + "_wrapper' href='#uc_" + user_coding_id + "_wrapper' role='tab' data-toggle='tab'>" + title + "</a><a class='close_tab_button'></a></li>");
        tab_content.append("<div role='tabpanel' class='tab-pane active' id='uc_" + user_coding_id + "_wrapper'><div id='uc_" + user_coding_id + "' class='editor'>" + code + "</div></div>");
        CodingCommon.setupEditor("uc_" + user_coding_id, lang_type);
        return CodingCommon.saveEditorState();
      });
    } else {
      editorWrapper.addClass('active');
      tab.find("a[href='#" + editorWrapperId + "']").closest('tab_li').addClass('active');
      return CodingCommon.saveEditorState();
    }
  };

  CodingCommon.saveEditorState = function(immediate) {
    var idleSeconds, saveEditorStateTimer;
    if (immediate == null) {
      immediate = false;
    }
    if ((window.saveEditorStateNowSaving != null) && window.saveEditorStateNowSaving) {
      return;
    }
    idleSeconds = immediate ? 0 : 5;
    if (typeof saveEditorStateTimer !== "undefined" && saveEditorStateTimer !== null) {
      clearTimeout(saveEditorStateTimer);
    }
    return saveEditorStateTimer = setTimeout(function() {
      var data;
      window.saveEditorStateNowSaving = true;
      data = {};
      data[CodingCommon.Key.CODES] = _codes();
      data[CodingCommon.Key.TREE_DATA] = _treeState();
      return $.ajax({
        url: "/coding/save_state",
        type: "POST",
        dataType: "json",
        data: data,
        success: function(data) {
          if (data.resultSuccess) {
            return window.saveEditorStateNowSaving = false;
          } else {
            return console.log('/coding/save_state server error');
          }
        },
        error: function(data) {
          console.log('/coding/save_state ajax error');
          return window.saveEditorStateNowSaving = false;
        }
      });
    }, idleSeconds * 1000);
  };

  _parentNodePath = function(select_node) {
    var joinPath, path, reversePath;
    path = $(select_node).parents('.jstree-children').prev('.jstree-anchor').map(function(n) {
      return $(this).text();
    }).get();
    path.unshift($(select_node).children('.jstree-anchor').text());
    reversePath = path.reverse();
    joinPath = reversePath.join('/');
    return joinPath;
  };

  _treeState = function() {
    var jt, ret, root;
    ret = [];
    root = $('#tree');
    jt = root.jstree(true);
    $('.jstree-node', root).each(function(i) {
      var is_opened, node_path, np, user_coding_id;
      node_path = _parentNodePath(this);
      np = node_path.replace(/\//g, '_').replace('.', '_');
      user_coding_id = $('#tree_wrapper').find(".user_coding_id." + np).val();
      if (user_coding_id != null) {
        user_coding_id = parseInt(user_coding_id);
      }
      is_opened = jt.is_open(this);
      return ret.push({
        node_path: node_path,
        user_coding_id: user_coding_id,
        is_opened: is_opened
      });
    });
    return ret;
  };

  _codes = function(targetEditorId) {
    var ret, tab;
    if (targetEditorId == null) {
      targetEditorId = null;
    }
    ret = [];
    tab = $('#my_tab');
    tab.children('li').each(function(i) {
      var code, editor, editorId, editorWrapperId, is_active, t, user_coding_id;
      t = $(this);
      editorWrapperId = t.find('a:first').attr('href').replace('#', '');
      editorId = editorWrapperId.replace('_wrapper', '');
      if ((targetEditorId != null) && editorId !== targetEditorId) {
        return true;
      }
      editor = ace.edit(editorId);
      code = editor.getValue();
      is_active = $("#" + editorWrapperId).hasClass('active');
      user_coding_id = parseInt(editorWrapperId.replace('uc_', '').replace('_wrapper', ''));
      return ret.push({
        user_coding_id: user_coding_id,
        code: code,
        is_opened: true,
        is_active: is_active
      });
    });
    return ret;
  };

  _deactiveEditor = function() {
    $('#my_tab').children('li').removeClass('active');
    return $('#my_tab_content').children('div').removeClass('active');
  };

  _activeEditorId = function() {
    return $('#my_tab').children('.active:first').find('.tab_button:first').attr('href').replace('#', '').replace('_wrapper', '');
  };

  return CodingCommon;

})();

//# sourceMappingURL=coding_common.js.map
