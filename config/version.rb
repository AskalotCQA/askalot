module Askalot
  module VERSION
    MAJOR = 1
    MINOR = 8
    PATCH = 3

    PRE = 'beta'

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
  end
end
