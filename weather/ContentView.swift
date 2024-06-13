import SwiftUI

struct ContentView: View {
    @State private var city: String = ""
    @State private var temperature: String = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            TextField("Enter city name", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: fetchWeather) {
                Text("Get Temperature")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text(temperature)
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showingError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func fetchWeather() {
        let weatherService = WeatherService()
        weatherService.fetchWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    temperature = "\(weatherResponse.current.temp_c) °C in \(weatherResponse.location.name)"
                case .failure(let error):
                    showingError = true
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
