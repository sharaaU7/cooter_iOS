values_for :a, [2, 5, 9, 35, 22]
values_for :b, [5, 1, 7, 24, 44]
values_for :c, [14, 8, 3, 27, 57]
values_for :d, [6, 27, 5, 10, 41]

solution do |a, b, c, d|
	[a, b, c, d].min
end