
#include "linux-syscall.h"

SYS_BASE = 0
SYS_alarm = SYS_BASE+ 27



.global _alarm
_alarm:
 mov r12, lr; 
 lli r21, SYS_alarm;
 scall; 
 mov lr, r12; 
 jmpr lr; 
 nop;




