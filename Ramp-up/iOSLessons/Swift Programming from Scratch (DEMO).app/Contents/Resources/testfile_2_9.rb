values_for	:number, [21, 56, 78, 169, 210, 589, 105, 840]

solution do |number|
	if number % 3 == 0 and number % 5 == 0 and number % 7 == 0
		"number is divisible by 3, 5 and 7"
	else
		"number is not divisible by 3, 5 and 7"
	end
end