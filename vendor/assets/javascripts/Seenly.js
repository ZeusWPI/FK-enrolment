function Seenly() {
	// Create global variable for callbacks
	seenly = this

	// Public:
	seenly.viewfinderWidth = 640;
	seenly.viewfinderHeight = 480;
	seenly.imageWidth = 640;
	seenly.imageHeight = 480;
	seenly.mirror = true;
	seenly.quality = 70;
	seenly.swfURL = "Seenly.swf";
	seenly.serverURL = "";
	seenly.base64 = false;		// Send the photo encoded in base64 to the server
	seenly.fieldName = "snapshot";	// The name of the variable containing the photo sent to the server
	seenly.detectMac = true;		// Detect if the user's PC is a MacBook, and select the iSight by default
	seenly.formFields = {};

	// Public, dynamic:
	seenly.parameters = new Object();	// Parameters send together with the photo to the server
	seenly.debug = false;		// Set to true to get an alert from all non-overridden events

	// Private:
	var movie = null;
	var movieName = "SeenlySWF";
	var overlays = new Array();
	var dynamicOverlays = false;

	function swf() {
		if (!movie) {
			if (navigator.appName.indexOf("Microsoft") != -1) {
				movie = window[movieName];
			} else {
				movie = document[movieName];
			}
		}

		return movie;
	}

	seenly.embed = function(id) {
		var flashvars = {};
		var params = {"allowScriptAccess": "always"};
		var attributes = {"id": movieName};

		swfobject.embedSWF(seenly.swfURL, id, seenly.viewfinderWidth, seenly.viewfinderHeight, 
			"9.0.0", false, flashvars, params, attributes);
	}

	seenly.code = function() {
		var path = seenly.swfURL;

		if (path.indexOf("?") == -1) {
			path += "?";
		} else {
			path += "&";
		}

		var code = '<OBJECT classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=10,0,0,0" WIDTH="' + seenly.viewfinderWidth;
		code += '" HEIGHT="' + seenly.viewfinderHeight + '" id="' + movieName + '"><PARAM NAME=movie VALUE="' + path + '"><PARAM NAME=quality VALUE=high><PARAM NAME=bgcolor VALUE=#000000><PARAM NAME="allowScriptAccess" value="always" /><EMBED src="' +  path + '" quality=high bgcolor=#FFFFFF WIDTH="' + seenly.viewfinderWidth + '" HEIGHT="' + seenly.viewfinderHeight + '" NAME="' + movieName + '" ALIGN="" TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer"></EMBED></OBJECT>';

		return code;
	}

	/* Private API Methods */
	seenly.swfError = function(error) {
		if (seenly.debug) {
			alert("swfError: " + error);
		}

		seenly.onError(error);
	}
	/* seenly.function is called to retrieve the initial overlays and set a flag */
	seenly.swfGetOverlays = function() {
		dynamicOverlays = true;
		var result = seenly.overlays;
		seenly.overlays = null;
		return result;
	}

	seenly.swfGetSettings = function() {
		var settings = new Object();

		settings.viewfinderWidth = seenly.viewfinderWidth;
		settings.viewfinderHeight = seenly.viewfinderHeight;
		settings.imageWidth = seenly.imageWidth;
		settings.imageHeight = seenly.imageHeight;
		settings.mirror = seenly.mirror;
		settings.quality = seenly.quality;
		settings.serverURL = seenly.serverURL;
		settings.base64 = seenly.base64;
		settings.snapName = seenly.snapName;
		settings.detectMac = seenly.detectMac;
		settings.fieldName = seenly.fieldName;
		settings.formFields = seenly.formFields;

		return settings;
	}




	/* Three events triggered by upload() */
	seenly.swfUploadComplete = function(results) {
		seenly.onUploadComplete(results);
	}

	seenly.swfUploadError = function(error) {
		seenly.onUploadError(error);
	}

	seenly.swfUploadStatus = function(httpStatus) {
		seenly.onUploadStatus(httpStatus);
	}


	/* Public API Methods */

	/* Public events */
	/* Overwrite these to hook the events */
	seenly.onError = function(error) {}
	seenly.onUploadComplete = function(results) { if (seenly.debug) alert("onUploadComplete: " + results); }
	seenly.onUploadError = function(error) { if (seenly.debug) alert("onUploadError: " + error); }
	seenly.onUploadStatus = function(httpStatus) { if (seenly.debug) alert("onUploadStatus: " + httpStatus); }		// Sent prior and in addition to any complete or error events

	/* Static and dynamic */
	seenly.addOverlay = function(url, x, y, opacity, burn) {
		var overlay = new Object;

		overlay.url = url;
		overlay.x = x || 0;
		overlay.y = y || 0;
		overlay.opacity = opacity || 1;
		overlay.burn = burn || 1;

		if (dynamicOverlays)
			swf().addOverlay(overlay);
		else
			seenly.overlays.push(overlay);
	}

	/* Dynamic */

	seenly.snap = function() {
		seenly.freeze();
		seenly.upload();
	}

	seenly.freeze = function() {
		return swf().freeze();
	}

	seenly.thaw = function() {
		return swf().thaw();
	}

	seenly.getBase64 = function() {
		return swf().getBase64();
	}

	seenly.upload = function() {
		return swf().upload();
	}
}
