// Generated by CoffeeScript 1.9.2
var ClickChapter,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ClickChapter = (function(superClass) {
  extend(ClickChapter, superClass);

  function ClickChapter() {
    return ClickChapter.__super__.constructor.apply(this, arguments);
  }

  ClickChapter.prototype.willChapter = function() {
    ClickChapter.__super__.willChapter.call(this);
    return this.riseFrontAllActor();
  };

  ClickChapter.prototype.didChapter = function() {
    return ClickChapter.__super__.didChapter.call(this);
  };

  return ClickChapter;

})(Chapter);

//# sourceMappingURL=click_chapter.js.map
