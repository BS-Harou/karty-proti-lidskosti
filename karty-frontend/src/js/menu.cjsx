

React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

css = require '../css/menu.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	displayName: 'Menu'

	logout: ->
		@props.actions.logout()

	render: ->
		<nav className={css['menu']}>
			<div className="btn btn-primary" onClick={@logout}>Odhlásit se</div>
		</nav>
