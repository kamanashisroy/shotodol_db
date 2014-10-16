using aroop;
using shotodol;
using shotodol.db;

/** \addtogroup filedb
 *  @{
 */
public class shotodol.filedb.FileDBHashMap : DB {
	extring dbname;
	extring tblname;
	BagFactoryImpl bags;
	public FileDBHashMap(extring*giventbl = null, BagFactoryImpl bgf) {
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
		bags = bgf;
	}
	~FileDBHashMap() {
	}

	public override int save(DBId id, Bag entry) {
		extring x = extring.set_static_string("junk.txt");
		FileOutputStream fo;
		fo = new FileOutputStream.from_file(&x);
		extring data = extring();
		entry.getContentAs(&data);
		fo.write(&data);
		fo.close();
		return 0;
	}

	public override Bag? remove(DBId id, Bag entry) {
		return null;
	}

	public override Bag? load(DBId id) {
		return null;
	}
}
/** @}*/

