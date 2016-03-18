module Shared::Ratain
  module Base
    # Lower bound of Wilson score confidence interval for a Bernoulli parameter
    # See http://www.evanmiller.org/how-not-to-sort-by-average-rating.html
    def lb_wsci_bp(positive, total, confidence = 0.95)
      return 0 if total.zero?

      n = total
      z = Statistics2.pnormaldist(1 - (1 - confidence) / 2)
      p = 1.0 * positive / n

      (p + z * z / (2 * n) - z * Math.sqrt((p * (1 - p) + z * z / (4 * n)) / n)) / (1 + z * z / n)
    end
  end
end
