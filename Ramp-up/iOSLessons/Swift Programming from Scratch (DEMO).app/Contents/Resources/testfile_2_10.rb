values_for :x,    [2,   5, 45, 10, 23]
values_for :y,    [5,   3, 47, 22, 14]
values_for :lowX, [12, 44,  9, 32,  9]
values_for :lowY, [14, 34, 46, 39,  7]
values_for :highX,[44, 78, 89, 90, 67]
values_for :highY,[37, 56, 75, 73, 78]

solution do |x, y, lowX, lowY, highX, highY|
	if x >= lowX and y >= lowY and x <= highX and y <= highY
		"inside"
	else
		"not inside"	
	end
end