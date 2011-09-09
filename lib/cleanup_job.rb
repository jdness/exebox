require 'sample'
require 'fileutils'

class CleanupJob < Struct.new(:md5, :tempfilename)

  def perform
                
    
    # Now delete the whole shootin match
    system("\"c:\\program files\\sandboxie\\start.exe\" /box:#{md5} delete_sandbox_silent")
    
    # if no work currently in progress, copy over a clean sandboxie.ini
    if (!Sample.exists?(['status < ?','3']))      
      system("copy /Y C:\\sandboxie.ini C:\\windows\\sandboxie.ini")
    end
    
    Sample.delete_all(:md5 => md5)

    # Delete the sample written out to disk
    #FileUtils.rm(tempfilename)
        
    if File.exist?(tempfilename)
      File.delete(tempfilename)
    end
    
  end
 
end