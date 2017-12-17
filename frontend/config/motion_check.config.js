const webpack = require('webpack');
const path = require('path');
const glob = require("glob");
const railsRootPath = __dirname.split('/').slice(0, -2).join('/');
const vendors = [
  path.join(railsRootPath, '/vendor/assets/javascripts/jquery-1.9.1.min.js'),
  path.join(railsRootPath, '/vendor/assets/javascripts/jquery.transit.min.js'),
  'i18n-js', 'markdown',
  path.join(railsRootPath, '/vendor/assets/bootstrap/bootstrap.js'),
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
  path.join(railsRootPath, '/frontend/src/base/float_view.js'),
  path.join(railsRootPath, '/frontend/src/base/config_menu.js'),
  path.join(railsRootPath, '/frontend/src/util/color/color_change.js'),
  path.join(railsRootPath, '/frontend/src/common_event/common_event.js'),
  path.join(railsRootPath, '/frontend/src/common_event/background_event.js'),
  path.join(railsRootPath, '/frontend/src/common_event/screen_event.js'),
  path.join(railsRootPath, '/frontend/src/common_event/operation_guide/scroll_operation_guide.js'),
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
  path.join(railsRootPath, '/frontend/src/run/common/run_setting.js'),
  path.join(railsRootPath, '/frontend/src/run/common/run_common.js'),
  path.join(railsRootPath, '/frontend/src/run/common/run_fullscreen.js'),
  path.join(railsRootPath, '/frontend/src/run/chapter.js'),
  path.join(railsRootPath, '/frontend/src/run/scroll_chapter.js'),
  path.join(railsRootPath, '/frontend/src/run/click_chapter.js'),
  path.join(railsRootPath, '/frontend/src/run/page.js'),
  path.join(railsRootPath, '/frontend/src/run/event_action.js'),
  path.join(railsRootPath, '/frontend/src/run/guide/base.js'),
  path.join(railsRootPath, '/frontend/src/run/guide/scroll.js'),
  path.join(railsRootPath, '/frontend/src/run/guide/click.js'),
  path.join(railsRootPath, '/frontend/src/motion_check/motion_check_common.js'),
  path.join(railsRootPath, '/frontend/src/motion_check/motion_check.js')
];
module.exports = {
  entry: {
    application: [...vendors, ...jsFiles]
  },
  output: {
    path: path.join(railsRootPath, '/app/assets/javascripts/webpack'),
    filename: 'motion_check.js'
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
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV),
      frontendImageUrlRoot: process.env.NODE_ENV === 'production' ? process.env.FRONTEND_IMAGE_URL : 'http://localhost:3000',
      apiUrl: process.env.NODE_ENV === 'production' ? process.env.API_URL : 'http://localhost:3000',
      debug: process.env.NODE_ENV !== 'production'
    })
  ]
};