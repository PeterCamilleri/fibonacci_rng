# coding: utf-8

#A Chi Squared tester
class ChiSquaredTest

  #Run a chi squared test on the random number generator.
  def run(gen, bin_size, count)
    @max  = bin_size
    @bins = Array.new(bin_size, 0)

    start_time = Time.now
    puts "Starting test"

    count.times do
      @bins[gen.dice(@max)] += 1
    end

    puts "Test completed (#{Time.now - start_time} elapsed)"
    puts "Raw Bins = #{@bins.inspect}"

    normalized = @bins.collect {|value| value.to_f/count }

    #puts "Nrm Bins = #{normalized.inspect}"

    expected = 1/@max.to_f
    #puts "Expected = #{expected}"

    err_sqr = normalized.collect{|value| diff = expected - value; diff*diff}
    #puts "Esq Bins = #{err_sqr.inspect}"

    chi_sq = err_sqr.inject {|sum, value| sum + value}
    puts "Chi Squared = #{chi_sq}"
  end

end
