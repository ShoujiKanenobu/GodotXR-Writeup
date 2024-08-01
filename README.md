# GodotXR Writeup

The prototype can be seen here: https://shouji.itch.io/godotxr-test 

You can swap between 3 kinds of primitives by tapping the screen while in AR Mode


There is a bug where re-entering AR mode causes the screen to be black. You can get around this issue by refreshing the page.
I think it has something to do with the cleanup of exiting AR mode.
## Introduction
I was asked to look into and get a grasp on how Godot's WebXR features work and to build out a quick prototype. The prototype was to be a very simple webpage where the user can view a Cube in AR. This is a quick write up of how that process went. Before getting into it, for the sake of clarity (and because these terms are sometimes used interchangably), I want to quickly define VR, AR, and XR.
+ VR (Virtual Reality): Where the users view is solely the 3D virtual world, and the real world is not meant to be seen.
+ AR (Augmented Reality): Where the users view is a mix of the 3D virtual and real world.
+ XR (Extended Reality): A blanket term for both VR and AR.
  
Ok, now lets dive into it.

### Getting started
The tools for creating XR apps in Godot are already there and awesome for quick development. So much of the work is already done for you if you use the [Godot XR Tools](https://github.com/GodotVR/godot-xr-tools) Asset from Godot's built-in Asset Library. Other than that, David Snopek (The person who wrote the feature) has a tutorial on getting started in WebXR, and it can be seen [here.](https://www.snopekgames.com/tutorial/2023/how-make-vr-game-webxr-godot-4) Using Snopek's tutorial as a start, the tutorial already has set up everything we need to export and test on smartphone browsers. However, doing so puts us in a VR world rather than an AR one. 

So how can we get the real world and the virtual one to be drawn? 

### Passthrough
As stated in the Godot Docs
> Passthrough is a technique where camera images are used to present the environment of the user as the background. This turns a VR headset into an AR headset, often referred to as Mixed Reality or MR.

Basically, wherever our background in the 3D virtual world is empty, show the real world instead. To do this we can use the code snippet from the docs. 

```
func enable_passthrough() -> bool:
  var xr_interface: XRInterface = XRServer.primary_interface
  if xr_interface and xr_interface.is_passthrough_supported():
	if !xr_interface.start_passthrough():
	  return false
  else:
	var modes = xr_interface.get_supported_environment_blend_modes()
	if xr_interface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
	  xr_interface.set_environment_blend_mode(xr_interface.XR_ENV_BLEND_MODE_ALPHA_BLEND)
	elif xr_interface.XR_ENV_BLEND_MODE_ADDITIVE in modes:
	  xr_interface.set_environment_blend_mode(xr_interface.XR_ENV_BLEND_MODE_ADDITIVE)
	else:
	  return false

  get_viewport().transparent_bg = true
  return true
```

There are 3 Environment blend modes in Godot. Opaque, Additive, and Alpha. Both Additive and Alpha allows for passthrough, but is **device dependent** on which one is supported. This code changes the requisite settings to allow for passthrough, asking for what blend mode is supported and switching to that mode. It is also incredibly important that the viewport's transparency is set to 0 as seen in the last line before we return true. More of the nuances for passthrough can be seen [here.](https://docs.godotengine.org/en/stable/tutorials/xr/openxr_passthrough.html)

Run this code on your _start_session event and you're good to go. Add as many 3D objects to you scene as you want and see them in their primitive glory. 
<div>
<img src="https://github.com/ShoujiKanenobu/GodotXR-Writeup/blob/main/XRBall.png" width="250" height="400">
<img src="https://github.com/ShoujiKanenobu/GodotXR-Writeup/blob/main/XRCubeAndTexture.png" width="250" height="400">
</div>

Done!

# Resources/Links

https://www.snopekgames.com/tutorial/2023/how-make-vr-game-webxr-godot-4
https://docs.godotengine.org/en/stable/classes/class_webxrinterface.html
https://docs.godotengine.org/en/stable/tutorials/xr/openxr_passthrough.html
