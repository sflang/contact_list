#require 'pg'

class Contact
 
  attr_accessor :firstname, :lastname, :email
  attr_reader :id

  def initialize(firstname, lastname, email, id = nil)
    # TODO: assign local variables to instance variables

    @firstname    = firstname
    @lastname     = lastname
    @email        = email
    @id           = id
  end

  def save
    if id
      # Updates a contact
      self.class.connection.exec_params('UPDATE contacts SET firstname = $1, lastname = $2, email = $3 WHERE id = $4;', [firstname, lastname, email, id])
    else
      # Creates a contact
      res = self.class.connection.exec_params('INSERT INTO contacts (firstname, lastname, email) VALUES ($1, $2, $3) RETURNING id;', [firstname, lastname, email])
      @id = res[0]['id']
    end
  end

  def destroy
    # Deletes a contact
    self.class.connection.exec_params('DELETE FROM contacts WHERE id = $1;', [id])
  end
 
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
 
  ## Class Methods
  class << self

    # def create(name, email, numbers)
    #   contact = Contact.new(name, email, numbers)
    #   ContactDatabase.add(contact.name, contact.email, contact.numbers)
    #   @@contact_hash[contact.id] = contact
    # end

    # def exists?(email)
      
    #   @@contact_hash.values.detect {|contact| email == contact.email}
      
    # end
 
    # def find(term)
    #   # matches = []
    #   # # TODO: Will find and return contacts that contain the term in the first name, last name or email
    #   # @@contact_hash.select do |key, contact|
    #   #    matches << contact if contact.to_s.include? term
    #   # end
    #   # matches
    #   @@contact_hash.values.select {|contact| contact.to_s.include? term}

    # end
 
    # def all
    #   @@contact_hash
    # end
    
    def find(id)
      res = connection.exec_params('SELECT * FROM contacts WHERE id = $1;', [id])
      if res.ntuples == 1
        Contact.new(res[0]['firstname'], res[0]['lastname'], res[0]['email'], res[0]['id'])
      end

    end

    def all
      res = connection.exec_params('SELECT * FROM contacts;')
      contact_array = []

      res.each do |hash|
        contact = Contact.new(hash['firstname'], hash['lastname'], hash['email'], hash['id'])
        contact_array << contact
      end
      contact_array
    end


    def connection
      @@conn ||= PG.connect(
                   host: 'localhost',
                   dbname: 'contacts_db',
                   user: 'development',
                   password: 'development'
                  )
    end

    def find_all_by_lastname(name)
      res = connection.exec_params('SELECT * FROM contacts WHERE lastname = $1;', [name])
      contact_array = []

      res.each do |hash|
        contact = Contact.new(hash['firstname'], hash['lastname'], hash['email'], hash['id'])
        contact_array << contact
      end
      contact_array
      
    end

    def find_all_by_firstname(name)
      res = connection.exec_params('SELECT * FROM contacts WHERE firstname = $1;', [name])
      contact_array = []

      res.each do |hash|
        contact = Contact.new(hash['firstname'], hash['lastname'], hash['email'], hash['id'])
        contact_array << contact
      end
      contact_array
      
    end

    def find_by_email(email)
      res = connection.exec_params('SELECT * FROM contacts WHERE email = $1;', [email])
      
      if res.ntuples == 1
        Contact.new(res[0]['firstname'], res[0]['lastname'], res[0]['email'], res[0]['id'])
      end     
    end

    
  end
 
end