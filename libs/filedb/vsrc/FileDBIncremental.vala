using aroop;
using shotodol;
using shotodol.db;
using shotodol_platform_fileutils;

/** \addtogroup filedb
 *  @{
 */
public class shotodol.filedb.FileDBIncremental : DB {
	extring dbname;
	extring tblname;
	public FileDBIncremental(extring*giventbl = null) {
		extring delim = extring.set_static_string("/");
		dbname = extring.set_static_string("incremental");
		tblname = extring.set_static_string("default");
		if(giventbl != null && !giventbl.is_empty()) {
			extring token = extring();
			extring inp = extring.stack(giventbl.length());
			inp.concat(giventbl);
			LineAlign.next_token_delimitered_sliteral(&inp, &token, &delim);
			dbname.rebuild_and_copy_on_demand(&token);
			dbname.zero_terminate();
			inp.shift(1); // skip '/' character
			if(!inp.is_empty()) {
				tblname.rebuild_and_copy_on_demand(&inp);
				tblname.zero_terminate();
			}
		}
	}
	~FileDBIncremental() {
	}

/*

function filedb_database_insert($db, $tbl, $more) {
	$tbldir = filedb_create_or_prepare_table($db, $tbl);
	if(!$tbldir) {
		error_report("Could not create table dir, please check file permission\n");
		return FALSE;
	}
	$index = 1;
	$infofile = $tbldir."/.info";
	$info = filedb_readfile($infofile);
	if(!isset($info) || !isset($info['index'])) {
		// new table
		$info = array('index' => $index);
	} else {
		$info['index'] = intval($info['index']);
		$info['index']++;
		$index = $info['index'];
	}
	// TODO write a function that locks and updates index file ..
	if(!filedb_writefile($infofile, $info) || !filedb_writefile($tbldir."/".$index, $more)) {
		return FALSE;
	}
	return $index;
}

 */
	public override int save(DBId id, DBEntry entry) {
		extring tbldir = extring();
		if(FileDBIO.buildTableDir(&dbname, &tblname, &tbldir) == -1) {
			return -1;
		}
		int index = 0;
		index = FileDBIO.autoIncrement(&tbldir);

		extring xfile = extring.stack(tbldir.length()+32); 
		xfile.printf("%s/%d", tbldir.to_string(), index);
		FileDBIO.writeEntryToBinaryFile(&xfile, entry);
		return 0;
	}

	public override DBEntry? remove(DBId id, DBEntry entry) {
		return null;
	}

	public override DBEntry? load(DBId id) {
		return null;
	}
}
/** @}*/

