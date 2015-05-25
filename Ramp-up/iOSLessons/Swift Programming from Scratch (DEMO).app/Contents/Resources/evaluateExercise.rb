Dir.chdir(File.dirname(__FILE__))
require "json"
require "./utils.rb"
require "./evaluator.rb"

if ARGV[0] == "-DEBUG"
	evaluator = Evaluator.new(ARGV[1],ARGV[2],ARGV[3],ARGV[4])

	result = evaluator.evaluateTestFile()

	expected_outcoume = expected_status ARGV[4]

	allOK = true

	result[:results].each do |res|
		if res[:status].to_s != expected_outcoume.to_s
			allOK = false
			break
		end
	end

	if allOK
		print "✅"
	else
		print "❌"
	end

	puts "  - ch #{ARGV[1]} ex #{ARGV[2]} - #{ARGV[4]}"

	# puts JSON.pretty_generate(result)
else
	sleep 0.1

	chapter = ARGV[1]
	exercise = ARGV[2]
	mainBundle = ARGV[3]
		
	testFilePath = mainBundle + "/Contents/Resources/testfile_#{chapter}_#{exercise}.rb"
	codePath = mainBundle + "/Contents/Resources/Exercise#{chapter}_#{exercise}.playground/section-1.swift"

	evaluator = Evaluator.new(ARGV[1],ARGV[2],testFilePath)

	result = evaluator.evaluateTestFile()


	puts JSON.pretty_generate(result)
end

# puts JSON.pretty_generate(result)


# outputJSON = {}
# outputHTML = "<table>"

# testCases.each do |testCase|
#     test = File.open("#{@path}/test1.test").read
    
#     sectionName = ""
#     Dir.foreach("#{@path}/Exercise1_1.playground/") do |item|
#     	if item.include? ".swift"
#     		sectionName = item
#     	end
#     end

#     solution = File.open("#{@path}/Exercise1_1.playground/#{sectionName}").read

#     ndx = 0
#     testVariables.each do |variable|
#         solution.gsub!(/#{"var #{variable}.+$"}/,"var #{variable} = #{testCase[ndx]}\n")
#         ndx += 1
#     end

#     finalCode = solution + "\n" + test

#     testFilePath = "#{@path}/testFile"

#     File.open(testFilePath, "w") { |io|  io.write(finalCode)}

#     output = `swift #{testFilePath}`

#     correctOutput = 0


# 	outputHTML += "<tr>"

# 	v1 = testCase[0]
# 	v2 = testCase[1]

# 	result = output.to_i 
    
#     if (v1 + v2 != result)
    	
#         isCorrect = 0
#         testResults += "Wrong!\n"
#     else
#     	correctOutput = 1
#     	testResults += "Correct!\n"
#     end

#     if output.strip.length == 0
#     	outputHTML += "<td><b>WARNING:</b> Your code did not print any output!</td>"
#     else 
# 		if correctOutput == 1
# 			outputHTML += "<td>#{v1} + #{v2} = #{result} ✅</td>"
# 		else
# 			outputHTML += "<td>#{v1} + #{v2} = #{result} ❌</td>"
# 		end
#     end

#     outputHTML += "</tr>"

# end

# outputHTML += "</table>"
# outputJSON["tests"] = outputHTML
# outputJSON["status"] = isCorrect

# puts JSON.pretty_generate(outputJSON)
