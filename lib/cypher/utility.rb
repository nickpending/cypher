module Cypher
  module Utility
    # Converts a hex string into a binary string
    # digit.hex returns the integer value which is then converted to binary string
    # Return a byte array/string
    def hex2bin(data)
      data.scan(/../).map { |digit| digit.hex }.pack("C*")
    end

    # Converts a binary string to a hex string
    # Returns a string of hex valeues
    def bin2hex(data)
      data.unpack("H*").first
    end

    # Help function that wraps frequency and scoring methods
    def english?(data)
      # Naive check of english spaces
      # Without this check we get key matches on the inversion of alpha cases and spaces become null bytes or other weird bits
      return false if hex2bin(data).match(/\s+/).nil?

      return true if character_score(data).between?(0.40, 0.60) && bigram_score(data).between?(0.075, 0.30)

      # return true if character_score(data).between?(0.30, 0.70)
   
      return false
    end
    
    def hamm(data_1, data_2)
      result = hex2bin(xor(data_1, data_2))
      # Count the 1's or the differences
      score = result.bytes.collect do |byte|
        byte.to_s(2).count("1")
      end
      score.inject(:+)
    end
    
    
    def hamm_analyzer(ciphertext, min, max)
      score = {}
      min.upto(max) do |c|
        c1 = bin2hex(ciphertext[0, c])
        c2 = bin2hex(ciphertext[c, c])
        c3 = bin2hex(ciphertext[c * 2, c])
        c4 = bin2hex(ciphertext[c * 3, c])
        
        h1 = hamm(c1, c2) / c.to_f
        score[c.to_s] = h1
      end
      # Sort by best score
      score = score.sort_by {|_key, value| value}.to_h
      score.keys
    end
  end
end
    