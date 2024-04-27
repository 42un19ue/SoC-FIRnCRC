#include "system.h"
#include "sys/alt_stdio.h"

int main()
{
//  volatile long* c_ptr = (long*)CRC_0_BASE;
//  long c;
//  *(c_ptr) = 0x12345;
//  c = *(c_ptr + 1);
//  alt_putstr("Hello");
  int y = 0;
  int* c_ptr = (int*)CRC_0_BASE;

  *(c_ptr + 0) = 0x12345678;
  *(c_ptr + 1) = 0;
  *(c_ptr + 1) = 1;

  while(*(c_ptr + 2) != 1){
    };						//timing khi nao done = 1
  y = *(c_ptr + 1);
  printf("CRC result: %d \n",y);
  return 0;
}
