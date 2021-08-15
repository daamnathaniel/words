
class Words::Request
  attr_accessor :base, :endpoint, :constraint, :variable, :path

  def initialize(base=nil, endpoint=nil, constraint=nil, variable=nil)
    @base = 'api.datamuse.com'
    @endpoint = endpoint
    @constraint = constraint
    @variable = variable
    @path = path
  end

  def endpoint
    @endpoint ||= Ask.('words or sug? ')
  end

  def constraint
    if @endpoint == "words"
      @constraint ||= Ask.('which constraint?')
    else @endpoint == "sug"
      @consraint = "s"
    end
  end

  def variable
    @variable ||= Ask.('which variable?')
  end

  def path
    @path = "#{@base}/#{@endpoint}?#{@constraint}=#{@variable}&md=dpsrf"
  end

  def make
    self.endpoint
    self.constraint
    self.variable
    self.path
  end

end
