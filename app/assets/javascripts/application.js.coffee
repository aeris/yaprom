###
//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.dd
//= require bootstrap-dropdown
//= require bootstrap-alert
//= require bootstrap-transition
//= require bootstrap-modal
//= require bootstrap.file-input
//= require inputosaurus
//= require_self
###

autoClosingAlert = (selector, delay) ->
	window.setTimeout (->
		$(selector).fadeOut("slow")
	), delay

autoClosingAlert "#flash > div", 2000
