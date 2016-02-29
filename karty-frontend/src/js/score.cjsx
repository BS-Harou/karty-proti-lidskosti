React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'
_ = require 'underscore'

css = require '../css/score.styl'

GAME_STATES =
	LOBBY: 'lobby'
	RUNNING: 'running'
	OVER: 'over'

PLAYER_STATES =
	ONLINE: 'online'
	OFFLINE: 'offline'
	DEAD: 'dead'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	getDefaultProps: ->
		customClassNames: []

	displayName: 'Score'

	POINTS_TO_WIN: 10

	isPlayerCzar: (player) ->
		@props.game.players[@props.game.czarIndex]?.id is player.id

	getLabels: (player) ->
		# offline
		# left game

		labels = []
		if player.master
			labels.push <span key="master" className="label label-primary">Master</span>
		
		if player.points >= @POINTS_TO_WIN
			labels.push <span key="winner" className="label label-warning">Vítěz</span>

		if player.state is PLAYER_STATES.DEAD
			labels.push <span key="dead" className="label label-default">Opustil hru</span>

		if @props.game.state is GAME_STATES.RUNNING

			playerPickedCards = @props.game.pickedCards[player.id] or []
			if player.state is PLAYER_STATES.ONLINE and not @isPlayerCzar(player) and playerPickedCards.length < @props.game.cardsRequired
				labels.push <span key="picking" className="label label-danger">Vybírá karty</span>

			if @isPlayerCzar(player)
				labels.push <span key="czar" className="label label-info">Czar</span>

		labels

	render: ->
		classes = [css['score']].concat @props['customClassNames']
		classes = classes.join ' '

		list = _.sortBy(@props.game.players, 'points').reverse().map (player) => 
			playerClasses = [css['player-row']]
			playerClasses.push css['player-me'] if player.id is @props.user.data.id
			playerClasses = playerClasses.join ' '
			<div key={player.id} className={playerClasses}>
				<span className={css['player-name']}>{player.nickname}</span>
				<span className={css['player-score']}>{player.points}</span>
				<span className={css['player-labels']}>{@getLabels(player)}</span>
			</div>

		<div className={classes}>
			{list}
		</div>