      *------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. REDIS-CLIENT.
      * AUTHOR is deprecated in GnuCOBOL 
      * AUTHOR. HBOBENICIO.
      *------------------------
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  REDIS.
         02  REDIS-CONN-HOST   PIC X(9) VALUE 'localhost'.
         02  REDIS-CONN-PORT   PIC X(4) VALUE '6379'.
         02  REDIS-CLIENT-SOCK PIC X(4) VALUE ZEROES.
       01  POSIX.
         02  POSIX-AF-INET     PIC S9(8) BINARY.
         02  POSIX-SOCK-STREAM PIC S9(8) BINARY.
       01  RC                  PIC S9(8) BINARY.
      *------------------------
       PROCEDURE DIVISION.
           PERFORM FFI-POSIX-INIT.
           PERFORM REDIS-CONNECT.
           STOP RUN.

      * Initializes the FFI for Posix stuff
       FFI-POSIX-INIT.
           CALL 'ffi_posix_af_inet'     RETURNING POSIX-AF-INET.
           CALL 'ffi_posix_sock_stream' RETURNING POSIX-SOCK-STREAM.

       REDIS-CONNECT.
           DISPLAY 'Connecting to Redis at '
                 , REDIS-CONN-HOST , ':', REDIS-CONN-PORT.
           PERFORM FFI-POSIX-CONNECT.
           DISPLAY RC.

       FFI-POSIX-CONNECT.
           CALL 'ffi_posix_socket' USING
               BY VALUE POSIX-AF-INET
               BY VALUE POSIX-SOCK-STREAM
               BY VALUE 0
               RETURNING RC
           END-CALL.
