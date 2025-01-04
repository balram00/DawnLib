import Foundation



class JSONHelper {
    
    static func fetchJSONResponse() async throws -> [Response] {
        // Fetch the URL of the JSON file from the app's bundle
        guard let url = Bundle.main.url(forResource: "JsonData", withExtension: "json") else {
            throw NSError(domain: "FileNotFound", code: 1002, userInfo: [NSLocalizedDescriptionKey: "JSON file not found in the bundle."])
        }
        
        // Step 2: Read the data from the file
        do {
            let jsonData = try Data(contentsOf: url)
            
            // Step 3: Create a JSONDecoder and decode the data
            let decoder = JSONDecoder()
            
            // Decode the JSON data
            let decodedData = try decoder.decode([Response].self, from: jsonData)
            
            return decodedData
        } catch {
            print("Error reading or decoding JSON: \(error)")
            throw error
        }
    }
}
