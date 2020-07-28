class Album 
    attr_reader :name, 
                :cover, 
                :id

  def initialize(attributes)
      @id = attributes[:id]
      @name = attributes[:name]
      @cover = attributes[:images].first[:url]
  end
end 