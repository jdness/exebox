class TerminatesandboxJob < Struct.new(:md5)

  def perform
    system("\"c:\\program files\\sandboxie\\start.exe\" /box:#{md5} /terminate")
  end

end
