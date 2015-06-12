class Relation < Array
	def where(params)
    results = self.select do |relation|
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


