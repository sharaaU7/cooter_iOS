require 'erb'

def template_named template_name
	template_path = Dir["**/#{template_name}.erb"].first
	if File.exists? template_path
		ERB.new(File.open(template_path).read)
	else
		raise "Template named '#{template_name}' not found at location #{template_path}!"
	end
end

def render template, b = nil
	unless template.is_a? ERB
		template = template_named template
	end

	template.result(b)
end