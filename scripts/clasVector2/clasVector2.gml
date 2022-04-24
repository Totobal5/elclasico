enum VEC2_DIR {
	UP, LEFT, RIGHT, DOWN
}

/// @param {number} x=0
/// @param {number} y=0
/// @returns {Vector2}
function Vector2(_x = 0, _y = 0) : __ClasicoStruct__() constructor {
	#region PRIVATE
	__xo = 0; /// @is {number} Origen x
	__yo = 0; /// @is {number} Origen y
	
	#endregion
	
	#region PUBLIC
	x = _x;
	y = _y;
	
	#endregion

	#region METHODS
	
	#region Basic
	/// @param x
	/// @param y=x
	/// @desc Establece el origen
	static SetOrigin = function(_x, _y=_x) {
		__xo = _x;
		__yo = _y;
		
		return self;
	}
	
	/// @returns {bool} 
	/// @desc indica si se encuentra en el origen
	static InOrigin = function() {
		return (x == __xo) && (y == __yo);
	}		
	
	/// @desc X e Y a 1
	static One  = function() {
		x = 1; y = 1;
		return self;
	}
	/// @desc X e Y a 0
	static Zero = function() {
		x=0; y=0;
		return self;
	}
	/// @desc X e Y a negativo
	static Negative = function() {
		x *= -1; y *= -1;
		return self;
	}
	/// @desc X e Y absolutos
	static Absolute = function() {
		x = abs(x); y = abs(y);
		return self;
	}
	
	#endregion
	
	#region Posicionar
	/// @param {number|Vector2} x
	/// @param {number} y=x
	static SetXY = function(_x, _y=_x) {
		if (is_vector2(_x) ) {
			x = _x.x;		
			y = _y.y;	
		} 
		else {
			x = _x;	
			y = _y;
		}
		
		return self;
	}
	
	/// @param {number|Vector2} x
	static SetX  = function(_x) {
		x = (!is_vector2(_x) ) ? _x : _x.x;
		
		return self;
	}
	
	/// @param {number|Vector2} y	
	static SetY  = function(_y) {
		y = (!is_vector2(_y) ) ? _y : _y.y;
		
		return self;
	}
	
	/// @param {number|Vector2} x
	/// @param {number} y=x
	/// @returns {Vector2}
	static With = function(_x, _y=_x) {
		return (Copy() ).SetXY(_x, _y);
	}
	
	/// @param {number|Vector2} x
	/// @returns {Vector2}
	static WithX = function(_x) {
		return (Copy() ).SetX(_x);
	}
	
	/// @param {number|Vector2} y
	/// @returns {Vector2}
	static WithY = function(_y) {
		return (Copy() ).SetY(_y);		
	}
	
	#endregion
	
	#region Operaciones
	/// @param {number|Vector2} x=0	posicion horizontal o vector2
	/// @param {number} 		y=x	posicion vertical
	static Add = function(_x=0, _y=_x) {
		if (!is_vector2(_x) ) {
			x += _x;
			y += _y;
		}
		else {
			x += _x.x;	
			y += _x.y;
		}
		
		return self;
	}

	/// @param {number|Vector2} x=1
	/// @param {number} 		y=x
	static Multiply = function(_x=1, _y = _x) {
		if (!is_vector2(_x) ) {
			x *= _x;	
			y *= _y;	
		}
		else {
			x *= _x.x;
			y *= _x.y;
		}
		
		return self;
	}
	
	/// @param {number|Vector2} x=1
	/// @param {number} 		y=x
	static Division = function(_x, _y = _x) {
		if (!is_vector2(_x) ) {
			x /= max(1, _x);	
			y /= max(1, _y);	
		}
		else {
			x /= max(1, _x.x);
			y /= max(1, _x.y);
		}
		
		return self;
	}
	
	#endregion
	
	#region Gets
	/// @returns {number}
	/// @desc Devuelve la longitud desde el origen.
	static Length = function() {
		return (point_distance(__xo, __yo, x, y) );
	}
	
	/// @param {number|Vector2} x
	/// @param {number} [y]
	/// @desc Devuelve la longitud desde un punto
	static LengthTo = function() {
		if (is_vector2(argument0) ) {
			return (point_distance(x, y, argument0.x, argument0.y) );		
		}
		else {
			return (point_distance(x, y, argument0, argument1) );
		}
	}
	
	/// @returns {number}
	static Angle = function() {
		return darctan2( (__yo - y) , (__xo - x) ); 
	}

	/// @returns {number}
	static GetAngle = function() {
		return darctan(y / x); 
	}
	
	/// @param {number|Vector2} x
	/// @param {number} [y]
	static AngleTo = function() {
		if (is_vector2(argument0) ) {
			return darctan2( (argument0.y - y) , (argument0.x - x) );
		}
		else {
			return darctan2( (argument1 - y) , (argument0 - x) );	
		}
	}
	
	/// @param {number} delta_x=0
	/// @param {number} delta_y=delta_x
	/// @returns {Vector2}
	static Translated = function(_dx=0, _dy=_dx) {
		return (new Vector2(x, y) ).Add(_dx, _dy);
	}

	/// @param {number|Vector2} x
	/// @param {number} [y]
	static Cross = function(_x, _y) {
		if (is_vector2(_x) ) {
			return ((x * _x.x) - (y * _x.y) );
		}
		else {
			return ((x * _y) - (y * _x) );	
		}
	}

	/// @param {number|Vector2} x
	/// @param {number} [y]
	/// @returns {number}
	static Dot = function(_x, _y) {
		if (is_vector2(_x) ) {
			return dot_product(x, y, _x.x, _x.y);
		}
		else {
			return dot_product(x, y, _x, _y);
		}
	}
	
	// SignTest(_Ax, _Ay, _Bx, _By, _Lx, _Ly) {
	// 	return ((_Bx - _Ax) * (_Ly - _Ay) - (_By - _Ay) * (_Lx - _Ax));
	// }
	
	/// @returns {Vector2}
	static Normalized = function() {
		var len = Length();
		
		return (new Vector2( (x - __xo) / len, (y - __yo) / len) );
	}

	#endregion
	
	#region Directions
	/// @param {VEC2_DIR} direction
	/// @param {number} value
	static DirAdd = function(_dir, _value) {
		switch (_dir) {
			case VEC2_DIR.UP:		y += _value;	break;
			case VEC2_DIR.LEFT:		x -= _value;	break;
			case VEC2_DIR.RIGHT:	x += _value;	break;
			case VEC2_DIR.DOWN:		y -= _value;	break;
		}
		
		return self;
	}
	
	/// @param {VEC2_DIR} direction
	/// @param {number} value
	static DirMult = function(_dir, _value) { 
		switch (_dir) {
			case VEC2_DIR.UP:		y *=  _value;	break;
			case VEC2_DIR.LEFT:		x *= -_value;	break;
			case VEC2_DIR.RIGHT:	x *=  _value;	break;
			case VEC2_DIR.DOWN:		y *= -_value;	break;
		}
		
		return self;		
	}
	
	#endregion
	
	/// @returns {string}
	static toString = function() {
		return "x: " + string(x) + "\n y: " + string(y);
	}
	/// @returns {array}
	static toArray  = function() {
		return [x, y];
	}
	/// @returns {ds_list}
	static toList   = function() {
		var _list = ds_list_create();
		ds_list_add(_list, x, y);
		return (_list);
	}
	
	/// @returns {Vector2}
	static Copy = function() {
		return (new Vector2(x, y) );
	}

	#endregion
}


