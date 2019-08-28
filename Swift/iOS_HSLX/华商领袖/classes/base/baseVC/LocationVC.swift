//
//  LocationVC.swift
//  华商领袖
//
//  Created by hansen on 2019/4/13.
//  Copyright © 2019 huashanglingxiu. All rights reserved.
//

import UIKit

import MJRefresh
private class LocationPoiInfo {
    
    var bmkInfo: BMKPoiInfo?
    var isSelected: Bool?
    
    
    required init(_ bmkInfo: BMKPoiInfo) {
        self.bmkInfo = bmkInfo
    }
}


class LocationVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: BMKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var confirmLocationCallback: ((_ areaCode: String, _ adsress: String,_ latitude: Double,_ longitude: Double) -> Void)?
    
    var locationName: String = ""
    var areaCode: String = ""
    
    private var rgcData:BMKLocationReGeocode?
    fileprivate var dataSources: [LocationPoiInfo] = []
    
    fileprivate var currentCheck: LocationPoiInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "选择地址"
        
        self.setupSubView()
        self.locationManager.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func locationBtnClick(_ sender: Any) {
        self.locationManager.startUpdatingLocation()
        
    }
    
    private func setupSubView() {
        self.tableView.rowHeight = 60
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightBtnClick))
        self.mapView.delegate = self
        self.searchBar.delegate = self
        
        self.tableView.dataSource = self
        self.searchBar.placeholder = "输入地址进行搜索"
        self.tableView.delegate = self
        self.searchBar.returnKeyType = UIReturnKeyType.search
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = BMKUserTrackingModeNone
        self.mapView.zoomLevel = 20
        self.tableView.tableFooterView = UIView()
        self.mapView.updateLocationView(with: self.paramView)
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
        SVProgressHUD.show(withStatus: "定位中...")
        self.mapView.showMapScaleBar = true
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self]  in
                self?.tableView.mj_header.endRefreshing()
            self?.updateNearbyLocation(location: (self?.userLocation.location)!)
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mapView.viewWillDisappear()
    }
    
    @objc func rightBtnClick() {
        
        if (self.confirmLocationCallback != nil) {
            
            if self.currentCheck == nil {
                SVProgressHUD.showInfo(withStatus: "没有明确的位置信息！")
                return
            }
            self.confirmLocationCallback!((self.currentCheck?.bmkInfo?.area!)!, (self.currentCheck?.bmkInfo?.name!)!, self.userLocation.location.coordinate.latitude, self.userLocation.location.coordinate.longitude)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    private func updateNearbyLocation(location: CLLocation) {
        self.userLocation.location = location
        self.mapView.updateLocationData(self.userLocation)
        self.mapView.centerCoordinate = location.coordinate
        
        let nearbySearch = BMKPOINearbySearchOption.init()
        
        nearbySearch.location = CLLocationCoordinate2D.init(latitude: self.userLocation.location.coordinate.latitude, longitude: self.userLocation.location.coordinate.longitude)
        nearbySearch.keywords = ["区域","建筑","小区","公司", "商店"]
        nearbySearch.scope = BMKPOISearchScopeType.BMK_POI_SCOPE_BASIC_INFORMATION
        nearbySearch.pageSize = 20
        nearbySearch.pageIndex = 0
        nearbySearch.radius = 1000
        nearbySearch.isRadiusLimit = true
        self.bmkSearch.poiSearchNear(by: nearbySearch)
        
        
        
        
        
//        self.updateReverseLocation(location: location)
        
        
    }
    
    private func searchDetail(uid: String) {
        let detailSearch = BMKPOIDetailSearchOption.init()
        detailSearch.poiUIDs = [uid]
        detailSearch.scope = BMKPOISearchScopeType.BMK_POI_SCOPE_DETAIL_INFORMATION
        
        self.bmkSearch.poiDetailSearch(detailSearch)
        
    }
    private func updateReverseLocation(location: CLLocation) {
        self.geoCodeSearch.delegate = self
        let reverseSearch = BMKReverseGeoCodeSearchOption.init()
        
        reverseSearch.location = CLLocationCoordinate2D.init(latitude: self.userLocation.location.coordinate.latitude, longitude: self.userLocation.location.coordinate.longitude)
        self.geoCodeSearch.reverseGeoCode(reverseSearch)
        
        
    }
    
    private func searchCity(address: String) {
        
        self.citySearch.keyword = address
        
        self.bmkSearch.poiSearch(inCity: citySearch)
        
    }
    
    private var citySearch: BMKPOICitySearchOption = {
        
        let city = BMKPOICitySearchOption.init()
        
        city.pageSize = 10
        city.pageIndex = 0
        
        return city
        
    }()
    
    private lazy var paramView: BMKLocationViewDisplayParam = {
        
        let param = BMKLocationViewDisplayParam.init()
        param.locationViewOffsetX = 0
        param.locationViewOffsetY = 0
        param.locationViewHierarchy = LocationViewHierarchy.LOCATION_VIEW_HIERARCHY_TOP
        param.isAccuracyCircleShow = false
        
        
        return param
        
    }()
    /// 地理编码检索对象
    private var geoCodeSearch: BMKGeoCodeSearch = {
        
        let geo = BMKGeoCodeSearch.init()
        return geo
    }()
    
    private lazy var bmkSearch: BMKPoiSearch = {
        
        let search = BMKPoiSearch.init()
        search.delegate = self
        
        return search
        
    }()
    
    private var userLocation: BMKUserLocation = {
        
        let location = BMKUserLocation.init()
        
        return location
    }()
    private lazy var locationManager: BMKLocationManager = {
        
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
        locationManager.pausesLocationUpdatesAutomatically = true;
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        locationManager.locationTimeout = 20;
        //设置获取地址信息超时时间
        locationManager.reGeocodeTimeout = 20;
        
        
        return locationManager
    }()
    
    
    deinit {
        self.locationManager.delegate = nil
        self.mapView.delegate = nil
        self.confirmLocationCallback = nil
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LocationVC:  UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        let poiInfo = self.dataSources[indexPath.item]
        if indexPath.row == 0 {
            self.locationName = poiInfo.bmkInfo!.name
        }
        cell!.textLabel!.text = poiInfo.bmkInfo!.name
        cell!.detailTextLabel?.text = poiInfo.bmkInfo!.address
        
        
        cell?.accessoryType = poiInfo.isSelected == true ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.currentCheck?.isSelected = false
        let poiInfo = self.dataSources[indexPath.item]
        poiInfo.isSelected = true
        self.currentCheck = poiInfo
        tableView.reloadData()
        self.userLocation.location = CLLocation.init(latitude: self.currentCheck?.bmkInfo?.pt.latitude ?? 0.0, longitude: self.currentCheck?.bmkInfo?.pt.longitude ?? 0.0)
        self.mapView.updateLocationData(self.userLocation)
        self.mapView.centerCoordinate = self.userLocation.location.coordinate
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let tableVC = LocationSearchResultVC.init()
        tableVC.city = self.rgcData?.city ?? ""
        let vc = UISearchController.init(searchResultsController: tableVC)
        self.present(vc, animated: true, completion: nil)
        vc.searchResultsUpdater = tableVC
        vc.searchBar.placeholder = "输入地址进行搜索"
        vc.searchBar.delegate = tableVC
        
        tableVC.selectedBlock = {
            [weak self] (info) in
            let currentInfo = LocationPoiInfo.init(info)
            currentInfo.isSelected = true
            self?.currentCheck = currentInfo
            
            self?.updateNearbyLocation(location: CLLocation.init(latitude: info.pt.latitude, longitude: info.pt.longitude))
            
        }
//        let cancleBtn = vc.searchBar.value(forKey: "cancelButton") as! UIButton
//        cancleBtn.setTitle("取消", for: UIControl.State.normal)
        
        return false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        
        
    }
    
    
}


extension LocationVC : BMKMapViewDelegate, BMKLocationManagerDelegate {
    
    
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        //设备朝向
        if heading == nil {
            return
        }
        self.userLocation.heading = heading
        self.mapView.updateLocationData(self.userLocation)
    }
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
    
        if (error != nil) {
            print("locaError : [\(String(describing: error))]")
            SVProgressHUD.showError(withStatus: "定位失败！")
            return
        }
        
        if location == nil {
            SVProgressHUD.showError(withStatus: "定位出错！")
            return
        }
        SVProgressHUD.dismiss()
        self.locationName = location?.rgcData?.poiList.first?.name ?? ""
        if location?.rgcData != nil {
            let info = BMKPoiInfo.init()
            info.address = location!.rgcData!.province + location!.rgcData!.city + location!.rgcData!.district + location!.rgcData!.street
            info.name = location?.rgcData?.poiList.first?.name
            info.pt = location!.location!.coordinate
            info.area = location?.rgcData?.adCode
            let currInfo = LocationPoiInfo.init(info)
            currInfo.isSelected = true
            self.currentCheck = currInfo
            self.rgcData = location?.rgcData
        }
        //自动一次定位后。停止自动定位
        self.locationManager.stopUpdatingLocation()
        self.updateNearbyLocation(location: location!.location!)
        if location?.rgcData?.poiList != nil {
            var dict:[String:String] = [:]
            for item in (location?.rgcData!.poiList)! {
                dict["subTitle"] = location!.rgcData!.province + location!.rgcData!.city + location!.rgcData!.district + location!.rgcData!.street
                dict["title"] = item.name
                //                self.dataSources.append(dict)
                //                self.tableView.reloadData()
                debugPrint("uid == \(dict["title"])   name == \(dict["subTitle"])")
            }
        }
        
        
    }
    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        debugPrint("dingwei shibai  === \(String(describing: error))")
    }
    //    func bmkLocationManager(_ manager: BMKLocationManager, didChange status: CLAuthorizationStatus) {
    //        if status == .authorizedAlways || status == .authorizedWhenInUse {
    //            locationManager.startUpdatingLocation()
    //        } else {sdk
    //            locationManager.stopUpdatingLocation()
    //        }
    //    }
    func mapView(_ mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
        debugPrint("click poi标注 location was  update \(mapPoi.pt.latitude)-- \(mapPoi.pt.longitude)")
        self.userLocation.location = CLLocation.init(latitude: mapPoi.pt.latitude, longitude: mapPoi.pt.longitude)
        self.mapView.centerCoordinate = self.userLocation.location.coordinate
        self.mapView.updateLocationData(self.userLocation)
        self.searchDetail(uid: mapPoi.uid)
        self.updateNearbyLocation(location: self.userLocation.location)
        
    }
    
    func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        debugPrint("click blank location was  update \(coordinate.latitude)-- \(coordinate.longitude)")
        self.currentCheck = nil
        self.userLocation.location = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.centerCoordinate = self.userLocation.location.coordinate
        self.mapView.updateLocationData(self.userLocation)
        self.updateNearbyLocation(location: self.userLocation.location)
    
        
        
    }
}



extension LocationVC: BMKPoiSearchDelegate, BMKGeoCodeSearchDelegate {
    
    
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPOISearchResult!, errorCode: BMKSearchErrorCode) {
        self.dataSources.removeAll()
        if self.currentCheck != nil {
            self.dataSources.append(self.currentCheck!)
        }
        if poiResult != nil {
            for item in poiResult.poiInfoList {
                debugPrint("POI result name = \(item.name) address = \(item.address)")
                self.dataSources.append(LocationPoiInfo.init(item))
            }
            self.dataSources.first?.isSelected = true
            self.tableView.reloadData()
        }
        
    }
    
    func onGetPoiDetailResult(_ searcher: BMKPoiSearch!, result poiDetailResult: BMKPOIDetailSearchResult!, errorCode: BMKSearchErrorCode) {
        //选中附近的图标
        if poiDetailResult != nil {
            for item in  poiDetailResult.poiInfoList {
                debugPrint("POI detail result name = \(item.name) address = \(item.address)")
                self.dataSources.append(LocationPoiInfo.init(item))
            }
            let cuurInfo = LocationPoiInfo.init(poiDetailResult.poiInfoList.first!)
            cuurInfo.isSelected = true
            self.currentCheck = cuurInfo
            self.dataSources.first?.isSelected = true
        }
        
        
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeSearchResult!, errorCode error: BMKSearchErrorCode) {
        for item in result.poiList {
            debugPrint("geocode reverse POI result name = \(item.name) address = \(item.address)")
            self.dataSources.append(LocationPoiInfo.init(item))

        }
        self.dataSources.first?.isSelected = true
        self.tableView.reloadData()
        self.geoCodeSearch.delegate = nil
    }
    
}



private class LocationSearchResultVC: UIViewController,UISearchResultsUpdating, BMKPoiSearchDelegate , UISearchBarDelegate{
    
    var dataSources: [BMKPoiInfo] = []
    
    
    var selectedBlock: ((BMKPoiInfo) -> Void)?
    
    var city: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsets.init(top: 54, left: 0, bottom: 0, right: 0)
        self.bmkSearch.delegate = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            [weak self] in
            self?.tableView.mj_header.endRefreshing()
            if let keyword = self?.citySearchOption.keyword {
                self?.citySearchOption.pageIndex = 0
                self?.bmkSearch.poiSearch(inCity: self?.citySearchOption)
            }
        })
    }
    
    private func searchCity(text: String) {
        self.tableView.mj_footer?.resetNoMoreData()
        self.citySearchOption.keyword = text
        self.citySearchOption.tags = ["区域", "建筑"]
        self.citySearchOption.isCityLimit = false
        self.citySearchOption.pageSize = 10
        self.citySearchOption.pageIndex = 0
        self.citySearchOption.city = self.city
        self.bmkSearch.poiSearch(inCity: self.citySearchOption)
        
    }
    
    private lazy var tableView: UITableView = {
        
        
        let view = UITableView.init()
        view.tableFooterView = UIView.init()
        view.rowHeight = 60
        return view
        
    }()
    private var bmkSearch: BMKPoiSearch = {
        
        let search = BMKPoiSearch.init()
        
        
        return search
    }()
    
    private var citySearchOption : BMKPOICitySearchOption = {
        
        let option = BMKPOICitySearchOption.init()
        
        return option
    }()
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
    }
    
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPOISearchResult!, errorCode: BMKSearchErrorCode) {
        
        
        guard poiResult.poiInfoList.count == 0 else {
            if self.tableView.mj_footer == nil {
                self.tableView.mj_footer = MJRefreshBackFooter.init(refreshingBlock: {
                    [weak self] in
                    self?.tableView.mj_footer.endRefreshing()
                    if self?.citySearchOption.keyword.count != 0 {
                        if poiResult.poiInfoList.count < self?.citySearchOption.pageSize ?? 10 {
                            self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                        self?.citySearchOption.pageIndex += 1
                        self?.bmkSearch.poiSearch(inCity: self?.citySearchOption)
                    }
                })
            }
            if poiResult.poiInfoList.count < self.citySearchOption.pageSize {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            if self.citySearchOption.pageIndex > 0 {
                //上拉加载
                var arrayM : [IndexPath] = []
                for item in poiResult.poiInfoList {
                    
                    arrayM.append(IndexPath.init(row: self.dataSources.count, section: 0))
                    self.dataSources.append(item)
                }
                self.tableView.insertRows(at: arrayM, with: UITableView.RowAnimation.none)
            } else {
                self.dataSources.removeAll()
                self.dataSources.append(contentsOf: poiResult.poiInfoList)
                self.tableView.reloadData()
                
            }
           
           
            return
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchCity(text: searchBar.text!)

    }
    
    
    deinit {
        self.bmkSearch.delegate = nil
    }
}


extension LocationSearchResultVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        let info = self.dataSources[indexPath.item]
        
        cell!.textLabel!.text = info.name
        cell!.detailTextLabel?.text = info.address
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.selectedBlock != nil {
            self.selectedBlock!(self.dataSources[indexPath.row])
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
