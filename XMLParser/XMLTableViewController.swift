//
//  XMLTableViewController.swift
//  XMLParser
//
//  Created by Orlando Amorim on 10/09/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit

class XMLTableViewController: UITableViewController {

    
    var pizzas: [Pizza] = []
    var currentElement = String()
    var pizzaName = String()
    var pizzaCost = String()
    var pizzaDescription = String()
    var parser = XMLParser()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "XML Parser"
        if let url = URL(string: "http://api.androidhive.info/pizza/?format=xml") {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                parser.parse()
            }
        }
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let pizza = pizzas[indexPath.row]
        cell.textLabel?.text = pizza.name
        cell.detailTextLabel?.text = "R$ \(pizza.cost!) • \(pizza.description!)"
        
        return cell
    }
 
}

extension XMLTableViewController: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = elementName
        if elementName == "item"{
            pizzaName = ""
            pizzaCost = ""
            pizzaDescription = ""
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = ""
        if elementName == "item"{
            let pizza = Pizza()
            pizza.name = pizzaName
            pizza.cost = pizzaCost
            pizza.description = pizzaDescription
            pizzas.append(pizza)
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty) {
            if currentElement == "name" {
                pizzaName += data
            } else if currentElement == "cost" {
                pizzaCost += data
            } else if currentElement == "description" {
                pizzaDescription += data
            }
        }
    }

}
