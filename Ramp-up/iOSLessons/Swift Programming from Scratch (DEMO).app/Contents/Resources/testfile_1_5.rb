has_no_output

values_for :width,  [10, 20, 50, 100, 25]
values_for :height, [10, 30, 20, 200, 222]
values_for :x, [5, 1, 10, 33, 55]
values_for :y, [5, 7, 3, 10, 12]

expects_value :perimeter do |width, height, x, y|
	2 * (width + height)
end

expects_value :area do |width, height, x, y|
	width * height - (width - x) * (height - y)
end
