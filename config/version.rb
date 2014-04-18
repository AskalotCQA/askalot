module Askalot
  module VERSION
    MAJOR = 1
    MINOR = 3
    PATCH = 4

    PRE = 'beta'

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
  end
end
