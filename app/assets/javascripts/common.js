// Generated by CoffeeScript 1.8.0
var checkBlowserEnvironment, generateId;

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

(function() {
  return window.loadedItemTypeList = [];
})();

$(function() {
  window.drawingCanvas = document.getElementById('canvas_container');
  return window.drawingContext = drawingCanvas.getContext('2d');
});

//# sourceMappingURL=common.js.map
