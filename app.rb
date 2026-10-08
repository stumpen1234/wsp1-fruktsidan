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

    post '/fruits' do
      name = params['fruit_name']
      description = params['fruit_description']
      tastiness = params['fruit_tastiness']

      db.execute("INSERT INTO products (name, description,tastiness) VALUES (?, ?,?)", [name, description,tastiness])

      redirect('/fruits')
    end

end
