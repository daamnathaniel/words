module Words

  class Request < Struct.new(:base, :endpoint, :constraint, :variable, :path, :response)
  end

  class RequestBuilder
    attr_accessor :request, :response

    def initialize
      @request = Words::Request.new
      @request.base = "https://api.datamuse.com"
    end

    def endpoint(endpoint=Words::Ask.('words or sug?'))
      @request.endpoint = endpoint
    end

    def constraint(constraint="sl")
      if @request.endpoint == "sug"
        @request.constraint = 's'
      else @request.endpoint == "words"
        @request.constraint ||= Words::Ask.('which constraint?')
      end
    end

    def variable(variable=Words::Ask.('which variable?'))
      @request.variable = variable
    end

    def path
      @request.path = "#{@request.base}/#{@request.endpoint}?#{@request.constraint}=#{@request.variable}&md=dpsrf"
    end

    def response
      response = HTTP.get(@request.path)
      @response = JSON.parse(response, { :symbolize_names => true})
    end

    def request
      @request
    end
  end
end
