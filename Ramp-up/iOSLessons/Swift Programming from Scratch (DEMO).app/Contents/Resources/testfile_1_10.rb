has_no_output

values_for :x, [6, 17, 32, 1000, 3471]

expects_value :apples do |x| 
	x % 5
end

expects_value :oranges do |x| 
	x / 5 * 3
end