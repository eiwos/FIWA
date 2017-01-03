package fiwa;
import js.Browser;

class Iwa_client {
    var functions : Map<String,Array<Dynamic>> = new Map();
    var registered_channels : Array<String> = new Array();
    var parent = Browser.window.parent;

    static function main() {
      var fiwa_iwa_client  = new Iwa_client();
    }

    public function new() {
      Browser.window.addEventListener("message", on_msg, false);

    }

    /**
    enviar un mensaje a la pagina que contiene el widget
    **/
    public function send_to_parent(msg : String, channelid : String) : Void {
      if( msg == null ) {
        trace( "msg cannot be null" );
      }
      var final_msg : Array<String> = [channelid, msg];

      parent.postMessage(final_msg, Browser.location.href);
    }

    /**
    registra el canal en la pagina que contiene el widget para que sepa el formato (xml, json...)
    y la api con la que el widget esta enviando los mensajes
    **/
    public function register_channel(channelid : String, format : String, api : String) : Void {
      var final_msg : Array<String> = [channelid, null, null, api, format];
      parent.postMessage(final_msg, Browser.location.href);
    }

    /**
    registrar una funcion que se ejecuta al recibir un mensaje por algun canal u otros especificada null en channelid
    **/
    public inline function register_function(channelid : String, the_function : Dynamic) : Void {
      this.functions.set(channelid, the_function);
    }

    /**
    devuelve true si este widget ha registrado el canal
    **/
    public function is_channel_registered(channelid : String) : Bool {
      if( registered_channels.indexOf(channelid) == -1 ) {
        return false;
      } else {
        return true;
      }

    }

    private function on_msg(event : Dynamic) : Void {
      if( untyped Browser.window.parenturl == event.origin ) {
        if( event.data[0] == null ) {
          for( the_function in this.functions[null] ) {
            the_function(event.data[1]);
          }
        } else {
          for( the_function in this.functions[event.data[0]] ) {
            the_function(event.data[1]);
          }
        }
      } else {
        trace( "Unstrusted parent mesage recived." );
      }
    }
}
