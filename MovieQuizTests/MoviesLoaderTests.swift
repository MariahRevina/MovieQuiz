import XCTest

@testable import MovieQuiz

 class MoviesLoaderTests: XCTestCase {
    
    
    
    func testFailureLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient (emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        
        // When
        loader.loadMovies {result in
            // Then
            switch result {
            case.success:
                XCTFail("Мы  ждали ошибку, но она  не пришла")
                
            case.failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()

            }
        }
        waitForExpectations(timeout: 1)
        
    }
     
     func testSuccessLoading() throws {
         
         // Given
         let stubNetworkClient = StubNetworkClient (emulateError: false)
         let loader = MoviesLoader(networkClient: stubNetworkClient)
         let expectation = expectation(description: "Loading expectation")
         
         // When
         loader.loadMovies {result in
             
             //Then
             switch result {
             case.success(let movies):
                 XCTAssertEqual(movies.items.count, 2)
                 expectation.fulfill()
                 
             case.failure(_):
                 XCTFail("Unexpected failure")
             }
         }
         waitForExpectations(timeout: 1)
     }
}
