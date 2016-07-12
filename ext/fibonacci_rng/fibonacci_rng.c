// 'C' language replacements for time critical methods of the fibonacci rng.

#include "fibonacci_rng.h"

// The 'C' version of the inner spinner. From speed_up_one branch.
// This code is ported from the Ruby code originally in spinner.rb
static VALUE do_spin(VALUE self)
{
  VALUE buffer;
  int   depth;
  int   p_one;
  int   p_two;
  int   idx;

  VALUE temp;

  // Get some instance variables from Ruby to C.
  buffer = rb_iv_get(self, "@buffer");
  depth  = FIX2INT(rb_iv_get(self, "@depth"));
  // Note: depth + 2 == buffer.length

  // @buffer[-2] = @buffer[0]
  //rb_ary_store(buffer, -2, rb_ary_entry(buffer, 0));
  RARRAY_ASET(buffer, depth, RARRAY_AREF(buffer, 0));

  // @buffer[-1] = p_one = @buffer[1]
  //temp = rb_ary_entry(buffer, 1);
  temp = RARRAY_AREF(buffer, 1);
  p_one = FIX2INT(temp);
  //rb_ary_store(buffer, -1, temp);
  RARRAY_ASET(buffer, depth+1, temp);

  // (0...@depth).each do |idx|
  for (idx = 0; idx < depth; idx++)
  {
    // p_two = @buffer[idx+2]
    //p_two = FIX2INT(rb_ary_entry(buffer, idx+2));
    p_two = FIX2INT(RARRAY_AREF(buffer, idx+2));

    // @buffer[idx] = (p_one + ((p_two >> 1) | (p_two.odd? ? TOP : 0))) & CHOP
    //rb_ary_store(buffer,
    //             idx,
    //             INT2FIX((p_one + ((p_two >> 1) | ((p_two & 1) ? TOP : 0))) & CHOP)
    //            );
    RARRAY_ASET(buffer,
                idx,
                INT2FIX((p_one + ((p_two >> 1) | ((p_two & 1) ? TOP : 0))) & CHOP)
               );

    // p_one = p_two
    p_one = p_two;
  }

  return Qnil;
}

// The extension initialization routine.
void Init_fibonacci_rng(void)
{
  VALUE cFibonacciRng;

  cFibonacciRng = rb_const_get(rb_cObject, rb_intern("FibonacciRng"));
  rb_define_method(cFibonacciRng, "do_spin", do_spin, 0);
}

