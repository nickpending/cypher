require "helper"

class TestCrypto < MiniTest::Test
  include Cypher::Frequency
  include Cypher::Utility
  include Cypher::Crypto
  
  def test_create_key
    key = create_key("414243", 6)
    assert_equal(hex2bin(key).length, 6)
    assert_equal(hex2bin(key)[0], "A")
  end
  
  def test_xor
    key = create_key("010101", 10)
    plaintext = "41" * 10
    ciphertext = xor(key, plaintext)
    assert_equal(ciphertext[0,2], "40")
  end
  
  def test_transpose_blocks
    c = "1529283261283261206135243235612e276135292461242c243326242f22386123332e2025222032356132383235242c6f"
    puts transpose_blocks(c, 1)
    puts transpose_blocks(c, 2)
    puts transpose_blocks(c, 3)
    puts transpose_blocks(c, 4)
    puts transpose_blocks(c, 5)
    puts transpose_blocks(c, 6)
    puts transpose_blocks(c, 7)
  end
  
  def test_brutefore_single_xor
    #finalists = []
    #candidates = compute_single_xor("1529283261283261206135243235612e276135292461242c243326242f22386123332e2025222032356132383235242c6f")
    #candidates.each do |c|
    #  finalists << c if score_ciphertext(c.last, "character", 0.40, 0.60)
    #end
    #puts "Finalists: #{finalists}"
    break_single_xor("1529283261283261206135243235612e276135292461242c243326242f22386123332e2025222032356132383235242c6f")
  end
  
  def test_break_multi_xor
    puts break_multi_xor("0e2c20246236312d2d612363352b2e24623729273124623420316320622e2e2c30352731")
  end
  
  def test_score_ciphertext
    result = score_ciphertext(bin2hex("Now that the party is jumping"), "character", 0.40, 0.60)
    assert_equal(result, true)
  end
  
  def test_scoring
    blocks  = ["0e2431613524292420202e35", "2c622d232b62276231622c27", "20362d632e373134632e3031"]
    keys    = ["414141414141414141414141", "424242424242424242424242", "434343434343434343434343"]
    blocks.zip(keys).each do |b|
      p = xor(b.first, b.last)
      puts "Score: #{character_score(p)}"
    end
  end
end