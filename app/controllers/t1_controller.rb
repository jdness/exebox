class T1Controller < ApplicationController

  def index
    system("\"c:\\program files\\sandboxie\\start.exe\" /box:DefaultBox calc.exe")
    #system("calc.exe")
  end

end
