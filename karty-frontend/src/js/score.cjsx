React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'
_ = require 'underscore'

css = require '../css/score.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	getDefaultProps: ->
		customClassNames: []

	displayName: 'Score'

	render: ->
		classes = [css['score']].concat @props['customClassNames']
		classes = classes.join ' '

		list = _.sortBy(@props.game.players, 'points').reverse().map (player) => 
			playerClasses = [css['player-row']]
			playerClasses.push css['player-me'] if player.id is @props.user.data.id
			playerClasses = playerClasses.join ' '
			<div key={player.id} className={playerClasses}>
				<span className={css['player-name']}>{player.nickname}</span>
				<span className={css['player-points']}>{player.points}</span>
			</div>

		<div className={classes}>
			{list}
		</div>