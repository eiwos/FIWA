package fiwa;
import fiwa.extraclient.Extraiwa;
import fiwa.extraclient.Player;
import fiwa.extraclient.Game;


/*Ignora esta clase si vas a usar la libreria con haxe,
 sirve para compilar la libreria de forma nativa a javascript
 */
class Fiwa_client {
  public var iwa : Dynamic = new Iwa_client();
  public var extraiwa : Dynamic = new Extraiwa();
  public var player : Dynamic = new Player();
  public var game : Dynamic = new Game();

  public function new() {
  }

  static function main() {
    var fiwa_client = new Fiwa_client();
  }
}
