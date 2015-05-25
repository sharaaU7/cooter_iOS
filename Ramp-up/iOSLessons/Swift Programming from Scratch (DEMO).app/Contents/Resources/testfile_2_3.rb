values_for :a, [12, 33, 10, 12, 69]
values_for :b, [4, 13, 2, 7, 3]

solution do |a, b|
	if a % b == 0 
		"divisible"
	else
		"not divisible"
	end
end

html do |a, b, run_info|
	if run_info[:output].strip == "divisible" or run_info[:output].strip == "not divisible"
		"#{a} is #{run_info[:output].strip} by #{b}"
	else
		"Wrong output!"
	end
end