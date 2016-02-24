React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

CardBox = require './card-box'

css = require '../css/active-cards.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	displayName: 'ActiveCards'

	render: ->
		columnClass = css['active-cards']
		cardBoxes = @props.cards.items.map (card, i) =>
			
			<CardBox key={card.value} type={card.type}>
				{card.value}
			</CardBox>

		<div className={css['active-cards']}>
			{cardBoxes}
		</div>


