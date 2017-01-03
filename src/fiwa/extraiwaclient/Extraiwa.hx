package fiwa.extraiwaclient;

import js.Browser;
class Extraiwa{
  public var parent_has_loaded : Bool = false;
  var parent_loaded : Array<Dynamic> = new Array();
  var iwa : Dynamic = fiwa.Iwa_client;

  static function main() {
  }

  public function new() {
    iwa.register_channel('extraiwa', 'json', 'extraiwa-1');
    iwa.register_function('extraiwa', onmsg);
    Browser.window.addEventListener("DOMContentLoaded", onloaded);
  }

  /*Registra una funcion que se ejecutara cuando la pagina que contiene el widget termine de cargarse */
  public function on_parent_loaded(the_function : Dynamic) : Void {
    this.parent_loaded.push(the_function);
  }

  /*Enviar que el wigget a terminado de ejecutarse 'Ejemplo: un video termina, game over en un videojuego ...' */
  public inline function play_finish() : Void {
    iwa.send_to_channel('extraiwa', haxe.Json.stringify({msg: "finish"}));
  }

  /*Enviar que el wigget a empezado a ejecutarse 'Ejemplo: un video empieza a reproducirse, un videojuego empieza ...' */
  public inline function play_started() : Void {
    iwa.send_to_channel('extraiwa', haxe.Json.stringify({msg: "playing"}));
  }

  private inline function onloaded() : Void {
    iwa.send_to_channel('extraiwa', haxe.Json.stringify({msg: "loaded"}));
  }

  private function onmsg(data : String, element_id : String) : Void {
    var data = haxe.Json.parse(data);
    if( data.msg == 'loaded' ) {
      parent_has_loaded = true;
      for( the_function in this.parent_loaded ) {
        the_function();
      }
    }
  }
}
