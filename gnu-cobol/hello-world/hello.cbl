      *------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       AUTHOR. HBOBENICIO.
      *------------------------
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01   GREETING PIC X(10) VALUE 'Hello'.
       01   SUBJECT  PIC X(10) VALUE SPACES.
      *------------------------
       PROCEDURE DIVISION.
           MOVE 'Cobol' TO SUBJECT.
           PERFORM PRINT-GREETING.

      * Calling intrinsic functions need to be
      * prefixed with the 'FUNCTION' keyword
           MOVE FUNCTION UPPER-CASE(SUBJECT) TO SUBJECT.
           PERFORM PRINT-GREETING.

           MOVE FUNCTION LOWER-CASE(SUBJECT) TO SUBJECT.
           PERFORM PRINT-GREETING.

           STOP RUN.

       PRINT-GREETING.
           DISPLAY GREETING, SUBJECT.
