// Generated by CoffeeScript 1.8.0
var Chapter;

Chapter = (function() {
  function Chapter(actorList) {
    this.actorList = actorList;
  }

  Chapter.prototype.scrollEvent = function(x, y) {
    return this.actorList.forEach(function(actor) {
      if (actor.scrollEvent != null) {
        return actor.scrollEvent(x, y);
      }
    });
  };

  Chapter.prototype.clickEvent = function(e) {
    return this.actorList.forEach(function(actor) {
      if (actor.clickEvent != null) {
        return actor.clickEvent(e);
      }
    });
  };

  Chapter.prototype.settleChapter = function() {};

  Chapter.prototype.focusToActor = function(type) {
    var item, left, top;
    if (type == null) {
      type = "center";
    }
    item = this.actorList[0];
    if (type === "center") {
      left = item.itemSize.x + item.itemSize.w * 0.5 - (scrollContents.width() * 0.5);
      top = item.itemSize.y + item.itemSize.h * 0.5 - (scrollContents.height() * 0.5);
      return scrollContents.animate({
        scrollTop: top,
        scrollLeft: left
      }, 500);
    }
  };

  return Chapter;

})();

//# sourceMappingURL=chapter.js.map
