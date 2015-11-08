class Contact

  @@contact_count = 0
  @@contact_hash  = Hash.new(nil)
 
  attr_accessor :name, :email, :numbers, :id

  def initialize(name, email, numbers)
    # TODO: assign local variables to instance variables

    @name    = name
    @email   = email
    @numbers = []
    @numbers << numbers unless numbers == nil
    @id      = @@contact_count
    @@contact_count += 1
  end
 
  def to_s
    # TODO: return string representation of Contact
    string = "#{name}\t(#{email})"
    #binding.pry
    unless numbers == []
      numbers.each do |num|
        string << "\t" + num
      end
    end
    string

  end
 
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
    end

    def exists?(email)
      
      @@contact_hash.values.detect {|contact| email == contact.email}
      
    end
 
    def find(term)
      # matches = []
      # # TODO: Will find and return contacts that contain the term in the first name, last name or email
      # @@contact_hash.select do |key, contact|
      #    matches << contact if contact.to_s.include? term
      # end
      # matches
      @@contact_hash.values.select {|contact| contact.to_s.include? term}

    end
 
    def all
      @@contact_hash
    end
    
    def show(id)
      contact = @@contact_hash[id]
      #binding.pry
      # TODO: Show a contact, based on ID
    end

    def contact_count
      @@contact_count
    end
    
  end
 
end