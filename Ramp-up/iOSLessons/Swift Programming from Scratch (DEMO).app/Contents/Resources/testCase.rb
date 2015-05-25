require './filter.rb'
require 'erb'

class TestCase
    attr_accessor :declarations,
                  :inputs,
                  :expectedOutput,
                  :expectedDeclarations,
                  :expectedDeclationValues,
                  :requiresOutput,
                  :solutionLambda,
                  :evalLambda


    def initialize
        self.declarations = []
        self.inputs = []
        self.expectedDeclarations = []
        self.expectedDeclationValues = []
        self.requiresOutput = true
    end

    def to_s
        return "declarations #{declarations}
                inputs #{inputs}
                expectedOutput #{expectedOutput}
                expectedDeclarations #{expectedDeclarations}
                expectedDeclationValues #{expectedDeclationValues}
               "
    end

    # Substitute variables in code with values from the test case
    def substituteDeclarations(code)

        declarations.each_with_index do |declaration,index|
            testValue = inputs[index]

            code.gsub!(/^\s*var\s+#{declaration}\s*=.*$/,"var #{declaration} = #{testValue}\n")
            code.gsub!(/^\s*let\s+#{declaration}\s*=.*$/,"let #{declaration} = #{testValue}\n")
        end
    end

    # will return all the information it can from a file
    def parse(code)
        # gets info from the code: variables, constants, funcitons etc.
        # we might include data from the AST here ...
        filter_data = Filter.filters.reduce({}) { |info, filter|
            info.merge(filter.parse(code))
        }

        variables = filter_data[:variables]

        filter_data.merge({
            # include missing variables in the parse info
            missingDeclarations: missingOutputDeclarations(code).map { |variable, message|
                variables.each do |var|
                    if is_typo variable, var
                        message = "You have a typo: #{var} -> #{variable}"
                    end
                end
                [variable, message]
            }
        })
    end

    def get_ast(code)


        `swiftc -dump-ast solution.swift`
    end

    # will add extra code at the begining or end of the code
    def hack(code)
        info = parse(code)

        substituteDeclarations(code)
        
        ##### SOURCE CODE CONTEXT #####
        variables = info[:variables]
        constants = info[:constants]

        symbols = variables + constants
        ###############################

        hack_footer = ERB.new(open("hack_footer.erb").read)

        footer = hack_footer.result(binding)

        code = "#{code}\n\n#{footer}"
    end

    def isOutputOK(code_info, run_info)
        info = run_info[:info]

        expectedDeclationValues.each do |variable, value|
            if info == nil or info[variable] == nil
                return false
            end
    
            if "#{info[variable]}" != "#{value}"
                return false
            end
        end


        output = run_info[:output]

        if requiresOutput  
            unless isOutputCorrect(output)
                return false
            end
        end

        if evalLambda != nil
            params = inputs + [run_info]

            return call_lambda evalLambda, params
        end

        true
    end

    # report any expected declarations that are missing
    def missingOutputDeclarations(code)
        output = []

        # expects
        expectedDeclarations.each do |name, message|
            foundDeclaration = false

            if code =~ /^\s*var\s+#{name}\s*=.*$/
                foundDeclaration = true 
            end

            if code =~ /^\s*let\s+#{name}\s*=.*$/
                foundDeclaration = true 
            end

            if foundDeclaration == false
                output << [name, message]
            end
        end

        # expects_value
        expectedDeclationValues.each do |name, value|
            foundDeclaration = false

            if code =~ /^\s*var\s+#{name}\s*=.*$/
                foundDeclaration = true 
            end

            if code =~ /^\s*let\s+#{name}\s*=.*$/
                foundDeclaration = true 
            end

            if foundDeclaration == false
                output << [name, "You did not declare the #{name} variable"]
            end
        end

        return output
    end

    def isOutputCorrect(output)
        # puts "-" * 10
        # puts output
        # puts 
        # puts expectedOutput

        return false if output == nil
        return true if expectedOutput == nil
        
        return output.strip == expectedOutput.strip
    end
end