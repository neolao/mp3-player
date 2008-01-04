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
 * Template for several mp3
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	1.2.1 (04/01/2008) 
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */ 
class TemplateMulti extends ATemplate
{
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * Template width	 */
	private var _width:Number = 200;
	/**
	 * Template height	 */
	private var _height:Number = 100;
	/**	 * Toolbar height
	 */
	private var _playerHeight:Number = 20;
	
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
	private var _playlistColor:Number = 0x000000;
	private var _playlistAlpha:Number = 50;
	private var _currentMp3Color:Number = 0xffff00;
	private var _scrollbarColor:Number = 0xffffff;
	private var _scrollbarOverColor:Number = 0xffff00;
	private var _showList:Boolean = true;
	private var _showSlider:Boolean = true;
	private var _title:Array;
	private var _showInfo:Boolean = false;
	private var _showVolume:Boolean = false;
	private var _volume:Number = 100;
	private var _volumeMax:Number = 200;
	private var _showLoading:String = "autohide"; // always, autohide, never
	private var _showPlaylistNumbers:Boolean = true;
	
	public var buttonWidth:Number = 26;
	public var volumeWidth:Number = 30;
	public var volumeHeight:Number = 6;
	public var sliderWidth:Number = 20;
	public var sliderHeight:Number = 10;
	
	private var _target:MovieClip = _root;
	private var _backgroundInstance:MovieClip;
	private var _previousButtonInstance:MovieClip;
	private var _playButtonInstance:MovieClip;
	private var _pauseButtonInstance:MovieClip;
	private var _stopButtonInstance:MovieClip;
	private var _infoButtonInstance:MovieClip;
	private var _infoPanel:MovieClip;
	private var _nextButtonInstance:MovieClip;
	private var _volumeButtonInstance:MovieClip;
	private var _separatorsInstance:MovieClip;
	private var _sliderInstance:MovieClip;
	private var _loadingInstance:MovieClip;
	private var _playlistInstance:MovieClip;
	private var _scrollbarInstance:MovieClip;
	
	private var _currentIndex:Number = 0;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Constructor
	 */
	public function TemplateMulti()
	{
		super();
		
		// Initialisation du Stage
		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		
		this._initVars();
		
		if (!this._showList) {
			this._height = this._playerHeight;
		}
		
		this._initBackground();
		this._initPreviousButton();
		this._initPlayButton();
		this._initPauseButton();
		this._initStopButton();
		this._initInfoButton();
		this._initNextButton();
		this._initVolumeButton();
		
		var vMarginSlider:Number = this.buttonWidth*4;
		var vSeparators:Array = [this.buttonWidth, 
								 this.buttonWidth, 
								 this.buttonWidth, 
								 this.buttonWidth];
		if (this._showInfo) {
			vMarginSlider += this.buttonWidth;
			vSeparators.push(this.buttonWidth);
		}
		if (this._showVolume) {
			vMarginSlider += this.volumeWidth;
			vSeparators.push(this.volumeWidth);
		}
		if (this._showSlider) {
			this._initSlider(vMarginSlider);
		} else {
			vMarginSlider -= this.buttonWidth;
			vSeparators.pop();
		}
		this._createSeparators(vSeparators);
		
		// Si la playlist est générée avec un fichier
		// Alors il ne faut pas encore créer l'affichage de la playlist
		if (_root.playlist != undefined) {
			this._loadPlaylist(_root.playlist);
		} else {
			// Use postcast rss
			if (_root.playlistrss != undefined) {
				this._loadPlaylistRss(_root.playlistrss);
			} else {
				this._initPlaylist();
			}
		}
		
		
		this._initInfoPanel();
		
		// Raccourcis clavier
		var vPlayPause:Function = this.delegate(this, function()
		{
			if (this.player.isPlaying) {
				this.pauseRelease();
			} else {
				this.playRelease();
			}
		});
		var vDecreaseVolume:Function = this.delegate(this, function()
		{
			var vVolume:Number = this._volume;
			vVolume -= 10;
			if (vVolume < 0) {
				vVolume = 0;
			}
			this.setVolume(vVolume);
		});
		var vIncreaseVolume:Function = this.delegate(this, function()
		{
			var vVolume:Number = this._volume;
			vVolume += 10;
			if (vVolume > this._volumeMax) {
				vVolume = this._volumeMax;
			}
			this.setVolume(vVolume);
		});
		// touche "Espace"
		this._addShortcut(32, vPlayPause);
		// touche "P"
		this._addShortcut(80, vPlayPause);
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
		// touche flèche haut
		this._addShortcut(38, this.delegate(this, function()
		{
			if (this.player.hasPrevious) {
				this.previousRelease();
			}
		}));
		// touche flèche bas
		this._addShortcut(40, this.delegate(this, function()
		{
			if (this.player.hasNext) {
				this.nextRelease();
			}
		}));
		// touche "-"
		this._addShortcut(109, vDecreaseVolume);
		this._addShortcut(189, vDecreaseVolume);
		// touche "+"
		this._addShortcut(107, vIncreaseVolume);
		this._addShortcut(187, vIncreaseVolume);
		// touche "I"
		this._addShortcut(73, this.delegate(this, function()
		{
			this.infoRelease();
		}));
	}
	/**
	 * Launched by mtasc
	 */
	static function main():Void
	{
		
		// On vérifie s'il y a un fichier de configuration à charger
		if (_root.config != undefined) {
			// Fichier de configuration texte
			var vConfigLoad:LoadVars = new LoadVars();
			vConfigLoad.onData = function(data:String) {
				if (data != undefined) {
					data = data.split("\r\n").join("\n");
					var newdata:Array = data.split("\n");
					
					for (var i=0; i<newdata.length; i++) {
						var detail:Array = newdata[i].split("=");
						if (detail[0] != "") {
							if (_root[detail[0]] == undefined) {
								_root[detail[0]] = detail[1];
							}
						}
					}
				}
				// Initialisation du lecteur
				var player:PlayerBasic = new PlayerMulti(new TemplateMulti());
			};
			vConfigLoad.load(_root.config, vConfigLoad, "GET");
			
		} else if (_root.configxml != undefined) {
			// Fichier de configuration XML
			var vConfigLoad:XML = new XML();
			vConfigLoad.ignoreWhite = true;
			vConfigLoad.onLoad = function(success:Boolean) {
				if (success) {
					for (var i=0; i<this.firstChild.childNodes.length; i++) {
						var name:String = this.firstChild.childNodes[i].attributes.name;
						var value:String = this.firstChild.childNodes[i].attributes.value;
						if (name != "") {
							if (_root[name] == undefined) {
								_root[name] = value;
							}
						}
					}
				}
				// Initialisation du lecteur
				var player:PlayerBasic = new PlayerMulti(new TemplateMulti());
			};
			vConfigLoad.load(_root.configxml);
		} else {
			// Aucun fichier de configuration
			// Initialisation du lecteur
			var player:PlayerBasic = new PlayerMulti(new TemplateMulti());
		}
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/**
	 * Modification d'une variable suivant des priorités
	 * 
	 * @param pVarName Le nom de la variable à modifier
	 * @param pList La liste des valeurs par ordre de priorité
	 * @param pType Le type de la variable: String, Number, Color ou Boolean (String par défaut)
	 * @return true si la variable a été modifié, sinon false
	 */
	private function _setVar(pVarName:String, pList:Array, pType:String):Boolean
	{
		for (var i:Number=0; i<pList.length; i++) {
			if (pList[i] != undefined) {
				switch (pType) {
					case "Number":
						this[pVarName] = parseInt(pList[i], 10);
						break;
					case "Color":
						this[pVarName] = parseInt(pList[i], 16);
						break;
					case "Boolean":
						this[pVarName] = (pList[i] == "false" || pList[i] == false)?false:true;
						break;
					default:
						this[pVarName] = pList[i];
				}
				return true;
			}
		}
		return false;
	}
	/**
	 * Initialisation des variables
	 * 
	 * @param pConfig La configuration par défaut
	 */
	private function _initVars(pConfig:Object)
	{
		this._setVar("_width", [_root.width, pConfig.width], "Number");
		this._setVar("_height", [_root.height, pConfig.height], "Number");
		this._setVar("_backgroundColor", [_root.bgcolor, pConfig.bgcolor], "Color");
		this._setVar("_backgroundColor1", [_root.bgcolor1, pConfig.bgcolor1], "Color");
		this._setVar("_backgroundColor2", [_root.bgcolor2, pConfig.bgcolor2], "Color");
		this._setVar("_buttonColor", [_root.buttoncolor, pConfig.buttoncolor], "Color");
		this._setVar("_buttonOverColor", [_root.buttonovercolor, pConfig.buttonovercolor], "Color");
		this._setVar("_sliderColor1", [_root.slidercolor1, pConfig.slidercolor1], "Color");
		this._setVar("_sliderColor2", [_root.slidercolor2, pConfig.slidercolor2], "Color");
		this._setVar("_sliderOverColor", [_root.sliderovercolor, pConfig.sliderovercolor], "Color");
		this._setVar("_textColor", [_root.textcolor, pConfig.textcolor], "Color");
		this._setVar("_loadingColor", [_root.loadingcolor, pConfig.loadingcolor], "Color");
		this._setVar("_backgroundSkin", [_root.skin, pConfig.skin], "String");
		this._setVar("_playlistColor", [_root.playlistcolor, pConfig.playlistcolor], "Color");
		this._setVar("_playlistAlpha", [_root.playlistalpha, pConfig.playlistalpha], "Number");
		this._setVar("_currentMp3Color", [_root.currentmp3color, pConfig.currentmp3color], "Color");
		this._setVar("_scrollbarColor", [_root.scrollbarcolor, pConfig.scrollbarcolor], "Color");
		this._setVar("_scrollbarOverColor", [_root.scrollbarovercolor, pConfig.scrollbarovercolor], "Color");
		this._setVar("_volume", [_root.volume, pConfig.volume], "Number");
		this._setVar("buttonWidth", [_root.buttonwidth, pConfig.buttonwidth], "Number");
		this._setVar("sliderWidth", [_root.sliderwidth, pConfig.sliderwidth], "Number");
		this._setVar("sliderHeight", [_root.sliderheight, pConfig.sliderheight], "Number");
		this._setVar("volumeWidth", [_root.volumewidth, pConfig.volumewidth], "Number");
		this._setVar("volumeHeight", [_root.volumeheight, pConfig.volumeheight], "Number");
		this._setVar("_showVolume", [_root.showvolume, pConfig.showvolume], "Boolean");
		this._setVar("_showList", [_root.showlist, pConfig.showlist], "Boolean");
		this._setVar("_showSlider", [_root.showslider, pConfig.showslider], "Boolean");
		this._setVar("_showInfo", [_root.showinfo, pConfig.showinfo], "Boolean");
		this._setVar("_showLoading", [_root.showloading, pConfig.showloading], "String");
		this._setVar("_showPlaylistNumbers", [_root.showplaylistnumbers, pConfig.showplaylistnumbers], "Boolean");
		
		if (_root.title != undefined && _root.playlist == undefined) {
			this._title = _root.title.split("|");
		}
		
	}
	/**
	 * Charger une playlist playlist
	 * 
	 * @param pUrl L'adresse de la playlist
	 */
	private function _loadPlaylist(pUrl:String)
	{
		var vList:LoadVars = new LoadVars();
		vList.parent = this;
		vList.onData = function(data:String) {
			if (data != undefined) {
				data = data.split("\r\n").join("\n");
				var newdata:Array = data.split("\n");
				
				var vPlaylist:Array = new Array();
				var vTitle:Array = new Array();
				for (var i=0; i<newdata.length; i++) {
					var detail:Array = newdata[i].split("|");
					if (detail[0] != "") {
						vPlaylist.push(detail[0]);
						vTitle.push(detail[1]);
					}
				}
				this.parent.player.playlist = vPlaylist;
				this.parent._title = vTitle;
				_root.mp3 = vPlaylist.join("|");
				this.parent._initPlaylist();
				this.parent.updatePlaylist();
				
				// autoplay
				if (_root.autoplay == "1") {
					this.parent.player.setIndex(0);
				}
				// shuffle
				if (this.parent.player.shuffle) {
					this.parent.player.next();
				}
			}
		};
		vList.load(pUrl, vList, "GET");
	}
	/**
	 * Load a podcast playlist
	 * 
	 * @param pUrl The podcast URL
	 */
	private function _loadPlaylistRss(pUrl:String)
	{
		var vList:LoadVars = new LoadVars();
		vList.parent = this;
		vList.onData = function(data:String) {
			if (data != undefined) {
				var dataXml:XML = new XML();
				dataXml.ignoreWhite = true;
				dataXml.parseXML(data);
				
				var vPlaylist:Array = new Array();
				this.parent._parseRss2(dataXml.firstChild, vPlaylist);
				
				var urlList:Array = new Array();
				var titleList:Array = new Array();
				for (var i:Number=0; i<vPlaylist.length; i++) {
					urlList.push(vPlaylist[i].url);
					titleList.push(vPlaylist[i].title);
				}
				
				this.parent.player.playlist = urlList;
				this.parent._title = titleList;
				_root.mp3 = urlList.join("|");
				this.parent._initPlaylist();
				this.parent.updatePlaylist();
				
				// autoplay
				if (_root.autoplay == "1") {
					this.parent.player.setIndex(0);
				}
				// shuffle
				if (this.parent.player.shuffle) {
					this.parent.player.next();
				}
			}
		};
		vList.load(pUrl, vList, "GET");
	}
	/**
	 * Parse RSS 2
	 * 
	 * @param pXml The XML
	 * @param pList The list of enclosure	 */
	private function _parseRss2(pXml:XML, pList:Array)
	{
		var items:Array = pXml.firstChild.childNodes;
		var title:String = "no title";
		var url:String = "no url";
		
		for (var i:Number=0; i<items.length; i++) {
			if (items[i].nodeName == "item") {
				title = "no title";
				for (var j:Number=0; j<items[i].childNodes.length; j++) {
					if (items[i].childNodes[j].nodeName == "title") {
						title = items[i].childNodes[j].firstChild.nodeValue;
					}
					if (items[i].childNodes[j].nodeName == "enclosure") {
						url = items[i].childNodes[j].attributes["url"];
						pList.push({title: title, url: url});
					}
				}
			}
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
	 * @param pSizes Les tailles entre chaque séparateur
	 */
	private function _createSeparators(pSizes:Array)
	{
		this._separatorsInstance = this._target.createEmptyMovieClip("separators_mc", this._target.getNextHighestDepth()); 
		
		var vTotal:Number = 0;
		for (var i:Number=0; i<pSizes.length; i++) {
			vTotal += pSizes[i];
			this._separatorsInstance.beginFill(0xcccccc, 50);
			this._separatorsInstance.moveTo(vTotal, 2);
			this._separatorsInstance.lineTo(vTotal, this._playerHeight - 2);
			this._separatorsInstance.lineTo(vTotal + 1, this._playerHeight - 2);
			this._separatorsInstance.lineTo(vTotal + 1, 2);
			this._separatorsInstance.endFill();
			this._separatorsInstance.beginFill(0x666666, 50);
			this._separatorsInstance.lineTo(vTotal - 1, 2);
			this._separatorsInstance.lineTo(vTotal - 1, this._playerHeight - 2);
			this._separatorsInstance.lineTo(vTotal, this._playerHeight - 2);
			this._separatorsInstance.endFill();
		}
	}
	/**
	 * Initialize a button
	 * 
	 * @param pTarget The button instance
	 * @param pWidth The button width
	 */
	private function _initButton(pTarget:MovieClip, pWidth:Number)
	{
		var vArea:MovieClip = pTarget.createEmptyMovieClip("area_mc", pTarget.getNextHighestDepth());
		var vIcon:MovieClip = pTarget.createEmptyMovieClip("icon_mc", pTarget.getNextHighestDepth());
		var width:Number = (pWidth == undefined)?this.buttonWidth:pWidth;
		
		vArea.beginFill(0, 0);
		vArea.moveTo(2, 2);
		vArea.lineTo(2, this._playerHeight - 4);
		vArea.lineTo(width - 4, this._playerHeight - 4);
		vArea.lineTo(width - 4, 2);
		vArea.endFill();
		
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
	 * Initialisation du bouton Previous
	 */
	private function _initPreviousButton()
	{
		// Création
		if (this._previousButtonInstance == undefined) {
			this._previousButtonInstance = this._target.createEmptyMovieClip("previous_btn", this._target.getNextHighestDepth()); 
			this._initButton(this._previousButtonInstance);
		} 
		
		// Position
		this._previousButtonInstance._x = 0;
		
		// Action
		this._previousButtonInstance.area_mc.onRelease = this.delegate(this, this.previousRelease);
		
		// Icone
		this._previousButtonInstance.icon_mc.beginFill(this._buttonColor);
		this._previousButtonInstance.icon_mc.lineTo(0, 8);
		this._previousButtonInstance.icon_mc.lineTo(2, 8);
		this._previousButtonInstance.icon_mc.lineTo(2, 0);
		this._previousButtonInstance.icon_mc.endFill();
		this._previousButtonInstance.icon_mc.moveTo(2, 4);
		this._previousButtonInstance.icon_mc.beginFill(this._buttonColor);
		this._previousButtonInstance.icon_mc.lineTo(8, 8);
		this._previousButtonInstance.icon_mc.lineTo(8, 0);
		this._previousButtonInstance.icon_mc.endFill();
		this._previousButtonInstance.icon_mc._y = this._playerHeight/2 - this._previousButtonInstance.icon_mc._height/2;
		this._previousButtonInstance.icon_mc._x = this.buttonWidth/2 - this._previousButtonInstance.icon_mc._width/2;
	}
	/**
	 * Initialisation du bouton Play
	 */
	private function _initPlayButton()
	{
		// Création
		if (this._playButtonInstance == undefined) {
			this._playButtonInstance = this._target.createEmptyMovieClip("play_btn", this._target.getNextHighestDepth()); 
			this._initButton(this._playButtonInstance);
		} 
		
		// Position
		this._playButtonInstance._x = this.buttonWidth;
		
		// Action
		this._playButtonInstance.area_mc.onRelease = this.delegate(this, this.playRelease);
		
		// icone
		this._playButtonInstance.icon_mc.beginFill(this._buttonColor);
		this._playButtonInstance.icon_mc.lineTo(0, 8);
		this._playButtonInstance.icon_mc.lineTo(6, 4);
		this._playButtonInstance.icon_mc.endFill();
		this._playButtonInstance.icon_mc._y = this._playerHeight/2 - this._playButtonInstance.icon_mc._height/2;
		this._playButtonInstance.icon_mc._x = this.buttonWidth/2 - this._playButtonInstance.icon_mc._width/2;
	}
	/**
	 * Initialisation du bouton Pause
	 */
	private function _initPauseButton()
	{
		// Création
		if (this._pauseButtonInstance == undefined) {
			this._pauseButtonInstance = this._target.createEmptyMovieClip("pause_btn", this._target.getNextHighestDepth()); 
			this._initButton(this._pauseButtonInstance);
		}
		
		// Position
		this._pauseButtonInstance._x = this.buttonWidth;
		
		// Action
		this._pauseButtonInstance.area_mc.onRelease = this.delegate(this, this.pauseRelease);
		
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
		this._pauseButtonInstance.icon_mc._y = this._playerHeight/2 - this._pauseButtonInstance.icon_mc._height/2;
		this._pauseButtonInstance.icon_mc._x = this.buttonWidth/2 - this._pauseButtonInstance.icon_mc._width/2;
	}
	/**
	 * Initialisation du bouton Stop
	 */
	private function _initStopButton()
	{
		// Création
		if (this._stopButtonInstance == undefined) {
			this._stopButtonInstance = this._target.createEmptyMovieClip("stop_btn", this._target.getNextHighestDepth());
			this._initButton(this._stopButtonInstance);
		}
		
		// Position
		this._stopButtonInstance._x = this.buttonWidth*2;
		
		// Action
		this._stopButtonInstance.area_mc.onRelease = this.delegate(this, this.stopRelease);
		
		// icone
		this._stopButtonInstance.icon_mc.beginFill(this._buttonColor);
		this._stopButtonInstance.icon_mc.lineTo(0, 8);
		this._stopButtonInstance.icon_mc.lineTo(8, 8);
		this._stopButtonInstance.icon_mc.lineTo(8, 0);
		this._stopButtonInstance.icon_mc.endFill();
		this._stopButtonInstance.icon_mc._y = this._playerHeight/2 - this._stopButtonInstance.icon_mc._height/2;
		this._stopButtonInstance.icon_mc._x = this.buttonWidth/2 - this._stopButtonInstance.icon_mc._width/2;
	}
	/**
	 * Initialisation du bouton Info
	 */
	private function _initInfoButton()
	{
		if (this._showInfo) {
			// Création
			if (this._infoButtonInstance == undefined) {
				this._infoButtonInstance = this._target.createEmptyMovieClip("info_btn", this._target.getNextHighestDepth()); 
				this._initButton(this._infoButtonInstance);
			}
			
			// Position
			this._infoButtonInstance._x = this.buttonWidth*3;
			
			// Action
			this._infoButtonInstance.area_mc.onRelease = this.delegate(this, this.infoRelease);
			
			// icone
			this._infoButtonInstance.icon_mc.lineStyle(2, this._buttonColor); 
			this._infoButtonInstance.icon_mc.moveTo(0, 2); 
			this._infoButtonInstance.icon_mc.curveTo(0, 0, 2, 0); 
			this._infoButtonInstance.icon_mc.curveTo(4, 0, 4, 2); 
			this._infoButtonInstance.icon_mc.curveTo(4, 3.5, 3, 4); 
			this._infoButtonInstance.icon_mc.curveTo(2, 5, 2, 6); 
			this._infoButtonInstance.icon_mc.moveTo(2, 8); 
			this._infoButtonInstance.icon_mc.lineTo(2, 9); 
			this._infoButtonInstance.icon_mc._y = this._playerHeight/2 - this._infoButtonInstance.icon_mc._height/2 + 2; 
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
				{matrixType:"box", x:0, y:0, w:this._width, h:this._playerHeight, r:Math.PI/2}); 
			this._infoPanel.moveTo(0, 5); 
			this._infoPanel.lineTo(0, this._playerHeight - 5); 
			this._infoPanel.curveTo(0, this._playerHeight, 5, this._playerHeight); 
			this._infoPanel.lineTo(this._width - 5, this._playerHeight); 
			this._infoPanel.curveTo(this._width, this._playerHeight, this._width, this._playerHeight - 5); 
			this._infoPanel.lineTo(this._width, 5); 
			this._infoPanel.curveTo(this._width, 0, this._width - 5, 0); 
			this._infoPanel.lineTo(5, 0); 
			this._infoPanel.curveTo(0, 0, 0, 5); 
			this._infoPanel.endFill();
			
			this._infoPanel.createTextField("time_txt", 1, 2, 0, 70, this._playerHeight); 
			this._infoPanel.createTextField("info_txt", 2, 72, 0, this._width - 74, this._playerHeight); 
			
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
	 * Initialisation du bouton Next
	 */
	private function _initNextButton()
	{
		// Création
		if (this._nextButtonInstance == undefined) {
			this._nextButtonInstance = this._target.createEmptyMovieClip("next_btn", this._target.getNextHighestDepth()); 
			this._initButton(this._nextButtonInstance);
		} 
		
		// Position
		this._nextButtonInstance._x = (this._showInfo)?this.buttonWidth*4:this.buttonWidth*3;
		
		// Action
		this._nextButtonInstance.area_mc.onRelease = this.delegate(this, this.nextRelease);
		
		// Icone
		this._nextButtonInstance.icon_mc.beginFill(this._buttonColor);
		this._nextButtonInstance.icon_mc.lineTo(0, 8);
		this._nextButtonInstance.icon_mc.lineTo(6, 4);
		this._nextButtonInstance.icon_mc.endFill();
		this._nextButtonInstance.icon_mc.moveTo(6, 0);
		this._nextButtonInstance.icon_mc.beginFill(this._buttonColor);
		this._nextButtonInstance.icon_mc.lineTo(8, 0);
		this._nextButtonInstance.icon_mc.lineTo(8, 8);
		this._nextButtonInstance.icon_mc.lineTo(6, 8);
		this._nextButtonInstance.icon_mc.endFill();
		this._nextButtonInstance.icon_mc._y = this._playerHeight/2 - this._nextButtonInstance.icon_mc._height/2;
		this._nextButtonInstance.icon_mc._x = this.buttonWidth/2 - this._nextButtonInstance.icon_mc._width/2;
	}
	/**
	 * Initialisation du bouton Volume
	 */
	private function _initVolumeButton()
	{
		if (this._showVolume) {
			this._volumeButtonInstance = this._target.createEmptyMovieClip("volume_btn", this._target.getNextHighestDepth());
			this._initButton(this._volumeButtonInstance, this.volumeWidth);
			
			// Position
			this._volumeButtonInstance._x = (this._showInfo)?this.buttonWidth*5:this.buttonWidth*4;
			
			this._volumeButtonInstance.area_mc.onPress = this.delegate(this, this._volumePress);
			this._volumeButtonInstance.area_mc.onRelease = this.delegate(this, this._volumeRelease);
			this._volumeButtonInstance.area_mc.onReleaseOutside = this.delegate(this, this._volumeRelease);
			
			// icone fond
			var vIconBackground:MovieClip = this._volumeButtonInstance.icon_mc.createEmptyMovieClip("background_mc", 1);
			vIconBackground.beginFill(this._buttonColor, 25);
			vIconBackground.moveTo(0, this.volumeHeight);
			vIconBackground.lineTo(this.volumeWidth - 8, this.volumeHeight);
			vIconBackground.lineTo(this.volumeWidth - 8, 0);
			vIconBackground.endFill();
			vIconBackground._y = this._playerHeight/2 - vIconBackground._height/2;
			vIconBackground._x = this.volumeWidth/2 - vIconBackground._width/2;
			
			// icone
			this._updateVolume();
		}
	}
	/**
	 * Mise à jour du bouton Volume
	 */
	private function _updateVolume()
	{
		var vIcon:MovieClip;
		if (this._volumeButtonInstance.icon_mc.current_mc == undefined) {
			vIcon = this._volumeButtonInstance.icon_mc.createEmptyMovieClip("current_mc", 2);
		} else {
			vIcon = this._volumeButtonInstance.icon_mc.current_mc;
		}
		vIcon.clear();
		
		if (this._volume > this._volumeMax) {
			this._volume = this._volumeMax;
		}
		
		var vWidth:Number = (this.volumeWidth - 8) * this._volume / this._volumeMax;
		var vRatio:Number = this._volume / this._volumeMax;
		
		vIcon.beginFill(this._buttonColor);
		vIcon.moveTo(0, this.volumeHeight);
		vIcon.lineTo(vWidth, this.volumeHeight);
		vIcon.lineTo(vWidth, this.volumeHeight - this.volumeHeight * vRatio);
		vIcon.endFill();
		vIcon._y = vIcon._parent.background_mc._y;
		vIcon._x = vIcon._parent.background_mc._x;
	}
	/**
	 * Le enterFrame pendant l'appui du bouton Volume
	 */
	private function _volumeEnterFrame()
	{
		var xmouse:Number = this._volumeButtonInstance.icon_mc.current_mc._xmouse;
		var max:Number = this._volumeButtonInstance.icon_mc.background_mc._width;
		if (xmouse < 0) {
			xmouse = 0;
		}
		if (xmouse > max) {
			xmouse = max;
		}
		
		var volume:Number = xmouse * this._volumeMax / max;
		this.setVolume(volume);
	}
	/**
	 * On appuie sur le bouton Volume
	 */
	private function _volumePress()
	{
		this._volumeButtonInstance.onEnterFrame = this.delegate(this, this._volumeEnterFrame);
	}
	/**
	 * On relâche le bouton Volume
	 */
	private function _volumeRelease()
	{
		delete this._volumeButtonInstance.onEnterFrame;
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
		vBarBg._y = this._playerHeight / 2; 
		
		
		// barre de chargement
		this._loadingInstance = this._sliderInstance.createEmptyMovieClip("loading_mc", this._sliderInstance.getNextHighestDepth());
		this._loadingInstance.beginFill(this._loadingColor, 75); 
		this._loadingInstance.moveTo(0, -1) 
		this._loadingInstance.lineTo(this._sliderInstance.width, -1); 
		this._loadingInstance.lineTo(this._sliderInstance.width, 1); 
		this._loadingInstance.lineTo(0, 1); 
		this._loadingInstance.endFill();
		this._loadingInstance._y = this._playerHeight / 2; 
		this._loadingInstance._xscale = 0; 
		this._loadingInstance._visible = false; 
		
		
		// barre slider 
		var vSlider:MovieClip = this._sliderInstance.createEmptyMovieClip("bar_mc", this._sliderInstance.getNextHighestDepth()); 
		vSlider.parent = this;
		vSlider.margin = vMargin;
		vSlider.width = this.sliderWidth;
		vSlider.barWidth = this._sliderInstance.width;
		vSlider.color = new Color(vSlider);
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
		vSlider._y = this._playerHeight/2 - this.sliderHeight / 2;
	}
	/**
	 * Chargement
	 */
	private function _loading()
	{
		var objLoading:Object = this.player.getLoading();
		this._loadingInstance._xscale = (objLoading.percent >= 1)?objLoading.percent:0; 
		if (objLoading.percent == 100) {
			if (this._showLoading != "always") {
				this._loadingInstance._visible = false;
			}
			delete this._loadingInstance.onEnterFrame; 
		}
	}
	/** 
	 * Le enterFrame du slider 
	 */ 
	private function _sliderEnterFrame()
	{
		var total:Number = (this._sliderInstance.loading_mc._visible)?this._sliderInstance.loading_mc._width:this._sliderInstance.width - this.sliderWidth;
		var position:Number = Math.round(this.player.getPosition()/this.player.getDuration() * total); 
		this._sliderInstance.bar_mc._x = position;
		
		if (!this.player.isPlaying && position == total) {
			this.stopRelease();
		}
		if (this._currentIndex != this.player.index) {
			this._currentIndex = this.player.index;
			this.updatePlaylist();
		}
	}
	/**
	 * Initialisation de la playlist
	 * @return true	 */
	private function _initPlaylist():Boolean
	{
		var totalMp3:Number = _root.mp3.split("|").length;
		var version:String = System.capabilities.version;
		if (version.indexOf("MAC") != -1) {
			totalMp3++;
		}
		
		// On vérifie si on affiche la playlist ou pas
		if (!this._showList) {
			return true;
		}
		
		// Création
		this._playlistInstance = this._target.createEmptyMovieClip("playlist_mc", this._target.getNextHighestDepth());
		
		// Position
		this._playlistInstance._y = this._playerHeight;
		
		// Fond
		if (this._backgroundSkin == undefined) {
			this._playlistInstance.moveTo(5, 0);
			this._playlistInstance.beginFill(this._playlistColor, this._playlistAlpha);
			this._playlistInstance.lineTo(this._width - 5, 0);
			this._playlistInstance.lineTo(this._width - 5, this._height - this._playerHeight - 5);
			this._playlistInstance.lineTo(5, this._height - this._playerHeight - 5);
			this._playlistInstance.endFill();
		}
		
		// Champ de texte
		this._playlistInstance.createTextField("list_txt", 1, 5, 0, this._width - 20, this._height - this._playerHeight);
		//this._playlistInstance.list_txt.selectable = false;
		this._playlistInstance.list_txt.html = true;
		
		// Remplissage du champ pour vérifier si ca scroll
		this._playlistInstance.list_txt.text = "";
		for (var i:Number=0; i<totalMp3; i++) {
			this._playlistInstance.list_txt.text += i + "\n";
		}
		
		// Champ de test pour vérifier si un texte scrolle ou pas (je sais, c'est pas top)
		this._playlistInstance.createTextField("textfield_tmp", -1, 5, 0, this._width - 20, 12);
		
		// asfunction
		this._playlistInstance.parent = this;
		this._playlistInstance.play = function(pIndex:String)
		{
			this.parent.player.setIndex(Number(pIndex));
			this.parent.playRelease();
		};
		
		// Scrollbar
		if (this._playlistInstance.list_txt.maxscroll > 1) {
			this._scrollbarInstance = this._playlistInstance.createEmptyMovieClip("scrollbar_mc", 2);
			this._scrollbarInstance.beginFill(this._scrollbarColor);
			this._scrollbarInstance.lineTo(4, 0);
			this._scrollbarInstance.lineTo(4, this._height - this._playerHeight - 5);
			this._scrollbarInstance.lineTo(0, this._height - this._playerHeight - 5);
			this._scrollbarInstance.endFill();
			this._scrollbarInstance._x = this._width - 10;
			this._scrollbarInstance._yscale = (totalMp3 - this._playlistInstance.list_txt.maxscroll + 1)/totalMp3 * 100;
			this._scrollbarInstance.max = (this._height - this._playerHeight - 5) - this._scrollbarInstance._height;
			this._scrollbarInstance.step = this._scrollbarInstance.max / (this._playlistInstance.list_txt.maxscroll - 1);
			this._scrollbarInstance.color = new Color(this._scrollbarInstance);
			this._scrollbarInstance.colorOver = this._scrollbarOverColor;
			this._scrollbarInstance.onRollOver = function()
			{ 
				this.color.setRGB(this.colorOver); 
			}; 
			this._scrollbarInstance.onRollOut = function()
			{  
				var transform:Object = {ra: 100, rb: 0, ga: 100, gb: 0, ba: 100, bb: 0, aa: 100, ab: 0}; 
				this.color.setTransform(transform); 
			}; 
			this._scrollbarInstance.onPress = function()
			{
				this.onEnterFrameAuto = this.onEnterFrame;
				this.startDrag(false, this._x, 0, this._x, this.max);
				this.onEnterFrame = function()
				{
					this._parent.list_txt.scroll = Math.floor((this._y+1) / this.step) + 1;
				}
			}
			this._scrollbarInstance.onRelease = this._scrollbarInstance.onReleaseOutside = function()
			{
				this.stopDrag();
				this.onEnterFrame = this.onEnterFrameAuto;
			}
			this._scrollbarInstance.onEnterFrame = function()
			{
				if (this._parent.list_txt.scroll == this._parent.list_txt.maxscroll) {
					this._y = this.max;
				} else {
					this._y = (this._parent.list_txt.scroll - 1) * this.step;
				}
			}
		}
		
		// Mise à jour de la playlist en permanence
		this._playlistInstance.waitScroll = 0;
		this._playlistInstance.intervalScroll = 0;
		this._playlistInstance.scrollMemo = 0;
		this._playlistInstance.onEnterFrame = this.delegate(this, this.updatePlaylist);
		
		return true;
	}
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Mise à jour de la playlist
	 * 
	 * @param pAutoScroll Indique qu'il faut scroller au bon endroit de la liste	 */
	public function updatePlaylist(pAutoScroll:Boolean)
	{
		var text:String = ""
		var title_tmp:String;
		var color:String = this._textColor.toString(16);
		
		if (this.player.playlist.length > 0) {
			text = "";
		} else {
			text = "<font color=\"#"+color+"\" face=\"_sans\">Liste vide</font>";
		}
		
		// Génération des pistes
		for (var i:Number=0; i<this.player.playlist.length; i++) {
			// Couleur de la piste
			if (i == this.player.index) {
				color = this._currentMp3Color.toString(16)
			} else {
				color = this._textColor.toString(16);
			}
			text += "<font color=\"#"+color+"\" face=\"_sans\">";
			text += "<a href=\"asfunction:play," + i + "\">";
			if (this._showPlaylistNumbers) {
				text += (i+1) + " - ";
			}
			
			// titre de la piste
			if (this._title[i] != undefined) {
				title_tmp = this._title[i];
			} else {
				title_tmp = this.player.playlist[i];
			}
			
			// Défilement automatique pour la piste sélectionnée
			this._playlistInstance.textfield_tmp.text = title_tmp;
			if (i == this.player.index && this._playlistInstance.textfield_tmp.maxhscroll > 0) {
				// On peut scroller
				title_tmp += " - ";
				var textLength:Number = title_tmp.length;
				
				if (++this._playlistInstance.waitScroll < 40) {
					this._playlistInstance.intervalScroll = 0;
				}
				
				title_tmp = title_tmp.substring(this._playlistInstance.scrollMemo, textLength) + title_tmp.substring(0, this._playlistInstance.scrollMemo - 1);
				if (++this._playlistInstance.intervalScroll > 5) {
					this._playlistInstance.scrollMemo += 1;
					this._playlistInstance.intervalScroll = 0;
				}
				this._playlistInstance.scrollMemo = this._playlistInstance.scrollMemo % (textLength);
			}
			this._playlistInstance.textfield_tmp.text = "";
			
			// La fin
			text += title_tmp;
			text += "\n";
			text += "</a>";
			text += "</font>";
		}
		
		this._playlistInstance.list_txt.htmlText = text;
		
		// Scroll automatique sur l'élément
		if (pAutoScroll && this._playlistInstance.list_txt.maxscroll > 1) {
			this._playlistInstance.list_txt.scroll = this._playlistInstance.list_txt.maxscroll - (this.player.playlist.length - 1 - this.player.index);
		}
		
		// Boutons Previous et Next
		this._enableButton(this._nextButtonInstance, this.player.hasNext);
		this._enableButton(this._previousButtonInstance, this.player.hasPrevious);
	}
	/**
	 * Action sur le bouton Previous	 */
	public function previousRelease()
	{
		this.player.previous();
		
		this._currentIndex = this.player.index;
		this.updatePlaylist(true);
	}
	/**
	 * Action sur le bouton Play	 */
	public function playRelease()
	{
		super.playRelease();
		this._enableButton(this._playButtonInstance, false, true);
		this._enableButton(this._pauseButtonInstance, true);
		this._enableButton(this._stopButtonInstance, true);
		this._sliderInstance.onEnterFrame = this.delegate(this, this._sliderEnterFrame);
		
		this._currentIndex = this.player.index;
		
		this._playlistInstance.waitScroll = 0;
		this._playlistInstance.intervalScroll = 0;
		this._playlistInstance.scrollMemo = 0;
		this.updatePlaylist(true);
	}
	/**	 * Action sur le bouton Pause
	 */
	public function pauseRelease()
	{
		super.pauseRelease();
		this._enableButton(this._pauseButtonInstance, false, true);
		this._enableButton(this._playButtonInstance, true);
		
		this.updatePlaylist();
	}
	/**
	 * Action sur le bouton Stop	 */
	public function stopRelease()
	{
		super.stopRelease();
		this._enableButton(this._stopButtonInstance, false);
		this._enableButton(this._pauseButtonInstance, false, true);
		this._enableButton(this._playButtonInstance, true);
		delete this._sliderInstance.onEnterFrame;
		this._sliderInstance.bar_mc._x = 0;
		
		this.updatePlaylist();
	}
	/**
	 * Action sur le bouton info
	 */
	public function infoRelease()
	{
		if (this._infoPanel._visible = !this._infoPanel._visible) {
			this._infoPanel.onEnterFrame = this._infoPanel.update;
		} else {
			delete this._infoPanel.onEnterFrame;
		}
	}
	/**
	 * Action sur le bouton Next
	 */
	public function nextRelease()
	{
		this.player.next();
		
		this._currentIndex = this.player.index;
		this.updatePlaylist(true);
	}
	/**
	 * Modifie le volume
	 * 
	 * Le maximum est de 200
	 * @param pVolume Le nouveau volume
	 */
	public function setVolume(pVolume:Number)
	{
		this._volume = pVolume;
		this._updateVolume();
		this.player.setVolume(pVolume);
	}
	/**
	 * Affichage du chargement
	 */
	public function startLoading():Void
	{
		super.startLoading();
		this._loadingInstance.onEnterFrame = this.delegate(this, this._loading);
		if (this._showLoading != "never") {
			this._loadingInstance._visible = true;
		}
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}