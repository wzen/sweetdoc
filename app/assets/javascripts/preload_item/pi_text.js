// Generated by CoffeeScript 1.9.2
var PreloadItemText,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PreloadItemText = (function(superClass) {
  extend(PreloadItemText, superClass);

  PreloadItemText.NAME_PREFIX = "text";

  PreloadItemText.ITEM_ACCESS_TOKEN = 'PreloadItemText';

  PreloadItemText.actionProperties = {
    modifiables: {
      fontType: {
        name: "Select Font",
        type: 'select',
        ja: {
          name: 'フォント選択'
        },
        options: ['sans-serif', 'arial', 'arial black', 'arial narrow', 'arial unicode ms', 'Century Gothic', 'Franklin Gothic Medium', 'Gulim', 'Dotum', 'Haettenschweiler', 'Impact', 'Ludica Sans Unicode', 'Microsoft Sans Serif', 'MS Sans Serif', 'MV Boil', 'New Gulim', 'Tahoma', 'Trebuchet', 'Verdana', 'serif', 'Batang', 'Book Antiqua', 'Bookman Old Style', 'Century', 'Estrangelo Edessa', 'Garamond', 'Gautami', 'Georgia', 'Gungsuh', 'Latha', 'Mangal', 'MS Serif', 'PMingLiU', 'Palatino Linotype', 'Raavi', 'Roman', 'Shruti', 'Sylfaen', 'Times New Roman', 'Tunga', 'monospace', 'BatangChe', 'Courier', 'Courier New', 'DotumChe', 'GulimChe', 'GungsuhChe', 'HG行書体', 'Lucida Console', 'MingLiU', 'ＭＳ ゴシック', 'ＭＳ 明朝', 'OCRB', 'SimHei', 'SimSun', 'Small Fonts', 'Terminal', 'fantasy', 'alba', 'alba matter', 'alba super', 'baby kruffy', 'Chick', 'Croobie', 'Fat', 'Freshbot', 'Frosty', 'Gloo Gun', 'Jokewood', 'Modern', 'Monotype Corsiva', 'Poornut', 'Pussycat Snickers', 'Weltron Urban', 'cursive', 'Comic Sans MS', 'HGP行書体', 'HG正楷書体-PRO', 'Jenkins v2.0', 'Script', ['ヒラギノ角ゴ Pro W3', 'Hiragino Kaku Gothic Pro'], ['ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN'], ['ヒラギノ角ゴ Pro W6', 'HiraKakuPro-W6'], ['ヒラギノ角ゴ ProN W6', 'HiraKakuProN-W6'], ['ヒラギノ角ゴ Std W8', 'Hiragino Kaku Gothic Std'], ['ヒラギノ角ゴ StdN W8', 'Hiragino Kaku Gothic StdN'], ['ヒラギノ丸ゴ Pro W4', 'Hiragino Maru Gothic Pro'], ['ヒラギノ丸ゴ ProN W4', 'Hiragino Maru Gothic ProN'], ['ヒラギノ明朝 Pro W3', 'Hiragino Mincho Pro'], ['ヒラギノ明朝 ProN W3', 'Hiragino Mincho ProN'], ['ヒラギノ明朝 Pro W6', 'HiraMinPro-W6'], ['ヒラギノ明朝 ProN W6', 'HiraMinProN-W6'], 'Osaka', ['Osaka－等幅', 'Osaka-Mono'], 'MS UI Gothic', ['ＭＳ Ｐゴシック', 'MS PGothic'], ['ＭＳ ゴシック', 'MS Gothic'], ['ＭＳ Ｐ明朝', 'MS PMincho'], ['ＭＳ 明朝', 'MS Mincho'], ['メイリオ', 'Meiryo'], 'Meiryo UI']
      }
    }
  };

  PreloadItemText.INPUT_CLASSNAME = 'pi_input_text';

  function PreloadItemText(cood) {
    if (cood == null) {
      cood = null;
    }
    PreloadItemText.__super__.constructor.call(this, cood);
    this.fontType = 'Times New Roman';
    if (cood !== null) {
      this._moveLoc = {
        x: cood.x,
        y: cood.y
      };
    }
    this._editing = true;
    this.inputText = 'Input text';
    if (window.isWorkTable) {
      this.constructor.include(WorkTableCommonInclude);
    }
  }

  PreloadItemText.prototype.updateItemSize = function(w, h) {
    return PreloadItemText.__super__.updateItemSize.call(this, w, h);
  };

  PreloadItemText.prototype.cssItemHtml = function() {
    if (this.editing) {
      return "<div class=\"css_item_base context_base\"><input type='text' class='" + this.constructor.INPUT_CLASSNAME + "' value='" + this.inputText + "'></div>";
    } else {
      return "<div class=\"css_item_base context_base\">" + this.inputText + "</div>";
    }
  };

  PreloadItemText.prototype.itemDraw = function(show) {
    return PreloadItemText.__super__.itemDraw.call(this, show);
  };

  PreloadItemText.prototype.didCallEndDraw = function() {
    var input;
    PreloadItemText.__super__.didCallEndDraw.call(this);
    WorktableCommon.changeMode(Constant.Mode.EDIT);
    input = this.getJQueryElement().find("." + this.constructor.INPUT_CLASSNAME + ":first");
    input.off('change').on('change', (function(_this) {
      return function(e) {
        _this.editing = true;
        return _this.reDraw();
      };
    })(this));
    return input.focus();
  };

  return PreloadItemText;

})(CssItemBase);

Common.setClassToMap(false, PreloadItemText.ITEM_ACCESS_TOKEN, PreloadItemText);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList[PreloadItemText.ITEM_ACCESS_TOKEN] == null)) {
  if (typeof EventConfig !== "undefined" && EventConfig !== null) {
    EventConfig.addEventConfigContents(PreloadItemText.ITEM_ACCESS_TOKEN);
  }
  console.log('PreloadItemText loaded');
  window.itemInitFuncList[PreloadItemText.ITEM_ACCESS_TOKEN] = function(option) {
    if (option == null) {
      option = {};
    }
    if (window.isWorkTable && (PreloadItemText.jsLoaded != null)) {
      PreloadItemArrow.jsLoaded(option);
    }
    if (window.debug) {
      return console.log('PreloadItemText init Finish');
    }
  };
}

//# sourceMappingURL=pi_text.js.map
