class Card
  def ==(o)
    self.class == o.class
  end

  def self.as_json(*)
    self.to_s
  end
end
