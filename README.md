# Win32 User Interface (fpc and delphi7)

# build resources
>brcc32 -32 -fofile.res file.rc

# delphi7 build
>dcc32 -b app.dpr

# fpc build
>fpc -B -Mdelphi -dRELEASE @extrafpc.cfg app.dpr

# fpc 64bit build
>ppcrossx64.exe -B -Mdelphi -dRELEASE @extrafpc.cfg app.dpr
