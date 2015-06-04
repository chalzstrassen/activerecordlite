require_relative "04_associatable2"
class Relation
	def initialize(arr)
		@relations = arr
	end

	attr_accessor :relations

	def [](num)
		relations[num]
	end

	def where2(params)
    results = self.relations.select do |relation|
    	is_match = false
      params.each do |key, val|
        if relation.attributes[key] == val
        	is_match = true
        else
  				is_match = false
        	break
        end
      end
      is_match
    end
    Relation.new(results)
  end
end


