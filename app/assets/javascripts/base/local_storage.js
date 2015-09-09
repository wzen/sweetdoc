// Generated by CoffeeScript 1.9.2
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

  LocalStorage.saveValueForWorktable = function() {
    this.saveGeneralPageValue();
    this.saveInstancePageValue();
    this.saveEventPageValue();
    return this.saveSettingPageValue();
  };

  LocalStorage.loadValueForWorktable = function() {
    this.loadGeneralPageValue();
    this.loadInstancePageValue();
    this.loadEventPageValue();
    return this.loadSettingPageValue();
  };

  LocalStorage.saveValueForRun = function() {
    this.saveGeneralPageValue(true);
    this.saveInstancePageValue(true);
    this.saveEventPageValue(true);
    return this.saveSettingPageValue(true);
  };

  LocalStorage.loadValueForRun = function() {
    this.loadGeneralPageValue(true);
    this.loadInstancePageValue(true);
    this.loadEventPageValue(true);
    return this.loadSettingPageValue(true);
  };

  LocalStorage.isOverWorktableSaveTimeLimit = function(isRun) {
    var diffTime, key, lstorage, saveTime, time;
    if (isRun == null) {
      isRun = false;
    }
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
    return lstorage.removeItem(this.Key.WORKTABLE_SETTING_PAGEVALUES);
  };

  LocalStorage.clearWorktableWithoutSetting = function() {
    var lstorage;
    lstorage = localStorage;
    lstorage.removeItem(this.Key.WORKTABLE_GENERAL_PAGEVALUES);
    lstorage.removeItem(this.Key.WORKTABLE_INSTANCE_PAGEVALUES);
    return lstorage.removeItem(this.Key.WORKTABLE_EVENT_PAGEVALUES);
  };

  LocalStorage.clearWorktableWithoutGeneralAndSetting = function() {
    var lstorage;
    lstorage = localStorage;
    lstorage.removeItem(this.Key.WORKTABLE_INSTANCE_PAGEVALUES);
    return lstorage.removeItem(this.Key.WORKTABLE_EVENT_PAGEVALUES);
  };

  LocalStorage.clearRun = function() {
    var lstorage;
    lstorage = localStorage;
    lstorage.removeItem(this.Key.RUN_GENERAL_PAGEVALUES);
    lstorage.removeItem(this.Key.RUN_INSTANCE_PAGEVALUES);
    lstorage.removeItem(this.Key.RUN_EVENT_PAGEVALUES);
    return lstorage.removeItem(this.Key.RUN_SETTING_PAGEVALUES);
  };

  LocalStorage.saveGeneralPageValue = function(isRun) {
    var h, key, lstorage;
    if (isRun == null) {
      isRun = false;
    }
    lstorage = localStorage;
    h = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX);
    key = isRun ? this.Key.RUN_GENERAL_PAGEVALUES : this.Key.WORKTABLE_GENERAL_PAGEVALUES;
    lstorage.setItem(key, JSON.stringify(h));
    key = isRun ? this.Key.RUN_SAVETIME : this.Key.WORKTABLE_SAVETIME;
    return lstorage.setItem(key, $.now());
  };

  LocalStorage.loadGeneralPageValue = function(isRun) {
    var h, k, key, lstorage, results, v;
    if (isRun == null) {
      isRun = false;
    }
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

  LocalStorage.saveInstancePageValue = function(isRun) {
    var h, key, lstorage;
    if (isRun == null) {
      isRun = false;
    }
    lstorage = localStorage;
    h = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX);
    key = isRun ? this.Key.RUN_INSTANCE_PAGEVALUES : this.Key.WORKTABLE_INSTANCE_PAGEVALUES;
    lstorage.setItem(key, JSON.stringify(h));
    key = isRun ? this.Key.RUN_SAVETIME : this.Key.WORKTABLE_SAVETIME;
    return lstorage.setItem(key, $.now());
  };

  LocalStorage.loadInstancePageValue = function(isRun) {
    var h, k, key, lstorage, results, v;
    if (isRun == null) {
      isRun = false;
    }
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

  LocalStorage.saveEventPageValue = function(isRun) {
    var h, key, lstorage;
    if (isRun == null) {
      isRun = false;
    }
    lstorage = localStorage;
    h = PageValue.getEventPageValue(PageValue.Key.E_PREFIX);
    key = isRun ? this.Key.RUN_EVENT_PAGEVALUES : this.Key.WORKTABLE_EVENT_PAGEVALUES;
    lstorage.setItem(key, JSON.stringify(h));
    key = isRun ? this.Key.RUN_SAVETIME : this.Key.WORKTABLE_SAVETIME;
    return lstorage.setItem(key, $.now());
  };

  LocalStorage.loadEventPageValue = function(isRun) {
    var h, key, lstorage;
    if (isRun == null) {
      isRun = false;
    }
    lstorage = localStorage;
    key = isRun ? this.Key.RUN_EVENT_PAGEVALUES : this.Key.WORKTABLE_EVENT_PAGEVALUES;
    h = JSON.parse(lstorage.getItem(key));
    return PageValue.setEventPageValueByRootHash(h);
  };

  LocalStorage.saveSettingPageValue = function(isRun) {
    var h, key, lstorage;
    if (isRun == null) {
      isRun = false;
    }
    lstorage = localStorage;
    h = PageValue.getSettingPageValue(Setting.PageValueKey.PREFIX);
    key = isRun ? this.Key.RUN_SETTING_PAGEVALUES : this.Key.WORKTABLE_SETTING_PAGEVALUES;
    lstorage.setItem(key, JSON.stringify(h));
    key = isRun ? this.Key.RUN_SAVETIME : this.Key.WORKTABLE_SAVETIME;
    return lstorage.setItem(key, $.now());
  };

  LocalStorage.loadSettingPageValue = function(isRun) {
    var h, k, key, lstorage, results, v;
    if (isRun == null) {
      isRun = false;
    }
    lstorage = localStorage;
    key = isRun ? this.Key.RUN_SETTING_PAGEVALUES : this.Key.WORKTABLE_SETTING_PAGEVALUES;
    h = JSON.parse(lstorage.getItem(key));
    results = [];
    for (k in h) {
      v = h[k];
      results.push(PageValue.setSettingPageValue(Setting.PageValueKey.PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + k, v));
    }
    return results;
  };

  return LocalStorage;

})();

//# sourceMappingURL=local_storage.js.map
