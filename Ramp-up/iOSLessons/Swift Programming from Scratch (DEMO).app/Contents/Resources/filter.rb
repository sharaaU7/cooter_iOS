class Filter
	attr_accessor :name, :lamdba

	def initialize(name, lamdba)
		self.name = name
		self.lamdba = lamdba
	end

	def parse code
		{
			name => lamdba.call(code)
		}
	end

	@@filters = []

	def self.filters
		@@filters
	end
end


def get name, &lamdba 
	Filter.filters << Filter.new(name, lamdba)
end

get :variables do |code|
	variables = []
	
	code.scan(/^\s*var\s+(?<name>[a-zA-Z0-9_]+)\s*=.*$/) do |variable|
		variables << variable[0]
	end
	
	variables
end

get :constants do |code|
	constants = []
	code.scan(/^\s*let\s+(?<name>[a-zA-Z0-9_]+)\s*=.*$/) do |constant|
		constants << constant[0]
	end
	constants
end