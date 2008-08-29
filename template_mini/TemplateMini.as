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
 * Thème léger
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.3.1 (29/08/2008) 
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */ 
class TemplateMini extends ATemplate
{
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * Largeur du thème	 */
	private var _width:Number = 200;
	/**
	 * Hauteur du thème	 */
	private var _height:Number = 20;
	
	public var buttonWidth:Number = 26;
	public var sliderWidth:Number = 20;
	public var sliderHeight:Number = 10;
	
	private var _buttonColor:Number = 0xffffff;
	private var _sliderColor:Number = 0xcccccc;
	private var _loadingColor:Number = 0xffff00;
	
	private var _target:MovieClip = _root;
	private var _playButtonInstance:MovieClip;
	private var _pauseButtonInstance:MovieClip;
	private var _sliderInstance:MovieClip;
	private var _loadingInstance:MovieClip;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 */
	public function TemplateMini()
	{
		super();
		this._initVars();
		this._initPlayButton();
		this._initPauseButton();
		this._initSlider(this.buttonWidth);
		
		// Raccourcis clavier
		// touche "P"
		this._addShortcut(80, delegate(this, function()
		{
			if (this.player.isPlaying) {
				this.pauseRelease();
			} else {
				this.playRelease();
			}
		}));
		// touche "S"
		this._addShortcut(83, delegate(this, function()
		{
			this.stopRelease();
		}));
		// touche flèche gauche
		this._addShortcut(37, delegate(this, function()
		{
			this.player.setPosition(this.player.getPosition() - 5000);
		}));
		// touche flèche droite
		this._addShortcut(39, delegate(this, function()
		{
			this.player.setPosition(this.player.getPosition() + 5000);
		}));
        
        // Update accessibility properties
        Accessibility.updateProperties();
	}
	/**
	 * Lancé par mtasc
	 */
	static function main():Void
	{
		// Initialisation du lecteur
		var player:PlayerBasic = new PlayerBasic(new TemplateMini());
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/**
	 * Initialisation des variables 
	 */
	private function _initVars()
	{
		if (_root.buttoncolor != undefined) {
			this._buttonColor = parseInt(_root.buttoncolor, 16);
		}
		if (_root.slidercolor != undefined) {
			this._sliderColor = parseInt(_root.slidercolor, 16);
		}
		if (_root.loadingcolor != undefined) {
			this._loadingColor = parseInt(_root.loadingcolor, 16);
		}
	}
	/**
	 * Initialisation d'un bouton
	 * 
	 * @param pTarget Le bouton à initialiser
	 */
	private function _initButton(pTarget:MovieClip)
	{
		var vArea:MovieClip = pTarget.createEmptyMovieClip("area_mc", pTarget.getNextHighestDepth());
		var vIcon:MovieClip = pTarget.createEmptyMovieClip("icon_mc", pTarget.getNextHighestDepth());
		
		vArea.beginFill(0, 0);
		vArea.moveTo(2, 2);
		vArea.lineTo(2, this._height - 4);
		vArea.lineTo(this.buttonWidth - 4, this._height - 4);
		vArea.lineTo(this.buttonWidth - 4, 2);
		vArea.endFill();
		
        if (vArea._accProps == undefined) {
            vArea._accProps = new Object();
        }
        vArea.tabEnabled = false;
		vArea.parent = this;
		vArea.icon = vIcon;
		vArea.onRollOver = function()
		{ 
			this.icon._alpha = 75;
		}; 
		vArea.onRollOut = vArea.onDragOut = vArea.onPress = function()
		{ 
			this.icon._alpha = 100;
		}; 
	}
	/** 
	 * Change l'état d'un bouton
	 * 
	 * @param pButton L'instance du bouton 
	 * @param pStatus true pour activer le bouton, sinon false 
	 * @param pMask (optional) pour masquer complètement le bouton
	 */ 
	private function _enableButton(pButton:MovieClip, pStatus:Boolean, pMask:Boolean)
	{ 
		pButton.area_mc.enabled = pStatus; 
		pButton._visible = !pMask; 
		if (!pStatus) pButton.icon_mc._alpha = 30; 
		else pButton.icon_mc._alpha = 100; 
	} 
	/**
	 * Initialisation du bouton Play
	 */
	private function _initPlayButton()
	{
		if (this._playButtonInstance == undefined) {
			this._playButtonInstance = this._target.createEmptyMovieClip("play_btn", this._target.getNextHighestDepth()); 
			this._initButton(this._playButtonInstance);
		} 
		
		this._playButtonInstance.area_mc.onRelease = this.delegate(this, this.playRelease);
        
        // Accessibility
        this._playButtonInstance.area_mc.tabEnabled = true;
        this._playButtonInstance.area_mc._accProps.name = "Play";
		
		// icone
		this._playButtonInstance.icon_mc.beginFill(this._buttonColor);
		this._playButtonInstance.icon_mc.lineTo(0, 8);
		this._playButtonInstance.icon_mc.lineTo(6, 4);
		this._playButtonInstance.icon_mc.endFill();
		this._playButtonInstance.icon_mc._y = this._height/2 - this._playButtonInstance.icon_mc._height/2;
		this._playButtonInstance.icon_mc._x = this.buttonWidth/2 - this._playButtonInstance.icon_mc._width/2;
	}
	/**
	 * Initialisation du bouton Pause
	 */
	private function _initPauseButton()
	{
		if (this._pauseButtonInstance == undefined) {
			this._pauseButtonInstance = this._target.createEmptyMovieClip("pause_btn", this._target.getNextHighestDepth()); 
			this._initButton(this._pauseButtonInstance);
		}
		
		this._pauseButtonInstance.area_mc.onRelease = this.delegate(this, this.pauseRelease);
        
        // Accessibility
        this._pauseButtonInstance.area_mc.tabEnabled = true;
        this._pauseButtonInstance.area_mc._accProps.name = "Pause";
		
		// icone
		this._pauseButtonInstance.icon_mc.beginFill(this._buttonColor); 
		this._pauseButtonInstance.icon_mc.lineTo(0, 8); 
		this._pauseButtonInstance.icon_mc.lineTo(3, 8); 
		this._pauseButtonInstance.icon_mc.lineTo(3, 0); 
		this._pauseButtonInstance.icon_mc.endFill(); 
		this._pauseButtonInstance.icon_mc.beginFill(this._buttonColor); 
		this._pauseButtonInstance.icon_mc.moveTo(5, 0); 
		this._pauseButtonInstance.icon_mc.lineTo(5, 8); 
		this._pauseButtonInstance.icon_mc.lineTo(8, 8); 
		this._pauseButtonInstance.icon_mc.lineTo(8, 0); 
		this._pauseButtonInstance.icon_mc.endFill(); 
		this._pauseButtonInstance.icon_mc._y = this._height/2 - this._pauseButtonInstance.icon_mc._height/2;
		this._pauseButtonInstance.icon_mc._x = this.buttonWidth/2 - this._pauseButtonInstance.icon_mc._width/2;
	}
	/**
	 * Initialisation de la barre
	 * 
	 * @param pMargin La marge gauche de la barre
	 */
	private function _initSlider(pMargin:Number)
	{
		if (this._sliderInstance == undefined) {
			this._sliderInstance = this._target.createEmptyMovieClip("slider_mc", this._target.getNextHighestDepth());
		}
		
		// calcul de la taille
		var vMargin:Number = pMargin;
		vMargin += 10;
		
		this._sliderInstance._x = vMargin;
		this._sliderInstance.width = this._width - vMargin - 10;
		
		// barre
		this._sliderInstance.barBg_mc.removeMovieClip();
		var vBarBg:MovieClip = this._sliderInstance.createEmptyMovieClip("barBg_mc", this._sliderInstance.getNextHighestDepth()); 
		vBarBg.beginFill(0xcccccc, 25);
		vBarBg.lineTo(this._sliderInstance.width, 0);
		vBarBg.lineTo(this._sliderInstance.width, 1);
		vBarBg.lineTo(0, 1);
		vBarBg.endFill();
		vBarBg._y = this._height / 2; 
		
		
		// barre de chargement
		this._loadingInstance = this._sliderInstance.createEmptyMovieClip("loading_mc", this._sliderInstance.getNextHighestDepth());
		this._loadingInstance.beginFill(this._loadingColor, 75); 
		this._loadingInstance.moveTo(0, -1) 
		this._loadingInstance.lineTo(this._sliderInstance.width, -1); 
		this._loadingInstance.lineTo(this._sliderInstance.width, 1); 
		this._loadingInstance.lineTo(0, 1); 
		this._loadingInstance.endFill();
		this._loadingInstance._y = this._height / 2; 
		this._loadingInstance._xscale = 0; 
		this._loadingInstance._visible = false; 
		
		
		// barre slider 
		var vSlider:MovieClip = this._sliderInstance.createEmptyMovieClip("bar_mc", this._sliderInstance.getNextHighestDepth()); 
		vSlider.parent = this;
		vSlider.margin = vMargin;
		vSlider.width = this.sliderWidth;
		vSlider.barWidth = this._sliderInstance.width;
        
        vSlider.tabEnabled = false;
        if (vSlider._accProps == undefined) {
            vSlider._accProps = new Object();
        }
        vSlider._accProps.silent = true;
        vSlider._accProps.name = "Slider";
        
		vSlider.onRollOver = function()
		{ 
			this._alpha = 75;
		}; 
		vSlider.onRollOut = function()
		{  
			this._alpha = 100;
		}; 
		vSlider.onPress = function()
		{ 
			this.startDrag(false, 0, this._y, this.barWidth - this.width, this._y); 
			delete this.parent._sliderInstance.onEnterFrame;
		}; 
		vSlider.onRelease = vSlider.onReleaseOutside = function()
		{ 
			this.stopDrag(); 
			var position:Number = this._x / (this.barWidth - this.width) * this.parent.player.getDuration(); 
			this.parent.player.setPosition(position);
			if (this.parent.player.isPlaying) {
				this.parent.playRelease();
			}
		}; 
		
		vSlider.beginFill(this._sliderColor); 
		vSlider.lineTo(0, this.sliderHeight);
		vSlider.lineTo(this.sliderWidth, this.sliderHeight);;
		vSlider.lineTo(this.sliderWidth, 0);
		vSlider.endFill();
		vSlider._y = this._height/2 - this.sliderHeight / 2;
	}
	/**
	 * Chargement
	 */
	private function _loading(){
		var objLoading:Object = this.player.getLoading();
		this._loadingInstance._xscale = (objLoading.percent >= 1)?objLoading.percent:0; 
		if (objLoading.percent == 100) { 
			this._loadingInstance._visible = false; 
			delete this._loadingInstance.onEnterFrame; 
		}
	}
	/** 
	 * Le enterFrame du slider 
	 */ 
	private function _sliderEnterFrame(){
		var total:Number = (this._sliderInstance.loading_mc._visible)?this._sliderInstance.loading_mc._width:this._sliderInstance.width - this.sliderWidth;
		var position:Number = Math.round(this.player.getPosition()/this.player.getDuration() * total); 
		this._sliderInstance.bar_mc._x = position;
		
		if (!this.player.isPlaying && position == total) {
			this.stopRelease();
		}
	}
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Action sur le bouton play	 */
	public function playRelease()
	{
		super.playRelease();
		this._enableButton(this._playButtonInstance, false, true);
		this._enableButton(this._pauseButtonInstance, true);
		this._sliderInstance.onEnterFrame = this.delegate(this, this._sliderEnterFrame);
	}
	/**	 * Action sur le bouton pause
	 */
	public function pauseRelease()
	{
		super.pauseRelease();
		this._enableButton(this._pauseButtonInstance, false, true);
		this._enableButton(this._playButtonInstance, true);
	}
	/**
	 * Action sur le bouton stop	 */
	public function stopRelease()
	{
		super.stopRelease();
		this._enableButton(this._pauseButtonInstance, false, true);
		this._enableButton(this._playButtonInstance, true);
		delete this._sliderInstance.onEnterFrame;
		this._sliderInstance.bar_mc._x = 0;
	}
	/**
	 * Affichage du chargement
	 */
	public function startLoading():Void
	{
		super.startLoading();
		this._loadingInstance.onEnterFrame = delegate(this, this._loading);
		this._loadingInstance._visible = true;
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}