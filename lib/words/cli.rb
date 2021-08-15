class Words::CLI

  def call
    start
  end

  def start
    @session = Session.new
    main
  end

  def main
    @session.request
    @session.menu
    @session.response
  end
end
