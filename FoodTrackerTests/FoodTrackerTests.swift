import XCTest;
@testable import FoodTracker;

class FoodTrackerTests: XCTestCase {
	// MARK: FoodTracker Tests
    func testMealInitialization() {
        // success case
        let potentialItem = Meal(name: "Newest meal", photo: nil, rating: 5);
        XCTAssertNotNil(potentialItem);
        
        // failure case
        let noName = Meal(name: "", photo: nil, rating: 0);
        XCTAssertNil(noName, "Empty name is invalid");
        
        let badRating = Meal(name: "Really bad rating", photo: nil, rating: -1);
        XCTAssertNil(badRating, "Negative ratings are invalid, be positive");
    }
}