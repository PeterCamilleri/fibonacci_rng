// 'C' language replacements for time critical methods of the fibonacci rng.

#include "fibonacci_rng.h"

#define BUFFER "i_b"

static ID  id_push;

// Free up the allocated buffer.
static void free_buffer(void *p)
{
  xfree(p);
}

// Perform initialization of the 'C' side of the generator
static VALUE initialize_c(VALUE self)
{
  int   depth;
  int   *pbuffer;

  depth = FIX2INT(rb_iv_get(self, "@depth")); // depth+2 == buffer.length
  pbuffer = ALLOC_N(int, depth+2);
  memset(pbuffer, 0, sizeof(int)*(depth+2));

  rb_iv_set(self, BUFFER, Data_Wrap_Struct(0, 0, free_buffer, pbuffer));

  return Qnil;
}

// Read the root value from the buffer
static VALUE get_root(VALUE self)
{
  int    *pbuffer;

  Data_Get_Struct(rb_iv_get(self, BUFFER), int, pbuffer);

  return INT2FIX(pbuffer[0]);
}

// Read a value from the buffer
static VALUE get_data(VALUE self, VALUE index)
{
  int    *pbuffer;
  int    idx;

  //Data_Get_Struct(rb_iv_get(self, BUFFER), int, pbuffer);
  pbuffer = (int *)DATA_PTR(rb_iv_get(self, BUFFER));
  idx = FIX2INT(index);

  return INT2FIX(pbuffer[idx]);
}

// Write a value to the buffer
static VALUE set_data(VALUE self, VALUE index, VALUE number)
{
  int    *pbuffer;
  int    idx;
  int    num;

  //Data_Get_Struct(rb_iv_get(self, BUFFER), int, pbuffer);
  pbuffer = (int *)DATA_PTR(rb_iv_get(self, BUFFER));
  idx = FIX2INT(index);
  num = FIX2INT(number);

  pbuffer[idx] = num & CHOP;

  return number;
}

// Add a value to the buffer
static VALUE add_data(VALUE self, VALUE index, VALUE number)
{
  int    *pbuffer;
  int    idx;
  int    num;

  //Data_Get_Struct(rb_iv_get(self, BUFFER), int, pbuffer);
  pbuffer = (int *)DATA_PTR(rb_iv_get(self, BUFFER));
  idx = FIX2INT(index);
  num = FIX2INT(number);

  pbuffer[idx] = (pbuffer[idx] + num) & CHOP;

  return number;
}


// Get the internal buffer array. For debugging.
static VALUE get_buffer(VALUE self)
{
  int    depth;
  int    *pbuffer;
  VALUE  result;
  int    idx;

  depth = FIX2INT(rb_iv_get(self, "@depth")); // depth+2 == buffer.length
  //Data_Get_Struct(rb_iv_get(self, BUFFER), int, pbuffer);
  pbuffer = (int *)DATA_PTR(rb_iv_get(self, BUFFER));

  result = rb_ary_new();

  for (idx = 0; idx < depth+2; idx++)
  {
    rb_funcall(result, id_push, 1, INT2FIX(pbuffer[idx]));
  }

  return result;
}

// The 'C' version of the inner spinner. From speed_up_one branch.
// This code is ported from the Ruby code originally in spinner.rb
static VALUE do_spin(VALUE self)
{
  int   depth;
  int   *pbuffer;

  int   p_one;
  int   p_two;
  int   idx;

  int   *reader;
  int   *writer;

  // Get some instance variables from Ruby to C.
  depth = FIX2INT(rb_iv_get(self, "@depth"));
  //Data_Get_Struct(rb_iv_get(self, BUFFER), int, pbuffer);
  pbuffer = (int *)DATA_PTR(rb_iv_get(self, BUFFER));

  // @buffer[-2] = @buffer[0]
  pbuffer[depth] = pbuffer[0];

  // @buffer[-1] = p_one = @buffer[1]
  pbuffer[depth+1] = p_one = pbuffer[1];

  writer = &pbuffer[0];
  reader = &pbuffer[2];

  // (0...@depth).each do |idx|
  for (idx = 0; idx < depth; idx++)
  {
    // p_two = @buffer[idx+2]
    p_two = *reader;
    reader++;

    // @buffer[idx] = (p_one + ((p_two >> 1) | (p_two.odd? ? TOP : 0))) & CHOP
    *writer = (p_one + ((p_two >> 1) | ((p_two & 1) ? TOP : 0))) & CHOP;
    writer++;

    // p_one = p_two
    p_one = p_two;
  }

  return Qnil;
}

// Generate a random byte value.
static VALUE get_byte(VALUE self)
{
  int    *pbuffer;

  Data_Get_Struct(rb_iv_get(self, BUFFER), int, pbuffer);
  do_spin(self);
  return INT2FIX(pbuffer[0] & 0xFF);
}

// The extension initialization routine.
void Init_fibonacci_rng(void)
{
  VALUE cFibonacciRng;

  // Get the required method ID values.
  id_push = rb_intern("push");

  // Connect these methods to the FibonacciRng class.
  cFibonacciRng = rb_const_get(rb_cObject, rb_intern("FibonacciRng"));
  rb_define_method(cFibonacciRng, "byte",         get_byte,     0);
  rb_define_method(cFibonacciRng, "do_spin",      do_spin,      0);
  rb_define_method(cFibonacciRng, "get_root",     get_root,     0);
  rb_define_method(cFibonacciRng, "get_data",     get_data,     1);
  rb_define_method(cFibonacciRng, "set_data",     set_data,     2);
  rb_define_method(cFibonacciRng, "add_data",     add_data,     2);
  rb_define_method(cFibonacciRng, "get_buffer",   get_buffer,   0);
  rb_define_method(cFibonacciRng, "initialize_c", initialize_c, 0);
}

