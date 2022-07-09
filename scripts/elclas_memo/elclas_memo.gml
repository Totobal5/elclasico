// --- MEMO SAVE AND LOAD SYSTEM ---

/// @ignore
function memo() 
{
	static __memo__ = new __memoMaster();
	return (__memo__);		
}

/// @ignore
function __memoMaster() constructor
{
	/// @ignore
	static files = {};

	/// @ignore
	__saveFile = ""					// Nombre del archivo 
	/// @ignore
	__savePath = working_directory;	// Direccion donde guardar

	/// @ignore
	static create = function(_file_key)
	{
		__saveFile = _file_key;
		var _map = ds_map_create();
		files[$ __saveFile] = _map;
		
		return _map;
	}
	
	///	@ignore
	static get = function(_other_name)
	{
		__saveFile = _other_name ?? __saveFile;
		return (files[$ __saveFile] );	
	}
}

function memo_create(_filename)
{
	memo().create(_filename);	
}

function memo_set(_filename, _key, _value)
{	
	var _use = memo().get(_filename);
	_use[? _key] = _value;
}

function memo_get(_filename, _key)
{
	var _use = memo().get(_filename);
	return (_use[? _key] );
}

function memo_save()
{
	ds_map_secure_save(memo().get(), memo().__saveFile);	
}

function memo_load()
{	
	var _savefile = memo().__saveFile;
	
	if (file_exists(_savefile) )
	{
		// Eliminar mapa
		ds_map_destroy(memo().get() );
		memo().files[$ _savefile] = ds_map_secure_load(_savefile);	// Cargar un nuevo mapa
	}
}

/// @desc Regresa el filename en que se encuentra
function memo_get_filename()
{
	return (memo().__saveFile);
}