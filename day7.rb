class Directory
  attr_accessor :name, :parent

  def initialize(name, parent = nil)
    @contents = []
    @name = name
    @parent = parent
    @size = 0
    @changed = true
  end

  def <<(el)
    @changed = true
    @contents << el
  end

  def size
    if @changed
      @size = @contents.map { |e| e.size }.sum
    end

    @size
  end

  def child_by_name(name)
    @contents.find { |child| child.name == name }
  end
end

DirFile = Struct.new(:name, :size)

class FileSystem
  MAX_SIZE = 70_000_000

  attr_accessor :file_system, :directories
  def initialize
    @file_system = Directory.new("/")
    @current_dir = @file_system
    @directories = [@file_system]
  end
  
  def cd(rel_path)
    if rel_path == "/"
      @current_dir = @file_system
    elsif rel_path == ".."
      @current_dir = @current_dir.parent ? @current_dir.parent : @file_system
    else
      @current_dir = @current_dir.child_by_name(rel_path)
    end
  end

  def unused_space
    MAX_SIZE - @file_system.size
  end

  def mkdir(name)
    dir = Directory.new(name, @current_dir)
    @current_dir << dir
    @directories << dir
  end

  def new_file(name, size)
    @current_dir << DirFile.new(name, size)
  end
end

def populate_filesystem(fs, lines)
  lines.each do |line|

    next if line.start_with? "$ ls" # nothing to see here

    if line.start_with? "$ cd"
      _, _, op = line.split (" ")
      fs.cd op
      next
    end

    part_a, part_b = line.split(" ")

    if part_a == "dir"
      fs.mkdir(part_b)
    else
      # part_a is file size
      fs.new_file(part_b, part_a.to_i)
    end
  end
end

def part_1(fs)
  fs.directories.select { |d| d.size <= 100_000 }.map { |d| d.size }.sum
end

def part_2(fs)
  diff = 30_000_000 - fs.unused_space
  fs.directories.map { |d| d.size }.sort.find { |s| s > diff}
end

if $PROGRAM_NAME == __FILE__
  dir = Directory.new("test")

  10.times do
    dir << DirFile.new("foo", 10)
  end

  puts "Directory Size test pass: #{dir.size == 100}"

  # Part 1
  TEST_INPUT = File.readlines("./content/day7_test_content.txt")
  test_fs = FileSystem.new
  populate_filesystem(test_fs, TEST_INPUT)

  puts "Part 1 test delatable size == 95437: #{part_1(test_fs) == 95437}"
  puts "Part 2 test smallest deltable file size == 24933642: #{part_2(test_fs) == 24933642}"
  
  INPUT = File.readlines("./content/day7_content.txt")
  fs = FileSystem.new
  populate_filesystem(fs, INPUT)

  # Part 1 solution
  puts part_1(fs)
  puts part_2(fs)
end