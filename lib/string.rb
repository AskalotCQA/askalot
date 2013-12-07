class String
  def downcase_first
    self.dup.downcase_first!
  end

  def downcase_first!
    self.sub!(/^\D{0,1}/) { |c| c.downcase }
  end

  def upcase_first
    self.dup.upcase_first!
  end

  def upcase_first!
    self.sub!(/^\D{0,1}/) { |c| c.upcase }
  end
end
