const path = require('path');
const glob = require("glob");
const railsRootPath = __dirname.split('/').slice(0, -2).join('/');
const webpack = require('webpack');
const vendors = [
  path.join(railsRootPath, '/vendor/assets/javascripts/jquery-1.9.1.min.js'),
  path.join(railsRootPath, '/vendor/assets/javascripts/jquery.transit.min.js'),
  'i18n-js', 'markdown',
  path.join(railsRootPath, '/vendor/assets/bootstrap/bootstrap.js'),
  path.join(railsRootPath, '/vendor/assets/contextmenu/jquery.ui-contextmenu.js'),
  ...glob.sync(path.join(railsRootPath, '/vendor/assets/colorpicker/js/*.js')),
  ...glob.sync(path.join(railsRootPath, '/vendor/assets/deflate/*.js')),
  path.join(railsRootPath, '/vendor/assets/jquery_readyselector/jquery.readyselector.js'),
  ...glob.sync(path.join(railsRootPath, '/app/assets/javascripts/i18n/*.js'))
];
const jsFiles = [
  path.join(railsRootPath, '/frontend/src/item/generator.jquery.color.js'),
  path.join(railsRootPath, '/frontend/src/base/constant.js'),
  path.join(railsRootPath, '/frontend/src/base/common.js'),
  path.join(railsRootPath, '/frontend/src/base/common_var.js'),
  path.join(railsRootPath, '/frontend/src/base/page_value.js'),
  path.join(railsRootPath, '/frontend/src/base/extend.js'),
  path.join(railsRootPath, '/frontend/src/base/event_base/event_base.js'),
  path.join(railsRootPath, '/frontend/src/base/event_base/common_event_base.js'),
  path.join(railsRootPath, '/frontend/src/base/event_base/item_event_base.js'),
  path.join(railsRootPath, '/frontend/src/base/local_storage.js'),
  path.join(railsRootPath, '/frontend/src/base/indicator.js'),
  path.join(railsRootPath, '/frontend/src/base/project.js'),
  path.join(railsRootPath, '/frontend/src/base/float_view.js'),
  path.join(railsRootPath, '/frontend/src/base/config_menu.js'),
  path.join(railsRootPath, '/frontend/src/util/color/color_change.js'),
  path.join(railsRootPath, '/frontend/src/sidebar_config/event_config.js'),
  path.join(railsRootPath, '/frontend/src/sidebar_config/sidebar_ui.js'),
  path.join(railsRootPath, '/frontend/src/sidebar_config/state_config.js'),
  path.join(railsRootPath, '/frontend/src/sidebar_config/item_state_config.js'),
  path.join(railsRootPath, '/frontend/src/common_event/common_event.js'),
  path.join(railsRootPath, '/frontend/src/common_event/background_event.js'),
  path.join(railsRootPath, '/frontend/src/common_event/screen_event.js'),
  path.join(railsRootPath, '/frontend/src/item/worktable_extend/item_base_worktable_extend.js'),
  path.join(railsRootPath, '/frontend/src/item/worktable_extend/canvas_item_base_worktable_extend.js'),
  path.join(railsRootPath, '/frontend/src/item/worktable_extend/css_item_base_worktable_extend.js'),
  path.join(railsRootPath, '/frontend/src/item/item_base.js'),
  path.join(railsRootPath, '/frontend/src/item/css_item_base.js'),
  path.join(railsRootPath, '/frontend/src/item/canvas_item_base.js'),
  path.join(railsRootPath, '/frontend/src/preload_item/pi_arrow.js'),
  path.join(railsRootPath, '/frontend/src/preload_item/pi_button.js'),
  path.join(railsRootPath, '/frontend/src/preload_item/pi_image.js'),
  path.join(railsRootPath, '/frontend/src/preload_item/pi_text.js'),
  path.join(railsRootPath, '/frontend/src/event_page_value/base/base.js'),
  path.join(railsRootPath, '/frontend/src/event_page_value/item/item.js'),
  path.join(railsRootPath, '/frontend/src/navbar/navbar.js'),
  path.join(railsRootPath, '/frontend/src/paging_animation/pageflip.js'),
  path.join(railsRootPath, '/frontend/src/motion_check/motion_check_common.js'),
  path.join(railsRootPath, '/frontend/src/coding/coding_common.js'),
  path.join(railsRootPath, '/frontend/src/worktable/common/worktable_common.js'),
  path.join(railsRootPath, '/frontend/src/worktable/common/message.js'),
  path.join(railsRootPath, '/frontend/src/worktable/common/history.js'),
  path.join(railsRootPath, '/frontend/src/worktable/common/server_storage.js'),
  path.join(railsRootPath, '/frontend/src/worktable/common/paging.js'),
  path.join(railsRootPath, '/frontend/src/worktable/common/worktable_setting.js'),
  path.join(railsRootPath, '/frontend/src/worktable/util/colorpicker.js'),
  path.join(railsRootPath, '/frontend/src/worktable/event/timeline.js'),
  path.join(railsRootPath, '/frontend/src/worktable/event/pointing/event_drag_pointing_rect.js'),
  path.join(railsRootPath, '/frontend/src/worktable/event/pointing/event_drag_pointing_draw.js'),
  path.join(railsRootPath, '/frontend/src/worktable/event/pointing/event_item_touch_pointing.js'),
  path.join(railsRootPath, '/frontend/src/worktable/handwrite/handwrite.js'),
  path.join(railsRootPath, '/frontend/src/worktable/handwrite/pointing_handwrite.js'),
  path.join(railsRootPath, '/frontend/src/worktable/worktable.js')
];
module.exports = {
  entry: {
    application: [...vendors, ...jsFiles]
  },
  output: {
    path: path.join(railsRootPath, '/app/assets/javascripts/webpack'),
    filename: 'worktable.js'
  },
  externals: {
    // require("jquery") is external and available
    //  on the global var jQuery
    "jquery": "jQuery"
  },
  module: {
    loaders: [
      {
        test: /.jsx$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        query: {
          "presets": ["react"]
        }
      }
    ]
  },
  plugins: [
    new webpack.DefinePlugin({
      isWorkTable: true
    })
  ]
};