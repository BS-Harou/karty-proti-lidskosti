React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'

css = require '../css/login.styl'

module.exports = React.createClass
	mixins: [PureRenderMixin]

	getDefaultProps: ->

	displayName: 'Login'

	componentDidMount: ->
		@refs.nickname.focus()

	handleSubmit: (ev) ->
		ev.preventDefault()
		nickname = @refs['nickname'].value.trim()
		return unless nickname.length > 2
		@props.loginUser nickname

	render: ->
		<div className={css['login']}>
			<form onSubmit={@handleSubmit} className={css['form'] + ' form-horizontal'}>
				<div className={css['heading']}>VSTOUPIT DO HRY</div>
				<div className="form-group">
					<div className="col-sm-12">
						<input className={css['input'] + ' form-control'} id="nickname" name="nickname" ref="nickname" placeholder="Přezdívka" tabindex="1" />
					</div>
				</div>
				<div className="form-group">
					<div className="col-sm-12">
						<button type="submit" className={css['button'] + ' btn btn-lg btn-primary'}>
							Vstoupit
						</button>
					</div>
				</div>
			</form>
		</div>
