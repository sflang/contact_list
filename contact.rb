#require 'pg'

class Contact < ActiveRecord::Base
 
  def to_s
    # TODO: return string representation of Contact
    string = "#{firstname} #{lastname}\t(#{email})"
    #binding.pry
    # unless numbers == []
    #   numbers.each do |num|
    #     string << "\t" + num
    #   end
    # end
    #string

  end
 
end