require "json"

@path = "#{ARGV[0]}/Contents/Resources"

exerciseId = ARGV[1]

testVariables = ["N"]

testCases = [[1],[2],[4],[7]]

expected = testCases.map {|x| x[0]}.map { |n|
    res = ""
    for i in 1..n 
        if i != n 
            for j in 1..n-i
                res += " "
            end
        end

        for j in 1..i*2-1 
            res += "*"
        end
        res += "\n"
    end
    res 
}


sqares = testCases.map {|x| x[0]}.map { |n|
    res = ""
    for i in 1..n 
        for j in 1..n 
            res += "*"
        end
        res += "\n"
    end
    res 
}

triangles = testCases.map {|x| x[0]}.map { |n|
    res = ""
    for i in 1..n 
        for j in 1..i 
            res += "*"
        end
        res += "\n"
    end
    res 
}

spacedTriangles = testCases.map {|x| x[0]}.map { |n|
    res = ""
    for i in 1..n 
        if i != n 
            for j in 1..n-i
                res += " "
            end
        end

        for j in 1..i 
            res += "*"
        end
        res += "\n"
    end
    res 
}


testResults = ""
isCorrect = 1

sleep 1

outputJSON = {}

outputHTML = "<table>"

testIndex = 0

testCases.each do |testCase|
    test = File.open("#{@path}/test1.test").read
    
    sectionName = ""
    Dir.foreach("#{@path}/Exercise3_8.playground/") do |item|
    	if item.include? ".swift"
    		sectionName = item
    	end
    end

    solution = File.open("#{@path}/Exercise3_8.playground/#{sectionName}").read

    ndx = 0
    testVariables.each do |variable|
        solution.gsub!(/#{"var #{variable}.+$"}/,"var #{variable} = #{testCase[ndx]}\n")
        ndx += 1
    end

    finalCode = solution + "\n" + test

    testFilePath = "#{@path}/testFile"

    File.open(testFilePath, "w") { |io|  io.write(finalCode)}

    output = `swift #{testFilePath}`
    expectedOutput = expected[testIndex]

    sqare = sqares[testIndex]
    triangle = triangles[testIndex]
    spacedTriangle = spacedTriangles[testIndex]

    correctOutput = 0


	outputHTML += "<tr>"

	n = testCase[0]
	
    if output != expectedOutput
        isCorrect = 0
        testResults += "Wrong!\n"
    else
    	correctOutput = 1
    	testResults += "Correct!\n"
    end

    if output.strip.length == 0
    	outputHTML += "<td><b>WARNING:</b> Your code did not print any output!</td>"
    else 
        paddedOutput = output.lines.map { |line|
            ln = line.gsub("\n", "")
            ln = ln + " " * (20 - ln.length) + "\n"
        }.join


		if correctOutput == 1
			outputHTML += "<td><pre><code style=\"background-color:#f0f0f0;\">#{paddedOutput}</code></pre></td>"
			outputHTML += "<td>✅</td>"
		else
            if output == sqare 
                outputHTML += "<td><pre><code style=\"background-color:#f0f0f0;\">#{paddedOutput}</code></pre> This is a square, try printing a triangle to get closer to the pyramid shape</td>"
            elsif output == triangle 
                outputHTML += "<td><pre><code style=\"background-color:#f0f0f0;\">#{paddedOutput}</code></pre> This is a triangle, you are close but you need to add spaces and a couple asterisks on each line</td>"
            elsif output == spacedTriangle 
                outputHTML += "<td><pre><code style=\"background-color:#f0f0f0;\">#{paddedOutput}</code></pre> You added the corrent number of spaces to the triangle, now tweak the number of asterisks</td>"
            else
                outputHTML += "<td><pre><code style=\"background-color:#f0f0f0;\">#{paddedOutput}</code></pre></td>"
            end

			outputHTML += "<td>❌</td>"
		end
    end

    outputHTML += "</tr>"
    testIndex += 1
end

outputHTML += "</table>"
outputJSON["tests"] = outputHTML
outputJSON["status"] = isCorrect

puts JSON.pretty_generate(outputJSON)
