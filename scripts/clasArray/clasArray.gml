/// @param {Array} array 
/// @return {bool}
function array_empty(_array) {
	return (array_length(_array) == 0); 
}

/// @param {array} array
/// @desc Devuelve el ultimo elemento de un array
function array_peek(_array) {
	if (array_empty(_array) ) return 0;
	return (_array[array_length(_array) - 1] );
}

/// @param {array} array
/// @desc Extrae el primer elemento de un array
function array_shift(_array) {
	var _temp = _array[0];
	array_delete(_array, 0, 1);
	return _temp;
}

/// @param {array} array
/// @param ...values
/// @desc Agrega un dato al inicio del array.
function array_unshift(_array) {
	var i=0; repeat(argument_count)	{
		array_insert(_array, 0, argument[i++] );
	}
}

/// @param {Array} array
/// @returns {number} Devuelve el menor numero en un array
function array_min(_array) {
	var _temp = undefined;
	
	if (!array_empty(_array) ) {
		_temp = _array[0];
		var i=1; repeat(array_length(_array) - 1) {
			var _in = _array[i++];
			_temp = min(_temp, _in);
		}
	}
	
	return (_temp);
}

/// @param {Array} array
/// @returns {number} Devuelve el mayor numero en un array
function array_max(_array) {
	var _temp = undefined;
	
	if (!array_empty(_array) ) {
		_temp = _array[0];
		var i=1; repeat(array_length(_array) - 1) {
			var _in = _array[i++];
			_temp = max(_temp, _in);
		}
	}
	
	return (_temp);
}

/// @param size1
/// @param size2
/// @param ....
/// @Sahaun make it
function array_create_nd() {
    if (argument_count == 0) return 0;
    
    var _array = array_create(argument[0]),
        _args  = array_create(argument_count-1),
        _i;
        
    _i = 0; repeat(argument_count-1) {
        _args[@ _i] = argument[_i+1];
        ++_i;
    }
    
    _i = 0; repeat(argument[0]) {
        _array[@ _i] = script_execute_ext(array_create_nd, _args);
        ++_i;
    }
    
    return _array;
}

/// @param {array} array
/// @returns {array} Devuelve un array al revez
function array_reverse(_array) {
	var _rev = [];
	var _len = array_length(_array);
	
	var i=0; repeat(_len) {
		array_push(_rev, _array[(_len - 1) - i++] ); 
	}
	
	return _rev;
}

/// @param {array} array
/// @param {number} source
/// @param {number} destination
/// @desc Intercambia valores entre un index y otro
function array_swap(_array, _i, _j) {
	var _temp = _array[_i];
	
	_array[@ _i] = _array[_j];
	_array[@ _j] = _temp;
}

/// @param {array} array
/// @desc Intercambia los valores en el array de forma aleatoria
function array_shuffle(_array) {
	var _len  = array_length(_array);
	var _seed = random_get_seed();	
	randomize();
	
	repeat (_len) array_swap(_array, irandom(_len), irandom(_len - 1) ); 
	random_set_seed(_seed);
}

/// @param {array} array
/// @param method function(value, i)
/// @desc Ejecuta una funcion por cada elemento de array
function array_foreach(_array, _f) {
	var i=0;repeat(array_length(_array) ) {
		_f(_array[i], i++);
	}
}

/// @param {array} array
/// @param method function(value, i)
/// @desc Devuelve un array a travez de una función establecida
/// @returns {array}
function array_map(_array, _f) {
	var _return = [];
	var i=0; repeat(array_length(_array) ) {
		array_push(_return, _f(_array[i], i++) );
	}
	
	return _return;
}

/// @param {array} array (Contiene structs)
/// @param method function(value, i)
function array_find(_array, _f) {
	var i=0; repeat(array_length(_array) ) {
		var _in = _array[i];
		if (_f(_in, i) ) return _in;
		i++;
	}
	
	return false;	
}

/// @param {array} array (Contiene structs)
/// @param method function(value, i)
function array_find_index(_array, _f) {
	var i=0; repeat(array_length(_array) ) {
		if (_f(_array[i], i) ) return i;
		i++;
	}
	
	return -1;	
}
