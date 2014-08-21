class Utility
  def self.singular_plural(count, singular_noun, plural_noun)
    count == 1 ? singular_noun : plural_noun
  end

  def self.valid_json?(json)
    begin
      JSON.parse(json)
      return true
    rescue JSON::ParserError
      return false
    end
  end
end
