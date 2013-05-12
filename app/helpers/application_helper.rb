module ApplicationHelper
	def include_controller_meta_tags
		p controller_path
		[controller_path, "#{controller_path}-#{action_name}"].collect do |file|
			[javascript_include_tag_if_exists(file),
			stylesheet_link_tag_if_exists(file)]
		end.flatten().join("\n").html_safe
	end

	def asset_exists? file
		Yaprom::Application.assets.find_asset file
	end

	def javascript_include_tag_if_exists file
		javascript_include_tag(file) if asset_exists? "#{file}.js"
	end

	def stylesheet_link_tag_if_exists file
		stylesheet_link_tag(file) if asset_exists? "#{file}.css"
	end
end
