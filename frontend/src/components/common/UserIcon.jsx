import React from 'react';
import BaseComponent from './BaseComponent';
import { Link } from 'react-router-dom'

export default class UserIcon extends BaseComponent {
  render() {
    let sp = this.props.isSmartphone ? 'sp' : '';
    let size = this.props.isGallery ? 50 : 40;
    size = this.props.isSmartphone ? 50 : size;
    if(this.props.isLogin) {
      let userpageLink = <Link to='/user'/>;
      let circle = (
        <div className={`circle ${sp}`}>
        {UserIcon.imageTag({
          src: this.props.userThumbnailImage ? this.props.userThumbnailImage : 'gallery/sidebar/default_user.png',
          size: `${size}x${size}`
        })}
        </div>
      );
      return (
        <div style={this.props.isGallery ? {padding: '5px'} : {}}>
          {userpageLink}
          {circle}
        </div>
      )
    } else {
      let loginLink = <Link to='/user/login'/>;
      let circle = (
        <div className={`circle ${sp}`}
                        onClick={ this.props.showLoginModal ? e => {e.preventDefault(); this.props.showModal()} : null }>
        { this.props.showLoginModal ? null : loginLink }
        {UserIcon.imageTag({
          src: 'gallery/sidebar/guest_user.png',
          size: `${size}x${size}`
        })}
        </div>
      );
      return (
        <div style={this.props.isGallery ? {padding: '5px'} : {}}>
          {circle}
        </div>
      )
    }
  }
}