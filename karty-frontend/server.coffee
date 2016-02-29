webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'
config = require './webpack.config'
productionConfig = require './webpack.production.config'

options =
  publicPath: config.output.publicPath
  historyApiFallback: yes

isProduction = ~process.argv.indexOf('production')
port = process.env.PORT ? 10000

if isProduction
  server = new WebpackDevServer webpack(productionConfig), options
  console.log 'PRODUCTION IS ON'
else
  options.hot = yes
  server = new WebpackDevServer webpack(config), options

handleListen = (err, result) ->
  if err
    console.log err
  else
    console.log "Listening at localhost:#{port}"

server.listen port, '0.0.0.0', handleListen
