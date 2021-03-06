// Generated by CoffeeScript 1.9.2
var StylesheetHandle;

StylesheetHandle = (function() {
  var Temp, instance;

  function StylesheetHandle() {}

  instance = null;

  StylesheetHandle.get = function() {
    if (instance == null) {
      instance = new Temp();
    }
    return instance;
  };

  Temp = (function() {
    function Temp() {
      var styleEl;
      styleEl = document.createElement('style');
      document.head.appendChild(styleEl);
      styleEl.appendChild(document.createTextNode(''));
      this.handleSheet = styleEl.sheet;
      this.historyStack = [];
    }

    Temp.prototype.insert = function(objId, cssCode) {
      var insertIndex;
      insertIndex = this.handleSheet.cssRules.length;
      this.handleSheet.insertRule(cssCode, insertIndex);
      return this.historyStack[insertIndex] = objId;
    };

    Temp.prototype.remove = function(objId) {
      var h, i, index, insertIndex, j, k, len, ref, ref1, ref2;
      insertIndex = null;
      ref = this.historyStack;
      for (index = j = 0, len = ref.length; j < len; index = ++j) {
        h = ref[index];
        if (h === objId) {
          insertIndex = index;
          break;
        }
      }
      if (insertIndex === null) {
        return;
      }
      this.handleSheet.deleteRule(insertIndex);
      for (i = k = ref1 = insertIndex, ref2 = this.historyStack.length - 2; ref1 <= ref2 ? k <= ref2 : k >= ref2; i = ref1 <= ref2 ? ++k : --k) {
        this.historyStack[i] = this.historyStack[i + 1];
      }
      return this.historyStack.pop();
    };

    return Temp;

  })();

  return StylesheetHandle;

})();

//# sourceMappingURL=stylesheet_handle.js.map
