package fiwa.extraclient;

class Game {
    var iwa : Dynamic = fiwa.Iwa_client;
    var controller_functions : Array<Dynamic> = new Array();
    var user_functions : Array<Dynamic> = new Array();
    var mobile_functions : Array<Dynamic> = new Array();

  public function new() {
    iwa.register_function('extraplayer', this.onmsg);
  }

  static function main() {
    new Game();
  }

  public function init_game(info : Map<String,String>, controllers : Map<String,String>, onuser : Dynamic) : Void {
    var info_keys : Array<String> = this.to_array_string(info.keys());
    var info_values : Array<String> = this.to_array_string(info.iterator());
    var controllers_names : Array<String> = this.to_array_string(controllers.iterator());
    var controllers_keys : Array<String> = this.to_array_string(controllers.keys());

    iwa.send_to_parent(haxe.Json.stringify({msg: "set_game_info", info_keys: info_keys, info_values: info_values}), 'extragame');
    iwa.send_to_parent(haxe.Json.stringify({msg: "set_controllers", controllers_names: controllers_names, controllers_keys: controllers_keys}), 'extragame');
    user_functions.push(onuser);
  }

  public inline function set_mobile() : Void {
    iwa.send_to_parent(haxe.Json.stringify({msg: "set_mobile"}), 'extragame');
  }

  public inline function on_mobile_controllers(the_function : Dynamic) : Void {
    mobile_functions.push(the_function);
  }

  public inline function on_controller(the_function : Dynamic) : Void {
    controller_functions.push(the_function);
  }

  public function set_leadboard(leadboard : Map<String,Int>) : Void {
    var names : Array<String> = this.to_array_string(leadboard.keys());
    var scores : Array<Int> = this.to_array_int(leadboard.iterator());
    iwa.send_to_parent(haxe.Json.stringify({msg: "update_leadboard", leadboard_names: names, leadboard_values: scores}), 'extragame');
  }

  public inline function set_value(name : String, value : String) : Void {
    iwa.send_to_parent(haxe.Json.stringify({msg: "update_value", value_name: name, value: value}), 'extragame');
  }

  public inline function on_user(the_function : Dynamic) : Void {
    user_functions.push(the_function);
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

  private function onmsg(data: String) : Void {
    var data : {msg:String, name : String, key : String, show: Bool, css: String, session: String} = haxe.Json.parse(data);
    if( data.msg == "set_controller" ) {
      for( the_function in controller_functions ) {
        the_function(data.name, data.key);
      }
    } else if( data.msg == "set_mobile_controller" ) {
      for( the_function in mobile_functions ) {
        the_function(data.show);
      }
    } else if( data.msg == "set_css" ) {
      js.Browser.document.getElementsByTagName('head')[0].insertAdjacentHTML("beforeend", "<style>" + data.css + "</style>");
    } else if( data.msg == "set_user" ) {
      for( the_function in user_functions ) {
        the_function(data.name, data.session);
      }
    }
  }
}
