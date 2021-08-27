# frozen_string_literal: true

module DataMuse
  class Request
    def initialize(path)
      @path = path
    end

    def fetch
      # response = HTTP.get(full_path)
      # JSON.parse(response)
       damu = Blanket.wrap(full_path)
       damu.get
    end

    DataMuse::CONSTRAINTS.each do |k, v|
      define_method k do |variable|
        self.class.new(@path + "?#{v}=#{variable}&md=dpsrf")
      end
    end

    DataMuse::CONSTRAINTS.each do |k, v|
      define_method v do |variable|
        self.class.new(@path + "?#{v}=#{variable}&md=dpsrf")
      end
    end

    private

    def full_path
      "http://api.datamuse.com/#{@path}"
    end
  end
end
