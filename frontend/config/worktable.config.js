const webpack = require('webpack');
const path = require('path');
const glob = require("glob");
const railsRootPath = __dirname.split('/').slice(0, -2).join('/');
const vendors = [
  path.join(railsRootPath, '/vendor/assets/javascripts/jquery-1.9.1.min.js'),
  path.join(railsRootPath, '/vendor/assets/javascripts/jquery.transit.min.js'),
  'i18n-js', 'markdown',
  path.join(railsRootPath, '/vendor/assets/bootstrap/bootstrap.js'),
  ...glob.sync(path.join(railsRootPath, '/vendor/assets/colorpicker/js/*.js')),
  ...glob.sync(path.join(railsRootPath, '/vendor/assets/deflate/*.js')),
  path.join(railsRootPath, '/vendor/assets/jquery_readyselector/jquery.readyselector.js'),
  ...glob.sync(path.join(railsRootPath, '/app/assets/javascripts/i18n/*.js'))
];
const jsFiles = [
  path.join(railsRootPath, '/frontend/src/item/generator.jquery.color.js'),
  ...glob.sync(path.join(railsRootPath, '/frontend/src/base/**/*.js')),
  path.join(railsRootPath, '/frontend/src/util/color/color_change.js'),
  path.join(railsRootPath, '/frontend/src/sidebar_config/event_config.js'),
  path.join(railsRootPath, '/frontend/src/sidebar_config/sidebar_ui.js'),
  path.join(railsRootPath, '/frontend/src/sidebar_config/state_config.js'),
  path.join(railsRootPath, '/frontend/src/sidebar_config/item_state_config.js'),
  path.join(railsRootPath, '/frontend/src/common_event/common_event.js'),
  path.join(railsRootPath, '/frontend/src/common_event/background_event.js'),
  path.join(railsRootPath, '/frontend/src/common_event/screen_event.js'),
  ...glob.sync(path.join(railsRootPath, '/frontend/src/item/worktable_extend/**/*.js')),
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
  ...glob.sync(path.join(railsRootPath, '/frontend/src/worktable/**/*.js'))
];

// 環境変数の動作について未検証
module.exports = (env) => {
  return {
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
    resolve: {
      extensions: ['.js', '.jsx']
    },
    module: {
      loaders: [
        {
          test: /\.jsx$/,
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
        isWorkTable: true,
        frontendImageUrlRoot: process.env.NODE_ENV === 'production' ? process.env.FRONTEND_IMAGE_URL : 'http://localhost:3000',
        apiUrl: process.env.NODE_ENV === 'production' ? process.env.API_URL : 'http://localhost:3000',
        debug: process.env.NODE_ENV !== 'production'
      })
    ]
  }
};