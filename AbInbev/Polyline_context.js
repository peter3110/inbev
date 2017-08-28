'use strict';

function PolylineContext () {
    this.currentPath = null;
    this.currentIndex = 0;
}

PolylineContext.prototype.beginPath = function() {};

PolylineContext.prototype.moveTo = function(x, y) {
    if (this.currentPath) {
        var latLng = new google.maps.LatLng(y, x);
        this.currentPath.setAt(this.currentIndex, latLng);
        this.currentIndex++;
    }
};

PolylineContext.prototype.setCurrent = function (path) {
    this.currentPath = path;
};

PolylineContext.prototype.lineTo = function(x, y) {
    if (this.currentPath) {
        var latLng = new google.maps.LatLng(y, x);
        this.currentPath.setAt(this.currentIndex, latLng);
        this.currentIndex++;
    }
};

PolylineContext.prototype.arc = function(x, y, radius, startAngle, endAngle) {
    
};

PolylineContext.prototype.closePath = function() {};