# VPSplashView
## Description
** VPSplashView** is a menu with liquid splash effect, that can use both LongTouch/3D touch gestures.<br>

![VPSplashView Demo](https://github.com/vitalykw/VPSplashView/blob/master/Demo.gif?raw=true)

## Installation
For now you can install **VPSplashView** manually only. Just add VPSplashView folder into your project and start working with VPSplashView.swift in your parent class.

## Example project
Example project shows how you can use this menu for navigation or share. 
With static or dynamic data.
To test it it, clone the repo and run it from the Example directory. 

## Usage
Here is an example of menu initialization:
add MenuDelegate to your class
if you would like to use dynamic data - add MenuDataSource to your class

add VPSplashView.addSplashTo(self.view, menuDelegate: self)

add delegate methods and dataSourceMethods (if required) and Run!

You can change different settings to customize menu in VPSplashMenu.swift.

## Author
Vitalii Popruzhenko, https://ua.linkedin.com/in/vpopruzhenko

## License
**VPSplashView** is available under the MIT License. See the LICENSE file for more info.