Namespace simplevideo

#Import "<std>"
#Import "<mojo>"
#Import "<theoraplayer>"

Using std..
Using mojo..
Using theoraplayer..

Class Video
Private
	Global initialized:Bool = False
	Global audiofactory:AudioInterfaceFactory
	Global vidman:VideoManager
	Global data:DataBuffer
	
	Field vidclip:VideoClip
	Field image:Image
	'Field gain:Float = 1
	Global time:Double
	Field loop:Bool = False
	Field free:Bool = False
	
	Function VideoInit:Void()
		If initialized Then Return
		initialized = True
		vidman = VideoManager.getInstance()
		audiofactory = New OpenAL_AudioInterfaceFactory
		vidman.setAudioInterfaceFactory(audiofactory)
	End
	
Public
	#rem monkeydoc Loads a video.
	#end
	Function Load:Video(path:String, shader:Shader = Null)
		Local v := New Video
		
		VideoInit()
		
		v.data = DataBuffer.Load(path)
		v.vidclip = vidman.createVideoClip(data.Data, data.Length)
		If Not v.vidclip Return Null
		If shader = Null Then
			v.image = New Image(v.vidclip.getWidth(), v.vidclip.getHeight(), PixelFormat.RGB24, TextureFlags.Dynamic)
		Else
			v.image = New Image(v.vidclip.getWidth(), v.vidclip.getHeight(), PixelFormat.RGB24, TextureFlags.Dynamic, shader)
		End
		v.vidclip.stop()
		
		time = Now()
		
		Return v
	End
	
	#rem monkeydoc Updates a video.
	#end
	Method Update:Void()
		If free Then Return
		If IsDone() And loop Then
			Stop()
			Play()
		End
		
		If vidclip.isPaused() Return
		
		Local now := Now()
		Local elapsed := now - time
		time = now
		If elapsed > 0.005 Then vidman.update(elapsed)
		Local frame := vidclip.fetchNextFrame()
		
		If frame
			Local pixmap := New Pixmap(vidclip.getWidth(), vidclip.getHeight(), PixelFormat.RGB24,frame.getBuffer(), vidclip.getWidth()*3)
			image.Texture.PastePixmap(pixmap, 0, 0)
			vidclip.popFrame()
		Endif
	End
	
	#rem monkeydoc Plays a video.
	#end
	Method Play:Void()
		If free Then Return
		time = Now()
		vidclip.play()
	End
	
	#rem monkeydoc Pauses a video.
	#end
	Method Pause:Void()
		If free Then Return
		vidclip.pause()
	End
	
	#rem monkeydoc Resumes a video if it is paused, otherwise pauses it.
	#end
	Method TogglePause:Void()
		If free Then Return
		If vidclip.isPaused() Then
			Play()
		Else
			Pause()
		End
	End
	
	#rem monkeydoc The audio volume of the video (between 0.0 and 1.0).
	#end
	Property Volume:Float()
		If free Then Return 1.0
		Return vidclip.getAudioGain()
	Setter(g:Float)
		If free Then Return
		g = Clamp(g, 0.0, 1.0)
		vidclip.setAudioGain(g)
	End
	
	#rem monkeydoc The video image (can be used to render it into an canvas).
	#end
	Property Image:Image()
		Return image
	End
	
	#rem monkeydoc The video image (conversion operator - can be used to render it into an canvas).
	#end
	Operator To:Image()
		Return image
	End
	
	#rem monkeydoc Returns true if video has ended.
	#end
	Method IsDone:Bool()
		If free Then Return True
		Return vidclip.isDone()
	End
	
	#rem monkeydoc Stops a video.
	#end
	Method Stop:Void()
		If free Then Return
		vidclip.stop()
	End
	
	#rem monkeydoc Automaticaly restarts a video if set to true.
	#end
	Property Loop:Bool()
		Return Self.loop
	Setter (loop:Bool)
		Self.loop = loop
	End
	
	#rem monkeydoc Restarts a video.
	#end
	Method Restart:Void()
		If free Then Return
		vidclip.restart()
	End
	
	#rem monkeydoc Returns true if video is paused.
	#end
	Method IsPaused:Bool()
		If free Then Return True
		Return vidclip.isPaused()
	End
	
	#rem monkeydoc The video duration.
	#end
	Property Duration:Float()
		If free Then Return 0.0
		Return vidclip.getDuration()
	End
	
	#rem monkeydoc The current playing time.
	#end
	Property Time:Float()
		If free Then Return 0.0
		Return vidclip.getTimePosition()
	Setter (t:Float)
		vidclip.seek(t)
	End
	
	#rem monkeydoc The video width.
	#end
	Property Width:Int()
		If free Then Return 0
		Return vidclip.getWidth()
	End
	
	#rem monkeydoc The video height.
	#end
	Property Height:Int()
		If free Then Return 0
		Return vidclip.getHeight()
	End
	
	#rem monkeydoc Frees the video data (should be called when video is no longer in use).
	#end
	Method Free:Void()
		If free Then Return
		vidman.destroyVideoClip(vidclip)
		free = True
	End
	
End

