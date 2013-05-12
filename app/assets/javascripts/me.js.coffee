$ ->
	$("#project_scm").msDropDown()

	$("#project_name").change () ->
		uid = $("#project_name").val().toLowerCase().replace /\s+/g, "-"
		$("#project_uid").val uid
