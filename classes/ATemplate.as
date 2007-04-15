/** 
 * Classe abstraite pour un thème
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.9 (02/04/2006) 
 * @link		http://resources.neolao.com/flash/components/player_mp3 
 * @license		http://creativecommons.org/licenses/by-sa/2.5/ 
 */ 
class ATemplate
{
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * L'instance du lecteur	 */
	public var player:PlayerBasic;
	/**
	 * Les raccourcis clavier	 */
	private var _shortcuts:Array;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation	 */
	private function ATemplate()
	{
		this._shortcuts = new Array();
		this._initKey();
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/**
	 * Initialisation du gestionnaire de clavier	 */
	private function _initKey()
	{
		var o:Object = new Object();
		o.onKeyUp = this.delegate(this, function() 
		{
		     if (this._shortcuts[Key.getCode()]) {
		     	this._shortcuts[Key.getCode()]();
		     }
		});
		Key.addListener(o);
	}
	/**
	 * Ajouter un raccourci clavier
	 * 
	 * @param pKeyCode Le code de la touche	 * @param pFunction La fonction à exécuter	 */
	private function _addShortcut(pKeyCode:Number, pFunction:Function)
	{
		this._shortcuts[pKeyCode] = pFunction;
	}
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Action sur le bouton Play
	 */
	public function playRelease()
	{
		this.player.play();
		if (this.player.getLoading().percent != 100) {
			this.startLoading();
		}
	}
	/**
	 * Action sur le bouton Pause
	 */
	public function pauseRelease()
	{
		this.player.pause();
	}
	/**
	 * Action sur le bouton Stop
	 */
	public function stopRelease()
	{
		this.player.stop();
	}
	/**
	 * Affichage du chargement
	 */
	public function startLoading()
	{
		
	}
	/**
	 * Délégation de fonction
	 * 
	 * @param pTarget La cible
	 * @param pFunc La fonction
	 * @return La même fonction avec un scope fixe
	 */
	public function delegate(pTarget:Object, pFunc:Function):Function
	{
		var f:Function = function()
		{
			var target = arguments.callee.target;
			var func = arguments.callee.func;
			return func.apply(target);
		};
 
		f.target = pTarget;
		f.func = pFunc;
 
		return f;
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}