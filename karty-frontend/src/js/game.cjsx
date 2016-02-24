React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

CardBox = require './card-box'
CardGroup = require './card-group'

css = require '../css/game.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	displayName: 'Game'

	pickCard: (cardId) ->
		if @props.cards.items[cardId]
			@props.actions.pickCard @props.game.id, cardId
		return

	pickWinner: (cardId) ->
		if @props.cards.items[cardId]
			@props.actions.pickWinner @props.game.id, cardId
		return

	renderPlayers: ->
		@props.game.players.map (player) => 
			<div key={player.id} className={css['player']}>
				<span className={css['player-name']}>{player.nickname}: </span>
				<span className={css['player-points']}>{player.points}</span>
			</div>

	render: ->
		columnClass = css['game']
		if card = @props.cards.items[@props.game.card]
			blackCard = <CardBox key={card.id} type={card.type} customClassNames={[css['card']]}>
				{card.value}
			</CardBox>

		me = null
		@props.game.players.some (player) => 
			if player.id is @props.user.data.id
				me = player

		# TODO use card ids
		if me and me.cards
			whiteCards = me.cards.map (cardId) =>
				card = @props.cards.items[cardId]
				<CardBox key={card.id} id={card.id} didClick={@pickCard} type={card.type} customClassNames={[css['card']]}>
					{card.value}
				</CardBox>

		pickedCards = []

		for playerId, playerPickedCards of @props.game.pickedCards
			playerPickedCardIds = playerPickedCards.map (pickedCard) => pickedCard.cardId
			pickedCards.push(
				<CardGroup 
					cards={@props.cards}
					customClassNames={[css['grouped-cards']]}
					didClick={@pickWinner}
					key={playerId}
					pickedCards={playerPickedCardIds}
					pickId={playerId}
				 />
			)

		<div className={css['game']}>
			<div className={css['played-cards']}>
				{blackCard}
				{pickedCards}
			</div>
			<h2>Karty v ruce</h2>
			<div className={css['player-cards']}>
				{whiteCards}
			</div>
			<div className={css['player-list']}>
				{@renderPlayers()}
			</div>
		</div>


