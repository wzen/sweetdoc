// Generated by CoffeeScript 1.8.0
var checkBlowserEnvironment, generateId, makeClone;

checkBlowserEnvironment = function() {
  var c, e;
  if (!localStorage) {
    return false;
  } else {
    try {
      localStorage.setItem('test', 'test');
      c = localStorage.getItem('test');
      localStorage.removeItem('test');
    } catch (_error) {
      e = _error;
      return false;
    }
  }
  if (!File) {
    return false;
  }
  return true;
};

generateId = function() {
  var BaseString, RandomString, i, n, numb, _i;
  numb = 10;
  RandomString = '';
  BaseString = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  n = 62;
  for (i = _i = 0; 0 <= numb ? _i <= numb : _i >= numb; i = 0 <= numb ? ++_i : --_i) {
    RandomString += BaseString.charAt(Math.floor(Math.random() * n));
  }
  return RandomString;
};

makeClone = function(obj) {
  var flags, key, newInstance;
  if ((obj == null) || typeof obj !== 'object') {
    return obj;
  }
  if (obj instanceof Date) {
    return new Date(obj.getTime());
  }
  if (obj instanceof RegExp) {
    flags = '';
    if (obj.global != null) {
      flags += 'g';
    }
    if (obj.ignoreCase != null) {
      flags += 'i';
    }
    if (obj.multiline != null) {
      flags += 'm';
    }
    if (obj.sticky != null) {
      flags += 'y';
    }
    return new RegExp(obj.source, flags);
  }
  newInstance = new obj.constructor();
  for (key in obj) {
    newInstance[key] = clone(obj[key]);
  }
  return newInstance;
};

(function() {
  return window.loadedItemTypeList = [];
})();

$(function() {
  window.drawingCanvas = document.getElementById('canvas_container');
  return window.drawingContext = drawingCanvas.getContext('2d');
});

//# sourceMappingURL=common.js.map