has_no_output

values_for :x, [3, 5, 4, 13]
values_for :y, [1, 2, 3, 2]

expects_value :alice do |x, y|
	(12 + x) * y - x
end
