React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

CardBox = require './card-box'

css = require '../css/game-list.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	displayName: 'GameList'

	createNewGame: ->
		name = prompt('Název hry')?.trim()
		return unless name && name.length > 2
		@props.actions.createNewGame name

	joinGame: (gameId) ->
		@props.actions.joinGame gameId

	render: ->
		items = [
			<CardBox key='NEW GAME' type='black' didClick={@createNewGame} customClassNames={[css['game']]}>
				Nová hra
			</CardBox>
		]

		items = items.concat Object.keys(@props.games.items).map (gameId, i) =>
			game = @props.games.items[gameId]
			players = game.players.map (player) -> player.nickname
			<CardBox key={game.id} id={game.id} type='white' didClick={@joinGame} customClassNames={[css['game']]}>
				{game.name}
				<div className={css['player-names']}>
					<div>
						<strong>Players: </strong>
					</div>
					{players.join ', '}
				</div>
			</CardBox>

		<div className={css['game-list']}>
			{items}
		</div>


