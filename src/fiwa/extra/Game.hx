package fiwa.extra;

class Game {
  public var games_info : Map<String,Map<String,String>> = new Map();
  public var controllers : Map<String,Map<String,String>> = new Map();
  public var leadboards : Map<String,Map<String,Int>> = new Map();
  public var game_values : Map<String,Map<String,String>> = new Map();
  var mobile_functions : Map<String,Array<Dynamic>> = new Map();
  var value_functions : Map<String,Array<Dynamic>> = new Map();
  var leadboard_functions : Map<String,Array<Dynamic>> = new Map();
  var iwa : Dynamic = fiwa.Iwa;

  public function new() {
    iwa.register_function('extragame', this.onmsg);
  }

  static function main() {
    new Game();
  }

  public inline function get_info(frameid : String) : Map<String,String> {
    return games_info[frameid];
  }

  public inline function get_controller(frameid : String, name: String) : String {
    return controllers[frameid][name];
  }

  public inline function set_controller(frameid : String, name: String, key: String) : Void {
    iwa.send_to_frame(frameid, haxe.Json.stringify({msg: "set_controller", name: name, key: key}), 'extragame');
  }

  public inline function on_mobile(frameid : String, the_function : Dynamic) : Void {
    mobile_functions[frameid].push(the_function);
  }

  public inline function set_mobile_controller(frameid : String, value: Bool) : Void {
    iwa.send_to_frame(frameid, haxe.Json.stringify({msg: "set_mobile_controller", show: value}), 'extragame');
  }

  public inline function set_style(frameid : String, style: String) : Void {
    iwa.send_to_frame(frameid, haxe.Json.stringify({msg: "set_css", css: style}), 'extragame');
  }

  public inline function get_leadboard(frameid : String) : Map<String,Int> {
    return leadboards[frameid];
  }

  public inline function on_leadboard(frameid : String, the_function : Dynamic) : Void {
    leadboard_functions[frameid].push(the_function);
  }

  public inline function get_value(frameid : String, name: String) : String {
    return game_values[frameid][name];
  }

  public inline function on_value(frameid : String, the_function : Dynamic) : Void {
    value_functions[frameid].push(the_function);
  }

  public inline function set_user(frameid : String, name: String, session: String) : Void {
    iwa.send_to_frame(frameid, haxe.Json.stringify({msg: "set_user", name: name, session: session}), 'extragame');
  }

  private function onmsg(data : String, element_id : String) : Void {
    var data : {msg:String, info_keys : Array<String>, info_values : Array<String>, controllers_names : Array<String>, controllers_keys : Array<String>, leadboard_names : Array<String>, leadboard_values : Array<Int>, value_name : String, value : String} = haxe.Json.parse(data);
    if( data.msg == "set_game_info" ) {
      for( i in 0...data.info_keys.length ) {
        games_info[element_id].set(data.info_keys[i], data.info_values[i]);
      }
    } else if( data.msg == "set_controllers" ) {
      for( i in 0...data.controllers_names.length ) {
        controllers[element_id].set(data.controllers_names[i], data.controllers_keys[i]);
      }
    } else if( data.msg == "update_leadboard" ) {
      for( i in 0...data.leadboard_names.length ) {
        leadboards[element_id].set(data.leadboard_names[i], data.leadboard_values[i]);
      }
      for( the_function in leadboard_functions[element_id] ) {
        the_function();
      }
    } else if( data.msg == "update_value" ) {
      game_values[element_id].set(data.value_name, data.value);
      for( the_function in value_functions[element_id] ) {
        the_function(data.value_name, data.value);
      }
    } else if( data.msg == "set_mobile" ) {
      for( the_function in mobile_functions[element_id] ) {
        the_function();
      }
    }
  }
}
