// クラス名からコンポーネントを動的にロードする
// @return [Object(Class)] ロードしたコンポーネントクラス
export const dynamicLoadClass = async (classes, type = 'all') => {
  let params = Array.isArray(classes) ? classes : [classes];
  params = params.map(p => {
    if (typeof p !== 'string') { return p.name; }
    else { return p; }
  });
  if (!window.loadedClasses) { window.loadedClasses = {} }
  let unloadedClassNames = params.filter(item => !window.loadedClasses.includes(item));
  if (unloadedClassNames.length > 0) {
    let searchDirs = [];
    if (type !== 'offical') {
      // searchDirs.push('***'); // TODO: ここにプラグインが格納されているリモートサーバを追加すること
    }
    if (type !== 'personal') {
      searchDirs.push('../../components');
    }
    let searchPatterns = [].concat(...searchDirs.map(s => unloadedClassNames.map(u => `${s}/**/${u}.js`)));
    let paths = await globby(searchPatterns);
    let loadClasses = await Promise.all(paths.map(p => import(p)));
    let classNames = paths.map(p => p.match(/([^/]+?)?\.js$/)[1]);
    classNames.forEach((name, idx) => {
      if(name) {
        window.loadedClasses[name] = loadClasses[idx].default();
      }
    });
  }
  return Array.isArray(classes) ? classes.map(c => window.loadedClasses[c]) : window.loadedClasses[classes];
};