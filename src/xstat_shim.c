/* Real implementation of FOREIGN MODULE MySysLib's _xstat procedure.
 * Mocka's SysLib.Stat record is laid out to exactly match the raw i386
 * 'stat' syscall's kernel struct, so we can pass the buffer straight
 * through to the raw syscall instead of going through glibc's
 * versioned __xstat interface (whose symbol name/layout differ). */
#include <sys/syscall.h>
#include <unistd.h>

int _xstat(int ver, const char *path, void *buf) {
    return (int) syscall(SYS_stat, path, buf);
}
