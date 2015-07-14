module Cypher
  module Crypto
    # Create a repeating sequence key
    def create_key(character, length)
      ascii_key = (hex2bin(character) * length)[0, length]
      bin2hex(ascii_key)
    end
    # Expects two hex strings
    def xor(data_1, data_2)
      raise "Error: Mismatched Lengths #{data_1.length} / #{data_2.length}" if data_1.length != data_2.length
      # Converts input into binary string
      d1 = hex2bin(data_1)
      d2 = hex2bin(data_2)

      # Merge into two arrays and perform XOR on each corresponding element
      # map returns the result in an array
      result = d1.bytes.zip(d2.bytes).map do |a, b|
        a ^ b
      end
      # Convert our array of integers back to a binary string
      bin2hex(result.pack("C*"))
    end
    
    def compute_single_xor(data)
      candidates = []
      # data is in hex so we divide by 2
      length = data.length / 2
      0.upto(255) do |k|
        key = create_key(k.to_s(16).rjust(2, '0'), length)
        plaintext = xor(data, key)
        # 
        #candidates << [key, plaintext] if english?(plaintext, multi)
        candidates << [key, plaintext]
      end
      # Return a list of key / plaintexts pairs
      candidates
    end
    
    def break_single_xor(data)
      finalists = []
      candidates = compute_single_xor(data)
      candidates.each do |c|
        finalists << c if score_ciphertext(c.last, "character", 0.40, 0.60) && score_ciphertext(c.last, "bigram", 0.075, 0.30)
      end
      finalists
    end
    
    def score_ciphertext(data, type, min, max)
      score = self.method("#{type}_score").call(data)
      
      # Naive check of english spaces
      # Without this check we get key matches on the inversion of alpha cases and spaces become null bytes or other weird bits
      return false if hex2bin(data).match(/\s+/).nil?
      
      # Return true if our score is within the thresholds
      return true if score.between?(min, max)
      
      false
    end
    
    def transpose_blocks(data, length)
      # Break up the ciphertext into an array of length value blocks
      # * 2 to account for hex string

      # Seperate our hex string in length * 2 segments
      blocks = data.chars.each_slice(length.to_i * 2).map(&:join)
      # Split each hex pair
      blocks = blocks.map { |v| v.chars.each_slice(2).map(&:join) }

      
      # Sanity check for transpose
      # Last element is shorter than others -- fill with nils
      if blocks.first.length != blocks.last.length
        blocks[-1] = Array.new(blocks.first.length) { |i| blocks.last }
      end
      
      # Transpose 
      # [FA, CE, 01], [DE, AD, FF] becomes [FA, DE], [CE, AD], [01, FF]
      blocks.transpose.map(&:join)
    end
    
    def compute_multi_xor(data, length)
      # Array for candidate plaintexts
      candidates = []

      blocks = transpose_blocks(data,length)
       
      blocks.each do |b|
        candidates << compute_single_xor(b)
      end  
      candidates
    end
    
    def break_multi_xor(data)
      # Analyze the ciphertext for hamming distance (find top n candidates)
      hamm_results = hamm_analyzer(data, 2, 7)
      
      hamm_results[0,2].each do |length|
        
        finalists = Array.new(length.to_i)
        
        candidates = compute_multi_xor(data, length)
        
        # Take first array
        candidates.each_with_index do |c, i|
          finalists[i] = c.map do |t| 
            # Check for non-printables
            next if hex2bin(t.last).bytes.map { |i| i.between?(0,31) || i.between?(128, 255) }.count(true) > 0
            # Check for excessive printable ranges
            printables = hex2bin(t.last).bytes.map { |i| i.between?(34,64) }.count(true) 
            next if ( printables.to_f / (t.last.length / 2)) > 0.40
            
            t if score_ciphertext(t.last, "character", 0.20, 0.90)
          end
        end
        
        # Check for possible matches
        keys = []
        finalists.each do |b|
        end
        # Build keys
        
        # Try Keys
        
        # Check ciphertext again
      end
    end    
  end
end