module TokenHolder
  attr_reader :tokens

  def has_token?(token_class)
    count_tokens(token_class) > 0 ? true : false
  end

  def count_tokens(token_class)
    @tokens.count { |token| token.is_a?(token_class) }
  end

  def get_tokens(token_class)
    @tokens.find_all { |token| token.is_a?(token_class) }
  end

  def receive_token(token)
    @tokens.push(token)
  end

  def remove_token(token_class)
    unless has_token?(token_class)
      raise to_s + ' has no ' + token_class.to_s
    end

    token = get_tokens(token_class).first
    @tokens.delete_at(@tokens.index(token))
  end
end
