// Generated by CoffeeScript 1.9.2
var LocalStorage;

LocalStorage = (function() {
  LocalStorage.Key = (function() {
    function Key() {}

    Key.WORKTABLE_GENERAL_PAGEVALUES = 'worktable_general_pagevalues';

    Key.WORKTABLE_INSTANCE_PAGEVALUES = 'worktable_instance_pagevalues';

    Key.WORKTABLE_EVENT_PAGEVALUES = 'worktable_event_pagevalues';

    Key.WORKTABLE_SETTING_PAGEVALUES = 'worktable_setting_pagevalues';

    Key.WORKTABLE_SAVETIME = 'worktable_time';

    Key.RUN_GENERAL_PAGEVALUES = 'run_general_pagevalues';

    Key.RUN_INSTANCE_PAGEVALUES = 'run_instance_pagevalues';

    Key.RUN_EVENT_PAGEVALUES = 'run_event_pagevalues';

    Key.RUN_SETTING_PAGEVALUES = 'run_setting_pagevalues';

    Key.RUN_FOOTPRINT_PAGE_VALUES = 'run_footprint_pagevalues';

    Key.RUN_SAVETIME = 'run_time';

    return Key;

  })();

  LocalStorage.WORKTABLE_SAVETIME = 5;

  LocalStorage.RUN_SAVETIME = 9999;

  function LocalStorage(userToken) {
    this.userToken = userToken;
  }

  LocalStorage.prototype.saveAllPageValues = function() {
    this.saveGeneralPageValue();
    this.saveInstancePageValue();
    this.saveEventPageValue();
    return this.saveSettingPageValue();
  };

  LocalStorage.prototype.loadAllPageValues = function() {
    this.loadGeneralPageValue();
    this.loadInstancePageValue();
    this.loadEventPageValue();
    return this.loadSettingPageValue();
  };

  LocalStorage.prototype.isOverWorktableSaveTimeLimit = function() {
    var diffTime, key, saveTime, time;
    if (typeof localStorage === "undefined" || localStorage === null) {
      return true;
    }
    key = this.userToken;
    time = 0;
    if ((window.isItemPreview != null) && window.isItemPreview) {
      return true;
    }
    if (window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_SAVETIME;
      time = this.constructor.WORKTABLE_SAVETIME;
    } else {
      key += this.constructor.Key.RUN_SAVETIME;
      time = this.constructor.RUN_SAVETIME;
    }
    if (key !== this.userToken) {
      saveTime = localStorage.getItem(key);
      if (saveTime == null) {
        return true;
      }
      diffTime = Common.calculateDiffTime($.now(), saveTime);
      return parseInt(diffTime.minutes) > time;
    } else {
      return true;
    }
  };

  LocalStorage.prototype.generalKey = function() {
    var key;
    key = this.userToken;
    if ((window.isItemPreview != null) && window.isItemPreview) {
      return '';
    }
    if (window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_GENERAL_PAGEVALUES;
    } else {
      key += this.constructor.Key.RUN_GENERAL_PAGEVALUES;
    }
    return key;
  };

  LocalStorage.prototype.instanceKey = function() {
    var key;
    key = this.userToken;
    if ((window.isItemPreview != null) && window.isItemPreview) {
      return '';
    }
    if (window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES;
    } else {
      key += this.constructor.Key.RUN_INSTANCE_PAGEVALUES;
    }
    return key;
  };

  LocalStorage.prototype.eventKey = function() {
    var key;
    key = this.userToken;
    if ((window.isItemPreview != null) && window.isItemPreview) {
      return '';
    }
    if (window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_EVENT_PAGEVALUES;
    } else {
      key += this.constructor.Key.RUN_EVENT_PAGEVALUES;
    }
    return key;
  };

  LocalStorage.prototype.settingKey = function() {
    var key;
    key = this.userToken;
    if ((window.isItemPreview != null) && window.isItemPreview) {
      return '';
    }
    if (window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_SETTING_PAGEVALUES;
    } else {
      key += this.constructor.Key.RUN_SETTING_PAGEVALUES;
    }
    return key;
  };

  LocalStorage.prototype.footprintKey = function() {
    var key;
    key = this.userToken;
    if ((window.isItemPreview != null) && window.isItemPreview) {
      return '';
    }
    if (!window.isWorkTable) {
      key += this.constructor.Key.RUN_FOOTPRINT_PAGE_VALUES;
    }
    return key;
  };

  LocalStorage.prototype.savetimeKey = function() {
    var key;
    key = this.userToken;
    if ((window.isItemPreview != null) && window.isItemPreview) {
      return '';
    }
    if (window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_SAVETIME;
    } else {
      key += this.constructor.Key.RUN_SAVETIME;
    }
    return key;
  };

  LocalStorage.prototype.savetime = function() {
    var time;
    time = 0;
    if (window.isWorkTable) {
      time = this.constructor.WORKTABLE_SAVETIME;
    } else {
      time = this.constructor.RUN_SAVETIME;
    }
    return time;
  };

  LocalStorage.prototype.clearWorktable = function() {
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      localStorage.removeItem(this.constructor.Key.WORKTABLE_GENERAL_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_EVENT_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_SETTING_PAGEVALUES);
      return localStorage.removeItem(this.constructor.Key.WORKTABLE_SAVETIME);
    }
  };

  LocalStorage.prototype.clearWorktableWithoutSetting = function() {
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      localStorage.removeItem(this.constructor.Key.WORKTABLE_GENERAL_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_EVENT_PAGEVALUES);
      return localStorage.removeItem(this.constructor.Key.WORKTABLE_SAVETIME);
    }
  };

  LocalStorage.prototype.clearWorktableWithoutGeneralAndSetting = function() {
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      localStorage.removeItem(this.constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_EVENT_PAGEVALUES);
      return localStorage.removeItem(this.constructor.Key.WORKTABLE_SAVETIME);
    }
  };

  LocalStorage.prototype.clearRun = function() {
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      localStorage.removeItem(this.constructor.Key.RUN_GENERAL_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.RUN_INSTANCE_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.RUN_EVENT_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.RUN_SETTING_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.RUN_FOOTPRINT_PAGE_VALUES);
      return localStorage.removeItem(this.constructor.Key.RUN_SAVETIME);
    }
  };

  LocalStorage.prototype.saveGeneralPageValue = function() {
    var h, key;
    key = this.generalKey();
    if (key !== '' && (typeof localStorage !== "undefined" && localStorage !== null)) {
      h = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX);
      localStorage.setItem(key, JSON.stringify(h));
      return localStorage.setItem(this.savetimeKey(), $.now());
    }
  };

  LocalStorage.prototype.loadGeneralValue = function() {
    var l;
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      l = localStorage.getItem(this.generalKey());
      if (l != null) {
        return JSON.parse(l);
      } else {
        return null;
      }
    }
  };

  LocalStorage.prototype.loadGeneralPageValue = function() {
    var h;
    h = this.loadGeneralValue();
    if (h != null) {
      return PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, h);
    }
  };

  LocalStorage.prototype.saveInstancePageValue = function() {
    var h, key;
    key = this.instanceKey();
    if (key !== '') {
      if (typeof localStorage !== "undefined" && localStorage !== null) {
        h = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX);
        localStorage.setItem(key, JSON.stringify(h));
        return localStorage.setItem(this.savetimeKey(), $.now());
      }
    }
  };

  LocalStorage.prototype.loadInstancePageValue = function() {
    var h, l;
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      l = localStorage.getItem(this.instanceKey());
      if (l != null) {
        h = JSON.parse(l);
        return PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, h);
      }
    }
  };

  LocalStorage.prototype.saveEventPageValue = function() {
    var h, key;
    key = this.eventKey();
    if (key !== '' && (typeof localStorage !== "undefined" && localStorage !== null)) {
      h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT);
      localStorage.setItem(key, JSON.stringify(h));
      return localStorage.setItem(this.savetimeKey(), $.now());
    }
  };

  LocalStorage.prototype.loadEventPageValue = function() {
    var h, l;
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      l = localStorage.getItem(this.eventKey());
      if (l != null) {
        h = JSON.parse(l);
        return PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT, h);
      }
    }
  };

  LocalStorage.prototype.saveSettingPageValue = function() {
    var h, key;
    key = this.settingKey();
    if (key !== '' && (typeof localStorage !== "undefined" && localStorage !== null)) {
      h = PageValue.getSettingPageValue(PageValue.Key.ST_PREFIX);
      return localStorage.setItem(key, JSON.stringify(h));
    }
  };

  LocalStorage.prototype.loadSettingPageValue = function() {
    var h, l;
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      l = localStorage.getItem(this.settingKey());
      if (l != null) {
        h = JSON.parse(l);
        return PageValue.setSettingPageValue(PageValue.Key.ST_PREFIX, h);
      }
    }
  };

  LocalStorage.prototype.saveFootprintPageValue = function() {
    var h, key;
    key = this.footprintKey();
    if (key !== '' && (typeof localStorage !== "undefined" && localStorage !== null)) {
      h = PageValue.getFootprintPageValue(PageValue.Key.F_PREFIX);
      return localStorage.setItem(key, JSON.stringify(h));
    }
  };

  LocalStorage.prototype.loadCommonFootprintPageValue = function() {
    var h, k, l, ret, v;
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      l = localStorage.getItem(this.footprintKey());
      if (l != null) {
        h = JSON.parse(l);
        ret = {};
        for (k in h) {
          v = h[k];
          if (k.indexOf(PageValue.Key.P_PREFIX) < 0) {
            ret[k] = v;
          }
        }
        return PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, ret);
      }
    }
  };

  LocalStorage.prototype.loadPagingFootprintPageValue = function(pageNum) {
    var h, k, l, ret, v;
    if (typeof localStorage !== "undefined" && localStorage !== null) {
      l = localStorage.getItem(this.footprintKey());
      if (l != null) {
        h = JSON.parse(l);
        ret = {};
        for (k in h) {
          v = h[k];
          if (k.indexOf(PageValue.Key.P_PREFIX) >= 0 && parseInt(k.replace(PageValue.Key.P_PREFIX, '')) === pageNum) {
            ret[k] = v;
          }
        }
        return PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, ret);
      }
    }
  };

  return LocalStorage;

})();

window.lStorage = new LocalStorage(utoken);

//# sourceMappingURL=local_storage.js.map
