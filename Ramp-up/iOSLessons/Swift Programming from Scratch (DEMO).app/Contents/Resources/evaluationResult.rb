class EvaluationResult
    # Possible values:
    # :correct // WELL DONE
    # :incorrect // EURISTICI
    # :compilation_error // EURISTICA?
    # :runtime_error // EURISTICA?
    # :timed_out // EURISTICA?
    # :no_output // PRINTEAZA IN PIZDA MATII
    # :missing_variables // CE VARIABILE NU ARE

    attr_accessor :status,
                  :message,
                  :inputs,
                  :output,
                  :runInfo,
                  :codeInfo

    def initialize(status)
        self.status = status
    end

    def toJSON
        json = {}

        json[:status] = status
        json[:message] = message if message
        json[:inputs] = inputs if inputs
        json[:output] = output if output
        json[:runInfo] = runInfo if runInfo
        json[:codeInfo] = codeInfo if codeInfo

        json
    end
end