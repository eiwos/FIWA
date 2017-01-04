package fiwa.extra;
import js.Browser;

class Player {
  public var players_status : Map<String,Int> = new Map();
  public var players_current_time : Map<String,Int> = new Map();
  public var players_videos_duration : Map<String,Int> = new Map();
  public var players_videos_info : Map<String,Map<String,String>> = new Map();
  public var players_qualities : Map<String,Array<Int>> = new Map();
  public var players_sources : Map<String,Array<String>> = new Map();
  public var players_controls : Map<String,Map<String,Int>> = new Map();
  var time_functions : Map<String,Map<Int,Dynamic>> = new Map();
  var iwa : Dynamic = fiwa.Iwa;

  public function new() {
    iwa.register_function('extraplayer', this.onmsg);
  }

  static function main() {
    new Player();
  }

  /*Enviar al widget que reproduzca el video */
  public function play_video(frameid : String) : Void {
    iwa.send_to_frame(frameid, haxe.Json.stringify({msg: "set_status", status: 1}), 'extraplayer');
    players_status[frameid] = 1;
  }

  /*Enviar al widget que quite el video que esta reproduciendo */
  public function stop_video(frameid : String) : Void {
    iwa.send_to_frame(frameid, haxe.Json.stringify({msg: "set_status", status: 0}), 'extraplayer');
    players_status[frameid] = 0;
  }

  /*Enviar al widget que ponga en pausa el video */
  public function pause_video(frameid : String) : Void {
    iwa.send_to_frame(frameid, haxe.Json.stringify({msg: "set_status", status: 2}), 'extraplayer');
    players_status[frameid] = 2;
  }

  /*Obtiene el estado actual del reproducto, devuelve un `int` para saber que significa
   dirijase a la documentacion del protocolo extraiwa > extraplayer */
  public inline function get_player_status(frameid : String) : Int {
    return players_status[frameid];
  }

  /*Obtiene la duracion total del video actual en segundos*/
  public inline function get_video_duration(frameid : String) : Int {
    return players_videos_duration[frameid];
  }

  /*Obtiene el segundo actual en el que esta el video*/
  public inline function get_current_time(frameid : String) : Int {
    return players_current_time[frameid];
  }

  /*Pone el video en el segundo especificado*/
  public function set_time(frameid : String, time : Int) : Void {
    iwa.send_to_frame(frameid, haxe.Json.stringify({msg: "set_time", time: time}), 'extraplayer');
    players_current_time[frameid] = time;
  }

  /*Ejecuta una funcion cuando el video llega al segundo especificado en la variable `time`
  y se le pasara el id del elemento del iframe como argumento `tipo: String`*/
  public inline function on_time_do(frameid : String, time : Int, the_function : Dynamic) : Void {
    time_functions[frameid].set(time, the_function);
  }

  /*Cambia el valor de un ajuste(calidad, volumen, velocidad, ...).
  pare ver el modelo estadar de nombres y valores de los ajustes dirijase a las especificaciones
  del protocolo*/
  public function set_control_value(frameid : String, control : String, value : Int) : Void {
    iwa.send_to_frame(frameid, haxe.Json.stringify({msg: "set_control_value",control: control , value: value}), 'extraplayer');
    players_controls[frameid][control] = value;
  }

  /*Obtiene el valor de un ajuste(calidad, volumen, velocidad, ...).
  pare ver el modelo estadar de nombres y valores de los ajustes dirijase a las especificaciones
  del protocolo*/
  public inline function get_control_value(frameid : String, control : String) : Int {
    return players_controls[frameid][control];
  }

  /*Obtiene las posibles calidades que se pueden asignar al video.
  se devolvera un valor ´int´ para entender su significado dirijase a la tabla de nombres y valores
  de los ajustes*/
  public inline function get_qualities(frameid : String) : Array<Int> {
    return players_qualities[frameid];
  }

  /*Devuelve un ´Map´ con tags y sus valores relacionados con el video,
  pare ver el modelo estadar de nombres y valores de los tags dirijase a las especificaciones
  del protocolo */
  public inline function get_video_info(frameid : String) : Map<String,String> {
    return players_videos_info[frameid];
  }

  /*Devuelve un ´Array´ con las fuentes (youtube, vimeo, ...) desde donde se pueden cargar videos al reproductor */
  public inline function get_sources(frameid : String) : Array<String> {
    return players_sources[frameid];
  }

  /*Cambia el video al especificado, en ´source´ tendremos que especificar la fuente, en ´video_id´ la id del video */
  public inline function set_video(frameid : String, source : String, video_id : String) : Void {
    iwa.send_to_frame(frameid, haxe.Json.stringify({msg: "set_video", source: source, video: video_id}), 'extraiwa');
  }

  private function onmsg(data : String, element_id : String) : Void {
    var data : {msg:String, controls:Array<String>, values:Array<Int>,control:String, value:Int, duration: Int, info_keys:Array<String>, info_value:Array<String>, qualities:Array<Int>, status:Int, time:Int, sources:Array<String>} = haxe.Json.parse(data);
    if( data.msg == 'set_controls' ) {
      for( i in 0...data.controls.length ) {
        players_controls[element_id].set(data.controls[i], data.values[i]);
      }
    } else if( data.msg == 'update_control' ) {
      players_controls[element_id][data.control] = data.value;
    } else if( data.msg == 'update_video' ) {
      players_videos_duration.set(element_id, data.duration);
      for( i in 0...data.info_keys.length ) {
        players_videos_info[element_id].set(data.info_keys[i], data.info_value[i]);
      }
    } else if( data.msg == 'update_qualities' ) {
      players_qualities[element_id] = data.qualities;
    } else if( data.msg == 'update_time' ) {
      players_current_time[element_id] = data.time;
      for( the_time in time_functions[element_id].keys() ) {
        if( the_time == data.time ) {
          time_functions[element_id][the_time](element_id);
        }
      }
    } else if( data.msg == 'update_sources' ) {
      players_sources[element_id] = data.sources;
    } else if( data.msg == 'update_status' ) {
      players_status[element_id] = data.status;
    }
  }
}
