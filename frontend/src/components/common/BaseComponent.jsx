import React, { Component } from 'react';

export default class BaseComponent extends Component {
  static imageTag({src = '', size = ''}) {
    let s = `${window.frontendImageUrlRoot}/${src}`;
    let [width, height] = size.split('x');
    return <img src={s} width={width} height={height}/>
  }
  static getChildrenComponent(key) {
    return this.props.children.filter( (comp) => {
      return comp.key === key;
    });
  }

  render() {
    return null
  }
}