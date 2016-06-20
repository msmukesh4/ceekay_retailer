class Retailer < ActiveRecord::Base

	default_scope { where(is_active: true) }


	def self.search(dse_code,route,retailer_name,retailer_code)
	  if dse_code or route or retailer_name or retailer_code
	  	puts "dse = #{dse_code}, route = #{route} , retailer_name = #{retailer_name}, retailer_code = #{retailer_code}"
	    find(:all, :conditions => ['dse_code LIKE ? AND route_no LIKE ? AND retailer_name LIKE ? AND retailer_code LIKE ?', "%#{dse_code}%", "%#{route}%", "%#{retailer_name}%", "%#{retailer_code}%"])
	  else
	    find(:all)
	  end
	end
	
end
