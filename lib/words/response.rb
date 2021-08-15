class Words::Response
  attr_reader :response, :parsed

  def self.get(request)
    @response = HTTP.get(request.path)
  end

  def self.parsed
    @parsed = JSON.parse(@response, { :symbolize_names => true })
  end
end
