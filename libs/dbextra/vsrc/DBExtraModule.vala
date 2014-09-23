using aroop;
using shotodol;
using shotodol.db;

/***
 * \addtogroup db
 * @{
 */
public class shotodol.db.DBExtraModule : DynamicModule {
	DBExtraModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	~DBExtraModule() {
	}

	public override int init() {
		extring entry = extring.set_static_string("command");
		Plugin.register(&entry, new M100Extension(new DBCommand(), this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new DBExtraModule();
	}
}

/** @} */
