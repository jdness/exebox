require 'digest'
require 'tmpdir'
require 'fileutils'

class UploadController < ApplicationController
 def index
    if request.post?
      if  params[:token] && params[:binary] && params[:filetype] && params[:md5]

	realbinary = params[:binary].lines.to_a.pack('H*')

        @sample = Sample.new
        @sample.filetype = params[:filetype]
        @sample.token = params[:token]
        @sample.md5 = Digest::MD5.hexdigest(realbinary);
        @sample.sha1 = Digest::SHA1.hexdigest(realbinary);
        @sample.status = 1; # new submission
        
        if (@sample.md5 == params[:md5])
	  # No need to actually save binary to database, never used (always use tempfile)
          #@sample.binary = realbinary
          @sample.save    

          tempfilename = File.join(Dir.tmpdir, @sample.md5 + "." + @sample.filetype)
      	  tempfile = File.open(tempfilename,'wb')
      	  tempfile.print realbinary
      	  tempfile.close        
                
          Delayed::Job.enqueue(SandboxJob.new(@sample.md5,tempfilename))

          @sample.status = 2; # sandboxie launched
          @sample.save    
        
          # Each of these jobs can fail independently with no consequence
          #  Delayed_job will attempt to re-run any failed jobs
          #  Segmented like this so that re-rerunning the failed jobs will cause as little impact as possible
          #  (i.e. if sandbox /terminate fails, it won't attempt to re-post the results to heroku site)
          Delayed::Job.enqueue(TerminatesandboxJob.new(@sample.md5), 2, 60.seconds.from_now)
        
          Delayed::Job.enqueue(PostresultsJob.new(@sample.md5), 2, 70.seconds.from_now)
        
          Delayed::Job.enqueue(CleanupJob.new(@sample.md5,tempfilename), 2, 90.seconds.from_now)
        else
          render :file => "public/400.html", :status => :bad_request   
        end   
      end
    end
  end
end


