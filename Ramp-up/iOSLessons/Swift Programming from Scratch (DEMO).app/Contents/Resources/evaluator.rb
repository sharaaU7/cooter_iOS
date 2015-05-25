require "./testFile.rb"
require "./evaluationResult.rb"

def outputForEvaluationResults(evaluationResults)
    return evaluationResults.map { |result| 
        result.toJSON
    }
end

class Evaluator
    attr_accessor :path, 
                  :chapterNumber,
                  :exerciseNumber,
                  :mockedCodePath,
                  :testFilePath,
                  :testFile

    def initialize(chapterNumber,exerciseNumber,testFilePath,codePath=nil)

        self.chapterNumber = chapterNumber
        self.exerciseNumber = exerciseNumber

        if codePath == nil
            self.path = "#{ARGV[3]}/Contents/Resources"
        end

        self.mockedCodePath = codePath
        self.testFilePath = testFilePath
    end

    # The path to the swift file in the playround
    def solutionPath 

        return self.mockedCodePath if self.mockedCodePath

        playgroundName = "Exercise#{chapterNumber}_#{exerciseNumber}.playground"
        playgroundPath = "#{path}/#{playgroundName}/"

        Dir.foreach(playgroundPath) do |item|
            if item.include? ".swift" 
                next if item.include? "-original"

                file = open(playgroundPath + item).read.strip
                if file and  file.length > 0
                    # puts file
                    return playgroundPath + item
                end
            end
        end

        return nil
    end

    # The code of the solution as entered by the user
    def solutionCode
        return File.open(solutionPath).read
    end

    def timeLimit
        return 2
    end

    # Evaluate the solution for a TestCase returning an EvaluationResult
    def evaluateSolution(testCase)

        code = solutionCode()

        # PARSE
        ## gets all the variables / constants
        ## finds missing variables
        ## finds typos
        code_info = testCase.parse(code)
        self.testFile.code = code

        # HACK
        ## change variable values
        ## adds extra code to check the value of a variable or stuff
        code = testCase.hack(code)

        # RUN
        ## runs the code
        ## gets the exit status
        ## gets the output
        run_info = run(code)

        # EVAL
        ## based on PARSE, HACK, RUN determines if the solution is correct 
        ## and creates an EvaluationResult
        result = eval(testCase, code_info, run_info)

        return result
    end

    def run(code)
        tempFilePath = ".tempFile"

        File.open(tempFilePath, "w+") { |io|  io.write(code)}

        output = ""
        info = nil

        exitStatus = -1
        
        status = :executed

        thread = Thread.new do
            output = `swift #{tempFilePath} 2> /dev/null`
            exitStatus = $?.exitstatus
        end

        thread.join(timeLimit)

        if thread.alive?
            Thread.kill(thread)
            status = :timed_out
        end

        
        if exitStatus != 0
            status = :compilation_error
        end

        if exitStatus == 0 
            output, info = output.split("MuchSuperDuperMegaCoolAwesomeHACK\n")
            if output and output.length == 0
                output = nil
            end
        end

        if info != nil
            info = info.lines.map { |line|
                variable, value = line.split(" ")
                {
                    variable => value.strip
                }
            }.reduce({}) { |x, y| x.merge(y) }
        end

        {
            exitStatus: exitStatus,
            status: status,
            output: output,
            info: info
        }
    end

    def eval(testCase, code_info, run_info)
        status = run_info[:status]

        if status == :compilation_error
            result = EvaluationResult.new(:compilation_error)
            result.message = "Error"

            return result
        end

        if status == :timed_out
            result = EvaluationResult.new(:timed_out)
            result.message = "Timed out"
            
            return result
        end

        missingDeclarations = code_info[:missingDeclarations]
        if missingDeclarations.count > 0
            status_sym = :missing_variables

            missingDeclarations.each do |name, message|
                if message["typo"]
                    status_sym = :typo
                end
            end

            result = EvaluationResult.new(status_sym)

            result.message = missingDeclarations.map { |name, message|
                message
            }.join("\n")

            return result
        end

        output = run_info[:output]

        if testCase.requiresOutput and (output == nil or output.strip.length == 0)
            result = EvaluationResult.new(:no_output)
            result.message = "Your code has no output!"
            result.inputs = testCase.inputs
            result.runInfo = run_info


            return result
        end

        # the test case should decide this one
        correctOutput = testCase.isOutputOK(code_info, run_info)

        if correctOutput
            result = EvaluationResult.new(:correct)
            result.message = "✅"
        else
            result = EvaluationResult.new(:incorrect)
            result.message = "❌"
        end

        result.output = output
        result.inputs = testCase.inputs
        result.codeInfo = code_info
        result.runInfo = run_info

        return result
    end

    # evaluate all testcases in a testfile
    def evaluateTestFile
        # `swift doNothing.swift`

        self.testFile = TestFile.new(testFilePath)

        evaluationResults = testFile.testCases.map do |testCase|
            evaluateSolution(testCase)
        end

        if testFile.afterTestsLambda
            testFile.afterTestsLambda.call(evaluationResults)
        end

        results = outputForEvaluationResults(evaluationResults)

        testFile.process results
    end
end