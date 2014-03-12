module Askalot
  module VERSION
    MAJOR = 1
    MINOR = 1
    PATCH = 2

    PRE = 'beta'

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
  end
end
