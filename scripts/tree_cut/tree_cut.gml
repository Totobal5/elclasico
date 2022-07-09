/// @param {Struct.Tree}	tree
/// @param {String}			[id]
/// @desc Convierte una rama en un tronco sacandola del tronco principal
/// @return {Struct.Tree} Rama eliminada
function tree_cut(_tree, _id) 
{
	// Agrega una nueva hoja a la rama seleccionada
	if (!is_tree(_tree) ) show_error("El arbol o rama no existen", true)
	
	if (is_undefined(_id) )
	{
		// Convertir el _tree
		_tree.remove(_tree.__id);
		return (_tree.__makeRoot() );
	}
	else
	{
		// Buscar y convertir
		var _conv = (_tree.remove(_id) );
		if (is_tree(_conv) ) return (_tree.__makeRoot() );
	}
	
	return undefined;	
}