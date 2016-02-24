React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

css = require '../css/result.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	displayName: 'Result'

	handleDestroyGame: ->
		@props.actions.destroyGame @props.game.id

	render: ->
		me = null
		players = @props.game.players.map (player) => 
			if player.id is @props.user.data.id
				me = player
			<div key={player.id} className={css['player']}>
				<span className={css['player-name']}>{player.nickname}: </span>
				<span className={css['player-points']}>{player.points}</span>
			</div>

		if me?.master
			destroyGameBtn = <div className="btn btn-danger" onClick={@handleDestroyGame}>Zrušit hru</div>

		<div>
			<div className={css['player-list']}>
				{players}
			</div>
			{destroyGameBtn}
		</div>
