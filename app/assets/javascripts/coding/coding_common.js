// Generated by CoffeeScript 1.9.2
var CodingCommon;

CodingCommon = (function() {
  var _codes, _deactiveEditor, _parentNodePath, _treeState, constant;

  function CodingCommon() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    CodingCommon.DEFAULT_FILENAME = constant.Coding.DEFAULT_FILENAME;
    CodingCommon.NOT_SAVED_PREFIX = '* ';
    CodingCommon.Key = (function() {
      function Key() {}

      Key.NAME = constant.Coding.Key.NAME;

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
    return this.initEditor();
  };

  CodingCommon.initTreeView = function() {
    $('#tree').jstree();
    return this.setupTreeEvent();
  };

  CodingCommon.initEditor = function() {
    $('.editor').each(function(e) {
      var editorId, lang_type;
      editorId = $(this).attr('id');
      lang_type = $(this).attr('class').split(' ').filter(function(item, idx) {
        return item !== 'editor';
      });
      if (lang_type.length > 0) {
        return CodingCommon.setupEditor(editorId, lang_type[0]);
      }
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
      editor.getSession().setMode("ace/mode/coffeescript");
    }
    editor.setTheme("ace/theme/tomorrow");
    return editor.setOptions({
      enableBasicAutocompletion: true,
      enableSnippets: true,
      enableLiveAutocompletion: false
    });
  };

  CodingCommon.setupTreeEvent = function() {
    var root;
    root = $('#tree');
    root.on('open_node.jstree close_node.jstree', function(node) {
      return CodingCommon.saveEditorState();
    });
    return this.setupContextMenu();
  };

  CodingCommon.setupContextMenu = function() {
    var menu;
    menu = [];
    menu.push({
      title: I18n.t('context_menu.new_file'),
      children: [
        {
          title: I18n.t('context_menu.js'),
          cmd: "js",
          func: function(event, ui) {
            return CodingCommon.addNewFile(event.target, CodingCommon.Lang.JAVASCRIPT, function(data) {
              var ref, sel;
              ref = $('#tree').jstree(true);
              sel = ref.get_selected();
              if (!sel.length) {
                return false;
              }
              sel = sel[0];
              return sel = ref.create_node(sel, {
                "type": "file",
                text: CodingCommon.DEFAULT_FILENAME + ".js"
              }, 'last', function() {});
            }, function(data) {});
          }
        }, {
          title: I18n.t('context_menu.coffee'),
          cmd: "coffee",
          func: function(event, ui) {
            return CodingCommon.addNewFile(event.target, CodingCommon.Lang.COFFEESCRIPT, function(data) {
              var ref, sel;
              ref = $('#tree').jstree(true);
              sel = ref.get_selected();
              if (!sel.length) {
                return false;
              }
              sel = sel[0];
              return sel = ref.create_node(sel, {
                "type": "file",
                text: CodingCommon.DEFAULT_FILENAME + ".coffee"
              }, 'last', function() {});
            }, function(data) {});
          }
        }
      ]
    });
    menu.push({
      title: I18n.t('context_menu.new_folder'),
      cmd: "new_folder",
      func: function(event, ui) {
        return CodingCommon.addNewFolder(event.target, function(data) {
          var ref, sel;
          ref = $('#tree').jstree(true);
          sel = ref.get_selected();
          if (!sel.length) {
            return false;
          }
          sel = sel[0];
          return sel = ref.create_node(sel, {
            type: "folder",
            text: CodingCommon.DEFAULT_FILENAME + ".coffee"
          });
        }, function(data) {});
      }
    });
    return Common.setupContextMenu($('#tree .dir'), '#tree', {
      menu: menu,
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
        return _exec_func.call(this, menu);
      },
      beforeOpen: function(event, ui) {
        var ref, t;
        t = $(event.target);
        ui.menu.zIndex($(event.target).zIndex() + 1);
        ref = $('#tree').jstree(true);
        return ref.select_node(t);
      }
    });
  };

  CodingCommon.closeTabView = function(e) {
    var contentsId, tab_li;
    tab_li = $(e).closest('.tab_li');
    contentsId = tab_li.find('.tab_button:first').attr('href').replace('#', '');
    tab_li.remove();
    $("" + contentsId).closest('.editor_wrapper').remove();
    if ($('#my_tab').find('.tab_li.active').length === 0) {
      $('#my_tab').find('.tab_li:first').addClass('active');
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
    data = {};
    data[this.Key.CODES] = _codes();
    data[this.Key.TREE_DATA] = _treeState();
    return $.ajax({
      url: "/coding/save_all",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (successCallback != null) {
          return successCallback(data);
        }
      },
      error: function(data) {
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
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
        if (successCallback != null) {
          return successCallback(data);
        }
      },
      error: function(data) {
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.saveCode = function(successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    data = {};
    data[this.Key.CODES] = _codes();
    return $.ajax({
      url: "/coding/save_code",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (successCallback != null) {
          return successCallback(data);
        }
      },
      error: function(data) {
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.loadCodeData = function(successCallback, errorCallback) {
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    return $.ajax({
      url: "/coding/load_code",
      type: "GET",
      dataType: "json",
      success: function(data) {
        if (successCallback != null) {
          return successCallback(data);
        }
      },
      error: function(data) {
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
        if (successCallback != null) {
          return successCallback(data);
        }
      },
      error: function(data) {
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.addNewFile = function(parentNode, lang_type, successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    data = {};
    data[this.Key.LANG] = lang_type;
    data[this.Key.PARENT_NODE_PATH] = _parentNodePath(parentNode);
    return $.ajax({
      url: "/coding/add_new_file",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (successCallback != null) {
          return successCallback(data);
        }
      },
      error: function(data) {
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.addNewFolder = function(parentNode, successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    data = {};
    data[this.Key.PARENT_NODE_PATH] = _parentNodePath(parentNode);
    return $.ajax({
      url: "/coding/add_new_folder",
      type: "POST",
      dataType: "json",
      data: data,
      success: function(data) {
        if (successCallback != null) {
          return successCallback(data);
        }
      },
      error: function(data) {
        if (errorCallback != null) {
          return errorCallback(data);
        }
      }
    });
  };

  CodingCommon.createTabEditor = function(editorData) {
    var code, lang_type, tab, tab_content, title, user_coding_id;
    tab = $('#my_tab');
    if (tab == null) {
      $('#editor_wrapper').append('<ul id="my_tab" class="nav nav-tabs"></ul><div id="my_tab_content" class="tab-content"></div>');
      tab = $('#my_tab');
    }
    tab_content = $('#my_tab_content');
    _deactiveEditor();
    user_coding_id = editorData.user_coding_id;
    code = editorData.code;
    title = editorData.title;
    lang_type = editorData.lang_type;
    tab.append("<li class='tab_li active'><a class='tab_button' href='uc_" + user_coding_id + "_wrapper' data-toggle='tab'>" + title + "</a><a class='close_tab_button'></a></li>");
    tab_content.append("<div class='tab-pane fade in active' id='uc_" + user_coding_id + "_wrapper'><div id='uc_" + user_coding_id + "' class='editor " + lang_type + "'></div></div>");
    this.setupEditor("uc_" + user_coding_id, lang_type);
    return this.saveEditorState();
  };

  CodingCommon.saveEditorState = function() {
    var idleSeconds, saveEditorStateTimer;
    if ((window.saveEditorStateNowSaving != null) && window.saveEditorStateNowSaving) {
      return;
    }
    idleSeconds = 5;
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
          return window.saveEditorStateNowSaving = false;
        },
        error: function(data) {
          return window.saveEditorStateNowSaving = false;
        }
      });
    }, idleSeconds * 1000);
  };

  _parentNodePath = function(select_node) {
    var joinPath, path, reversePath;
    path = $(select_node).parents('li.dir').map(function(n) {
      return $(this).text();
    }).get();
    path.unshift($('.jstree-anchor:first', select_node).text());
    reversePath = path.reverse();
    joinPath = reversePath.join('/');
    return joinPath;
  };

  _treeState = function() {
    var jt, ret, root;
    ret = [];
    root = $('#tree');
    jt = root.jstree(true);
    $('.dir, .tip', root).each(function(i) {
      var is_opened, node_path, user_coding_id;
      node_path = _parentNodePath(this);
      user_coding_id = $(this).find('.id');
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

  _codes = function() {
    var ret, tab;
    ret = [];
    tab = $('#my_tab');
    tab.each(function(i) {
      var code, is_active, lang_type, name, t, tabContentId, user_coding_id;
      t = $(this);
      name = t.find('a:first').text().replace(CodingCommon.NOT_SAVED_PREFIX, '');
      tabContentId = t.find('a:first').attr('href').replace('#', '');
      lang_type = $("" + tabContentId).find('.editor').attr('class').split(' ').filter(function(item, idx) {
        return item !== 'editor';
      });
      code = $("" + tabContentId).find('.editor').text();
      is_active = $("" + tabContentId).find('.tab-pane:first').hasClass('active');
      user_coding_id = parseInt($("" + tabContentId).find('.editor').attr('id').replace('uc_', ''));
      return ret.push({
        user_coding_id: user_coding_id,
        name: name,
        lang_type: lang_type,
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

  return CodingCommon;

})();

//# sourceMappingURL=coding_common.js.map
