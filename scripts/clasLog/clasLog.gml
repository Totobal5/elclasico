#macro serial __Log()
#macro SERIAL_ACTIVE true

function __Log() constructor {
    #region PRIVATE
    __log = "";
    
    #endregion
    
    #region METHOD
    /// @param {string} message
    static echo = function(_msg) {
        if (!SERIAL_ACTIVE) exit;
        
        var i=1; repeat(argument_count - 1) {
            _msg = string_replace(_msg, "%s", argument[i++] );    
        }
        // Guardar
        __log = _msg;
        show_debug_message(_msg);
    }
    
    /// @desc Complex echo
    static log  = function() {
        if (!SERIAL_ACTIVE) exit;
        
		var _obj="", _id="";
		
		#region Quien llama
		if (is_struct(other) ) {
			_obj = string(instanceof(other) ); 
		} 
		else {
			if (other.id == 0) {
				_id  = "Room Creation Code"
				_obj = ""; 
			}
			else {
				_id = string(other.id);
				_obj = object_get_name(_id.object_index); 
			}
		}
        #endregion

	    var _event = "";

	    switch(event_type) {
			#region Obtener event_type
	        case ev_create:		_event = "create";		break;
	        case ev_destroy:	_event = "destroy";		break;
	        case ev_alarm:		_event = "alarm["+string(event_number)+"]";	break;
	
	
	        case ev_keyboard:	_event = "keyboard";		break;
	        case ev_keypress:	_event = "keypress";		break;
	        case ev_keyrelease: _event = "ev_keyrelease";	break;
	        case ev_mouse:		_event = "ev_mouse";		break;
	        case ev_collision:	_event = "ev_collision";	break;

	        case ev_step: 
	            switch (event_number) {
	                case ev_step_begin: _event = "begin ";	break;
	                case ev_step_end:	_event = "end ";	break;
	            }
	            _event += "step";
	        break;

			case ev_draw:
	            switch (event_number) {
	                case ev_draw_begin:		_event = "begin ";	break;
	                case ev_draw_end:		_event = "end ";	break;
	            }
	            _event += "draw";
	        break;
			
	        case ev_other:		_event = "ev_other";		break;
	        case ev_gesture:	_event = "ev_gesture";		break;
			
			#endregion
	    }
		
		__log = "[" + _obj + " - " + _id + " - " + _event + "]\n";
	
		// Argumentos
		if (argument_count < 2) {
			__log  += string(argument[0] );	
		}
		else {
			var i = 0; repeat( argument_count div 2) {
				var _one = argument[i], _two = argument[i + 1] ?? "";
				__log += string(_one) + ": " + string(_two) + "\n";	
			}
		}
		
		show_debug_message(__log);        
    }
    
    /// @desc Crea un archivo de log
    static make = function() {
		var _file = file_text_open_write(working_directory + "log.txt");
		    file_text_write_string(_file, __log);
		    file_text_writeln(_file);
		file_text_close(_file);        
    }
    
    #endregion
}

/// @returns {__Log}
function __logSingle() {
    static single = new __Log();
    return single;
}
