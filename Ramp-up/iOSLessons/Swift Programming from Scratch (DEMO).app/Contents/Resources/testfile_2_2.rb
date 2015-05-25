values_for :number, [1, 2, 3, 4, 5]

solution do |number|
	if number % 2 == 1 
		"odd"
	else
		"even"
	end
end

html do |number, run_info|
	"#{number} is #{run_info[:output]}"
end