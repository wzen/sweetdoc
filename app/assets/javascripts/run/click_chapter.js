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
    var self;
    ClickChapter.__super__.willChapter.call(this);
    self = this;
    this.eventListenerList.forEach(function(eventListener) {
      eventListener.getJQueryElement().off('click');
      return eventListener.getJQueryElement().on('click', function(e) {
        return self.clickEvent(e);
      });
    });
    return this.riseFrontAllActor();
  };

  ClickChapter.prototype.didChapter = function() {
    return ClickChapter.__super__.didChapter.call(this);
  };

  ClickChapter.prototype.clickEvent = function(e) {
    if (window.disabledEventHandler) {
      return;
    }
    return this.eventListenerList.forEach(function(eventListener) {
      if (eventListener.clickEvent != null) {
        return eventListener.clickEvent(e);
      }
    });
  };

  return ClickChapter;

})(Chapter);

//# sourceMappingURL=click_chapter.js.map
