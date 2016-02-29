

React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

css = require '../css/menu.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	displayName: 'Menu'

	logout: ->
		return unless confirm 'Určitě se chete odhlásit?'
		@props.actions.logout()

	leaveGame: ->
		return unless confirm 'Určitě chcete opustit hru?'
		return unless id = @props.user.gameId
		@props.actions.leaveGame id
		return

	renderLeaveGameBtn: ->
		return null unless @props.user.gameId
		<div className="btn btn-primary" onClick={@leaveGame}>Opustit hru</div>

	renderLogoutBtn: ->
		return null unless @props.user.data.id
		<div className="btn btn-primary" onClick={@logout}>Odhlásit se</div>

	render: ->
		<nav className={css['menu']}>
			{@renderLeaveGameBtn()}
			{@renderLogoutBtn()}
		</nav>
