React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'
CardBox = require './card-box'

css = require '../css/card-group.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	getDefaultProps: ->
		customClassNames: []
		pickId: null
		didClick: null
		pickedCards: []

	displayName: 'CardGroup'

	handleClick: ->
		@props.didClick? @props.pickId
		return

	getFullClassName: ->
		classes = [css['card-group']].concat @props['customClassNames']
		classes.push css['clickable'] if @props.didClick?
		classes = classes.join ' '

	renderCardBoxes: ->
		@props.pickedCards.map (cardId) =>
			card = @props.cards.items[cardId]
			<CardBox key={card.id} id={card.id} type={card.type} customClassNames={[css['card']]}>
				{card.value}
			</CardBox>

	render: ->
		<div className={@getFullClassName()} onClick={@handleClick}>
			{@renderCardBoxes()}
		</div>
