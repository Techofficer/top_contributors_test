import XCTest
@testable import Top_Githubers

class Top_GithubersTests: XCTestCase {

    var contributorsTestTVC: ContributorsTableViewController?
    var contributorVC : ContributorViewController?
    
    override func setUp() {
        super.setUp()
        
        contributorsTestTVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContributorsTVC") as? ContributorsTableViewController
        
        contributorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContributorVC") as? ContributorViewController
    }

    override func tearDown() {
        contributorsTestTVC = nil
        contributorVC = nil
        super.tearDown()
    }

    func testContributorsTablePopulation(){
        XCTAssertEqual(contributorsTestTVC?.contributors.count, 0, "Contributors table should be empty before the API call")
        
        contributorsTestTVC?.retrieveContributors { () in
            XCTAssertGreaterThan(self.contributorsTestTVC!.contributors.count, 0, "Table is not populated after API call")
        }
    }
    
    func testCallToGithubContributorsApi() {
        let promise = expectation(description: "List of contibutors returned")
        
        GithubApi.getContributors { error, result in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            
            guard (result as? [[String:Any]]) != nil else {
                XCTFail("Error: empty response")
                return
            }
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFindingContributorsValidLocation(){
        let data : [String : Any?] = ["location" : "Cambridge" ]
        
        let promise = expectation(description: "Contributor's location has been found")
        
        contributorVC?.getContributorLocation(data: data as AnyObject){ error, location in
            if let error = error {
                XCTFail("Error: \(error)")
                return
            }
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFindingContributorsInvalidLocation(){
        let data : [String : Any?] = ["location" : "asd9021ud90jfiasf102uf1i2f120f0" ]
        let promise = expectation(description: "Invalid location hasn't been found")
        
        contributorVC?.getContributorLocation(data: data as AnyObject){ error, location in
            if error != nil {
                promise.fulfill()
                return
            }
            
            XCTFail("Invalid location has been found")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    

}
