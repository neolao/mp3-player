/** 
 * Lecteur mp3 basique
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.9.3 (03/04/2007) 
 * @link		http://resources.neolao.com/flash/components/player_mp3 
 * @license		http://creativecommons.org/licenses/by-sa/2.5/ 
 */ 
dynamic class PlayerBasic
{
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * L'objet Flash qui s'occupe du son
	 */
	private var _sound:Sound;
	/**
	 * Indique que le lecteur est en train de jouer
	 */
	public var isPlaying:Boolean = false;
	/**
	 * L'instance du thème utilisé
	 */
	private var _template:ATemplate;
	/**
	 * La position du son dans le temps
	 */
	private var _position:Number = 0;
	/**
	 * Indique si le mp3 est à sa première lecture
	 */
	private var _firstPlay:Boolean;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation du lecteur
	 * 
	 * @param pTemplate L'instance du thème à utiliser
	 */
	public function PlayerBasic(pTemplate:ATemplate)
	{
		this._template = pTemplate;
		
		this._template.player = this;
		
		// Lecture automatique
		if (_root.autoplay == "1") {
			this._template.playRelease();
		} else {
			this._template.stopRelease();
		}
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/	
	/**
	 * Récupère les informations sur le chargement du mp3
	 * 
	 * - loaded: Le nombre de bytes chargés
	 * - total: Le nombre de bytes à chargés
	 * - precent: Le pourcentage entre les 2
	 * 
	 * @return L'objet contenant les informations
	 */
	public function getLoading():Object
	{
		var loaded:Number = this._sound.getBytesLoaded();
		var total:Number = this._sound.getBytesTotal();
		var percent:Number = Math.round(loaded / total * 100); 
		return {loaded:loaded, total:total, percent:percent};
	}
	/**
	 * Récupère le temps écoulé en milliseconde
	 * 
	 * @return Le temps en milliseconde
	 */
	public function getPosition():Number
	{
		return this._sound.position;
	}
	/**
	 * Récupère le temps écoulé en milliseconde
	 * 
	 * @return Le temps en milliseconde
	 */
	public function setPosition(pPosition:Number)
	{
		this._position = pPosition;
		this._sound.start(Math.round(this._position / 1000));
		this._sound.stop();
		if (this.isPlaying) {
			this.play();
		}
	}
	/**
	 * Récupère la durée du mp3 en milliseconde
	 * 
	 * @return Le temps en milliseconde
	 */
	public function getDuration():Number
	{
		return this._sound.duration;
	}
	/**
	 * Jouer
	 */
	public function play():Void
	{
		if (!this._firstPlay) {
			this._position = 0;
			this._sound = new Sound();
			this._sound.loadSound(_root.mp3, true);
			this._firstPlay = true;
		}
		this._sound.start(Math.round(this._position / 1000));
		this.isPlaying = true;
	}
	/**
	 * Pause
	 */
	public function pause():Void
	{
		this._position = this._sound.position;
		this._sound.stop();
		this.isPlaying = false;
	}
	/**
	 * Stopper
	 */
	public function stop():Void
	{
		this._position = 0;
		this._sound.start(0);
		this._sound.stop();
		this.isPlaying = false;
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}