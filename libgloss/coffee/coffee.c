
int
write ( int file,
        char *buf,
        int nbytes)
{
  return sysCall(0, file, (unsigned long)buf, nbytes);
}

int
read (int file,
      char *buf,
      int nbytes)
{
  return sysCall(0, file, (unsigned long)buf, nbytes);
}

int
outbyte (unsigned char c)
{
  return sysCall(0, 0, (unsigned long)&c, 1);
}

unsigned char
inbyte (void)
{
  char c;
  sysCall(0, 0, (unsigned long)&c, 1);
  return c;
}

int sysCall(unsigned long func, unsigned long p1, unsigned long p2, unsigned long p3)
{
  int ret = 0;
  asm volatile ( "scall");
  return ret;
}



