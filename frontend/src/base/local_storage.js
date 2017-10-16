// WebStorage
export default class LocalStorage {
  static initClass() {

    const Cls = (this.Key = class Key {
      static initClass() {
        // @property [Int] WORKTABLE_EVENT_PAGEVALUES アイテム情報
        this.WORKTABLE_GENERAL_PAGEVALUES = 'worktable_general_pagevalues';
        // @property [Int] WORKTABLE_EVENT_PAGEVALUES アイテム情報
        this.WORKTABLE_INSTANCE_PAGEVALUES = 'worktable_instance_pagevalues';
        // @property [Int] WORKTABLE_EVENT_PAGEVALUES イベント
        this.WORKTABLE_EVENT_PAGEVALUES = 'worktable_event_pagevalues';
        // @property [Int] WORKTABLE_SETTING_PAGEVALUES 共通設定
        this.WORKTABLE_SETTING_PAGEVALUES = 'worktable_setting_pagevalues';
        // @property [Int] WORKTABLE_SAVETIME 保存時間
        this.WORKTABLE_SAVETIME = 'worktable_time';
        // @property [Int] WORKTABLE_EVENT_PAGEVALUES アイテム情報
        this.RUN_GENERAL_PAGEVALUES = 'run_general_pagevalues';
        // @property [Int] WORKTABLE_EVENT_PAGEVALUES アイテム情報
        this.RUN_INSTANCE_PAGEVALUES = 'run_instance_pagevalues';
        // @property [Int] WORKTABLE_EVENT_PAGEVALUES イベント
        this.RUN_EVENT_PAGEVALUES = 'run_event_pagevalues';
        // @property [Int] WORKTABLE_SETTING_PAGEVALUES 共通設定
        this.RUN_SETTING_PAGEVALUES = 'run_setting_pagevalues';
        // @property [Int] RUN_FOOTPRINT_PAGE_VALUES 操作履歴
        this.RUN_FOOTPRINT_PAGE_VALUES = 'run_footprint_pagevalues';
        // @property [Int] RUN_SAVETIME 保存時間
        this.RUN_SAVETIME = 'run_time';
      }
    });
    Cls.initClass();

    this.WORKTABLE_SAVETIME = 5;
    this.RUN_SAVETIME = 9999;
  }

  constructor(userToken) {
    this.userToken = userToken;
  }

  // PageValueを保存
  saveAllPageValues() {
    this.saveGeneralPageValue();
    this.saveInstancePageValue();
    this.saveEventPageValue();
    return this.saveSettingPageValue();
  }

  // PageValueを読み込み
  loadAllPageValues() {
    this.loadGeneralPageValue();
    this.loadInstancePageValue();
    this.loadEventPageValue();
    return this.loadSettingPageValue();
  }

  // 保存時間が経過しているか
  isOverWorktableSaveTimeLimit() {
    if((typeof localStorage === 'undefined' || localStorage === null)) {
      return true;
    }

    let key = this.userToken;
    let time = 0;
    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時
      return true;
    }

    if(window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_SAVETIME;
      time = this.constructor.WORKTABLE_SAVETIME;
    } else {
      key += this.constructor.Key.RUN_SAVETIME;
      time = this.constructor.RUN_SAVETIME;
    }

    if(key !== this.userToken) {
      const saveTime = localStorage.getItem(key);
      if((saveTime === null)) {
        return true;
      }
      const diffTime = Common.calculateDiffTime($.now(), saveTime);
      return parseInt(diffTime.minutes) > time;
    } else {
      return true;
    }
  }

  generalKey() {
    let key = this.userToken;

    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は保存しない
      return '';
    }

    if(window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_GENERAL_PAGEVALUES;
    } else {
      key += this.constructor.Key.RUN_GENERAL_PAGEVALUES;
    }
    return key;
  }

  instanceKey() {
    let key = this.userToken;

    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は保存しない
      return '';
    }

    if(window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES;
    } else {
      key += this.constructor.Key.RUN_INSTANCE_PAGEVALUES;
    }
    return key;
  }

  eventKey() {
    let key = this.userToken;

    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は保存しない
      return '';
    }

    if(window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_EVENT_PAGEVALUES;
    } else {
      key += this.constructor.Key.RUN_EVENT_PAGEVALUES;
    }
    return key;
  }

  settingKey() {
    let key = this.userToken;

    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は保存しない
      return '';
    }

    if(window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_SETTING_PAGEVALUES;
    } else {
      key += this.constructor.Key.RUN_SETTING_PAGEVALUES;
    }
    return key;
  }

  footprintKey() {
    let key = this.userToken;

    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は保存しない
      return '';
    }

    if(!window.isWorkTable) {
      key += this.constructor.Key.RUN_FOOTPRINT_PAGE_VALUES;
    }
    return key;
  }

  savetimeKey() {
    let key = this.userToken;

    if((window.isItemPreview !== null) && window.isItemPreview) {
      // アイテムプレビュー時は保存しない
      return '';
    }

    if(window.isWorkTable) {
      key += this.constructor.Key.WORKTABLE_SAVETIME;
    } else {
      key += this.constructor.Key.RUN_SAVETIME;
    }
    return key;
  }

  savetime() {
    let time = 0;
    if(window.isWorkTable) {
      time = this.constructor.WORKTABLE_SAVETIME;
    } else {
      time = this.constructor.RUN_SAVETIME;
    }
    return time;
  }

  // 全ワークテーブルキャッシュを消去
  clearWorktable() {
    if(typeof localStorage !== 'undefined' && localStorage !== null) {
      localStorage.removeItem(this.constructor.Key.WORKTABLE_GENERAL_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_EVENT_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_SETTING_PAGEVALUES);
      return localStorage.removeItem(this.constructor.Key.WORKTABLE_SAVETIME);
    }
  }

  // 設定値以外のワークテーブルキャッシュを消去
  clearWorktableWithoutSetting() {
    if(typeof localStorage !== 'undefined' && localStorage !== null) {
      localStorage.removeItem(this.constructor.Key.WORKTABLE_GENERAL_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_EVENT_PAGEVALUES);
      return localStorage.removeItem(this.constructor.Key.WORKTABLE_SAVETIME);
    }
  }

  // 共通値と設定値以外のワークテーブルキャッシュを消去
  clearWorktableWithoutGeneralAndSetting() {
    if(typeof localStorage !== 'undefined' && localStorage !== null) {
      localStorage.removeItem(this.constructor.Key.WORKTABLE_INSTANCE_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.WORKTABLE_EVENT_PAGEVALUES);
      return localStorage.removeItem(this.constructor.Key.WORKTABLE_SAVETIME);
    }
  }

  // 実行画面キャッシュを消去
  clearRun() {
    if(typeof localStorage !== 'undefined' && localStorage !== null) {
      localStorage.removeItem(this.constructor.Key.RUN_GENERAL_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.RUN_INSTANCE_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.RUN_EVENT_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.RUN_SETTING_PAGEVALUES);
      localStorage.removeItem(this.constructor.Key.RUN_FOOTPRINT_PAGE_VALUES);
      return localStorage.removeItem(this.constructor.Key.RUN_SAVETIME);
    }
  }

  // キャッシュに共通値を保存
  saveGeneralPageValue() {
    if((typeof Project !== 'undefined' && Project !== null) && Project.isSampleProject()) {
      // サンプルプロジェクトでは保存しない
      return;
    }

    const key = this.generalKey();
    if((key !== '') && (typeof localStorage !== 'undefined' && localStorage !== null)) {
      const h = PageValue.getGeneralPageValue(PageValue.Key.G_PREFIX);
      localStorage.setItem(key, JSON.stringify(h));
      // 現在時刻を保存
      return localStorage.setItem(this.savetimeKey(), $.now());
    }
  }

  // キャッシュから共通値を読み込み
  loadGeneralValue() {
    if(typeof localStorage !== 'undefined' && localStorage !== null) {
      const l = localStorage.getItem(this.generalKey());
      if(l !== null) {
        return JSON.parse(l);
      } else {
        return null;
      }
    }
  }

  loadGeneralPageValue() {
    const h = this.loadGeneralValue();
    if(h !== null) {
      return PageValue.setGeneralPageValue(PageValue.Key.G_PREFIX, h);
    }
  }

  // キャッシュにインスタンス値を保存
  saveInstancePageValue() {
    if((typeof Project !== 'undefined' && Project !== null) && Project.isSampleProject()) {
      // サンプルプロジェクトでは保存しない
      return;
    }

    const key = this.instanceKey();
    if(key !== '') {
      if(typeof localStorage !== 'undefined' && localStorage !== null) {
        const h = PageValue.getInstancePageValue(PageValue.Key.INSTANCE_PREFIX);
        localStorage.setItem(key, JSON.stringify(h));
        // 現在時刻を保存
        return localStorage.setItem(this.savetimeKey(), $.now());
      }
    }
  }

  // キャッシュからインスタンス値を読み込み
  loadInstancePageValue() {
    if(typeof localStorage !== 'undefined' && localStorage !== null) {
      const l = localStorage.getItem(this.instanceKey());
      if(l !== null) {
        const h = JSON.parse(l);
        return PageValue.setInstancePageValue(PageValue.Key.INSTANCE_PREFIX, h);
      }
    }
  }

  // キャッシュにイベント値を保存
  saveEventPageValue() {
    if((typeof Project !== 'undefined' && Project !== null) && Project.isSampleProject()) {
      // サンプルプロジェクトでは保存しない
      return;
    }

    const key = this.eventKey();
    if((key !== '') && (typeof localStorage !== 'undefined' && localStorage !== null)) {
      const h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT);
      localStorage.setItem(key, JSON.stringify(h));
      // 現在時刻を保存
      return localStorage.setItem(this.savetimeKey(), $.now());
    }
  }

  // キャッシュからイベント値を読み込み
  loadEventPageValue() {
    if(typeof localStorage !== 'undefined' && localStorage !== null) {
      const l = localStorage.getItem(this.eventKey());
      if(l !== null) {
        const h = JSON.parse(l);
        return PageValue.setEventPageValue(PageValue.Key.E_SUB_ROOT, h);
      }
    }
  }

  // キャッシュに共通設定値を保存
  saveSettingPageValue() {
    if((typeof Project !== 'undefined' && Project !== null) && Project.isSampleProject()) {
      // サンプルプロジェクトでは保存しない
      return;
    }

    const key = this.settingKey();
    if((key !== '') && (typeof localStorage !== 'undefined' && localStorage !== null)) {
      const h = PageValue.getSettingPageValue(PageValue.Key.ST_PREFIX);
      return localStorage.setItem(key, JSON.stringify(h));
    }
  }

  // キャッシュから共通設定値を読み込み
  loadSettingPageValue() {
    if(typeof localStorage !== 'undefined' && localStorage !== null) {
      const l = localStorage.getItem(this.settingKey());
      if(l !== null) {
        const h = JSON.parse(l);
        return PageValue.setSettingPageValue(PageValue.Key.ST_PREFIX, h);
      }
    }
  }

  // キャッシュに操作履歴値を保存
  saveFootprintPageValue() {
    if((typeof Project !== 'undefined' && Project !== null) && Project.isSampleProject()) {
      // サンプルプロジェクトでは保存しない
      return;
    }

    const key = this.footprintKey();
    if((key !== '') && (typeof localStorage !== 'undefined' && localStorage !== null)) {
      const h = PageValue.getFootprintPageValue(PageValue.Key.F_PREFIX);
      return localStorage.setItem(key, JSON.stringify(h));
    }
  }

  // キャッシュから操作履歴値を読み込み
  loadCommonFootprintPageValue() {
    if(typeof localStorage !== 'undefined' && localStorage !== null) {
      const l = localStorage.getItem(this.footprintKey());
      if(l !== null) {
        const h = JSON.parse(l);
        const ret = {};
        for(let k in h) {
          const v = h[k];
          if(k.indexOf(PageValue.Key.P_PREFIX) < 0) {
            ret[k] = v;
          }
        }
        return PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, ret);
      }
    }
  }

  loadPagingFootprintPageValue(pageNum) {
    if(typeof localStorage !== 'undefined' && localStorage !== null) {
      const l = localStorage.getItem(this.footprintKey());
      if(l !== null) {
        const h = JSON.parse(l);
        const ret = {};
        for(let k in h) {
          const v = h[k];
          if((k.indexOf(PageValue.Key.P_PREFIX) >= 0) && (parseInt(k.replace(PageValue.Key.P_PREFIX, '')) === pageNum)) {
            ret[k] = v;
          }
        }
        return PageValue.setFootprintPageValue(PageValue.Key.F_PREFIX, ret);
      }
    }
  }
}

LocalStorage.initClass();

// インスタンスを作成
window.lStorage = new LocalStorage(utoken);