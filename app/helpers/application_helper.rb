module ApplicationHelper
    
  def return_value_of_symbol(obj,sym)
    # And here is the magic, we need to call the object method of fields_for
    # to obtain the reference of the object we are building for, then call the
    # send function so we send a message with the actual value of the symbol 
    # and so we return that message to our view.  
    obj.object.send(sym)
  end
    
end
