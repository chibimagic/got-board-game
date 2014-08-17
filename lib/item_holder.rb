module ItemHolder
  attr_reader :items

  def has?(criteria)
    count(criteria) > 0 ? true : false
  end

  def count(criteria)
    get_all(criteria).count
  end

  def get_all(criteria)
    raise 'To use ItemHolder, implement get_all'
  end

  def receive(item)
    @items.push(item)
  end

  def remove!(criteria)
    unless has?(criteria)
      raise to_s + ' has no items matching ' + criteria.to_s
    end

    item = get_all(criteria).first
    @items.delete_at(@items.index(item))
  end
end
