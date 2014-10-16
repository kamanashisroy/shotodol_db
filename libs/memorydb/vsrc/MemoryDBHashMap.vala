using aroop;
using shotodol;
using shotodol.db;

/** \addtogroup memorydb
 *  @{
 */
internal class shotodol.memorydb.MemoryDBHashMap : DB {
	SearchableSet<Bag>db;
	public MemoryDBHashMap() {		
		db = SearchableSet<Bag>();
	}
	
	~MemoryDBHashMap() {		
		db.destroy();
	}

#if false
	public override int insert(Bag entry, DBId*newId) {
		core.die("unimplemented");
		db.addPointer(entry, id.hash);
		return 0;
	}
#endif
	
	public override int save(DBId id, Bag entry) {
		db.addPointer(entry, id.hash);
		return 0;
	}
	
	public override Bag? remove(DBId id, Bag entry) {
		db.prune(id.hash, entry);
		return null;
	}
	
	public override Bag? load(DBId id) {
		return (Bag)db.search(id.hash, null);
	}
}
/** @}*/
