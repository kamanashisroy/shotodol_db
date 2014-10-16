using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup db Database
 */

/** \addtogroup db
 *  @{
 */
public struct shotodol.db.DBId {
	aroop_hash hash;
}
public abstract class shotodol.db.DB : Replicable {
	/*public enum DBType {
		DB_IS_REMOTE = 1,
		DB_IS_LOCAL = 1<<1,
		DB_IS_SHARED = 1<<2,
	}*/
	public virtual int insert(Bag entry, DBId*newId) {
		core.die("unimplemented");
		return 0;
	}
	
	public virtual int save(DBId id, Bag entry) {
		core.die("unimplemented");
		return 0;
	}
	
	public virtual Bag? remove_by_hash(DBId id) {
		core.die("unimplemented");
		return null;
	}
	
	public virtual Bag? remove(DBId id, Bag entry) {
		core.die("unimplemented");
		return null;
	}
	
	public virtual Bag? load(DBId id) {
		core.die("unimplemented");
		return null;
	}
}
/** @}*/
