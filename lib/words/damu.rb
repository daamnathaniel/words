# frozen_string_literal: true


# DataMuse module instantiates Request with API endpoint arguments
module DataMuse
  def self.words
    Request.new('words')
  end

  def self.sug
    Request.new('sug')
  end
end

# DataMuse constraints serves as 
module DataMuse
  CONSTRAINTS = {
    sounds_like: :sl,
    means_like: :ml,
    spelled_like: :sp,
    nouns_modified_by: :rel_jja,
    adjectives_that_modify: :rel_jjb,
    synonymous_with: :rel_syn,
    trigger_by: :rel_trg,
    antonymns_of: :rel_ant,
    kind_of: :rel_spc,
    more_general_than: :rel_gen,
    comprise: :rel_com,
    part_of: :rel_par,
    frequently_follow: :rel_bga,
    frequently_preceed: :rel_bgb,
    rhymes_with: :rel_rhy,
    kinda_rhymes_with: :rel_nry,
    sound_alike: :rel_hom,
    consonants_match: :rel_cns,
    left_context: :lc,
    right_context: :rc,
    max: :max,
    topics: :topic,
    s: :s,
    v: :vocabulary
  }
end