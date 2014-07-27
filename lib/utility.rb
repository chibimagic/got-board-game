class Utility
  def self.singular_plural(count, singular_noun, plural_noun)
    count == 1 ? singular_noun : plural_noun
  end
end
