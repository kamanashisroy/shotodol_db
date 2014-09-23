using aroop;
using shotodol;
using shotodol.db;

/** \addtogroup memorydb
 *  @{
 */
internal class shotodol.memorydb.MemoryDBIncremental : DB {
	ArrayList<DBEntry>db;
	uint counter;
	public MemoryDBIncremental() {		
		db = ArrayList<DBEntry>();
		counter = 0;
	}
	
	~MemoryDBIncremental() {		
		db.destroy();
	}

	public override int insert(DBEntry entry, DBId*newId) {
		uint index = counter;
		db.set(index, entry);
		newId.hash = index;
		counter++;
		return (int)index;
	}
	
	public override int save(DBId id, DBEntry entry) {
		db.set(id.hash, entry);
		return 0;
	}
	
	public override DBEntry? remove(DBId id, DBEntry entry) {
		db.set(id.hash, null);
		return null;
	}
	
	public override DBEntry? load(DBId id) {
		return (DBEntry)db.get(id.hash);
	}
}
/** @}*/
