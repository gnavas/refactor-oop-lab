class Student
  attr_reader :id, :squad_id
  attr_accessor :name, :age, :spirit_animal
  def initialize params, existing=false
    @id = params["id"]
    @squad_id = params["squad_id"]
    @name = params["name"]
    @age = params["age"]
    @spirit_animal = params["spirit_animal"]
    @existing = existing
  end
  def existing?
    @existing
  end
  def self.conn= connection
    @conn = connection
  end
  def self.conn
    @conn
  end
  # should return a list of students for a particular sqaud
  def self.all
    @conn.exec("SELECT * FROM students WHERE squad_id = $1", [squad_id])
  end
#should return a student by id; return nill if not found. 
  def self.find id, squad_id 
    new @conn.exec('SELECT * FROM students WHERE id = $1 AND squad_id = $2', [ id, squad_id ] )[0], true #what's the new?
  end
# I think I know what's going on till here

  def students
    Student.conn.exec("SELECT * FROM students WHERE squad_id = ($1)", [id])
  end

  def save
    if existing?
      Student.conn.exec('UPDATE students SET name=$1, age=$2, spirit_animal=$3 WHERE id = $4', [ name, age, spirit_animal, id ] )
    else
      Student.conn.exec('INSERT INTO students (name, age, spirit_animal, squad_id) values ($1,$2,$3,$4)', [ name, age, spirit_animal, squad_id ] )
    end
  end

  def self.create params
    new(params).save
  end

  def destroy
    Squad.conn.exec('DELETE FROM students WHERE id = ($1)', [ id ] )
  end

end
