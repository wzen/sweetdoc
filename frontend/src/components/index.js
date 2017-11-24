import React from 'react';
import { render } from 'react-dom'
import { BrowserRouter, Route } from 'react-router-dom'
import '../../css/common.css';
import Modal from '../containers/common/Modal';
import Overlay from '../containers/common/Overlay';
import Worktable from './worktable/index';
import User from './user/index';
import UserLogin from './user/login';
import Gallery from './gallery/index';
import ItemGallery from './item_gallery/index';
import Coding from './coding/index';

render(
  <div>
    <BrowserRouter>
      <div>
        <Route exact path='/' component={Gallery} />
        <Route path='/item_gallery' component={ItemGallery} />
        <Route path='/worktable' component={Worktable} />
        <Route path='/user' component={User} />
        <Route path='/user/login' component={UserLogin} />
        <Route path='/coding' component={Coding} />
      </div>
    </BrowserRouter>
    <Modal/>
    <Overlay/>
  </div>,
  document.body
);
