module Cypher
  module Filters
    def english(data)
    end
    
    # Check for non-printables
    def non_printables(data)
      finalists = Array.new(data.length)
      
      data.each_with_index do |c, i|
        finalists[i] = data.map do |t|
          next if hex2bin(t.last).bytes.map { |i| i.between?(0,31) || i.between?(128, 255) }.count(true) > 0
          t
        end
      end
      
      finalists
    end
    
    def printables(data)
      #printables = hex2bin(t.last).bytes.map { |i| i.between?(34,64) }.count(true) 
      #puts "Printables: #{printables.to_f / (t.last.length / 2)}"
      #if ( printables.to_f / (t.last.length / 2)) > 0.40
      #  puts "Rejecting: #{t}"
      #  next
      #end
    end
    
    
  end
end