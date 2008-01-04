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
import flash.external.*;
/** 
 * Thème spécial pour le contrôle par javascript
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.3.0 (26/11/2007) 
 * @license		http://creativecommons.org/licenses/by-sa/2.5/ 
 */ 
class TemplateJS extends ATemplate
{
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * Javascript object listener
	 */
	private var _listener:String = "";
	/**
	 * Temporary Javascript object listener
	 */
	private var _listenerTemp:Object;
	/**
	 * Interval update in milliseconds
	 */
	private var _intervalUpdate:Number = 1000;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 */
	public function TemplateJS()
	{
		super();
		
		// Temporary Javascript object listener
		_listenerTemp = new Object();
		
		// Javascript object listener
		if (_root.listener) {
			_listener = _root.listener + ".";
		}
		
		// Use ExternalInterface
		if (_root.useexternalinterface) {
			getURL("javascript:"+_listener+"oooupdate=function(o){eval(o);};void(0);");
		}
		
		// Interval update
		if (_root.interval) {
			_intervalUpdate = Number(_root.interval);
		}
		setInterval(this, "_enterFrame", _intervalUpdate);
	}
	/**
	 * Lancé par mtasc
	 */
	static function main():Void
	{
		_root.method = new TemplateJS();
		var player:PlayerBasic = new PlayerDefault(_root.method);
		
		_root.method.jsInit();
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/**
	 * Update property in the javascript listener
	 * 
	 * @param pName Property name
	 * @param pValue Property value
	 */
	private function _setProperty(pName:String, pValue:Object)
	{
		_listenerTemp[pName] = pValue;
	}
	/**
	 * Global EnterFrame
	 */
	private function _enterFrame()
	{
		var loading:Object = this.player.getLoading();
		
		_setProperty("bytesTotal", loading.total);
		_setProperty("bytesLoaded", loading.loaded);
		_setProperty("bytesPercent", loading.percent);
		_setProperty("position", this.player.getPosition());
		_setProperty("duration", this.player.getDuration());
		_setProperty("volume", this.player.getVolume());
		_setProperty("isPlaying", this.player.isPlaying);
		_setProperty("url", _root.mp3);
		
		var id3:Object = this.player.getID3();
		for (var i:String in id3) {
			_setProperty("id3_"+i, id3[i]);
		}
		
		var js:String = "";
		for (var i:String in _listenerTemp) {
			js += _listener+i+'="'+_listenerTemp[i]+'";';
		}
		
		if (_root.enabled == "true") {
			this.sendToJavascript(js+_listener+"onUpdate();");
		}
	}
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Send command to javascript
	 */
	public function sendToJavascript(pCommand:String)
	{
		if (_root.useexternalinterface) {
			ExternalInterface.call(_listener+"oooupdate", pCommand);
		} else if (System.capabilities.playerType == "ActiveX") {
			fscommand("update", pCommand);
		} else {
			getURL("javascript:"+pCommand);
		}
	}
	/**
	 * Initialize event to Javascript object listener
	 */
	public function jsInit()
	{
		this.sendToJavascript(_listener+"onInit();");
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
	
	/*========================= CONTROLES JAVASCRIPT =========================*/
	/*========================================================================*/
	public function set play(n:String)
	{
		super.playRelease();
		_setProperty("isPlaying", this.player.isPlaying);
	}
	public function set pause(n:String)
	{
		super.pauseRelease();
		_setProperty("isPlaying", this.player.isPlaying);
	}
	public function set stop(n:String)
	{
		super.stopRelease();
		_setProperty("isPlaying", this.player.isPlaying);
	}
	public function set setPosition(n:String)
	{
		this.player.setPosition(Number(n));
	}
	public function set setVolume(n:String)
	{
		this.player.setVolume(Number(n));
		_setProperty("volume", this.player.getVolume());
	}
	public function set setUrl(n:String)
	{
		this.player["_firstPlay"] = false;
		_root.mp3 = n;
		_setProperty("url", _root.mp3);
	}
	/*=================== FIN = CONTROLES JAVASCRIPT = FIN ===================*/
	/*========================================================================*/
}