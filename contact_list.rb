#!/usr/local/rvm/rubies/ruby-2.1.3/bin/ruby
require 'pry'
require 'pg'
require_relative 'contact'
require_relative 'exceptions'

# TODO: Implement command line interaction
# This should be the only file where you use puts and gets


def help
  puts "Here is a list of available commands:"
  puts " new           - Create a new contact"
  puts " remove 'id'   - Delete contact"
  puts " list          - List all contacts"
  puts " show 'id'     - Show a contact"
  puts " find 'name'   - Find a contact by first or last name"
end

def new
  puts "Email address?"
  email = STDIN.gets.chomp
  raise BadArgument, "Bad email address" unless email =~ /\S+@\S+\.\S+/
  
  puts "First Name?"
  firstname = STDIN.gets.chomp
  raise BadArgument, "Missing first name" if firstname.length == 0

  puts "Last Name?"
  lastname = STDIN.gets.chomp
  raise BadArgument, "Missing last name" if lastname.length == 0

  # numbers = []
  # puts "Phone (Home, Work, Mobile, etc...), press enter to skip"
  # type = STDIN.gets.chomp
  
  # while type.length > 0
  #   num_string = type + ":\t("

  #   puts "Phone Number? (ddd)ddd-dddd"
  #   number = STDIN.gets.chomp

  #   if parsed_fields = number.match(/\b(\d{3}).?(\d{3}).?(\d{4})/)
  #     num_string += parsed_fields[0] + ")"
  #     num_string += parsed_fields[1] + "-"
  #     num_string += parsed_fields[2]
  #   else
  #     raise BadArgument, "Bad phone number"
  #   end
  #   numbers << num_string

  #   puts "Phone (Home, Work, Mobile, etc...), press enter to skip"
  #   type = STDIN.gets.chomp
  # end
  
  #binding.pry
  unless Contact.find_by_email(email)
    contact = Contact.new(firstname, lastname, email)
    contact.save
  else
    puts("Duplicate email, try again")
  end

end

def list
  #binding.pry
  contacts = Contact.all
  contacts.each do |contact|
    puts("#{contact.id}\t#{contact.to_s}")
  end
  puts ("---")
  puts "#{contacts.length} records total"
end

def show
  raise BadArgument, "Missing command line argument" if ARGV.length < 2
  contact = Contact.find(ARGV[1].to_i)
  if contact == nil
    puts("Contact id not in database") 
  else
    puts("#{contact.to_s}")
  end
end

def remove
  raise BadArgument, "Missing command line argument" if ARGV.length < 2
  contact = Contact.find(ARGV[1].to_i)
  if contact == nil
    puts("Contact id not in database") 
  else
    contact.destroy
  end
end

def find
  raise BadArgument, "Missing command line argument" if ARGV.length < 2
  matches = Contact.find_all_by_firstname(ARGV[1])
  Contact.find_all_by_lastname(ARGV[1]).each do |contact|
    matches << contact
  end
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
  

  case ARGV[0]
  when 'new'    then new
  when 'list'   then list
  when 'show'   then show
  when 'find'   then find
  when 'help'   then help
  when 'remove' then remove
  else raise BadArgument, "Unrecognized command line argument"    
  end




rescue BadArgument => e
  puts "#{e.message}"
  puts "Type 'contact_list.rb help' for a list of valid commands"
end



