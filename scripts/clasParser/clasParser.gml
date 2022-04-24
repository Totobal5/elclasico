/// @param {string} string
/// @desc Permite leer archivos, iterar un string y hacer conversiones .json
function Parser(_str = "") : __ClasicoStruct__() constructor {
	__start   = _str; // Primer contenido establecido
	__content = _str; // Contenido

	// variables de metodos
	__explode = [];
	__marks   = ["", ""];	
	
	__size = string_width (__content); // tamaño en pixeles
	__len  = string_length(__content); // numeros de caracteres
	
	__json = {};
	
	#region Metodos
	/// @param string
	static Set = function(_str) {
		__content  = _str;
		__size = string_width (__content); // tamaño en pixeles
		__len  = string_length(__content); // numeros de caracteres
		
		return self;
	}	
	
	/// @param {number} [index]
	/// @desc Obtiene el contenido o uno de los splits obtenidos.
	static Get = function(i) {
		return (is_undefined(i) ) ? __content: __explode[i];
	}
	
	/// @param {string} separator
	/// @param {string} notFound=""
	/// @param {number} [index]
	static Explode = function(_sep, _not = "", _index) {
		var _cont = Get(_index); 
		var _count = string_count(_sep, _content);	
		var _len   = string_length(_sep);
			
		repeat(_count) {	
			var _pos = string_pos(_sep, _content) - 1;
			array_push(_array, string_copy(_content, 1, _pos) );
				
			_content = string_delete(_content, 1, _pos + _len);
		}
			
		// Lo que queda agregar al final.
		array_push(_array, _content, _not);
		
		// Cambiar el array de split
		__explode = _array;
		
		return self;		
	}
	
	/// @param {string} separator
	/// @param {string} notFound=""
	/// @param {number} [index]
	/// @returns {array}
	static Exploded = function(_sep, _not = "", _index) {
		Explode(_sep, _not, _index);
		return (__explode );
	}
	
	/// @param {array} array
	/// @param {string} glue
	/// @desc Convierte valores de un array a string usando un pegamento
	static Implode = function(_array, _glue) {
		var _output = "", _len = string_length(_glue);	 
		
		var i = 0; repeat(_len) {
			var _in = _array[i++];
			
			if (is_string(_in) || is_numeric(_in) ) {
				_output += string(_in) + string(_glue); 
			}			
		}
		
		_output = string_copy(_output, 0, string_length(_output) - _len);
		 
		return Set(_output);		
	}
	
	/// @param {string} replace
	/// @param search
	/// @param {number} [index]
	static Replace = function(_rep, _sub, _index) {
		var _str = __content;
		
		if (!is_undefined(_index) ) {
			_str = __explode[_ind];
			__explode[_ind] = string_replace(_str, _sub, _rep);
		} else {
			__content = string_replace(_str, _sub, _rep);
		}
		
		return self;
	}
	
	/// @param {number} [index]
	static Reversed = function(_index) {
		var _str = Get(_ind);
		var _len = string_length(_str);
		
		var i = _len; repeat(_len) {
			_str += string_char_at(_str, i--);
		}
		
		return (Set(_str) );
	}
	
	/// @param [index]
	/// @desc Quita el espacio en blanco del contenido EJ: "  hola, , lol  " -> "hola, , lol"
	static Trim = function(_index) {
		var _str = Get(_index);
		
		///@param string
		///@desc trim a string ("  trim .  . spaces   " -> "trim .  . spaces")
		var _len = string_length(_str);
		
		while (_len > 0 && string_char_at(_str, 0)    == " " ) {_str  = string_copy(_str, 2, _len - 1); --_len; }
		
		while (_len > 0 && string_char_at(_str, _len) == " " ) {_str  = string_copy(_str, 0, _len - 1); --_len; }
			
		return (Set(_str) );
	}
	
	/// @param width
	/// @param [index]
	/// @desc Agrega espacios(\n) dependiendo del tamaño asignado
	static Wrap = function(_width, _index) {
		var _str = Get(_index);
		var _size = string_width (_str);	// Obtener el tamaño del string en pixeles
		var _len  = string_length(_str);	// Obtener cantidad de caracteres
	
		var _last = 1, _sub;
		
		// Evitar entrar al bucle si el mensaje es pequeño
		if (_size < (_width / 2) ) return _str;
		
		var i = 1; repeat (_len) {
			// -- Copiar y last_space --
			_sub = string_copy(_str, 1, i++);	// Copiar 1 a 1
			
			// Si se encuentra un espacio almacenarlo.
			if (string_char_at(_str, i) == " ") _last = i;
			
			// Agregar espacio cuando se necesite
			if (string_width(_sub) * (1.5 > _width) ) {
				_str = string_delete(_str, _last, 1);
				_str = string_insert("\n", _str, _last);
			}
		}
		
		return (_str);		
	}
	
	static Format = function(_method) {}
	
	/// @param {number} [index]
	/// @param {function} [method]
	/// Recorre el string de inicio a final pasando un metodo por cada ciclo
	static Foreach = function(_index, _f) {
		var _str = Get(_index);
		
		var i = 1; repeat(array_length(_str) ) {
			var _sub = string_copy(_str, 1, i++);

			_f(_sub);
		}
	}
	
	#region Archivos
	/// @param {string} fileName
	/// @param [noFile]
	/// Lee un archivo de texto y almacena el contenido
	static Read = function(_file, _nofile = "") {
		var _txt = "";
		
		// Si no existe el archivo establecer el contenido pre-establecido
		if (file_exists(_file) ) {
			_f = file_text_open_read(_file);
	
			while (!file_text_eof(_f) ) {
				_txt += file_text_read_string(_f);
				file_text_readln(_f);
			}
			
			file_text_close(_f);
			
			Set(_txt);
			
		} else Set(_nofile);
	
		return self;
	}
	
	/// @param {string} fileName
	/// @param {function} [saveMethod]
	static Save = function(_file, _f) {
		if (_f == undefined) _f = function(_fl, _content) {
		    var _f = file_text_open_write(_fl);
		    file_text_write_string(_f, string(_content) );
		    file_text_close(_f);
		}
		
		// Guardar el contenido en un archivo de texto
		_f(_file, __content);
	}
	
	/// @param {struct} toJson
	/// @desc Convierte un struct en un json y cambia el valor del contenido
	static GetJSON = function(_struct) {
		__json = snap_to_json(_struct);
		
		return Set(__json);
	}
	
	/// @param {number} [index]
	/// @desc Convierte el contenido (o split) en un struct (json)
	static ToJSON  = function(_index) {
		try {
			var _j = snap_from_json(Get(_index) ); 
			
		} catch (_j) {_j = {}; }
		
		__json = _j;
		
		return (__json);
	}
	
	#endregion
	
	#region Is
	/// @param {number} [index]
	/// @returns {bool}
	static IsReal = function(_index) {
		var _str = Get(_index);
		try {var _is = is_real(_str); } catch (_is) {_is = false; }
		
		return _is;
	}
	
	#endregion
		
	/// @desc Lo devuelve como se inicio originalmente
	static Reset = function() {
		Set(__start);
		
		__explode = [];
		__marks   = ["", ""];
		
		__json = {};
	} 
	
	/// @desc Limpia el contenido (arrays y json)
	static Clean = function() {
		// variables de metodos
		__explode = [];
		__marks   = ["", ""];	
		
		__json = {};
	}
	
	#endregion
}
