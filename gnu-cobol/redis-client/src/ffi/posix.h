#ifndef FFI_POSIX_H
#define FFI_POSIX_H

#include <stdint.h>
#include <stdio.h>

int ffi_posix_errno();
const char* ffi_posix_strerror(int error_code);

int ffi_posix_af_inet();
int ffi_posix_sock_stream();

int ffi_posix_connect(int sockfd, const char* host, size_t host_len, uint16_t port);
ssize_t ffi_posix_send(int sockfd, const char* buf, size_t buf_len);
ssize_t ffi_posix_recv(int sockfd, char *buf, size_t buf_len);

#endif
