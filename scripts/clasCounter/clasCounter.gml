/// @param {number} start=0
/// @param {number} end=1
/// @param {number} amount=1
/// @param [iterateTime]
/// @param {array} [options] iterate:bool, repeat:bool, active:bool
function Counter(_start=0, _end=1, _amount=1, _iterateTime = undefined, _options) : __ClasicoStruct__() constructor {
	#region PRIVATE
	if (_options == undefined) _options = [false, false, false];
	__arg = {s: _start, e:_end, a: _amount, i:_iterateTime, o:_options};
	
	__active = _options[2];	// Si esta activo puede trabajar
	__repeat = _options[1];	// Si al terminar reinicia el valor de la cuenta
	
	__count  = _start; // Valor de la cuenta
	
	__min = _start; // Minimo valor de cuenta
	__max = _end;	// Maximo valor de cuenta

	__amount = _amount; // Cada cuanto aumenta el valor de la cuenta
	
	__iterate = _options[0];
	__iterateTime = _iterateTime; // Cuantas iteracciones trabajará. undefined: indefinidamente
	
	#endregion
	
	#region METHODS
	
	/// @desc Trabajar como contador
	static Count = function() {
		if (!__active) return false;
	
		__count += __amount;
		
		if (__count >= __max) {
			if (__iterateTime > 1) {
				// Si hay que repetir
				__active = __repeat;
				__count  = __min * __repeat;	// Reiniciar contador si repite
				
				if (__iterateTime != noone) __iterateTime--;
				
				return true;
			}
			else {
				__active = false;
				__iterateTime = 0;
				
				return false;
			}
		}
		
		return false;
	}
	
	/// @desc Trabajar como adicion por ciclos
	static Iterate = function() {
		if (!__active) return false;
		
		if (__iterateTime >= 0 || __iterateTime == undefined) {
			__count += __amount;	
			if (__iterateTime != undefined) __iterateTime--;
			
			return true;
		}
		
		return false;
	}
	
	/// @desc Trabajar el contador. Posee 2 modos que dependen: Contador o Adiccion por ciclos
	static Work = function() {
		return (!__iterate ? Count() : Iterate() );
	}
	
	/// @param {number} amount=1
	static SetAument  = function(_amount = 1) {
		__amount = _amount;
		return self;
	}
	
	/// @param {number} time=0
	static ToggleIterate = function(_time = 0) {
		__iterate = !__iterate;
		__iterateTime = _time;
		
		return self;
	}
	
	/// @param {bool} [active]
	static SetActive = function(_active = true) {
		__active = _active;
		return self;
	}
	
	/// @return {Counter}
	static Copy = function() {
		return (new Counter(__arg.s, __arg.e, __arg.a, __arg.i, __arg.o) );
	}

	#endregion
}
