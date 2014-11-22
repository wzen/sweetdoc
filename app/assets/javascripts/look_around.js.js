// Generated by CoffeeScript 1.8.0
var arrow, initResize, initScroll, initScrollEvents, resizeTimer, scrollEvents, scrollTimer, scrollViewHeight;

resizeTimer = false;

scrollTimer = -1;

scrollViewHeight = 50000;

scrollEvents = [];

arrow = null;

initScrollEvents = function() {
  var b, c, cf, colorPerHeight, color_max, g, i, r, rgb, style, styles, _i;
  color_max = 256 * 3;
  colorPerHeight = color_max / scrollViewHeight;
  c = 0;
  for (i = _i = 0; 0 <= scrollViewHeight ? _i <= scrollViewHeight : _i >= scrollViewHeight; i = 0 <= scrollViewHeight ? ++_i : --_i) {
    styles = [];
    c += colorPerHeight;
    cf = Math.floor(c);
    r = parseInt(cf / 3);
    g = parseInt((cf + 1) / 3);
    b = parseInt((cf + 2) / 3);
    rgb = "rgb(" + r + "," + g + "," + b + ")";
    style = {
      name: "background-color",
      param: rgb
    };
    styles.push(style);
    scrollEvents[i] = styles;
  }
  return this;
};

initResize = function(wrap, contents) {
  resizeTimer = false;
  return $(window).resize(function() {
    if (resizeTimer !== false) {
      clearTimeout(resizeTimer);
    }
    return resizeTimer = setTimeout(function() {
      var h;
      h = $(window).height();
      wrap.height(h);
      return contents.height(h - 80);
    }, 200);
  });
};

initScroll = function(scroll_contents) {
  var scrollFinished;
  scroll_contents.scroll(function() {
    var sh, styles;
    if (scrollTimer !== -1) {
      clearTimeout(scrollTimer);
    }
    scrollTimer = setTimeout(scrollFinished, 500);
    sh = Math.floor($(this).scrollTop());
    styles = scrollEvents[sh];
    return $.each(styles, function(i, v) {
      return scroll_contents.css(v["name"], v["param"]);
    });
  });
  return scrollFinished = function() {};
};

$(function() {
  var contents, h, inside, objList, scroll_contents, wrap;
  wrap = $('#wrap');
  contents = $("#wrap_contents");
  scroll_contents = $("#scroll_contents");
  inside = $("#inside");
  inside.height(scrollViewHeight);
  scrollEvents = new Array(scrollViewHeight);
  h = $(window).height();
  wrap.height(h);
  contents.height(h - 80);
  initResize(wrap, contents);
  objList = JSON.parse(sstorage.getItem('lookaround'));
  return arrow = objList.get(0);
});

//# sourceMappingURL=look_around.js.js.map
