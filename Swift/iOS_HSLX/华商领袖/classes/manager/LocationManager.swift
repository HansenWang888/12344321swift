//
//  LocationManager.swift
//  华商领袖
//
//  Created by abc on 2019/4/8.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject {

    var latitude: Double? = 0.0//纬度
    var longitude: Double? = 0.0//经度
    
    static let shared = LocationManager()
    
    private override init() {
        
    }
    
    func getLocation() {
        
//        if CLLocationManager.locationServicesEnabled() {
//            self.location.delegate = self
//            self.location.requestLocation()
//            self.location.requestAlwaysAuthorization()
//            self.location.requestWhenInUseAuthorization()
//            self.location.startUpdatingLocation()
//        }
    }
    
    func initialBMKMap() {
        BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_COMMON)
        let isAuthorise =  self.mapManager.start("tW4gPvDvnxhjPGCsxlo9jcUMowGtHkim", generalDelegate: self)
    
        if isAuthorise == false {
            debugPrint("--------百度地图授权失败----------")
        }
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: "tW4gPvDvnxhjPGCsxlo9jcUMowGtHkim", authDelegate: self)
        //设置delegate
        locationManager.delegate = self;
        self.locationManager.startUpdatingLocation()
        
        
    }
    
//    private lazy var location: CLLocationManager = {
//
//        let cll = CLLocationManager.init()
//        cll.distanceFilter = 5.0
//        cll.desiredAccuracy = kCLLocationAccuracyBest
//        return cll
//    }()
    lazy var mapManager: BMKMapManager = {
        
        let manager = BMKMapManager.init()
        return manager
    }()
    
    lazy var locationManager: BMKLocationManager = {
        
        let locationManager = BMKLocationManager.init()
        //设置返回位置的坐标系类型
        locationManager.coordinateType = BMKLocationCoordinateType.BMK09LL;
        //设置距离过滤参数
        locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        locationManager.activityType = CLActivityType.automotiveNavigation;
        //设置是否自动停止位置更新
        locationManager.pausesLocationUpdatesAutomatically = false;
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        locationManager.reGeocodeTimeout = 10;
        
        return locationManager
    }()
    
    
}


extension LocationManager: BMKGeneralDelegate ,BMKLocationAuthDelegate, BMKLocationManagerDelegate {
    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//
//        print("获取定位失败\(error)")
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.location.stopUpdatingLocation()
//
//        let location = locations.last
//
////        self.latitude = location?.coordinate.latitude
////        self.longitude = location?.coordinate.longitude
//        self.longitude = 112.920176
//        self.latitude = 28.208391
//    }
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            location.startUpdatingLocation()
//        } else {
//            location.stopUpdatingLocation()
//        }
//    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
//        let location = locations.last
//
//        self.latitude = location?.coordinate.latitude
//        self.longitude = location?.coordinate.longitude
//                self.longitude = 112.920176
//                self.latitude = 28.208391
    }
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        self.latitude = location?.location?.coordinate.latitude
        self.longitude = location?.location?.coordinate.longitude
    }
    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        
    }
//    func bmkLocationManager(_ manager: BMKLocationManager, didChange status: CLAuthorizationStatus) {
//        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        } else {
//            locationManager.stopUpdatingLocation()
//        }
//    }
    
    
    func onGetPermissionState(_ iError: Int32) {
        if iError != 0 {
            debugPrint("百度地图授权错误 == \(iError)")
        }
    }
    
    func onGetNetworkState(_ iError: Int32) {
        if iError != 0 {
            debugPrint("百度地图网络错误 == \(iError)")
        }

    }


}



