require "helper"
require "yaml"

class TestUtility < MiniTest::Test
    include Cypher::Frequency
    include Cypher::Utility
    include Cypher::Crypto
    
    def test_hex2bin
      bin = hex2bin("41424344")
      assert_equal(bin, "ABCD")
    end

    def test_bin2hex
      hex = bin2hex("\x01\x01\x01")
      assert_equal(hex, "010101")
    end
    
    def test_hamm
      result = hamm(bin2hex("this is a test"), bin2hex("wokka wokka!!!"))
      assert_equal(result, 37)
    end
    
    def test_hamm_analyzer
      ciphertext = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
      result = hamm_analyzer(ciphertext, 2, 5)
      assert_equal(result.first.to_i, 5)
    end
end
  