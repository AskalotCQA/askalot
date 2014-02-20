class String
  alias :utf8 :mb_chars

  def ascii
    return self if self.ascii_only?

    self.utf8.normalize(:kd).bytes.map { |b| (0x00..0x7F).include?(b) ? b.chr : '' }.join
  end

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
