Namespace example

#Import "<std>"
#Import "<mojo>"
#Import "<simplevideo>"

#Import "assets/"

Using std..
Using mojo..
Using simplevideo..

Class AppWindow Extends Window
	Field vid:Video

	Method New(title:String, width:Int, height:Int)
		Super.New(title, width, height)
		
		' load and play video in loop mode:
		vid = Video.Load("asset::monkeys.ogv")
		vid.Play()
		vid.Loop = True
	End

	Method OnRender( canvas:Canvas ) Override
		App.RequestRender()
		
		If Mouse.ButtonPressed(MouseButton.Left) Then vid.TogglePause()
		
		' update and render video:
		vid.Update()
		canvas.Color = Color.White
		canvas.DrawRect(0, 0, Width, Height, vid)
		
		' draw pause button when paused
		If vid.IsPaused() Then
			canvas.Color = New Color(0, 0, 0, 0.75)
			canvas.DrawRect(Width/2-20, Height/2-30, 40, 40)
			canvas.Color = Color.White
			canvas.DrawRect(Width/2-8, Height/2-20, 5, 20)
			canvas.DrawRect(Width/2+3, Height/2-20, 5, 20)
		End
		
		' draw scrub bar and counter:
		canvas.Color = New Color(0, 0, 0, 0.75)
		canvas.DrawRect(0, Height-24, Width, 24)
		canvas.Color = Color.White
		canvas.DrawText("click to pause", 2, Height-24)
		canvas.DrawText(Int(vid.Time / 10), Width-12, Height-24, 1.0, 0.0)
		canvas.DrawText(Int(vid.Time Mod 10), Width-2, Height-24, 1.0, 0.0)
		canvas.Color = New Color(0.2, 0.2, 0.2)
		canvas.DrawRect(0, Height-5, Width, 5)
		canvas.Color = Color.Red
		canvas.DrawRect(0, Height-5, Float(Width)*Float(vid.Time)/Float(vid.Duration), 5)
	End
End

Function Main()
	New AppInstance
	New AppWindow("simplevideo example", 320, 180)
	App.Run()
End

