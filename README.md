[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/eiwos/FIWA/master/LICENSE)
# FIWA
Library for haxe and compilable to native javascript based on [FIWA protocol](https://beartek.pw/eiwos/docs/protocol/).

## Installation on haxe
Simply put the command:
```
	haxelib install actuate
```
## Integrate natively into javascript
Download the js file from [here](https://github.com/eiwos/FIWA/releases) and upload it to your web page.
The [api](https://beartek.pw/eiwos/api/fiwa/) will be the same that haxe lib.
**To use iwa in the container the name of the class will be:**

```
fiwa_Fiwa.iwa
```

**in the widget will be:**
```
  fiwa_Fiwa_client.iwa
```
___
**To use extra protocol in the container the name of the class will be:**

```
fiwa_Fiwa.<extraname>
```
*extraname: extraiwa, player and game*

**in the widget will be:**
```
  fiwa_Fiwa_client.<extraname>
```
*extraname: extraiwa, player and game*

## Api
you can view the api [here](https://beartek.pw/eiwos/api/fiwa/)
