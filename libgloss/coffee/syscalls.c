/* Support files for GNU libc.  Files in the system namespace go here.
   Files in the C namespace (ie those that do not start with an
   underscore) go in .c.  */

#include <_ansi.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/fcntl.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <sys/times.h>
#include <errno.h>
#include <reent.h>
#include <unistd.h>
#include <sys/wait.h>
#include <syscall.h>
/* Forward prototypes.  */
int     _system     _PARAMS ((const char *));
int     _rename     _PARAMS ((const char *, const char *));
int     _isatty		_PARAMS ((int));
clock_t _times		_PARAMS ((struct tms *));
int     _gettimeofday	_PARAMS ((struct timeval *, void *));
int     _unlink		_PARAMS ((const char *));
int     _link 		_PARAMS ((void));
int     _stat 		_PARAMS ((const char *, struct stat *));
int     _fstat 		_PARAMS ((int, struct stat *));
int	_swistat	_PARAMS ((int fd, struct stat * st));
caddr_t _sbrk		_PARAMS ((int));
int     _getpid		_PARAMS ((int));
int     _close		_PARAMS ((int));
clock_t _clock		_PARAMS ((void));
int     _open		_PARAMS ((const char *, int, ...));
int     _write 		_PARAMS ((int, char *, int));
int     _lseek		_PARAMS ((int, int, int));
int     _read		_PARAMS ((int, char *, int));
int     _kill           _PARAMS ((int, int));
void    _exit           _PARAMS ((int));


// Use "naked" attribute to suppress C prologue/epilogue
static int __attribute__ ((naked)) __syscall(int func_no, ...)
{ 
    int res;
    asm volatile ("mov   r12, lr\n");
    asm volatile ("mov   r21, %0"
	: /*no output*/
	: "r"(func_no)
        );
    asm volatile ("scall\n");
    asm volatile ("nop\n");
    asm volatile ("mov %0, r25\n"
	: "=r"(res)
	);
    asm volatile ("mov   lr, r12\n");
}

/* fd, is a valid user file handle. 
   Translates the return of _swiread into
   bytes read. */
int
_read (int fd,
       char * ptr,
       int len)
{
return __syscall(SYS_read, fd, ptr, len);
}

int
_lseek (int fd,
	int ptr,
	int dir)
{
  return __syscall(SYS_lseek,fd, ptr, dir);
}

int
_write (int    fd,
	char * ptr,
	int    len)
{
  return __syscall(SYS_write, fd, ptr, len);
}

int
_open (const char * path, int flags, ...)
{
  return  __syscall(SYS_open, path, flags);
}

int
_close (int fd)
{
return __syscall(SYS_close, fd);
}

int
_getpid (int n)
{
  return __syscall(SYS_getpid, n);
}


caddr_t 
_sbrk(int n) 
{
int t = n;
}



int __attribute__((weak))
_fstat (int fd, struct stat * st)
{
return -1;
}

int __attribute__((weak))
_stat (const char *fname, struct stat *st)
{
return -1;
}

int __attribute__((weak))
_link (void)
{
  return -1;
}

int
_unlink (const char *path)
{
return -1;
}

int
_gettimeofday (struct timeval * tp, void * tzvp)
{
return -1;
}

/* Return a clock that ticks at 100Hz.  */
clock_t 
_clock (void)
{
return -1;
}

/* Return a clock that ticks at 100Hz.  */
clock_t
_times (struct tms * tp)
{
return -1;
}


int
_isatty (int fd)
{
return -1;
}

int
_system (const char *s)
{
return -1;
}

int
_rename (const char * oldpath, const char * newpath)
{
return -1;
}



void
_exit (int status)
{
  /* There is only one SWI for both _exit and _kill. For _exit, call
     the SWI with the second argument set to -1, an invalid value for
     signum, so that the SWI handler can distinguish the two calls.
     Note: The RDI implementation of _kill throws away both its
     arguments.  */
  _kill (status, -1);
}


int
_kill (int pid, int sig)
{
return -1;
}




