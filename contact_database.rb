## TODO: Implement CSV reading/writing
require 'csv'

class ContactDatabase
  @@contacts = []
  class << self
    def init 
      #binding.pry
      @@contacts = CSV.read('contacts.csv') if File.exists?('contacts.csv')
    end

    def add(name, email, numbers)
      #binding.pry
      if numbers == []
        @@contacts << CSV.parse(name + "," + email)[0]
      else
        num_str = numbers.join(",")
        binding.pry
        @@contacts << CSV.parse(name + "," + email + "," + num_str)[0]
      end
    end

    def write
      CSV.open('contacts.csv', 'w') do | dbfile |
        @@contacts.each do |row|
          dbfile << row
        end
      end
    end

    def contacts
      @@contacts
    end
  end
end