require "helper"
require "yaml"

class TestUtility < MiniTest::Test
    include Cypher::Frequency
    include Cypher::Utility
    
    def setup
      @corpus = YAML.load_file("test/english.yml")
    end

    def test_frequency
      result = character_frequency(bin2hex(@corpus["short"]))
      assert_equal(result["t"], 6)
    end
    
    def test_character_score
      puts "Total: #{CHARACTER_FREQUENCY_TOTAL}"
      puts result = character_score(bin2hex(@corpus["short"]))
      puts result = character_score(bin2hex(@corpus["medium"]))
      puts result = character_score(bin2hex(@corpus["long"]))
      puts "Score for Partials"
      puts result = character_score("0e2431613524292420202e35")
      puts result = character_score("2c622d232b62276231622c27")
      puts result = character_score("20362d632e373134632e3031")
    end
    
    def test_bigram_frequency
      result = bigram_frequency(bin2hex(@corpus["short"]))
      assert_equal(result["on"], 0)
    end
  
    def test_bigram_score
      puts "Bigram Total: #{BIGRAM_FREQUENCY_TOTAL}"
      puts result = bigram_score(bin2hex(@corpus["short"]))
      puts result = bigram_score(bin2hex(@corpus["medium"]))
      puts result = bigram_score(bin2hex(@corpus["long"]))
    end
    
    def test_english
    end
end