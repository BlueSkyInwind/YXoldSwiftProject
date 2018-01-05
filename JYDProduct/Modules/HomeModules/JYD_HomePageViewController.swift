//
//  JYD_HomePageViewController.swift
//  JYDProduct
//
//  Created by admin on 2018/1/5.
//  Copyright © 2018年 WangYongxin. All rights reserved.
//

import UIKit

class JYD_HomePageViewController: BaseViewController,BMKMapViewDelegate {

    
    var _mapView:BMKMapView?
    
    var circleView:BMKCircle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "急用达"
        
        _mapView = BMKMapView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height))
        self.view.addSubview(_mapView!)
        _mapView?.zoomLevel = 14
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _mapView?.viewWillAppear()
        _mapView?.delegate = self
        addCircleView()
        addPointAnnotation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil
    }
    
    
    func addCircleView()  {
        if circleView == nil {
            circleView = BMKCircle(center: CLLocationCoordinate2DMake(39.915, 116.404), radius: 5000)
        }
        _mapView?.add(circleView!)
    }
    
    func addPointAnnotation()  {
        let locationCoordinate1 = CLLocationCoordinate2DMake(39.915, 116.404)
        let locationCoordinate2 = CLLocationCoordinate2DMake(39.950, 116.430)
        let locationCoordinate3 = CLLocationCoordinate2DMake(39.869, 116.410)
        let locationCoordinate4 = CLLocationCoordinate2DMake(39.930, 116.390)
        let locationCoordinate5 = CLLocationCoordinate2DMake(39.890, 116.450)
        let arr =  [locationCoordinate1,locationCoordinate2,locationCoordinate3,locationCoordinate4,locationCoordinate5]
        for location in arr {
            let annotationPoint = BMKPointAnnotation.init()
            annotationPoint.coordinate = location
            annotationPoint.title = "这一家店"
            _mapView?.addAnnotation(annotationPoint)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if (overlay as? BMKCircle) != nil {
            let circleView = BMKCircleView(overlay: overlay)
            circleView?.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            circleView?.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
            //            circleView?.lineWidth = 5
            return circleView
        }
        return nil
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if  annotation.isKind(of: BMKPointAnnotation.self ){
            let AnnotationViewID = "pointReuseIndentifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationViewID) as! BMKPinAnnotationView?
            if annotationView == nil {
                annotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: AnnotationViewID)
            }
            annotationView?.isDraggable = false
            annotationView?.pinColor = UInt(BMKPinAnnotationColorGreen)
            annotationView?.animatesDrop = true
            annotationView?.annotation = annotation
            return annotationView
        }
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
