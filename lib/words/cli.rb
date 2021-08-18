class Words::CLI

  def call
    start
  end

  def start
    main
  end

  def main
    @session = Words::Session.new
    @session.build_request
    @session.present_results
  end


  def display


end
