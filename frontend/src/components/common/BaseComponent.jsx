import React, { Component } from 'react';

export default class BaseComponent extends Component {
  imageTag({src = '', size = ''}) {
    return <img/>
  }
}