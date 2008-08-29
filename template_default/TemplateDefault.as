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
 * Thème par défaut du lecteur mp3
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	1.0.1 (29/08/2008) 
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */ 
class TemplateDefault extends ATemplate
{
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * Largeur du thème	 */
	private var _width:Number = 200;
	/**
	 * Hauteur du thème	 */
	private var _height:Number = 20;
	
	private var _backgroundSkin:String;
	private var _backgroundColor:Number;
	private var _backgroundColor1:Number = 0x7c7c7c;
	private var _backgroundColor2:Number = 0x000000;
	private var _buttonColor:Number = 0xffffff;
	private var _buttonOverColor:Number = 0xffff00;
	private var _sliderColor1:Number = 0xcccccc;
	private var _sliderColor2:Number = 0x888888;
	private var _sliderOverColor:Number = 0xeeee00;
	private var _textColor:Number = 0xffffff;
	private var _loadingColor:Number = 0xffff00;
	private var _showStop:Boolean = false;
	private var _showInfo:Boolean = false;
	
	public var buttonWidth:Number = 26;
	public var sliderWidth:Number = 20;
	public var sliderHeight:Number = 10;
	
	private var _target:MovieClip = _root;
	private var _backgroundInstance:MovieClip;
	private var _playButtonInstance:MovieClip;
	private var _pauseButtonInstance:MovieClip;
	private var _stopButtonInstance:MovieClip;
	private var _infoButtonInstance:MovieClip;
	private var _infoPanel:MovieClip;
	private var _separatorsInstance:MovieClip;
	private var _sliderInstance:MovieClip;
	private var _loadingInstance:MovieClip;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 */
	public function TemplateDefault()
	{
		super();
		
		this._initVars();
		this._initBackground();
		this._initPlayButton();
		this._initPauseButton();
		this._initStopButton();
		this._initInfoButton();
		
		var vMarginSlider:Number = this.buttonWidth;
		var vSeparators:Number = 1; // Premier séparateur est obligatoire
		if (this._showStop) {
			vMarginSlider += this.buttonWidth;
			vSeparators++;
		}
		if (this._showInfo) {
			vMarginSlider += this.buttonWidth;
			vSeparators++;
		}
		this._initSlider(vMarginSlider);
		this._createSeparators(vSeparators);
		
		this._initInfoPanel();
		
		// Raccourcis clavier
		// touche "P"
		this._addShortcut(80, this.delegate(this, function()
		{
			if (this.player.isPlaying) {
				this.pauseRelease();
			} else {
				this.playRelease();
			}
		}));
		// touche "S"
		this._addShortcut(83, this.delegate(this, function()
		{
			this.stopRelease();
		}));
		// touche flèche gauche
		this._addShortcut(37, this.delegate(this, function()
		{
			this.player.setPosition(this.player.getPosition() - 5000);
		}));
		// touche flèche droite
		this._addShortcut(39, this.delegate(this, function()
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
		var player:PlayerBasic = new PlayerDefault(new TemplateDefault());
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
		if (_root.bgcolor != undefined) {
			this._backgroundColor = parseInt(_root.bgcolor, 16);
		}
		if (_root.bgcolor1 != undefined) {
			this._backgroundColor1 = parseInt(_root.bgcolor1, 16);
		}
		if (_root.bgcolor2 != undefined) {
			this._backgroundColor2 = parseInt(_root.bgcolor2, 16);
		}
		if (_root.buttoncolor != undefined) {
			this._buttonColor = parseInt(_root.buttoncolor, 16);
		}
		if (_root.buttonovercolor != undefined) {
			this._buttonOverColor = parseInt(_root.buttonovercolor, 16);
		}
		if (_root.slidercolor1 != undefined) {
			this._sliderColor1 = parseInt(_root.slidercolor1, 16);
		}
		if (_root.slidercolor2 != undefined) {
			this._sliderColor2 = parseInt(_root.slidercolor2, 16);
		}
		if (_root.sliderovercolor != undefined) {
			this._sliderOverColor = parseInt(_root.sliderovercolor, 16);
		}
		if (_root.textcolor != undefined) {
			this._textColor = parseInt(_root.textcolor, 16);
		}
		if (_root.loadingcolor != undefined) {
			this._loadingColor = parseInt(_root.loadingcolor, 16);
		}
		if (_root.showstop != undefined) {
			this._showStop = true;
		}
		if (_root.showinfo != undefined) {
			this._showInfo = true;
		}
		if (_root.skin != undefined) {
			this._backgroundSkin = _root.skin;
		}
	}
	/**
	 * Initialisation du fond
	 */
	private function _initBackground()
	{
		if (this._backgroundInstance == undefined) {
			this._backgroundInstance = this._target.createEmptyMovieClip("background_mc", this._target.getNextHighestDepth()); 
		}
		
		// La couleur de fond si elle est définie
		if(this._backgroundColor != undefined){ 
			this._backgroundInstance.beginFill(this._backgroundColor); 
			this._backgroundInstance.lineTo(0, this._height); 
			this._backgroundInstance.lineTo(this._width, this._height); 
			this._backgroundInstance.lineTo(this._width, 0); 
			this._backgroundInstance.endFill(); 
		} 
		
		// Le skin s'il est défini
		if (this._backgroundSkin != undefined) {
			// Une image de skin a été définie
			var vSkin:MovieClip = this._backgroundInstance.createEmptyMovieClip("skin_mc", this._backgroundInstance.getNextHighestDepth());
			vSkin.loadMovie(this._backgroundSkin);
		} else {
			// Aucune image de skin n'a été définie
			
			this._backgroundInstance.beginGradientFill("linear", 
				[this._backgroundColor1, this._backgroundColor2], 
				[100,100], 
				[0,255], 
				{matrixType:"box", x:0, y:0, w:this._width, h:this._height, r:Math.PI/2});
			this._backgroundInstance.moveTo(0, 5);
			this._backgroundInstance.lineTo(0, this._height - 5);
			this._backgroundInstance.curveTo(0, this._height, 5, this._height);
			this._backgroundInstance.lineTo(this._width - 5, this._height);
			this._backgroundInstance.curveTo(this._width, this._height, this._width, this._height - 5);
			this._backgroundInstance.lineTo(this._width, 5);
			this._backgroundInstance.curveTo(this._width, 0, this._width - 5, 0);
			this._backgroundInstance.lineTo(5, 0);
			this._backgroundInstance.curveTo(0, 0, 0, 5);
			this._backgroundInstance.endFill();
		}
	}
	/**
	 * Crée les séparateurs de bouton
	 * 
	 * @param pTotal Le nombre de séparateurs
	 */
	private function _createSeparators(pTotal:Number)
	{
		if (this._separatorsInstance == undefined) {
			this._separatorsInstance = this._target.createEmptyMovieClip("separators_mc", this._target.getNextHighestDepth()); 
		}
		
		this._separatorsInstance.clear();
		for (var i:Number=1; i<=pTotal; i++) {
			this._separatorsInstance.beginFill(0xcccccc, 50);
			this._separatorsInstance.moveTo(this.buttonWidth*i, 2);
			this._separatorsInstance.lineTo(this.buttonWidth*i, this._height - 2);
			this._separatorsInstance.lineTo(this.buttonWidth*i + 1, this._height - 2);
			this._separatorsInstance.lineTo(this.buttonWidth*i + 1, 2);
			this._separatorsInstance.endFill();
			this._separatorsInstance.beginFill(0x666666, 50);
			this._separatorsInstance.lineTo(this.buttonWidth*i - 1, 2);
			this._separatorsInstance.lineTo(this.buttonWidth*i - 1, this._height - 2);
			this._separatorsInstance.lineTo(this.buttonWidth*i, this._height - 2);
			this._separatorsInstance.endFill();
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
		vArea.color = new Color(vIcon);
		vArea.onRollOver = function()
		{ 
			this.color.setRGB(this.parent._buttonOverColor); 
		}; 
		vArea.onRollOut = vArea.onDragOut = vArea.onPress = function()
		{ 
			this.color.setRGB(this.parent._buttonColor); 
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
	 * Initialisation du bouton Stop
	 */
	private function _initStopButton()
	{
		if (this._showStop) {
			if (this._stopButtonInstance == undefined) {
				this._stopButtonInstance = this._target.createEmptyMovieClip("stop_btn", this._target.getNextHighestDepth());
				this._initButton(this._stopButtonInstance);
			}
			
			this._stopButtonInstance._x = this.buttonWidth;
			
			this._stopButtonInstance.area_mc.onRelease = this.delegate(this, this.stopRelease);
            
            // Accessibility
            this._stopButtonInstance.area_mc.tabEnabled = true;
            this._stopButtonInstance.area_mc._accProps.name = "Stop";
			
			// icone
			this._stopButtonInstance.icon_mc.beginFill(this._buttonColor);
			this._stopButtonInstance.icon_mc.lineTo(0, 8);
			this._stopButtonInstance.icon_mc.lineTo(8, 8);
			this._stopButtonInstance.icon_mc.lineTo(8, 0);
			this._stopButtonInstance.icon_mc.endFill();
			this._stopButtonInstance.icon_mc._y = this._height/2 - this._stopButtonInstance.icon_mc._height/2;
			this._stopButtonInstance.icon_mc._x = this.buttonWidth/2 - this._stopButtonInstance.icon_mc._width/2;
		}
	}
	/**
	 * Initialisation du bouton Info
	 */
	private function _initInfoButton()
	{
		if (this._showInfo) {
			if (this._infoButtonInstance == undefined) {
				this._infoButtonInstance = this._target.createEmptyMovieClip("info_btn", this._target.getNextHighestDepth()); 
				this._initButton(this._infoButtonInstance);
			}
			
			this._infoButtonInstance._x = (this._showStop)?this.buttonWidth*2:this.buttonWidth;
			
			this._infoButtonInstance.area_mc.onRelease = this.delegate(this, this.infoRelease);
			
			
			this._infoButtonInstance.icon_mc.lineStyle(2, this._buttonColor); 
			this._infoButtonInstance.icon_mc.moveTo(0, 2); 
			this._infoButtonInstance.icon_mc.curveTo(0, 0, 2, 0); 
			this._infoButtonInstance.icon_mc.curveTo(4, 0, 4, 2); 
			this._infoButtonInstance.icon_mc.curveTo(4, 3.5, 3, 4); 
			this._infoButtonInstance.icon_mc.curveTo(2, 5, 2, 6); 
			this._infoButtonInstance.icon_mc.moveTo(2, 8); 
			this._infoButtonInstance.icon_mc.lineTo(2, 9); 
			this._infoButtonInstance.icon_mc._y = this._height/2 - this._infoButtonInstance.icon_mc._height/2 + 2; 
			this._infoButtonInstance.icon_mc._x = this.buttonWidth/2 - this._infoButtonInstance.icon_mc._width/2 + 2; 
		}
	}
	/**
	 * Initialisation du panneau d'information
	 */
	private function _initInfoPanel(){
		if (this._showInfo) {
			if (this._infoPanel == undefined) {
				this._infoPanel = this._target.createEmptyMovieClip("infoPanel_mc", this._target.getNextHighestDepth());
				this._infoPanel.parent = this;
			}
			
			// fond
			this._infoPanel.beginGradientFill("linear",  
				[this._backgroundColor1, this._backgroundColor2],  
				[100,100],  
				[0,255],  
				{matrixType:"box", x:0, y:0, w:this._width, h:this._height, r:Math.PI/2}); 
			this._infoPanel.moveTo(0, 5); 
			this._infoPanel.lineTo(0, this._height - 5); 
			this._infoPanel.curveTo(0, this._height, 5, this._height); 
			this._infoPanel.lineTo(this._width - 5, this._height); 
			this._infoPanel.curveTo(this._width, this._height, this._width, this._height - 5); 
			this._infoPanel.lineTo(this._width, 5); 
			this._infoPanel.curveTo(this._width, 0, this._width - 5, 0); 
			this._infoPanel.lineTo(5, 0); 
			this._infoPanel.curveTo(0, 0, 0, 5); 
			this._infoPanel.endFill();
			
			this._infoPanel.createTextField("time_txt", 1, 2, 0, 70, this._height); 
			this._infoPanel.createTextField("info_txt", 2, 72, 0, this._width - 74, this._height); 
			
			var infoStyle:TextFormat = new TextFormat(); 
			infoStyle.color = this._textColor; 
			infoStyle.font = "_sans"; 
			infoStyle.align = "left"; 
			this._infoPanel.time_txt.selectable = false;
			this._infoPanel.time_txt.setNewTextFormat(infoStyle);
			this._infoPanel.info_txt.selectable = false;
			this._infoPanel.info_txt.setNewTextFormat(infoStyle);
			this._infoPanel._visible = false;
			this._infoPanel.onRelease = function()
			{
				delete this.onEnterFrame;
				this._visible = false;
			};
			
			this._infoPanel.waitScroll = this._infoPanel.scrollMemo = 0;
			this._infoPanel.update = function()
			{
				var sep:String = "";
				this._visible = true;
				this.time_txt.text = "";
				this.info_txt.text = "";
				var id3:Object = this.parent.player.getID3();
				
				if (this.parent.player.getDurationTime() != undefined) {
					this.time_txt.text = this.parent.player.getPositionTime() + "/" + this.parent.player.getDurationTime(); 
				} else {
					this.time_txt.text = "Non chargé";
				}
				
				if (id3.artist != undefined) { 
					this.info_txt.text += sep + id3.artist; 
					sep = " - ";
				} 
				
				if (id3.songname != undefined) { 
					this.info_txt.text += sep + id3.songname; 
				} 
				
				if(this.info_txt.text == ""){ 
					this.info_txt.text += "Inconnu"; 
				} 
				
				// Défilement
				// On teste s'il y a du scroll
				if (this.info_txt.maxhscroll > 0) {
					// On peut scroller
					this.info_txt.text += sep;
					var textLength:Number = this.info_txt.length;
					
					this.info_txt.text = this.info_txt.text.substring(this.scrollMemo, textLength) + this.info_txt.text.substring(0, this.scrollMemo - 1);
					if (++this.waitScroll > 5) {
						this.scrollMemo += 1;
						this.waitScroll = 0;
					}
					this.scrollMemo = this.scrollMemo % (textLength);
				}
			};
		}
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
		vBarBg.beginFill(0x666666, 25);
		vBarBg.moveTo(0, 0);
		vBarBg.lineTo(0, -1);
		vBarBg.lineTo(this._sliderInstance.width, -1);
		vBarBg.lineTo(this._sliderInstance.width, 0);
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
		vSlider.color = new Color(vSlider);
        vSlider.tabEnabled = false;
        if (vSlider._accProps == undefined) {
            vSlider._accProps = new Object();
        }
        vSlider._accProps.silent = true;
        vSlider._accProps.name = "Slider";
		vSlider.onRollOver = function()
		{ 
			this.color.setRGB(this.parent._sliderOverColor); 
		}; 
		vSlider.onRollOut = function()
		{  
			var transform:Object = {ra: 100, rb: 0, ga: 100, gb: 0, ba: 100, bb: 0, aa: 100, ab: 0}; 
			this.color.setTransform(transform); 
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
		
		vSlider.beginGradientFill("linear",  
							[this._sliderColor1, this._sliderColor2],  
							[100,100],  
							[50,150],  
							{matrixType:"box", x:0, y:0, w:this.sliderWidth, h:this.sliderHeight, r:Math.PI/2}); 
		vSlider.moveTo(0, 4);
		vSlider.lineTo(0, this.sliderHeight - 4);
		vSlider.curveTo(0, this.sliderHeight, 4, this.sliderHeight);
		vSlider.lineTo(this.sliderWidth - 4, this.sliderHeight);
		vSlider.curveTo(this.sliderWidth, this.sliderHeight, this.sliderWidth, this.sliderHeight - 4);
		vSlider.lineTo(this.sliderWidth, 4);
		vSlider.curveTo(this.sliderWidth, 0, this.sliderWidth - 4, 0);
		vSlider.lineTo(4, 0);
		vSlider.curveTo(0, 0, 0, 4);
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
		this._enableButton(this._stopButtonInstance, true);
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
		this._enableButton(this._stopButtonInstance, false);
		this._enableButton(this._pauseButtonInstance, false, true);
		this._enableButton(this._playButtonInstance, true);
		delete this._sliderInstance.onEnterFrame;
		this._sliderInstance.bar_mc._x = 0;
	}
	/**
	 * Action sur le bouton info	 */
	public function infoRelease()
	{
		if (this._infoPanel._visible = !this._infoPanel._visible) {
			this._infoPanel.onEnterFrame = this._infoPanel.update;
		} else {
			delete this._infoPanel.onEnterFrame;
		}
	}
	/**
	 * Affichage du chargement
	 */
	public function startLoading():Void
	{
		super.startLoading();
		this._loadingInstance.onEnterFrame = this.delegate(this, this._loading);
		this._loadingInstance._visible = true;
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}