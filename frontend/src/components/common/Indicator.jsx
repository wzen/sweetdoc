import React from 'react';
import BaseComponent from '../common/BaseComponent';

export default translate()(class Indicator extends BaseComponent {
  render() {
    return (
      <div className="indicator_overlay_temp">
        <div className="floatingBarsG">
          <div className="blockG rotateG_01"/>
          <div className="blockG rotateG_02"/>
          <div className="blockG rotateG_03"/>
          <div className="blockG rotateG_04"/>
          <div className="blockG rotateG_05"/>
          <div className="blockG rotateG_06"/>
          <div className="blockG rotateG_07"/>
          <div className="blockG rotateG_08"/>
        </div>
      </div>      
    )
  }
});