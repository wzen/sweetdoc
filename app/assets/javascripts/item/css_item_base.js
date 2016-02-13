// Generated by CoffeeScript 1.9.2
var CssItemBase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

CssItemBase = (function(superClass) {
  extend(CssItemBase, superClass);

  if (window.loadedClassDistToken != null) {
    CssItemBase.CLASS_DIST_TOKEN = window.loadedClassDistToken;
  }

  function CssItemBase(cood) {
    if (cood == null) {
      cood = null;
    }
    CssItemBase.__super__.constructor.call(this, cood);
    this._cssRoot = null;
    this._cssDesignToolCache = null;
    this._cssDesignToolCode = null;
    this._cssDesignToolStyle = null;
    if (cood !== null) {
      this._moveLoc = {
        x: cood.x,
        y: cood.y
      };
    }
    this._cssStypeReflectTimer = null;
  }

  CssItemBase.prototype.initEventPrepare = function() {
    return this.appendAnimationCssIfNeeded();
  };

  CssItemBase.prototype.cssItemHtml = function() {
    return '';
  };

  CssItemBase.prototype.createItemElement = function(callback) {
    var element;
    element = "<div class='css_item_base context_base put_center'>" + (this.cssItemHtml()) + "</div>";
    return this.addContentsToScrollInside(element, callback);
  };

  CssItemBase.jsLoaded = function(option) {};

  CssItemBase.prototype.getCssRootElementId = function() {
    return "css_" + this.id;
  };

  CssItemBase.prototype.getCssAnimElementId = function() {
    return "css_anim_style";
  };

  CssItemBase.prototype.makeDesignConfigCss = function(forceUpdate) {
    var _applyCss, rootEmt;
    if (forceUpdate == null) {
      forceUpdate = false;
    }
    _applyCss = function(designs) {
      var k, ref, ref1, temp, v;
      if (designs != null) {
        temp = $('.cssdesign_tool_temp:first').clone(true).attr('class', '');
        temp.attr('id', this.getCssRootElementId());
        if (designs.values != null) {
          ref = designs.values;
          for (k in ref) {
            v = ref[k];
            temp.find("." + k).html("" + v);
          }
        }
        if (designs.flags != null) {
          ref1 = designs.flags;
          for (k in ref1) {
            v = ref1[k];
            if (!v) {
              temp.find("." + k).empty();
            }
          }
        }
      } else {
        temp = $('.cssdesign_temp:first').clone(true).attr('class', '');
        temp.attr('id', this.getCssRootElementId());
      }
      temp.find('.design_item_obj_id').html(this.id);
      return temp.appendTo(window.cssCode);
    };
    rootEmt = $("" + (this.getCssRootElementId()));
    if ((rootEmt != null) && rootEmt.length > 0) {
      if (forceUpdate) {
        $("" + (this.getCssRootElementId())).remove();
      } else {
        return;
      }
    }
    if (this.designs != null) {
      _applyCss.call(this, this.designs);
    } else {
      _applyCss.call(this, this.constructor.actionProperties.designConfigDefaultValues);
    }
    this._cssRoot = $('#' + this.getCssRootElementId());
    this._cssDesignToolCache = $(".css_design_tool_cache", this._cssRoot);
    this._cssDesignToolCode = $(".css_design_tool_code", this._cssRoot);
    return this._cssDesignToolStyle = $(".css_design_tool_style", this._cssRoot);
  };

  CssItemBase.prototype.refresh = function(show, callback, doApplyDesignChange) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (doApplyDesignChange == null) {
      doApplyDesignChange = true;
    }
    if (doApplyDesignChange) {
      this.applyDesignChange(false, false);
    }
    return CssItemBase.__super__.refresh.call(this, show, (function(_this) {
      return function() {
        if (callback != null) {
          return callback(_this);
        }
      };
    })(this));
  };

  CssItemBase.prototype.applyDesignChange = function(doStyleSave, doRefresh) {
    var addStyle, styleId;
    if (doStyleSave == null) {
      doStyleSave = true;
    }
    if (doRefresh == null) {
      doRefresh = true;
    }
    this.makeDesignConfigCss();
    this._cssDesignToolStyle.text(this._cssDesignToolCode.text());
    styleId = "css_style_" + this.id;
    $("#" + styleId).remove();
    if ((addStyle = this.cssStyle()) != null) {
      this._cssRoot.append($("<style id='" + styleId + "' type='text/css'>" + addStyle + "</style>"));
    }
    if (doStyleSave) {
      this.saveDesign();
    }
    if (doRefresh) {
      return this.refresh(true, null, false);
    }
  };

  CssItemBase.prototype.cssStyle = function() {};

  CssItemBase.prototype.cssAnimationKeyframe = function() {
    return null;
  };

  CssItemBase.prototype.appendAnimationCssIfNeeded = function() {
    var css, duration, funcName, keyFrameName, keyframe, methodName, mozKeyframe, webkitKeyframe;
    keyframe = this.cssAnimationKeyframe();
    if (keyframe != null) {
      methodName = this.getEventMethodName();
      this.removeAnimationCss();
      funcName = methodName + "_" + this.id;
      keyFrameName = this.id + "_frame";
      webkitKeyframe = "@-webkit-keyframes " + keyframe;
      mozKeyframe = "@-moz-keyframes " + keyframe;
      duration = this.eventDuration();
      css = "." + funcName + "\n{\n-webkit-animation-name: " + keyFrameName + ";\n-moz-animation-name: " + keyFrameName + ";\n-webkit-animation-duration: " + duration + "s;\n-moz-animation-duration: " + duration + "s;\n}";
      return window.cssCode.append("<div class='" + funcName + "'><style type='text/css'> " + webkitKeyframe + " " + mozKeyframe + " " + css + " </style></div>");
    }
  };

  CssItemBase.prototype.removeAnimationCss = function() {
    var funcName, methodName;
    methodName = this.getEventMethodName();
    funcName = methodName + "_" + this.id;
    return window.cssCode.find("." + funcName).remove();
  };

  if (window.isWorkTable) {
    CssItemBase.include(cssItemBaseWorktableExtend);
  }

  return CssItemBase;

})(ItemBase);

//# sourceMappingURL=css_item_base.js.map
