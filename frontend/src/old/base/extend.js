// Mix-in関数
const moduleKeywords = ['extended', 'included'];

export default class Extend {
  // クラスメソッド拡張
  static extend(obj) {
    for(let key in obj) {
      const value = obj[key];
      if(!Array.from(moduleKeywords).includes(key)) {
        this[key] = value;
      }
    }
    if(obj.extended !== null) {
      obj.extended.apply(this);
    } //callback
    return this;
  }

  // インスタンスメソッド拡張
  static include(obj) {
    for(let key in obj) {
      // Assign properties to the prototype
      const value = obj[key];
      if(!Array.from(moduleKeywords).includes(key)) {
        this.prototype[key] = value;
      }
    }
    if(obj.included !== null) {
      obj.included.apply(this);
    } //callback
    return this;
  }
}
