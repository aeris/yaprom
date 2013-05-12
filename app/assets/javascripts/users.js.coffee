$ ->
	update_name = () ->
		common_name = $("#user_common_name").val().toLowerCase().replace /\s+/g, ""
		surname = $("#user_surname").val().toLowerCase().replace /\s+/g, ""

		uid = common_name.substring(0, 1) + surname
		$("#user_uid").val uid

		email = common_name + "." + surname + "@" + $("#user_email").attr 'data-domain'
		$("#user_email").val email

	$("#user_common_name").change update_name
	$("#user_surname").change update_name
