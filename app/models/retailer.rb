class Retailer < ActiveRecord::Base

	default_scope { where(is_active: true) }

  	PER_PAGE = 2000

	def self.search(dse_code,route,retailer_name,retailer_code)
	  if dse_code or route or retailer_name or retailer_code
	  	puts "dse = #{dse_code}, route = #{route} , retailer_name = #{retailer_name}, retailer_code = #{retailer_code}"
	    find(:all, :conditions => ['dse_code ILIKE ? AND route_no ILIKE ? AND retailer_name ILIKE ? AND retailer_code ILIKE ?', "%#{dse_code}%", "%#{route}%", "%#{retailer_name}%", "%#{retailer_code}%"])
	  else
	    find(:all)
	  end
	end
	
end
