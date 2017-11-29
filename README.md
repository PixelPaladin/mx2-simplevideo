# mx2-simplevideo

*mx2-simplevideo* is a small video module for Monkey2. It uses the theoraplayer module and provides a simple video class.

<p align="center">
  <img src="https://i.imgur.com/H0riRMB.png" alt="image: simplevideo module">
</p>

## Installation

1. copy the folder `simplevideo` into your Monkey2 modules folder (`YOUR-MONKEY2-PATH/modules/`)
2. open Ted2 and update your modules:
    
        Menu bar > Build > Update modules

3. rebuild your documentation:
    
        Menu bar > Build > Rebuild documentation

## Example

The following example code loads and renders a video using the simplevideo module:

```monkey
Namespace video_application

#Import "<mojo>"
#Import "<simplevideo>"

Using mojo..
Using simplevideo..

Class AppWindow Extends Window
    Field video:Video
    
    Method New(title:String, width:Int, height:Int)
        Super.New(title, width, height)
        
        'Super.New(title, width, height)
        video = Video.Load("/home/thomas/Projects2/LIBS/video/mini-example/assets/video.ogv")
        video.Play()
    End
    
    Method OnRender( canvas:Canvas ) Override
        App.RequestRender()
        
        ' update and render video:
        video.Update()
        canvas.DrawRect(0, 0, Width, Height, video)
    End
End

Function Main()
    New AppInstance
    New AppWindow("simplevideo example", 320, 180)
    App.Run()
End
```
