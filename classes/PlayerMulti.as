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
 * Lecteur de plusieurs mp3
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	1.3.0 (31/10/2007) 
 * @license		http://creativecommons.org/licenses/by-sa/2.5/ 
 */ 
class PlayerMulti extends PlayerDefault
{	
	// ------------------------------ CONSTANTES -------------------------------
	/**
	 * Le séparateur les urls des mp3
	 */
	static var URL_SEPARATOR:String = "|";
	
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * La liste des mp3 à lire
	 */
	public var playlist:Array;
	/**
	 * Choisir le mp3 suivant aléatoirement dans la playlist
	 */
	public var shuffle:Number = 0;
	/**
	 * Indique s'il y a un précédent
	 */
	public var hasPrevious:Boolean = false;
	/**
	 * Indique s'il y a un suivant
	 */
	public var hasNext:Boolean = false;
	/**
	 * L'index du mp3 dans la playlist
	 */
	public var index:Number = 0;
	/**
	 * Shuffle the playlist and save the order (nice shuffle)	 */
	private var _randomList:Array;
	/**
	 * Random list Index	 */
	private var _randomListIndex:Number = 0;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation du lecteur
	 * 
	 * @param pTemplate L'instance du thème à utiliser	 */
	public function PlayerMulti(pTemplate:ATemplate)
	{
		// Définition de la liste des mp3
		this.playlist = _root.mp3.split(URL_SEPARATOR);
		
		if (this.playlist.length > 1) {
			this.hasNext = true;
		}
		
		if (_root.shuffle == "1") {
			this.shuffle = 1;
			this.index = Math.round(Math.random() * (this.playlist.length - 1));
			this.hasPrevious = true;
			this.hasNext = true;
		}
		if (_root.shuffle == "2") {
			this.shuffle = 2;
			this._randomList = this._shuffle(this.playlist);
			this._randomListIndex = 0;
			this.index = this._randomList[this._randomListIndex];
			this.hasPrevious = true;
			this.hasNext = true;
		}
		super(pTemplate);
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/**
	 * Invoquée lorsque le mp3 a fini
	 */
	private function _soundComplete()
	{
		this.next();
	}
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Changer l'index
	 * 
	 * @param pIndex L'index du mp3	 */
	public function setIndex(pIndex:Number)
	{
		if (this.shuffle == 1) {
			this.index = pIndex;
			this._firstPlay = false;
			this.hasPrevious = true;
			this.hasNext = true;
		} else if (this.shuffle == 2) {
			this._randomList = this._shuffle(this.playlist);
			this._randomListIndex = 0;
			for(var i:Number=0; i<this._randomList.length; i++){
				if(this._randomList[i] === pIndex){
					this._randomList.splice(i, 1);
					i--;
				}
			}
			this._randomList.unshift(pIndex);
			this.index = pIndex;
			this.hasPrevious = true;
			this.hasNext = true;
		} else {
			this.index = pIndex;
			this._firstPlay = false;
			this.hasNext = (this.index < this.playlist.length - 1);
			this.hasPrevious = (this.index > 0);
		}
		if (this.isPlaying) {
			this.play();
		}
	}
	/**
	 * Jouer
	 */
	public function play():Void
	{
		if (!this._firstPlay) {
			this._position = 0;
			this._sound = new Sound();
			this._sound.onSoundComplete = this._template.delegate(this, this._soundComplete);
			this._sound.setVolume(this.volume);
			this._sound.loadSound(this.playlist[this.index], true);
			this._firstPlay = true;
		}
		if (this.shuffle == 0) {
			this.hasNext = (this.index < this.playlist.length - 1);
			this.hasPrevious = (this.index > 0);
		}
		this._sound.start(Math.round(this._position / 1000));
		this.isPlaying = true;
	}
	/**
	 * mp3 suivant
	 * 
	 * @return true s'il y a une suite, sinon false
	 */
	public function next():Boolean
	{
		if (this.shuffle === 1) {
			this.index = Math.round(Math.random() * (this.playlist.length - 1));
			this.hasNext = true;
		} else if (this.shuffle === 2) {
			this._randomListIndex++;
			this._randomListIndex %= this._randomList.length;
			this.index = this._randomList[this._randomListIndex];
			this.hasNext = true;
		} else {
			this.index++;
			this.hasNext = (this.index < this.playlist.length - 1);
			
			if (this.index >= this.playlist.length) {
				if (this.loop) {
					this.index = 0;
					this.hasNext = (this.index < this.playlist.length - 1);
				} else {
					this.stop();
					return false;
				}
			}
			this.hasPrevious = (this.index > 0);
		}
		
		this._firstPlay = false;
		if (this.isPlaying) {
			this.play();
		}
		return true;
	}
	/**
	 * mp3 précédent
	 * 
	 * @return true s'il y a un précédent, sinon false
	 */
	public function previous():Boolean
	{
		if (this.shuffle === 1) {
			this.index = Math.round(Math.random() * (this.playlist.length - 1));
			this.hasPrevious = true;
		} else if (this.shuffle === 2) {
			this._randomListIndex--;
			this._randomListIndex = (this._randomListIndex < 0)?0:this._randomListIndex;
			this.index = this._randomList[this._randomListIndex];
			this.hasNext = true;
		} else {
			this.index--;
			this.hasPrevious = (this.index > 0);
			
			if (this.index < 0) {
				// Si on fait précédent la piste 0, on la rejoue
				this.index = 0;
				this.hasPrevious = false;
			}
			this.hasNext = (this.index < this.playlist.length - 1);
		}
		
		this._firstPlay = false;
		if (this.isPlaying) {
			this.play();
		}
		return true;
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
	private function _shuffle(pArray:Array):Array
	{
		var vResult:Array = pArray.slice();
		var tmp:Object;
		var i:Number;
		var j:Number;
		var l:Number = pArray.length - 1;
		
		for(i=0; i<=l; i++) {
			vResult[i] = i;
		}

		for(i=0; i<=l; i++){
			j = Math.round(Math.random()*l);
			tmp = vResult[j];
			vResult[j] = vResult[i];
			vResult[i] = tmp;
		}

		return vResult;
	}
}