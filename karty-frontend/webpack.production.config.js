var webpack = require('webpack');
var path = require('path');

cssConfig = "modules"

module.exports = {
    devtool: 'cheap-source-map',
    entry: [
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
        new webpack.DefinePlugin({
            'process.env': {
               NODE_ENV: JSON.stringify('production')
            }
        })
    ]
};