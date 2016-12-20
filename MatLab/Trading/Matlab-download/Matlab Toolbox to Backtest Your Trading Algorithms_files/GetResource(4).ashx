#lightbox{
	background-color:#eee;
	padding: 10px;
	border-bottom: 2px solid #666;
	border-right: 2px solid #666;
	}
#lightboxDetails{
	font-size: 0.8em;
	padding-top: 0.4em;
	}	
#lightboxCaption{ float: left; }
#keyboardMsg{ float: right; }
#closeButton{ top: 5px; right: 5px; }

#lightbox img{ border: none; clear: both;} 
#overlay img{ border: none; }

#overlay{ background-image: url(https://quantiacs.com/App_Themes/QuantNet/css/overlay.png); }

* html #overlay{
	background-color: #333;
	back\ground-color: transparent;
	background-image: url(https://quantiacs.com/App_Themes/QuantNet/css/blank.gif);
	filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src="overlay.png", sizingMethod="scale");
	}
	

/* Minification failed (line 24, error number 1043): 'progid:' is an IE-only construct that generates invalid CSS */