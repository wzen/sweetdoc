const path = require('path');
module.exports = {
    entry: {
        application: path.join(__dirname, '/frontend/src/javascripts/greet.jsx')
    },
    output: {
        path: path.join(__dirname, '/app/assets/javascripts/webpack'),
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