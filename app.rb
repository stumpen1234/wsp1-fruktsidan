require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader
  
    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    #TODO: Skriv routen hämtar alla frukter i databasen
    get '/fruits' do
      @fruits = db.execute('SELECT * FROM products')
      ap @fruits
      erb(:"fruits/index")
    end
  
    get '/fruits/new' do
      erb(:"fruits/new")
    end
    
    get '/fruits/:id' do | id |
      @fruit = db.execute('SELECT * FROM products WHERE id=?',id).first
      ap @fruit
      erb(:"fruits/show")
    end     
    post '/fruits/:id/delete' do | id |
      db.execute("DELETE FROM products WHERE id =?", id)
      redirect("/fruits")
    end
    get '/fruits/:id/edit' do | id |
      ap id

      #1. Hämta info om frukten med id från DB
      @fruit = db.execute('SELECT * FROM products WHERE id=?',id).first
      erb(:"fruits/edit")

      #2. Visa info i edit.erb
    end
    

    post '/fruits' do
      name = params['fruit_name']
      description = params['fruit_description']
      tastiness = params['fruit_tastiness']

      db.execute("INSERT INTO products (name, description,tastiness) VALUES (?, ?,?)", [name, description,tastiness])

      redirect('/fruits')
    end
    post "/fruits/:id/update" do | id |
      fruit_name = params["fruit_name"]
      fruit_category = params["fruit_description"]
      fruit_tastiness = params["fruit_tastiness"]
     
      db.execute("UPDATE products 
       SET name =?, description=?, tastiness=? WHERE id =?", [fruit_name, fruit_category,fruit_tastiness, id])
     
      redirect("/fruits")
     end
     
     

end
