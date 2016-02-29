React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

CardBox = require './card-box'
CardGroup = require './card-group'
Score = require './score'

css = require '../css/game.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	displayName: 'Game'

	isUserCzar: ->
		@props.game.players[@props.game.czarIndex]?.id is @props.user.data.id

	pickCard: (cardId) ->
		return if @isUserCzar()
		if @props.cards.items[cardId]
			@props.actions.pickCard @props.game.id, cardId
		return

	pickWinner: (userId) ->
		return unless @isUserCzar()
		@props.actions.pickWinner @props.game.id, userId
		return

	getTotalWhiteCardsNeeded: ->
		pickingPlayers = @props.game.players.filter (player, index) =>
			return no if @props.game.players[@props.game.czarIndex]?.id is player.id
			return no unless player.state is 'online'
			return yes
		@props.game.cardsRequired * pickingPlayers.length

	render: ->
		###
			BLACK CARD
		###
		if card = @props.cards.items[@props.game.blackCard]
			blackCard = <CardBox key={card.id} type={card.type} customClassNames={[css['card'], css['black-card']]}>
				{card.value}
			</CardBox>

		###
			MINE PLAYER
		###
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

		###
			PICKED CARD GROUPS or STATE
		###
		pickedCards = []
		cardsToPick = @getTotalWhiteCardsNeeded()
		alreadyPickedReducer = (count, playerId) =>
			amountPickedByPlayer = @props.game.pickedCards[playerId]?.length or 0
			count + amountPickedByPlayer
		alreadyPicked = Object.keys(@props.game.pickedCards).reduce alreadyPickedReducer, 0
		amountPickedByMe = @props.game.pickedCards[me.id]?.length or 0

		if @isUserCzar() and alreadyPicked < cardsToPick
			pickedCards = <div className={css['payers-picking-cards']}>JSI CZAR</div>
		else if not @isUserCzar() and amountPickedByMe < @props.game.cardsRequired
			pickedCards = <div className={css['payers-picking-cards']}>VYBERTE KARTU</div>
		else if alreadyPicked < cardsToPick
			pickedCards = <div className={css['payers-picking-cards']}>HRÁČI VYBÍRAJÍ KARTY</div>
		else

			# for playerId, playerPickedCards of @props.game.pickedCards
			@props.game.randomPlayerOrder.forEach (playerId) =>
				return unless playerPickedCards = @props.game.pickedCards[playerId]
				playerPickedCardIds = playerPickedCards.map (pickedCard) -> pickedCard.cardId
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
			<h2 className={css['heading']}>Hra : {@props.game.name}</h2>
			<div className={css['picked-cards']}>
				{blackCard}
				{pickedCards}
			</div>
			<h2>Karty v ruce</h2>
			<div className={css['player-cards']}>
				{whiteCards}
			</div>
			<Score game={@props.game} user={@props.user} />
		</div>


