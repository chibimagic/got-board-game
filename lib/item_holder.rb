module ItemHolder
  attr_reader :items

  def has?(criteria)
    count(criteria) > 0 ? true : false
  end

  def count(criteria)
    get_all(criteria).count
  end

  def items
    raise 'To use ItemHolder, implement items'
  end

  def get_all(criteria)
    raise 'To use ItemHolder, implement get_all'
  end

  def receive(item)
    self.items.push(item)
  end

  def get!(criteria)
    unless has?(criteria)
      raise to_s + ' has no items matching ' + criteria.to_s
    end

    get_all(criteria).first
  end

  def remove!(criteria)
    item = get!(criteria)
    self.items.delete_at(self.items.index(item))
  end
end
