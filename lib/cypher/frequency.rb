module Cypher
  module Frequency    
    BIGRAMS = %w{th he in er an re nd at}
    CHARACTERS = %w{e t a o i n s h}
    
    
    CHARACTER_FREQUENCY = [0.130, 0.090, 0.081, 0.075, 0.069, 0.067, 0.063, 0.060, 0.059]
    BIGRAM_FREQUENCY = [0.152, 0.128, 0.094, 0.094, 0.082, 0.068, 0.063, 0.059]
    
    
    # Calculate the total possible for the top 8 english characters
    CHARACTER_FREQUENCY_TOTAL = CHARACTER_FREQUENCY.inject(:+)
    BIGRAM_FREQUENCY_TOTAL = BIGRAM_FREQUENCY.inject(:+)

    # Calculcate frequency of all characters (ignores case)
    def character_frequency(data)
        d = hex2bin(data)
        
        # Fetches a byte (as an Integer) and uses that as the reference to a hash count
        d.each_byte.inject(Hash.new(0)) do |h, b|
            # Change the Integer to binary string (downcase if its alpha)
            h[b.chr.downcase] += 1                    
            h
        end
    end
    
    # Generate score for
    def character_score(data)
      # Length of hexified string
      length = data.length / 2
      
      # Calculate the distribution of characters
      result = character_frequency(data)

      calculation = 0.0
      
      # Additive scoring
      # We add all the relative frequencies to see if they fall within the aggregate frequencies
      Cypher::Frequency::CHARACTERS.each_with_index do |char, i|            
        # Skip if our data doesn't include the listed character
        next if result[char.downcase] == 0
        
        # Calculate the relative percentage of occurance for each major character
        calculation += result[char.downcase] / length.to_f
      end
      
      return calculation         
    end

    # XXX - borken bad
    
    #def character_score(data)
    #  result = frequency(data)

    #  scores = result.sort_by {|_key, value| value}.reverse
      
    #  score = 0
    #  Cypher::Frequency::LETTERS.each_with_index do |letter, i|
    #    unless scores[i].nil?
    #      score += 1 if scores[i].first.downcase == Cypher::Frequency::LETTERS[i]
    #    end
    #  end
    #  score / Cypher::Frequency::LETTERS.length.to_f
    #end

    def bigram_frequency(data)
      bigrams = []
      
      # Convert to binary
      d = hex2bin(data).downcase

      # Generate bigrams
      # Split characters and collect in groups of 2
      d.split(//).each_with_index { |c, i| bigrams << d[i,2] }
      
      # Remove elements that have spaces
      bigrams.reject! { |h| /\s+/ =~ h }
      
      # Calculate bigram occurence
      result = bigrams.inject(Hash.new(0)) do |h, b|
        h[b] += 1
        h
      end
    end
    
    # Take a distribution of bigrams and analyze for english
    def bigram_score(data)
      result = bigram_frequency(data)
      # Reset the score
      score = 0.0

      # Check for bigrams in list
      Cypher::Frequency::BIGRAMS.each do |bigram|
        # Skip if our data doesn't include the listed character
        next if result[bigram] == 0
        
        # Calculate the relative percentage of occurance for each major character
        score += result[bigram] / result.values.inject(:+).to_f
      end
      score
    end
    
  end
end