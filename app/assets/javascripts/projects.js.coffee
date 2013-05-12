$ ->
	$("#project_scm").msDropDown()
	$("#project_name").change () ->
		uid = $("#project_name").val().toLowerCase().replace /\s+/g, "-"
		$("#project_uid").val uid

	$("input.git").focus () ->
		$(this).select()

	$("#members").inputosaurus {
		autoCompleteSource : (request, response) ->
			$.get "/users/find", { find: request.term }, (datas) ->
				response datas
	}
