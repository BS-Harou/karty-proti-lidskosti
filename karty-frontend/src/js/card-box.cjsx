React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

css = require '../css/card-box.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	getDefaultProps: ->
		customClassNames: []
		type: 'white'
		didClick: null

	displayName: 'CardBox'

	handleClick: ->
		@props.didClick? @props.id
		return

	render: ->
		classes = [css['card-box']].concat @props['customClassNames']

		classes.push css['white-card'] if @props.type is 'white'
		classes.push css['black-card'] if @props.type is 'black'
		classes.push css['clickable'] if @props.didClick?

		classes = classes.join ' '

		<div className={classes} onClick={@handleClick}>
			{@props.children}
		</div>
