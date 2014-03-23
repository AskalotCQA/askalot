module Askalot
  module VERSION
    MAJOR = 1
    MINOR = 2
    PATCH = 0

    PRE = 'alpha'

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
  end
end
