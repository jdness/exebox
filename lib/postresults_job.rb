require 'sample'
require 'httpclient'
require 'zipruby'

class PostresultsJob < Struct.new(:md5)

  def perform
        
    @sample = nil

    if (Sample.exists?(:md5 => md5))
      @sample = Sample.find_by_md5(md5)  
	    @sample.status = 3;  # sample finished running
	    @sample.save
    else
      return
    end
        
    if (File.exists?("C:\\sandbox\\webworker\\#{md5}\\drive\\C\\jness\\db\\process.db")) 
      clnt = HTTPClient.new
      File.open("C:\\sandbox\\webworker\\#{md5}\\drive\\C\\jness\\db\\process.db") do |file|
        body = { 'md5' => md5, 'resultdb' => file, 'token' => @sample.token, 'vm_id' => 1 }
        res = clnt.post('http://evening-window-75.heroku.com/results', body)
      end
    else  
      # Sample failed to process..  need to warn mothership so it can re-submit
      clnt = HTTPClient.new
      body = { 'md5' => md5, 'failed' => 1, 'token' => @sample.token, 'vm_id' => 1 }
      res = clnt.post('http://evening-window-75.heroku.com/results', body)
      return
    end    
    
    if (File.exists?("C:\\sandbox\\webworker\\#{md5}.zip")) 
      File.delete("C:\\sandbox\\webworker\\#{md5}.zip")
    end
    
    if (File.directory?("C:\\sandbox\\webworker\\#{md5}"))
      
      Zip::Archive.open("C:/sandbox/webworker/#{md5}.zip", Zip::CREATE) do |ar|

        Dir.glob("C:/sandbox/webworker/#{md5}/**/*").each do |path|
          if File.directory?(path)
            ar.add_dir(path)
          else
            if (path == path.gsub(/[\x00-\x1f\x3c-\x3f\x7f-\xff]/,''))
              ar.add_file(path,path)
            end
            #ar.add_file(path.gsub(/[\x80-\xff]/,'?'), path) # add_file(<entry name>, <source path>)
          end
        end
      end
            
      clnt = HTTPClient.new
      File.open("C:\\sandbox\\webworker\\#{md5}.zip") do |file|
        body = { 'md5' => md5, 'drivediff' => file, 'token' => @sample.token, 'vm_id' => 1 }
#        res = clnt.post('http://192.168.56.1:3000/results', body)
        res = clnt.post('http://evening-window-75.heroku.com/results', body)
      end
      
      File.delete("C:\\sandbox\\webworker\\#{md5}.zip")
      
    end

  end
end
