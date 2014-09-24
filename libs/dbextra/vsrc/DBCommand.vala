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
	}
	public DBCommand() {
		var prefix = extring.set_static_string("db");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.NONE, Options.INSERT, "Insert db content, eg. db -i -nm name -val value"); 
		addOptionString("-v", M100Command.OptionType.NONE, Options.VIEW, "View db content"); 
		addOptionString("-nm", M100Command.OptionType.TXT, Options.KEY, "Key name"); 
		addOptionString("-val", M100Command.OptionType.TXT, Options.VALUE, "Value"); 
	}
	DB? getDB() {
		extring dbpath = extring.set_static_string("db/memory/incremental/shake");
		DB?db = null;
		Plugin.acceptVisitor(&dbpath, (x) => {
			db = (DB)x.getInterface(null);
		});
		if(db == null) {
			extring dbspace = extring.set_static_string("db/memory/incremental");
			extring dbname = extring.set_static_string("shake");
			extring unused = extring();
			Plugin.swarm(&dbspace, &dbname, &unused);
		}
		Plugin.acceptVisitor(&dbpath, (x) => {
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
			db = getDB();
			if(db == null)
				return 0;
			dbd.hash = 10;
			xtring?nm = vals[Options.KEY];
			xtring?vl = vals[Options.VALUE];
			if(nm == null || vl  == null)
				return 0;
			DBEntry entry = DBEntryFactory.createEntry();
			entry.build(dbd);
			//DBEntry entry = new DBEntry(dbd);
			entry.addETxt(Options.KEY, nm);
			entry.addETxt(Options.VALUE, vl);
			db.save(dbd,entry);
			return 0;
		} else {
			// TODO view db
		}
		return 0;
	}
}
/* @} */
