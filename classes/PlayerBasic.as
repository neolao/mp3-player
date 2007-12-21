/*
Version: MPL 1.1

The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in
compliance with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS"
basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
License for the specific language governing rights and limitations
under the License.

The Original Code is mp3player (http://code.google.com/p/mp3player/).

The Initial Developer of the Original Code is neolao (neolao@gmail.com).
*/
/** 
 * Lecteur mp3 basique
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	1.0.0 (26/11/2007) 
 * @license		http://creativecommons.org/licenses/by-sa/2.5/ 
 */ 
dynamic class PlayerBasic
{
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * L'objet Flash qui s'occupe du son
	 */
	private var _sound:Sound;
	
	private var _timer:MovieClip;
	private var _sound2:Sound;
	private var _bytesLimit:Number = 0;
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
		
		this._timer = _root.createEmptyMovieClip("timer_mc", _root.getNextHighestDepth());
		this._timer.onEnterFrame = this._template.delegate(this, _timerEnterFrame);
		this._timer.transition = false;
		this._sound2 = null;
		
		if (_root.byteslimit != undefined) {
			this._bytesLimit = Number(_root.byteslimit);
		}
		
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
	
	/**
	 * Timer enterframe	 */
	private function _timerEnterFrame():Void
	{
		if (_root.byteslimit != undefined) {
			this._bytesLimit = Number(_root.byteslimit);
		}
		
		if (this._bytesLimit > 0) {
			var loaded:Number = this._sound.getBytesLoaded();
			var volume:Number;
			var volume2:Number;
			
			if (!this._timer.transition && this._sound2 != null) {
				this._sound = this._sound2;
				this._sound2 = null;
			}
			if (loaded > this._bytesLimit && !this._timer.transition && this._sound2 == null) {
				this._timer.transition = true;
				this._position = 0;
				this._sound2 = new Sound();
				this._sound2.loadSound(_root.mp3+"?random="+Math.round(Math.random()*100000), true);
				this._sound2.setVolume(0);
				this._sound2.start(0);
			}
			if (this._timer.transition && this._sound2.position > 200) {
				volume = this._sound.getVolume();
				volume2 = this._sound2.getVolume();
				
				volume -= 1;
				volume2 += 1;
				
				this._sound.setVolume(volume);
				this._sound2.setVolume(volume2);
				
				if (volume <= 0) {
					this._sound = null;
					this._timer.transition = false;
				}
			}
		}
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}