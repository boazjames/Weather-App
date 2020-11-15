//
//  LocationDetailsViewController.swift
//  Sendy Interview
//
//  Created by Boaz James on 14/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit
import CoreData

class LocationDetailsViewController: UIViewController {
    var item: NSManagedObject!
    var days: [Date] = []
    var items: [[WeatherItem]] = []
    var currentItems: [WeatherItem] = []
    var selectedDayIndex = 0
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var todayView: TodayView = {
        let tdView = TodayView()
        tdView.translatesAutoresizingMaskIntoConstraints = false
        return tdView
    }()
    
    private var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.isTranslucent = false
        if var textAttributes = navBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
            navBar.titleTextAttributes = textAttributes
        }
        return navBar
    }()
    
    var navItem = {
        return UINavigationItem()
    }()
    
    var layoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide
        } else {
            return view.layoutMarginsGuide
        }
    }
    
    private var tableView: UITableView = {
        let tblView = UITableView()
        tblView.allowsSelectionDuringEditing = false
        if #available(iOS 11.0, *) {
            tblView.contentInsetAdjustmentBehavior = .never
        }
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.allowsSelection = false
        return tblView
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let rect = CGRect()
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        configureCollectionView()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedDayIndex = 0
        setupDates()
        setupData()
        getCurrentWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideProgress()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        let backItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissController))
        navItem.leftBarButtonItem = backItem
        
        navBar.setItems([navItem], animated: false)
        
        view.addSubview(navBar)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([navBar.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
                                     navBar.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
                                     navBar.topAnchor.constraint(equalTo: layoutGuide.topAnchor)])
        
        containerView.addSubview(todayView)
        
        NSLayoutConstraint.activate(
            [containerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
             containerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
             containerView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 1),
             containerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
        ])
        
        todayView.pinToView(parentView: containerView, bottom: false)
    }
    
    private func configureCollectionView() {
        containerView.addSubview(collectionView)
        collectionView.pinToView(parentView: containerView, top: false, bottom: false)
        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor.constraint(equalTo: todayView.bottomAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func configureTableView() {
        containerView.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.pinToView(parentView: containerView, top: false)
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(WeatherCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc private func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupData() {
        navItem.title = item.value(forKey: "address") as? String
    }
    
}

// MARK: UITableViewDataSource
extension LocationDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherCell
        cell.selectionStyle = .none
        let ele = currentItems[indexPath.row]
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeFmt = DateFormatter()
        timeFmt.dateFormat = "h:mm a"
        let date = dateFmt.date(from: ele.dt_txt)!
        cell.lblTime.text = timeFmt.string(from: date)
        
        let iconLink = String(format: ICON_URL, ele.weather[0].icon)
        cell.imgView.load(link: iconLink)
        
        let hum = "\(ele.main.humidity)%"
        let humTxt = "Humidity: \(hum)"
        let humRange = humTxt.range(of: hum)!
        let humNsRange = NSRange(humRange, in: humTxt)
        let humAttrStr = NSMutableAttributedString(string: humTxt)
        humAttrStr.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray],
                                 range: humNsRange)
        cell.lblHum.attributedText = humAttrStr
        
        let precip = "\(ele.pop * 100)%"
        let precipTxt = "Precipipitation: \(precip)"
        let precipRange = precipTxt.range(of: precip)!
        let precipNsRange = NSRange(precipRange, in: precipTxt)
        let precipAttrStr = NSMutableAttributedString(string: precipTxt)
        precipAttrStr.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray],
                                    range: precipNsRange)
        cell.lblPrecip.attributedText = precipAttrStr
        
        var win: String {
            if Configuration.getUnits() == UNIT_IMPERIAL {
                return "\(ele.wind.speed)m/h"
            } else {
                return "\(ele.wind.speed)km/h"
            }
        }
        
        let winTxt = "Wind: \(win)"
        let winRange = winTxt.range(of: win)!
        let winNsRange = NSRange(winRange, in: winTxt)
        let winAttrStr = NSMutableAttributedString(string: winTxt)
        winAttrStr.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray],
                                 range: winNsRange)
        cell.lblWind.attributedText = winAttrStr
        
        var tempUnit: String {
            if Configuration.getUnits() == UNIT_IMPERIAL || Configuration.getUnits() == UNIT_STANDARD {
                return "°F"
            } else {
                return "°C"
            }
        }
        
        var temp: String {
            if Configuration.getUnits() == UNIT_IMPERIAL || Configuration.getUnits() == UNIT_STANDARD {
                let temp: Int = Int(ele.main.temp)
                return String(temp)
            } else {
                return "\(ele.main.temp)"
            }
        }
        
        let tempTxt = "\(temp)\(tempUnit)"
        let tempRange = tempTxt.range(of: tempUnit)!
        let tempNsRange = NSRange(tempRange, in: tempTxt)
        let tempAttrStr = NSMutableAttributedString(string: tempTxt)
        let fnt = UIFont(name: "Futura", size: 17.0)
        tempAttrStr.setAttributes([NSAttributedString.Key.font : fnt!, NSAttributedString.Key.baselineOffset: 10],
                                  range: tempNsRange)
        cell.lblTemp.attributedText = tempAttrStr
        
        return cell
    }
    
    
}

// MARK: UITableViewDelegate
extension LocationDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableView.automaticDimension
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: UICollectionViewDelegate
extension LocationDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (self.collectionView.frame.size.height - space)
        return CGSize(width: space + 120, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if indexPath.row != self.selectedDayIndex {
                let indexPath2 = IndexPath(row: self.selectedDayIndex, section: 0)
                self.selectedDayIndex = indexPath.row
                collectionView.reloadItems(at: [indexPath, indexPath2])
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.currentItems = self.items[indexPath.row]
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

// MARK: UICollectionViewDataSource
extension LocationDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DayCell
        let now = Date.currentDate()
        let day = Calendar.current.dateComponents([.day], from: now).day!
        let date = days[indexPath.row]
        let myDay = Calendar.current.dateComponents([.day], from: date).day!
        let diff = myDay - day
        if day == myDay {
            cell.label.text = "Today"
        } else if diff == 1 {
            cell.label.text = "Tomorrow"
        } else {
            let dateFmt = DateFormatter()
            dateFmt.timeZone = .current
            dateFmt.dateFormat = "EEE, MMM dd"
            cell.label.text = dateFmt.string(from: date)
        }
        
        if indexPath.row == self.selectedDayIndex {
            cell.cardView.backgroundColor = cell.tintColor
            cell.label.textColor = .white
        } else {
            cell.cardView.backgroundColor = .white
            cell.label.textColor = .black
        }
        return cell
    }
    
}

// MARK: Network
extension LocationDetailsViewController {
    private func getCurrentWeather() {
        self.showProgress(onView: self.containerView)
        getWeather { (data, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("an error occured")
                    print(error)
                    let myError = error as NSError
                    if myError.domain == NSURLErrorDomain, myError.code == NSURLErrorNotConnectedToInternet {
                        self.showNetworkError {
                            self.getCurrentWeather()
                        }
                    } else {
                        self.showAlert("An Error occured")
                    }
                    return
                }
                
                if let data = data {
                    self.setupTodaysData(data)
                } else {
                    self.showAlert("An Error occured")
                }
            }
            self.getData()
        }
    }
    
    private func getData() {
        getForecasts { (data, error) in
            DispatchQueue.main.async {
                self.hideProgress()
                if let error = error {
                    print("an error occured")
                    print(error)
                    let myError = error as NSError
                    if myError.domain == NSURLErrorDomain, myError.code == NSURLErrorNotConnectedToInternet {
                        self.showNetworkError {
                            self.getCurrentWeather()
                        }
                    } else {
                        self.showAlert("An Error occured")
                    }
                    return
                }
                
                if let data = data {
                    self.setupForecastData(data.list)
                } else {
                    self.showAlert("An Error occured")
                }
            }
        }
    }
    
    func getForecasts(completionHandler: @escaping (Response?, Error?) -> Void) {
        let lat = item.value(forKey: "lat") as! Double
        let lng = item.value(forKey: "lng") as! Double
        let url = URL(string: "\(BASE_URL)forecast?lat=\(lat)&lon=\(lng)&units=\(Configuration.getUnits())&appid=\(API_KEY)")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let data = data,
                let response = try? JSONDecoder().decode(Response.self, from: data) {
                completionHandler(response , error)
            } else {
                completionHandler(nil, error)
            }
        })
        task.resume()
    }
    
    func getWeather(completionHandler: @escaping (TodayWeatherResponse?, Error?) -> Void) {
        let lat = item.value(forKey: "lat") as! Double
        let lng = item.value(forKey: "lng") as! Double
        let url = URL(string: "\(BASE_URL)weather?lat=\(lat)&lon=\(lng)&units=\(Configuration.getUnits())&appid=\(API_KEY)")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let data = data,
                let response = try? JSONDecoder().decode(TodayWeatherResponse.self, from: data) {
                completionHandler(response , error)
            } else {
                completionHandler(nil, error)
            }
        })
        task.resume()
    }
}

extension LocationDetailsViewController {
    private func setupDates() {
        days.removeAll()
        let calendar = Calendar.current
        let now = Date.currentDate()
        for i in 0..<5 {
            days.append(calendar.date(byAdding: .day, value: i, to: now)!)
        }
        collectionView.reloadData()
    }
    
    private func setupTodaysData(_ data: TodayWeatherResponse) {
        let iconLink = String(format: ICON_URL, data.weather[0].icon)
        todayView.imgView.load(link: iconLink)
        todayView.lblDsc.text = data.weather[0].description
        
        let hum = "\(data.main.humidity)%"
        let humTxt = "Humidity: \(hum)"
        let humRange = humTxt.range(of: hum)!
        let humNsRange = NSRange(humRange, in: humTxt)
        let humAttrStr = NSMutableAttributedString(string: humTxt)
        humAttrStr.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray],
                                 range: humNsRange)
        todayView.lblHum.attributedText = humAttrStr
        
        var win: String {
            if Configuration.getUnits() == UNIT_IMPERIAL {
                return "\(data.wind.speed)m/h"
            } else {
                return "\(data.wind.speed)km/h"
            }
        }
        
        let winTxt = "Wind: \(win)"
        let winRange = winTxt.range(of: win)!
        let winNsRange = NSRange(winRange, in: winTxt)
        let winAttrStr = NSMutableAttributedString(string: winTxt)
        winAttrStr.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray],
                                 range: winNsRange)
        todayView.lblWind.attributedText = winAttrStr
        
        var tempUnit: String {
            if Configuration.getUnits() == UNIT_IMPERIAL || Configuration.getUnits() == UNIT_STANDARD {
                return "°F"
            } else {
                return "°C"
            }
        }
        
        var temp: String {
            if Configuration.getUnits() == UNIT_IMPERIAL || Configuration.getUnits() == UNIT_STANDARD {
                let temp: Int = Int(data.main.temp)
                return String(temp)
            } else {
                return "\(data.main.temp)"
            }
        }
        
        let tempTxt = "\(temp)\(tempUnit)"
        let tempRange = tempTxt.range(of: tempUnit)!
        let tempNsRange = NSRange(tempRange, in: tempTxt)
        let tempAttrStr = NSMutableAttributedString(string: tempTxt)
        let fnt = UIFont(name: "Futura", size: 17.0)
        tempAttrStr.setAttributes([NSAttributedString.Key.font : fnt!, NSAttributedString.Key.baselineOffset: 10],
                                  range: tempNsRange)
        todayView.lblTemp.attributedText = tempAttrStr
    }
    
    private func setupForecastData(_ data: [WeatherItem]) {
        items.removeAll()
        days.forEach { (date) in
            let filtered = data.filter { (ele) -> Bool in
                let dateFmt = DateFormatter()
                dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let myDate = dateFmt.date(from: ele.dt_txt)!
                let day = Calendar.current.dateComponents([.day], from: date).day!
                let myDay = Calendar.current.dateComponents([.day], from: myDate).day!
                if day == myDay {
                    return true
                }
                
                return false
            }
            
            let sorted = filtered.sorted { (item0, item1) -> Bool in
                let dateFmt = DateFormatter()
                dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                return dateFmt.date(from: item0.dt_txt)! < dateFmt.date(from: item1.dt_txt)!
            }
            items.append(sorted)
            
        }
        
        currentItems = items[0]
        tableView.reloadData()
        
        
    }
}
