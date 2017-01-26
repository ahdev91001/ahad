module UtilRake
  require 'fileutils'

  # Case 1: Shouldn't ever occur
  #    Line 1  # :A    
  #    Line 2  # :B
  
  # Case 2: Change from B being activated to A being activated (BtoA)
  #    #Line 1  # :A
  #    Line 2  # :B 
  
  # Case 3: Change from A being activated to B being activated (AtoB)
  #    Line 1  # :A
  #    #Line 2  # :B
  
  # Case 4: Shouldn't occur
  #    #Line 1  # :A
  #    #Line 2  # :B
  def convert_schema_rb_from_mysql_to_sqlite(path_and_file)

    file_name = File.basename path_and_file
    path = File.dirname path_and_file

    FileUtils.cp path_and_file, File.join(path, file_name + ".bak")

    a_out = []
    text = File.read(path_and_file)
    text.each_line do |line|
      # Remove options, e.g.
      #  create_table "TESTnotesource", id: :integer, force: :cascade, 
      #    options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
      # Becomes...
      #  create_table "TESTnotesource", id: :integer, force: :cascade, 
      #    options: "" do |t|
      line.gsub!(/^(.*options: ").*(".*)$/,'\1\2')
      # Comment out all t.index calls
      #      t.index ["propid"], name: "propid", using: :btree
      # Becomes...
      #   #   t.index ["propid"], name: "propid", using: :btree
      line.gsub!(/^(\s*t\.index.*)$/,'#\1')
      a_out << line
    end
    
    File.open(path_and_file, "w") { |file| file.puts a_out }
  end
  
  def swap_active_groups_in_file(path_and_file, tag_to_deactivate, tag_to_activate)
    
    file_name = File.basename path_and_file
    path = File.dirname path_and_file

    FileUtils.cp path_and_file, File.join(path, file_name + ".bak")

    a_out = []
    text = File.read(path_and_file)
    if false
        puts "Text: " + text
        puts "Deactivating (commenting out) tag: " + tag_to_deactivate
        puts "Activating (uncommenting) tag: " + tag_to_activate
    end
    text.each_line do |line|
      # Deactivate (comment out)
      line.gsub!(/^([^#].*#\s*#{Regexp.quote(tag_to_deactivate)}\s*$)/,'#\1')
      # Activate (uncomment)
      line.gsub!(/^#([^#].*#\s*#{Regexp.quote(tag_to_activate)}\s*$)/,'\1') 
      a_out << line
    end
    
    File.open(path_and_file, "w") {|file| file.puts a_out }
    
  end
end
