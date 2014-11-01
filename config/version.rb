module Askalot
  module VERSION
    MAJOR = 1
    MINOR = 7
    PATCH = 1

    PRE = 'alpha'

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join '.'
  end
end
