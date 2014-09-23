using aroop;
using shotodol;
using shotodol.db;

/** \addtogroup memorydb
 *  @{
 */
internal class shotodol.memorydb.MemoryDBHashMap : DB {
	SearchableSet<DBEntry>db;
	public MemoryDBHashMap() {		
		db = SearchableSet<DBEntry>();
	}
	
	~MemoryDBHashMap() {		
		db.destroy();
	}

#if false
	public override int insert(DBEntry entry, DBId*newId) {
		core.die("unimplemented");
		db.addPointer(entry, id.hash);
		return 0;
	}
#endif
	
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
