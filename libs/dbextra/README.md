
DBCommand
============

You can insert a new entry into a database like the following,

```
db -i -nm a -val b -dbstr db/filedb/incremental/shake/default
```

And you can read the value like the following,

```
db -v 1 -dbstr db/filedb/incremental/shake/default
```

You can find the dbfile in .data/shake/default/ directory.

