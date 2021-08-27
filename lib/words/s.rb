
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
        spaced = resp.word + "#{' ' * (24 - resp.word.length) }"
        response_array << spaced
      end
    
      response_array.each_slice(5) do |res|
        puts res * ""
      end
    end
  
    def individual(response)
      r = response
      puts " #{r.word} | #{r.defHeadword}         #{r.tags} #{r.score} #{r.numSyllables} "
      r.defs.each{|r| puts r } if r.defs
    end
  
  
end
    