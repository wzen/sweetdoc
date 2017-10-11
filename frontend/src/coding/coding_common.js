/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
var CodingCommon = (function() {
  let constant = undefined;
  let _nodePath = undefined;
  let _treeState = undefined;
  let _codes = undefined;
  let _deactiveEditor = undefined;
  let _activeEditorId = undefined;
  let _userCodingClassNameByNodePath = undefined;
  let _countSameFilename = undefined;
  CodingCommon = class CodingCommon {
    static initClass() {
      constant = gon.const;
      this.DEFAULT_FILENAME = constant.Coding.DEFAULT_FILENAME;
      this.NOT_SAVED_PREFIX = '* ';
      let Cls = (this.Key = class Key {
        static initClass() {
          this.LANG = constant.Coding.Key.LANG;
          this.PUBLIC = constant.Coding.Key.PUBLIC;
          this.CODE = constant.Coding.Key.CODE;
          this.CODES = constant.Coding.Key.CODES;
          this.USER_CODING_ID = constant.Coding.Key.USER_CODING_ID;
          this.TREE_DATA = constant.Coding.Key.TREE_DATA;
          this.SUB_TREE = constant.Coding.Key.SUB_TREE;
          this.NODE_PATH = constant.Coding.Key.NODE_PATH;
          this.DRAW_TYPE = constant.Coding.Key.DRAW_TYPE;
          this.IS_OPENED = constant.Coding.Key.IS_OPENED;
          this.PARENT_NODE_PATH = constant.Coding.Key.PARENT_NODE_PATH;
        }
      });
      Cls.initClass();
      Cls = (this.Lang = class Lang {
        static initClass() {
          this.JAVASCRIPT = constant.Coding.Lang.JAVASCRIPT;
          this.COFFEESCRIPT = constant.Coding.Lang.COFFEESCRIPT;
        }
      });
      Cls.initClass();

      _nodePath = function(select_node) {
        const path = $(select_node).parents('.jstree-children').prev('.jstree-anchor').map(function(n) {
          return $(this).text();
        }).get();
        path.unshift($(select_node).text());
        const reversePath = path.reverse();
        const joinPath = reversePath.join('/');
        return joinPath;
      };

      _treeState = function() {
        const ret = [];
        const root = $('#tree');
        const jt = root.jstree(true);
        $('.jstree-node', root).each(function(i) {
          const node_path = _nodePath($(this).children('.jstree-anchor:first'));
          let user_coding_id = $('#tree_wrapper').find(`.user_coding_id.${_userCodingClassNameByNodePath(node_path)}`).val();
          if(user_coding_id !== null) {
            user_coding_id = parseInt(user_coding_id);
          }
          const is_opened = jt.is_open(this);
          return ret.push({
            node_path,
            user_coding_id,
            is_opened
          });
        });
        return ret;
      };

      _codes = function(targetEditorId = null) {
        const ret = [];
        const tab = $('#my_tab');
        tab.children('li').each(function(i) {
          const t = $(this);
          const editorWrapperId = t.find('a:first').attr('href').replace('#', '');
          const editorId = editorWrapperId.replace('_wrapper', '');

          if((targetEditorId !== null) && (editorId !== targetEditorId)) {
            // 対象外のEditorはパス
            return true;
          }

          const editor = ace.edit(editorId);
          const code = editor.getValue();
          const is_active = $(`#${editorWrapperId}`).hasClass('active');
          const user_coding_id = parseInt(editorWrapperId.replace('uc_', '').replace('_wrapper', ''));
          return ret.push({
            user_coding_id,
            code,
            is_opened: true,
            is_active
          });
        });
        return ret;
      };

      _deactiveEditor = function() {
        $('#my_tab').children('li').removeClass('active');
        return $('#my_tab_content').children('div').removeClass('active');
      };

      _activeEditorId = () => $('#my_tab').children('.active:first').find('.tab_button:first').attr('href').replace('#', '').replace('_wrapper', '');

      _userCodingClassNameByNodePath = nodePath => nodePath.replace(/\//g, '_').replace('.', '_');

      _countSameFilename = function(node, name, ext) {
        if(ext === null) {
          ext = '';
        }
        const childrenText = $(node).next('.jstree-children').find('.jstree-node > .jstree-anchor').map(function() {
          return $(this).text();
        });
        let count = 1;
        while(count < 100) {
          const num = count <= 1 ? '' : count;
          if($.inArray(`${name}${num}${ext}`, childrenText) < 0) {
            break;
          }
          count += 1;
        }
        return count;
      };
    }

    static init() {
      window.editing = {};
      this.initTreeView();
      return this.initEditor();
    }

    static initTreeView() {
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
            'icon': '/images/coding/tree/node_icon_root.png'
          },
          "folder": {
            "valid_children": ["folder", "js_file", "coffee_file"],
          },
          "js_file": {
            'icon': '/images/coding/tree/node_icon_js.png',
            "valid_children": []
          },
          "coffee_file": {
            'icon': '/images/coding/tree/node_icon_coffee.png',
            "valid_children": []
          }

        },
        "plugins": ['types']
      });
      return this.setupTreeEvent();
    }

    static initEditor() {
      $('.editor').each(function(e) {
        const editorId = $(this).attr('id');
        const lang_type = $(this).next(`.${CodingCommon.Key.LANG}`).val();
        return CodingCommon.setupEditor(editorId, lang_type);
      });

      $('a[data-toggle="tab"]').on('shown.bs.tab', e =>
        // タブ切り替え
        CodingCommon.saveEditorState()
      );

      return $('#editor_tab_wrapper .preview').off('click').on('click', e => {
        // ボタンイベント設定
        e.preventDefault();
        return this.runPreview();
      });
    }

    static setupEditor(editorId, lang_type, defaultValue = null) {
      ace.require("ace/ext/language_tools");
      const editor = ace.edit(editorId);
      if(lang_type === this.Lang.JAVASCRIPT) {
        editor.getSession().setMode("ace/mode/javascript");
      } else {
        editor.getSession().setMode("ace/mode/coffee");
      }
      editor.setTheme("ace/theme/tomorrow");
      // enable autocompletion and snippets
      editor.setOptions({
        enableBasicAutocompletion: true,
        enableSnippets: true,
        enableLiveAutocompletion: true
      });

      editor.setKeyboardHandler('ace/keyboard/emacs');
      if(defaultValue !== null) {
        editor.setValue(defaultValue);
      }

      editor.getSession().off('change');
      editor.getSession().on('change', function(e) {
        if((window.editing[editorId] === null) || !window.editing[editorId]) {
          // 編集フラグ
          window.editing[editorId] = true;
          const tab = $('#my_tab').find(`a[href=#${editorId}_wrapper]`);
          const name = tab.text().replace(/\*/g, '');
          return tab.text(`*${name}`);
        }
      });

      editor.commands.addCommand({
        Name: "savefile",
        bindKey: {
          win: "Ctrl-S",
          mac: "Command-S"
        },
        exec(editor) {
          return CodingCommon.saveActiveCode(function() {
            editorId = $(editor.container).attr('id');
            // 編集フラグ消去
            window.editing[editorId] = false;
            const tab = $('#my_tab').find(`a[href=#${editorId}_wrapper]`);
            const name = tab.text();
            return tab.text(name.replace(/\*/g, ''));
          });
        }
      });

      $('.close_tab_button').off('click');
      return $('.close_tab_button').on('click', function() {
        return CodingCommon.closeTabView(this);
      });
    }

    static setupTreeEvent() {
      const root = $('#tree');

      root.off('open_node.jstree close_node.jstree.my');
      root.on('open_node.jstree close_node.jstree.my', node =>
        // ツリー開閉
        CodingCommon.saveEditorState()
      );

      root.off('dblclick.jstree.my');
      root.on('dblclick.jstree.my', function(event) {
        const node = $(event.target).closest("li");
        const path = _userCodingClassNameByNodePath(_nodePath(node));
        if(node.hasClass('js') || node.hasClass('coffee')) {
          // エディタ表示
          return CodingCommon.activeTabEditor(parseInt($('#tree_wrapper').find(`.user_coding_id.${path}`).val()));
        }
      });
      return this.setupContextMenu();
    }

    static setupContextMenu() {
      this.setupContextMenuByType('root');
      this.setupContextMenuByType('dir');
      return this.setupContextMenuByType('tip');
    }

    static setupContextMenuByType(type) {
      let element;
      if(type === 'root') {
        element = $("#tree li.root").children('.jstree-anchor');
      } else if(type === 'dir') {
        element = $("#tree li.folder").children('.jstree-anchor');
      } else if(type === 'tip') {
        element = $("#tree li.js, #tree li.coffee").children('.jstree-anchor');
      }

      return Common.setupContextMenu(element, '#tree', {
        menu: CodingCommon.getContextMenuArray(type),
        select(event, ui) {
          var _exec_func = function(menuArray) {
            return (() => {
              const result = [];
              for(let v of Array.from(menuArray)) {
                if(v.children !== null) {
                  _exec_func.call(this, v.children);
                }
                if(v.cmd === ui.cmd) {
                  if(v.func !== null) {
                    result.push(v.func(event, ui));
                  } else {
                    result.push(undefined);
                  }
                } else {
                  result.push(undefined);
                }
              }
              return result;
            })();
          };
          return _exec_func.call(this, CodingCommon.getContextMenuArray(type));
        },

        beforeOpen(event, ui) {
          const t = $(event.target);
          const ref = $('#tree').jstree(true);
          ref.deselect_all(true);
          return ref.select_node(t);
        }
      });
    }


    static getContextMenuArray(type) {
      const makeFile = {
        title: I18n.t('context_menu.new_file'), cmd: "new_file", func(event, ui) {
          return Common.showModalView(constant.ModalViewType.CREATE_USER_CODE, false, CodingCommon.initAddNewFileModal, {target: event.target});
        }
      };

      const makeFolder = {
        title: I18n.t('context_menu.new_folder'), cmd: "new_folder", func(event, ui) {
          const sameNameCount = _countSameFilename(event.target, CodingCommon.DEFAULT_FILENAME);
          const num = sameNameCount <= 1 ? '' : sameNameCount;
          // フォルダ作成
          const folderName = CodingCommon.DEFAULT_FILENAME + num;
          return CodingCommon.addNewFolder(event.target, folderName);
        }
      };

      const deleteNode = {
        title: I18n.t('context_menu.delete'), cmd: "delete", func(event, ui) {
          // 削除
          if(window.confirm(I18n.t('message.dialog.delete_node'))) {
            return CodingCommon.deleteNode(event.target, function() {
              // 表示削除
              const ref = $('#tree').jstree(true);
              let sel = ref.get_selected();
              if(!sel.length) {
                return false;
              }
              sel = sel[0];
              // ノード削除
              ref.delete_node(sel);
              // コンテキストメニュー再設定
              CodingCommon.setupContextMenu();
              // 状態保存
              return CodingCommon.saveEditorState(true);
            });
          }
        }
      };

      let menu = [];
      if(type === 'root') {
        menu = [makeFile, makeFolder];
      } else if(type === 'dir') {
        menu = [makeFile, makeFolder, deleteNode];
      } else if(type === 'tip') {
        menu = [deleteNode];
      }
      return menu;
    }

    static closeTabView(e) {
      const tab_li = $(e).closest('.tab_li');
      const contentsId = tab_li.find('.tab_button:first').attr('href').replace('#', '');
      tab_li.remove();
      $(`#${contentsId}`).closest('.tab-pane').remove();
      if(($('#my_tab').find('.tab_li').length > 0) && ($('#my_tab').find('.tab_li.active').length === 0)) {
        $('#my_tab').find('.tab_li:first').addClass('active');
        const cid = $('#my_tab').find('.tab_li:first .tab_button').attr('href').replace('#', '');
        $(`#${cid}`).addClass('active');
      }

      return this.saveEditorState();
    }

    static saveAll(successCallback = null, errorCallback = null) {
      if($.map(window.editing, function(value) {
          if(value) {
            return '';
          } else {
            return null;
          }
        }).length > 0) {

        const data = {};
        data[this.Key.CODES] = _codes();
        data[this.Key.TREE_DATA] = _treeState();
        return $.ajax(
          {
            url: "/coding/save_all",
            type: "POST",
            dataType: "json",
            data,
            success(data) {
              // 編集フラグ消去
              for(let k in window.editing) {
                const v = window.editing[k];
                window.editing[k] = false;
              }
              const tabs = $('#my_tab').find(".tab_button");
              tabs.each(function() {
                const name = $(this).text();
                return $(this).text(name.replace(/\*/g, ''));
              });

              if(data.resultSuccess) {
                if(successCallback !== null) {
                  return successCallback(data);
                }
              } else {
                if(errorCallback !== null) {
                  errorCallback(data);
                }
                console.log('/coding/save_all server error');
                return Common.ajaxError(data);
              }
            },
            error(data) {
              if(errorCallback !== null) {
                errorCallback(data);
              }
              console.log('/coding/save_all ajax error');
              return Common.ajaxError(data);
            }
          }
        );
      }
    }

    static saveTree(successCallback = null, errorCallback = null) {
      const data = {};
      data[this.Key.TREE_DATA] = _treeState();
      return $.ajax(
        {
          url: "/coding/save_tree",
          type: "POST",
          dataType: "json",
          data,
          success(data) {
            if(data.resultSuccess) {
              if(successCallback !== null) {
                return successCallback(data);
              }
            } else {
              console.log('/coding/save_tree server error');
              Common.ajaxError(data);
              if(errorCallback !== null) {
                return errorCallback(data);
              }
            }
          },
          error(data) {
            console.log('/coding/save_tree ajax error');
            Common.ajaxError(data);
            if(errorCallback !== null) {
              return errorCallback(data);
            }
          }
        }
      );
    }

    static saveAllCode(successCallback = null, errorCallback = null) {
      if($.map(window.editing, function(value) {
          if(value) {
            return '';
          } else {
            return null;
          }
        }).length > 0) {

        const data = {};
        data[this.Key.CODES] = _codes();
        return $.ajax(
          {
            url: "/coding/update_code",
            type: "POST",
            dataType: "json",
            data,
            success(data) {
              // 編集フラグ消去
              for(let k in window.editing) {
                const v = window.editing[k];
                window.editing[k] = false;
              }
              const tabs = $('#my_tab').find(".tab_button");
              tabs.each(function() {
                const name = $(this).text();
                return $(this).text(name.replace(/\*/g, ''));
              });

              if(data.resultSuccess) {
                if(successCallback !== null) {
                  return successCallback(data);
                }
              } else {
                console.log('/coding/save_code server error');
                Common.ajaxError(data);
                if(errorCallback !== null) {
                  return errorCallback(data);
                }
              }
            },
            error(data) {
              console.log('/coding/save_code ajax error');
              Common.ajaxError(data);
              if(errorCallback !== null) {
                return errorCallback(data);
              }
            }
          }
        );
      }
    }

    static saveActiveCode(successCallback = null, errorCallback = null) {
      const editorId = _activeEditorId();
      if((window.editing[editorId] !== null) && window.editing[editorId]) {
        const data = {};
        data[this.Key.CODES] = _codes(editorId);
        return $.ajax(
          {
            url: "/coding/update_code",
            type: "POST",
            dataType: "json",
            data,
            success(data) {
              if(data.resultSuccess) {
                // 編集フラグ消去
                window.editing[editorId] = false;
                const tabs = $('#my_tab').find(".tab_button");
                tabs.each(function() {
                  if($(this).parent('.active')) {
                    const name = $(this).text();
                    return $(this).text(name.replace(/\*/g, ''));
                  }
                });

                if(successCallback !== null) {
                  return successCallback(data);
                }
              } else {
                console.log('/coding/save_code server error');
                Common.ajaxError(data);
                if(errorCallback !== null) {
                  return errorCallback(data);
                }
              }
            },
            error(data) {
              console.log('/coding/save_code ajax error');
              Common.ajaxError(data);
              if(errorCallback !== null) {
                return errorCallback(data);
              }
            }
          }
        );
      }
    }

    static loadCodeData(userCodingId, successCallback = null, errorCallback = null) {
      const data = {};
      data[CodingCommon.Key.USER_CODING_ID] = userCodingId;
      return $.ajax(
        {
          url: "/coding/load_code",
          type: "GET",
          dataType: "json",
          data,
          success(data) {
            if(data.resultSuccess) {
              if(successCallback !== null) {
                return successCallback(data);
              }
            } else {
              console.log('coding/load_code server error');
              Common.ajaxError(data);
              if(errorCallback !== null) {
                return errorCallback(data);
              }
            }
          },
          error(data) {
            console.log('coding/load_code ajax error');
            Common.ajaxError(data);
            if(errorCallback !== null) {
              return errorCallback(data);
            }
          }
        }
      );
    }

    static loadTreeData(successCallback = null, errorCallback = null) {
      return $.ajax(
        {
          url: "/coding/load_tree",
          type: "GET",
          dataType: "json",
          success(data) {
            if(data.resultSuccess) {
              if(successCallback !== null) {
                return successCallback(data);
              }
            } else {
              console.log('/coding/load_tree server error');
              Common.ajaxError(data);
              if(errorCallback !== null) {
                return errorCallback(data);
              }
            }
          },
          error(data) {
            console.log('/coding/load_tree ajax error');
            Common.ajaxError(data);
            if(errorCallback !== null) {
              return errorCallback(data);
            }
          }
        }
      );
    }

    static initAddNewFileModal(modalEmt, params, callback = null) {
      $('.node_path', modalEmt).html(_nodePath(params.target) + '/');
      $('.file_name:first', modalEmt).val(CodingCommon.DEFAULT_FILENAME + '.js');
      $('.lang_select:first', modalEmt).val('');
      $('.draw_select:first', modalEmt).val('');

      $('.lang_select', modalEmt).off('change');
      $('.lang_select', modalEmt).on('change', function(e) {
        // 拡張子設定
        let ext = '';
        if($('.lang_select', modalEmt).val() === 'js') {
          ext = '.js';
        } else if($('.lang_select', modalEmt).val() === 'coffee') {
          ext = '.coffee';
        }
        let fileName = $('.file_name:first', modalEmt).val();
        fileName = fileName.replace(/\..*/, '') + ext;
        return $('.file_name:first', modalEmt).val(fileName);
      });

      $('.create_button', modalEmt).off('click');
      $('.create_button', modalEmt).on('click', function(e) {
        e.preventDefault();
        let lang_type = '';
        let draw_type = '';
        let ext = '';
        if($('.lang_select', modalEmt).val() === 'js') {
          lang_type = CodingCommon.Lang.JAVASCRIPT;
          ext = '.js';
        } else if($('.lang_select', modalEmt).val() === 'coffee') {
          lang_type = CodingCommon.Lang.COFFEESCRIPT;
          ext = '.coffee';
        }
        if($('.draw_select', modalEmt).val() === 'canvas') {
          draw_type = constant.ItemDrawType.CANVAS;
        } else if($('.draw_select', modalEmt).val() === 'css') {
          draw_type = constant.ItemDrawType.CSS;
        }

        if((lang_type !== '') && (draw_type !== '')) {
          // 同名ファイルチェック
          const fileName = $('.file_name:first', modalEmt).val();
          const sameNameCount = _countSameFilename(params.target, fileName);
          if(sameNameCount <= 1) {
            return CodingCommon.addNewFile(params.target, fileName, lang_type, draw_type, () => Common.hideModalView());
          }
        }
      });
      $('.back_button', modalEmt).off('click');
      $('.back_button', modalEmt).on('click', function(e) {
        e.preventDefault();
        return Common.hideModalView();
      });

      if(callback !== null) {
        return callback();
      }
    }

    static addNewFile(parentNode, name, lang_type, draw_type, successCallback = null, errorCallback = null) {
      const data = {};
      data[this.Key.LANG] = lang_type;
      const node_path = _nodePath(parentNode) + '/' + name;
      data[this.Key.NODE_PATH] = node_path;
      data[this.Key.DRAW_TYPE] = draw_type;
      return $.ajax(
        {
          url: "/coding/add_new_file",
          type: "POST",
          dataType: "json",
          data,
          success(data) {
            if(data.resultSuccess) {
              let type = '';
              if(lang_type === CodingCommon.Lang.JAVASCRIPT) {
                type = 'js_file';
              } else if(lang_type === CodingCommon.Lang.COFFEESCRIPT) {
                type = 'coffee_file';
              }
              const ref = $('#tree').jstree(true);
              let sel = ref.get_selected();
              if(!sel.length) {
                return false;
              }
              sel = sel[0];
              ref.create_node(sel, {"type": type, text: name}, 'last', function(e) {
                // クラス名設定
                let className;
                if(lang_type === CodingCommon.Lang.JAVASCRIPT) {
                  className = 'js';
                } else if(lang_type === CodingCommon.Lang.COFFEESCRIPT) {
                  className = 'coffee';
                }
                $(`#${e.id}`).addClass(className);
                // フォルダオープン
                return ref.open_node(sel, function() {
                  // user_coding_id追加
                  $('#tree_wrapper').append(`<input type='hidden' class='user_coding_id ${_userCodingClassNameByNodePath(node_path)}' value='${data.add_user_coding_id}' />`);
                  // イベント再設定
                  CodingCommon.setupTreeEvent();
                  // 状態保存
                  CodingCommon.saveEditorState(true);
                  // エディタ表示
                  return CodingCommon.activeTabEditor(parseInt($('#tree_wrapper').find(`.user_coding_id.${_userCodingClassNameByNodePath(node_path)}`).val()));
                });
              });
              if(successCallback !== null) {
                return successCallback(data);
              }
            } else {
              console.log('/coding/add_new_file server error');
              Common.ajaxError(data);
              if(errorCallback !== null) {
                return errorCallback(data);
              }
            }
          },
          error(data) {
            console.log('/coding/add_new_file ajax error');
            Common.ajaxError(data);
            if(errorCallback !== null) {
              return errorCallback(data);
            }
          }
        }
      );
    }

    static addNewFolder(parentNode, name, successCallback = null, errorCallback = null) {
      const data = {};
      const nodePath = _nodePath(parentNode) + '/' + name;
      data[this.Key.NODE_PATH] = nodePath;
      return $.ajax(
        {
          url: "/coding/add_new_folder",
          type: "POST",
          dataType: "json",
          data,
          success(data) {
            if(data.resultSuccess) {
              const ref = $('#tree').jstree(true);
              let sel = ref.get_selected();
              if(!sel.length) {
                return false;
              }
              sel = sel[0];
              sel = ref.create_node(sel, {type: "folder", text: name}, 'last', function(e) {
                // クラス名設定
                $(`#${e.id}`).addClass('folder');
                // フォルダオープン
                return ref.open_node(sel, function() {
                  // イベント再設定
                  CodingCommon.setupTreeEvent();
                  // 状態保存
                  return CodingCommon.saveEditorState(true);
                });
              });
              if(successCallback !== null) {
                return successCallback(data);
              }
            } else {
              console.log('/coding/add_new_folder server error');
              Common.ajaxError(data);
              if(errorCallback !== null) {
                return errorCallback(data);
              }
            }
          },
          error(data) {
            console.log('/coding/add_new_folder ajax error');
            Common.ajaxError(data);
            if(errorCallback !== null) {
              return errorCallback(data);
            }
          }
        }
      );
    }

    static deleteNode(selectNode, successCallback = null, errorCallback = null) {
      const data = {};
      data[this.Key.NODE_PATH] = _nodePath(selectNode);
      return $.ajax(
        {
          url: "/coding/delete_node",
          type: "POST",
          dataType: "json",
          data,
          success(data) {
            if(data.resultSuccess) {
              if(successCallback !== null) {
                return successCallback(data);
              }
            } else {
              console.log('/coding/delete_node server error');
              Common.ajaxError(data);
              if(errorCallback !== null) {
                return errorCallback(data);
              }
            }
          },
          error(data) {
            console.log('/coding/delete_node ajax error');
            Common.ajaxError(data);
            if(errorCallback !== null) {
              return errorCallback(data);
            }
          }
        }
      );
    }

    static activeTabEditor(user_coding_id) {
      let tab = $('#my_tab');
      if((tab === null) || (tab.length === 0)) {
        // タブビュー作成
        $('#editor_tab_wrapper').append('<div id="editor_header_menu"><div><div><a><div class="editor_btn preview">Preview</div></a></div></div></div><div id="editor_contents_wrapper"><div><ul id="my_tab" class="nav nav-tabs" role="tablist"></ul><div id="my_tab_content" class="tab-content"></div></div></div>');
        tab = $('#my_tab');
        // イベント設定
        $('#editor_tab_wrapper .preview').off('click').on('click', e => {
          e.preventDefault();
          return this.runPreview();
        });
      }
      const tab_content = $('#my_tab_content');
      // 全てDeactive
      _deactiveEditor();

      const editorWrapperId = `uc_${user_coding_id}_wrapper`;
      const editorWrapper = $(`#${editorWrapperId}`);
      if((editorWrapper === null) || (editorWrapper.length === 0)) {
        // エディタ作成
        return CodingCommon.loadCodeData(user_coding_id, function(data) {
          const loaded = data.load_data[0];
          const {code} = loaded;
          const nodes = loaded.node_path.split('/');
          const title = nodes[nodes.length - 1];
          const {lang_type} = loaded;

          tab.append(`<li role='presentation' class='tab_li active'><a class='tab_button' aria-controls='uc_${user_coding_id}_wrapper' href='#uc_${user_coding_id}_wrapper' role='tab' data-toggle='tab'>${title}</a><a class='close_tab_button'></a></li>`);
          tab_content.append(`<div role='tabpanel' class='tab-pane active' id='uc_${user_coding_id}_wrapper'><div id='uc_${user_coding_id}' class='editor'></div></div>`);
          CodingCommon.setupEditor(`uc_${user_coding_id}`, lang_type, code);
          return CodingCommon.saveEditorState();
        });

      } else {
        // 対象エディタをActiveに
        editorWrapper.addClass('active');
        tab.find(`a[href='#${editorWrapperId}']`).closest('tab_li').addClass('active');
        return CodingCommon.saveEditorState();
      }
    }

    // プレビュー実行
    static runPreview() {
      // アクティブコード取得
      const user_coding_id = $('#my_tab .active a').attr('href').replace('#uc_', '').replace('_wrapper', '');
      $(`#${this.Key.USER_CODING_ID}`).val(user_coding_id);
      const target = "_coding_item_preview_tab";
      window.open("about:blank", target);
      document.coding_form.action = '/coding/item_preview';
      document.coding_form.target = target;
      return document.coding_form.submit();
    }

    static saveEditorState(immediate) {
      let saveEditorStateTimer;
      if(immediate === null) {
        immediate = false;
      }
      if((window.saveEditorStateNowSaving !== null) && window.saveEditorStateNowSaving) {
        return;
      }

      const idleSeconds = immediate ? 0 : 5;
      if(saveEditorStateTimer !== null) {
        clearTimeout(saveEditorStateTimer);
      }
      return saveEditorStateTimer = setTimeout(function() {
          window.saveEditorStateNowSaving = true;
          const data = {};
          data[CodingCommon.Key.CODES] = _codes();
          data[CodingCommon.Key.TREE_DATA] = _treeState();
          return $.ajax(
            {
              url: "/coding/save_state",
              type: "POST",
              dataType: "json",
              data,
              success(data) {
                if(data.resultSuccess) {
                  return window.saveEditorStateNowSaving = false;
                } else {
                  console.log('/coding/save_state server error');
                  return Common.ajaxError(data);
                }
              },
              error(data) {
                console.log('/coding/save_state ajax error');
                Common.ajaxError(data);
                return window.saveEditorStateNowSaving = false;
              }
            }
          );
        }
        , idleSeconds * 1000);
    }
  };
  CodingCommon.initClass();
  return CodingCommon;
})();
