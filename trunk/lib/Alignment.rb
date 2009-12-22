
# All possible alignments.
#

module DDOChargen

  class Alignment
    LAWFUL_GOOD = 1,
    LAWFUL_NEUTRAL = 2,
    CHAOTIC_GOOD = 3,
    CHAOTIC_NEUTRAL = 4,
    NEUTRAL = 5

    def to_str ( align = nil )
      return "Lawful Good" if align == LAWFUL_GOOD
      return "Lawful Neutral" if align == LAWFUL_NEUTRAL
      return "Chaotic Good" if align == CHAOTIC_GOOD
      return "Chaotic Neutral" if align == CHAOTIC_NEUTRAL
      return "Neutral" if align == NEUTRAL
      return nil if align == nil
    end

    def from_str ( align )
      a = align.downcase
      return LAWFUL_GOOD if a == "lawful good"
      return LAWFUL_NEUTRAL if a == "lawful neutral"
      return CHAOTIC_GOOD if a == "chaotic good"
      return CHAOTIC_NEUTRAL if a == "chaotic neutral"
      return NEUTRAL if a == "neutral"
      return nil
    end
    
    def to_a
      return [LAWFUL_GOOD, LAWFUL_NEUTRAL, CHAOTIC_GOOD, CHAOTIC_NEUTRAL, NEUTRAL]
    end
    
  end

end
