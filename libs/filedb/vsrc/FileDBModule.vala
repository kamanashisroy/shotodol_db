using aroop;
using shotodol;
using shotodol.db;

/***
 * \addtogroup filedb
 * @{
 */
public class shotodol.filedb.FileDBModule : DynamicModule {
	FileDBModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	~FileDBModule() {
	}

	public override int init() {
		extring entry = extring.set_static_string("db/memory/incremental");
		Plugin.register(&entry, new HookExtension(onBuildFileDBIncrementalHook, this));
		entry.rebuild_and_set_static_string("db/memory/hashmap");
		Plugin.register(&entry, new HookExtension(onBuildFileDBHashMapHook, this));
		return 0;
	}
	int onBuildFileDBIncrementalHook(extring*msg, extring*output) {
		if(msg == null)
			return 0;
		extring dbentry = extring.stack(128);
		dbentry.concat_string("db/memory/incremental/");
		dbentry.concat(msg);
		Plugin.register(&dbentry, new AnyInterfaceExtension(new FileDBIncremental(), this));
		return 0;
	}
	int onBuildFileDBHashMapHook(extring*msg, extring*output) {
		if(msg == null)
			return 0;
		extring dbentry = extring.stack(128);
		dbentry.concat_string("db/memory/hashmap/");
		dbentry.concat(msg);
		Plugin.register(&dbentry, new AnyInterfaceExtension(new FileDBHashMap(), this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new FileDBModule();
	}
}

/** @} */
