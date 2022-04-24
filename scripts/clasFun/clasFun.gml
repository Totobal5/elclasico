#macro __CLASICO_VERSION "1.1.0"
#macro __CLASICO_PREFIX "[Clasico]"
#macro __CLASICO_SHOW false

#macro timer_start	var time1, time2; time1 = get_timer();
#macro timer_end	time2 = get_timer(); show_debug_message("time: " + string( (time2 - time1) / 1000) + " [ms]");

#macro RANCOLOR make_color_rgb(irandom(255), irandom(255), irandom(255) )
#macro print show_debug_message

#macro DELTA		 (delta_time / 1000000) * global.__delta_scale
#macro DELTA_SECOND	 DELTA * game_get_speed(gamespeed_fps)

global.__delta_scale = 1;

#region Instancias
/// @param {instance} id
/// @param {object} object
/// @param {bool} [descendant?]
/// @desc Comprueba si una instancia es un objeto o descendiente
function instance_object(_id, _obj, _check = false) {
	with (_id) {
		return (is_object(_obj, _check) );
	}
}

/// @param {object} object
/// @desc Devuelve un array de todas las instancias del objeto en el cuarto
function instance_to_array(_obj) {
	var _array = [];
	
	with (_obj) array_push(_array, id);
	
	return (_array);
}

/// @param object
/// @param direction
/// @param distance
/// Detecta objetos en una direccion y devuelve una lista con los que encontró (la lista no hay que borrarla)
function instance_detect(_object, _dir, _dis) {
	static list = ds_list_create();
	
	var _len = -1;
	var x_offset = abs(sprite_xoffset - (sprite_width  / 2) );
	var y_offset = abs(sprite_yoffset - (sprite_height / 2) );
	
	// Dependiendo de la direccion
	switch(_dir) {
		case 90 :	_len = collision_line_list(x + x_offset, y - y_offset, x + x_offset, y - (y_offset + _dis) , _object, false, true, list, true);   break; //Arriba
		case 0  :	_len = collision_line_list(x + x_offset, y - y_offset, x + (x_offset + _dis), y - y_offset , _object, false, true, list, true);   break; //Derecha
		case 180:	_len = collision_line_list(x + x_offset, y - y_offset, x - (x_offset + _dis), y - y_offset , _object, false, true, list, true);   break; //Izquierda
		case 270:   _len = collision_line_list(x + x_offset, y - y_offset, x + x_offset, y + (y_offset - _dis) , _object, false, true, list, true);   break; //Abajo
 
		default: show_debug_message("Error Actores: Direccion mal usada" ); break;
	}

	return [list, _len];
}

/// @param {instance} instance
/// @param {number} x_offset
/// @param {number} y_offset
function stick_to(_ins, _x=0, _y=0) {
	x = _ins.x + _x;
	y = _ins.y + _y;
}

/// @param {instance} instance
/// @param {number} x_offset
/// @param {number} y_offset
/// @param {number} angle_offset
function stick_to_angle(_ins, _x=0, _y=0, _angle=0) {
	var _dis = point_distance (_ins.x, _ins.y, _ins.x + _x, _ins.y + _y);
	var _dir = point_direction(_ins.x, _ins.y, _ins.x + _y, _ins.y + _y);
	
	// Pos
	x = _ins.x + lengthdir_x(_dis, _dir + _ins.image_angle);
	y = _ins.y + lengthdir_y(_dis, _dir + _ins.image_angle);
	
	// Angulo
	image_angle = _ins.image_angle + _angle;
}

#endregion

#region Is

/// @param room
/// @returns {bool}
function is_room(_room) {
	return (room == _room);
}

/// @param object
/// @param [descendant?]
/// @returns {bool}
/// @desc Comprueba si esta instancia es un objeto o descendiente
function is_object(_obj, _check = false) {
	return (object_index == _obj) || (_check && object_is_ancestor(object_index, _obj) );
}

/// @returns {bool}
/// @desc Comprueba si unas cordenadas se encuentran entre un rango establecido
function is_here(_x, _y, _x1, _y1, _x2, _y2) {
	return ((_x > _x1) && (_x < _x2) && (_y > _y1) && (_y < _y2) );
}

/// @param {Vector2} Vector2
/// @returns {bool}
function is_vector2(_vec2) {
	return (is_struct(_vec2) && (_vec2.__is == Vector2) );
}

/// @param {Line} line
/// @returns {bool}
function is_line(_line) {
	return (is_struct(_line) && (_line.__is == Line) );	
}

/// @param {Rectangle} rectangle
/// @returns {bool}
function is_rectangle(_rect) {
	return (is_struct(_rect) && (_rect.__is == Rectangle) );	
}

/// @param {Parser} parser
/// @returns {bool}
function is_parser(_parser) {
	return (is_struct(_parser) && (_parser.__is == Parser) );	
}

/// @param {Collection} collection
/// @returns {bool}
function is_collection(_collection) {
	return (is_struct(_collection) && (_collection.__is == Collection) );
}

#endregion

#region Math
/// @param {number} a
/// @param {number} b
/// @param {number} step
/// @returns {number}
function approach(a, b, _step) {
	if (a < b){
		return min (a + abs(_step), b);
	} else {
		return max (a - abs(_step), b);
	}
}

/// @param {number} value
/// @param {number} min
/// @param {number} max
/// @returns {number}
/// @desc Si valor es menor que minimo devuelve maximo y si valor es mayor que maximo devuelve minimo.
function clip(_val, _min, _max) {
	// Ir más rapido
	if (_val > _max) {return _min; } else 
	if (_val < _min) {return _max; }
	
	return (_val);
}

/// @param value
/// @param range_a
/// @param range_b
/// @returns {bool}
/// @desc Si un valor se encuentra entre a y b
function between(_val, _ra, _rb) {
	return (min(_ra, _rb) < _val && _val < max(_ra, _rb));
}

#endregion

#region String

/// @param {number} repeats
/// @desc Establece caracteres al azar
function string_random_symbol(_rep) {
	var _sym1 = irandom_range(32, 47);		// !"#$%&'()*+,-./
	var _sym2 = irandom_range(58, 64);		// :;<=>?@
	
	var _txt = ""; repeat(_rep) _txt += chr(choose(_sym1, _sym2) );
	
	return _txt;
}

/// @param {number} repeats
/// @desc Establece letras al azar
function string_random_letter(_rep) {
	var _letter1 = irandom_range(65,  90);
	var _letter2 = irandom_range(97, 122);
	
	var _txt = ""; repeat(_rep) _txt += chr(choose(_letter1, _letter2) );		
	
	return _txt;
}

/// @param {number} repeats
/// @desc Establece caracteres y letras al azar
function string_random(_rep = 1) {
	var _txt = ""; repeat(_rep) {
		var _symbol = string_random_symbol(1); 
		var _letter = string_random_letter(1);
		
		_txt += choose(_symbol, _letter);
	}
	
	return (_txt);
}

/// @param {number} seconds
function string_time_hms(_seconds) {
	var _hours		= _seconds div 3600;
	_seconds		= _seconds mod 3600;
	var _minutes	= _seconds div 60;
	_seconds		= _seconds mod 60;
    
	return    ((_hours   div 10) > 0 ? "" : "0") + string(_hours  ) + ":"
	        + ((_minutes div 10) > 0 ? "" : "0") + string(_minutes) + ":" 
	        + ((_seconds div 10) > 0 ? "" : "0") + string(floor(_seconds));
}

/// @param halign
/// @returns {string}
function halign_to_text(_h) {
	switch (_h) {
		case fa_left :	return "fa_left";	break;
		case fa_right:	return "fa_right";	break;
		case fa_center: return "fa_center";	break;	
	}
}

/// @param valign
/// @returns {string}
function valign_to_text(_v) {
	switch (_v) {
		case fa_top:		return "fa_top";		break;
		case fa_bottom:		return "fa_bottom";		break;
		case fa_middle:		return "fa_middle";		break;
	}
}

/// @param {string} halign
/// @returns {number}
function halign_from_text(_h) {
	switch (_h) {
		case "fa_left" :	return fa_left;		break;
		case "fa_right":	return fa_right;	break;
		case "fa_center":	return fa_center;	break;	
	}	
}

/// @param {string} valign
/// @returns {number}
function valign_from_text(_v) {
	switch (_v) {
		case "fa_top":		return fa_top;		break;
		case "fa_bottom":	return fa_bottom;	break;
		case "fa_middle":	return fa_middle;	break;
	}
}

#endregion

#region Percent
/// @param {number} percent
/// @returns {bool}
function percent_chance(_percent) {
	return (random(100) <= _percent);
}

/// @param {number} percent
/// @param {number} winner	Si obtiene el porcentaje este valor es devuelto
/// @param {number} loser	Valor si no se obtiene
function percent_set(_percent, _winner, _loser) {
	return (percent_chance(_percent) ) ? _winner : _loser;
}

/// @param percent
/// @returns {number}
function percent_between(_percent) {
	return (_percent - random(_percent) ) / max(0.01, _percent);
}

#endregion

#region DS Types

/// @param {ds_list} list
/// @returns {array}
function ds_list_to_array(_list) {
	var _size  = ds_list_size(_list);
	var _array = array_create(_size);
	
	var i=0; repeat(_size) {
		_array[i] = _list[| i++];
	}
	
	return (_array);
}

/// @param {ds_list}
/// @returns {ds_map}
/// @desc Medio hack
function ds_list_to_map(_list) {
	var _map  = ds_map_create();
	var _size = ds_list_size(_list);
	
	var i = 0; repeat(_size) _map[? i] = _list[| i++];
	return (_map);	
}

#endregion

#region Drawing

/// @param x
/// @param y
function draw_crosshair(_x, _y) {
	draw_line(0, _y, display_get_gui_width(), _y);
    draw_line(_x, 0, _x, display_get_gui_height() );
}

/// @param size
function draw_grid(_size) {
	var _w = display_get_gui_width ();
	var _h = display_get_gui_height();

	for(var i=0; i<= max(_w, _h); i += _size) {
	     draw_line(0, i, _w, i);
	     draw_line(i, 0, i, _h);
	}	
}

#endregion

#region Other
/// @param {number} x1
/// @param {number} y1
/// @param {number} x2
/// @param {number} y2
/// @returns {bool}
/// @desc True si el mouse esta en la region rectangular x1,y1: top left | x2,y2: right bottom 
function mouse_is_here(_x1, _y1, _x2, _y2) {
	return ((mouse_x > _x1) && (mouse_x < _x2) && (mouse_y > _y1) && (mouse_y < _y2) );
}

/// @return {bool} True si el mouse esta en la bounding box de la instancia.
function mouse_over() {
	return (
		mouse_x >= bbox_left	&&
	    mouse_x <= bbox_right	&&
	    mouse_y >= bbox_top		&&
	    mouse_y <= bbox_bottom
	);
}

/// @param {weak_reference} weak_reference
function weak_get(_weak) {
	return (_weak.ref);
}

/// @param index
/// @param value
/// @param [seconds?]
/// @param [instance]
function alarm_delay(_index, _value, _seconds=false, _ins=id) {
	if (_ins == undefined) {
		if (alarm_off(_index) ) {
			alarm[_index] = _seconds ? _value * delta_second : _value * delta;
		}
	}
	else with (ins) alarm_delay(_index, _value, _seconds, id);
}

/// @param index
/// @returns {bool}
function alarm_off(index) {
	return (alarm[index] == -1);	
}

#endregion



