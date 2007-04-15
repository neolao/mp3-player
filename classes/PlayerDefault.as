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
 * Lecteur mp3
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	1.0.2 (31/05/2006) 
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