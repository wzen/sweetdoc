const webpack = require('webpack');
const path = require('path');
const glob = require("glob");
const railsRootPath = __dirname.split('/').slice(0, -2).join('/');
const vendors = [
  path.join(railsRootPath, '/vendor/assets/javascripts/jquery-1.9.1.min.js'),
  path.join(railsRootPath, '/vendor/assets/javascripts/jquery.transit.min.js'),
  'i18n-js',
  path.join(railsRootPath, '/vendor/assets/bootstrap/bootstrap.js'),
  path.join(railsRootPath, '/vendor/assets/contextmenu/jquery.ui-contextmenu.js'),
  path.join(railsRootPath, '/vendor/assets/jquery_readyselector/jquery.readyselector.js'),
  // ace
  path.join(railsRootPath, '/vendor/assets/jstree/jstree.js'),
  ...glob.sync(path.join(railsRootPath, '/app/assets/javascripts/i18n/*.js'))
];
const jsFiles = [
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
  path.join(railsRootPath, '/frontend/src/navbar/navbar.js'),
  path.join(railsRootPath, '/frontend/src/coding/coding_common.js'),
  path.join(railsRootPath, '/frontend/src/coding/coding.js'),

];
module.exports = {
  entry: {
    application: [...vendors, ...jsFiles]
  },
  output: {
    path: path.join(railsRootPath, '/app/assets/javascripts/webpack'),
    filename: 'coding.js'
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
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)
    })
  ]
};