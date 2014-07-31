module TokenHolder
  attr_reader :tokens

  def has_token?(criteria)
    count_tokens(criteria) > 0 ? true : false
  end

  def count_tokens(criteria)
    get_tokens(criteria).count
  end

  def get_tokens(criteria)
    raise 'To use TokenHolder, implement get_tokens'
  end

  def receive_token(token)
    @tokens.push(token)
  end

  def remove_token!(criteria)
    unless has_token?(criteria)
      raise to_s + ' has no tokens matching ' + criteria.to_s
    end

    token = get_tokens(criteria).first
    @tokens.delete_at(@tokens.index(token))
  end
end
