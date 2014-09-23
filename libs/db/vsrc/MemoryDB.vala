using aroop;
using shotodol;

/** \addtogroup db
 *  @{
 */
public class shotodol.db.MemoryDB : DB {
	SearchableSet<DBEntry>db;
	public MemoryDB(DB.DBType tp, extring*address) {		
		db = SearchableSet<DBEntry>();
	}
	
	~MemoryDB() {		
		db.destroy();
	}
	
	public override int save(DBId id, DBEntry entry) {
		db.addPointer(entry, id.hash);
		return 0;
	}
	
	public override DBEntry? remove(DBId id, DBEntry entry) {
		db.prune(id.hash, entry);
		return null;
	}
	
	public override DBEntry? load(DBId id) {
		return (DBEntry)db.search(id.hash, null);
	}
}
/** @}*/
