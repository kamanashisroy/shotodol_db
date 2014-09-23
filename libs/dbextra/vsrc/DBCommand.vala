using aroop;
using shotodol;
using shotodol.db;

/** \addtogroup db
 *  @{
 */
internal class shotodol.db.DBCommand : M100Command {
	public DBCommand() {
		var prefix = extring.set_static_string("db");
		base(&prefix);
	}
	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) {
		extring fillme = extring.set_static_string("fill me\r\n");
		pad.write(&fillme);
		return 0;
	}
}
/* @} */
