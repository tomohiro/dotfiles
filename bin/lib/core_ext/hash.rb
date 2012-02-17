# encoding: utf-8

class Hash
  def method_missing key
    return self[key.to_s] if self.key? key.to_s
    super
  end
end
