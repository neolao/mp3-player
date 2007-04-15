/** 
 * Thème spécial pour le contrôle par javascript
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.2.1 (03/04/2007) 
 * @link		http://resources.neolao.com/flash/components/player_mp3/templates/js
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
		
		this.sendToJavascript(js+_listener+"onUpdate();");
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
		if (System.capabilities.playerType == "ActiveX") {
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