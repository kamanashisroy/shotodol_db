using aroop;
using shotodol;
using shotodol.db;

/***
 * \addtogroup memorydb
 * @{
 */
public class shotodol.memorydb.MemoryDBModule : DynamicModule {
	MemoryDBModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	~MemoryDBModule() {
	}

	public override int init() {
		//DBEntryFactory.init();
		extring entry = extring.set_static_string("db/memory/incremental");
		Plugin.register(&entry, new HookExtension(onBuildMemoryDBIncrementalHook, this));
		entry.rebuild_and_set_static_string("db/memory/hashmap");
		Plugin.register(&entry, new HookExtension(onBuildMemoryDBHashMapHook, this));
		return 0;
	}
	int onBuildMemoryDBIncrementalHook(extring*msg, extring*output) {
		if(msg == null)
			return 0;
		extring dbentry = extring.stack(128);
		dbentry.concat_string("db/memory/incremental/");
		dbentry.concat(msg);
		Plugin.register(&dbentry, new AnyInterfaceExtension(new MemoryDBIncremental(), this));
		return 0;
	}
	int onBuildMemoryDBHashMapHook(extring*msg, extring*output) {
		if(msg == null)
			return 0;
		extring dbentry = extring.stack(128);
		dbentry.concat_string("db/memory/hashmap/");
		dbentry.concat(msg);
		Plugin.register(&dbentry, new AnyInterfaceExtension(new MemoryDBHashMap(), this));
		return 0;
	}
	public override int deinit() {
		//DBEntryFactory.deinit();
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new MemoryDBModule();
	}
}

/** @} */
