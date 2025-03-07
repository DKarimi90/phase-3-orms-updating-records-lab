require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id 


  def initialize( name, grade, id = nil)
    @id=id
    @name=name
    @grade=grade 

  end

  def self.create_table 
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table 
    sql = <<-SQL
    DROP TABLE IF EXISTS students 
    SQL
    
    DB[:conn].execute(sql)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save 
    if self.id
      self.update
    else
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end 
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student

  end

  def self.new_from_db(row)
    self.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    LIMIT 1
    SQL
  

    result = DB[:conn].execute(sql, name)[0]
    Student.new(result[1], result[2], result[0])
   

  end



end 