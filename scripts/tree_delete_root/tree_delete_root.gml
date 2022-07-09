/// @param {Struct.Tree}	tree
/// @param {String}			id
/// @desc Elimina una rama del arbol seleccionado buscando desde el root
/// @return {Struct.Tree} Rama eliminada
function tree_delete_root(_tree, _id) 
{
	// Agrega una nueva hoja a la rama seleccionada
	if (!is_tree(_tree) ) show_error("El arbol o rama no existen", true)
	
	return (_tree.removeGlobal(_id) );
}