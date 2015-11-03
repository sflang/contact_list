class Application
  
  @@contact_hash = Hash.new(nil)
 
  ## Class Methods
  class << self
    def open
      ContactDatabase.init
      ContactDatabase.contacts.each do |contact_str|
        #binding.pry
        numbers = ""
        contact_str[2...contact_str.length].each {|num| numbers << "\t" + num.to_s}

        contact = Contact.new(contact_str[0], contact_str[1], numbers)
        @@contact_hash[contact.id] = contact
      end
    end

    def close
      ContactDatabase.write
    end

    def contact_hash
      @@contact_hash
    end

    def create(name, email, numbers)
      contact = Contact.new(name, email, numbers)
      ContactDatabase.add(contact.name, contact.email, contact.numbers)
      @@contact_hash[contact.id] = contact
      #binding.pry
      # TODO: Will initialize a conta

    end

    def exists?(email)
      exist = false
      
      @@contact_hash.values.each do |contact|
        exist = true if email == contact.email
        #binding.pry
      end
      exist
      
    end

 
    def find(term)
      matches = []
      # TODO: Will find and return contacts that contain the term in the first name, last name or email
      @@contact_hash.select do |key, contact|
         matches << contact if contact.to_s.include? term
      end
      matches
    end
 
    def all
      @@contact_hash
    end
    
    def show(id)
      contact = @@contact_hash[id]
      #binding.pry
      # TODO: Show a contact, based on ID
    end
    
  end
 
end