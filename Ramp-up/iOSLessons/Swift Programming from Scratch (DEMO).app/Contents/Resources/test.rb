def pathFor(chapter,exercise,fileName="solution.swift")
	return "./Tests/Chapter#{chapter}/Exercise#{exercise}/#{fileName}"
end

def testFileFor(chapter,exercise)
	return "testfile_#{chapter}_#{exercise}.rb"
end

def has_testfile(chapter, exercise)
	File.exists?(pathFor(chapter, exercise, "testfile.rb"))
end

def runTest(chapterNumber,exerciseNumber,path=nil,testPath=nil)
	unless has_testfile(chapterNumber, exerciseNumber) 
		puts "No Testfile for ch. #{chapterNumber} ex. #{exerciseNumber}"
		return
	end

	if (path == nil)
		path = pathFor(chapterNumber,exerciseNumber)
	end

	if (testPath == nil)
		testPath = testFileFor(chapterNumber,exerciseNumber)
	end

	puts `ruby evaluateExercise.rb -DEBUG #{chapterNumber} #{exerciseNumber} #{testPath} #{path}`
end



# runTest(1, 7, pathFor(1, 7, "no_output.swift"))
# runTest(1, 1)
# exit


Dir.foreach("./Tests") do |chapter|
	if chapter.include?("Chapter")
		exit if chapter == "Chapter3"

		Dir.foreach("./Tests/#{chapter}") do |exercise|
			if exercise.include?("Exercise")
				Dir.foreach("./Tests/#{chapter}/#{exercise}") do |test|

					if test.include?(".swift")

						chapterNumber = chapter[/[0-9]+/]
						exerciseNumber = exercise[/[0-9]+/]
						path = "./Tests/#{chapter}/#{exercise}/#{test}"



						runTest(chapterNumber,exerciseNumber,path)
						# exit
					end
				end

				# exit
			end
		end
	end
end