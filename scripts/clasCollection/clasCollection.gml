/// @desc	Es un tipo de coleccion de datos que utiliza un struct para guardar contenidos y un array para guardar las llaves
///			Permite realizar ciertas acciones más rapido
/// @return {Collection}
function Collection() : __ClasicoStruct__() constructor {
	#region PRIVATE

	/// @is {struct}
	__content = {};	// Guardar los valores
	
	/// @is {array}
	__keys = [];
	
	/// @ignore
	__last  = 0;	// Ultimo indice en ciclo
	__cicle = 0;	// Para el ciclo
	
	/// @ignore
	__size = 0;
	
	#endregion
	
	#region METHODS
	
	/// @param {string} key
	/// @param value
	/// @desc Añade un nuevo valor a la coleccion
	/// @returns {Collection}
	static Set = function(key, value) {
		if (!Exists(key) ) {
			array_push(__keys, key);
			__size = array_length(__keys);
		}
		
		__content[$ key] = value;
		
		return self;
	}

	/// @param value
	/// @desc Establece todos los valores de la coleccion a un valor especificado
	/// @returns {Collection}
	static All = function(value) {
		var i=0; repeat(__size) Set(__keys[i++], value);
		return self;
	}
	
	/// @param {string} key
	/// @return {bool}
	static Exists = function(_key) {
		return (variable_struct_exists(__content, _key) );
	}
	
	/// @param {string|number|array} [use]
	/// @returns {array|string} Devuelve la llave
	static Remove = function(use) {
		var _delete = undefined;

		if (is_numeric(use) ) {
			#region Indice
			_delete = __keys[use];
			variable_struct_remove(__content, _delete);
			
			// Remover
			array_delete(__keys, use, 1);		
			#endregion
		}
		else if (is_string(use) ) {
			#region Llave
			var _index = Search(use);
			
			if (_index >= 0) {
				// Remover contenido del struct
				variable_struct_remove(__content, _key);
				
				// Remover
				_delete = __keys[_index];
				array_delete(__keys, _index, 1);
			}
			#endregion
		}
		else if (is_array(use) ) {
			#region Array de elementos
			_delete = [];
			
			for (var i=0, len=array_length(use); i<len; i++) {
				var _in = Remove(use[i] );
				// Eliminado
				if (_in != undefined) array_push(_delete, _in);
			}
			
			#endregion
		}

		// Obtener tamaño
		__size = array_length(__keys);
		
		return _delete;
	}
	
	#region GET´S
	/// @param {string|number} key	Llave o indice para obtener el valor
	static Get = function(_key) {
		return (is_string(_key) ? 
			__content[$ _key] : 
			__content[$ __keys[_key] ] 
		);	
	}
	
	/// @param {bool} [content?] Devolver contenido (true) o llave(false)
	/// @desc Devuelve el primer valor de la coleccion 
	static PeekIn = function(content=true) { 
		var _first = __keys[0];
		return content ? __content[$ _first] : _first;  
	}
	
	/// @param {bool} [content?] Devolver contenido (true) o llave(false)
	/// @desc Devuelve el ultimo valor de la coleccion 	
	static PeekOut = function(content=true) { 
		var _last = __keys[__size - 1];
		return content ? __content[$ _last] : _last;  
	}
	
	/// @desc Devuelve el ultimo valor de la coleccion y lo elimina
	static Pop = function() {
		var _last = PeekOut();
		Remove(__size - 1);
		return _last;
	}
	
	/// @desc Devuelve el primer valor de la coleccion y lo elimina
	static Shift = function() {
		var _first = PeekIn();
		Remove();
		return _first;
	}
	
	/// @param {bool} [content?] Devolver contenido (true) o llave(false)
	/// @desc Cicla los valores de la coleccion (izq->der)
	static Cicle = function(content=true) {
		return content? 
			__content[$ __keys[__cicle++] ] :
			__keys[__cicle++];
	}
	
	#endregion
	
	/// @desc Devuelve el indice de la llave
	/// @param {string|array} key
	static Search = function(_key) {
		// No existe salir rapido
		if (!Exists(_key) ) return undefined;
		
		var i=0 repeat(__size) {
			var _in = __keys[i++];
			if (_in == _key) return true;
		}
		
		return false;
	}

	/// @desc Devuelve el tamaño de la coleccion
	/// @param {bool} [resetCicle]
	/// @return {number} 
	static Size = function(_reset = false) {
		if (_reset) __cicle = 0; // Para ciclar
		return (__size);
	}
	
	/// @desc True: Esta vacio False: tiene contenido
	/// @return {bool}
	static Empty = function() {
		return (__size == 0); 
	}
	
	/// @return {Collection} 
	/// @desc Reinicia los valores de la coleccion
	static Clear = function() {
		__content = {};
		__keys = [];
		
		__last = 0;
		__size = 0;
		
		return self;
	}
		
	/// @return {Collection}
	static Copy = function() {
		var _collection = (new Collection() ); /// @is {Collection}

		// Devolver valores
		var i = 0; repeat(__size) {
			var _key = __keys[i++];
			var _val = Get(_key);
			
			_collection.Set(_key, _val);
		}
		
		return (_collection);
	}
	
	/// @returns {string}
	static toString = function() {
		return "size: " + string(__size);
	}
	
	#endregion
}
