# react-native-context-menu

## Getting started

`$ npm install react-native-context-menu --save`

### Mostly automatic installation

`$ react-native link react-native-context-menu`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-context-menu` and add `RnContextMenu.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRnContextMenu.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.mpiannucci.rncontextmenu.RnContextMenuPackage;` to the imports at the top of the file
  - Add `new RnContextMenuPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-context-menu'
  	project(':react-native-context-menu').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-context-menu/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-context-menu')
  	```


## Usage
```javascript
import RnContextMenu from 'react-native-context-menu';

// TODO: What to do with the module?
RnContextMenu;
```
