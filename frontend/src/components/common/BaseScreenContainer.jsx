import React from 'react';
import BaseComponent from '../common/BaseComponent';
import {dynamicLoadClass} from "../../util/item_util";

export default class BaseScreenContainer extends BaseComponent {
  async componentWillUpdate() {
    await dynamicLoadClass(this.props.items.map(i => i.itemClassName));
  }

  contents() {
    let ret = [];
    this.props.items.forEach(item => {
      let Cls = window.classes[item.itemClassName];
      if(!Cls) return;
      ret.push(<Cls {...item}/>);
    });
    return ret;
  }
}