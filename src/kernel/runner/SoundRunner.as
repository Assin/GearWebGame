﻿package kernel.runner{	import com.greensock.TweenLite;	import com.greensock.TweenMax;		import flash.errors.IllegalOperationError;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundLoaderContext;	import flash.media.SoundTransform;	import flash.net.URLRequest;	import flash.utils.Dictionary;	import flash.utils.getQualifiedClassName;				/**	 * The SoundManager is a singleton that allows you to have various ways to control sounds in your project.	 * <p />	 * The SoundManager can load external or library sounds, pause/mute/stop/control volume for one or more sounds at a time,	 * fade sounds up or down, and allows additional control to sounds not readily available through the default classes.	 * <p />	 * This class is dependent on TweenLite (http://www.tweenlite.com) to aid in easily fading the volume of the sound.	 *	 * @author Matt Przybylski [http://www.reintroducing.com]	 * @version 1.0	 */	public class SoundRunner	{		/**		 * 单例字典		 */		private static var dict:Dictionary = new Dictionary();		private static var _instance:SoundRunner;		private static var _allowInstance:Boolean;				private var _ref:Class;				private var _soundsDict:Dictionary;		private var _sounds:Array;		public var muted:Boolean;		/**音量增益*/		private var _volumeGain:Number = 0;				public static function getInstance(ref:Class=null):SoundRunner		{			if(ref == null)				ref = SoundRunner;			if (dict[ref] == null)				dict[ref] = new SoundRunner(ref);			return dict[ref] as SoundRunner;		}				public function SoundRunner(ref:Class)		{			if (dict[ref])				throw new IllegalOperationError(getQualifiedClassName(this) + " is Singleton!!!");			else			{				_ref = ref;				dict[ref] = this;				this._soundsDict = new Dictionary(true);				this._sounds = new Array();			}		}		//- PRIVATE & PROTECTED METHODS ---------------------------------------------------------------------------						//- PUBLIC & INTERNAL METHODS -----------------------------------------------------------------------------			/**		 * Adds a sound from the library to the sounds dictionary for playing in the future.		 *		 * @param $linkageID The class name of the library symbol that was exported for AS		 * @param $name The string identifier of the sound to be used when calling other methods on the sound		 *		 * @return Boolean A boolean value representing if the sound was added successfully		 */		public function addLibrarySound($linkageID:*, $name:String, $volume:Number = 1):Boolean		{			for (var i:int = 0; i < this._sounds.length; i++)			{				if (this._sounds[i].name == $name) return false;			}						var sndObj:Object = new Object();			var snd:Sound;			if($linkageID is Sound)			{				snd = $linkageID;			}			else if($linkageID is Class)			{				snd = new $linkageID;			}			sndObj.name = $name;			sndObj.sound = snd;			sndObj.channel = new SoundChannel();			sndObj.position = 0;			sndObj.paused = true;			sndObj.volume = $volume;			sndObj.startTime = 0;			sndObj.loops = 0;			sndObj.pausedByAll = false;						this._soundsDict[$name] = sndObj;			this._sounds.push(sndObj);						return true;		}				/**		 * Adds an external sound to the sounds dictionary for playing in the future.		 *		 * @param $path A string representing the path where the sound is on the server		 * @param $name The string identifier of the sound to be used when calling other methods on the sound		 * @param $buffer The number, in milliseconds, to buffer the sound before you can play it (default: 1000)		 * @param $checkPolicyFile A boolean that determines whether Flash Player should try to download a cross-domain policy file from the loaded sound's server before beginning to load the sound (default: false)		 *		 * @return Boolean A boolean value representing if the sound was added successfully		 */		public function addExternalSound($path:String, $name:String, $buffer:Number = 1000, $checkPolicyFile:Boolean = false):Boolean		{			for (var i:int = 0; i < this._sounds.length; i++)			{				if (this._sounds[i].name == $name) return false;			}						var sndObj:Object = new Object();			try{				var snd:Sound = new Sound(new URLRequest($path), new SoundLoaderContext($buffer, $checkPolicyFile));			}catch ( err: Error ) {				trace( this, "addExternalSound, Unable to load requested document." );			}						sndObj.name = $name;			sndObj.sound = snd;			sndObj.channel = new SoundChannel();			sndObj.position = 0;			sndObj.paused = true;			sndObj.volume = 1;			sndObj.startTime = 0;			sndObj.loops = 0;			sndObj.pausedByAll = false;						this._soundsDict[$name] = sndObj;			this._sounds.push(sndObj);						return true;		}				/**		 * Removes a sound from the sound dictionary.  After calling this, the sound will not be available until it is re-added.		 *		 * @param $name The string identifier of the sound to remove		 *		 * @return void		 */		public function removeSound($name:String):void		{			var i:int = _sounds.length;			while(--i > -1)			{				if (this._sounds[i].name == $name)				{					this._sounds[i] = null;					this._sounds.splice(i, 1);				}			}			delete this._soundsDict[$name];		}				/**		 * Removes all sounds from the sound dictionary.		 *		 * @return void		 */		public function removeAllSounds():void		{			for (var i:int = 0; i < this._sounds.length; i++)			{				this._sounds[i] = null;			}						this._sounds = new Array();			this._soundsDict = new Dictionary(true);		}				/**		 * Release 		 * 		 */		public function dispose():void		{			stopAllSounds();			removeAllSounds();			if (_ref != null)			{				delete dict[_ref];			}		}		/**		 * Plays or resumes a sound from the sound dictionary with the specified name.		 *		 * @param $name The string identifier of the sound to play		 * @param $volume A number from 0 to 1 representing the volume at which to play the sound (default: 1)		 * @param $startTime A number (in milliseconds) representing the time to start playing the sound at (default: 0)		 * @param $loops An integer representing the number of times to loop the sound (default: 0)		 * @param $len the time of change sound .		 * @return void		 */		public function playSound($name:String, $volume:Number = 1, $startTime:Number = 0, $loops:int = 0, $len:Number = 0):void		{			$volume += this._volumeGain;
			var volume:Number = muted ? 0 : $volume;			var snd:Object = this._soundsDict[$name];			snd.volume = $volume;			snd.startTime = $startTime;			snd.loops = $loops;			snd.len = $len;							if (snd.paused)			{				snd.channel = snd.sound.play(snd.position, snd.loops);			}			else			{				snd.channel = snd.sound.play($startTime, snd.loops);			}						if (!snd.channel)				return;						if ($len == 0)			{				snd.channel.soundTransform = new SoundTransform(volume);			}			else			{				snd.channel.soundTransform = new SoundTransform(0);				TweenLite.killTweensOf(snd.channel);				TweenLite.to(snd.channel, $len, {volume:volume , onComplete:function():void{					TweenLite.killTweensOf(snd.channel);				}});			}						snd.paused = false;		}				/**		 * 		 * @param $name		 * @param $volume		 * @param $startTime		 * @param $loops		 * @param $len 变化需要的时间		 * 		 */		public function play($name:String, $volume:Number = 1, $startTime:Number = 0, $loops:int = 0, $len:Number = 0):void		{			var snd:Object = this._soundsDict[$name];			if(snd == null)			{				var sound:Sound = ResourcesRunner.getInstance().getSound($name);				addLibrarySound(sound,$name,$volume);				playSound($name,$volume,$startTime,$loops,$len);			}			else			{				playSound($name,$volume,$startTime,$loops,$len);			}		}				/**		 * Stops the specified sound.		 *		 * @param $name The string identifier of the sound		 *		 * @return void		 */		public function stopSound($name:String, $len:Number = 0):void		{			var snd:Object = this._soundsDict[$name];			if(snd == null)			{				return;			}			snd.paused = true;					if (snd.channel)			{				TweenLite.killTweensOf(snd.channel);				if ($len==0)				{					snd.channel.stop();					snd.position = snd.channel.position;				}					else				{					TweenLite.to(snd.channel, $len, {volume:0.0, onComplete:function():void{						TweenLite.killTweensOf(snd.channel);						snd.channel.stop();						snd.position = snd.channel.position;					}});				}			}		}				/**		 * Pauses the specified sound.		 *		 * @param $name The string identifier of the sound		 *		 * @return void		 */		public function pauseSound($name:String):void		{			var snd:Object = this._soundsDict[$name];			if (snd != null) 
			{
				snd.paused = true;				if(snd.channel != null)				{					snd.position = snd.channel.position;					snd.channel.stop();				}			}		}				/**		 * Plays all the sounds that are in the sound dictionary.		 *		 * @param $useCurrentlyPlayingOnly A boolean that only plays the sounds which were currently playing before a pauseAllSounds() or stopAllSounds() call (default: false)		 *		 * @return void		 */		public function playAllSounds($useCurrentlyPlayingOnly:Boolean = false):void		{			for (var i:int = 0; i < this._sounds.length; i++)			{				var id:String = this._sounds[i].name;				var snd:Object = this._soundsDict[id];								if ($useCurrentlyPlayingOnly)				{					if (this._soundsDict[id].pausedByAll)					{						this._soundsDict[id].pausedByAll = false;						this.playSound(id,snd.volume,snd.startTime,snd.loops,snd.len);					}				}				else				{					this.playSound(id,snd.volume,snd.startTime,snd.loops,snd.len);				}			}		}				/**		 * Stops all the sounds that are in the sound dictionary.		 *		 * @param $useCurrentlyPlayingOnly A boolean that only stops the sounds which are currently playing (default: true)		 *		 * @return void		 */		public function stopAllSounds($useCurrentlyPlayingOnly:Boolean = true, $len:Number = 0):void		{			for (var i:int = 0; i < this._sounds.length; i++)			{				var id:String = this._sounds[i].name;								if ($useCurrentlyPlayingOnly)				{					if (!this._soundsDict[id].paused)					{						this._soundsDict[id].pausedByAll = true;						this.stopSound(id,$len);					}				}				else				{					this.stopSound(id,$len);				}			}		}				/**		 * Pauses all the sounds that are in the sound dictionary.		 *		 * @param $useCurrentlyPlayingOnly A boolean that only pauses the sounds which are currently playing (default: true)		 *		 * @return void		 */		public function pauseAllSounds($useCurrentlyPlayingOnly:Boolean = true):void		{			for (var i:int = 0; i < this._sounds.length; i++)			{				var id:String = this._sounds[i].name;								if ($useCurrentlyPlayingOnly)				{					if (!this._soundsDict[id].paused)					{						this._soundsDict[id].pausedByAll = true;						this.pauseSound(id);					}				}				else				{					this.pauseSound(id);				}			}		}				/**		 * Fades the sound to the specified volume over the specified amount of time.		 *		 * @param $name The string identifier of the sound		 * @param $targVolume The target volume to fade to, between 0 and 1 (default: 0)		 * @param $fadeLength The time to fade over, in seconds (default: 1)		 *		 * @return void		 */		public function fadeSound($name:String, $targVolume:Number = 0, $fadeLength:Number = 1):void		{			var fadeChannel:SoundChannel = this._soundsDict[$name].channel;						TweenMax.to(fadeChannel, $fadeLength, {volume: $targVolume});		}				/**		 * Mutes the volume for all sounds in the sound dictionary.		 *		 * @return void		 */		public function muteAllSounds():void		{			this.muted = true;			for (var i:int = 0; i < this._sounds.length; i++)			{				var id:String = this._sounds[i].name;								this.setSoundVolume(id, 0);			}		}				/**		 * Resets the volume to their original setting for all sounds in the sound dictionary.		 *		 * @return void		 */		public function unmuteAllSounds():void		{			this.muted = false;			for (var i:int = 0; i < this._sounds.length; i++)			{				var id:String = this._sounds[i].name;				var snd:Object = this._soundsDict[id];				if(snd.channel != null)				{					var curTransform:SoundTransform = snd.channel.soundTransform;					curTransform.volume = snd.volume;					snd.channel.soundTransform = curTransform;				}			}		}				/**		 * Sets the volume of the specified sound.		 *		 * @param $name The string identifier of the sound		 * @param $volume The volume, between 0 and 1, to set the sound to		 *		 * @return void		 */		public function setSoundVolume($name:String, $volume:Number):void		{			var snd:Object = this._soundsDict[$name];			if(snd.channel != null)			{				TweenLite.killTweensOf(snd.channel);				var curTransform:SoundTransform = snd.channel.soundTransform;				curTransform.volume = $volume;				snd.channel.soundTransform = curTransform;			}		}				/**		 * 设置当前实例的所有音量增益		 * 注：此设置会影响该实例的所有声音		 */		public function setAllSoundVolumeGain($gain:Number = 1):void		{			this._volumeGain = $gain;			for (var i:int = 0; i < this._sounds.length; i++)			{				var id:String = this._sounds[i].name;				var snd:Object = this._soundsDict[id];				var volume:Number = snd.channel.soundTransform.volume + $gain;				this.setSoundVolume(id, volume);			}
		}				/**		 * Gets the volume of the specified sound.		 *		 * @param $name The string identifier of the sound		 *		 * @return Number The current volume of the sound		 */		public function getSoundVolume($name:String):Number		{			return this._soundsDict[$name].channel.soundTransform.volume;		}				/**		 * Gets the position of the specified sound.		 *		 * @param $name The string identifier of the sound		 *		 * @return Number The current position of the sound, in milliseconds		 */		public function getSoundPosition($name:String):Number		{			return this._soundsDict[$name].channel.position;		}				/**		 * Gets the duration of the specified sound.		 *		 * @param $name The string identifier of the sound		 *		 * @return Number The length of the sound, in milliseconds		 */		public function getSoundDuration($name:String):Number		{			return this._soundsDict[$name].sound.length;		}				/**		 * Gets the sound object of the specified sound.		 *		 * @param $name The string identifier of the sound		 *		 * @return Sound The sound object		 */		public function getSoundObject($name:String):Sound		{			return this._soundsDict[$name].sound;		}				/**		 * Identifies if the sound is paused or not.		 *		 * @param $name The string identifier of the sound		 *		 * @return Boolean The boolean value of paused or not paused		 */		public function isSoundPaused($name:String):Boolean		{			return this._soundsDict[$name].paused;		}				/**		 * Identifies if the sound was paused or stopped by calling the stopAllSounds() or pauseAllSounds() methods.		 *		 * @param $name The string identifier of the sound		 *		 * @return Number The boolean value of pausedByAll or not pausedByAll		 */		public function isSoundPausedByAll($name:String):Boolean		{			return this._soundsDict[$name].pausedByAll;		}//- EVENT HANDLERS ----------------------------------------------------------------------------------------			//- GETTERS & SETTERS -------------------------------------------------------------------------------------			public function get sounds():Array		{		    return this._sounds;		}	//- HELPERS -----------------------------------------------------------------------------------------------			public function toString():String		{			return getQualifiedClassName(this);		}	//- END CLASS ---------------------------------------------------------------------------------------------	}}