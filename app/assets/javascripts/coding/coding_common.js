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

      Key.TREE_STATE = constant.Coding.Key.TREE_STATE;

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

  CodingCommon.openItemCoding = function(e) {
    var target;
    e.stopPropagation();
    target = "_coding";
    window.open("about:blank", target);
    document.run_form.action = '/coding/item';
    document.run_form.target = target;
    setTimeout(function() {
      return document.run_form.submit();
    }, 200);
    return false;
  };

  CodingCommon.init = function() {
    this.initTreeView();
    return this.initEditor();
  };

  CodingCommon.initTreeView = function() {
    $('#tree').jstree();
    return this.setupTreeEvent();
  };

  CodingCommon.initEditor = function() {
    return $('.editor').each((function(_this) {
      return function(e) {
        var editorId, lang_type;
        editorId = $(_this).attr('id');
        lang_type = $(_this).attr('class').split(' ').filter(function(item, idx) {
          return item !== 'editor';
        });
        if (lang_type.length > 0) {
          return _this.setupEditor(editorId, lang_type[0]);
        }
      };
    })(this));
  };

  CodingCommon.setupEditor = function(editorId, lang_type) {
    var EditSession, editor;
    ace.require("ace/ext/language_tools");
    editor = ace.edit(editorId);
    EditSession = require("ace/edit_session").EditSession;
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
    $('.dir, .tip', root).off('click');
    $('.dir, .tip', root).on('click', function(e) {
      return e.preventDefault();
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
            return CodingCommon.addNewFile(CodingCommon.Lang.JAVASCRIPT, function(data) {
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
            return CodingCommon.addNewFile(CodingCommon.Lang.COFFEESCRIPT, function(data) {
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
        return CodingCommon.addNewFolder(function(data) {
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
    data[this.Key.TREE_STATE] = _treeState();
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
    data[this.Key.TREE_STATE] = _treeState();
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

  CodingCommon.addNewFile = function(lang_type, successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    data = {};
    data[this.Key.LANG] = lang_type;
    data[this.Key.PARENT_NODE_PATH] = _parentNodePath();
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

  CodingCommon.addNewFolder = function(successCallback, errorCallback) {
    var data;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    data = {};
    data[this.Key.PARENT_NODE_PATH] = _parentNodePath();
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
    tab.append("<li class='active'><a href='uc_" + user_coding_id + "_wrapper' data-toggle='tab'>" + title + "</a></li>");
    tab_content.append("<div class='tab-pane fade in active' id='uc_" + user_coding_id + "_wrapper'><div id='uc_" + user_coding_id + "' class='editor " + lang_type + "'></div></div>");
    return this.setupEditor("uc_" + user_coding_id, lang_type);
  };

  _parentNodePath = function(select_node) {
    var path;
    path = $(select_node).parents('li.dir').map(function(n) {
      return $(this).text();
    });
    path.reverse().push(select_node.text());
    return path;
  };

  _treeState = function() {
    var ret, root;
    ret = [];
    root = $('#tree');
    $('.dir, .tip', root).each(function(i) {
      var is_opened, node_path, user_coding_id;
      node_path = _parentNodePath(this);
      user_coding_id = $(this).find('.id');
      if (user_coding_id != null) {
        user_coding_id = parseInt(user_coding_id);
      }
      is_opened = $(this).attr('aria-expanded') === 'true';
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
      var code, lang_type, name, t, tabContentId;
      t = $(this);
      name = t.find('a:first').text().replace(CodingCommon.NOT_SAVED_PREFIX, '');
      tabContentId = t.find('a:first').attr('href').replace('#', '');
      lang_type = $("" + tabContentId).find('.editor').attr('class').split(' ').filter(function(item, idx) {
        return item !== 'editor';
      });
      code = $("" + tabContentId).find('.editor').text();
      return ret.push({
        name: name,
        lang_type: lang_type,
        code: code
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
