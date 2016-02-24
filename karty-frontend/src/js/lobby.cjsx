React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

css = require '../css/lobby.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	getDefaultProps: ->

	displayName: 'Lobby'

	getLabelForPlayer: (player) ->
		labels = []
		if player.master
			labels.push <span key="master" className="label label-primary">Master</span>
		
		if player.ready
			labels.push <span key="ready" className="label label-success">Připraven</span>
		else
			labels.push <span key="waiting" className="label label-danger">Zdržuje</span>
		labels

	handleReady: ->
		@props.actions.getReady @props.game.id
		return

	isEveryoneReady: ->
		@props.game.players.every (player) -> player.ready

	handleStartGame: ->
		if @props.game.players.length < 1
			alert 'K zahájení hry jsou potřeba alespoň tři hráči.'
			return
		@props.actions.startGame @props.game.id
		return

	leaveGame: ->
		@props.actions.leaveGame @props.game.id
		return


	render: ->
		me = null
		players = @props.game.players.map (player) => 
			if player.id is @props.user.data.id
				me = player
			<div key={player.id} className={css['player']}>
				<span className={css['player-name']}>{player.nickname}</span>
				{@getLabelForPlayer(player)}
			</div>

		if me?.master and @isEveryoneReady()
			startGameBtn = <div className="btn btn-primary" onClick={@handleStartGame}>Spustit hru</div>
		
		unless me?.ready 
			readyEl = <div className="btn btn-primary" onClick={@handleReady}>Jsem připraven</div>

		<div className={css['lobby']}>
			{players}
			<div className={css['buttons']}>
				<div className="btn btn-danger" onClick={@leaveGame}>Opustit hru</div>
				{readyEl}
				{startGameBtn}
			</div>
		</div>
