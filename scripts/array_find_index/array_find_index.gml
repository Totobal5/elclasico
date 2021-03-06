/// @param {Array}		array_index (Contiene structs)
/// @param {Function}	method function(value, i) {return index or -1}
/// @desc Se pasa un metodo en él se debe indicar si se encontro un valor o no. Devuelve el indice
/// @return {Real}
function array_find_index(_array, _f) 
{
	gml_pragma("forceinline");
	var i=0; repeat(array_length(_array) ) 
	{
		if (_f(_array[i], i) ) return i;
		i++;
	}
	
	return -1;	
}
