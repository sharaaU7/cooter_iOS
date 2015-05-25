CHECKMARK = "✅"
CROSS = "❌"

def call_lambda lambda, args
    begin
        if args.count == 0 
            lambda.call
        elsif args.count == 1 
            lambda.call(args[0])
        elsif args.count == 2 
            lambda.call(args[0], args[1])
        elsif args.count == 3 
            lambda.call(args[0], args[1], args[2])
        elsif args.count == 4 
            lambda.call(args[0], args[1], args[2], args[3])
        elsif args.count == 5 
            lambda.call(args[0], args[1], args[2], args[3], args[4])
        elsif args.count == 6 
            lambda.call(args[0], args[1], args[2], args[3], args[4], args[5])
        elsif args.count == 7
            lambda.call(args[0], args[1], args[2], args[3], args[4], args[5], args[6])
        elsif args.count == 8
            lambda.call(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7])
        elsif args.count == 9
            lambda.call(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8])
        end    
    rescue
        return nil
    end 
end


def expected_status filepath_or_code
    code = filepath_or_code
    if File.exists? filepath_or_code
        code = open(filepath_or_code).read
    end

    status = code.lines.last
    if status != nil and status["//"]
        status.gsub!("//", "").strip

        status.to_s
    else
        :correct
    end
end


# Typo hack

TYPE_COST = 10 # for adding a letter
TYPO_COST = {} # distance based on qwerty keyboard - fuck the french

keyboard = [
    "qwertyuiop_".split(""),
    "asdfghjkl  ".split(""),
    "zxcvbnm    ".split("")
]

for i in 0..keyboard.count-1
    for j in 0..keyboard[i].count-1
        first = keyboard[i][j]

        next if first == " "

        for x in 0..keyboard.count-1
            for y in 0..keyboard[x].count-1
                second = keyboard[x][y]

                next if second == " "
                
                dist = Math.sqrt((i-x)**2 + (j-y)**2).to_i

                TYPO_COST[first] ||= {}

                TYPO_COST[first][second] = dist
            end
        end

    end
end

# for i in 'a'..'z'
#     for j in 'a'..'z'
#         print "%2d " % TYPO_COST[i][j]
#     end
#     puts
# end

def is_typo this, of_that
    # ignore 1 letter variables
    if this.length == 1 or of_that.length == 1
        return false
    end

    # ignore difference bigger than 4 letters
    if (this.length - of_that.length).abs > 4
        return false
    end

    # cost[i][j] = the cost to transform the first i characters 
    # of this in to the first j characters of of_that
    # cost[i][0] = 0
    # cost[0][j] = 0
    # cost[i][j] = 1 + cost[i-1][j-1] if this[i] == this[j]

    n = this.length 
    m = of_that.length

    cost = Array.new(n + 1) {
        Array.new(m + 1, 0)
    }
        

    for i in 1..n
        cost[i][0] = i * TYPE_COST
    end

    for j in 1..m
        cost[0][j] = j * TYPE_COST
    end

    for i in 1..n
        for j in 1..m
            x = this[i-1].downcase
            y = of_that[j-1].downcase

            cost[i][j] = [
                cost[i-1][j] + TYPE_COST,
                cost[i][j-1] + TYPE_COST,
                cost[i-1][j-1] + TYPO_COST[x][y]
            ].min
        end
    end

    # puts cost[n][m]

    return cost[n][m] <= 18
end

# tests = [
#     ["number", "nomber"],
#     ["sun", "sum"],
#     ["secondsInYear", "secondsInAYear"],
#     ["yolo", "swag"]
# ]

# tests.each do |this, that|
#     puts "#{this} -> #{that} | #{is_typo this, that}"    
# end



