/// @param {Array} array_index
/// @param method function(value, i)
/// @desc Devuelve un array a travez de una función establecida
/// @returns {Array<Any>}
function array_map(_array, _f) 
{
	gml_pragma("forceinline");
	var _return = [];
	var i=0; repeat(array_length(_array) ) 
	{
		var _get = _f(_array[i], i);
		array_push(_return, _get);
		++i;
	}
	
	return _return;
}