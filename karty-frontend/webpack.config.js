var ExtractTextPlugin = require('extract-text-webpack-plugin')
var webpack = require('webpack');
var path = require('path');

cssConfig = "modules&localIdentName=[name]--[local]--[hash:base64:8]";

//  
//  { test: /\.styl$/, loader: ExtractTextPlugin.extract("style-loader", "css-loader!less-loader") }
// { test: /\.css$/, loader: ExtractTextPlugin.extract("style-loader", "css-loader") },

module.exports = {
    devtool: 'eval',
    debug: true,

    entry: [
        'webpack-dev-server/client?http://0.0.0.0:10000', // WebpackDevServer host and port
        'webpack/hot/only-dev-server', // "only" prevents reload on syntax errors
        "./src/js/main-redux.cjsx"
    ],

    output: {
        path: path.join(__dirname, 'build'),
        filename: "main.js",
        publicPath:  '/build/'
    },

    module: {
        loaders: [
            {
                test: /\.css$/,
                loader: "style!css?" + cssConfig + "!autoprefixer-loader?browsers=last 3 versions",
                include: path.join(__dirname, 'src/css')
            },
            {
                test: /\.styl$/,
                loader: "style!css?" + cssConfig + "!autoprefixer-loader?browsers=last 3 versions!stylus?sourceMap",
                include: path.join(__dirname, 'src/css')
            },
            { 
                test: /\.cjsx$/,
                loader: "react-hot!coffee!cjsx-loader",
                include: path.join(__dirname, 'src/js')
            },
            { 
                test: /\.coffee$/,
                loader: "coffee-loader" ,
                include: path.join(__dirname, 'src/js')
            },
            { 
                test: /\.png$/,
                loader: "url-loader?limit=20000",
                include: path.join(__dirname, 'src/assets')
            },
            {
                test: /\.jpg$/,
                loader: "file-loader",
                include: path.join(__dirname, 'src/assets')
            },
            {
                test: /\.(eot|woff|woff2|ttf|svg)$/,
                loader: "file-loader",
                include: path.join(__dirname, 'src/assets')
            }
        ]
    },
    resolveLoader: {
        modulesDirectories: ['node_modules']
    },
    resolve: {
        extensions: ['', '.js', '.coffee', '.cjsx']
    },
    plugins: [
        new webpack.HotModuleReplacementPlugin()
    ]
};