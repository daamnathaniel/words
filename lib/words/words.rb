# frozen_string_literal: true


require 'blanket'

module Damu
  def self.words
    Request.new('words', {})
  end

  def self.sug
    Request.new('sug', {})
  end

  WordMethods = {
    s: :s,
    sounds_like: :sl,
    means_like: :ml,
    spelled_like: :sp,
    nouns_describing: :rel_jja,
    adjectives_describing: :rel_jjb,
    synonymos_with: :rel_syn,
    trigger: :rel_trg,
    antonyms_of: :rel_ant,
    kind_of: :rel_spc,
    more_general_than: :rel_gen,
    comprise: :rel_com,
    part_of: :rel_par,
    frequently_follow: :rel_bga,
    frequently_preceed: :rel_bgb,
    rhyme_with: :rel_rhy,
    kinda_rhyme_with: :rel_nry,
    sound_alike: :rel_hom,
    consonants_match: :rel_cns,
    left_context: :lc,
    right_context: :rc,
    max: :max,
    topics: :topic,
    v: :vocabulary
  }
end
