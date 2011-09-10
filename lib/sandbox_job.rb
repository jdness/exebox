require 'tmpdir'

class SandboxJob < Struct.new(:md5,:tempfilename)
  
  def perform
        
    # First check if sandbox already exists
    #  Build up a UTF-16 looking string and check whether it exists
    checkstring = "\000["
    md5.each_char do |c|
      checkstring = checkstring + "\000" + c
    end
    
    inifile = File.open("c:\\windows\\sandboxie.ini")
    inistring = inifile.read
    inifile.close
    
    if (inistring.index(checkstring) == nil)
    #if 1 == 1    
      # Sandbox does not exist so create it
      inifile = File.open("c:\\windows\\sandboxie.ini","a:UTF-16LE")
      inifile.puts " ".encode("UTF-16LE")
      inifile.puts "[#{md5}]".encode("UTF-16LE")
      inifile.puts " ".encode("UTF-16LE")
      inifile.puts "ConfigLevel=6".encode("UTF-16LE")
      inifile.puts "AutoRecover=y".encode("UTF-16LE")
      inifile.puts "Template=LingerPrograms".encode("UTF-16LE")
      inifile.puts "Template=Firefox_Phishing_DirectAccess".encode("UTF-16LE")
      inifile.puts "Template=AutoRecoverIgnore".encode("UTF-16LE")
      inifile.puts "RecoverFolder=%Personal%".encode("UTF-16LE")
      inifile.puts "RecoverFolder=%Favorites%".encode("UTF-16LE")
      inifile.puts "RecoverFolder=%Desktop%".encode("UTF-16LE")
      inifile.puts "Enabled=y".encode("UTF-16LE")
      inifile.puts "ForceProcess=werfault.exe".encode("UTF-16LE")
      inifile.puts "InjectDll=c:\\InjDll.dll".encode("UTF-16LE")
      inifile.close  
      system("\"c:\\program files\\sandboxie\\start.exe\" /reload")
    
    end
        
    # Get the CWD so we can initiate the process from there
    #elements = tempfilename.split('/')
    #elements.pop
    #cwd = elements.join('\\')
        
    #system("\"c:\\program files\\sandboxie\\start.exe\" /silent /box:#{md5} cmd /c \"cd #{cwd}&&#{tempfilename}\"")

    Dir.chdir(Dir.tmpdir)
    system("\"c:\\program files\\sandboxie\\start.exe\" /silent /box:#{md5} #{tempfilename}")
    
  end
  
end