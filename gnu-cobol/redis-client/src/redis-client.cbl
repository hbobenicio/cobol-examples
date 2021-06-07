      *------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. REDIS-CLIENT.
      * AUTHOR is deprecated in GnuCOBOL 
      * AUTHOR. HBOBENICIO.
      *------------------------
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  REDIS.
         02  HOST        PIC X(10)  VALUE '127.0.0.1'.
         02  HOST-LEN    PIC 9(2)   VALUE 9.
         02  PORT        PIC 9(4)   BINARY VALUE 6379.
         02  SOCK        PIC S9(8)  BINARY VALUE ZEROES.
         02  COMMAND     PIC X(100) VALUE ' '.
         02  RESP        PIC X(100) VALUE ' '.
       01  POSIX.
         02  ERRNO       PIC S9(8)  BINARY.
         02  STRERROR    PIC X(50)  VALUE SPACES.
         02  AF-INET     PIC S9(8)  BINARY.
         02  SOCK-STREAM PIC S9(8)  BINARY.
       01  RC            PIC S9(8)  BINARY.
      *------------------------
       PROCEDURE DIVISION.
           PERFORM FFI-POSIX-INIT.
           PERFORM REDIS-CONNECT.
           PERFORM REDIS-PING.
           STOP RUN.

      * Initializes the FFI for Posix stuff
      * TODO test to define it like this
      * 01 EXT-ITEM1          PIC 99 EXTERNAL.
       FFI-POSIX-INIT.
           CALL 'ffi_posix_af_inet'     RETURNING AF-INET     IN POSIX.
           CALL 'ffi_posix_sock_stream' RETURNING SOCK-STREAM IN POSIX.

       REDIS-CONNECT.
           DISPLAY '[INFO] Creating TCP Socket...'
           PERFORM FFI-POSIX-SOCKET.
           DISPLAY '[INFO] Socket created successfully. fd='
                 , SOCK IN REDIS
                 .

           DISPLAY '[INFO] Connecting to Redis Server... '
                 , 'host=', HOST IN REDIS
                 , 'port=', PORT IN REDIS
                 .
           PERFORM FFI-POSIX-CONNECT.
           DISPLAY '[INFO] Successfully connected. fd=', SOCK IN REDIS.

       REDIS-PING.
           DISPLAY '[INFO] redis: Sending PING command'
           STRING 'PING' DELIMITED BY 4
                  x'0D'  DELIMITED BY 1
                  x'0A'  DELIMITED BY 1
             INTO COMMAND IN REDIS.
           PERFORM FFI-POSIX-SEND.
           PERFORM FFI-POSIX-RECV.
           DISPLAY '[INFO] redis: Ping success. resp=TODO'.
       
       FFI-POSIX-SOCKET.
           CALL 'socket' USING
               BY VALUE AF-INET IN POSIX 
               BY VALUE SOCK-STREAM IN POSIX
               BY VALUE 0
               RETURNING SOCK IN REDIS
           END-CALL.
           IF SOCK IN REDIS IS EQUAL TO -1 THEN
               CALL 'ffi_posix_errno' RETURNING ERRNO IN POSIX
      *         CALL 'ffi_posix_strerror' USING
      *             BY VALUE POSIX-ERRNO
      *             RETURNING POSIX-STRERROR
      *         END-CALL
               DISPLAY 'error: call=socket code=', ERRNO IN POSIX
               MOVE ERRNO TO RETURN-CODE
               STOP RUN
           END-IF.

       FFI-POSIX-CONNECT.
           CALL 'ffi_posix_connect' USING
               BY VALUE SOCK IN REDIS
               BY CONTENT HOST IN REDIS
               BY VALUE HOST-LEN IN REDIS
               BY VALUE PORT IN REDIS
               RETURNING RC
           END-CALL.
           IF RC IS EQUAL TO -1 THEN 
               CALL 'ffi_posix_errno' RETURNING ERRNO IN POSIX
               DISPLAY 'error: connect failed. errno=', ERRNO
               MOVE ERRNO TO RETURN-CODE
               STOP RUN
           END-IF.

       FFI-POSIX-SEND.
           CALL 'ffi_posix_send' USING
               BY VALUE SOCK IN REDIS
               BY CONTENT COMMAND IN REDIS
               BY VALUE 6
               RETURNING RC
           END-CALL.
           IF RC IS EQUAL TO -1 THEN
               CALL 'ffi_posix_errno' RETURNING ERRNO IN POSIX
               DISPLAY 'error: send failed. errno=', ERRNO
               MOVE ERRNO TO RETURN-CODE
               PERFORM FFI-POSIX-CLOSE
               STOP RUN
           END-IF.
           DISPLAY '[DEBUG] send success. rc=', RC
                 , '(bytes sent)'
                 .

       FFI-POSIX-RECV.
           DISPLAY '[DEBUG] recv: reading response...'
           CALL 'ffi_posix_recv' USING
               BY VALUE SOCK IN REDIS
               BY REFERENCE ADDRESS OF RESP IN REDIS
               BY VALUE LENGTH OF RESP IN REDIS
               RETURNING RC
           END-CALL.
           DISPLAY '[DEBUG] recv:'
                 , ' rc=', RC
                 , ' resp=', RESP IN REDIS
                 .
           IF RC IS EQUAL TO -1 THEN
               CALL 'ffi_posix_errno' RETURNING ERRNO IN POSIX
               DISPLAY 'error: recv failed. errno=', ERRNO
               MOVE ERRNO TO RETURN-CODE
               STOP RUN
           END-IF.
           DISPLAY '[DEBUG] recv success.'
                 , ' rc=', RC
                 , ' resp=', RESP IN REDIS
                 .

       FFI-POSIX-CLOSE.
           CALL 'close' USING
               BY VALUE SOCK IN REDIS
           END-CALL.
