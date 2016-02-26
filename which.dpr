program which;
{
        ---------------------------------------------------
        portation of the UNIX command WHICH to WIN32
        (Win95/98/NT4)
        Gives the complete path of a file anywhere
        in one of the declared pathes of environment
        variable %PATH% or if it is a registered
        application
        ---------------------------------------------------
        author:
        ~~~~~~~
                  Axel Hahn
                  http://www.axel-hahn.de/
        ---------------------------------------------------
        IN:
        ~~~
            param1 - filename to search

        OUT (returncodes):
        ~~~~~~~~~~~~~~~~~~
            0 = OK
            1 = ERROR: count of parameters wasn't equal 1
            2 = ERROR: file wasn't found
        ---------------------------------------------------
        history:
        2000-08-08  Version 1.0
        2001-04-01  Version 1.1 - complete given filename
                    with an extension (exe, com, bat, cmd)
                    and additional search in the registry
                    ("open with..." - applications)
        ---------------------------------------------------
}
uses
  Windows, SysUtils, Registry, Classes;


// ---------------------------------------------------------------
// some constants and variables...
// ---------------------------------------------------------------
const
     txtabout:string='*** WHICH.EXE *** version 1.1 - written by Axel Hahn - 2000-2001' + #10+#13 + #10+#13 +
                     'INFO:'#10+#13 +
                     '  Gives the complete path of a file anywhere in one of the declared pathes of' + #10+#13 +
                     '  environment variable %PATH% or if it is a registered application.'  + #10+#13;
     txtSyntax:string='SYNTAX:' +#10+#13 +
                     '  which filename[.extension]  -  show complete path of a file'  + #10+#13 +
                     '                                 extensions .exe, .com, .bat, .cmd will be'  + #10+#13 +
                     '                                 added automaticly.'  + #10+#13 +
                     '  which /regapps              -  list all registered appliations';
     errWrongParamCount:string='ERROR:' +#10+#13 + '  Wrong count of parameters!';
     APP_Key:string = 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\';
var
   envPATH, RegApps, errFileNotFound, myFilename, myFoundFile:string;


// ---------------------------------------------------------------
// function:
// get value of an environment variable
// ---------------------------------------------------------------
function GetEnvVar(AVariable:String): string;
var
    FRegSysVar: TRegistry;
    APVariable, APVariablePath: array[0..1023] of Char;
    myresult:string;
begin
     StrPCopy(APVariable,AVariable);
     if GetEnvironmentVariable(APVariable,APVariablePath,sizeof(APVariablePath)) = 0
     then begin
          myresult := '';
          // Windows NT specific
          if (Win32Platform = VER_PLATFORM_WIN32_NT) then
          begin
               FRegSysVar := TRegistry.Create;
               FRegSysVar.Rootkey:=HKEY_LOCAL_Machine;

               if (FRegSysVar.OpenKey('\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',FALSE))
               then begin
                    myresult := FRegSysVar.ReadString(AVariable);
                    FRegSysVar.CloseKey;
               end;
               if (result = '')
               and (FRegSysVar.OpenKey('\Environment',FALSE))
               then begin
                    myresult := FRegSysVar.ReadString(AVariable);
                    FRegSysVar.CloseKey;
               end;
               FRegSysVar.free;
          end;
     end
     else
         myresult := strPas(APVariablePath);

     GetEnvVar:=myresult;
end;


// ---------------------------------------------------------------
// function:
// list of all registered applications
// ---------------------------------------------------------------
function GetRegApps: string;
var tmp,tmp2:string;
    keylist:Tstrings;
   Reg_Info: TRegistry;
   i:integer;
begin
   tmp:='';
   Reg_Info := TRegistry.Create;
   try
      Reg_Info.Rootkey:=HKEY_LOCAL_MACHINE;
      if Reg_Info.OpenKey(APP_Key,FALSE) then begin
         keylist := TStringList.create;
         try
            Reg_Info.GetKeyNames(keylist);
            Reg_Info.CloseKey;
            for i:=0 to (keylist.count-1) do begin
                tmp2:='';
                if Reg_Info.OpenKey(APP_Key+keylist[i],FALSE) then begin
                   tmp2:=Reg_Info.ReadString('');
                   Reg_Info.CloseKey;
                end;
                tmp:=tmp+keylist[i] + ' - ' + tmp2 + #10+#13;
            end;
         finally
            keylist.free;
         end;
      end;
   finally
      Reg_Info.free;
   end;

   GetRegApps:=tmp;

end;


// ---------------------------------------------------------------
// function:
// test - file exists?
// ---------------------------------------------------------------
function checkfile(Filename:String): boolean;
var tmp:boolean;
    myFoundFile:string;
    Reg_Info: TRegistry;
begin
   tmp:=false;

   // -- step one: search in the PATH environment
   myFoundFile:=FileSearch(Filename, envPATH);
   //                                ^^^^^^^^^
   //                                global variable

   if (myFoundFile='') then begin

      // -- step two: search in the registry for registered apps
     Reg_Info := TRegistry.Create;
     Reg_Info.Rootkey:=HKEY_LOCAL_MACHINE;
     try
        if Reg_Info.OpenKey(APP_Key+Filename,FALSE) then begin
           myFoundFile:=Reg_Info.ReadString('');
           Reg_Info.CloseKey;
        end;
     finally
        Reg_Info.free;
     end;

   end;

   // -- last step: check the file
   if (fileexists(myFoundFile))
   then begin
      writeln(myFoundFile);
      tmp:=true;
   end;

   checkfile:=tmp;
end;


// ---------------------------------------------------------------
// let's go!
// ---------------------------------------------------------------
begin

     if paramCount<>1 then begin
        writeln(txtabout);
        writeln(errWrongParamCount);
        writeln;
        writeln(txtSyntax);
        Halt(1);
     end else begin

        myFilename:=ParamStr(1);
        envPATH:=GetEnvVar('PATH');
        RegApps:=GetRegApps;

        if (AnsiUpperCase(ParamStr(1))='/REGAPPS')
        then begin
           writeln(RegApps);
           Halt(0);
        end;

        errFileNotFound:='ERROR:' + #10+#13 +
                      '  The file <' + myFilename + '> was not found in' + #10+#13 +
                      '  %PATH%='+ envPATH + #10+#13 +
                      '  and also not as registered application under' + #10+#13 +
                      '  HKEY_LOCAL_MACHINE\' + APP_Key;

        if (checkfile(myFilename))
        or (checkfile(myFilename + '.exe'))
        or (checkfile(myFilename + '.com'))
        or (checkfile(myFilename + '.bat'))
        or (checkfile(myFilename + '.cmd'))
        then Halt(0)
        else begin
           writeln(txtabout);
           writeln(errFileNotFound);
           writeln;
           writeln(txtSyntax);
           Halt(2);
        end;

     end;
end.
// ---------------------------------------------------------------
// http://www.axel-hahn.de/
// BYE!
// ---------------------------------------------------------------

