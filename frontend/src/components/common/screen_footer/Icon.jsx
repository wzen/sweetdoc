import React from 'react';
import BaseComponent from '../BaseComponent';
import { translate } from 'react-i18next';

class Icon extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <div className="float_view_temp">
        <div className='wrapper'>
          <div className="icon_wrapper">
            <div className="icon"/>
          </div>
        </div>
      </div>
    )
  }
}

export default translate()(Icon);