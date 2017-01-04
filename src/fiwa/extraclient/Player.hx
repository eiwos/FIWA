package fiwa.extraclient;
import js.Browser;

class Player {
  var status_functions : Array<Dynamic> = new Array();
  var time_functions : Array<Dynamic> = new Array();
  var controls_functions : Array<Dynamic> = new Array();
  var quality_functions : Array<Dynamic> = new Array();
  var video_functions : Array<Dynamic> = new Array();
  var iwa : Dynamic = fiwa.Iwa;

  public function new() {
    iwa.register_function('extraplayer', this.onmsg);
  }

  static function main() {
    new Player();
  }

  public function init_player(sources : Array<String>, qualities : Array<Int>, video_info : Map<String,String>, video_duration : Int, controls : Map<String,Int>) : Void {
    var info_keys : Array<String> = this.to_array_string(video_info.keys());
    var info_value : Array<String> = this.to_array_string(video_info.iterator());
    var controls_keys : Array<String> = this.to_array_string(controls.keys());
    var controls_values : Array<Int> = this.to_array_int(controls.iterator());

    iwa.send_to_parent(haxe.Json.stringify({msg: "update_sources", sources: sources}), 'extraplayer');
    iwa.send_to_parent(haxe.Json.stringify({msg: "update_qualities", qualities: qualities}), 'extraplayer');
    iwa.send_to_parent(haxe.Json.stringify({msg: "update_video", duration: video_duration, info_keys: info_keys, info_values: info_value}), 'extraplayer');
    iwa.send_to_parent(haxe.Json.stringify({msg: "update_controls", controls: controls_keys, values: controls_values}), 'extraplayer');
  }

  /*Registra una funcion que se ejecutara cuando el contenedor quiera cambiar el estado del player, se le pasara
  un ´Int´ como argumento, para saber que significa dirijase a la tabla estados del reproductor del protocolo */
  public inline function on_status_changed(the_function : Dynamic) : Void {
    status_functions.push(the_function);
  }

  /*Envia que el estado del player a cambiado */
  public inline function set_player_status(status : Int) : Void {
    iwa.send_to_parent(haxe.Json.stringify({msg: "update_status", status: status}), 'extraplayer');
  }

  /*Envia en que segundo se encuentra el reproductor */
  public inline function set_current_time(time : Int) : Void {
    iwa.send_to_parent(haxe.Json.stringify({msg: "update_time", time: time}), 'extraplayer');
  }

  /* Registra una funcion que se ejecutara cuando el contenedor quiera cambiar el segundo en el que va el player, se le pasara
  un ´Int´ como argumento*/
  public inline function on_time_changed(the_function : Dynamic) : Void {
    time_functions.push(the_function);
  }

  /* Registra una funcion que se ejecutara cuando el contenedor quiera cambiar el valor de un ajuste, se le pasara
  un ´Int´ como argumento*/
  public inline function on_control_changed(the_function : Dynamic) : Void {
    controls_functions.push(the_function);
  }

  /*Envia que el valor de un ajuste a cambiado */
  public inline function set_control_value(control : String, value : Int) : Void {
    iwa.send_to_parent(haxe.Json.stringify({msg: "update_control", control: control, value: value}), 'extraplayer');
  }

  /*Envia que el player a cambiado de video */
  public function set_video_changed( video_info : Map<String,String>, video_duration : Int, qualities : Array<Int> ) : Void {
    var info_keys : Array<String> = this.to_array_string(video_info.keys());
    var info_value : Array<String> = this.to_array_string(video_info.iterator());
    iwa.send_to_parent(haxe.Json.stringify({msg: "update_video", duration: video_duration, info_keys: info_keys, info_values: info_value}), 'extraplayer');
    if( qualities != null ) {
      iwa.send_to_parent(haxe.Json.stringify({msg: "update_qualities", qualities: qualities}), 'extraplayer');
    }
  }

  /* Registra una funcion que se ejecutara cuando el contenedor quiera cambiar de video, se le pasara
  un ´String´ con el nombre de la fuente y otro ´String´ con el id del video*/
  public inline function on_video_changed(the_function : Dynamic) : Void {
    video_functions.push(the_function);
  }

  private function to_array_string(iterator:Iterator<Dynamic>) : Array<String> {
    var final : Array<String> = new Array();
    for( value in iterator ) {
      final.push(value);
    }
    return final;
  }

  private function to_array_int(iterator:Iterator<Dynamic>) : Array<Int> {
    var final : Array<Int> = new Array();
    for( value in iterator ) {
      final.push(value);
    }
    return final;
  }

  private function onmsg(data : String) : Void {
    var data = haxe.Json.parse(data);
    if( data.msg == 'set_status' ) {
      for( the_function in status_functions ) {
        the_function(data.status);
      }
    } else if( data.msg == 'set_time' ) {
      for( the_function in time_functions ) {
        the_function(data.time);
      }
    } else if( data.msg == 'set_control_value' ) {
      for( the_function in controls_functions ) {
        the_function(data.control, data.value);
      }
    } else if( data.msg == 'set_video' ) {
      for( the_function in video_functions ) {
        the_function(data.source, data.video);
      }

    }
  }
}
