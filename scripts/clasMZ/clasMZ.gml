/// @typedef {tuple<width:number, height:number, entity:string>} mz

enum MZ {W, H, I}

/// @param width
/// @parma height
/// @returns {mz}
function mz_create(_w, _h) {
	return ([_w, _h, "mzins"] );	
}

/// @param {mz} mz
/// @returns {number}
function mz_w(_mz) {
	if (_mz[2] == "mzins") {return _mz[0]; }
}

/// @param {mz} mz
/// @returns {number}
function mz_h(_mz) {
	if (_mz[2] == "mzins") {return _mz[1]; }
}

/// @param {mz} mz
/// @returns {number}
function mz_area(_mz) {
	if (_mz[2] == "mzins") {return _mz[0] * _mz[1]; }
}

/// @param {mz} mz
/// @returns {number}
function mz_perimeter(_mz) {
	if (_mz[2] == "mzins") {
		return (_mz[0] * 2) + (_mz[1] * 2);
	}
}
