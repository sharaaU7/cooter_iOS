values_for :baconAge, [6, 7, 10, 2, 8]
values_for :eggsAge, [12, 22, 10, 22, 22]


check_with do |baconAge, eggsAge, run_info|
	sol = []

	if baconAge <= 7 and eggsAge <= 21 
		sol = ["you can cook bacon and eggs"]
	else
		sol = []

		if baconAge > 7 
			sol << "throw out bacon"
		end

		if eggsAge > 21 
			sol << "throw out eggs"
		end
	end

	output = run_info[:output]

	allOK = true

	output.lines.each do |line|
		clearLine = line.gsub("\n", "")
		unless sol.include? clearLine
		 	allOK = false
		end 
	end

	allOK and output and output.lines.count == sol.count
end
