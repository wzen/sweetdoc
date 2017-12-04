import React from 'react';
import BaseComponent from '../common/BaseComponent';
import {dynamicLoadClass} from "../../util/item_util";

export default class BaseScreenContainer extends BaseComponent {
  async componentWillUpdate() {
    await dynamicLoadClass(this.props.items.map(i => i.itemClassName));
  }

  contents() {
    let ret = [];
    let obj = this.props.items;
    Object.keys(obj).forEach(key => {
      let item = this[key];
      let Cls = window.classes[item.itemClassName];
      if(!Cls) return;
      ret.push(<Cls id={key} {...item}/>);
    }, obj);
    return ret;
  }
}