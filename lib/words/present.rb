# def m
# <<-EOT.gsub(/^\s+/, '')

# EOT
# end

# .tap(&method(:puts))

class Results
  attr_accessor :words, :latest

  @@all = {}

  def initialize(words, latest=[])
    @words = words
    self.addto
  end

  def self.addto
    @words.each do |w|
      wword = w[:word].to_sym
      @@all[wword] = FancyOpenStruct.new(w)
      @latest << wword
    end
  end

  def self.all
    @@all
  end

  def latest
    @latest
  end

  def word_list(part)
    @words.map { |e| e.select{|k,_| part.include? k } }
  end

  def numbered_list(part)
    @words.map.with_index(1) {|e| e.select{|k,_| part.include? k } }
  end

  def word_detail(word)
    detail = <<-EOT.gsub(/^\s+/, '')
      word[:word] word[:defs]
    EOT
    puts detail
  end
end



class Words::Results
  def initialize(response)




    class List
      def format
        @words.each

