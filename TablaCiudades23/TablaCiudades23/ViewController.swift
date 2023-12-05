//
//  ViewController.swift
//  TablaCiudades23
//
//  Created by dam2 on 5/12/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    let cityList = ["Linares", "Granada", "Málaga", "Madrid", "Barcelona"]
    
    var filteredCities = [String]()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar ciudad"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredCities.count
        } else {
            return cityList.count
        }
    }
    
   
    func filterContentForSearchText(_ searchText: String){
        filteredCities.removeAll()
        filteredCities = cityList.filter { (city: String) -> Bool in
            if city.lowercased().localizedCaseInsensitiveContains(self.searchController.searchBar.text!){
                return true
            } else {
                return false
            }
        }
        tabla.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda_ciudad", for: indexPath) as! MiCelda
        
        if isFiltering{
            celda.imagen.image = UIImage(named: filteredCities[indexPath.row])
            celda.nombre.text = filteredCities[indexPath.row]
        } else {
            celda.imagen.image = UIImage(named: cityList[indexPath.row])
            celda.nombre.text = cityList[indexPath.row]
        }
        return celda
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if isFiltering{
            //print(filteredCities[indexPath.row])
        //} else 
        //{
            //print(cityList[indexPath.row])
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SegundoViewController") as! SegundoViewController
            
            vc.cityname = isFiltering ? filteredCities[indexPath.row] : cityList[indexPath.row]
            self.navigationController?.show(vc, sender: nil)
        }
    }


extension ViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
