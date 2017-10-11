const path = require('path');
const glob = require("glob");
const parentPath = __dirname.split('/').slice(0, -1).join('/');
const railsRootPath = __dirname.split('/').slice(0, -2).join('/');
module.exports = {
  entry: {
    javascripts: glob.sync(path.join(parentPath, '/src/javascripts/*.jsx'))
  },
  output: {
    path: path.join(railsRootPath, '/app/assets/javascripts/webpack'),
    filename: 'test.js'
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
  }
};