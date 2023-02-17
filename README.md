# scut
scut is a little tool that gives you basic directory aliasing functionality on the windows command line.
You can open a directory in explorer or cd into it.

To use, drop scut.bat into a directory that is on your path.

```batch
USAGE: scut [-l|-r|-a|-o] pathalias [pathToAlias]
  'pathalias' is a alias given to a path. 
  '-l' option will list available path aliases
  '-o' will open the pathalias in explorer
  '-r' will remove an alias from database
  '-a' will add 'pathToAlias' to the database
```

scut stores your shortcuts in a flat file located `%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\scut-db.txt`

To add "c:\user\blah" as alias "blah"
`scut -a blah c:\user\blah`

If your path has spaces in it surround it with quotes like so
`scut -a blah "c:\path with space\blah"`

To remove alias "blah"
`scut -r blah`

To open "c:\user\blah" in windows explorer GUI
`scut -o blah`

To list the content of your alias database
`scut -l`

To change directory (cd) in an alias 
`scut <pathalias>`
