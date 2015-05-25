values_for :RockysAge, [25, 50, 66, 81, 100]

solution do |rockysAge|
	rockysAge / 7
end

html do |rockysAge, run_info|
	"#{rockysAge} -> #{run_info[:output]}"
end