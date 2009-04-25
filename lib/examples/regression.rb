class SSY
  include TeguGears
  def process(*y)
    y_mean = Mean.call(*y)
    y.inject{|s,e| s + (e - y_mean)**2}
  end
end

class SSX < SSY; end

class SSXY
  include TeguGears
  def process(x, y)
    raise ArgumentError, "x and y need to be the same size" unless x.size == y.size
    x_mean = Mean.call(*x)
    y_mean = Mean.call(*y)
    (0...x.size).inject(0.0) {|s,i| s + (y[i] - y_mean) * (x[i] - x_mean) }
  end
end

class Mean
  include TeguGears
  def process(*x)
    x.inject{|s,e| s + e} / x.size.to_f
  end
end

class MaximumLikelihoodSlope
  include TeguGears
  def process(x, y)
    raise ArgumentError, "x and y need to be the same size" unless x.size == y.size
    b = SSXY.call(x, y) / SSX.call(x)
  end
end

class MaximumLikelihoodIntercept
  include TeguGears
  def process(x,y)
    raise ArgumentError, "x and y need to be the same size" unless x.size == y.size
    Mean.call(*y) - MaximumLikelihoodSlope.call(x,y) * Mean.call(*x)
  end
end

class SSE
  include TeguGears
  def process(x,y)
    raise ArgumentError, "x and y need to be the same size" unless x.size == y.size
    (0...x.size).inject(0.0) do |s, i|
      s + (y[i] - MaximumLikelihoodIntercept.call(x,y) - MaximumLikelihoodSlope.call(x,y) * x[i] ) ** 2
    end
  end
end

class RSquared
  include TeguGears
  def process(x,y)
    (SSY.call(*y) - SSE.call(x,y)) / SSY.call(*y)
  end
end
