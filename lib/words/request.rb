

  class Words::Request < Struct.new(:base, :endpoint, :constraint, :variable, :path, :response)
  end

  class Words::RequestBuilder
    attr_accessor :request, :response

    def initialize(request=Words::Request.new)
      @request = request
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
      resp = HTTP.get(@request.path)
      JSON.parse(resp, { :symbolize_names => true})
    end

    def request
      @request
    end
  end



b = Words::RequestBuilder.new
b.endpoint("words")
b.constraint("sp")
b.variable("cat")
b.path
br = b.response


Diction
