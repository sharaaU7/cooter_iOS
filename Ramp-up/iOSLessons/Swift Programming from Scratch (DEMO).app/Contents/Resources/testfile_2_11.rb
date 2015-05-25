values_for :hp, [2, 13, 45, 55, 81, 0, 90, 100]

solution do |hp|
	if hp > 0 && hp < 20 
    	hp = 20
    elsif hp % 10 != 0 
	    hp = hp / 10
	    hp = hp + 1
	    hp = hp * 10
	end

	hp
end