package fiwa;
import js.Browser;
import js.html.IFrameElement;

class Iwa {
  var frames : Array<Array<String>> = null;
  var functions : Map<String,Array<Dynamic>> = new Map();
  var url : String = Browser.location.href;
  var frames_apis : Map<String,Map<String,String>> = new Map();
  var channels_format : Map<String, String> = new Map();

  static function main() {
    var fiwa_iwa = new Iwa();
  }

  public function new() : Void {
    Browser.window.addEventListener("message", on_msg, false);
  }

  /**
  registra y le cambia el color y imagen de fondo al iframe.
  **/
  public function init_frame(id : String, url : String, back_color : String, back_img : String) : Void {
    this.register_frame(id, url);
    this.set_backround_color(id, back_color);
    this.set_backround_image(id, back_img);

    var frame = this.get_frame(id);
    frame.getElementsByTagName('body')[0].insertAdjacentHTML("afterbegin", "<script>var parenturl = '" + this.url + "';</script>");

  }

  /**
  forzar al iframe a mantenerse en la url especificada en su registro,
  simplemente añadir la etiqueta onload="frameapi.force_origin(id)" al iframe cambiando id por el id del iframe.
  **/
  public function force_origin(id : String) : Void {
    var frame = get_frame(id);
    for( frameid in this.frames ) {
      if( frameid[1] == id ) {
        if( frame.src != frameid[0] ) {
          frame.src = frameid[0];
        }
        break;
      }
    }
  }

  /**
  envia un mensaje a un canal (este mensaje sera enviado a todos los iframes registrados)
  **/
  public function send_to_channel(channelid : String, msg : String) : Void {
    var final_msg : Array<String> = [channelid, msg];

    for( id in this.frames ) {
      var frame = get_frame(id[1]);
      frame.postMessage(final_msg, Browser.location.href);
    }
  }

  /**
  envia un mensaje a todos los iframes registrados de la misma url de origen
  **/
  public function send_to_origin(origin : String, msg : String, channelid : String) : Void {
    var final_msg : Array<String> = [channelid, msg];

    for( id in this.frames ) {
      if( id[0] == origin ) {
        var frame = get_frame(id[1]);
        frame.postMessage(final_msg, Browser.location.href);
      }
    }
  }

  /**
  envia un mensaje a un canal pero solo a un iframe
  **/
  public function send_to_frame(id : String, msg : String, channelid : String) : Void {
    var final_msg : Array<String> = [channelid, msg];

    var frame = get_frame(id);
    frame.postMessage(final_msg, Browser.location.href);
  }

  private inline function register_frame(id : String, origin : String) : Void {
    this.frames.push([origin, id]);
  }

  /**
  registrar una funcion que se ejecuta al recibir un mensaje por algun canal u otros especificada null en channelid
  **/
  public inline function register_function(channelid : String, the_function : Dynamic) : Void {
    functions.set(channelid, the_function);
  }

  /**
  devuelve un mapa con el nombre del canal como key y como value el nombre de la api
  **/
  public inline function get_frame_apis(frameid : String) : Map<String,String> {
    return frames_apis[frameid];
  }

  public inline function get_channel_format(channelid : String) : String {
    return channels_format[channelid];
  }

  /**
  cambiar el color de fondo a todos los iframes registrados
  **/
  public function all_backround_color(color : String) : Void {
    for( id in this.frames ) {
      var frame = this.get_frame(id[1]);
      frame.getElementsByTagName('body')[0].style.background = color;
    }
  }

  /**
  cambiar la imagen de fondo a todos los iframes registrados
  **/
  public function all_backround_image(url : String) : Void {
    for( id in this.frames ) {
      var frame = this.get_frame(id[1]);
      frame.getElementsByTagName('body')[0].style.backgroundImage = "url(" + url + ")";
    }
  }

  /**
  cambiar el color de fondo a un iframe registrado
  **/
  public function set_backround_color(id :String, color : String) : Void {
    var frame = this.get_frame(id);
    frame.getElementsByTagName('body')[0].style.background = color;
  }

  /**
  cambiar la imagen de fondo a un iframe registrado
  **/
  public function set_backround_image(id : String, url : String) : Void {
    var frame = this.get_frame(id);
    frame.getElementsByTagName('body')[0].style.backgroundImage = "url(" + url + ")";
  }

  private function on_msg(event : Dynamic) : Void {
    var found : Bool = false;
    var element_id : String = null;
    for( id in this.frames ) {
      if( id[0] == event.origin ) {
        found = true;
        element_id = id[1];
        break;
      }
    }

    if( found == true ) {
      if( event.data[1] == null ) {
        if( !channels_format.exists(event.data[0]) ) {
          channels_format.set(event.data[0], event.data[4]);
        }
        frames_apis[element_id].set(event.data[0],event.data[3]);
      } else {
        for( the_function in this.functions[event.data[0]] ) {
          the_function(event.data[1], element_id );
        }
      }
    } else {
      trace( "Unstrusted frame mensage recived." );
    }
  }

  private inline function get_frame(id : String) : Dynamic {
    var frame = cast Browser.document.getElementById(id);
    return frame.contentWindow;
  }
}
