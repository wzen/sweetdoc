import React, {Component} from 'react';
import {StyleSheet, css} from 'aphrodite';

export default class Header extends Component {
  render() {
    return (
      <div className="navbar navbar-default navbar-fixed-top" role="navigation">
        <div className="container">
          <div className="navbar-header">
            <button type="button" className="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
              <span className="sr-only">Toggle navigation</span>
              <span className="icon-bar" />
              <span className="icon-bar" />
              <span className="icon-bar" />
            </button>
            <a className="navbar-brand nav_title" />
          </div>
          <div className="collapse navbar-collapse">
            <ul className="nav navbar-nav">
              <li id="header_items_file_menu">
                <a className="dropdown-toggle" data-toggle="dropdown" href="#header_items_file_menu">
                  <%= t('header_menu.file.file') %>
                        <b className="caret"></b>
                    </a>
                    <ul className="dropdown-menu" role="menu">
                      <li><a className="menu-changeproject"><%= t(' header_menu.file.changeproject') %></a></li>
                      <li><a className="menu-adminproject"><%= t(' header_menu.file.adminproject') %></a></li>
                      <li className="menu-save-li"><a className="menu-save"><%= t(' header_menu.file.save') %></a></li>
                    </ul>
                </li>
                <li id="header_items_select_menu">
                    <a className="dropdown-toggle" data-toggle="dropdown" href="#header_items_select_menu">
                        <span id="header_items_selected_menu_span"><%= t(' header_menu.action.select_action') %></span>
                        <b className="caret"></b>
                    </a>
                    <ul className="dropdown-menu" role="menu">
                        <li className="dropdown-header"><%= t(' header_menu.action.draw.draw') %></li>
                        <li className="dropdown-submenu">
                            <a className="menu-load"><%= t(' header_menu.action.preload_item') %></a>
                            <ul className="dropdown-menu">
                                <% if @preload_items.present? %>
                                    <% @preload_items.each do |p| %>
                                        <li><a id="menu-item-<%= p.dist_token %>" className="menu-item"><%= p.title %></a></li>
                                    <% end %>
                                <% else %>
                                    <li><a className="menu-item">No item</a></li>
                                <% end %>
                            </ul>
                        </li>
                        <li className="dropdown-submenu">
                            <a className="menu-load"><%= t(' header_menu.action.added_item') %></a>
                            <ul className="dropdown-menu">
                                <% if @using_items.present? %>
                                    <% @using_items.each do |p| %>
                                        <li><a id="menu-item-<%= p[Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN] %>" className="menu-item"><%= p[Const::ItemGallery::Key::TITLE] %></a></li>
                                    <% end %>
                                <% else %>
                                    <li><a className="menu-item">No item</a></li>
                                <% end %>
                            </ul>
                        </li>
                         <li className="divider"></li>
                        <li><a id="menu-action-edit" className="menu-item"><%= t(' header_menu.action.edit') %></a></li>
                        <li className="divider"></li>
                        <li>
                          <a id="menu-action-item_gallery" className="menu-item href" href="/item_gallery/">
                            <div className="icon">
                            </div>
                            <div>
                              <%= t(' header_menu.action.item_gallery') %>
                            </div>
                          </a>
                        </li>
                        <% if user_signed_in? %>
                          <li>
                            <a id="menu-action-coding" className="menu-item href" href="/coding/item">
                              <div className="icon">
                              </div>
                              <div>
                                <%= t(' header_menu.action.item_coding') %>
                              </div>
                            </a>
                          </li>
                        <% else %>
                          <li className="disabled">
                            <a id="menu-action-coding" className="menu-item href" href="" disabled="disabled">
                              <div className="icon">
                              </div>
                              <div>
                                <%= t(' header_menu.action.item_coding') %>
                              </div>
                            </a>
                          </li>
                        <% end %>
                    </ul>
                </li>

                <li id="header_etc_select_menu">
                    <a className="dropdown-toggle" data-toggle="dropdown" href="#header_etc_select_menu">
                        <%= t(' header_menu.etc.etc') %>
                        <b className="caret"></b>
                    </a>
                    <ul className="dropdown-menu" role="menu">
                        <li className="dropdown-submenu">
                            <a><%= t(' header_menu.etc.language') %></a>
                            <ul className="dropdown-menu">
                                <%= render_cell :locale, :index %>
                            </ul>
                        </li>
                        <li className="divider"></li>
                        <!--<li><a className="menu-intro"><%= t(' header_menu.etc.introduction') %></a></li>-->
                        <li><a className="menu-about"><%= t(' header_menu.etc.about') %></a></li>
                        <li className="divider"></li>
                        <li><a className="menu-backtomainpage"><%= t(' header_menu.etc.back_to_gallery') %></a></li>
                    </ul>
                </li>
            </ul>
            <ul className="nav navbar-nav navbar-right">
              <li className="last_update_time_li"><a href=""><span className="<%= Const::ElementAttribute::LAST_UPDATE_TIME_CLASS %>"></span></a></li>
              <li id="<%= Const::Paging::NAV_ROOT_ID %>">
                  <a className="dropdown-toggle" data-toggle="dropdown" href="#header-pageing">
                      <span className="<%= Const::Paging::NAV_SELECTED_CLASS %>"></span>
                      <b className="caret"></b>
                  </a>
                  <ul className="dropdown-menu <%= Const::Paging::NAV_SELECT_ROOT_CLASS %>" role="menu">
                  </ul>
              </li>
              <li id="header_items_motion_check"><a onclick="MotionCheckCommon.run()"><%= image_tag("nav/motion_check.png", size:'36x36') %></a></li>
              <li id="menu_sidebar_toggle_li"><a id="menu_sidebar_toggle"><%= image_tag("nav/sidebar.png", size:'32x32') %></a></li>
              <li>
                <%= render ' base/user/login_user' %>
              </li>
            </ul>
        </div>
    </div>
</div>
    )
  }
}