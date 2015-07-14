require "helper"

class TestFilters < MiniTest::Test
  include Cypher::Frequency
  include Cypher::Utility
  include Cypher::Filters
  include Cypher::Crypto

  
  def test_non_printables
    string1 = bin2hex("\x01\x02\x03\x04Have a nice data\x16\x17")
    string2 = bin2hex("Have a nice day!")
    data = [["AAAA", string1], ["BBBB", string2]]
    puts non_printables(data)
  end
end