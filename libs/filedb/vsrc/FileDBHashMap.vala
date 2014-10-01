using aroop;
using shotodol;
using shotodol.db;

/** \addtogroup filedb
 *  @{
 */
public class shotodol.filedb.FileDBHashMap : DB {
	extring dbname;
	extring tblname;
	public FileDBHashMap(extring*giventbl = null) {
		dbname = extring.set_static_string("hashmap");
		tblname = extring.set_static_string("default");
		if(giventbl != null && !giventbl.is_empty()) {
			extring token = extring();
			extring inp = extring.stack(giventbl.length());
			inp.concat(giventbl);
			LineAlign.next_token(&inp, &token);
			dbname.rebuild_and_copy_on_demand(&token);
			if(!inp.is_empty())
				tblname.rebuild_and_copy_on_demand(&inp);
		}
	}
	~FileDBHashMap() {
	}

	public override int save(DBId id, DBEntry entry) {
		extring x = extring.set_static_string("junk.txt");
		FileOutputStream fo;
		fo = new FileOutputStream.from_file(&x);
		extring data = extring();
		entry.copyAs(&data);
		fo.write(&data);
		fo.close();
		return 0;
	}

	public override DBEntry? remove(DBId id, DBEntry entry) {
		return null;
	}

	public override DBEntry? load(DBId id) {
		return null;
	}
}
/** @}*/

