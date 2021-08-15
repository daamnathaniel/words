class Words::Session
  attr_reader :menu, :response, :exit

  def initialize
    @request = Request.new
    @menu = Menu.new
    @response = Response.new
  end

  def request
    @request_made = @request.make
  end

  def menu
    puts "menu"
  end

  def response
    @response.get(@request_made)
    @response.parsed
  end

  def exit
  end
end
