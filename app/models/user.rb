class User < ActiveRecord::Base

	default_scope { where(is_active: true) }

end
