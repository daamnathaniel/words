module S
  extend self
  def words_fetch(endpoint, constraint, variable) 
    DataMuse.send(endpoint).send(constraint, variable).fetch
  end

  def ift(this, that, something=nil)
    if this
      that
    else
      something
    end
  end

  def columns(response)
    response_array = []
    response.each do |resp|
    # spaced = resp.word + "#{' ' * (24 - resp.word.length) }"
    # response_array << spaced
    response_array << resp.word + "#{' ' * (24 - resp.word.length) }"
    end
    response_array.each_slice(5) do |res|
      puts res * ''
    end
  end

  def individual(response)
    r = response
    puts ''
    puts %( 
#{r.word} | #{r&.defHeadword}
p:#{r.tags[0]} #{r.tags[1]} #{r.tags[2]} s:#{r.numSyllables} )
    r&.defs.each { |r| puts r }
    puts ''
  end
end
    