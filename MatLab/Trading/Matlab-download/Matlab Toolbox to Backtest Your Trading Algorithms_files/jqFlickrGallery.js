var jqf={};jqf.jqfobj=null;jqf.imgArray=new Array();jqf.titleArray=new Array();jqf.currentIndex=0;jqf.fImg=null;jqf.galleryName=false;function setFlickrData(g){var h=g.photoset.photo.length;var e="<ul>";for(i=0;i<h;i++){var f="http://farm"+g.photoset.photo[i].farm+".static.flickr.com/"+g.photoset.photo[i].server+"/"+g.photoset.photo[i].id+"_"+g.photoset.photo[i].secret+".jpg";e+='<li><img src="'+f+'" alt="'+g.photoset.photo[i].title+'" /></li>'}jQuery("#flickr_loader").html(e+"</ul>")}function setPrettyFlickrData(h){var j=h.photoset.photo.length,k,f="";if(jqf.galleryName==false){k=""}else{k="["+jqf.galleryName+"]"}for(i=0;i<j;i++){var g="http://farm"+h.photoset.photo[i].farm+".static.flickr.com/"+h.photoset.photo[i].server+"/"+h.photoset.photo[i].id+"_"+h.photoset.photo[i].secret+".jpg";f+='<a href="'+g+'" title="" rel="prettyPhoto'+k+'" class="img-holder prettyPhoto"><img src="'+g+'" alt="'+h.photoset.photo[i].title+'" /><span class="img-zoom" /></a>'}jQuery("#flickr_loader").html(f);jQuery("#flickr_loader a").prettyPhoto()}(function(b){b.fn.flickrGallery=function(f,e,a){if((typeof a==="undefined"||a===null)||isNaN(a)||a<=0){a=9}jqfobj=this;this.css("text-align","center");this.append('<div id="flickr_loader"></div>');b.getScript("http://api.flickr.com/services/rest/?format=json&method=flickr.photosets.getPhotos&photoset_id="+f+"&api_key="+e+"&per_page="+a+"&jsoncallback=setFlickrData",function(c){})};b.fn.prettyFlickrGallery=function(h,f,a,g){if((typeof a==="undefined"||a===null)||isNaN(a)||a<=0){a=9}jqfobj=this;jqf.galleryName=g;this.css("text-align","center");this.append('<div id="flickr_loader"></div>');b.getScript("http://api.flickr.com/services/rest/?format=json&method=flickr.photosets.getPhotos&photoset_id="+h+"&api_key="+f+"&per_page="+a+"&jsoncallback=setPrettyFlickrData",function(c){})}})(jQuery);