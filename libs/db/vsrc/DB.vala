using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup db Database
 */

/** \addtogroup db
 *  @{
 */
public abstract class shotodol.db.DB : Replicable {
	/*public enum DBType {
		DB_IS_REMOTE = 1,
		DB_IS_LOCAL = 1<<1,
		DB_IS_SHARED = 1<<2,
	}*/
	public virtual int insert(DBEntry entry, DBId*newId) {
		core.die("unimplemented");
		return 0;
	}
	
	public virtual int save(DBId id, DBEntry entry) {
		core.die("unimplemented");
		return 0;
	}
	
	public virtual DBEntry? remove_by_hash(DBId id) {
		core.die("unimplemented");
		return null;
	}
	
	public virtual DBEntry? remove(DBId id, DBEntry entry) {
		core.die("unimplemented");
		return null;
	}
	
	public virtual DBEntry? load(DBId id) {
		core.die("unimplemented");
		return null;
	}
}
/** @}*/
