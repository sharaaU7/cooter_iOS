require "./testCase"

class TestFile

    attr_accessor :solution_lambda,
                  :symbols,
                  :values,
                  :expectedDeclarations,
                  :expectedValues,
                  :requiresOutput,
                  :evalLambda,
                  :afterTestsLambda,
                  :htmlGenerator,
                  :code


    def initialize(filePath)
        self.symbols = []
        self.values = []
        self.expectedDeclarations = []
        self.expectedValues = []
        self.requiresOutput = true

        instance_eval(open(filePath).read)

    end

    # returns the testcases for the current test file

    def valueFor(expectedValue,inputs,solution)
         case expectedValue
            when Symbol
                return solution
            when Proc
                return call_lambda(expectedValue,inputs).to_s
            else
                return expectedValue
        end
    end

    def testCases
        testCases = []

        if values.count > 0 
            number_of_tests = values[0].count

            number_of_tests.times do |testIndex|
                testCase = TestCase.new

                # add test specific values
                symbols.each_with_index do |symbol, index|
                    test_values = values[index]

                    
                    testCase.declarations << symbol.to_s
                    testCase.inputs << test_values[testIndex]
                end

                init_test testCase

                testCases << testCase
            end
        else
            testCase = TestCase.new

            init_test testCase

            testCases << testCase
        end

        return testCases
    end

    def init_test testCase
        if solution_lambda
            testCase.expectedOutput = call_lambda(solution_lambda,testCase.inputs).to_s
        else
            testCase.expectedOutput = nil
        end

        
        testCase.expectedDeclarations = expectedDeclarations
        
        expectedValues.each do |name, value|
            expected = [name, valueFor(value,
                                      testCase.inputs,
                                      testCase.expectedOutput)]

            testCase.expectedDeclationValues << expected
        end


        testCase.solutionLambda = solution_lambda
        testCase.evalLambda = evalLambda

        testCase.requiresOutput = self.requiresOutput
    end

    # provides values for a declaration. Each value represents a test case
    def values_for(symbol,test_values)
        symbols << symbol
        values << test_values
    end

    # variable should be defined
    def expects(symbol,message=nil)
        unless message
            message = "You did not declare #{symbol.to_s}"
        end

        expectedDeclarations << [symbol.to_s, message]
    end

    # Symbol should be value after code is executed
    def expects_value(symbol,value=nil,&lambda)
        #array, value or lambda. symbol
        if lambda
            expectedValues << [symbol.to_s,lambda]
            return
        end
        expectedValues << [symbol.to_s,value]
    end

    # a lambda that provides a solution for the problem. i.e. solves the problem given the input data
    def solution(&lambda)
        self.solution_lambda = lambda
    end

    # need to think about this one
    def check_with(&lambda)
        self.evalLambda = lambda
    end

    def has_no_output()
        self.requiresOutput = false
    end

    def after_tests(&lambda)
        self.afterTestsLambda = lambda
    end

    def html(&lambda)
        self.htmlGenerator = lambda
    end

    # HTML Generation

    def process results 
        allOK = true
        failedToCompile = false
        htmlTable = "<table>"
        missingVariables = false
        typo = false
        noOutput = false
        relevantResult = nil

        results.each do |result|
            status = result[:status]

            if status != :correct
                allOK = false
            end

            if status == :compilation_error
                failedToCompile = true
                break
            end

            if status == :missing_variables
                missingVariables = true
                relevantResult = result
                break
            end

            if status == :typo
                typo = true
                relevantResult = result
                break
            end

            html = "ERROR"
            if htmlGenerator 
                runInfo = result[:runInfo] 
                inputs = result[:inputs]

                html = call_lambda(htmlGenerator, inputs + [runInfo])
            else
                html = defaultHTML result
            end

            if requiresOutput and result[:status] == :no_output
                html = result[:message]
            end



            checkmark = "❌"
            if result[:status] == :correct
                checkmark = "✅"
            end

            htmlTable += "<tr><td>#{html}</td><td>#{checkmark}</td></tr>"
        end

        htmlTable += "</table>"

        if failedToCompile
            htmlTable = "<p>Compilation error!<p>"
        end


        noOutput = results.map { |result|
            result[:status]
        }.select { |status|
            status != :no_output
        }.count == 0

        if noOutput
            relevantResult = results.first
        end


        if missingVariables or typo or noOutput
            htmlTable = relevantResult[:message].lines.map { |line|
                "<p>#{line}</p>"
            }.join
        end



        {
            status: allOK ? 1 : 0,
            results: results,
            tests: htmlTable,
            code: code
        }
    end

    def defaultHTML result 
        status = result[:status]
        inputs = result[:inputs]

        if status == :compilation_error
            return ""
        end

        runInfo = result[:runInfo]
        
        info = nil

        info = runInfo[:info] if runInfo

        if info and info.count > 0
            html = ""

            if inputs and  inputs.count > 0
                html += "<span><strong>Input: </strong></span>"
    
                idx = 0
                symbols.each do |name|
                    html += "<span>#{name}: #{inputs[idx]}</span>&nbsp;&nbsp;"
                    idx += 1
                end
                # html += "<br/>"
            end

            html += "<span><strong>Output: </strong></span>"
            info.each do |key, value|
                html += "<span>#{key}: #{value}</span>&nbsp;&nbsp;"
            end

            html
        elsif runInfo and runInfo[:output]
            html = ""

            has_multiple_lines = runInfo[:output].lines.count > 1

            if inputs and  inputs.count > 0
                html += "<span><strong>Input: </strong></span>"
    
                idx = 0
                symbols.each do |name|
                    html += "<span>#{name}: #{inputs[idx]}</span>&nbsp;&nbsp;"
                    idx += 1
                end

                if has_multiple_lines
                    html += "<br><span><strong>Output: </strong></span><br>"
                else
                    html += "<span><strong>Output: </strong></span>"
                end
            end

            if has_multiple_lines
                html + "<pre>#{runInfo[:output]}</pre>"
            else
                html + "<code>#{runInfo[:output]}</code>"
            end
        elsif result[:message]
            result[:message]
        else
            "#{result[:status]}"
        end
    end

end