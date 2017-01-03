package fiwa;
import fiwa.extraiwa.Extraiwa;
import fiwa.extraiwa.Player;
import fiwa.extraiwa.Game;


/*Ignora esta clase si vas a usar la libreria con haxe,
 sirve para compilar la libreria de forma nativa a javascript
 */
class Fiwa {
  public var iwa : Dynamic = new Iwa();
  public var extraiwa : Dynamic = new Extraiwa();
  public var player : Dynamic = new Player();
  public var game : Dynamic = new Game();

  public function new() {
  }

  static function main() {
    var fiwa = new Fiwa();
  }
}
