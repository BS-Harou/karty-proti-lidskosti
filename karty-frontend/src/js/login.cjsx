React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

css = require '../css/login.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	getDefaultProps: ->

	displayName: 'Login'

	handleSubmit: (ev) ->
		ev.preventDefault()
		nickname = @refs['nickname'].value.trim()
		return unless nickname.length > 2
		@props.loginUser nickname

	render: ->
		<div className={css['login']}>
			<form onSubmit={@handleSubmit}>
				<label className={css['label']} htmlFor="nickname">Přezdívka:</label>
				<input className={css['input']} id="nickname" name="nickname" ref="nickname" />
				<input type="submit" className={css['button']} value="Vstoupit" />
			</form>
		</div>
