# Words

Words is an api wrapper for DataMuse. For now. It will become an aggregate of different 'word' apis to make searching for words easier.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'words'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install words

## Usage

You are first asked to choose between 'words' or 'sug'. Words returns a list of words (and multiword expressions) from a given vocabulary that match a given set of constraints. Sug (for suggestion) provides word suggestions given a partially-entered query using a combination of the operations described in the “/words” resource above. 
If you choose 'words' you are then asked to choose one of the constraints for the words.
	means_like, sounds_like, spelled_like, nouns_modified_by, adjectives_that_modify, synonymous_with, trigger_by, antonymns_of, kind_of,
    more_general_than, comprise, part_of, frequently_follow, frequently_preceed, rhymes_with, kinda_rhymes_with, sound_alike,
    consonants_match, left_context, right_context, max, topics, v (vocabulary- defaults to English. es for Spanish. enwiki for English-language Wikipedia)
    refer to DataMuse site for further explaination[DataMuse](https://www.datamuse.com/api/)
If you choose 'sug' and after you choose a constraint, then choose the word or partial word you want your search to be based upon.

When given a list, the option of 'more' is available to choose a specific word for more detail.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daamnathaniel/words. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/daamnathaniel/words/blob/words/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the Words project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/daamnathaniel/words/blob/words/CODE_OF_CONDUCT.md).
