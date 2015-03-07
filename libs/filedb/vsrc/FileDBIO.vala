using aroop;
using shotodol;
using shotodol.db;
using shotodol_platform_fileutils;

/** \addtogroup filedb
 *  @{
 */
internal class shotodol.filedb.FileDBIO : Replicable {
/*
function filedb_readfile($file) {
	if(($fd = @fopen($file, 'r')) == FALSE) {
		return FALSE;
	}
	$x = array();
	while(($str = @fgets($fd))) {
		$i = strpos($str, '=');
		if($i == 0 || $i == FALSE) {
			continue;
		}
		$key = substr($str, 0, $i);
		$key = trim($key);
		$val = substr($str, $i+1);
		$x[$key] = trim($val);
	}
	@fclose($fd);
	return $x;
}
*/
	public static int readBinaryFile(extring*filepath, extring*contentoutput) {
		filepath.zero_terminate();
		FileInputStream?fi = new FileInputStream.from_file(filepath);
		if(fi == null) {
#if DB_DEBUG
			extring dlg = extring.stack(filepath.length()+32);
			dlg.printf("Unable to open file for reading:[%d][%s]\n", filepath.length(), filepath.to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.ERROR, 0, 0, &dlg);
#endif
			return -1;
		}
		if(contentoutput.capacity() >= 512) {
			contentoutput.set_length(0);
		} else {
			contentoutput.rebuild_in_heap(512);
		}
		fi.read(contentoutput);
		fi.close();
		return 0;
	}

	public static int readEntryFromBinaryFile(extring*filepath, Bag content) {
		filepath.zero_terminate();
		FileInputStream?fi = new FileInputStream.from_file(filepath);
		if(fi == null) {
#if DB_DEBUG
			extring dlg = extring.stack(filepath.length()+32);
			dlg.printf("Unable to open file for reading:[%d][%s]\n", filepath.length(), filepath.to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.ERROR, 0, 0, &dlg);
#endif
			return -1;
		}
		extring data = extring();
		content.getContentAs(&data);
		data.set_length(0);
		fi.read(&data);
		content.size = data.length();
		fi.close();
		return 0;
	}

	public static aroop_hash getDBIndex(extring*tbldir) {
		aroop_hash index = 0;
		extring infofile = extring.stack(tbldir.length()+32); 
		infofile.concat(tbldir);
		infofile.concat_string("/info.bin");
		if(FileUtil.exists(&infofile)) {
			extring content = extring();
			readBinaryFile(&infofile, &content);
			index = content.to_int(); // TODO use to_long_int()
		}
		return index;
	}


	public static aroop_hash autoIncrement(extring*tbldir) {
		aroop_hash index = getDBIndex(tbldir);
		index++;
		// TODO check if the file value is index before setting. Or open the file for writing before reading .. make it atomic .
		extring content = extring.stack(64);
		content.printf("%u\r\n", index);
		extring infofile = extring.stack(tbldir.length()+32); 
		infofile.concat(tbldir);
		infofile.concat_string("/info.bin");
		FileDBIO.writeBinaryFile(&infofile, &content);
		return index;
	}

/*
function filedb_writefile($file, $x) {
	if(!($fd = @fopen($file, 'w'))) {
		return FALSE;
	}
	foreach($x as $key=>$val) {
		@fputs($fd, $key.' = '.$val."\r\n");
	}
	@fclose($fd);
	return TRUE;
}
*/

	public static int writeBinaryFile(extring*filepath, extring*content) {
		filepath.zero_terminate();
		FileOutputStream?fo = new FileOutputStream.from_file(filepath);
		if(fo == null) {
#if DB_DEBUG
			extring dlg = extring.stack(filepath.length()+32);
			dlg.printf("Unable to open file for writing:[%d][%s]\n", filepath.length(), filepath.to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.ERROR, 0, 0, &dlg);
#endif
			return -1;
		}
		fo.write(content);
		fo.close();
		return 0;
	}

	public static int writeEntryToBinaryFile(extring*filepath, Bag content) {
		filepath.zero_terminate();
		FileOutputStream?fo = new FileOutputStream.from_file(filepath);
		if(fo == null) {
#if DB_DEBUG
			extring dlg = extring.stack(filepath.length()+32);
			dlg.printf("Unable to open file for writing:[%d][%s]\n", filepath.length(), filepath.to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.ERROR, 0, 0, &dlg);
#endif
			return -1;
		}
		extring data = extring();
		content.getContentAs(&data);
		fo.write(&data);
		fo.close();
		return 0;
	}


	public static int buildTableDir(extring*db, extring*tbl, extring*outtbl, bool create = false) {
#if DB_DEBUG
		extring dlg = extring.stack(128);
		dlg.printf("Building db:[%d][%s], tbl:[%d][%s]\n", db.length(), db.to_string(), tbl.length(), tbl.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.LOG, 0, 0, &dlg);
#endif
		outtbl.destroy();
		extring FILEDB_HOME = extring.set_static_string(".data");
		if(!FileUtil.exists(&FILEDB_HOME) && !create && !FileUtil.mkdir(&FILEDB_HOME, 0777)) {
#if DB_DEBUG
			dlg.printf("Failed to create directory:[%d][%s]\n", FILEDB_HOME.length(), FILEDB_HOME.to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.ERROR, 0, 0, &dlg);
#endif
			return -1;
		}
		extring dir = extring.stack(512);
		dir.concat(&FILEDB_HOME);
		dir.concat_char('/');
		dir.concat(db);
		dir.zero_terminate(); // this is important
		if(!FileUtil.exists(&dir) && create && !FileUtil.mkdir(&dir, 0777)) {
#if DB_DEBUG
			dlg.printf("Failed to create directory:[%d][%s]\n", dir.length(), dir.to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.ERROR, 0, 0, &dlg);
#endif
			return -1;
		}
		dir.concat_char('/');
		dir.concat(tbl);
		dir.zero_terminate(); // this is important
		if(!FileUtil.exists(&dir) && create && !FileUtil.mkdir(&dir, 0777)) {
#if DB_DEBUG
			dlg.printf("Failed to create directory:[%d][%s]\n", dir.length(), dir.to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.ERROR, 0, 0, &dlg);
#endif
			return -1;
		}
		outtbl.rebuild_and_copy_on_demand(&dir);
		return 0;
	}

}

