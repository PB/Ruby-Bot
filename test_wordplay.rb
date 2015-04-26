require 'test/unit'
require './wordplay'

#Unit test case for class WordPlay
class TestWordPlay < Test::Unit::TestCase
  #Test of splitting sentences to array of sentence
  def test_sentences
    assert_equal(['a', 'b', 'c d', 'e f g'], "a. b. c d. e f g.".sentences)

    test_text = %q{Hello. This is a test
of sentences separation. This is the end 
of the test.}
    assert_equal('This is the end of the test', test_text.sentences[2])
  end

  #Test of splitting sentence to words 
  def test_words
    assert_equal(%w{this is a test}, "this is a test".words)
    assert_equal(%w{these are mostly words}, "these are. mostly. words".words)
  end

  #Test of choosing  best sentence
  def test_sentence_choice
    assert_equal('This is a great test.', WordPlay.best_sentence(['This is a test.',
      'This is another test.',
      'This is a great test.'], %w{test great this}))

    assert_equal('This is a great test.', WordPlay.best_sentence(['This is a great test.'], 
      %w{still the best}))
  end

  #Test of switching pronouns
  def test_basic_pronouns
    assert_equal('i am a robot', WordPlay.switch_pronouns('you are a robot'))
    assert_equal('you are a person', WordPlay.switch_pronouns('i am a person'))
    assert_equal('i love you', WordPlay.switch_pronouns('you love me'))
  end

  #Test of switching pronouns in more complicate sentence
  def test_mixed_pronouns
    assert_equal('you gave me life', WordPlay.switch_pronouns('i gave you life'))
    assert_equal('i am not what you are', WordPlay.switch_pronouns('you are not what i am'))
    assert_equal('i annoy your dog', WordPlay.switch_pronouns('you annoy my dog'))
  end

  #Test of switching pronouns in complex sentences (to implement in future for now not equal)
  def test_complex_pronouns
    assert_not_equal('yes. i rule', WordPlay.switch_pronouns('yes. you rule'))
    assert_not_equal('why do i cry', WordPlay.switch_pronouns('why do you cry'))
  end
end