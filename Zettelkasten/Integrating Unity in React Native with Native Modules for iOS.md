> Source: https://levelup.gitconnected.com/part-ii-integrating-unity-games-to-react-native-ios-71db9b23d885
# Fix existing issues with iOS
This issues will not be carried around and fixed right after this build
- [x] Modal orientation
```tsx
<Modal
	animationType='none'
	transparent
	visible={isSettingsModalVisible}
	statusBarTranslucent
	supportedOrientations={['landscape']}
	onRequestClose={() => 
	setIsSettingsModalVisible(false)}
>
```

- Fix the Modal in `Header.tsx` to have supportedOrientations as 'landscape'

# Build and Export Unity project

You can create a new Unity Project or Open your existing project in UnityHub.
- File → Build Settings
- Select your scene
- In the platform section select iOS

![https://miro.medium.com/v2/resize:fit:1400/format:webp/1*OML7oLkzX-q3hI1Lcc-mQg.png][https://miro.medium.com/v2/resize:fit:1400/format:webp/1*OML7oLkzX-q3hI1Lcc-mQg.png]

**Update Player Settings** -
click on the player settings from the build settings. `File → Build Settings → Player Settings → Other Settings`

Make the following changes in other settings:
- Set the same Bundle Identification as your react-native project.
- Scripting Language: IL2CPP
- Target Device SDK: Device SDK
- Target Minimum OS Version: 12.0 (as of your requirement)
- Keep other settings as it is.

![https://miro.medium.com/v2/resize:fit:1400/format:webp/1*PaCWHTICIkiNy5zt9rRxuw.png](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*PaCWHTICIkiNy5zt9rRxuw.png)

- Add NativeCallProxy.h and NativeCallProxy.mm files below in `Assets/Plugins/iOS` path of the Unity Project.

> Download files from this URL: https://gist.github.com/Rushit013/e06e8298264e355bb2732705d4558cfe#file-nativecallproxy-h

>  NativeCallProxy.h:
```c
#import <Foundation/Foundation.h>

@protocol NativeCallsProtocol
@required

- (void) sendMessageToMobileApp:(NSString*)message;

@end

__attribute__ ((visibility("default")))
@interface FrameworkLibAPI : NSObject

+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi;

@end
```

> NativeCallProxy.mm
```objective-c++
#import <Foundation/Foundation.h>
#import "NativeCallProxy.h"

@implementation FrameworkLibAPI

id<NativeCallsProtocol> api = NULL;
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi
{
    api = aApi;
}

@end

extern "C"
{
    void sendMessageToMobileApp(const char* message)
    {
        return [api sendMessageToMobileApp:[NSString stringWithUTF8String:message]];
    }
}
```

Once these changes are made, you’re all set to export your iOS project.

**Export iOS Project from Unity**

- From Build Settings,
- Run in Xcode: Select the latest Xcode version here
- Run in Xcode as Release
- Keep other checkboxes unchecked
- Compression Method: Default
- Click on “Build” and save your iOS Project with the name “iOSBuild”
- Compress and share the "iOSBuild"

![https://miro.medium.com/v2/resize:fit:4800/format:webp/1*q9NEX1O-oV9tpxVso3foqA.png](https://miro.medium.com/v2/resize:fit:4800/format:webp/1*q9NEX1O-oV9tpxVso3foqA.png)




# XCode Configuration for Native Modules approach

This is how exported project’s structure looks.

<img src="https://miro.medium.com/v2/resize:fit:1100/format:webp/1*DKLaPUuJkt73VuFJXTNTLA.png" height="500"> <img src="https://i.ibb.co/r2r1gG1P/Screenshot-2025-04-08-at-4-12-20-AM.png" height="500">

- **Add** `Unity-iPhone.xcodeproj` **to your XCode:** press the right mouse button in the Left Navigator XCode -> `Add Files to [project_name]...` -> `[project_root]/ios/iOSBuild/Unity-iPhone.xcodeproj`
- **Add** `UnityFramework.framework` to `General` / section `Frameworks, Libraries, and Embedded Content`
- Select the **Data** folder and set a checkbox in the “Target Membership” section to “UnityFramework”
-  **Locate** the file `NativeCallProxy.h` within the Unity-iPhone project’s `Unity-iPhone/Libraries/Plugins/iOS` folder. Proceed to modify the target membership of UnityFramework from “Project” to “Public.”
- we are using `rnunitygames.m`, `rnunitygames.swift`, `UnityEmbeddedSwift.swift`, and `color_pencil-Bridging-Header.h` to initiate and serve as a link between React Native and Unity.

> **Reference files**: https://gist.github.com/Rushit013/42432d28db23cd7b6088181ae7d3d500

# React Native Code and Unity Bi-directional Communication

```tsx
import React from 'react';  
import {  
	SafeAreaView,  
	StyleSheet,  
	Text,  
	TouchableOpacity,  
	View,  
	NativeModules,  
} from 'react-native';  
  
function App(): JSX.Element {  
	return (  
		<SafeAreaView style={styles.safeAreaContainer}>  
			<View style={styles.rootContainer}>  
				<TouchableOpacity  
				style={styles.actionButton}  
				onPress={() => {  
				NativeModules.rnunitygames.sendDataToUnity(JSON.stringify({}));  
				}}>  
					<Text style={styles.buttonLabel}>Launch Game</Text>  
				</TouchableOpacity>  
			</View>  
		</SafeAreaView>  
	);  
}  
  
const styles = StyleSheet.create({  
	safeAreaContainer: {  
		flex: 1,  
		width: '100%',  
	},  
	rootContainer: {  
		flex: 1,  
		width: '100%',  
		padding: 12,  
		alignItems: 'center',  
		justifyContent: 'center',  
	},  
	actionButton: {  
		height: 45,  
		width: '100%',  
		backgroundColor: 'black',  
		alignItems: 'center',  
		justifyContent: 'center',  
	},  
	buttonLabel: {  
		textAlign: 'center',  
		color: 'white',  
	},  
});  

export default App;
```