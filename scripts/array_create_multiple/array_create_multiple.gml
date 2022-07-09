/// @param size1
/// @param size2
/// @param ....
/// @desc Crea un array con multiples arrays de otros tamaños.
function array_create_multiple() 
{
	gml_pragma("forceinline");
	if (argument_count > 0)
	{
		var _array = array_create(argument[0]);	
			
		var i=1; repeat(argument_count - 1)
		{
			var _size = argument[i];
			if (is_real(_size) )
			{
				_array[i] = array_create(argument[i]);
			}
			
			++i;
		}
	}
	
	return [];
}