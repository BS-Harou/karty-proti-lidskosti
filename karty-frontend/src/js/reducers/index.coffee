Redux = require 'redux'
cards = require './cards'
games = require './games'
user = require './user'

rootReducer = Redux.combineReducers({
  cards
  user
  games
})

module.exports = rootReducer