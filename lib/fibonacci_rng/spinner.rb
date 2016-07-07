# coding: utf-8

#The class of Fibonacci inspired random number generators.
class FibonacciRng

  #Cycle through the PRNG count times.
  def spin(count=1)
    count.times do
      do_spin
    end
  end

  private

  #Cycle through the PRNG once.
# def do_spin
#   @buffer[-2] = @buffer[0]
#   @buffer[-1] = @buffer[1]
#
#   (0...@depth).each do |idx|
#     tmp = @buffer[idx+2]
#     @buffer[idx] = (@buffer[idx+1] + ((tmp >> 1)|(tmp.odd? ? TOP : 0))) & CHOP
#   end
# end

  #Construct a special fast version of do_spin for this instance.
  def build_fast_spinner
    define_singleton_method(:do_spin, &FibonacciRng.build_spinner_proc(@depth))
  end

  #Build a custom spin procedure.
  def self.build_spinner_proc(depth)
    @proc_cache        ||= {}
    @proc_cache[depth] ||= do_build_spinner_proc(depth)
  end

  #Actually do build a custom spin procedure.
  def self.do_build_spinner_proc(depth)
    begin
      src = "lambda{t0=@buffer[0]; t1=p1=@buffer[1]; "

      (0...(depth-2)).each do |idx|
        src << "p2=@buffer[#{idx+2}]; " +
               "@buffer[#{idx}]=(p1+((p2>>1)|(p2.odd? ? TOP : 0)))&CHOP; " +
               "p1=p2; "
      end

      src << "@buffer[#{depth-2}]=(p1+((t0>>1)|(t0.odd? ? TOP : 0)))&CHOP; "
      src << "@buffer[#{depth-1}]=(t0+((t1>>1)|(t1.odd? ? TOP : 0)))&CHOP }"

      eval(src)
    end
  end

end