# -*- encoding : utf-8 -*-
class FileService
  def init_file (file_name)
    @path = File.join(File.dirname(__FILE__),'/', file_name)
  end

  def get_from_file (line_text)
    init_file('external_data_file')
    @aFile = File.new("#{@path}", "r")
    
    File.readlines(@aFile).each do |line|
      if line.include? line_text
        @aFile.close
        return line.sub("#{line_text}","")
      end
    end
    return nil
    @aFile.close
  end

  def insert_to_file (line_text, new_value)
    init_file('external_data_file')
    aFile = File.new("#{@path}", "a+")
    
    if get_from_file(line_text) != nil
      File.write(aFile, File.read(aFile).gsub(/#{line_text}.*/, "#{line_text}#{new_value}"))
    else
      aFile << "#{line_text}#{new_value}\n"
    end
  end
end
