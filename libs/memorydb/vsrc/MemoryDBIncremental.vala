using aroop;
using shotodol;
using shotodol.db;

/** \addtogroup memorydb
 *  @{
 */
internal class shotodol.memorydb.MemoryDBIncremental : DB {
	ArrayList<Bag>db;
	uint counter;
	public MemoryDBIncremental() {		
		db = ArrayList<Bag>();
		counter = 0;
	}
	
	~MemoryDBIncremental() {		
		db.destroy();
	}

	public override int insert(Bag entry, DBId*newId) {
		uint index = counter;
		db.set(index, entry);
		newId.hash = index;
		counter++;
		return (int)index;
	}
	
	public override int save(DBId id, Bag entry) {
		db.set(id.hash, entry);
		return 0;
	}
	
	public override Bag? remove(DBId id, Bag entry) {
		db.set(id.hash, null);
		return null;
	}
	
	public override Bag? load(DBId id) {
		return (Bag)db.get(id.hash);
	}
}
/** @}*/
