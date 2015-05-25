Dir.foreach("./Tests") do |chapter|
	if chapter.include?("Chapter")
		# !!!!!!!!!!!!!!!
		# HERE BE DRAGONS
		# !!!!!!!!!!!!!!!
		exit if chapter == "Chapter3"

		Dir.foreach("./Tests/#{chapter}") do |exercise|
			if exercise.include?("Exercise")
				Dir.foreach("./Tests/#{chapter}/#{exercise}") do |test|
					chapterNumber = chapter[/[0-9]+/]
					exerciseNumber = exercise[/[0-9]+/]

					if test.include?(".rb")

						path = "./Tests/#{chapter}/#{exercise}/#{test}"

						new_path = "testfile_#{chapterNumber}_#{exerciseNumber}.rb"

						`cp #{path} #{new_path}`
					end
				end
			end
		end
	end
end