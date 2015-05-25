values_for :a, [1, 2, 1, 4, 5]
values_for :b, [1, 3, 2, 4, 1]
values_for :c, [1, 2, 3, 4, 1]

solution do |a, b, c|
	if a == b or a == c or b == c 
		"At least two variables have the same value"
	else
		"All the values are different"
	end
end

