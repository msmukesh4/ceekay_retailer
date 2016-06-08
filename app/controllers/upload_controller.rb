require 'rubyXL'
class UploadController < ApplicationController

	def self.export_xls_to_db
		workbook = RubyXL::Parser.parse("/home/mukesh/Desktop/ck_retailers.xlsx")
		worksheet = workbook[0]
		worksheet.each { |row|
		   row && row.cells.each { |cell|
		     val = cell && cell.value
		     puts "val : #{val.to_s}"
		   }
		}

	end
end
