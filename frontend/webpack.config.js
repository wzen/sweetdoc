const path = require('path');
const parentPath = __dirname.split('/').slice(0, -1).join('/');
module.exports = {
    entry: {
        application: path.join(__dirname, '/src/javascripts/greet.jsx')
    },
    output: {
        path: path.join(parentPath, '/app/assets/javascripts/webpack'),
        filename: 'greet.js'
    },
    module: {
        loaders: [
            {
                test: /.jsx$/,
                exclude: /node_modules/,
                loader: 'babel-loader',
                query:{
                    "presets":["react"]
                }
            }
        ]
    }
};