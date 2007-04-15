/** 
 * Lecteur mp3
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	1.0.2 (31/05/2006) 
 * @link		http://resources.neolao.com/flash/components/player_mp3 
 * @license		http://creativecommons.org/licenses/by-sa/2.5/ 
 */ 
class PlayerDefault extends PlayerBasic
{	
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * Bouclage sur la playlist	 */
	public var loop:Boolean = false;
	/**
	 * Le volume	 */
	public var volume:Number = 100;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation du lecteur
	 * 
	 * @param pTemplate L'instance du thème à utiliser	 */
	public function PlayerDefault(pTemplate:ATemplate)
	{
		super(pTemplate);
		
		// Valeurs de l'utilisateur
		if (_root.volume != undefined) {
			this.setVolume(Number(_root.volume));
		}
		if (_root.loop == "1") {
			this.loop = true;
		}
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/**
	 * Invoquée lorsque le mp3 a fini	 */
	private function _soundComplete()
	{
		this.stop();
		if (this.loop) {
			this.play();
		}
	}
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Converti les millisecondes en temps
	 * 
	 * @param milli Les millisecondes à convertir
	 * @return Une représentation du temps
	 */
	public function milli2time(milli:Number):String
	{
		var min:Number = Math.floor(milli / (1000 * 60));
		var sec:Number = Math.floor(milli / 1000) % 60;
		return ((min < 10)?"0"+min:min) + ":" + ((sec < 10)?"0"+sec:sec);
	}
	/**
	 * Récupère le temps écoulé
	 * 
	 * @return Le temps au format mm:ss	 */
	public function getPositionTime():String
	{
		if (this._sound.position != undefined) {
			return milli2time(this._sound.position);
		} else {
			return undefined;
		}
	}
	/**
	 * Récupère la durée du mp3
	 * 
	 * @return Le temps au format mm:ss	 */
	public function getDurationTime():String
	{
		if (this._sound.duration != undefined) {
			return milli2time(this._sound.duration);
		} else {
			return undefined;
		}
	}
	/**
	 * Récupère les tags ID3 du mp3
	 * 
	 * @return L'objet contenant les informations du mp3	 */
	public function getID3():Object
	{
		return this._sound.id3;
	}
	/**
	 * Modifie le volume
	 * 
	 * @param pVolume Le nouveau volume	 */
	public function setVolume(pVolume:Number)
	{
		this.volume = Number(pVolume);
		this._sound.setVolume(this.volume);
	}
	/**
	 * Récupère le volume
	 * @return Le volume	 */
	public function getVolume():Number
	{
		return this.volume;
	}
	/**
	 * Jouer
	 */
	public function play():Void
	{
		super.play();
		this._sound.setVolume(this.volume);
		this._sound.onSoundComplete = this._template.delegate(this, _soundComplete);
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}