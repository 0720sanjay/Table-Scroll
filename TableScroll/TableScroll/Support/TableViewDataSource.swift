import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return ("Section \(section)")
//    }
    
}
