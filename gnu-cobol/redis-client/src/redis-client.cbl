      *------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. REDIS-CLIENT.
      * AUTHOR is deprecated in GnuCOBOL 
      * AUTHOR. HBOBENICIO.
      *------------------------
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  REDIS.
         02  HOST        PIC X(9) VALUE 'localhost'.
         02  PORT        PIC X(4) VALUE '6379'.
         02  SOCK        PIC X(4) VALUE ZEROES.
       01  POSIX.
         02  ERRNO       PIC S9(8) BINARY.
         02  STRERROR    PIC X(50) VALUE SPACES.
         02  AF-INET     PIC S9(8) BINARY.
         02  SOCK-STREAM PIC S9(8) BINARY.
       01  RC            PIC S9(8) BINARY.
      *------------------------
       PROCEDURE DIVISION.
           PERFORM FFI-POSIX-INIT.
           PERFORM REDIS-CONNECT.
           STOP RUN.

      * Initializes the FFI for Posix stuff
       FFI-POSIX-INIT.
           CALL 'ffi_posix_af_inet'     RETURNING AF-INET IN POSIX.
           CALL 'ffi_posix_sock_stream' RETURNING SOCK-STREAM IN POSIX.

       REDIS-CONNECT.
           DISPLAY 'Connecting to Redis at '
                 , HOST IN REDIS, ':', PORT IN REDIS.
           PERFORM FFI-POSIX-CONNECT.

       FFI-POSIX-CONNECT.
           CALL 'socket' USING
               BY VALUE AF-INET IN POSIX 
               BY VALUE SOCK-STREAM IN POSIX
               BY VALUE 0
               RETURNING RC
           END-CALL.
           IF RC IS EQUAL TO -1 THEN
               CALL 'ffi_posix_errno' RETURNING ERRNO IN POSIX
      *         CALL 'ffi_posix_strerror' USING
      *             BY VALUE POSIX-ERRNO
      *             RETURNING POSIX-STRERROR
      *         END-CALL
               DISPLAY 'error: call=socket code=', ERRNO IN POSIX
               MOVE ERRNO TO RETURN-CODE
               STOP RUN
           END-IF.
