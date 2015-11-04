#!/usr/local/rvm/rubies/ruby-2.1.3/bin/ruby
require 'pry'
require_relative 'contact'
require_relative 'contact_database'
require_relative 'application'
require_relative 'exceptions'

# TODO: Implement command line interaction
# This should be the only file where you use puts and gets

# class BadArgument < StandardError
# end

def help
  puts "Here is a list of available commands:"
  puts " new           - Create a new contact"
  puts " list          - List all contacts"
  puts " show 'id'     - Show a contact"
  puts " find 'string' - Find a contact"
end

def new
  puts "Email address?"
  email = STDIN.gets.chomp
  raise BadArgument, "Missing email address" if email.length == 0
  puts "Name?"
  name = STDIN.gets.chomp

  numbers = []
  puts "Phone?"
  number = STDIN.gets.chomp
  
  while number.length > 0
    numbers << number
    puts "Phone?"
    number = STDIN.gets.chomp
  end


  raise BadArgument, "Missing name" if name.length == 0
  raise BadArgument, "Need first and last name" if name.split.length != 2
  
  #binding.pry
  unless Application.exists?(email)
    Application.create(name, email, numbers)
  else
    puts("Duplicate email, try again")
  end

end

def list
  #binding.pry
  Application.all.each do |key, contact|
    puts("#{contact.id}\t#{contact.to_s}")
  end
  puts ("---")
  puts "#{Contact.contact_count} records total"
end

def show
  raise BadArgument, "Missing command line argument" if ARGV.length < 2
  contact = Application.show(ARGV[1].to_i)
  if contact == nil
    puts("Contact id not in database") 
  else
    puts("#{contact.to_s}")
  end
end

def find
  raise BadArgument, "Missing command line argument" if ARGV.length < 2
  matches = Application.find(ARGV[1])
  #binding.pry

  if matches.empty?
    puts("No match") 
  else
    matches.each do |contact|
      puts("#{contact.id}\t#{contact.to_s}")
    end
  end
end
 


   

begin

  raise BadArgument, "Missing command line argument" if ARGV.length == 0
  
  Application.open
  #binding.pry

  case ARGV[0]
  when 'new' then new
  when 'list' then list
  when 'show' then show
  when 'find' then find
  when 'help' then help
  else raise BadArgument, "Unrecognized command line argument"    
  end

  #binding.pry
  Application.close




rescue BadArgument => e
  puts "#{e.message}"
  puts "Type 'contact_list.rb help' for a list of valid commands"
end



