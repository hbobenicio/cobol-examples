#ifndef FFI_POSIX_H
#define FFI_POSIX_H

#include <stdint.h>
#include <stddef.h>

int ffi_posix_errno();
const char* ffi_posix_strerror(int error_code);

int ffi_posix_af_inet();
int ffi_posix_sock_stream();
int ffi_posix_connect(int sock, const char* host, size_t host_len, uint16_t port);
int ffi_posix_send(int fd, const char* buf, size_t buf_len);

#endif
