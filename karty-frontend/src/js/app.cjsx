React = require 'react'
PropTypes = React.PropTypes
Redux = require 'redux'
connect = require('react-redux').connect
PureRenderMixin = require 'react-addons-pure-render-mixin'

cardActions = require './actions/cards'
userActions = require './actions/user'
gameActions = require './actions/games'

ActiveCards = require './active-cards'
GameList = require './game-list'
Login = require './login'
Lobby = require './lobby'
Game = require './game'
Menu = require './menu'
Result = require './result'

App = React.createClass
  mixins: [PureRenderMixin]

  displayName: 'App'

  render: ->
    game = if @props.user.gameId then @props.games.items[@props.user.gameId] else null

    if game and game.state is 'running'
      el = <Game game={game} user={@props.user} actions={@props.actions} cards={@props.cards} />
    else if game and game.state is 'over'
      el = <Result game={game} user={@props.user} actions={@props.actions} cards={@props.cards} />
    else if game
      el = <Lobby game={game} user={@props.user} actions={@props.actions} />
    else if @props.user.data?.id
      # el = <ActiveCards cards={@props.cards} />
      el = <GameList games={@props.games} actions={@props.actions} />
    else
      el = <Login loginUser={@props.actions.loginUser} />

    if @props.user.data?.id
      menu = <Menu actions={@props.actions} />

    return (
      <div>
        {menu}
        {el}
      </div>
    )

App.propTypes =
  cards: PropTypes.object.isRequired,
  user: PropTypes.object.isRequired,
  games: PropTypes.object.isRequired,
  actions: PropTypes.object.isRequired

mapStateToProps = (state) ->
  cards: state.cards
  games: state.games
  user: state.user

mapDispatchToProps = (dispatch) ->
  allActions = Object.assign {}, cardActions, userActions, gameActions
  actions: Redux.bindActionCreators allActions, dispatch


module.exports = connect(
  mapStateToProps,
  mapDispatchToProps
)(App)