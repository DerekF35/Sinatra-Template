class Hash
  def with_str_keys
    tmp = {}
    self.each do |k,v|
      tmp[k.to_str] = v
    end
    return tmp
 end

 def with_upper_keys
   tmp = {}
   self.each do  |k,v|
     tmp[k.to_str.upcase] = v
   end
   return tmp
 end

 def with_lower_keys
   tmp = {}
   self.each do  |k,v|
     tmp[k.to_str.downcase] = v
   end
   return tmp
 end

  def with_sym_keys
    tmp = {}
    self.each do  |k,v|
      tmp[k.to_str.to_sym] = v
    end
    return tmp
  end

   def removeAllKeys!(keys)
     keys = [keys] if !keys.is_a?(Array)
      keys.each do |key|
        self.delete(key)
        self.delete(key.to_sym)
        self.delete(key.to_s)
        self.delete(key.to_s.upcase)
        self.delete(key.to_s.downcase)
        self.delete(key.to_s.upcase.to_sym)
        self.delete(key.to_s.downcase.to_sym)
      end
  end
end
