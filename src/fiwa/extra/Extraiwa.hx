package fiwa.extra;
import js.Browser;

class Extraiwa {
  public var loaded_frames : Array<String> = new Array();
  public var playing_frames : Array<String> = new Array();
  public var finish_frames : Array<String> = new Array();
  var frame_loaded : Array<Dynamic> = new Array();
  var frame_playing : Array<Dynamic> = new Array();
  var frame_finish : Array<Dynamic> = new Array();
  var iwa : Dynamic = fiwa.Iwa;


  static function main() {
  }

  public function new() {
    iwa.register_function('extraiwa', this.onmsg);
    Browser.window.addEventListener("DOMContentLoaded", onloaded);
  }

  /*Registra una funcion que se ejecutara cuando un iframe termine de cargar (por lo que ya se puede establecer una comunicacion con el) y se le pasara el id del
  elemento del iframe como argumento `tipo: String` */
  public function on_frame_loaded(the_function : Dynamic) : Void {
    frame_loaded.push(the_function);
  }

  /*Registra una funcion que se ejecutara cuando un iframe empieze a ejecutarse 'Ejemplo: un video empieza a reproducirse, un videojuego empieza ...'
   y se le pasara el id del elemento del iframe como argumento `tipo: String` */
  public function on_frame_playing(the_function : Dynamic) : Void {
    frame_playing.push(the_function);
  }

  /*Registra una funcion que se ejecutara cuando un iframe termina de ejecutarse 'Ejemplo: un video termina, game over en un videojuego ...'
   y se le pasara el id del elemento del iframe como argumento `tipo: String` */
  public function on_frame_finish(the_function : Dynamic) : Void {
    frame_finish.push(the_function);
  }

  /*Devuelve un array de strings con todas las apis de extraiwa que el iframe tiene disponibles */
  public function get_frame_extra_apis(frameid : String) : Array<String> {
    var apis : Array<String> = new Array();
    var all : Map<String,String> = iwa.get_frame_apis(frameid);
    for( channel in all.keys() ) {
      if( channel == "extraiwa") {
        apis.push("extraiwa");
      } else if( channel == "extraplayer" ) {
        apis.push("extraplayer");
      }
    }
    return apis;
  }

  private inline function onloaded() : Void {
    iwa.send_to_channel('extraiwa', haxe.Json.stringify({msg: "loaded"}));
  }

  private function onmsg(data : String, element_id : String) : Void {
    var data = haxe.Json.parse(data);
    if( data.msg == 'loaded' ) {
      loaded_frames.push(element_id);
      for( the_function in this.frame_loaded ) {
        the_function(element_id);
      }
    } else if( data.msg == 'playing' ) {
      playing_frames.push(element_id);
      for( the_function in this.frame_playing ) {
        the_function(element_id);
      }

    } else if( data.msg == 'finish' ) {
      finish_frames.push(element_id);
      playing_frames.remove(element_id);
      for( the_function in this.frame_finish ) {
        the_function(element_id);
      }
    }
  }
}
