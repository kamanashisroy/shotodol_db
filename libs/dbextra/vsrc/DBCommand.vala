using aroop;
using shotodol;
using shotodol.db;

/** \addtogroup db
 *  @{
 */
internal class shotodol.db.DBCommand : M100Command {
	enum Options {
		INSERT = 1,
		VIEW,
		KEY,
		VALUE,
		DB_STR,
	}
	BagFactoryImpl bags;
	public DBCommand() {
		var prefix = extring.set_static_string("db");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.INT, Options.INSERT, "Insert db content, eg. db -i hashvalue -nm name -val value, You can put 0 as hashvalue if the there is autoincrement."); 
		addOptionString("-v", M100Command.OptionType.INT, Options.VIEW, "View db content by index"); 
		addOptionString("-nm", M100Command.OptionType.TXT, Options.KEY, "Key name"); 
		addOptionString("-val", M100Command.OptionType.TXT, Options.VALUE, "Value"); 
		addOptionString("-dbstr", M100Command.OptionType.TXT, Options.DB_STR, "Database string denoted as db/memory/incremental/dbname/tablename or db/filedb/incremental/dbname/tablename "); 
		bags = new BagFactoryImpl();
	}
	DB? getDB(extring*dbstr = null) {
		extring dbpath = extring.set_static_string("db/memory/incremental/shake");
		if(dbstr != null) {
			dbpath.rebuild_and_copy_shallow(dbstr);
		}
		DB?db = null;
		PluginManager.acceptVisitor(&dbpath, (x) => {
			db = (DB)x.getInterface(null);
		});
		if(db == null) {
			// tokenize the dbpath
			extring next = extring();
			extring dupdb = extring.stack(dbpath.length()+1);
			dupdb.concat(&dbpath);
			extring frdslash = extring.set_static_string("/");
			int term = 0;
			extring dbtp = extring.stack(128);
			while(LineAlign.next_token_delimitered(&dupdb, &next, &frdslash) == 0) {
				if(next.is_empty())
					break;
				switch(term) {
					case 0:
					case 1:
					case 2:
						dbtp.concat(&next);
						if(term != 2)dbtp.concat_char('/');
					break;
					default:
					break;
				}
				term++;
				dupdb.shift(1);
			}


			extring dbname = extring.copy_shallow(&dbpath);
			dbname.shift(dbtp.length()+1);
			if(dbname.is_empty()) {
				dbname.rebuild_and_set_static_string("shake");
			}
			extring unused = extring();
			PluginManager.swarm(&dbtp, &dbname, &unused);
		}
		PluginManager.acceptVisitor(&dbpath, (x) => {
			db = (DB)x.getInterface(null);
		});
		return db;
	}
	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?ex = vals[Options.INSERT];
		if(ex != null) {
			DB?db = null;
			DBId dbd = DBId();
			xtring?dbstr = vals[Options.DB_STR];
			db = getDB(dbstr);
			if(db == null) {
#if DB_DEBUG
				extring dlg = extring.stack(128);
				dlg.printf("Could not create db:[%s]\n", dbstr.fly().to_string());
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.Severity.LOG, 0, 0, &dlg);
#endif
				return 0;
			}
			dbd.hash = ex.fly().to_int();
			xtring?nm = vals[Options.KEY];
			xtring?vl = vals[Options.VALUE];
			if(nm == null || vl  == null)
				return 0;
			Bag entry = bags.createBag(512);
			Bundler bndlr = Bundler();
			bndlr.buildFromCarton(&entry.msg, entry.size);
			bndlr.writeEXtring(Options.KEY, nm);
			bndlr.writeEXtring(Options.VALUE, vl);
			entry.finalize(&bndlr);
			db.save(dbd,entry);
			return 0;
		}

		ex = vals[Options.VIEW];
		if(ex != null) {
			DB?db = null;
			DBId dbd = DBId();
			xtring?dbstr = vals[Options.DB_STR];
			db = getDB(dbstr);
			if(db == null) {
#if DB_DEBUG
				extring dlg = extring.stack(128);
				dlg.printf("Could not create db:[%s]\n", dbstr.fly().to_string());
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.Severity.LOG, 0, 0, &dlg);
#endif
				return 0;
			}
			dbd.hash = ex.fly().to_int();
			Bag?entry = db.load(dbd);
			if(entry == null)
				return 0;
			Unbundler ubndlr = Unbundler();
			ubndlr.buildFromCarton(&entry.msg, entry.size);
			extring nl = extring.set_static_string("\n");
			while(ubndlr.next() != -1) {
				extring val = extring();
				ubndlr.getEXtring(&val);
				pad.write(&val);
				pad.write(&nl);
			}
		}
		return 0;
	}
}
/* @} */
