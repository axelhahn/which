---------------------------------------------------

                - = README.TXT = -

---------------------------------------------------
What is WHICH.EXE ???

... a portation of the UNIX command WHICH to WIN32
(Win95/98/NT4).
It gives the complete path of a file anywhere
in one of the declared pathes of environment
variable %PATH% or if it is a registered
application.

Run DEMO_WHICH.BAT to get an introduction.

---------------------------------------------------
This program is FREEWARE includung full sourcecode
(language: ObjectPascal - Borland DELPHI)
---------------------------------------------------
author:
~~~~~~~
        Axel Hahn
        http://www.axel-hahn.de/
---------------------------------------------------
IN:
~~~
param1 - [filename] to search
         or
         /regapps to list all registered applications

OUT (returncodes):
~~~~~~~~~~~~~~~~~~
0 = OK
1 = ERROR: count of parameters wasn't equal 1
2 = ERROR: file wasn't found

syntax:
~~~~~~~
which file[.ext]  -  show complete path of a file
                     extensions .exe, .com, .bat,
                     .cmd will be added automaticly.
which /regapps    -  list all registered appliations

examle:
~~~~~~~~
The command...
    WHICH EXPLORER
...gives the result
    C:\WINDOWS\EXPLORER.EXE

---------------------------------------------------

history:
~~~~~~~~
2000-08-08  Version 1.0
2001-04-01  Version 1.1
            * autocomplete given filename with an
              extension (exe, com, bat, cmd)
            * added: search in regisry for
              registered application

---------------------------------------------------

files:
~~~~~~
DEMO_WHICH.BAT  - demo introduces WHICH
FILE_ID.DIZ     - description file
WHICH.DPR       - Sourcecode (Pascal)
WHICH.EXE       - console application

---------------------------------------------------

If you have a further question contact me:
mailto:support@axel-hahn.de

---------------------------------------------------
### END OF FILE ##
---------------------------------------------------