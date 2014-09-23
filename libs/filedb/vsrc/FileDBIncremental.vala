using aroop;
using shotodol;
using shotodol.db;

/** \addtogroup filedb
 *  @{
 */
public class shotodol.filedb.FileDBIncremental : DB {
	public FileDBIncremental() {
	}
	~FileDBIncremental() {
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

