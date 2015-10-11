// Generated by CoffeeScript 1.10.0
var LocalStorage;

LocalStorage = (function() {
  function LocalStorage() {}

  LocalStorage.Key = (function() {
    function Key() {}

    Key.WORKTABLE_GENERAL_PAGEVALUES = 'worktable_general_pagevalues';

    Key.WORKTABLE_INSTANCE_PAGEVALUES = 'worktable_instance_pagevalues';

    Key.WORKTABLE_EVENT_PAGEVALUES = 'worktable_event_pagevalues';

    Key.WORKTABLE_SETTING_PAGEVALUES = 'worktable_setting_pagevalues';

    Key.RUN_GENERAL_PAGEVALUES = 'run_general_pagevalues';

    Key.RUN_INSTANCE_PAGEVALUES = 'run_instance_pagevalues';

    Key.RUN_EVENT_PAGEVALUES = 'run_event_pagevalues';

    Key.RUN_SETTING_PAGEVALUES = 'run_setting_pagevalues';

    Key.WORKTABLE_SAVETIME = 'worktable_time';

    Key.RUN_SAVETIME = 'run_time';

    return Key;

  })();

  LocalStorage.WORKTABLE_SAVETIME = 5;

  LocalStorage.RUN_SAVETIME = 9999;

  LocalStorage.saveAllPageValues = function() {
    this.saveGeneralPageValue();
    this.saveInstancePageValue();
    this.saveEventPageValue();
    if (window.isWorkTable) {
      return this.saveSettingPageValue();
    }
  };

  LocalStorage.loadAllPageValues = function() {
    this.loadGeneralPageValue();
    this.loadInstancePageValue();
    this.loadEventPageValue();
    if (window.isWorkTable) {
      return this.loadSettingPageValue();
    }
  };

  LocalStorage.isOverWorktableSaveTimeLimit = function() {
    var diffTime, isRun, key, lstorage, saveTime, time;
    isRun = !window.isWorkTable;
    lstorage = localStorage;
    key = isRun ? this.Key.RUN_SAVETIME : this.Key.WORKTABLE_SAVETIME;
    saveTime = lstorage.getItem(key);
    if (saveTime == null) {
      return true;
    }
    diffTime = Common.calculateDiffTime($.now(), saveTime);
    time = isRun ? this.RUN_SAVETIME : this.WORKTABLE_SAVETIME;
    return parseInt(diffTime.minutes) > time;
  };

  LocalStorage.clearWorktable = function() {
    var lstorage;
    lstorage = localStorage;
    lstorage.removeItem(this.Key.WORKTABLE_GENERAL_PAGEVALUES);
    lstorage.removeItem(this.Key.WORKTABLE_INSTANCE_PAGEVALUES);
    lstorage.removeItem(this.Key.WORKTABLE_EVENT_PAGEVALUES);
    lstorage.removeItem(this.Key.WORKTABLE_SETTING_PAGEVALUES);
    return lstorage.removeItem(this.Key.WORKTABLE_SAVETIME);
  };

  LocalStorage.clearWorktableWithoutSetting = function() {
    var lstorage;
    lstorage = localStorage;
    lstorage.removeItem(this.Key.WORKTABLE_GENERAL_PAGEVALUES);
    lstorage.removeItem(this.Key.WORKTABLE_INSTANCE_PAGEVALUES);
    lstorage.removeItem(this.Key.WORKTABLE_EVENT_PAGEVALUES);
    return lstorage.removeItem(this.Key.WORKTABLE_SAVETIME);
  };

  LocalStorage.clearWorktableWithoutGeneralAndSetting = function() {
    var lstorage;
    lstorage = localStorage;
    lstorage.removeItem(this.Key.WORKTABLE_INSTANCE_PAGEVALUES);
    lstorage.removeItem(this.Key.WORKTABLE_EVENT_PAGEVALUES);
    return lstorage.removeItem(this.Key.WORKTABLE_SAVETIME);
  };

  LocalStorage.clearRun = function() {
    var lstorage;
    lstorage = localStorage;
    lstorage.removeItem(this.Key.RUN_GENERAL_PAGEVALUES);
    lstorage.removeItem(this.Key.RUN_INSTANCE_PAGEVALUES);
    lstorage.removeItem(this.Key.RUN_EVENT_PAGEVALUES);
    lstorage.removeItem(this.Key.RUN_SETTING_PAGEVALUES);
    return lstorage.removeItem(this.Key.RUN_SAVETIME);
  };

  LocalStorage.saveGeneralPageValue = function() {
    var h, isRun, key, lstorage;
    isRun = !window.isWorkTable;
    lstorage = localStorage;
    h = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX);
    key = isRun ? this.Key.RUN_GENERAL_PAGEVALUES : this.Key.WORKTABLE_GENERAL_PAGEVALUES;
    lstorage.setItem(key, JSON.stringify(h));
    key = isRun ? this.Key.RUN_SAVETIME : this.Key.WORKTABLE_SAVETIME;
    return lstorage.setItem(key, $.now());
  };

  LocalStorage.loadGeneralPageValue = function() {
    var h, isRun, k, key, lstorage, results, v;
    isRun = !window.isWorkTable;
    lstorage = localStorage;
    key = isRun ? this.Key.RUN_GENERAL_PAGEVALUES : this.Key.WORKTABLE_GENERAL_PAGEVALUES;
    h = JSON.parse(lstorage.getItem(key));
    results = [];
    for (k in h) {
      v = h[k];
      results.push(PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v));
    }
    return results;
  };

  LocalStorage.saveInstancePageValue = function() {
    var h, isRun, key, lstorage;
    isRun = !window.isWorkTable;
    lstorage = localStorage;
    h = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX);
    key = isRun ? this.Key.RUN_INSTANCE_PAGEVALUES : this.Key.WORKTABLE_INSTANCE_PAGEVALUES;
    lstorage.setItem(key, JSON.stringify(h));
    key = isRun ? this.Key.RUN_SAVETIME : this.Key.WORKTABLE_SAVETIME;
    return lstorage.setItem(key, $.now());
  };

  LocalStorage.loadInstancePageValue = function() {
    var h, isRun, k, key, lstorage, results, v;
    isRun = !window.isWorkTable;
    lstorage = localStorage;
    key = isRun ? this.Key.RUN_INSTANCE_PAGEVALUES : this.Key.WORKTABLE_INSTANCE_PAGEVALUES;
    h = JSON.parse(lstorage.getItem(key));
    results = [];
    for (k in h) {
      v = h[k];
      results.push(PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v));
    }
    return results;
  };

  LocalStorage.saveEventPageValue = function() {
    var h, isRun, key, lstorage;
    isRun = !window.isWorkTable;
    lstorage = localStorage;
    h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT);
    key = isRun ? this.Key.RUN_EVENT_PAGEVALUES : this.Key.WORKTABLE_EVENT_PAGEVALUES;
    lstorage.setItem(key, JSON.stringify(h));
    key = isRun ? this.Key.RUN_SAVETIME : this.Key.WORKTABLE_SAVETIME;
    return lstorage.setItem(key, $.now());
  };

  LocalStorage.loadEventPageValue = function() {
    var h, isRun, key, lstorage;
    isRun = !window.isWorkTable;
    lstorage = localStorage;
    key = isRun ? this.Key.RUN_EVENT_PAGEVALUES : this.Key.WORKTABLE_EVENT_PAGEVALUES;
    h = JSON.parse(lstorage.getItem(key));
    return PageValue.setEventPageValueByRootHash(h);
  };

  LocalStorage.saveSettingPageValue = function() {
    var h, isRun, key, lstorage;
    isRun = !window.isWorkTable;
    lstorage = localStorage;
    h = PageValue.getSettingPageValue(WorktableSetting.PageValueKey.PREFIX);
    key = isRun ? this.Key.RUN_SETTING_PAGEVALUES : this.Key.WORKTABLE_SETTING_PAGEVALUES;
    return lstorage.setItem(key, JSON.stringify(h));
  };

  LocalStorage.loadSettingPageValue = function() {
    var h, isRun, k, key, lstorage, results, v;
    isRun = !window.isWorkTable;
    lstorage = localStorage;
    key = isRun ? this.Key.RUN_SETTING_PAGEVALUES : this.Key.WORKTABLE_SETTING_PAGEVALUES;
    h = JSON.parse(lstorage.getItem(key));
    results = [];
    for (k in h) {
      v = h[k];
      results.push(PageValue.setSettingPageValue(WorktableSetting.PageValueKey.PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v));
    }
    return results;
  };

  return LocalStorage;

})();

//# sourceMappingURL=local_storage.js.map
