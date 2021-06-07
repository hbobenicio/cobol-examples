#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>

#include <unistd.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>

static char* new_str_from_buf(const char* buf, size_t buf_len);

int ffi_posix_errno() {
    return errno;
}

const char* ffi_posix_strerror(int error_code) {
    return strerror(error_code);
}

int ffi_posix_af_inet() {
    return AF_INET;
}

int ffi_posix_sock_stream() {
    return SOCK_STREAM;
}

int ffi_posix_connect(int sockfd, const char* host, size_t host_len, uint16_t port) {
    char* const null_terminated_host = new_str_from_buf(host, host_len);

#ifdef DEBUG
    fprintf(stderr, "[DEBUG] ffi: socket(%d, \"%s\", %hu)\n", sockfd, null_terminated_host, port);
#endif

    struct sockaddr_in addr = {0};
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(null_terminated_host);
    
    int rc = connect(sockfd, (struct sockaddr*)&addr, sizeof(addr));
    if (rc == -1) {
        int error_code = errno;
        const char* error_msg = strerror(error_code);
        fprintf(stderr, "[ERROR] ffi: connect: [%d] %s\n", error_code, error_msg);
    }

    free(null_terminated_host);
    return rc;
}

ssize_t ffi_posix_send(int sockfd, const char* buf, size_t buf_len) {
#ifdef DEBUG
    fprintf(stderr, "[DEBUG] ffi: send(%d,", sockfd);
    for (size_t i = 0; i < buf_len; i++) {
        fprintf(stderr, " %02X", buf[i]);
    }
    fprintf(stderr, ", %zu, 0)\n", buf_len);
#endif

    ssize_t rc = send(sockfd, buf, buf_len, 0);
    if (rc == -1) {
        int error_code = errno;
        const char* error_msg = strerror(error_code);
        fprintf(stderr, "[ERROR] ffi: send: [%d] %s\n", error_code, error_msg);
    }

    return rc;
}

ssize_t ffi_posix_recv(int sockfd, char *buf, size_t buf_len) {
#ifdef DEBUG
    fprintf(stderr, "[DEBUG] ffi: recv(%d, out buf, %zu, 0)\n", sockfd, buf_len);
#endif

    ssize_t rc = recv(sockfd, buf, buf_len, 0);
    if (rc == -1) {
        int error_code = errno;
        const char* error_msg = strerror(error_code);
        fprintf(stderr, "[ERROR] ffi: recv: [%d] %s\n", error_code, error_msg);
    }

#ifdef DEBUG
    fprintf(stderr, "[DEBUG] ffi: recv ok. rc=%zd(bytes received) buf=\"%s\"\n", rc, buf);
#endif

    return rc;
}

static char* new_str_from_buf(const char* buf, size_t buf_len) {
    assert(buf != NULL);
    assert(buf != 0);

    // one space more for the null byte at the end of the string
    const size_t str_capacity = buf_len + 1;

    // create the new string
    char* str = (char*) malloc(sizeof(char) * str_capacity);
    if (str == NULL) {
        fprintf(stderr, "error: Out of Memory. Aborting.\n");
        exit(1);
    }

    // copy the source buffer into the new string...
    strncpy(str, buf, str_capacity - 1);

    // ...and append the null byte char at the end
    str[str_capacity - 1] = '\0';

    return str;
}
