import React from 'react';
import BaseComponent from './BaseComponent';

export default class UserIcon extends BaseComponent {
  render() {



    return(
      <div style={this.props.isGallery ? {padding: '5px'} : {}}>
        <% if user_signed_in? %>
        <%= link_to '/my_page' do %>

        <% unless current_user.thumbnail_img? %>
        <div class="circle <%= sp_class %> <%= Const::Gallery::Sidebar::USER %>">
          <%= image_tag 'gallery/sidebar/default_user.png' ,size:"#{size}x#{size}" %>
        </div>
        <% else %>
        <div class="circle <%= sp_class %> <%= Const::Gallery::Sidebar::USER %>">
          <img src="<%= current_user.thumbnail_img %>" width="<%= size %>" height="<%= size %>" />
        </div>
        <% end %>
        <% end %>
        <% else %>

        <% if show_login_modal %>
        <div class="circle <%= sp_class %> <%= Const::Gallery::Sidebar::USER %> guest" onclick="Common.showModalView(constant.ModalViewType.NOTICE_LOGIN); return false;">
          <%= image_tag 'gallery/sidebar/guest_user.png', size:"#{size}x#{size}" %>
        </div>
        <% else %>
        <div class="circle <%= sp_class %> <%= Const::Gallery::Sidebar::USER %> guest">
          <%= link_to '/user/sign_in' do %>
          <%= image_tag 'gallery/sidebar/guest_user.png', size:"#{size}x#{size}" %>
          <% end %>
        </div>
        <% end %>
        <% end %>
      </div>
    )
  }
}