using aroop;
using shotodol;
using shotodol.db;

/** \addtogroup filedb
 *  @{
 */
internal class shotodol.filedb.FileDBHashMap : DB {
	extring dbname;
	extring tblname;
	BagFactoryImpl bags;
	public FileDBHashMap(extring*giventbl = null, BagFactoryImpl bgf) {
		extring delim = extring.set_static_string("/");
		dbname = extring.set_static_string("hashmap");
		tblname = extring.set_static_string("default");
		if(giventbl != null && !giventbl.is_empty()) {
			extring token = extring();
			extring inp = extring.stack(giventbl.length());
			inp.concat(giventbl);
			LineAlign.next_token_delimitered_sliteral(&inp, &token, &delim);
			dbname.rebuild_and_copy_on_demand(&token);
			dbname.zero_terminate();
			inp.shift(1); // skip '/' character
			if(!inp.is_empty()) {
				tblname.rebuild_and_copy_on_demand(&inp);
				tblname.zero_terminate();
			}
		}
		bags = bgf;
	}
	~FileDBHashMap() {
	}
	public override int insert(Bag entry, DBId*newId) {
		DBId xid = DBId();
		xid.hash = newId.hash;
		save(xid, entry);
		return 0;
	}
	public override int save(DBId id, Bag entry) {
		extring tbldir = extring();
		if(FileDBIO.buildTableDir(&dbname, &tblname, &tbldir, true) == -1) {
			return -1;
		}
		aroop_hash index = id.hash;
		extring xfile = extring.stack(tbldir.length()+32); 
		xfile.printf("%s/%X", tbldir.to_string(), index);
		FileDBIO.writeEntryToBinaryFile(&xfile, entry);
		return 0;
	}

	public override Bag? remove(DBId id, Bag entry) {
		return null;
	}

	public override Bag? load(DBId id) {
		extring tbldir = extring();
		if(FileDBIO.buildTableDir(&dbname, &tblname, &tbldir) == -1) {
			return null;
		}
		aroop_hash index = id.hash;
		extring xfile = extring.stack(tbldir.length()+32); 
		xfile.printf("%s/%X", tbldir.to_string(), index);
		Bag ret = bags.createBag(512);
		FileDBIO.readEntryFromBinaryFile(&xfile, ret);
		return ret;
	}
}
/** @}*/

