values_for :a, [1, 12, 123, 567, 100]

solution do |a| 
	a % 10
end

html do |a, run_info|
	"The last digit of #{a} is #{run_info[:output]}"
end