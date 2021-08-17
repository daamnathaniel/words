class Words::Session
  attr_reader :request, :menu, :exit

  def initialize
    @build = Words::RequestBuilder.new
  end

  def build_request
    @build.endpoint
    @build.constraint
    @build.variable
    @build.path
    @build.response
    @response = @build.request.response
  end

  def present_results

  end

  def get_direction
  end


  def exit
  end
end
