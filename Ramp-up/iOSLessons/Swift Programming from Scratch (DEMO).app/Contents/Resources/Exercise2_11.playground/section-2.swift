var hp = 75

if hp < 20 {
   hp = 20
} else {
    hp = hp/10
    hp = hp + 1
    hp = hp * 10
}

println(hp)
